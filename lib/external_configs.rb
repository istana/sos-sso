require 'active_support/core_ext/object/blank'

class ExternalConfigs
	# primitive (and "lossy") parser to read config files
	# the purpose is to test SQL commands, not that config is correct
	# second argument is, whether key = value or key   value
	# third argument:
	# key = value \
	#   valuenext
	# or
	# key = value
	#   valuenext
	def self.read(file, key_delimiter = "=", endline_backspaced = true)
		lines = File.read(file).gsub(/#.*$/, '').split("\n").select do |i|
			!i.blank?
		end

		# join lines, which continue
		i = 0
		while(i < lines.length) do
			while (endline_backspaced == true && lines[i] =~ /\\\s*\z/) ||
					(endline_backspaced == false && i <= lines.count && lines[i+1] =~ /\A\s+/)
				# remove \ on the end
				lines[i].gsub!(/\\\s*\z/, ' ') if endline_backspaced
				lines[i] << lines[i+1]
				lines.delete_at(i+1)
				# change of indexes i, i+2 (now i+1), i+3, ...
			end
			lines[i].gsub!(/\s+/, ' ')
			i += 1
		end
		# extract keys and values, ignore not valid lines
		x = lines.reduce({}) do |result, l|
			key, *value = l.split(key_delimiter).select{|s| !s.blank?}
			# nss uses space as delimiter, join other segments
			value = value.join(key_delimiter)

			if !key.blank? && !value.blank?
				key.strip!
				value.strip!
				result[key] = value
			end

			result
		end
		x
	end

	def self.read_libnss(file)
		self.read(file, " ", true)
	end

	def self.read_postfix(file)
		self.read(file, "=", false)
	end
end

