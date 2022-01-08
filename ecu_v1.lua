-- ecu v1
turboed = false
cycles = 0;

function setInflows(throttle)
	output.setNumber(1,1 * throttle)
	if(turboed) then
		output.setNumber(2,(minFuel+additionalFuel) * throttle)
	else
		output.setNumber(2,minFuel * throttle)
	end
end

function onTick()
	rps = input.getNumber(2)
	temp = input.getNumber(1)
	throttle = input.getNumber(3)
	turbo = input.getNumber(4)
	maxTemp = property.getNumber("Max temp")
	idleRPS = property.getNumber("Idle RPS")
	minFuel = property.getNumber("Min fuel inflow")
	idleThrottle = property.getNumber("idle throttle")
	maxRPS = property.getNumber("max rps")
	additionalFuel = property.getNumber("additional turbo fuel")
	revCycles = property.getNumber("rev limiter cycles")
	if(turbo > 0.1) then
		turboed = true
	else
		turboed = false
	end
	
	if(temp < maxTemp) then
		if(rps < idleRPS) then
			if(throttle < 0) then
				setInflows(0)
			elseif(throttle > idleThrottle) then
				setInflows(throttle)
			else
				setInflows(idleThrottle)
			end
		else
			if(rps > maxRPS) then
				cycles = revCycles
			end
			
			if(cycles > 0) then
				cycles = cycles - 1;
				setInflows(0)
			else
				setInflows(throttle)
			end
		end
	else
		setInflows(0)
	end
end