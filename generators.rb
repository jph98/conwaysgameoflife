#!/usr/bin/env ruby

class Generators

	# Generate a still lifeform - http://www.conwaylife.com/wiki/Still_life
	def populate_still_life_one(game)
		game.place_coords(1, 1)
		game.place_coords(2, 1)
		game.place_coords(1, 2)
		game.place_coords(2, 2)
	end

	# Generate an oscillating lifeform - http://www.conwaylife.com/wiki/Oscillator
	def populate_oscillator_one(game)

		game.place_coords(2, 1)
		game.place_coords(2, 2)
		game.place_coords(2, 3)
	end

	# Generate an spaceship lifeform - http://www.conwaylife.com/wiki/Spaceship
	def populate_spaceship_one(game)

		game.place_coords(1, 1)
		game.place_coords(2, 2)
		game.place_coords(2, 3)
		game.place_coords(3, 1)
		game.place_coords(3, 2)
	end

end