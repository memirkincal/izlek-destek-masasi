# İzlek — Destek çalışma alanı / Support workspace

[![CI](https://github.com/memirkincal/izlek-destek-masasi/actions/workflows/ci.yml/badge.svg)](https://github.com/memirkincal/izlek-destek-masasi/actions/workflows/ci.yml)

**Canlı uygulama / Live app:** [izlek-destek-masasi.onrender.com](https://izlek-destek-masasi.onrender.com) — Render üzerinde canlı; son doğrulanan dağıtım `be188ff`.
**Kaynak / Source:** [GitHub](https://github.com/memirkincal/izlek-destek-masasi)

---

## Türkçe

### Ürün ve ilham kaynağı

İzlek, müşteri destek taleplerini kurumlara özel çalışma alanlarında toplayan, sorumluyu ve sıradaki işi görünür kılan bir destek masası SaaS MVP'sidir. Ürün akışı için **Zendesk'in destek talebi kuyruğu** incelendi: talep alma, atama, ilk yanıt, çözme ve yeniden açma. İzlek bağımsız bir öğrenci projesidir; Zendesk kodunu, adını veya logosunu kullanmaz.

### Aort dilimi: talebin oluşturulmasından çözüme

1. Kurum yöneticisi kayıt olur; kuruma özel çalışma alanı oluşur. Yönetici oturum açtıktan sonra **Ekip üyeleri** ekranından istediği zaman yeni e-posta adresiyle temsilci veya talep sahibi hesabı oluşturabilir. E-posta adresi platform genelinde benzersizdir; mevcut kullanıcı yeniden eklenmez, kendi hesabıyla giriş yapar. Otomatik davet e-postası gönderilmez; yönetici giriş bilgilerini üyeye iletir.
2. Talep sahibi yeni talep açar. Talep `new` olur ve oluşturulma anından itibaren **4 saatlik ilk yanıt SLA'sı** başlar.
3. Aynı kurumdaki temsilci talebi açar, kendine/ekip arkadaşına atar ve herkese açık yanıt yazar. İlk yanıt zamanlayıcıyı durdurur.
4. Temsilci talebi çözer. Talep sahibi gerekirse yeniden açıp yanıtlayabilir.
5. Kuyrukta SLA durumu ve **sıradaki eylem** birlikte görünür. Son 30 dakikada risk, süre aşımında gecikme bildirilir.

Yönetici, temsilci ve talep sahibi rolleri vardır. Talep sahipleri yalnızca kendi taleplerini; destek ekibi yalnızca kendi kurumunun taleplerini görür. Bu akış, gerçek müşteri datası için güvenlik denetiminden geçmiş tam bir kurumsal help desk değildir.

### Araştırma — Fortune 500 ve SaaS

Veriler Fortune'un 2025 ABD Fortune 500 listesi (2024 mali yılı) ile Zylo'nun 2025 SaaS Management Index raporundandır. Fortune 500 şirketleri **gelire** göre sıralanır; bu listeyi tek bir “şirket değerlemesi” aralığı gibi okumamak gerekir. Halka açık şirketlerin piyasa değeri fiyat ve tarihe göre değişir; özel şirketlerin karşılaştırılabilir piyasa değeri çoğu zaman yayımlanmaz.

| Ödev sorusu | Cevap / tahmin | Kaynak ve sınır |
|---|---:|---|
| Fortune 500 şirketlerinde piyasa değeri aralığı | Yaklaşık **2 milyar–3,34 trilyon USD** (halka açık üyeler için gösterge) | [Fortune 500 tam liste](https://fortune.com/ranking/fortune500/2025/) Apple için 3,337 trilyon USD piyasa değeri gösterir. Alt uç yaklaşık ve tarihe/halka açıklığa bağlıdır; Fortune listesi piyasa değerine göre sıralanmaz. |
| Çalışan sayısı aralığı | Yaklaşık **486–2,1 milyon kişi** | [Fortune 500 2025](https://fortune.com/ranking/fortune500/2025/) ve [Fortune'un çalışan sayısı uçları](https://fortune.com/2025/06/02/fortune-500-employees-headcount-workforce-largest-smallest/). Walmart yaklaşık 2,1 milyon çalışan bildirir; A-Mark 486 çalışanla en düşük örneklerden biridir. |
| Büyük bir işletmede kullanılan SaaS uygulaması | 10.000+ çalışanlı şirketlerde ortalama **660 uygulama** | [Zylo 2025 Index duyurusu](https://www.prweb.com/releases/2025-saas-management-index-reveals-first-increase-in-average-saas-spend-in-three-years-amid-rising-vendor-costs-and-rapid-ai-adoption-302351642.html). Fortune 500 şirketlerinin tek tek sayımı değildir; büyüklük segmenti ortalamasıdır. |
| SaaS'a yıllık harcama | 10.000+ çalışanlı şirketlerde ortalama **284 milyon USD** | Aynı Zylo kaynağındaki büyük işletme segmenti. Fortune 500 toplamı veya şirket başına doğrulanmış ödeme değildir. Rapor tüm örneklem için 49 milyon USD ortalama da verir. |

Fortune 2025 listesi toplam **19,9 trilyon USD gelir** ve **31 milyon çalışan** bildirir ([Fortune 500](https://fortune.com/ranking/fortune500/2025/)). Bu büyüklük, destek iş akışlarında küçük gecikmelerin çok sayıda müşteri etkileşimine yayılabileceğini anlamaya yardımcı olur.

### SaaS seçimi ve Fortune 500 kanıtı

Seçilen SaaS, kurumsal destek masası **Zendesk**. [Comcast Business alt işleyenler listesi (PDF)](https://business.comcast.com/~/media/business_comcast_com/PDFs/privacy/Comcast%20Business%20Subprocessor%20List%20%28260323%29.pdf) Zendesk'i müşteri destek hizmet sağlayıcısı olarak listeler. [Comcast, Fortune 2025 listesinde 35. sıradadır](https://fortune.com/ranking/fortune500/2025/). Bu belge en az bir Fortune 500 şirketindeki kullanıma dair şirket kaynaklı kanıttır; fiyat veya sözleşme tutarı açıklamaz.

Zendesk'in kaynak kodu kapalı olduğundan **300.000 satır** ödev için ölçek varsayımıdır; doğrulanmış LOC bilgisi değildir. Ürünün asıl ticari değeri ekiplerin müşteri taleplerini kaybetmeden atayıp zamanında yanıtlayabilmesidir.

### Kullanıcı acısı ve “tam ayağına gelen pas”

[G2'de Emily I. G.'nin 19 Mayıs 2026 tarihli Zendesk yorumu](https://www.g2.com/products/zendesk-for-customer-service/reviews?hubspot_post-cta=anchor&page=6&source=search%23reviews%3D) yöneticilerin filtre, iş kuralı, makro ve SLA kurulumlarını öğrenmek/uygulamak için zaman harcayabildiğini söylüyor. [Capterra'da Jane F.'nin 23 Mart 2026 tarihli yorumu](https://www.capterra.com/p/164283/Zendesk/reviews/) yeni kullanıcıların çok sayıdaki özelliği öğrenmesinin zaman alabildiğini belirtiyor. Bunlar tekil kullanıcı görüşleridir; bütün kullanıcıları temsil ettikleri iddia edilmez.

**Seçilen acı:** Yeni destek ekibinin geniş yapılandırma seçenekleri arasında sıradaki işi bulmak için zaman kaybetmesi.

**İzlek'teki çözüm:** Kuyrukta her talebin sorumlusu, SLA riski ve sıradaki eylemi birlikte görünür. Ekip temel akışta talebi yapılandırma/filtre kurmadan oluşturup atayabilir, yanıtlayabilir ve çözebilir. Akış `test/integration/ticket_workflow_test.rb` içinde uçtan uca doğrulanır.

**Sunum cümlesi:** “G2'deki Zendesk kullanıcı yorumu, yöneticilerin SLA ve iş akışı kurulumlarını öğrenmek için zaman harcayabildiğini anlatıyor; İzlek sorumluyu, SLA'yı ve sıradaki eylemi tek kuyrukta göstererek ekibin doğrudan işe başlamasını sağlıyor.” İzlek, gelişmiş otomasyon ve raporlama sorunlarını çözmüş olduğunu iddia etmez.

### Faz 2 — maliyet ve süre tahmini

| Ölçüm | Tahmin / gerçekleşen | Nasıl hesaplandı |
|---|---:|---|
| Zendesk kod büyüklüğü | Yaklaşık **300.000 LOC** | Kaynak kodu kapalı olduğu için gerçek satır sayısı bilinmiyor. Bu, ödevin kurumsal ürün ölçeğine göre belirtilmiş varsayımıdır. |
| Ajanla çekirdek akış ön tahmini | **2–3 gün** | Kapsam, Rails akışı, görünüm, test, deploy yapılandırması ve hata düzeltme için planlama tahmini; 300.000 satırın klonlanması değildir. |
| Bu oturumda gerçekleşen süre | Yaklaşık **1 çalışma oturumu / bir takvim günü** | Bu depo değişikliklerinin hazırlandığı oturum; öğrenci sunum provası ve canlı deploy süresini kapsamaz. |
| Token / abonelik | Bu ödev için **ayrı API faturası ölçülmedi** | Çalışma mevcut Codex oturum/aboneliğiyle yürütüldü. Abonelik bedeli ve hesap genelindeki kullanımı bu projeye doğru biçimde bölmek mümkün olmadığından sayısal maliyet uydurulmadı. |

### Yerel kurulum ve çalıştırma

Gereksinimler: Ruby 3.4.7, Bundler. Geliştirme/testte SQLite; üretimde PostgreSQL kullanılır.

```sh
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/rails server
```

`http://localhost:3000` adresinde açılır. Geliştirme ortamı demo girişi: `ece@izlek.demo` / `IzlekDemo2026!`. Demo hesapları ve örnek talepler üretimde seed edilmez. Yerel örnek veri girmek için yalnızca development ortamında `db:seed` çalıştırın.

```sh
bin/rails db:prepare test
bundle exec rubocop
```

SLA ve durum geçişleri `travel_to` ile sabit zamanda test edilir. GitHub Actions, PostgreSQL 16 servisinde migration ve testleri çalıştırır; README rozeti en son workflow durumunu gösterir.

### Canlıya alma: Rails sunucusu + Supabase (Vercel Marketplace seçeneği)

Ödev **canlı URL'yi açıkça zorunlu tutuyor**; yerel sunum yeterli değil. İzlek, Rails 8 ile sunucu tarafında çalışan tek parça bir uygulamadır. Vercel'in Ruby desteği Beta Function'lar içindir ve her `.rb` dosyası tek bir HTTP handler tanımlar; Vercel'in Rails rehberi de Rails'i Vercel'de çalışan ayrı bir frontend'e API olarak bağlama yaklaşımını anlatır. Bu nedenle mevcut Rails portalı Vercel'e doğrudan dağıtılacak şekilde belgelenmemiştir ([Vercel Ruby runtime](https://vercel.com/docs/functions/runtimes/ruby), [Vercel Rails yaklaşımı](https://vercel.com/kb/guide/does-vercel-support-ruby-on-rails-applications)).

Supabase projesi Vercel Marketplace'ten oluşturulabilir. Bu, Vercel üzerinden yönetilen ve Vercel faturasında görünen gerçek bir Supabase/PostgreSQL projesidir; ancak Marketplace entegrasyonu bağlantı değişkenlerini bağlı **Vercel** projelerine senkronlar. Rails uygulaması Vercel dışında çalışırsa `DATABASE_URL` bağlantısı Rails sunucusunun gizli ortam değişkenlerine ayrıca girilmelidir ([Supabase Vercel Marketplace rehberi](https://supabase.com/docs/guides/integrations/vercel-marketplace)).

İlk kurulumu Supabase SQL Editor'dan yapmak isterseniz [db/supabase_bootstrap.sql](db/supabase_bootstrap.sql) dosyası güncel Rails tablolarını, indeksleri, yabancı anahtarları ve migration takip kayıtlarını tek seferde kurar. Yalnızca boş/yeni veritabanında bir kez çalıştırın. Sonraki şema değişikliklerinin kaynağı Rails migration dosyalarıdır.

Bu depodaki mevcut dağıtım tanımı, Rails uygulamasını Render Web Service üzerinde ve PostgreSQL'i Supabase'te çalıştırır. Vercel'den Supabase oluşturmak bu mimariyle uyumludur; yalnızca DB bağlantısını Render'a güvenli biçimde kopyalamak gerekir. Rails'i gerçekten Vercel üzerinde çalıştırmak için uygulama mimarisini ayırmak (Vercel frontend + başka yerde Rails API) gerekir; bu mevcut dağıtımın bir parçası değildir. Render, bu Rails-rendered portal için doğrudan uyumlu hedeftir ([Render Rails 8 kılavuzu](https://render.com/docs/deploy-rails-8)).

**Canlı uygulama:** [https://izlek-destek-masasi.onrender.com](https://izlek-destek-masasi.onrender.com). Servis Render'ın ücretsiz Ruby planında, veritabanı Supabase PostgreSQL'de çalışır. 16 Ekim 2026'da `/up` kontrolü HTTP 200 döndürdü; giriş ve kayıt sayfaları da canlı ortamda açıldı. Ücretsiz servis boşta kalınca uyur; ilk isteğin açılması 50 saniye veya daha uzun sürebilir.

1. `render.yaml` Blueprint'i Render'da `izlek-destek-masasi` adlı ücretsiz web servisini tanımlar. İlk dağıtım GitHub deposunun herkese açık URL'si kullanılarak yapıldı; Git sağlayıcısı bağlanmadığı için yeni commit'leri yayımlamak üzere servis sayfasından **Manual Deploy → Deploy latest commit** seçin.
2. Supabase projesi Vercel Marketplace'ten oluşturuldu. Render `DATABASE_URL` gizli değişkeni Supabase **Session pooler (5432)** bağlantısını kullanır. Rails için Transaction pooler (6543) kullanmayın; Supabase session pooler/direct connection ve `sslmode=require` öneriyor ([Supabase Rails rehberi](https://supabase.com/docs/guides/getting-started/quickstarts/ruby-on-rails)).
3. `DATABASE_URL` ve `RAILS_MASTER_KEY` Render gizli değişkenlerinde tutulur; anahtarı repoya koymayın. Parola sıfırlama e-postaları için ayrıca `SMTP_ADDRESS`, `SMTP_PORT`, `SMTP_DOMAIN`, `SMTP_USERNAME`, `SMTP_PASSWORD`, isteğe bağlı `SMTP_AUTHENTICATION` ve `APP_HOST` ayarlanmalıdır.
4. Yeni bir dağıtımdan sonra `/up` sağlık kontrolünü ve giriş/kayıt ekranlarını doğrulayın. Tam demo için kayıt oluşturup farklı kurum hesaplarıyla tenant izolasyonunu ve talep akışını elle deneyin.
5. Ödev teslim alanına yukarıdaki doğrulanmış canlı URL'yi ekleyin.

Render hesabı ve veritabanı bağlantısı için hesap sahibinin erişimi gerekir; gizli değerleri yalnızca Render'ın secret environment variables alanında tutun, repoya commit etmeyin. Vercel Marketplace kullanılırsa Supabase ortam değişkenleri Rails'in çalıştığı Render servisine otomatik aktarılmaz.

### Yapamadıklarım / kapsam dışı

- Canlı URL ve `/up` sağlık kontrolü doğrulandı. Geliştirme/test ortamında kayıt, ekip üyesi ekleme ve talep akışları test edilir. Üretimde iki ayrı kurumla tenant izolasyonunu teslim demosundan önce elle sınayın.
- Render ücretsiz servisi boşta kaldığında uyur; ilk istek yavaş açılabilir. GitHub sağlayıcısı Render'a bağlanmadığından yeni commitler otomatik dağıtılmaz; serviste Manual Deploy gerekir.
- Ticari Zendesk kod sayısı kamuya açık değil; 300.000 LOC yalnızca belirtilmiş tahmindir.
- Piyasa değeri aralığı yaklaşık halka açık şirket göstergesidir. Zylo rakamları Fortune 500'ün şirket şirket ölçümü değildir.
- SMTP sağlayıcısı yapılandırılmadan parola sıfırlama e-postası teslim edilmez; bu nedenle üretimde SMTP ayarı yokken sıfırlama bağlantısı gösterilmez. Yeni üye hesabı yönetici tarafından elle oluşturulur ve giriş bilgisi paylaşılır; e-posta daveti/doğrulama, dosya eki, faturalama, çok faktörlü giriş, denetim günlüğü ve analitik bu dilimde yoktur.
- SLA takvim saatidir; çalışma saatleri, hafta sonu ve tatiller hesaba katılmaz. Geliştirme demo parolası yalnızca yerel seed verisidir.
- Token maliyeti görev bazında ölçülemedi. Gerçek müşteri verisiyle üretim kullanımı için ek güvenlik, yedekleme, e-posta ve gözlemleme yapılandırması gerekir.

---

## English

### Product and inspiration

İzlek is a support-desk SaaS MVP that organizes customer requests into organization-specific workspaces and makes ownership and the next action visible. Its workflow is inspired by Zendesk's support-ticket queue: intake, assignment, first response, resolution, and reopening. İzlek is an independent student project and does not use Zendesk's code, name, or logo in the application.

### The core workflow

1. An organization administrator signs up and gets a private workspace. At any time, the administrator can open **Team members** and create an agent or requester with a new email address. Email addresses are unique platform-wide, so existing users sign in rather than being recreated. Automatic invitation email is not implemented; the administrator shares the sign-in details.
2. A requester creates a ticket. It enters `new`, and a **four-hour first-response SLA** starts at creation time.
3. An agent in the same organization opens and assigns the ticket, then sends a public reply. The first reply stops the timer.
4. The agent resolves the ticket. The requester may reopen it and reply if needed.
5. The queue shows SLA state and the **next action** together. Tickets within 30 minutes of the deadline are at risk; overdue tickets are marked late.

There are administrator, agent, and requester roles. Requesters see only their own tickets; support staff see tickets in their organization. This is not a fully audited enterprise help desk for real customer data.

### Fortune 500 research

The figures below use Fortune's 2025 U.S. Fortune 500 list (FY 2024) and Zylo's 2025 SaaS Management Index. Fortune ranks companies by revenue, not market capitalization. Public-company market values change by date and price; private companies generally do not have comparable published market values.

| Assignment question | Answer / estimate | Source and limitation |
|---|---:|---|
| Fortune 500 market-value range | Approx. **$2B–$3.34T** as an indicator for public members | [Fortune 500 list](https://fortune.com/ranking/fortune500/2025/) lists Apple's market value at $3.337T. The lower end is approximate and depends on date/public listing; Fortune does not rank by market value. |
| Employee range | Approx. **486–2.1M people** | [Fortune 500 2025](https://fortune.com/ranking/fortune500/2025/) and [Fortune's headcount extremes](https://fortune.com/2025/06/02/fortune-500-employees-headcount-workforce-largest-smallest/). Walmart reports about 2.1M employees; A-Mark's 486 is among the smallest counts. |
| SaaS applications at a large enterprise | Average **660 apps** for organizations with 10,000+ employees | [Zylo 2025 Index announcement](https://www.prweb.com/releases/2025-saas-management-index-reveals-first-increase-in-average-saas-spend-in-three-years-amid-rising-vendor-costs-and-rapid-ai-adoption-302351642.html). This is a segment average, not a census of Fortune 500 firms. |
| Annual SaaS spend | Average **$284M** for organizations with 10,000+ employees | Large-enterprise segment in the same Zylo source; not a Fortune 500 total or verified company-by-company figure. The overall sample average is $49M. |

Fortune's 2025 list reports **$19.9T revenue** and **31M employees** ([Fortune 500](https://fortune.com/ranking/fortune500/2025/)). This scale helps explain why small support delays can affect many customer interactions.

### SaaS selection and Fortune 500 proof

The selected SaaS is enterprise support desk **Zendesk**. [Comcast Business's subprocessor list (PDF)](https://business.comcast.com/~/media/business_comcast_com/PDFs/privacy/Comcast%20Business%20Subprocessor%20List%20%28260323%29.pdf) names Zendesk as a customer-support provider. [Comcast ranks No. 35 on the 2025 Fortune 500](https://fortune.com/ranking/fortune500/2025/). This is company-published evidence of usage at at least one Fortune 500 company; it does not reveal price or contract value.

Zendesk's source code is closed, so **300,000 LOC** is an assignment-scale assumption, not a verified count. The product's commercial value is helping teams assign and answer customer requests without losing them.

### User pain and the “perfect pass”

[Emily I. G.'s May 19, 2026 G2 review](https://www.g2.com/products/zendesk-for-customer-service/reviews?hubspot_post-cta=anchor&page=6&source=search%23reviews%3D) says administrators can spend significant time learning and implementing filters, business rules, macros, and SLAs. [Jane F.'s March 23, 2026 Capterra review](https://www.capterra.com/p/164283/Zendesk/reviews/) also says new users may need time to learn the many features. These are individual reviews, not claims about every customer.

**Pain selected:** A new support team loses time finding the next task among broad configuration options.

**İzlek's response:** The queue shows each ticket's owner, SLA risk, and next action together. In this MVP, teams can create, assign, answer, and solve a ticket before configuring rules or filters. The core flow is covered end-to-end in `test/integration/ticket_workflow_test.rb`.

**Presentation sentence:** “A Zendesk user review on G2 describes the time administrators spend learning SLA and workflow settings; İzlek puts ownership, SLA, and the next action in one queue so a team can start handling work before configuring those rules.” İzlek does not claim to solve Zendesk's advanced automation and reporting limitations.

### Phase 2 — cost and time estimate

| Measure | Estimate / actual | Method |
|---|---:|---|
| Zendesk code size | Approx. **300,000 LOC** | Actual LOC is unknown because the source is closed. This is an explicit assumption based on the assignment's enterprise scale. |
| Initial agent estimate | **2–3 days** | Planning estimate for scope, Rails workflow, views, tests, deployment setup, and fixes; it does not mean recreating 300,000 lines. |
| Time spent in this session | About **one work session / one calendar day** | Covers preparing this repository's changes, not student presentation practice or the live deployment. |
| Token / subscription cost | **No separate API invoice measured** | Work used the existing Codex session/subscription. Its account-wide subscription and usage cannot be reliably allocated to this project, so no numeric cost is invented. |

### Local setup

Requirements: Ruby 3.4.7 and Bundler. Development/test use SQLite; production uses PostgreSQL.

```sh
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/rails server
```

Open `http://localhost:3000`. Development demo login: `ece@izlek.demo` / `IzlekDemo2026!`. Demo users and sample tickets are never seeded in production.

```sh
bin/rails db:prepare test
bundle exec rubocop
```

SLA and state-transition tests use `travel_to`. GitHub Actions runs migrations and tests against PostgreSQL 16; the badge above shows the latest workflow status.

### Deployment: Rails server + Supabase (Vercel Marketplace option)

The assignment **explicitly requires a live URL**; a local demo is insufficient. İzlek is a monolithic Rails 8 server-rendered application. Vercel's Ruby support is for beta Functions where each `.rb` file defines one HTTP handler; Vercel's Rails guide describes using Rails as an API for a separate frontend hosted on Vercel. The current Rails portal is therefore not documented as a direct Vercel deployment ([Vercel Ruby runtime](https://vercel.com/docs/functions/runtimes/ruby), [Vercel Rails guidance](https://vercel.com/kb/guide/does-vercel-support-ruby-on-rails-applications)).

Supabase can be provisioned through the Vercel Marketplace. It remains a real Supabase/PostgreSQL project managed and billed through Vercel. The Marketplace syncs environment variables to connected **Vercel** projects; if Rails runs outside Vercel, copy `DATABASE_URL` securely into the Rails host yourself ([Supabase Vercel Marketplace guide](https://supabase.com/docs/guides/integrations/vercel-marketplace)).

For a one-time SQL Editor setup, [db/supabase_bootstrap.sql](db/supabase_bootstrap.sql) creates the current Rails tables, indexes, foreign keys, and migration tracking records. Run it only once against a new, empty database. Future schema changes should use the Rails migration files.

This repository's current deployment definition runs Rails on a Render Web Service and PostgreSQL on Supabase. Creating Supabase through Vercel fits this architecture; the database URL must be entered into Render. Running Rails itself on Vercel would require separating the app into a Vercel frontend and a Rails API hosted elsewhere, which is not part of the current deployment. Render is the direct fit for this Rails-rendered portal ([Render Rails 8 guide](https://render.com/docs/deploy-rails-8)).

**Live app:** [https://izlek-destek-masasi.onrender.com](https://izlek-destek-masasi.onrender.com). The web service runs on Render's free Ruby plan and PostgreSQL runs on Supabase. The `/up` health endpoint and login/signup pages were verified in production on October 16, 2026; the latest verified app commit is `be188ff`. Render's free service sleeps after inactivity, so its first response may take 50 seconds or longer.

1. The `render.yaml` Blueprint defines a free Render web service named `izlek-destek-masasi`. The first deploy used the public GitHub repository URL; because a Git provider was not connected, use the service's **Manual Deploy → Deploy latest commit** action for new commits.
2. Supabase was provisioned through the Vercel Marketplace. Render's secret `DATABASE_URL` uses Supabase's **Session pooler (5432)**. Do not use the Transaction pooler (6543) as Rails' main connection; Supabase recommends the session pooler/direct connection and `sslmode=require` ([Supabase Rails guide](https://supabase.com/docs/guides/getting-started/quickstarts/ruby-on-rails)).
3. `DATABASE_URL` and `RAILS_MASTER_KEY` are stored as Render secret environment variables; never commit the master key. To enable reset emails, also set `SMTP_ADDRESS`, `SMTP_PORT`, `SMTP_DOMAIN`, `SMTP_USERNAME`, `SMTP_PASSWORD`, optional `SMTP_AUTHENTICATION`, and `APP_HOST`.
4. After each deploy, verify `/up` and the login/signup pages. For a full demo, create accounts in separate organizations and manually exercise tenant isolation and the ticket workflow.
5. Add the verified live URL above to the assignment submission.

Access to the Render account and database connection is required; keep secret values in Render's environment settings and out of the repository. Marketplace environment variables are not automatically copied to a Rails service running on Render.

### What is not implemented / limitations

- The live URL and `/up` health check are verified. Registration, team-member creation, and ticket workflow are tested locally; tenant isolation across two production organizations should still be demonstrated manually before the presentation.
- The Render free service sleeps after inactivity, so the first request may be slow. New commits are not deployed automatically because a GitHub provider was not connected; use Manual Deploy on the service.
- Zendesk's actual LOC is not public; 300,000 LOC is an estimate only.
- The market-value range is an approximate indicator for public companies. Zylo figures are not a Fortune 500 company-by-company census.
- Without an SMTP provider, password-reset email cannot be delivered; the production reset link is hidden until SMTP is configured. Team accounts are created manually by an administrator and credentials are shared directly; invitation/verification email, attachments, billing, multi-factor authentication, audit logs, and analytics are outside this slice.
- SLA uses calendar hours and ignores business hours, weekends, and holidays. Demo passwords only belong to local seed data.
- Token cost was not measured per task. Production use with real customer data needs further security, backup, email, and observability configuration.

## Agent notes

See [AGENT.md](AGENT.md) for architecture, repository rules, and verification commands.
