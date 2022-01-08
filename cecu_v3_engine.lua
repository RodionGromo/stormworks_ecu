-- engine control
-- Do not copy these comments or it may not fit in 4096 symbol limit!
fuelManifold = 0.5
function onTick()
	throttle = input.getNumber(4)
	airVolume = input.getNumber(1)
	fuelVolume = input.getNumber(2)
	afrConst = property.getNumber("afr const")
	change = property.getNumber("const dec/inc")
	--math
	afr = airVolume / fuelVolume
	if(afr > afrConst) then
		fuelManifold = fuelManifold + change
	elseif(afr < afrConst) then
		fuelManifold = fuelManifold - change
	end
	--output
	output.setNumber(1,throttle)
	output.setNumber(2,fuelManifold * throttle)
	output.setNumber(3,afr)
	
end