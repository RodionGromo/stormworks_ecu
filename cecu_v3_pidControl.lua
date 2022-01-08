-- PID control
function onTick()
	rps = input.getNumber(1)
	minRPS = input.getNumber(2)
	rpsTarget = input.getNumber(3)
	active = not input.getBool(4)
	hardcore = input.getBool(5)
	if(rps >= minRPS and active) then
		output.setBool(1,true)
	else
		output.setBool(1,false)
	end
	if(hardcore == false) then
		output.setNumber(2,math.floor(rps))
		output.setNumber(3,math.floor(rpsTarget))
	else
		output.setNumber(2,rps)
		output.setNumber(3,rpsTarget)
	end
end