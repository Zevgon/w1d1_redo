require 'set'

class Node
	attr_reader :pos, :val, :parent
	def initialize(pos, val, parent = nil)
		@val = val
		@pos = pos
		@parent = parent
	end
end

def adjacent_squares(grid, pos)
	result = []
	i, j = pos
	all_adjacents = [[i - 1, j], [i, j + 1], [i + 1, j], [i, j - 1]]
	all_adjacents.each do |adj|
		result << adj if grid[adj[0]] && grid[adj[0]][adj[1]] && adj.none?{|num| num < 0}
	end

	result
end

def possible_moves(grid, pos)
	adjes = adjacent_squares(grid, pos)
	adjes.select do |pos|
		grid[pos[0]][pos[1]] == ' ' || grid[pos[0]][pos[1]] == 'E'
	end
end

def show_grid(grid)
	grid.each do |line|
		puts line.join("")
	end
end

def starting_position(grid)
	idx = 0
	while idx < grid.length
		idx2 = 0
		while idx2 < grid[idx].length
			return [idx, idx2] if grid[idx][idx2] == 'S'
			idx2 += 1
		end
		idx += 1
	end

	nil
end

def ending_position(grid)
	idx = 0
	while idx < grid.length
		idx2 = 0
		while idx2 < grid[idx].length
			return [idx, idx2] if grid[idx][idx2] == 'E'
			idx2 += 1
		end
		idx += 1
	end

	nil
end

def trace(grid, target)
	node = target
	until node.val == 'S'
		grid[node.pos[0]][node.pos[1]] = "X" unless grid[node.pos[0]][node.pos[1]] == "E"
		node = node.parent
	end
	show_grid(grid)
end

def bfs(grid)
	visited = Set.new
	node = Node.new(starting_position(grid), 'S')
	q = [node]
	visited << node.pos
	target = nil
	found = false
	until q.empty?
		moves = possible_moves(grid, q[0].pos)
		moves.each do |pos|
			new_node = Node.new(pos, grid[pos[0]][pos[1]], q[0])
			q << new_node unless visited.include?(pos)
			return trace(grid, new_node) if new_node.val == 'E'
			visited << pos
		end
		q.shift
	end

	"Not hapnin' bro"
end

maze = ARGV[0]

grid = []
File.readlines(maze).each do |line|
	grid << line.chomp
end

grid.map!{|row| row.split("")}
bfs(grid)
