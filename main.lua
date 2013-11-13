--[[ 
Example client for the leaderboards server https://github.com/romka/leaderboards-server.

Author - Roman Arkharov arkharov@gmail.com
(C) 2013
]]

-- Initialization

-- Unique key. The same values should be used on server side. 
local sequence = {1, 166, 2, 158, 3, 146, 5, 134, 122, 7, 114, 11, 206, 13, 102, 17, 94, 19, 86, 23, 82, 29, 74, 31, 62, 37, 58, 41, 46, 43, 38, 47, 34, 51, 26, 53, 22, 57, 14, 61, 10, 67, 6, 73, 4, 79, 2, 83}

local leaderboards_name = 'leaderboards_example' -- your game name
local leaderboards_secret = 'Tratata-tratata-we-are-carry-the-cat' -- some random unique string
local domain = 'kece.ru' -- server domain or ip
local port = 10188 -- server port
local timeout = 3

--[[
	records_loader initialization
--]]
records_loader = RecordsLoader.new(domain, port, timeout, leaderboards_name, leaderboards_secret, sequence) -- you should the your own domain and port here








-- Send data to server

-- data to send
local data = {}
data.mode = 'easy' -- for example: easy, medium or hard

-- For testing purposes you can change values below
data.local_records = {
	{
     ['value'] = 1000, -- score
     ['name'] = to_base64('Ivan Ivanov'), -- name coded to base64
     ['time'] = 1382516658, -- time in Unix timestamp format
     ['record_id'] = 'some-unique-id-1', -- server won't put to DB two items with the same record_id
   },
   {
     ['value'] = 500,
     ['name'] = to_base64('John Smith'),
     ['time'] = 1382516658,
     ['record_id'] = 'some-unique-id-2',
   }
}

--[[
	Method records_loader:send_and_retrieve_records sends records list to server and recieves global records for selected game and mode
--]]
local global_records = records_loader:send_and_retrieve_records(data)
local result = Json.Decode(decrypt(tostring(global_records)))

for i = 1, #result['top'], 1 do
	print('name', from_base64(result['top'][i]['name']), 'score', result['top'][i]['score'])
end
