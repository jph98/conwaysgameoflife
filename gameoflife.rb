#!/usr/bin/env ruby

require "colorize"

require_relative "generators"
require_relative "cell"

# See - http://jonathan-jackson.net/life-in-a-shade-of-ruby

class GameOfLife

	attr_accessor :board

	DEBUG = false

	def initialize(user_width, user_height)

		@max_width_x = user_width - 1
		@max_height_y = user_height - 1

		create_board()
	end

	# Create the board
	def create_board()

		# Create a board 
		@rows = Array.new(@max_height_y)
		(0..@max_height_y).each do |y|

			@rows[y] = Array.new(@max_width_x)

			(0..@max_width_x).each do |x|

				cells = @rows[y]
				cells[x] = Cell.new(x, y, Cell::DEAD)
			end
		end
	end

	# Display the board
	def display()

		text = ""
		@rows.each do |y|
			text += "Row: "
			y.each do |c|
				if DEBUG
					text += " [#{c.x + 1},#{c.y + 1} #{c.status_color}]"
				else
					text += " #{c.status_color} "
				end
			end
			text += "\n"
		end
		return "#{text}\n" 
	end

	# Generate the new population
	def generate()

		updates = []
		@rows.each do |y|
			y.each do |c|
				updates << determine_future(c)
				puts "added: #{c.x} #{c.y} #{c.status}" if DEBUG
			end
		end

		# Perform updates
		updates.each do |update|
			puts "updating: #{update.x} #{update.y} #{update.status}" if DEBUG
			@rows[update.y][update.x] = Cell.new(update.x, update.y, update.status)
		end
	end

	# Get the number of neighbours given the coords
	def get_num_neighbours_by_coords(cx, cy, check_status)
		return get_num_neighbours(cx - 1, cy - 1, check_status)
	end

	# Get the number of neighbours given the array positions
	def get_num_neighbours(cx, cy, check_status)

		count = 0
		puts "Considering neighbours for: #{cx + 1}, #{cy + 1}" if DEBUG
		up = cy - 1
		left = cx - 1
		right = cx + 1

		# Upper Left
		if cy > 0 and cx > 0
			cell_status = @rows[up][left].status
			if cell_status.eql? check_status
				count += 1 
				puts "\tUpper left matched, count++ #{cell_status}" if DEBUG
			end
		end

		# Upper
		if cy > 0
			cell = @rows[up][cx]
			if cell.status.eql? check_status
				count += 1 
				puts "\tTop matched, count++ #{cell.status}" if DEBUG
			end
		end

		# Upper Right
		if cy > 0 and cx < @max_width_x
			cell_status = @rows[up][right].status
			if cell_status.eql? check_status
				count += 1 
				puts "\tUpper right matched, count++ #{cell_status}" if DEBUG
			end
		end

		# Left
		if cx > 0 
			cell_status = @rows[cy][left].status
			if cell_status.eql? check_status
				count += 1 
				puts "\tLeft matched, count++ #{cell_status}" if DEBUG
			end
		end

		# Right
		if cx < @max_width_x
		cell_status = @rows[cy][right].status 
			if cell_status.eql? check_status
				count += 1
				puts "\tRight matched, count++ #{cell_status}" if DEBUG
			end
		end

		down = cy + 1

		# Lower Left
		if cx > 0 and cy < @max_height_y 
			cell_status = @rows[down][left].status
			if cell_status.eql? check_status
				count += 1
				puts "\tLower left matched, count++ #{cell_status}" if DEBUG
			end
		end

		# Lower Right
		if cx < @max_width_x and cy < @max_height_y
			cell_status = @rows[down][right].status
			if cell_status.eql? check_status
				count += 1 
				puts "\tLower right matched, count++ #{cell_status}" if DEBUG
			end
		end

		# Lower
		if cy < @max_height_y
			cell_status = @rows[down][cx].status
			if cell_status.eql? check_status
				count += 1 
				puts "\tBottom matched, count++ #{cell_status}" if DEBUG
			end
		end

		return count
	end

	# Any live cell with < 2 live neighbours dies, as if by needs caused by underpopulation.
	# Any live cell with > 3 live neighbours dies, as if by overcrowding.
	# Any live cell with 2 or 3 live neighbours lives to the next generation.
	# Any dead cell with 3 live neighbours becomes a live cell.
	def determine_future(cell)
	
		puts "\nDetermine future of cell: [#{cell.x + 1},#{cell.y + 1}] status: #{cell.status}" if DEBUG
		status = cell.status
		neighbours = get_num_neighbours(cell.x, cell.y, Cell::ALIVE)

		if neighbours < 2

			# Underpopulation, isolation
			puts "Cell status #{cell.status} - underpopulation" if DEBUG
			return Cell.new(cell.x, cell.y, Cell::DEAD)

		elsif neighbours > 3

			# Overpopulation
			puts "Cell status #{cell.status} - overpopulation" if DEBUG
			return Cell.new(cell.x, cell.y, Cell::DEAD)
			

		elsif neighbours.eql? 3 and status.eql? Cell::DEAD

			# Reproduction
			puts "Cell status #{cell.status} - reproduction" if DEBUG
			return Cell.new(cell.x, cell.y, Cell::ALIVE)

		elsif neighbours.eql? 2 or neighbours.eql? 3

			# Do nothing, we live on
			puts "Cell status #{cell.status} - unchanged, lives on" if DEBUG
		end

		sleep 3 if DEBUG

		return Cell.new(cell.x, cell.y, cell.status)
	end

	# Place num random cells
	def place_random_cells(num)

		(1..num).each do |n|
			cx = rand(1..@max_width_x).round()
			cy = rand(1..@max_height_y).round()
			puts "Generated #{cx} and #{cy}" if DEBUG
			update_cell_status_at_coords(cx, cy, Cell::ALIVE)
		end
	end

	# Place a Cell::ALIVE at array coords 
	def place_coords(x, y)

		update_cell_status_at_coords(x, y, Cell::ALIVE)
	end

	# Change status of cell at array position (x,y)
	def update_cell_status_at_coords(x, y, status)

		cell = @rows[y - 1][x - 1]
		cell.status = status
		return cell
	end

	# Get cell given coords converted into array position (x,y)
	def get_cell_at_coords(x, y)
		return @rows[y - 1][x - 1]
	end
	
end

if __FILE__ == $0

	game = GameOfLife.new(5, 5)

	gen = Generators.new()

	#gen.populate_oscillator_one(game)
	#gen.populate_still_life_one(game)
	gen.populate_spaceship_one(game)

	puts "\nCreated initial population...\n\n"

	puts game.display()
	sleep 4

	index = 1
	loop do 

		puts "Generation #{index}\n\n"
		game.generate()
		puts game.display()
		sleep 4
		index += 1	
	end
end