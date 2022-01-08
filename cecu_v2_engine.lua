-- cecu v2
-- this is engine control part
-- Do not copy these comments or it may not fit in 4096 symbol limit!
fuelManifold = 0.5;
function onTick()
	--input section
	airVolume = input.getNumber(1)
	fuelVolume = input.getNumber(2)
	temperature = input.getNumber(3)
	throttle = input.getNumber(4)
	ratioChanger = property.getNumber("ratio inc/dec")
	stoichConst = property.getNumber("stoich constant")
	--math section
	currentAFR = airVolume / fuelVolume
	if(currentAFR ~= nil) then
		if(currentAFR > stoichConst) then
			fuelManifold = fuelManifold + ratioChanger
		elseif(currentAFR < stoichConst) then
			fuelManifold = fuelManifold - ratioChanger
		end
	end
	--output section
	output.setNumber(1,fuelManifold * throttle)
	output.setNumber(2,throttle)
	output.setNumber(3,currentAFR)
end