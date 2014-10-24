#!/usr/bin/env ruby

gem "minitest"

require "minitest/autorun"
require 'minitest/pride'
require_relative "gameoflife"

class TestGameOfLife < Minitest::Test

	def setup

		@game = GameOfLife.new(10, 5)
    end  

    def test_place_at_coords

        @game.display()

        cell = @game.update_cell_status_at_coords(2,4, Cell::ALIVE)
        puts @game.display()
        assert_equal Cell::ALIVE, cell.status
    end

    def test_status

        assert_equal Cell::ALIVE, @game.update_cell_status_at_coords(2,2, Cell::ALIVE).status
        assert_equal Cell::ALIVE, @game.update_cell_status_at_coords(3,1, Cell::ALIVE).status
        assert_equal Cell::ALIVE, @game.update_cell_status_at_coords(3,2, Cell::ALIVE).status
        assert_equal Cell::ALIVE, @game.update_cell_status_at_coords(4,2, Cell::ALIVE).status

        puts @game.display()

        # Need to convert to positions
        assert_equal 2, @game.get_num_neighbours_by_coords(4, 2, Cell::ALIVE)
        assert_equal 3, @game.get_num_neighbours_by_coords(3, 2, Cell::ALIVE)
        
    end

    def test_determine_future_underpopulation

        # Check under populated < 2
        puts "\nChecking underpopulation...\n"
        assert_equal Cell::ALIVE, @game.update_cell_status_at_coords(6,3, Cell::ALIVE).status
        puts @game.display
        underpopulated_cell = @game.get_cell_at_coords(6, 3)
        cell = @game.determine_future(underpopulated_cell)
        assert_equal Cell::DEAD, cell.status
    end

    def test_determine_future_overpopulation

        # Check over populated > 3
        puts "\nChecking overpopulation\n"
        assert_equal Cell::ALIVE, @game.update_cell_status_at_coords(2, 2, Cell::ALIVE).status
        assert_equal Cell::ALIVE, @game.update_cell_status_at_coords(3, 1, Cell::ALIVE).status
        assert_equal Cell::ALIVE, @game.update_cell_status_at_coords(3, 2, Cell::ALIVE).status
        assert_equal Cell::ALIVE, @game.update_cell_status_at_coords(2, 1, Cell::ALIVE).status
        assert_equal Cell::ALIVE, @game.update_cell_status_at_coords(3, 3, Cell::ALIVE).status
        puts @game.display
        overpopulated_cell = @game.get_cell_at_coords(3, 2)
        cell = @game.determine_future(overpopulated_cell)
        puts @game.display
        assert_equal Cell::DEAD, cell.status
    end

    def test_determine_future_reproduction

        puts "\nChecking reproduction"
        assert_equal Cell::ALIVE, @game.update_cell_status_at_coords(2, 2, Cell::ALIVE).status
        assert_equal Cell::ALIVE, @game.update_cell_status_at_coords(3, 2, Cell::ALIVE).status
        assert_equal Cell::ALIVE, @game.update_cell_status_at_coords(2, 1, Cell::ALIVE).status
        assert_equal Cell::ALIVE, @game.update_cell_status_at_coords(3, 3, Cell::ALIVE).status
        puts @game.display
        puts "\n\n\ncheck repro\n\n\n"
        assert_reproduction(3, 1)
    end

    def check_lives_on

        puts "\nChecking lives on"
        cell_lives = @game.get_cell_at_coords(3, 3)
        future = @game.determine_future(cell_lives)
        puts @game.display

        assert_equal Cell::DEAD, @game.update_cell_status_at_coords(3, 2, future).status
    end

    def assert_reproduction(x, y)

        reproduction_cell = @game.get_cell_at_coords(x, y)
        cell = @game.determine_future(reproduction_cell)
        puts @game.display
        assert_equal Cell::ALIVE, cell.status
    end
end