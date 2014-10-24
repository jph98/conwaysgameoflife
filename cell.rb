#!/usr/bin/env ruby

require "colorize"

class Cell

	attr_accessor :x, :y, :status

	ALIVE = :A
	DEAD = :D

	def initialize(x, y, status)
		@x = x
		@y = y
		@status = status
	end

	def status_color()

		if @status.eql? ALIVE
			return "#{status}".colorize(:light_green)
		elsif @status.eql? DEAD
			return "#{status}".colorize(:light_red)
		end
		return @status
	end

	def to_s
		return "[#{@x},#{@y}] - #{@status}"
	end

end
