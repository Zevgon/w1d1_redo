class Player
	attr_reader :name
	attr_accessor :letters

	def initialize(name)
		@letters = ''
		@name = name
	end

	def guess(fragment)
		debugger;
		p 'HERE!'
		puts "#{@name}'s turn. Please make a guess:\n>> "
		gets.chomp
	end

	def alert_invalid_move
		puts "#{@name}, you enetered an invalid guess."
		guess
	end
end

class AiPlayer < Player
	attr_accessor :fragment

	def initialize(name, dictionary, num_players)
		@dictionary = dictionary
		@num_players = num_players
		super(name)
	end

	def guess(fragment)
		@dictionary = @dictionary.select{|word| word.start_with?(fragment)}
		chosen_letter = nil
		found = false
		possible_letters = []
		('a'..'z').each do |letter|
			new_fragment = fragment + letter
			selections = @dictionary.select{|word| word.start_with?(new_fragment)}
			next if selections.empty?
			if selections.all?{|word| (word.length - new_fragment.length) % @num_players != 0}
				chosen_letter = letter
				found = true
			elsif @dictionary.any?{|word| word.start_with?(new_fragment)}
				possible_letters << letter
			end

			break if found
		end

		return chosen_letter if chosen_letter
		possible_letters[rand(possible_letters.length)]
	end

	def alert_invalid_move
		puts 'computer messed up hahahah'
	end
end
