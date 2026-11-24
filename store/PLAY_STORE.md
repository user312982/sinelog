# Checklist rilis Google Play — Sinelog

## Sudah siap (dicek 24 Nov 2026)

| Syarat Play | Status |
|---|---|
| Format Android App Bundle (`.aab`) | `flutter build appbundle --release --dart-define-from-file=tmdb.local.properties` |
| Target API 36 (Android 16), wajib untuk app baru sejak 31 Agu 2026 | `targetSdkVersion 36`, min 24 |
| Ditandatangani upload key, bukan debug key | `CN=izanagi, OU=PAPB, O=Sinelog` |
| Dukungan memory page 16 KB | library native sejajar 64 KB, lolos `zipalign -P 16` |
| Package name unik | `com.winatra.sinelog` (tidak bisa diganti setelah upload) |
| Hanya permission yang perlu | `INTERNET` saja |
| Fungsi nyata, bukan sekadar demo | cari (TMDB), koleksi + rating tersimpan di SQLite |
| Atribusi TMDB | teks resmi di dialog Tentang (tombol ⓘ di halaman Cari) |
| Ikon 512×512 | `store/icon-512.png` |
| Feature graphic 1024×500 | `store/feature-graphic-1024x500.png` |
| Teks kebijakan privasi | `store/privacy-policy.md` |

## Masih harus kamu kerjakan

1. **Logo TMDB.** Unduh salah satu logo resmi dari
   <https://www.themoviedb.org/about/logos-attribution>, ubah ke PNG tanpa
   diedit, lalu simpan sebagai `assets/images/tmdb_logo.png`. Kode untuk
   menampilkannya di dialog Tentang sudah ada. Syarat ini wajib menurut API
   Terms of Use TMDB.
2. **Host kebijakan privasi.** Isi email kontak di `store/privacy-policy.md`,
   lalu terbitkan di URL publik (GitHub Pages / Google Sites). Play Console
   meminta URL, bukan file.
3. **Screenshot.** Minimal 2 screenshot HP (rasio 16:9 atau 9:16, sisi 320–3840
   px) dari aplikasi versi rilis. Screenshot lama di `assets/images/ss/`
   masih memakai UI lama.
4. **Akun Play Console.** Biaya pendaftaran sekali bayar USD 25 dan verifikasi
   identitas.
5. **Closed testing (akun personal baru).** Minimal 12 tester ikut closed test
   **terus-menerus selama 14 hari** sebelum boleh mengajukan akses production.
   Jadi siapkan minimal ±3 minggu dari upload pertama sampai bisa publik.

## Isian formulir Play Console (App content)

| Formulir | Jawaban yang disarankan |
|---|---|
| Privacy policy | URL dari langkah 2 |
| Ads | Tidak ada iklan |
| App access | Semua fitur bisa dipakai tanpa login |
| Target audience | 13+ (bukan untuk anak; konten film dari TMDB tidak difilter per umur) |
| Content rating (IARC) | Tidak ada kekerasan/seks/judi buatan app sendiri; tidak ada konten dari pengguna lain; tidak ada chat. Akan keluar rating sekitar remaja. |
| Data safety | Data dienkripsi saat dikirim (HTTPS). Tidak ada akun, jadi tidak ada permintaan hapus data. Kata kunci pencarian dikirim ke TMDB; paling aman dideklarasikan sebagai *App activity → In-app search history*, untuk fungsi app, diproses sesaat (ephemeral), tidak dipakai untuk iklan. |
| Government / financial / health app | Tidak |

## Setiap update berikutnya

Naikkan `version` di `pubspec.yaml`, misalnya `1.0.0+1` → `1.0.1+2`. Angka
setelah `+` (versionCode) harus selalu naik, kalau tidak, upload ditolak.

## Risiko yang perlu diketahui

- **API key TMDB ikut di dalam APK** dan bisa diekstrak orang lain. Untuk API
  gratis dengan rate limit risikonya kecil. Kalau key disalahgunakan, buat key
  baru di akun TMDB lalu build ulang.
- **TMDB hanya gratis untuk penggunaan non-komersial.** Begitu app memasang
  iklan atau berbayar, perlu perjanjian tertulis dengan TMDB.
- **Simpan cadangan keystore** (`~/sinelog-upload-keystore.jks` dan
  `android/key.properties`). Dengan Play App Signing, upload key yang hilang
  masih bisa di-reset lewat dukungan Google, tapi prosesnya lama.
