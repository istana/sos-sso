# Converts Aliases, Groups and People
require 'base64'
require 'active_support/core_ext/object/blank.rb'
require 'json'

class FromLdapConvertor

	def initialize(file)
		if !File.exists?(file)
			raise("File #{file} does not exist")
		else
			@ldiff = File.read(file)
		end
		@file = file
		@out = file + "_converted.json"
		@objects = []
		@messages = []
		convert
		"ok"
	end

	def kind(object)
		if !object["dn"].blank?
			segs = object["dn"].split(",").map{|it| it.split("=")}
			x = segs.select{|i| i.first == "ou"}.first
			x = x[1] if x
			#			puts x
			#			sleep 0.5
			return x
		else
			#			puts 'xxxx'
			return false
		end
	end

	def populate_groups
		@objects.each do |ob|
			# check for cn, because may be command to create Group itself
			if kind(ob) == "Group" && ob["cn"]
				group = Group.create!(name: ob["cn"], password: ob["userPassword"], id: ob["gidNumber"])
				puts "Group created: #{ob['cn']}"

				if ob["memberUid"]
					*values = ob["memberUid"]
					values.each do |mem|
						user = User.find_by(username: mem)

						if user
							user.groups << group
						end
					end
				end
			end
		end
		"ok"
	end

	def populate_primary_groups
		User.all.each do |u|
			group = (Group.find(u.gid) rescue nil)

			if group && !u.groups.map(&:id).include?(u.gid)
				u.groups << group
				puts "#{u.username} - #{group.name}"
			else
				puts "#{u.username} - gid exist"
			end
		end
	end


	def populate_aliases
		@objects.each do |ob|
			if kind(ob) == "Aliases"
				*forward = ob["rfc822MailMember"]
				forward.each do |usern|
					user = User.find_by(username: usern)
					if user
						user.aliases.create!(name: ob["cn"])
					else
						puts "User #{usern} for alias #{ob['cn']} not found"
					end
				end
			end
			# NOTE there may be other direction of alias, I don't really know
		end
	end

	def populate_users
		@objects.each do |ob|
			if kind(ob) == "People" && ob["cn"]
				# in case you deleted password, so user couldn't login (probably)
				ob["userPassword"] = "{CRYPT}x" if !ob["userPassword"]

				# translators
				translator = {
					"username" => "uid",
					"id" => "uidNumber",
					"gid" => "gidNumber",
					"password" => "userPassword",
					"gecos" => "gecos",
					"homedir" => "homeDirectory",
					"shell" => "loginShell",
					"lstchg" => "shadowLastChange",
					"max" => "shadowMax",
					"warn" => "shadowWarning"
				}

				# remove nil keys, so they don't interfere and default values may be used (or error raised)
				translator.each_pair{|our, ldiff| ob.delete(ldiff) if ob[ldiff].nil?}

				# rename keys in ob to match our model
				translator.each_pair do |our, ldiff|
					if ob.has_key?(ldiff)
						tmp = ob[ldiff]
						ob.delete(ldiff)
						ob[our] = tmp
					end
				end

				# remove other fields like dn and objectClass
				ob.each_pair do |k, v|
					if !translator.keys.include?(k)
						ob.delete(k)
					end
				end

				u = User.create!(ob)
				puts "User created: " + u.username
			end
		end
	end


	def convert
		object = {}
		i = 0
		@ldiff.each_line do |l|
			# ignore comments
			next if !l || l.blank? || (l =~ /\A\s*#/)

				# every object starts with dn
				if(l =~ /\Adn:/)
					@objects << object
					object = {}
				end

			# some fields has more colons like "userPassword"
			key, value = l.split(":").select{|seg| !seg.blank?}.map(&:strip)

			# userPassword is base64 encoded
			if key == "userPassword"
				value = Base64.decode64(value)

				# print warning if password is hashed in MD5 (too weak hash function nowadays)
				if value =~ /\A\{crypt\}\$[^6]\$/
					@messages << "password #{value} is using MD5 or SHA1! (account #{object.has_key?("uid") ? object["uid"] : 'unknown'})"
				end
			end

			# create array if key has more values
			if object[key].is_a? Array
				object[key] << value
			elsif !object[key].blank?
				object[key] = [object[key], value]
			else
				object[key] = value
			end

			#			return if i > 500
			i = i+1
		end

		"ok"
	end

	def dump
		File.write(@out, JSON.pretty_generate(@objects))
		File.write(@out+"_messages.json", JSON.pretty_generate(@messages))
	end

end
