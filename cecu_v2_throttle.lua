-- ecu v2
-- This is throttle control part
-- Do not copy these comments or it may not fit in 4096 symbol limit!
throttleA = 0
cycles = 0
stopEngine = false
startEngine = false
startCount = 0
function onTick()
	--input section
	throttle = input.getNumber(1)
	temperature = input.getNumber(2)
	RPS = input.getNumber(3)
	maxRPS = property.getNumber("RPS redline")
	idleRPS = property.getNumber("Idle RPS")
	maxTemp = property.getNumber("Max Temperature")
	revCycle = property.getNumber("rev limiter cycle")
	idleThrottle = property.getNumber("Idle throttle")
	startTimeout = property.getNumber("starting timeout (seconds)")
	RPStarget = input.getNumber(4)
	freeThrottle = input.getBool(6)
	engineButton = input.getBool(5)
	--logic section
	if(RPS > 1) then
		if(temperature < maxTemp) then -- if not overheat
			if(RPS > idleRPS) then -- if not idling
				if(RPS > maxRPS) then -- if redlining
					if(cycles > 0) then 
						cycles = cycles - 1
						throttleA = 0
					else
						cycles = revCycle
					end
				else -- not redlining
					if(freeThrottle) then
						throttleA = throttle
					else
						if(RPS < RPStarget) then
							throttleA = 1.25 - (RPS / RPStarget)
						else
							throttleA = 0
						end
					end
				end
			else -- if idling (RPS < idleRPS)
				if(throttle > idleThrottle) then
					throttleA = throttle
				elseif(throttle < 0) then
					throttle = 0
				else
					throttleA = idleThrottle
				end
			end
		else -- if overheat
			throttleA = 0
		end
	end
	
	if(startEngine and startCount > startTimeout * 60) then
		startEngine = false
		stopEngine = false
	end
	
	if(temperature > maxTemp - 25) then
		output.setBool(3,true)
	else
		output.setBool(3,false)
	end
	
	if(RPS > 1 and engineButton) then
		stopEngine = true
		startEngine = false
	elseif(RPS < 1 and engineButton) then
		startCount = 0
		startEngine = true
		stopEngine = false
	end
	
	if(startEngine and RPS < idleRPS) then
		throttleA = 1
	elseif(startEngine and RPS > idleRPS) then
		startEngine = false
	end
	
	if(stopEngine and RPS > 1) then
		throttleA = 0
	elseif(stopEngine and RPS < 1) then
		stopEngine = false
	end
	
	if(startEngine) then
		startCount = startCount+1
		output.setBool(2,true)
	else 
		output.setBool(2,false)
		startCount = 0
	end
	
	if(throttleA > 1) then
		throttleA = 1;
	end

	--output section
	output.setBool(5,startEngine)
	output.setBool(6,stopEngine)
	output.setNumber(4,startCount)
	output.setNumber(1,throttleA)
end
