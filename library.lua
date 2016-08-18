--Library table
local tobor = {}

--In and out pins
tobor.inputs = {top=1,bottom=2,under=3}
tobor.outs = {motorLeft=1,_motorLeft=3,motorRight=2,_motorRight=4,arm=6,_arm=10,pincerLeft=7,pincerRight=8}
--Settings
tobor.settings = {moveSpeed=800,armSpeed=800,turnTime=1000000,armTime=500000,midAngle=100,holdAngle=-10,releaseAngle=10}
--Environment data
tobor.world = {cube=0,ledge=0,wall=0,_cube=0,_ledge=0,_wall=0}

--Listener functions
tobor.on = {}

--Called on ledge collision
function tobor.on.ledge(v)
end

--Called on cube collision
function tobor.on.cube(v)
end

--Called on wall collision
function tobor.on.wall(v)
end

--Initialise pins
function tobor.init()
    pwm.setup(tobor.outs["leftMotor"],500,512)
    pwm.setup(tobor.outs["rightMotor"],500,512)
    pwm.setup(tobor.outs["arm"],500,512)
	pwm.setup(tobor.outs["pincerLeft"],50,100)
	pwm.setup(tobor.outs["pincerRight"],50,100)
    pwm.start(tobor.outs["leftMotor"])
    pwm.start(tobor.outs["rightMotor"])
    pwm.start(tobor.outs["arm"])
	pwm.start(tobor.outs["pincerLeft"])
    pwm.start(tobor.outs["pincerRight"])
end

--Read pin
function tobor.input(i)
    return gpio.read(tobor.inputs[p])
end

--Output functions
tobor.out = {}

--Output to servo based on angle
function tobor.out.servo(p,a)
    pwm.setduty(tobor.outs[p],a)
end

function tobor.pincerAngle(a,s)
	b = tobor.settings[a]
	if (s == 1)
		b = b * -1
	end
	return tobor.settings.midAngle + b
end

--Output to motor based on speed
function tobor.out.motor(p,s)
    if (s < 0) then
        d = gpio.HIGH;
    else
        d = gpio.LOW;
    end
    pwm.setduty(tobor.outs[p],math.abs(s))
    gpio.write(tobor.outs["_" .. p],d)
end

--Start moving
function tobor.go()
    tobor.out.motor("motorLeft",tobor.settings.moveSpeed)
    tobor.out.motor("motorRight",tobor.settings.moveSpeed)
end

--Stop moving
function tobor.stop()
    tobor.out.motor("motorLeft",0)
    tobor.out.motor("motorRight",0)
end

--Spin around
function tobor.spin(d)
    if (d == 0) then
        tobor.out.motor("motorLeft",-tobor.settings.moveSpeed)
        tobor.out.motor("motorRight",tobor.settings.moveSpeed)
    else
        tobor.out.motor("motorLeft",tobor.settings.moveSpeed)
        tobor.out.motor("motorRight",-tobor.settings.moveSpeed)
    end
end

--Turn by angle
function tobor.turn(d,a)
    local t = (a/360)*tobor.settings.turnTime
    tobor.spin(d)
    tmr.delay(t)
    tobor.stop()
end

--Set arm to lift
function tobor.up()
    tobor.out.motor("arm",settings.armSpeed)
end

--Set arm to drop
function tobor.down()
    tobor.out.motor("arm",-settings.armSpeed)
end

--Set arm to not move
function tobor.holt()
    tobor.out.motor("arm",0)
end

--Lift up and stop
function tobor.lift()
    tobor.up()
    tmr.delay(tobor.settings.armTime)
    tobor.holt()
end

--Drop and stop
function tobor.drop()
    tobor.down()
    tmr.delay(tobor.settings.armTime)
    tobor.holt()
end

--Squeeze pincers to hold cube
function tobor.hold()
    tobor.out.servo("pincerLeft",tobor.pincerAngle("holdAngle",0))
    tobor.out.servo("pincerRight",tobor.pincerAngle("holdAngle",1))
end

--Relax pincers to release cube
function tobor.release()
    tobor.out.servo("pincerLeft",tobor.pincerAngle("releaseAngle",0))
    tobor.out.servo("pincerRight",tobor.pincerAngle("releaseAngle",1))
end

--Check sensors
function tobor.check()
    if (tobor.input("top") == 0 and tobor.input("bottom") == 0) then
        tobor.world.ledge = 1
    end
    if (tobor.input("top") == 1 and tobor.input("bottom") == 0) then
        tobor.world.cube = 1
    end
    if (tobor.input("top") == 1 and tobor.input("bottom") == 1) then
        tobor.world.ledge = 0
        tobor.world.cube = 0
    end
    if (tobor.input("under") == 1) then
        tobor.world.wall = 1
    else
        tobor.world.wall = 0
    end
    if (tobor.world.ledge ~= tobor.world._ledge) then
        tobor.world._ledge = tobor.world.ledge
        tobor.on.ledge(tobor.world.ledge)
    end
    if (tobor.world.cube ~= tobor.world._cube) then
        tobor.world._cube = tobor.world.cube
        tobor.on.cube(tobor.world.cube)
    end
    if (tobor.world.wall ~= tobor.world._wall) then
        tobor.world._wall = tobor.world.wall
        tobor.on.wall(tobor.world.wall)
    end
end

--Repeating timer to check ins
tmr.register(0,10,tmr.ALARM_AUTO,tobor.check)

--Return library
return tobor
