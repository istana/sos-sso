require 'fileutils'

# checks integrity of files, permissions
module SystemTasks

	module Users
		# may also return file
		def self.redundant_homedirs(homedirs = nil)
			homedirs ||= File.join('/', 'network', 'home')

			Dir[File.join(homedirs, '*')].reduce([]) do |result, d|
				user = (::User.find_by(homedir: File.expand_path(d)) rescue nil)
				result << d if !user
				result
			end
		end

		def self.missing_homedirs
			::User.all.reduce([]) do |result, u|
				if !File.exists?(u.homedir)
					result << [u.username, 'noexist']
				elsif	!File.directory?(u.homedir)
					result << [u.username, 'file']
				end
				result
			end
		end

		# TODO better check
		def self.homedirs_check_permissions
			::User.all.reduce({}) do |result, u|
				if File.exists?(u.homedir)
					stat = File.stat(u.homedir)
					if (stat.uid != u.id)
						result[u.username] ||= []
						result[u.username] << "wrong uid"
					end

					if stat.gid != u.primary_group.id
						result[u.username] ||= []
						result[u.username] << "wrong gid"
					end

					if stat.world_readable?
						result[u.username] ||= []
						result[u.username] << "directory is world readable"
					end

					if stat.world_writable?
						result[u.username] ||= []
						result[u.username] << "directory is world writable!"
					end
				end
				result
			end
		end

		# use pdbedit -L to list users (as root)
		def self.redundant_missing_samba_users
			samba_users = Cocaine::CommandLine.new("sudo sosssoroot", "--sambalist").run
			samba_users = samba_users.split("\n").select{|i| !i.blank?}.map{|l| l.split(":").first}
			users = ::User.all.map(&:username)

			redundant = samba_users - users
			missing = users - samba_users
			return [redundant, missing]
		end

		def self.weak_hash_function_in_password
			::User.all.reduce([]) do |weak, u|
				# detect non SHA512 passwords in CRYPT format
				# TODO handle bcrypt (2a)? as secure (but is not used much in Linux world)
				# x is for dummy password
				if u.password != 'x' && u.password !~ /\A.*\$(6|2a)\$.+\z/
					weak << u.username
				end
				weak
			end
		end

	end
end	
