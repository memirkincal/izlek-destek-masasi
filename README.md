# İzlek — Destek masası

[![CI](https://github.com/memirkincal/izlek-destek-masasi/actions/workflows/ci.yml/badge.svg)](https://github.com/memirkincal/izlek-destek-masasi/actions/workflows/ci.yml)

İzlek, destek taleplerini tek bir açık kuyruğa toplayan ve ekibin sıradaki işi görmesini sağlayan küçük bir destek masasıdır. İlham kaynağı Zendesk'in müşteri destek talebi iş akışıdır; İzlek bağımsız bir öğrenci projesidir ve orijinal ürünün markasını kullanmaz.

**Canlı uygulama:** https://izlek-destek-masasi.onrender.com (yayın kurulumu henüz doğrulanmadı)  
**Kaynak kodu:** https://izlek-destek-masasi.onrender.com (yayın kurulumu henüz doğrulanmadı)

## Ürünün ana iş akışı

1. Müşteri talep oluşturur; talep `new` durumunda kuyruğa girer.
2. Bir ekip üyesi atanır ve talep `open` yapılır.
3. Ekip ilk herkese açık yanıtı gönderir. Bu yanıt dört saatlik ilk yanıt süresini durdurur.
4. Ekip çözümü doğrulayıp talebi `solved` yapar; gerekirse yeniden açar.

Kuyrukta durum, öncelik, atanan kişi, yanıt için kalan süre ve **sıradaki net eylem** birlikte görünür. Son 30 dakikada SLA uyarısı verilir, süre geçtiyse açıkça gösterilir. Örnek kayıtlar sunum için oluşturulmuş hayalî verilerdir.

## Faz 1 — Kısa araştırma

> Veriler Fortune'un 2025 ABD Fortune 500 listesi (2024 mali yıl verileri) ve Zylo'nun 2025 SaaS Management Index raporundandır. Fortune 500 şirketleri Fortune tarafından gelire göre sıralanır; tek bir ortak “değerleme” tanımı yoktur. Piyasa değeri halka açık şirketlerde hisse fiyatıyla değişir ve özel şirketler için karşılaştırılabilir değildir. Bu nedenle değerleme aralığı yalnızca yaklaşık, halka açık liste üyeleri için piyasa değeri göstergesi olarak verilmiştir.

| Soru | Yaklaşık cevap | Kaynak ve yorum |
|---|---:|---|
| Fortune 500 şirketlerinin piyasa değeri aralığı | Yaklaşık **2 milyar–3,34 trilyon USD** (halka açık üyeler; mali yıl sonu civarı) | Fortune'un 2025 tam listesi şirket bazında piyasa değeri sütunu sunar; Apple için 3.337 trilyon USD gösterir. Liste piyasa değerine göre sıralanmadığından alt uç yuvarlak bir yaklaşık değerdir ve tarih/halka açıklık durumuna göre değişir. [Fortune 500 tam liste](https://fortune.com/ranking/fortune500/2025/) |
| Çalışan sayısı aralığı | Yaklaşık **486–2,1 milyon kişi** | Fortune'un 2025 listesi toplamda 31 milyon çalışan bildirir. Walmart 2,1 milyon çalışanla listenin en büyük işvereni; en küçük çalışan sayılarından biri A-Mark Precious Metals'in 486 çalışanıdır. [Fortune 500](https://fortune.com/ranking/fortune500/2025/), [Fortune: çalışan sayısı uçları](https://fortune.com/2025/06/02/fortune-500-employees-headcount-workforce-largest-smallest/) |
| Bir büyük şirketin kullandığı SaaS ürünü sayısı | 10.000+ çalışanlı kuruluşlarda ortalama **660 uygulama** | Zylo 2025 endeksi bu büyüklükteki kuruluşlar için 660 uygulama bildirir; bu örneklem tüm Fortune 500 şirketlerinin sayımı değildir. [Zylo 2025 endeksi duyurusu](https://www.prweb.com/releases/2025-saas-management-index-reveals-first-increase-in-average-saas-spend-in-three-years-amid-rising-vendor-costs-and-rapid-ai-adoption-302351642.html) |
| SaaS'a yıllık harcama | 10.000+ çalışanlı kuruluşlarda ortalama **284 milyon USD** | Aynı Zylo raporundaki büyük işletme segmenti. Genel örneklem ortalaması 49 milyon USD; Fortune 500 ölçeğine yakın karşılaştırma için 284 milyon USD kullanıldı. Bu, Fortune 500'e özel bir toplam değildir. [Zylo 2025 endeksi duyurusu](https://www.prweb.com/releases/2025-saas-management-index-reveals-first-increase-in-average-saas-spend-in-three-years-amid-rising-vendor-costs-and-rapid-ai-adoption-302351642.html) |

Fortune 2025 listesi toplam **19,9 trilyon USD gelir** ve **31 milyon çalışan** bildirir. Bu ölçek, destek yazılımının neden kritik olduğunu açıklar: küçük bir ilk yanıt gecikmesi çok sayıda müşteri etkileşimini etkileyebilir. [Fortune 500 2025](https://fortune.com/ranking/fortune500/2025/)

### SaaS seçimi ve Fortune 500 kanıtı

Seçilen ürün, kurumsal destek masası SaaS'ı **Zendesk**. Comcast Business'ın yayımladığı alt işleyen listesinde “Zendesk” müşteri desteği sağlayıcısı olarak yer alıyor. Comcast 2025 Fortune 500'de **35. sıradadır**. Bu, en az bir Fortune 500 şirketinin Zendesk'i kullandığına dair birincil şirket belgesidir; belge, kamuya açık SaaS fiyatı veya sözleşme tutarı açıklamaz. [Comcast Business alt işleyen listesi (PDF)](https://business.comcast.com/~/media/business_comcast_com/PDFs/privacy/Comcast%20Business%20Subprocessor%20List%20%28260323%29.pdf), [Fortune 2025 sıralaması](https://fortune.com/ranking/fortune500/2025/)

Zendesk'in çekirdeğini seçme nedeni, kurumsal ölçekte gerçek bir kuyruk, atama, yanıt, zaman kuralı ve çözüm akışına sahip olmasıdır. Ticari ürünün gerçek kaynak kodu açık değildir; dolayısıyla 300.000 satır bu ödev için ölçek varsayımıdır, doğrulanmış bir Zendesk kod sayımı değildir.

### Kullanıcı acısı ve İzlek'teki karşılığı

Zendesk kullanıcı yorumlarında yeni kullanıcıların ayarlar/yapılandırma seçeneklerini bunaltıcı bulduğunu belirten yorumlar bulunuyor. [G2 kullanıcı yorumları](https://www.g2.com/products/zendesk-for-customer-service/reviews). Capterra'daki kullanıcılar da raporlama/analitik kullanımının karmaşık olabildiğini yazıyor. [Capterra kullanıcı yorumları](https://www.capterra.com/p/164283/Zendesk/reviews/)

**Sunum cümlesi:** “Yeni destek ekibi üyelerinin, yorumlarda anlatılan karmaşık yapılandırma yükünü yaşamadan sıradaki işi görmesine yardımcı olmak için İzlek tek bir kuyrukta SLA'yı, sorumluyu ve sonraki eylemi birlikte gösteriyor.” Bu, ürünün yönetim ve raporlama kapsamını bütünüyle çözdüğü iddiası değildir; seçilen akış içinde işin nereden devam edeceğini görünür kılar.

## Faz 2 — Maliyet ve süre tahmini

| Ölçüm | Tahmin / gerçekleşen | Yöntem |
|---|---|---|
| Zendesk kaynak kodu | Yaklaşık **300.000 satır** ölçek varsayımı | Kaynak kodu özel olduğu için gerçek LOC kamuya açık değil. Ödevin belirttiği kurumsal ölçeğe göre varsayım; satır sayımı değil. |
| Ajanla çekirdek akışı üretmek (ön tahmin) | **2–3 gün** | Bir akışı kapsamlandırma, Rails uygulama, arayüz, test, dağıtım ve hata düzeltme adımları için planlama tahmini. Bu, 300.000 satırın kopyalanacağı anlamına gelmez. |
| Ajanla çekirdek akışı üretmek (gerçekleşen) | Yaklaşık **1 çalışma oturumu / 1 gün** | Bu oturumda Rails uygulaması, testler ve dağıtım yapılandırması hazırlandı; geçen takvim süresi iş gününe eşit değildir. Sunum öncesi öğrenci tarafından canlı denetim ve prova gerekir. |
| Token/API maliyeti | **0 USD ek API faturası**; mevcut asistan aboneliğinin oturum başı parasal maliyeti ayrı ölçülemiyor | Bu çalışma ayrı bir API anahtarı/faturasıyla değil, mevcut Codex oturumuyla yapıldı. Aboneliğin sabit bedeli ve hesap geneli kullanım bu tek projeye güvenilir biçimde ayrıştırılamıyor; bu yüzden sıfır toplam maliyet iddiası değildir. |

## Çalıştırma

Gereksinimler: Ruby 3.4.7, Bundler ve SQLite (geliştirme/test). Üretimde PostgreSQL kullanılır.

```sh
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/rails server
```

Uygulama `http://localhost:3000` adresinde açılır. Testleri çalıştırmak için:

```sh
bin/rails db:prepare test
```

SLA ve durum geçişi testleri `travel_to` ile sabit zaman kullanır. GitHub Actions aynı komutu her push ve pull request'te çalıştırır.

## Dağıtım

Dağıtım hedefi Render'dır. `render.yaml` web servisini ve PostgreSQL veritabanını tanımlar. Render'da Blueprint'i bağladıktan sonra `RAILS_MASTER_KEY` için `config/master.key` içeriği gizli ortam değişkeni olarak girilmelidir. Anahtar repoya konmamalıdır. Yayın/URL hesabın ve Blueprint kurulumunun tamamlanmasına bağlıdır.

## Yapamadıklarım

- Ticari Zendesk ürününün gerçek satır sayısını doğrulayamıyorum; kod kapalı kaynak. 300.000 LOC yalnızca ödev için açıkça belirtilmiş ölçek varsayımıdır.
- Fortune 500 için tek ve sabit bir şirket değerleme aralığı yoktur: özel şirketlerin piyasa değeri yayımlanmaz, halka açıkların değeri tarih ve hisse fiyatına göre değişir. Yukarıdaki aralık yaklaşık piyasa değeri göstergesidir.
- Zylo'nun SaaS adet/harcama verileri Fortune 500 şirketlerinin tek tek ölçümü değil, kuruluş büyüklüğüne göre örneklem ortalamasıdır.
- Uygulama eğitim demosudur: kullanıcı girişi/rol yetkisi, e-posta bildirimi, çoklu müşteri izolasyonu, mesai takvimi, tatil günlerini hesaba katan SLA, dosya eki, raporlama ve üretim güvenlik sertleştirmesi yoktur. Gerçek müşteri verisi girmeyin.
- Token başına parasal tüketim mevcut abonelikte görev özelinde raporlanmadığı için bağımsız doğrulanamıyor.
- Canlı URL ve CI rozeti, GitHub deposu ve Render yayını tamamlandıktan sonra gerçek adreslerle güncellenecektir.

## Ajan çalışma notları

Kodun mimarisi, doğrulama komutları ve katkı sınırları için [`AGENT.md`](AGENT.md) dosyasına bakın.


