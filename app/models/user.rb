# == Schema Information
#
# Table name: users
#
#  id            :bigint(8)        not null, primary key
#  username      :string(255)      not null
#  gid           :bigint(8)        not null
#  gecos         :string(255)      default(""), not null
#  homedir       :string(255)      not null
#  shell         :string(255)      default("/usr/bin/rssh"), not null
#  password      :string(255)      default("x"), not null
#  lstchg        :bigint(8)        default(1), not null
#  min           :bigint(8)        default(0), not null
#  max           :bigint(8)        default(9999), not null
#  warn          :bigint(8)        default(30), not null
#  inact         :bigint(8)        default(0), not null
#  expire        :bigint(8)        default(-1), not null
#  flag          :integer          default(0), not null
#  quota_mass    :bigint(8)        default(52428800), not null
#  quota_inodes  :bigint(8)        default(15000), not null
#  active        :boolean          default(TRUE), not null
#  created_at    :datetime
#  updated_at    :datetime
#  ntlm_password :string(255)
#

require 'digest'
require 'securerandom'
require 'smbhash'
require 'terrapin'
require 'open3'
#require 'string/crypt'

class User < ApplicationRecord
	has_many :groups_users, class_name: 'GroupsUsers'
	has_many :groups, :through => :groups_users, :inverse_of => :users
	has_many :aliases, :inverse_of => :user, :dependent => :destroy
	has_many :radius_users, :inverse_of => :user, :class_name => 'Radcheck',
		:dependent => :destroy, :foreign_key => :username, :primary_key => :username
	has_many :radius_auths, :inverse_of => :user, :class_name => 'Radpostauth',
		:dependent => :destroy, :foreign_key => :username, :primary_key => :username

	belongs_to :primary_group, foreign_key: 'gid', class_name: 'Group'
	validates :primary_group, :presence => true


	# DEFAULT VALUES

	after_initialize :default_values

	def default_values
		if !self.persisted?
			# 200MB
			self.quota_mass = 204800
			self.quota_inodes = 10000
			# max. life of password to 99999 days, cca 270 years
			self.max = 99999
		end
	end

	private :default_values

	# END DEFAULT VALUES

	# BEGIN USERNAME

	validates :username, :uniqueness => { :case_sensitive => true }, :presence => true, :format => /\A\w+[\w-]*\w+\z/
	before_validation :generate_save_username

	def generate_save_username
		tmpname = self.generate_username
		self.username = tmpname if tmpname
	end

	# generates username from GECOS full name if blank
	def generate_username
		management_groups = Rails.application.config.management_groups

		if self.username.blank? && !self.fullname.blank?
			segments = ActiveSupport::Inflector.transliterate(self.fullname).split(" ")
			surname = segments.last

			# John Doe -> doe
			if (self.groups.map(&:name) & management_groups).length > 0
				self.username = surname.downcase
			else
				# -> xdoej
				names = segments[0..-2]
				self.username = 'x' + surname.downcase + names.map{|n| n.first.downcase}.reverse.join("")
			end

			uniq_username(username)
		end
	end

	def uniq_username(username)
		existing = name = nil
		i = 1

		# username is already unique, do not append something
		existing = User.where(username: username)
		name = username if existing.count == 0

		while name.nil? && i <= 50
			existing = User.where(username: username)

			if existing.count == 0
				name = username
			else
				username = username.gsub(/\d/, '') + i.to_s
			end

			i += 1
		end

		# after 50 iterations append first segment of uuid
		if existing.count > 0
			name = username.gsub(/\d/, '')
			name << "-" + SecureRandom.uuid.split("-").first
		end

		return name
	end

	private :generate_save_username

	# END USERNAME

	# BEGIN GROUP

	after_save :sync_primary_group

	def sync_primary_group
		# primary group exists
		if primary_group
			if !groups.map(&:name).include?(primary_group.name)
				groups << primary_group
			end
		end
	end

	# END GROUP

	# BEGIN GECOS FIELDS

	def fullname; split_gecos(0); end
	def section; split_gecos(1); end
	def phone; split_gecos(2); end
	def email; split_gecos(3); end

	def fullname=(n); set_gecos_field(n, 0); end
	def section=(s); set_gecos_field(s, 1); end
	def phone=(p); set_gecos_field(p, 2); end
	def email=(e); set_gecos_field(e, 3); end

	def split_gecos(position)
		if gecos.blank?
			return nil
		elsif position == -1
			return gecos.split(",")
		else
			return gecos.split(",")[position]
		end
	end

	def set_gecos_field(f, position)
		gtmp = split_gecos(-1)
		(gtmp = [nil]*4) if !gtmp
		gtmp[position] = f.gsub(',', '+').strip.gsub(/\s\s+/, ' ')
		self.gecos = gtmp.join(",")
	end

	private :split_gecos, :set_gecos_field

	# END GECOS FIELDS

	# BEGIN PASSWORD

	# SHA512 password for Dovecot, Postfix and freeRADIUS (potentially also for PAM)
	validates :password, :presence => true

	# NTLM password for PEAP in freeRADIUS
	validates :ntlm_password, :presence => true

	# temporary attribute for Samba password (cannot set already hashed password from ntlm_password)
	validates :password_cleartext, length: { minimum: 8 }, allow_nil: true

	attr_reader :password_cleartext

	def password_cleartext=(pw)
		if pw && pw.length >= 8
			self.password = hash_password(crypt_salt, pw)
			self.ntlm_password = Smbhash.ntlm_hash(pw)
		end

		@password_cleartext = pw

		# set last change of password to now (timestamp)
		@lstchg = Time.now.to_i
	end

	# CRYPT compatible salt [a-zA-Z0-9./] 97-122, 65-90, 48-57, 46, 47
	def crypt_salt(length = 16)
		length = 5 if length < 1

		chars = [46, 47] + (97..122).to_a + (65..90).to_a + (48..57).to_a

		# sample is random, but only for one element at one time
		(1..length).reduce("") {|result, i| result += chars.sample.chr}
	end

	#	our system generates only SHA512 grade passwords
	def hash_password(salt, pw)
		pw.crypt('$6$' + salt)
		# doesn't match password generated by crypt
		# TODO rounds=5000 by default
		# Digest::SHA512.base64digest(salt.to_s + pw)
	end

	private :crypt_salt, :hash_password

	attr_accessor :generate_password
	validates :generate_password, allow_nil: true, inclusion: {in: ["0", "1", 0, 1, true, false]}
	before_validation :process_generate_password
	after_save :note_password, :generated_finished

	# checkbox true or true
	def process_generate_password
		if [1, "1", true].include?(self.generate_password)
			self.password_cleartext = PasswordGenerator.rememberable(9)
		end
	end

	# note password
	# we can then distribute them
	# TODO: show them in rails_admin via flash[:notice]
	def note_password
		if (!self.password_cleartext.blank?) && ([1, "1", true].include?(self.generate_password))
			us = ""
			us << "Fullname: #{self.fullname}\n"
			us << "User: #{self.username}\n"
			us << "Password: #{self.password_cleartext}\n"
			us << "Group: #{self.primary_group.name}\n"
			us << "Change: #{self.updated_at}\n\n"

			File.write(File.join(Rails.root, "exports", "generated_passwords.txt"), us, mode: "a")
		end
	end

	def generated_finished
		self.generate_password = false
		# TODO remove: don't return false in validation, otherwise it will fail
		return true
	end

	# END PASSWORD

	# BEGIN HOMEDIR

	before_validation :generate_save_homedir

	def generate_save_homedir
		if self.homedir.blank?
			self.homedir = File.join(Rails.application.config.homedirs, self.username)
		end
	end

	# END HOMEDIR

	# BEGIN freeRADIUS

	after_save :sync_radius

	def sync_radius
		RadiusTasks.synchronize_account(self)
	end

	# END freeRADIUS

	# BEGIN QUOTA

	after_commit :sync_quota,
		:if => Proc.new { Rails.application.config.quota == true },
		:on => [:create, :update]
	after_destroy :delete_quota,
		:if => Proc.new { Rails.application.config.quota == true }

	def sync_quota
		# set soft quota less than hard to people belonging to mail group
		# TODO: when user is added to mail group, is him updated also or only link table?
		Terrapin::CommandLine.new("sudo sosssoroot", "--set-user-quota :bs,:bh,:is,:ih --user :user", :expected_outcodes => [0, 1]).run(
			:user => self.username,
			:bs => self.groups.map(&:name).include?("mail") ? (self.quota_mass * 0.8).to_i.to_s : self.quota_mass.to_s,
			:bh => self.quota_mass.to_s,
			:is => self.groups.map(&:name).include?("mail") ? (self.quota_inodes * 0.8).to_i.to_s : self.quota_inodes.to_s,
			:ih => self.quota_inodes.to_s
		)
	end

	def delete_quota
		Terrapin::CommandLine.new("sudo sosssoroot", "--remove-quota --user :user", :expected_outcodes => [0, 1]).run(:user => self.username)
	end

	# END QUOTA

	# BEGIN Samba

	after_commit :sync_samba,
		:if => Proc.new { Rails.application.config.samba == true },
		:on => [:create, :update]
	after_destroy :delete_samba,
		:if => Proc.new { Rails.application.config.samba == true }

	def sync_samba
		if !self.password_cleartext.blank?
			c = Terrapin::CommandLine.new("sudo sosssoroot", "--sambaa --user :user").command(:user => self.username)

			Open3.popen3(c) do |stdin, stdout, stderr, t|
				stdin.puts "#{password_cleartext}\n#{password_cleartext}"
				stdin.close
				puts stdout.read
				puts stderr.read
				stdout.close
				stderr.close
				# exit status
				puts t.value
			end
		end
	end

	def delete_samba
		Terrapin::CommandLine.new("sudo sosssoroot", "--sambax --user :user", :expected_outcodes => [0, 1]).run(:user => self.username)
	end

	# END Samba

	# BEGIN homedir

	# home directory is only created at a creation of user
	# this _DOES NOT_ create self.homedir,
	# but uses combination of username and homedir base
	# if homedir is not in that format, it won't create homedir
	# TODO: username or primary group changed - needs to chown dir

	after_commit :create_homedir,
		:if => Proc.new { Rails.application.config.homedir == true },
		:on => [:create]
	after_destroy :archive_homedir,
		:if => Proc.new { Rails.application.config.homedir == true }

	def create_homedir
		Terrapin::CommandLine.new("sudo sosssoroot", "--create-home --user :user --group :group").run(
			:user => self.username,
			:group => self.primary_group.name
		)
	end

	def archive_homedir
		Terrapin::CommandLine.new("sudo sosssoroot", "--archive-home --user :user").run(
			:user => self.username
		)
	end

	# END homedir

	has_paper_trail

	rails_admin do
		object_label_method :username

		list do
			field :id
			field :username
			field :fullname
			field :primary_group
			field :active
			field :aliases
			field :groups

			#exclude_fields :id, :created_at, :lstchg, :min, :max, :warn, :inact,
			#	:expire, :flag, :quota_mass, :quota_inodes, :shell, :homedir

			# hmm, need to define all fields againi
		end

		edit do
			field :username
			field :primary_group
			field :generate_password, :boolean
			field :password_cleartext, :password
			field :fullname
			field :section
			field :phone
			field :email
			field :groups
			field :quota_mass
			field :active
		end

		edit do
			exclude_fields :password
		end

		field :groups do
			inverse_of :users
		end
	end
end
