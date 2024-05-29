-- results() fonksiyonunu al
local results = require('@permaweb/aoconnect').results

-- WebSocket kütüphanesini al
local WebSocket = require('ws')

-- İlk cursor değerini saklamak için bir değişken
local cursor = ''

-- WebSocket bağlantısını oluştur
local ws = WebSocket:new('ws://localhost:8080')

-- WebSocket bağlantısı açıldığında
ws:on('open', function()
    print('WebSocket bağlantısı açıldı')
end)

-- WebSocket hatası oluştuğunda
ws:on('error', function(error)
    print('WebSocket hatası:', error)
end)

-- DevChat'ten mesajları yakalama fonksiyonu
async function captureMessages()
    try {
        -- İlk cursor değerini kontrol et
        if cursor == '' then
            local resultsOut = await results({
                process: 'YOUR_DEVCHAT_PROCESS_ID',
                sort: 'DESC',
                limit: 1
            })
            cursor = resultsOut.edges[0].cursor
            print('İlk sonuçlar:', resultsOut)
        end

        print('Mesajlar yakalanıyor------>>>>')
        -- Son cursor değerinden itibaren mesajları al
        local resultsOut2 = await results({
            process: 'YOUR_DEVCHAT_PROCESS_ID',
            from: cursor,
            sort: 'ASC',
            limit: 50
        })

        -- Sonuçları işle
        for _, element in ipairs(resultsOut2.edges:reverse()) do
            cursor = element.cursor
            print('Eleman Verisi:', element.node.Messages)

            for _, msg in ipairs(element.node.Messages) do
                print('Mesaj Etiketleri:', msg.Tags)
            end

            -- Etiketleri olan mesajları al
            local messagesData = element.node.Messages:filter(
                function(e)
                    return #e.Tags > 0 and e.Tags:some(
                        function(f)
                            return f.name == 'Action' and f.value == 'Say'
                        end
                    )
                end
            )
            print('Filtrelenmiş Mesaj Verisi:', messagesData)

            -- WebSocket üzerinden mesajları gönder
            for _, messagesItem in ipairs(messagesData) do
                local event = messagesItem.Tags:find(function(e) return e.name == 'Event' end)?.value or 'Message in DevChatRoom'
                local sendText = event .. ' : ' .. messagesItem.Data
                print('Yakalanan Mesaj:', sendText)
                ws:send(sendText)
            end
        end
    } catch (error) {
        print('Mesaj yakalama hatası:', error)
        print('Hata detayları:', error.message)
    } finally {
        -- Belirli bir süre sonra tekrar mesajları yakalamaya devam et
        setTimeout(captureMessages, 5000)
    }
end

-- Yakalama işlemini başlat
captureMessages()
