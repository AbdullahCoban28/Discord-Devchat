const { results } = require('@permaweb/aoconnect');
const WebSocket = require('ws');
async function DevChatCheking() {
  try {
    // WebSocket bağlantısını başlat
    const ws = new WebSocket('ws://localhost:8080');
    
    // WebSocket bağlantısı açıldığında gerçekleştirilecek işlemler
    ws.on('open', () => {
      console.log('WebSocket bağlantısı açıldı');
    });

    // WebSocket bağlantısında bir hata oluştuğunda gerçekleştirilecek işlemler
    ws.on('error', (error) => {
      console.error('WebSocket hatası:', error);
    });

    // WebSocket üzerinden mesaj gönderme işlemi
    // Burada DevChat mesajlarını kontrol edecek kodlar bulunacak

  } catch (error) {
    console.error('DevChatCheking hatası:', error);
    console.error('Hata detayları:', error.message);
  } finally {
    // Belli bir süre sonra tekrar etmesi için fonksiyonu çağırma
    setTimeout(DevChatCheking, 5000);
  }
}
// DevChatCheking fonksiyonunu başlatma
DevChatCheking();

