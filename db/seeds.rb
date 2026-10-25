if Rails.env.development?
organization = Organization.find_or_create_by!(name: "İzlek Demo")

accounts = [
  { name: "Ece Demir", email: "ece@izlek.demo", role: "admin" },
  { name: "Mert Kaya", email: "mert@izlek.demo", role: "agent" },
  { name: "Deniz Arslan", email: "deniz@izlek.demo", role: "agent" }
]

accounts.each do |account|
  User.find_or_create_by!(email_address: account[:email]) do |user|
    user.name = account[:name]
    user.role = account[:role]
    user.organization = organization
    user.password = "IzlekDemo2026!"
    user.password_confirmation = "IzlekDemo2026!"
  end
end

agents = organization.users.where(role: %w[admin agent]).index_by(&:name)

samples = [
  { name: "Ada Yılmaz", email: "ada.yilmaz@example.com", subject: "Ödeme alındı ama hesabım hâlâ ücretsiz görünüyor", body: "Merhaba, yıllık plana geçtim ve kartımdan ödeme alındı. Ancak hesabımda hâlâ ücretsiz plan yazıyor. Yardımcı olabilir misiniz?", priority: "urgent", assignee: "Ece Demir", status: "new", age: 218.minutes },
  { name: "Can Özkan", email: "can.ozkan@example.com", subject: "Son faturamı indiremedim", body: "Faturalar bölümündeki indirme bağlantısına bastığımda boş bir sayfa açılıyor. PDF olarak paylaşabilir misiniz?", priority: "high", assignee: "Mert Kaya", status: "new", age: 203.minutes },
  { name: "Elif Kaya", email: "elif.kaya@example.com", subject: "Ekibime yeni kullanıcı eklemek istiyorum", body: "Yeni çalışma arkadaşım bugün başladı. Ekip hesabımıza davet göndermek için hangi adımları izlemeliyim?", priority: "normal", assignee: "Deniz Arslan", status: "open", age: 94.minutes },
  { name: "Bora Şahin", email: "bora.sahin@example.com", subject: "Mobil uygulamada oturumum kapanıyor", body: "Uygulamayı her açtığımda yeniden giriş yapmam gerekiyor. Bu durumu inceleyebilir misiniz?", priority: "normal", assignee: "Ece Demir", status: "open", age: 181.minutes, reply: "Merhaba Bora, yardımcı olayım. Hangi işletim sistemi sürümünü kullanıyorsun? Bu sırada uygulamayı güncellediğinden emin olabilir misin?" },
  { name: "Selin Aydın", email: "selin.aydin@example.com", subject: "Veri aktarımı tamamlandı", body: "Dışa aktardığım dosyanın içe aktarımı başarıyla tamamlandı, teşekkürler.", priority: "low", assignee: "Mert Kaya", status: "solved", age: 1.day, reply: "Merhaba Selin, aktarımın tamamlandığını doğruladım. Yardımcı olabileceğim başka bir şey olursa bize yazabilirsin." },
  { name: "Emre Demir", email: "emre.demir@example.com", subject: "Bildirim ayarları hakkında soru", body: "Haftalık özet bildirimlerini nereden kapatabilirim?", priority: "low", assignee: "Deniz Arslan", status: "solved", age: 2.days, reply: "Profil > Bildirimler bölümünden haftalık özet seçeneğini kapatabilirsin." },
  { name: "Duru Eren", email: "duru.eren@example.com", subject: "Karttan ödeme çekildi ama siparişim görünmüyor", body: "Banka uygulamamda ödeme onaylandı. Siparişlerim sayfasında yeni sipariş yok ve onay e-postası da gelmedi.", priority: "urgent", assignee: "Ece Demir", status: "new", age: 18.minutes },
  { name: "Kaan Yıldız", email: "kaan.yildiz@example.com", subject: "Ödeme tamamlandı, hesabım hâlâ ücretsiz", body: "Kartımdan ücret alındı fakat hesabımda hâlâ ücretsiz plan yazıyor. Tekrar ödeme yapmalı mıyım?", priority: "high", assignee: "Mert Kaya", status: "new", age: 34.minutes },
  { name: "Sude Akın", email: "sude.akin@example.com", subject: "Satın alma sonrası ürün hesabıma düşmedi", body: "Ödeme ekranı başarılı dedi ve kart ekstresinde çekim var. Ancak hesabımda ürün görünmüyor.", priority: "high", assignee: "Deniz Arslan", status: "open", age: 51.minutes },
  { name: "Eren Koç", email: "eren.koc@example.com", subject: "Aynı ödeme için yeniden çekim olmasından endişeliyim", body: "Banka hareketinde tahsilat görünüyor ama sipariş onayı gelmedi. Mükerrer çekim olmadan kontrol edebilir misiniz?", priority: "normal", assignee: "Ece Demir", status: "open", age: 67.minutes }
]

samples.each do |sample|
  requester = organization.users.find_or_create_by!(email_address: sample[:email]) do |user|
    user.name = sample[:name]
    user.role = "requester"
    user.password = "IzlekDemo2026!"
    user.password_confirmation = "IzlekDemo2026!"
  end

  ticket = organization.tickets.find_or_initialize_by(subject: sample[:subject])
  created_at = Time.current - sample[:age]
  ticket.assign_attributes(
    requester_user: requester,
    requester_name: requester.name,
    requester_email: requester.email_address,
    assignee_user: agents[sample[:assignee]],
    assignee: sample[:assignee],
    description: sample[:body], priority: sample[:priority], status: sample[:status],
    created_at: created_at, updated_at: created_at,
    response_due_at: created_at + Ticket::FIRST_RESPONSE_SLA
  )
  ticket.save!

  if sample[:reply]
    response_at = created_at + 25.minutes
    reply = ticket.replies.find_or_initialize_by(body: sample[:reply])
    reply.assign_attributes(user: agents[sample[:assignee]], author_name: sample[:assignee], created_at: response_at)
    reply.save!
    ticket.update!(first_response_at: response_at, updated_at: response_at)
  end

  ticket.update!(solved_at: 3.hours.ago) if sample[:status] == "solved"
end
end
