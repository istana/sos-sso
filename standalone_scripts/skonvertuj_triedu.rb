#!/usr/bin/env ruby

#puts ARGF.read.inspect
#exit

#ziaci = File.read(ARGF.read.strip)
ziaci = ARGF.read

year = Time.now.year
res = ""

ziaci.each_line do |z|
  segs = z.split(";")

  segs[2].gsub!(/\A(I\.)/, "#{year}.")
  segs[2].gsub!(/\A(II\.)/, "#{year-1}.")
  segs[2].gsub!(/\A(III\.)/, "#{year-2}.")
  segs[2].gsub!(/\A(IV\.)/, "#{year-3}.")
  segs[2].gsub!(/\A(V\.)/, "#{year-4}.")

  res << segs.join(";")
end

File.write("ziaci.csv", res)
