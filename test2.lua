function setupMotor(pinDir, pinSpeed)
    gpio.mode(pinDir, gpio.OUTPUT)
    pwm.setup(pinSpeed, 500, 512) 
    pwm.start(pinSpeed) 
end

function setMotor(speed, pinDir, pinSpeed)
    if speed < 0 then
        gpio.write(pinDir, gpio.HIGH)
    else
        gpio.write(pinDir, gpio.LOW)
    end
    pwm.setduty(pinSpeed, math.abs(speed)) 
end

--setupMotor(3, 1)
--setupMotor(4, 2)
setupMotor(8, 7)
setMotor(300, 8, 7)
--setMotor(800, 4, 2)

pwm.setup(5, 50, 100)
pwm.start(5)
pwm.setduty(5, 100)

--tmr.delay(400000)

--setMotor(0, 3, 1)
--setMotor(0, 8, 7)
--setMotor(0, 4, 2)
