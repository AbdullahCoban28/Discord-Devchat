DevChat = {}

DevChat.Colors = {
    red = "\27[31m",
    green = "\27[32m",
    blue = "\27[34m",
    reset = "\27[0m",
    gray = "\27[90m"
}

DevChat.Router = "xnkv_QpWqICyt8NpVMbfsUQciZ4wlm5DigLrfXRm8fY" 
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
            " odada " .. DevChat.Colors.blue .. roomName .. DevChat.Colors.gray .. "."
        )
    end

-- Mesajı yayınlama işlemini dinleyen fonksiyon
Handlers.add(
    "DevChat-Broadcasted",
    Handlers.utils.hasMatchingTag("Action", "Broadcasted"),
    function (m)
        local shortRoom = DevChat.Rooms[m.From] or string.sub(m.From, 1, 6)
        if m.Broadcaster == ao.id then
            if DevChat.Confirmations == true then
                print(
                    DevChat.Colors.gray .. "[Yayınınız " ..
                    DevChat.Colors.blue .. shortRoom .. DevChat.Colors.gray .. " odasında doğrulandı.]" ..
                    DevChat.Colors.reset)
            end
        else
            local nick = string.sub(m.Nickname, 1, 10)
            if m.Broadcaster ~= m.Nickname then
                nick = nick .. DevChat.Colors.gray .. "#" .. string.sub(m.Broadcaster, 1, 3)
            end
            print(
                "[" .. DevChat.Colors.red .. nick .. DevChat.Colors.reset ..
                "@" .. DevChat.Colors.blue .. shortRoom .. DevChat.Colors.reset ..
                "]> " .. DevChat.Colors.green .. m.Data .. DevChat.Colors.reset)

            DevChat.LastReceive.Room = m.From
            DevChat.LastReceive.Sender = m.Broadcaster
        end
    end
)

-- Oda listesini işleyen fonksiyon
Handlers.add(
    "DevChat-List",
    function(m)
        if m.Action == "Room-List" and m.From == DevChat.Router then
            return true
        end
        return false
    end,
    function(m)
        local intro = "?? Aşağıdaki odalar şu anda DevChat'te mevcut:\n\n"
        local rows = ""
        DevChat.Rooms = DevChat.InitRooms

        for i = 1, #m.TagArray do
            local filterPrefix = "Room-" -- Tüm oda etiketleri bu önekiyle başlar
            local tagPrefix = string.sub(m.TagArray[i].name, 1, #filterPrefix)
            local name = string.sub(m.TagArray[i].name, #filterPrefix + 1, #m.TagArray[i].name)
            local address = m.TagArray[i].value

            if tagPrefix == filterPrefix then
                rows = rows .. DevChat.Colors.blue .. "        " .. name .. DevChat.Colors.reset .. "\n"
                DevChat.Rooms[address] = name
            end
        end

        print(
            intro .. rows .. "\nBir odaya katılmak için `Join(\"odaAdı\"[, \"kullanıcıAdı\"])` komutunu kullanabilirsiniz! Odalardan çıkmak için `Leave(\"odaAdı\")` kullanabilirsiniz.")
    end
)

-- DevChat'a yeni bir katılımcının eklendiğini işleyen fonksiyon
Handlers.add(
    "TransferToDevChat",
    Handlers.utils.hasMatchingTag("Action", "TransferToDevChat"),
    function(m)
        local msgContent = m.Data or "Mesaj içeriği bulunamadı"
        local senderName = m.Event or "Bilinmeyen gönderen"

        -- Mesajı DevChat konsolunda göster
        print(DevChat.Colors.green .. "[" .. senderName .. "]: " .. DevChat.Colors.reset .. msgContent)
    end
)

-- Eğer daha önce DevChat'a kaydolunmadıysa, ilk odaya katıl
if DevChatRegistered == nil then
    DevChatRegistered = true
    Join(DevChat.InitRoom)
end
