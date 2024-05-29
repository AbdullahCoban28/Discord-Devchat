-- client.lua
local socket = require("socket")
local json = require("json")

local Client = {}
Client.__index = Client

function Client:new(name, address, port)
    local client = setmetatable({}, Client)
    client.name = name
    client.address = address
    client.port = port
    client.tcp = assert(socket.tcp())
    client.tcp:connect(address, port)
    client.tcp:settimeout(0)
    return client
end

function Client:send(data)
    local encoded = json.encode(data)
    self.tcp:send(encoded .. "\n")
end

function Client:receive()
    local response, err = self.tcp:receive()
    if not err then
        return json.decode(response)
    end
end

function Client:joinRoom(roomName)
    self:send({ action = "join", room = roomName })
end

function Client:say(message, roomName)
    self:send({ action = "say", room = roomName, message = message })
end

function Client:listRooms()
    self:send({ action = "list" })
end

function Client:close()
    self.tcp:close()
end

-- Usage example:
-- local client = Client:new("username", "localhost", 12345)
-- client:joinRoom("general")
-- client:say("Hello, world!", "general")
-- client:listRooms()
-- client:close()

return Client
