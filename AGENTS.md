# İzlek kod ajanı notları

- Bu depo Rails 8 uygulamasıdır. Uygulama kodu `app/`, veritabanı geçişleri `db/migrate/`, testler `test/` içindedir.
- Ödevin karar, fark ve kanıt kaydı `CHALLENGE_LOG.md`; canlı adres ve yerel çalıştırma adımları `README.md` içindedir.
- Destek yardımcısı yalnızca mevcut kurumun ve dilin yayınlanmış `KnowledgeArticle` kayıtlarını kullanır. Kaynak kimliğini Rails tarafında doğrula; Gemini anahtarını kod, log veya repoya yazma.
- Kod değişikliğinden sonra `ruby bin/rails test`, `bundle exec rubocop` ve gerekirse `bundle exec brakeman -q` çalıştır.
- Dağıtım tanımı `render.yaml`; derleme `bin/render-build.sh`, başlatma `bin/render-start.sh` ile yapılır. Başlatma sırasında `db:prepare` migration'ları uygular. GitHub'a push bu servisi otomatik dağıtmaz; Render'da **Manual Deploy → Deploy latest commit** gerekir.
- Dağıtımdan sonra Render durumunu ve `https://izlek-destek-masasi.onrender.com/up` sağlık kontrolünü doğrula. Canlı demo için yalnızca hayalî müşteri içeriği kullan.
