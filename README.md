# İzlek — Destek çalışma alanı / Support workspace

[![CI](https://github.com/memirkincal/izlek-destek-masasi/actions/workflows/ci.yml/badge.svg)](https://github.com/memirkincal/izlek-destek-masasi/actions/workflows/ci.yml)

**Uygulama / App:** deployment pending — Render + Supabase credentials and first deploy must be completed before sharing a live URL.
**Kaynak / Source:** [GitHub](https://github.com/memirkincal/izlek-destek-masasi)

---

## Türkçe

### Ürün ve ilham kaynağı

İzlek, müşteri destek taleplerini kurumlara özel çalışma alanlarında toplayan, sorumluyu ve sıradaki işi görünür kılan bir destek masası SaaS MVP'sidir. Ürün akışı için **Zendesk'in destek talebi kuyruğu** incelendi: talep alma, atama, ilk yanıt, çözme ve yeniden açma. İzlek bağımsız bir öğrenci projesidir; Zendesk kodunu, adını veya logosunu kullanmaz.

### Aort dilimi: talebin oluşturulmasından çözüme

1. Kurum yöneticisi kayıt olur; kuruma özel çalışma alanı oluşur. Yönetici aynı alana temsilci ve talep sahibi ekleyebilir.
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

[G2 Zendesk yorumlarında](https://www.g2.com/products/zendesk-for-customer-service/reviews) bazı kullanıcılar ayar ve yapılandırma seçeneklerinin yeni ekip üyelerini zorlayabildiğini; [Capterra yorumlarında](https://www.capterra.com/p/164283/Zendesk/reviews/) bazı kullanıcılar raporlama/analitik kullanımının karmaşık olabildiğini anlatıyor. Bunlar örnek kullanıcı görüşleridir; tüm kullanıcıları temsil ettiği iddia edilmez.

**Sunum cümlesi:** “Yeni destek ekibi üyesinin, yorumlarda anlatılan yapılandırma karmaşası içinde sıradaki işi aramasını önlemek için İzlek kuyrukta sorumluyu, SLA durumunu ve sonraki eylemi tek bakışta gösteriyor.” Bu, seçilen temel akış için tasarım çözümüdür; Zendesk'in tüm raporlama ve yapılandırma sorunlarını çözdüğümüz anlamına gelmez.

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

### Canlıya alma: Render + Supabase

Ödev **canlı URL'yi açıkça zorunlu tutuyor**; yerel sunum yeterli değil. Rails 8 sunucu uygulaması Render Web Service üzerinde, kalıcı PostgreSQL veritabanı Supabase üzerinde çalışacak şekilde yapılandırıldı. Vercel'in Ruby runtime'ı beta ve Vercel dokümanı Rails'i başlıca Vercel'de barındırılan bir frontend'e API olarak bağlama yaklaşımını anlatıyor; bu Rails-rendered portal için doğrudan uyumlu hedef Render'dır ([Vercel Ruby runtime](https://vercel.com/docs/functions/runtimes/ruby), [Vercel Rails yaklaşımı](https://vercel.com/kb/guide/does-vercel-support-ruby-on-rails-applications), [Render Rails 8 kılavuzu](https://render.com/docs/deploy-rails-8)).

1. GitHub deposunu Render'a bağlayıp `render.yaml` Blueprint'ini oluşturun.
2. Supabase projesinde **Session pooler (5432)** bağlantısını kopyalayıp Render'daki `DATABASE_URL` gizli değişkenine girin. Rails için Transaction pooler (6543) kullanmayın; Supabase, session pooler/direct connection ve `sslmode=require` öneriyor ([Supabase Rails rehberi](https://supabase.com/docs/guides/getting-started/quickstarts/ruby-on-rails)).
3. `RAILS_MASTER_KEY` için `config/master.key` içeriğini Render gizli değişkenine girin. Bu anahtarı repoya koymayın. Parola sıfırlama e-postalarını açmak için ayrıca `SMTP_ADDRESS`, `SMTP_PORT`, `SMTP_DOMAIN`, `SMTP_USERNAME`, `SMTP_PASSWORD`, isteğe bağlı `SMTP_AUTHENTICATION` ve `APP_HOST` secret/env değişkenlerini girin.
4. İlk build/deploy bitince Render URL'sini `/up` ile kontrol edin; kayıt oluşturup iki ayrı kurum hesabıyla tenant izolasyonunu ve talep akışını elle doğrulayın.
5. Gerçek canlı URL'yi bu README'ye ve ödev teslim alanına ekleyin. Şu an linki doldurulmuş gibi göstermiyoruz: ilk deploy ve URL doğrulaması yapılmadan canlı demek doğru olmaz.

Render tarafındaki kullanıcı onayı ve Supabase veritabanı bilgileri hesap sahibinin kontrolünde gereklidir; bağlantı dizesi veya anahtarlar sohbet/repoya yazılmamalıdır.

### Yapamadıklarım / kapsam dışı

- Bu teslimde canlı servis kurulumu, Supabase erişim bilgisi ve Render hesabı onayı tamamlanmadı; bu nedenle **şimdilik doğrulanmış canlı URL yoktur**. Ödevin 0 puan riskini kaldırmak için teslimden önce deploy edip linki eklemek zorunludur.
- Ticari Zendesk kod sayısı kamuya açık değil; 300.000 LOC yalnızca belirtilmiş tahmindir.
- Piyasa değeri aralığı yaklaşık halka açık şirket göstergesidir. Zylo rakamları Fortune 500'ün şirket şirket ölçümü değildir.
- SMTP sağlayıcısı yapılandırılmadan parola sıfırlama e-postası teslim edilmez; bu nedenle üretimde SMTP ayarı yokken sıfırlama bağlantısı gösterilmez. E-posta doğrulama, otomatik davet, dosya eki, faturalama, çok faktörlü giriş, denetim günlüğü ve analitik bu dilimde yoktur.
- SLA takvim saatidir; çalışma saatleri, hafta sonu ve tatiller hesaba katılmaz. Geliştirme demo parolası yalnızca yerel seed verisidir.
- Token maliyeti görev bazında ölçülemedi. Gerçek müşteri verisiyle üretim kullanımı için ek güvenlik, yedekleme, e-posta ve gözlemleme yapılandırması gerekir.

---

## English

### Product and inspiration

İzlek is a support-desk SaaS MVP that organizes customer requests into organization-specific workspaces and makes ownership and the next action visible. Its workflow is inspired by Zendesk's support-ticket queue: intake, assignment, first response, resolution, and reopening. İzlek is an independent student project and does not use Zendesk's code, name, or logo in the application.

### The core workflow

1. An organization administrator signs up and gets a private workspace. The administrator can add agents and requesters.
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

Some [G2 Zendesk reviews](https://www.g2.com/products/zendesk-for-customer-service/reviews) describe setup and configuration choices as difficult for new team members. Some [Capterra reviews](https://www.capterra.com/p/164283/Zendesk/reviews/) describe reporting and analytics as complex. These are examples of user opinions, not claims about every customer.

**Presentation sentence:** “To help a new support agent avoid searching through configuration complexity for the next task described in user reviews, İzlek puts the owner, SLA state, and next action together in the queue.” This is a focused design response for the selected workflow; it does not claim to solve all Zendesk reporting or setup issues.

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

### Deployment: Render + Supabase

The assignment **explicitly requires a live URL**; a local demo is insufficient. This project is configured for a Render Web Service running Rails 8 and a Supabase PostgreSQL database. Vercel's Ruby runtime is in beta and its Rails guidance describes Rails as an API for a frontend hosted on Vercel; Render is the direct fit for this Rails-rendered portal ([Vercel Ruby runtime](https://vercel.com/docs/functions/runtimes/ruby), [Vercel Rails guidance](https://vercel.com/kb/guide/does-vercel-support-ruby-on-rails-applications), [Render Rails 8 guide](https://render.com/docs/deploy-rails-8)).

1. Connect the GitHub repository to Render and create the `render.yaml` Blueprint.
2. In Supabase, copy the **Session pooler (5432)** connection string into Render's secret `DATABASE_URL`. Do not use the Transaction pooler (6543) as Rails' main connection; Supabase recommends the session pooler/direct connection and `sslmode=require` ([Supabase Rails guide](https://supabase.com/docs/guides/getting-started/quickstarts/ruby-on-rails)).
3. Set `RAILS_MASTER_KEY` in Render from `config/master.key`. Never commit this key. To enable reset emails, also set `SMTP_ADDRESS`, `SMTP_PORT`, `SMTP_DOMAIN`, `SMTP_USERNAME`, `SMTP_PASSWORD`, optional `SMTP_AUTHENTICATION`, and `APP_HOST` as environment secrets/variables.
4. After the first deploy, check the Render URL at `/up`, then manually verify signup and the ticket workflow with accounts in two separate organizations.
5. Add the verified live URL to this README and the assignment submission. It is intentionally not presented as live until a first deploy has been verified.

The account owner's Render approval and Supabase database credentials are required; never paste connection strings or keys into chat or the repository.

### What is not implemented / limitations

- The live service, Supabase credentials, and Render account approval are not configured in this delivery; therefore **there is no verified live URL yet**. Deploying and adding the URL is mandatory to avoid the assignment's zero-point risk.
- Zendesk's actual LOC is not public; 300,000 LOC is an estimate only.
- The market-value range is an approximate indicator for public companies. Zylo figures are not a Fortune 500 company-by-company census.
- Without an SMTP provider, password-reset email cannot be delivered; the production reset link is hidden until SMTP is configured. Email verification, automated invitations, attachments, billing, multi-factor authentication, audit logs, and analytics are outside this slice.
- SLA uses calendar hours and ignores business hours, weekends, and holidays. Demo passwords only belong to local seed data.
- Token cost was not measured per task. Production use with real customer data needs further security, backup, email, and observability configuration.

## Agent notes

See [AGENT.md](AGENT.md) for architecture, repository rules, and verification commands.
