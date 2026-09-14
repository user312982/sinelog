# Screenshot

Diambil dari Pixel 4a (Android 13, 1080x2340), build debug tahap 2.5.

| Berkas | Isi |
|---|---|
| `01-koleksi-kosong.png` | Empty state koleksi (UC-02) |
| `02-cari-awal.png` | Tab Cari sebelum ada kata kunci |
| `03-cari-hasil.png` | Hasil pencarian TMDB (UC-01) |
| `04-cari-sudah-ditambahkan.png` | Tombol + berubah jadi ✓ setelah film masuk koleksi |
| `05-koleksi-terisi.png` | Daftar koleksi berisi dua film |
| `06-detail-belum-ditonton.png` | Detail film; rating terkunci selama belum ditonton (UC-03) |
| `07-detail-ditonton-rating.png` | Status sudah ditonton + rating 4 bintang |
| `08-konfirmasi-hapus.png` | Dialog konfirmasi hapus (UC-04) |
| `09-persisten-setelah-restart.png` | Koleksi + rating bertahan setelah app ditutup paksa |
| `10-error-tanpa-api-key.png` | Pesan error saat TMDB_API_KEY kosong |

Folder ini tidak ikut di-bundle ke aplikasi — `pubspec.yaml` hanya mendaftarkan
`assets/images/`.
