require 'byebug'
require_relative './player.rb'
require 'set'

class Game
	attr_reader :fragment
	def initialize(players)
		@players = players
		@fragment = ''
		@dictionary = Set.new
		File.readlines('./dictionary.txt').each do |word|
			@dictionary << word.chomp
		end
		@ghost = 'GHOST'
	end

	def current_player
		@players.first
	end

	def previous_player
		@players.last
	end

	def next_player!
		@players.rotate!
	end

	def take_turn(player)
		letter = player.guess(@fragment)
		if valid_play?(letter)
			@fragment += letter
		else
			player.alert_invalid_move
		end
	end

	def valid_play?(str)
		return false unless str.length == 1 && str =~ /[a-z]/
		new_fragment = @fragment + str
		return false if @dictionary.none?{|word| word.start_with?(new_fragment)}
		true
	end

	def run
		until won?
			puts "Current fragment: #{@fragment}"
			take_turn(current_player)
			next_player!
		end
		previous_player.letters << @ghost[previous_player.letters.length]
		if previous_player.letters.length == 5
			puts "#{previous_player.name} is kicked out of the game. YIPPEEEEE!!!"
		else
			puts "#{previous_player.name} loses hahahahaha! You get a letter!"
		end
		puts
		@fragment = ''
	end

	def play_full_game
		until @players.length == 1
			display_standings
			run
			lost_player = @players.select{|player| player.letters == 'GHOST'}[0]
			@players.delete(lost_player) if lost_player
		end

		puts "#{@players[0].name} wins :("
	end

	def display_standings
		@players.each do |player|
			puts "#{player.name}: #{player.letters}"
		end
	end

	def won?
		@dictionary.include?(@fragment)
	end
end

dictionary = Set.new
File.readlines('./dictionary.txt').each do |word|
	dictionary << word.chomp
end

p1 = Player.new('Yale')
p2 = Player.new('Bob')
p3 = AiPlayer.new('Burfie', dictionary, 3)
g = Game.new([p1, p2, p3])
g.play_full_game
