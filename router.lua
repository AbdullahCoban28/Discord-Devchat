-- Handlers tablosu mesaj işleyicilerini depolamak için kullanılır
Handlers = {}

-- Handlers tablosuna yeni bir işleyici ekler
function Handlers.add(name, condition, action)
    if type(name) == "string" and type(condition) == "function" and type(action) == "function" then
        Handlers[name] = {
            condition = condition,
            action = action
        }
    else
        print("Invalid handler definition for handler '" .. name .. "'")
    end
end

-- Gelen mesajları işler ve uygun işleyiciyi çağırır
function processMessage(message)
    for name, handler in pairs(Handlers) do
        if handler.condition(message) then
            handler.action(message)
        end
    end
end

-- Mesaj işleme döngüsü
while true do
    local message = ao.receive()
    processMessage(message)
end

