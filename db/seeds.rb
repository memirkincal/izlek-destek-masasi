samples = [
  { name: "Ada Yılmaz", email: "ada.yilmaz@example.com", subject: "Ödeme alındı ama hesabım hâlâ ücretsiz görünüyor", body: "Merhaba, yıllık plana geçtim ve kartımdan ödeme alındı. Ancak hesabımda hâlâ ücretsiz plan yazıyor. Yardımcı olabilir misiniz?", priority: "urgent", assignee: "Ece Demir", status: "new", age: 218.minutes },
  { name: "Can Özkan", email: "can.ozkan@example.com", subject: "Son faturamı indiremedim", body: "Faturalar bölümündeki indirme bağlantısına bastığımda boş bir sayfa açılıyor. PDF olarak paylaşabilir misiniz?", priority: "high", assignee: "Mert Kaya", status: "new", age: 203.minutes },
  { name: "Elif Kaya", email: "elif.kaya@example.com", subject: "Ekibime yeni kullanıcı eklemek istiyorum", body: "Yeni çalışma arkadaşım bugün başladı. Ekip hesabımıza davet göndermek için hangi adımları izlemeliyim?", priority: "normal", assignee: "Deniz Arslan", status: "open", age: 94.minutes },
  { name: "Bora Şahin", email: "bora.sahin@example.com", subject: "Mobil uygulamada oturumum kapanıyor", body: "Uygulamayı her açtığımda yeniden giriş yapmam gerekiyor. Bu durumu inceleyebilir misiniz?", priority: "normal", assignee: "Ece Demir", status: "open", age: 181.minutes, reply: "Merhaba Bora, yardımcı olayım. Hangi işletim sistemi sürümünü kullanıyorsun? Bu sırada uygulamayı güncellediğinden emin olabilir misin?" },
  { name: "Selin Aydın", email: "selin.aydin@example.com", subject: "Veri aktarımı tamamlandı", body: "Dışa aktardığım dosyanın içe aktarımı başarıyla tamamlandı, teşekkürler.", priority: "low", assignee: "Mert Kaya", status: "solved", age: 1.day, reply: "Merhaba Selin, aktarımın tamamlandığını doğruladım. Yardımcı olabileceğim başka bir şey olursa bize yazabilirsin." },
  { name: "Emre Demir", email: "emre.demir@example.com", subject: "Bildirim ayarları hakkında soru", body: "Haftalık özet bildirimlerini nereden kapatabilirim?", priority: "low", assignee: "Deniz Arslan", status: "solved", age: 2.days, reply: "Profil > Bildirimler bölümünden haftalık özet seçeneğini kapatabilirsin." }
]

samples.each do |sample|
  ticket = Ticket.find_or_initialize_by(subject: sample[:subject])
  next if ticket.persisted?

  created_at = Time.current - sample[:age]
  ticket.assign_attributes(requester_name: sample[:name], requester_email: sample[:email], description: sample[:body], priority: sample[:priority], assignee: sample[:assignee], status: sample[:status], created_at: created_at, updated_at: created_at, response_due_at: created_at + Ticket::FIRST_RESPONSE_SLA)
  ticket.save!
  if sample[:reply]
    response_at = created_at + 25.minutes
    ticket.replies.create!(author_name: sample[:assignee], body: sample[:reply], created_at: response_at)
    ticket.update!(first_response_at: response_at, updated_at: response_at)
  end
  ticket.update!(solved_at: 3.hours.ago) if sample[:status] == "solved"
end
