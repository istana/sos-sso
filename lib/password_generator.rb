module PasswordGenerator

	# inspired by pwgen a bit
	def self.chars
		{
			"a" => :wovel,
			"b" => :consonant,
			"c" => :consonant,
			"d" => :consonant,
			"e" => :wovel,
			"f" => :consonant,
			"g" => :consonant,
			"h" => :consonant,
			"i" => :wovel,
			"j" => :consonant,
			"k" => :consonant,
			"l" => :consonant,
			"m" => :consonant,
			"n" => :consonant,
			"o" => :wovel,
			"p" => :consonant,
			"q" => :consonant,
			"r" => :consonant,
			"s" => :consonant,
			"t" => :consonant,
			"u" => :wovel,
			"v" => :consonant,
			"w" => :consonant,
			"x" => :consonant,
			"y" => :wovel,
			"z" => :consonant,

			"0" => :number,
			"1" => :number,
			"2" => :number,
			"3" => :number,
			"4" => :number,
			"5" => :number,
			"6" => :number,
			"7" => :number,
			"8" => :number,
			"9" => :number,

			"?" => :specials,
			"," => :specials,
			":" => :specials,
			"." => :specials,
			"_" => :specials,
			"-" => :specials,
			"!" => :specials,
			"/" => :specials,
		 	"(" => :specials,
			")" => :specials,
			"*" => :specials,
			"+" => :specials 
		}
	end

	# generates password
	# based on trigrams
	def self.rememberable(length = 8)
		length = 8 if length < 1

		i = 0
		result = ""

		segment_start = true
		segment = 0
		segment_position = 0
		previous = :any

		while i < length

=begin
			# after one segment insert special chars with certain probability
			if segment_start && segment != 0
				if rand(2) == 1
					result << get_special
					previous == :special
					# start segment, but do not move position
					segment_start = false
					i += 1
					next
				end
			end
=end

			if previous == :wovel
				result << (rand(100) < 70 ? get_consonant : get_wovel)
			elsif previous == :consonant
				result << get_wovel
			else
				result << (rand(100) < 70 ? get_consonant : get_wovel)
			end

			segment_position += 1
			segment_start = false
			previous = chars[result[result.length-1]]

			# possible special character + trigram
			# start new segment
			if segment_position % 3 == 0
				segment_start = true
				segment += 1
				segment_position = 0
			end

			i += 1
		end

		return result
	end

	# TODO potentially infinite loop
	def self.get_char(klass)
		begin
			char, chklass = chars.to_a.sample
		end while(klass != chklass)

		return char
	end

	def self.get_wovel
		get_char(:wovel)
	end

	def self.get_consonant
		get_char(:consonant)
	end

	def self.get_special
		get_char(:specials)
	end
end	

