RoomManager = {}

RoomManager.Rooms = RoomManager.Rooms or {}

-- Oda adına göre oda adresini bulan fonksiyon
RoomManager.findRoom =
    function(target)
        for address, name in pairs(RoomManager.Rooms) do
            if target == name then
                return address
            end
        end
    end

-- Yeni bir oda eklemek için fonksiyon
RoomManager.add =
    function(...)
        local arg = {...}
        ao.send({
            Target = DevChat.Router,
            Action = "Register",
            Name = arg[1] or Name,
            Address = arg[2] or ao.id
        })
    end

-- Bir odaya katılma fonksiyonu
Join =
    function(id, ...)
        local arg = {...}
        local addr = RoomManager.findRoom(id) or id
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
            DevChat.LastSend = RoomManager.findRoom(id) or id
        end
        local name = RoomManager.Rooms[DevChat.LastSend] or id
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
        local roomName = RoomManager.Rooms[room] or room
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
            " odada " .. DevChat.Colors.blue .. roomName .. DevChat.Colors.gray ..
            "."
        )
    end

-- Mesajı yayınlama işlemini dinleyen fonksiyon
Handlers.add(
    "DevChat-Broadcasted",
    Handlers.utils.hasMatchingTag("Action", "Broadcasted"),
    function (m)
        local shortRoom = RoomManager.Rooms[m.From] or string.sub(m.From, 1, 6)
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
        RoomManager.Rooms = DevChat.InitRooms

        for i = 1, #m.TagArray do
            local filterPrefix = "Room-" -- Tüm oda etiketleri bu önekiyle başlar
            local tagPrefix = string.sub(m.TagArray[i].name, 1, #filterPrefix)
            local name = string.sub(m.TagArray[i].name, #filterPrefix + 1, #m.TagArray[i].name)
            local address = m.TagArray[i].value

            if tagPrefix == filterPrefix then
                rows = rows .. DevChat.Colors.blue .. "        " .. name .. DevChat.Colors.reset .. "\n"
                RoomManager.Rooms[address] = name
            end
        end

        print(
            intro .. rows .. "\nBir odaya katılmak için `Join(\"odaAdı\"[, \"kullanıcıAdı\"])` komutunu kullanabilirsiniz! Odalardan çıkmak için `Leave(\"odaAdı\")` kullanabilirsiniz.")
    end
)

-- Yeni bir oda eklemek için
RoomManager.add("CoinssporRoom")

-- CoinssporRoom'a katıl
Join("CoinssporRoom")

-- CoinssporRoom'da hoş geldiniz mesajı
print(
    DevChat.Colors.blue .. "\n\nCoinssporRoom odasına hoş geldiniz!\n\n" .. DevChat.Colors.reset ..
    "Bu oda, sporun heyecanını ve stratejisini tartışmak için oluşturulmuştur.\n" ..
    "Bir oyun, bir maç veya bir takım hakkında konuşmak için mükemmel bir yerdir.\n" ..
    "Dürüstlük ve saygıyı ön planda tutun ve eğlenceli vakit geçirin!"
)

-- DevChat'a kaydolun
ao.send({
    Target = DevChat.Router,
    Action = "Register",
    Name = "CoinssporRoom"
})

-- Mesajları dinleme döngüsü
DevChat.listen()
