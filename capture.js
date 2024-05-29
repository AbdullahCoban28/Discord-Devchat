// results ve ws modüllerini içe aktar
const { results } = require('@permaweb/aoconnect');
const WebSocket = require('ws');

// İşaretleç başlangıç değeri
let cursor = '';

// WebSocket bağlantısını başlat
const ws = new WebSocket('ws://localhost:8080');

// WebSocket açıldığında gerçekleşecek olaylar
ws.on('open', () => {
  console.log('WebSocket bağlantısı açıldı');
});

// WebSocket hatası olduğunda gerçekleşecek olaylar
ws.on('error', (error) => {
  console.error('WebSocket hatası:', error);
});

// DevChatCheking fonksiyonu, DevChat'ten gelen mesajları kontrol eder
async function DevChatCheking() {
  try {
    if (cursor == '') {
      // İlk sonuçları al
      const resultsOut = await results({
        process: 'cSh3iRyE3_qGdRzczwkZxG7bHfFC3Kq7xhO4toPbp9k',
        sort: 'DESC',
        limit: 1,
      });
      cursor = resultsOut.edges[0].cursor;
      console.log('İlk sonuçlar:', resultsOut);
    }

    // DevChat'ten gelen sonuçları kontrol et
    const resultsOut2 = await results({
      process: 'cSh3iRyE3_qGdRzczwkZxG7bHfFC3Kq7xhO4toPbp9k',
      from: cursor,
      sort: 'ASC',
      limit: 50,
    });

    // Gelen mesajları işle
    for (const element of resultsOut2.edges.reverse()) {
      cursor = element.cursor;
      console.log('Eleman Verisi:', element.node.Messages);

      for (const msg of element.node.Messages) {
        console.log('Mesaj Etiketleri:', msg.Tags);
      }

      // Mesajları filtrele ve işle
      const messagesData = element.node.Messages.filter(e => e.Tags.length > 0 && e.Tags.some(f => f.name == 'Action' && f.value == 'Say'));
      console.log('Filtrelenmiş Mesaj Verisi:', messagesData);
      for (const messagesItem of messagesData) {
          const event = messagesItem.Tags.find(e => e.name == 'Event')?.value || 'Message in CoinssporRoom';
          const sendTest = event + ' : ' + messagesItem.Data;
          console.log('Yakalanan Mesaj:', sendTest);
          ws.send(sendTest); // WebSocket üzerinden mesajı gönder
      }
    }

  } catch (error) {
    console.error('DevChatCheking hatası:', error);
    console.error('Hata detayları:', error.message);
  } finally {
    setTimeout(DevChatCheking, 5000);
  }
}

// DevChatCheking fonksiyonunu çağır
DevChatCheking();
