return(
    DevChat.Colors.blue .. "\n\nao DevChat v0.1'e hoş geldiniz!\n\n" .. DevChat.Colors.reset ..
    "DevChat, yeni bir bilgisayar oluştururken ao topluluğunun iletişim kurmasına yardımcı olan basit bir servistir.\n" ..
    "Arayüz oldukça basittir. Aşağıdaki komutları çalıştırabilirsiniz:\n\n" ..
    DevChat.Colors.green .. "\t\t`List()`" .. DevChat.Colors.reset .. " mevcut odaları görmek için.\n" .. 
    DevChat.Colors.green .. "\t\t`Join(\"OdaAdı\")`" .. DevChat.Colors.reset .. " bir odaya katılmak için.\n" .. 
    DevChat.Colors.green .. "\t\t`Say(\"Mesaj\"[, \"OdaAdı\"])`" .. DevChat.Colors.reset .. " bir odaya göndermek için (bir sonraki sefer için son seçiminizi hatırlar).\n" ..
    DevChat.Colors.green .. "\t\t`Replay([\"Sayı\"])`" .. DevChat.Colors.reset .. " bir sohbetten en son mesajları yeniden yazdırmak için.\n" ..
    DevChat.Colors.green .. "\t\t`Leave(\"OdaAdı\")`" .. DevChat.Colors.reset .. " herhangi bir zamanda bir sohbetten ayrılmak için.\n" ..
    DevChat.Colors.green .. "\t\t`Tip([\"Alıcı\"])`" .. DevChat.Colors.reset .. " sohbet odasından en son mesajı gönderene bir jeton göndermek için.\n\n" ..
    "Zaten " .. DevChat.Colors.blue .. DevChat.Rooms[DevChat.InitRoom] .. DevChat.Colors.reset .. " adlı odaya kayıt oldunuz.\n" ..
    "İyi eğlenceler, saygılı olun ve unutmayın: Cypherpunks kodu gönderir! ??"
)
