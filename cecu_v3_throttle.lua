-- throttle control
-- Do not copy these comments or it may not fit in 4096 symbol limit!
cycles = 0
startEngine = false
stopEngine = false
throttleA = 0;
startTimeout = 0;
--outputs: 1N - throttle, 2B - starter
function onTick()
	temp = input.getNumber(3)
	throttle = input.getNumber(4)
	rps = input.getNumber(5)
	engineButton = input.getBool(6)
	idleRPS = property.getNumber("idle RPS")
	maxRPS = property.getNumber("max RPS")
	revCycles = property.getNumber("rev cycler")
	startTimeoutMax = property.getNumber("starter timeout (sec)") * 60
	maxTemp = property.getNumber("max temp")
	idleThrottle = property.getNumber("idle throttle")
	
	if(temp < maxTemp) then
		if(rps < maxRPS) then
			if(rps >= idleRPS) then
				throttleA = throttle
			else
				if(throttle > idleThrottle) then
					throttleA = throttle
				else
					throttleA = idleThrottle
				end
			end
		else
			if(cycles < 1) then
				throttleA = 0
				cycles = revCycles
			else
				cycles = cycles - 1
			end
		end
	else
		throttleA = 0
	end
	
	if(rps < idleRPS and engineButton) then
		startEngine = true
		stopEngine = false
	elseif(rps > idleRPS and engineButton) then
		stopEngine = true
		startEngine = false
	end
	
	if(startEngine and startTimeout < startTimeoutMax) then
		output.setBool(2,true)
		startTimeout = startTimeout + 1
	else
		output.setBool(2,false)
		startTimeout = 0;
		startEngine = false;
	end
	
	if(startEngine and rps > idleRPS) then
		startEngine = false
	end
	
	if(stopEngine) then
		throttleA = 0;
	end
	output.setNumber(1,throttleA)
	
end