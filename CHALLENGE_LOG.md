# CHALLENGE_LOG

## Başlangıç noktası

- Ürün: İzlek, kurumların müşteri taleplerini atadığı, yanıtladığı ve ilk yanıt SLA'sını izlediği destek masası MVP'si.
- Geçen haftanın son commit'i: [`e8245da`](https://github.com/memirkincal/izlek-destek-masasi/commit/e8245daf6db1a20cab0acf815a88f616b2eddafa).
- Canlı URL: [https://izlek-destek-masasi.onrender.com](https://izlek-destek-masasi.onrender.com). Bu haftaki çalışma henüz canlıya alınmadı; URL mevcut önceki sürümü gösteriyor.
- Kaynak repo: [memirkincal/izlek-destek-masasi](https://github.com/memirkincal/izlek-destek-masasi).
- Bu ürüne kim, neden para ödüyor? Destek ekipleri; taleplerin kaybolmaması, sorumlunun belli olması, yanıt süresinin izlenmesi ve ekip işinin tek yerde yürütülmesi için destek masası yazılımına ödeme yapar. İzlek'in kurumsal ölçekte bu değeri kanıtladığı iddia edilmiyor.

## Acı

- Kullanıcı: Bir sorunu yaşayan ve form kategorisi seçmeden yardım isteyen müşteri; ayrıca aynı sorunu tekrar tekrar yanıtlayan destek temsilcisi.
- Acı: Müşteri doğru çözüm yolunu bulamıyor; ekip aynı konudaki talepleri ayrı ayrı okuyup benzer yanıtları yeniden yazıyor. Kaynaklarda, bazı yeni Zendesk kullanıcılarının geniş iş akışı ve SLA ayarlarını öğrenmek için zaman harcadığı anlatılıyor: [G2 kullanıcı yorumu](https://www.g2.com/products/zendesk-for-customer-service/reviews?hubspot_post-cta=anchor&page=6&source=search%23reviews%3D), [Capterra kullanıcı yorumu](https://www.capterra.com/p/164283/Zendesk/reviews/). Bunlar tekil yorumlardır; bütün kullanıcıları temsil etmez.
- Bu haftanın kişisel yönü: Sınıf arkadaşlarının doğal dille talep, bilgi kaynağı, benzer talep, gizlilik ve insan devri fikirlerini tek bir destek yolculuğunda birleştirmek.

## Bu haftanın vaadi

> Talep sahibi sorununu kendi sözleriyle anlatır. Gemini anahtarı ayarlıysa İzlek maskelenmiş mesajı ve yerel bilgi bankasını Gemini'ye gönderir; model kaynak kimliğiyle yanıt taslağı veya insan devri kararı verir. Rails kaynak kimliğini doğrular. Anahtar yoksa yerel eşleştirme, API hata verirse açıkça etiketlenmiş yerel yedek çalışır. Temsilci aynı ticket'ta ilgili talepleri, kaynaklı taslağı ve yalnızca ekibe görünen notları kullanır.

## Yapılanlar ve kanıt

- `/yardimci` akışı eklendi: talep sahibi serbest metinle soru sorabiliyor; kaynaklı yanıt taslağı ve kaynak başlığı gösteriliyor; kaynak yoksa ya da kullanıcı isterse talep otomatik açılıp temsilci kuyruğuna aktarılıyor. Kanıt: `app/controllers/support_agent_controller.rb`, `app/views/support_agent/show.html.erb`, `config/routes.rb`.
- Gemini desteği eklendi: `GEMINI_API_KEY` ayarlıysa sunucu Interactions API'ye hassas örüntüleri maskelenmiş kullanıcı mesajı ve yerel YAML kaynaklarını yollar. Yapılandırılmış sonuçta yalnızca mevcut bir kaynak kimliği seçilebilir; Rails bunu doğrular. Kaynak yoksa ticket açılır; API çağrısı başarısızsa yerel yedek kullanılır ve arayüz bunu belirtir. Kanıt: `app/services/gemini_support_assistant.rb`, `app/controllers/support_agent_controller.rb`, `config/support_knowledge.yml`.
- Serbest metindeki e-posta, telefon, kimlik numarası, kart numarası ve bilinen API sırrı örüntüleri ticket'a kaydedilmeden ve Gemini'ye gönderilmeden önce maskelenir. Maske tüm kişisel veriyi bulmayı garanti etmez; demo içeriği hayalî tutulmalı. İstek metni ve ticket açıklaması sunucu loglarında filtrelenir. Kanıt: `app/services/privacy_masker.rb`, `config/initializers/filter_parameter_logging.rb`.
- Temsilci görünümüne ilgili ticket'lar ve kaynaklı yanıt taslakları eklendi. Ekip içi notlar talep sahiplerine gösterilmez; bu notlar ilk yanıt SLA'sını durdurmaz. Müşteriye gidecek yanıtta riskli sayı/sır örüntüsü bulunursa gönderim için açık onay istenir. Kanıt: `app/controllers/tickets_controller.rb`, `app/views/tickets/show.html.erb`, `app/services/reply_safety.rb`.
- Tamamen hayalî yerel demo talepleri ödeme/sipariş örüntülerini göstermesi için genişletildi. `db/seeds.rb` yalnızca development ortamında çalışır; gerçek müşteri verisi eklenmedi.
- Yerel demo adımı: `bin/rails db:prepare`, `bin/rails db:seed`, sonra `can.ozkan@example.com` / `IzlekDemo2026!` ile giriş yapıp `/yardimci` sayfasında “Faturamı indiremedim” yaz. Kaynaklı yanıtı gör; “Temsilciye aktar” ile ticket aç. Temsilci görünürlüğü için `mert@izlek.demo` / `IzlekDemo2026!` hesabıyla gelen kutusuna geç. Bu hesaplar yalnızca yerel development seed verisidir.
- Gemini entegrasyon kodu hazır; geçerli anahtar henüz `GEMINI_API_KEY` ortam değişkenine güvenli biçimde konmadı. Yeni anahtarla gerçek çağrı elle doğrulanmalı. Yeni çalışma ağacındaki değişiklikler henüz commit edilmedi veya dağıtılmadı; canlı URL önceki sürümü gösterir.
- Yerel doğrulama (25 Ekim 2026): SQLite geliştirme veritabanında beş migration `up`; `db:prepare db:seed` başarılı. Gerçek klasör yolundan Rails sunucusu açıldı; `/up` ve giriş sayfası HTTP 200 döndü. Demo talep sahibiyle giriş yapılıp `/yardimci` ekranında “Faturamı indiremedim” sorusuna “Fatura PDF'i indirme” kaynağıyla yerel yanıt alındı. `ruby bin/rails test`: 34 test, 194 assertion, sıfır hata; RuboCop: 57 dosyada ihlal yok; Brakeman: sıfır uyarı; Bundler Audit: açık yok; üretim asset derlemesi başarılı. Testler Gemini protokolünü sahte HTTP yanıtıyla doğruladı.
- Gerçek Gemini API çağrısı ve yeni canlı dağıtım henüz doğrulanmadı; ortamda güvenli yeni `GEMINI_API_KEY` ayarlı değil. Bu kayıt başarılı canlı model çağrısı iddiası değildir.
- Vaat edilip yapılmayanlar: embedding tabanlı arama, dış web sitesine gömülen widget, gerçek ödeme/CRM entegrasyonu, otomatik kök neden analizi ve dış müşteriye otomatik e-posta. Model yanıttaki kaynağı yalnızca yerel YAML bilgi bankasından seçer.

## Zaman

- İnsan zamanı: Bu haftaki kodlama/inceleme süresi ayrı bir zamanlayıcıyla ölçülmedi; sayı uydurulmadı.
- Agent zamanı: Çalışma oturumundaki araç ve düzenleme süresi ayrıca ölçülmedi; kodlama, önceki fikir tartışmalarıyla aynı oturumda yapıldı.
- İlk prompt (olduğu gibi):

```text
C:\Users\memir\OneDrive\Desktop\26-27 güz\Ruby\odev-3 burada geçen hafta ödev yapmıştık bunun için olan mdleri incele ardından "C:\Users\memir\OneDrive\Desktop\26-27 güz\Ruby\odev-4\odev.pdf" bu dosyayla devam edicez hoca ödevimizi copy paste olduğu için beğenmedi ve geçen hafta sunamadım hastaydım o yüzden bu hafta daha güzel bir şekilde devam etmeliyiz.

öncelikle sadece geçen haftanın odev-3 klasöründeki md leri incelemeni sonrasında odev-4 içindeki pdf i okuyup analiz etmeni istiyorum.
```

## Karar

**Devam et ve yönünü değiştir.** İzlek'in çalışan ticket/SLA temelini koruyup bu haftaki ürünü kaynak gösteren destek yardımı, gizlilik maskesi ve insan devri etrafında yeniden odaklamak mantıklı. İş kararı, “daha fazla ekran eklemek” değil; bir sorunun kaynaktan çözülemediği anda güvenli biçimde insana ulaşmasını kanıtlamak.

Bu sürüm tamamlanmış kurumsal AI ürünü değildir. Değeri, Gemini'yi yerel kaynakla sınırlaması, kaynak kimliğini Rails tarafında doğrulaması ve cevap için dayanak yoksa talebi insana aktarmasıdır. Sunumda faturayı bulma → Gemini'nin yanıtını ve seçtiği kaynağı görme → temsilciye aktarma akışı gösterilecek. Bu demo ancak iptal edilmiş anahtar yerine yeni anahtar ortam değişkenine konup gerçek çağrı doğrulandıktan sonra “çalışan Gemini entegrasyonu” diye sunulmalı; gerçek müşteri verisi kullanılmamalı.
