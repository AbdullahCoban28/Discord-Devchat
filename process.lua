-- process.lua
DevChat = {}

DevChat.Colors = {
    red = "\27[31m",
    green = "\27[32m",
    blue = "\27[34m",
    reset = "\27[0m",
    gray = "\27[90m"
}

DevChat.Router = "cSh3iRyE3_qGdRzczwkZxG7bHfFC3Kq7xhO4toPbp9k" 
DevChat.InitRoom = "1245365878657388660" 
DevChat.LastSend = DevChat.InitRoom

DevChat.LastReceive = {
    Room = DevChat.InitRoom,
    Sender = nil
}

DevChat.InitRooms = { [DevChat.InitRoom] = "DevChat-Main" }
DevChat.Rooms = DevChat.Rooms or DevChat.InitRooms

DevChat.Confirmations = DevChat.Confirmations or true

-- Hedef oda adına göre oda adresini bulan fonksiyon
DevChat.findRoom =
    function(target)
        for address, name in pairs(DevChat.Rooms) do
            if target == name then
                return address
            end
        end
    end

-- Yeni bir oda eklemek için fonksiyon
DevChat.add =
    function(...)
        local arg = {...}
        ao.send({
            Target = DevChat.Router,
            Action = "Register",
            Name = arg[1] or Name,
            Address = arg[2] or ao.id
        })
    end

-- Tüm odaların listesini alma fonksiyonu
List =
    function()
        ao.send({ Target = DevChat.Router, Action = "Get-List" })
        return(DevChat.Colors.gray .. "DevChat dizininden oda listesi alınıyor..." .. DevChat.Colors.reset)
    end

-- Bir odaya katılma fonksiyonu
Join =
    function(id, ...)
        local arg = {...}
        local addr = DevChat.findRoom(id) or id
        local nick = arg[1] or ao.id
        ao.send({ Target = addr, Action = "Register", Nickname = nick })
        return(
            DevChat.Colors.gray ..
             "Odaya katılıyor: " ..
            DevChat.Colors.blue .. id .. 
            DevChat.Colors.gray .. "..." .. DevChat.Colors.reset)
    end

-- Mesaj gönderme fonksiyonu
Say =
    function(text, ...)
        local arg = {...}
        local id = arg[1]
        if id ~= nil then
            DevChat.LastSend = DevChat.findRoom(id) or id
        end
        local name = DevChat.Rooms[DevChat.LastSend] or id
        ao.send({ Target = DevChat.LastSend, Action = "Say", Data = text })
        if DevChat.Confirmations then
            return(DevChat.Colors.gray .. "Yayıncıya " .. DevChat.Colors.blue ..
                name .. DevChat.Colors.gray .. " mesajı iletiliyor..." .. DevChat.Colors.reset)
        else
            return ""
        end
    end

-- Kullanıcıya bahşiş verme fonksiyonu
Tip =
    function(...) -- Alıcı, Hedef, Miktar
        local arg = {...}
        local room = arg[2] or DevChat.LastReceive.Room
        local roomName = DevChat.Rooms[room] or room
        local qty = tostring(arg[3] or 1)
        local recipient = arg[1] or DevChat.LastReceive.Sender
        ao.send({
            Action = "Transfer",
            Target = room,
            Recipient = recipient,
            Quantity = qty
        })
        return(DevChat.Colors.gray .. "Bahşiş gönderiliyor: " ..
            DevChat.Colors.green .. qty .. DevChat.Colors.gray ..
            " alıcıya " .. DevChat.Colors.red .. recipient .. DevChat.Colors.gray ..
            " odada " .. Dev
