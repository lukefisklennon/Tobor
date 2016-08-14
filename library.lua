--Library table
local tobor = {}

--In and out pins
tobor.ins = {top=1,bottom=2,under=3}
tobor.outs = {motorLeft=1,motorRight=2,arm=3,pincerLeft=4,pincerRight=5}
--Settings
tobor.settings = {moveSpeed=1000,armmoveSpeed=1000,turnTime=1000000,armTime=500000,relaxAngle=-20,squeezeAngle=20}

--Initialise pins
function tobor.init()
	for k,v in ipairs(tobor.ins)
		gpio.mode(v,gpio.INPUT)
	end
	for k,v in ipairs(tobor.outs)
		gpio.mode(v,gpio.OUTPUT)
	end
end

--Read pin
function tobor.in(i)
	return gpio.read(tobor.ins[p])
end

--Write to pin
function tobor.out(o,v,t)
	gpio.write(tobor.outs[p],v)
end

--Start moving
function tobor.go()
	tobor.out("leftMotor",tobor.settings.moveSpeed)
	tobor.out("rightMotor",tobor.settings.moveSpeed)
end

--Stop moving
function tobor.stop()
	tobor.out("leftMotor",0)
	tobor.out("rightMotor",0)
end

--Spin around
function tobor.spin(d)
	if (d == 0) then
		tobor.out("leftMotor",-tobor.settings.moveSpeed)
		tobor.out("rightMotor",tobor.settings.moveSpeed)
	else then
		tobor.out("leftMotor",tobor.settings.moveSpeed)
		tobor.out("rightMotor",-tobor.settings.moveSpeed)
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
	tobor.out("arm",settings.armSpeed)
end

--Set arm to drop
function tobor.down()
	tobor.out("arm",-settings.armSpeed)
end

--Set arm to not move
function tobor.holt()
	tobor.out("arm",0)
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
	tobor.out("pincerLeft",tobor.settings.relaxAngle)
	tobor.out("pincerLeft",-tobor.settings.relaxAngle)
end

--Relax pincers to release cube
function tobor.release()
	tobor.out("pincerLeft",tobor.settings.squeezeAngle)
	tobor.out("pincerLeft",-tobor.settings.squeezeAngle)
end

function tobor.check()
	--...
end

--Repeating timer to check ins
tmr.register(0,10000,tmr.ALARM_AUTO,tobor.check)

--Return library
return tobor