--[[ 
Simple encrypt/decrypt functions.

Author - Roman Arkharov arkharov@gmail.com
(C) 2013
]]

local function convert(byte, key, direction)
	local new
	if direction == true then
		new = byte + key
		if new > 255 then
			new = new - 255
		end
	else
		new = byte - key
		if new < 0 then
			new = new + 255
		end
	end
		
	return new
end

function encrypt(str)
	local result = ''
	-- records_loader is a global object defined in main.lua
	local max_counter = #records_loader.sequence
	local counter = 1

	for i = 1, #str do
		local ch = convert(string.byte(string.sub(str, i, i)), records_loader.sequence[counter], true)
		ch = tostring(ch)
		while string.len(ch) < 3 do
			ch = '0' .. ch
		end
		
		result = result .. ch
		
		counter = counter + 1
		if counter > max_counter then
			counter = 1
		end
	end

	return result
end

function decrypt(str)
	local result = ''
	-- records_loader is a global object defined in main.lua
	local max_counter = #records_loader.sequence
	local counter = 1

	for i = 1, #str, 3 do
		local ch = tonumber(string.sub(str, i, i + 2))
		
		local ch2 = convert(ch, records_loader.sequence[counter], false)
		
		result = result .. string.char(ch2)
		
		counter = counter + 1
		if counter > max_counter then
			counter = 1
		end
	end
	
	return result
end
