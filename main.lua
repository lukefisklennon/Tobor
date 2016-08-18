--Import library
tobor = require("library")

--Modes: 0 = search, 1 = found, 2 = done
mode = 0
--Angle to bounce of walls
bounceAngle = 100

--Function to bounce of walls and the ledge
function bounce()
	tobor.turn(bounceAngle)
	tobor.go()
end

--Function to pick the cube up
function get()
	tobor.squeeze()
	tobor.lift()
end

--Function to put the cube down
function put()
	tobor.relax()
end

--Initialise tobor
tobor.init()

--Go!
tobor.go()

--When colliding with a wall, bounce
tobor.on.wall = function(v)
	if (v == 0) then
		bounce()
	end
end

--When colliding with a ledge, bounce if haven't found the cube yet or put the cube there if has it
tobor.on.ledge = function(v)
	if (v == 0) then
		if (mode == 0) then
			bounce()
		elseif (mode == 1) then
			put()
			mode = 2
		end
	end
end

--When colliding with cube, pick it up
tobor.on.cube = function(v)
	if (mode == 0 and v == 0) then
		get()
	end
end
