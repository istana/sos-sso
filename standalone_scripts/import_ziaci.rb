#!/usr/bin/env ruby

ziaci = File.read("ziaci.csv")

ziaci.each_line do |z|
  priezv, meno, trieda = z.strip.split(";")

	g = Group.find_or_create_by!(name: trieda)
	u = User.create!(fullname: "#{meno} #{priezv}",
									generate_password: true,
									primary_group: g)
	u.groups << g
	puts u.inspect
end


