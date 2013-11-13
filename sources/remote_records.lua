--[[ 
Example client for the leaderboards server https://github.com/romka/leaderboards-server.

Author - Roman Arkharov arkharov@gmail.com
(C) 2013
]]

RecordsLoader = gideros.class(Sprite)

function RecordsLoader:init(host, port, timeout, leaderboards_name, leaderboards_secret, sequence)
	if host == nil or port == nil then
		error('Host or port doesn\'t set in RecordsLoader')
	end
	
	self.host = host
	self.port = port
	self.timeout = timeout
	self.leaderboards_name = leaderboards_name
	self.leaderboards_secret = leaderboards_secret
	self.sequence = sequence
end

function RecordsLoader:send_and_retrieve_records(data)
	local socket = require('socket')
	client = socket.connect(self.host, self.port)
	
	if client == nil then
		return 'no connection'
	else
		client:settimeout(self.timeout, 't')
		
		data.app_name = self.leaderboards_name
		data.app_secret = self.leaderboards_secret
		
		
		local cr_data = encrypt(Json.Encode(data))
		
		-- Split data to chunks if it's too big
		local chunks_amount = 1
		local chunks = {}
		local string_len = string.len(cr_data)
		if string_len > 1000 then
			chunks_amount = math.ceil(string_len / 1000)
			for i = 1, chunks_amount, 1 do
				local from = i + 1000 * (i - 1)
				local to = i + 1000 * i
				if to > string_len then
					to = string_len
				end

				table.insert(chunks, string.sub(cr_data, from, to))
			end
		end

		if chunks_amount == 1 then
			client:send(chunks_amount)
			s, status, partial = client:receive(1)
			client:send(cr_data)
			s, status, partial = client:receive(1)
		else
			client:send(chunks_amount)
			s, status, partial = client:receive(1) -- read one byte from socket
			for i = 1, chunks_amount, 1 do
				client:send(chunks[i])
				s, status, partial = client:receive(1)
			end
		end

		s, status, partial = client:receive('*a')
		
		client:close()
		
		if status == 'closed' then
			return status
		else	
			return s
		end
	end
end