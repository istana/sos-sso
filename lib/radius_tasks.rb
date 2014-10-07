module RadiusTasks
	def self.create_crypt_radius_user(user)
		Radcheck.create!(username: user.username,
										 attr: 'Crypt-Password',
										 op: ':=',
										 # remove {CRYPT} or {SHA512-CRYPT} from password
										 value: user.password.gsub(/{.+}/, ''))
	end

  def self.create_ntlm_radius_user(user)
    Radcheck.create!(username: user.username,
                    attr: 'NT-Password',
                    op: ':=',
                    value: user.ntlm_password)
  end

	def self.synchronize_accounts
		Radcheck.destroy_all
		# TODO check for GID?
		User.joins(:groups).where(active: true, groups: {name: 'wifi'}).each do |u|
			create_crypt_radius_user(u)
      create_ntlm_radius_user(u)
		end
	end

	def self.synchronize_account(user)
		if user && user.active && user.groups.map(&:name).include?('wifi')
			Radcheck.where(username: user.username).destroy_all
			create_crypt_radius_user(user)
      create_ntlm_radius_user(user)
		end
	end
end 
