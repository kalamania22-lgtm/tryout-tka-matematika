# Try Out TKA Matematika SDN Pondok Bambu 04 — Paket Online

## File dalam paket
- `index.html` — website peserta, tampilan terbaru, token halaman 2, pengacakan 30 soal per percobaan, timer 75 menit, hasil dikirim ke Supabase saat dikumpulkan.
- `admin.html` — dashboard login guru, rekap percobaan, ekspor Excel dan CSV.
- `supabase_schema.sql` — tabel `tka_attempts` dan kebijakan akses Row Level Security.

## A. Buat proyek Supabase baru
1. Buka https://supabase.com/dashboard dan buat proyek baru. Simpan kata sandi database dengan aman.
2. Setelah proyek aktif, buka SQL Editor → New query.
3. Buka `supabase_schema.sql`. Ganti `GANTI_EMAIL_GURU@sekolah.id` dengan email akun guru yang akan digunakan untuk login dashboard.
4. Jalankan seluruh SQL. Pastikan tabel `public.tka_attempts` tersedia di Table Editor.
5. Buka Project Settings → API (atau Connect), salin Project URL dan publishable key/anon key. Jangan gunakan `service_role` atau secret key.

## B. Hubungkan website peserta ke Supabase
1. Buka `index.html` menggunakan editor teks/kode.
2. Cari `GANTI_DENGAN_SUPABASE_PROJECT_URL`, ganti dengan Project URL.
3. Cari `GANTI_DENGAN_SUPABASE_PUBLISHABLE_OR_ANON_KEY`, ganti dengan publishable/anon key.
4. Simpan. Jangan masukkan service_role key ke file HTML.

## C. Buat akun guru
1. Supabase → Authentication → Users → Add user. Buat user dengan email yang sama persis dengan email pada policy SQL dan kata sandi kuat.
2. Dashboard membaca data hanya setelah login, dan policy SELECT hanya mengizinkan email tersebut. Jika ingin menambah guru, ubah policy RLS secara sengaja untuk memasukkan email tambahan.

## D. Unggah ke GitHub Pages
1. Buat repository bernama `tryout-tka-matematika`.
2. Unggah `index.html`, `admin.html`, dan `supabase_schema.sql` ke root repository. (SQL hanya dokumentasi; SQL sudah harus dijalankan di Supabase.)
3. Repository → Settings → Pages → Deploy from a branch → `main` → `/ (root)` → Save.
4. Website siswa: `https://USERNAME.github.io/tryout-tka-matematika/`
5. Dashboard guru: `https://USERNAME.github.io/tryout-tka-matematika/admin.html`

## E. Uji coba sebelum dibagikan
1. Buka website siswa secara online. Isi nama, kelas, tanggal lahir, dan token yang tampil.
2. Jawab beberapa soal lalu klik Kumpulkan. Tunggu status `Hasil berhasil disimpan` pada halaman hasil.
3. Supabase → Table Editor → `tka_attempts`, pastikan satu baris baru muncul.
4. Buka `admin.html`, masukkan Project URL dan key, lalu login sebagai guru. Klik Muat/Perbarui Data dan coba ekspor Excel.
5. Ulangi tes. Setiap submit menambah baris percobaan baru.

## Catatan penting
- Hasil baru disimpan saat peserta mengumpulkan. Perangkat harus online pada saat itu. Jika status menyatakan gagal, data belum tersimpan ke Supabase.
- Token dibuat lokal di browser. Ini bukan sistem autentikasi siswa dan tidak dijamin unik secara global.
- Pengacakan dilakukan secara independen di browser masing-masing. Urutan bisa kebetulan sama.
- Nilai dan kunci jawaban masih dihitung di browser. Untuk asesmen berisiko tinggi, penilaian perlu dipindah ke backend tepercaya karena kode HTML/JavaScript publik dapat diperiksa.
- Jawaban disimpan sebagai JSON di kolom `answers`; dashboard menyediakan ringkasan nilai dan menyertakan JSON jawaban saat ekspor Excel.
- Jangan mengumpulkan tanggal lahir ke database secara default; hanya nama, kelas, gender opsional, jawaban, nilai, dan metadata percobaan yang disimpan.
