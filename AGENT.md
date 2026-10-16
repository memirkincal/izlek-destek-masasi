# İzlek ajan ve geliştirme notları

## Amaç ve kapsam

Bu depo, Ruby on Rails 8 ile geliştirilmiş eğitim amaçlı multi-tenant destek masası SaaS MVP'sidir. Öncelik, kayıt/giriş → kurum çalışma alanı → talep oluşturma → atama/açma → ilk yanıt → çözme/yeniden açma akışının anlaşılır ve tenant sınırları içinde kalmasıdır. Ürün ilhamı README'de belirtilmiştir; arayüzde başka bir markanın adı veya logosu kullanılmamalıdır.

## Mimari

- `Ticket`: doğrulama, durum geçişleri, 4 saatlik ilk yanıt SLA'sı, kalan süre ve kuyrukta gösterilen sonraki eylem.
- `Reply`: herkese açık ilk yanıt zamanını kaydeder ve ilk yanıt bekleyen yeni talebi `open` durumuna alır.
- `User` / `Organization`: parola tabanlı oturum, yönetici/temsilci/talep sahibi rolleri ve tenant ilişkisi.
- `TicketsController`: tenant-scoped kuyruk, arama/filtreleme, talep oluşturma, atama, yanıt ve durum eylemleri. Requester kendi taleplerini görür; support staff yalnızca kendi kurumunu görür.
- `RegistrationsController` / `TeamMembersController`: yeni kurum ve yönetici kaydı, yöneticinin aynı kuruma yeni ekip üyesi eklemesi.
- `app/views/tickets`: kuyruk, yeni talep formu, talep ayrıntısı ve konuşma görünümü.
- `app/views/shared/_flash_messages.html.erb`: erişilebilir, özel tasarımlı toast bildirimleri; tarayıcı `alert()` penceresi kullanılmaz.
- `config/locales`: Türkçe ve İngilizce arayüz metinleri.
- `test/models/ticket_test.rb`: zaman ve durum kuralları (`travel_to`).
- `test/integration/ticket_workflow_test.rb`: kullanıcı açısından uçtan uca temel akış.

## Değişiklik kuralları

1. SLA veya durum akışı değişince model testlerini sabit zamanla güncelle; yeni davranışı entegrasyon testinde de doğrula.
2. Gerçek kişi verisi/üretim verisi ekleme. `db/seeds.rb` yalnızca hayalî demo kayıtları içermeli ve tekrar çalıştırılabilir kalmalı.
3. `config/master.key`, credentials anahtarı, veritabanı ve log dosyalarını sürüm kontrolüne ekleme. Deploy gizlileri yalnızca sağlayıcının ortam değişkenlerinde tutulmalı.
4. Üretimde PostgreSQL, geliştirme/testte SQLite kullanılmasını sağlayan `config/database.yml` ile `render.yaml` değişikliklerini birlikte gözden geçir. Render `DATABASE_URL`, Supabase Session pooler'a (5432) bağlanmalı; Transaction pooler kullanma.
5. Arayüz değişikliklerinde Türkçe metinleri, klavye etiketlerini, boş/hata durumlarını ve küçük ekran düzenini koru.
6. Tam ürün veya haricî entegrasyon varmış gibi davranma. Çalışmayan özelliği README'deki “Yapamadıklarım” listesine ekle.

## Yerel doğrulama

```sh
bundle install
bin/rails db:prepare test
```

Üretim paketi/asset derlemesi için:

```sh
RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile
```

Başarılı test çıktısı alınmadan testlerin geçtiğini bildirme. Dağıtımın hazır olduğunu ancak sağlayıcıda deploy tamamlanıp `/up` yanıtı doğrulandıktan sonra söyle.

## Bilinen sınırlar

E-posta doğrulama, otomatik davet, SMTP sağlayıcısı, ekler, mesai takvimine göre SLA, MFA, denetim günlüğü, billing ve analitik bu ödev diliminde yoktur. SLA takvim saati ile ilerler. Tenant sınırlarını koruyan temel testler olsa da uygulamayı gerçek müşteri datasıyla kullanmadan önce güvenlik/operasyon denetimi gerekir.
