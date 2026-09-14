// ─────────────────────────────────────────────────────────────
//  Laporan Tahap 0 : Sinelog
//  Kompilasi:  typst compile laporan-tahap0.typ
//  Berkas gambar diletakkan di folder: screenshots/
// ─────────────────────────────────────────────────────────────

#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
  numbering: "1",
)

#set text(font: "Libertinus Serif", size: 11pt, lang: "id")
#set par(justify: true, leading: 0.75em)

#show heading.where(level: 1): it => [
  #set text(size: 16pt, weight: "bold")
  #block(above: 1.4em, below: 0.8em)[#it.body]
]

#show heading.where(level: 2): it => [
  #set text(size: 12pt, weight: "bold")
  #block(above: 1.2em, below: 0.6em)[#it.body]
]

#show raw: set text(font: "DejaVu Sans Mono", size: 9pt)

// Fungsi bantu untuk menampilkan gambar beserta keterangannya
#let gambar(path, caption, width: 100%) = figure(
  box(stroke: 0.5pt + luma(180), radius: 3pt, clip: true, image(path, width: width)),
  caption: caption,
)

#show figure.caption: set text(size: 9pt)
#show figure: set block(breakable: false, above: 1.2em, below: 1.2em)

// ───────────────────────── Judul ─────────────────────────

#align(center)[
  #text(size: 20pt, weight: "bold")[Laporan Tahap 0 : Sinelog]

  #v(0.3em)
  #text(size: 11pt)[Fondasi Proyek: Scaffold, Logo, dan Package Name]

  #v(0.8em)
  #text(size: 10pt)[Dicha Wijaya Kusuma · 11231020 · PAPB B]
]

#v(1.5em)
#line(length: 100%, stroke: 0.5pt)
#v(1em)

= Pendahuluan

Sinelog adalah aplikasi pencatat film yang ditonton, dibangun memakai Flutter.
Laporan ini mendokumentasikan Tahap 0, yaitu penyiapan fondasi proyek sebelum
fitur-fitur utama dikerjakan.

Tiga hal yang diselesaikan pada tahap ini:

+ Scaffold proyek Flutter untuk Android, iOS, web, dan desktop.
+ Pemasangan logo aplikasi sebagai _launcher icon_ di semua platform.
+ Penggantian _package name_ menjadi `com.winatra.sinelog`.

= Lingkungan Pengembangan

#table(
  columns: (auto, 1fr),
  stroke: 0.5pt + gray,
  inset: 7pt,
  align: (left, left),
  table.header[*Komponen*][*Keterangan*],
  [Framework], [Flutter 3.47.3 (channel stable)],
  [Bahasa], [Dart SDK ^3.13.3],
  [Perangkat uji], [Google Pixel 4a, Android 13 (API 33)],
  [Resolusi layar], [1080 × 2340 piksel],
  [Sistem operasi], [Ubuntu 24.04.4 LTS],
)

= Hasil Pengerjaan

== Aplikasi Berhasil Dijalankan

Aplikasi berhasil dibangun dan dijalankan pada perangkat fisik. Halaman utama
menampilkan logo Sinelog beserta teks `Hello World` sebagai penanda bahwa
kerangka aplikasi sudah berfungsi dengan benar.

#gambar(
  "screenshots/01-app-jalan.png",
  [Aplikasi Sinelog berjalan di Pixel 4a, menampilkan logo dan teks Hello World],
  width: 33%,
)

Label _DEBUG_ di pojok kanan atas menandakan aplikasi dijalankan dalam mode
_debug_, yang memang digunakan selama tahap pengembangan.

== Logo sebagai Launcher Icon

Logo aplikasi dipasang memakai paket `flutter_launcher_icons`, sehingga ikon
otomatis dibangkitkan untuk seluruh kerapatan layar Android (mdpi hingga
xxxhdpi) maupun platform lain. Hasilnya terlihat pada daftar aplikasi
perangkat.

#gambar(
  "screenshots/02-launcher-icon.png",
  [Ikon Sinelog muncul di daftar aplikasi dengan logo yang sudah terpasang],
  width: 88%,
)

Berkas sumber logo berada di `assets/images/logo.png` dan dikonfigurasi melalui
`pubspec.yaml`:

```yaml
flutter_launcher_icons:
  image_path: "assets/images/logo.png"
  android: true
  ios: true
  remove_alpha_ios: true
```

Perintah yang dijalankan untuk membangkitkan ikon:

```bash
flutter pub run flutter_launcher_icons
```

== Package Name

_Package name_ bawaan hasil `flutter create` diganti menjadi
`com.winatra.sinelog`. Nilai ini berfungsi sebagai identitas unik aplikasi di
perangkat dan pada Google Play Store.

#gambar(
  "screenshots/03-package-name.png",
  [Konfigurasi package name pada berkas Gradle dan verifikasinya di perangkat],
  width: 82%,
)

Perlu dibedakan dua nilai yang tampak serupa pada berkas Gradle:

#table(
  columns: (auto, 1fr),
  stroke: 0.5pt + gray,
  inset: 7pt,
  table.header[*Nilai*][*Fungsi*],
  [`applicationId`],
  [Identitas aplikasi di perangkat dan Play Store. Tidak boleh diubah setelah
   aplikasi dirilis, karena pembaruan dikenali melalui nilai ini.],
  [`namespace`],
  [Ruang nama untuk kode Kotlin/Java serta kelas `R` dan `BuildConfig` yang
   dibangkitkan saat proses _build_.],
)

Selain pada berkas Gradle, package name juga tercatat pada beberapa berkas
lain sesuai platformnya:

#table(
  columns: (auto, 1fr),
  stroke: 0.5pt + gray,
  inset: 7pt,
  table.header[*Platform*][*Lokasi*],
  [Android], [`android/app/build.gradle.kts`],
  [Android], [`android/app/src/main/kotlin/com/winatra/sinelog/MainActivity.kt`],
  [iOS], [`ios/Runner.xcodeproj/project.pbxproj`],
  [macOS], [`macos/Runner/Configs/AppInfo.xcconfig`],
)

Perlu dicatat bahwa package name *tidak* berada di `pubspec.yaml`. Isian
`name: sinelog` pada berkas tersebut adalah nama paket Dart yang dipakai untuk
keperluan _import_, misalnya `import 'package:sinelog/main.dart'`, dan berbeda
dari identitas aplikasi di tingkat sistem operasi.

= Struktur Proyek

Pada tahap ini berkas kode masih minimal, hanya berisi satu berkas `main.dart`:

```
sinelog/
├── android/              # proyek Android + package com.winatra.sinelog
├── ios/                  # proyek iOS
├── lib/
│   └── main.dart         # Hello World + tampilan logo
├── assets/
│   └── images/
│       └── logo.png      # sumber logo & launcher icon
├── pubspec.yaml          # konfigurasi proyek & dependensi
└── README.md
```

= Pengujian

Verifikasi dilakukan melalui tiga perintah berikut, seluruhnya berhasil tanpa
kesalahan:

#table(
  columns: (auto, 1fr, auto),
  stroke: 0.5pt + gray,
  inset: 7pt,
  table.header[*Perintah*][*Tujuan*][*Hasil*],
  [`flutter pub get`], [Mengunduh dependensi], [Berhasil],
  [`flutter analyze`], [Analisis statis kode], [Tidak ada isu],
  [`flutter build apk --debug`], [Membangun berkas APK], [Berhasil],
)

Keluaran perintah analisis statis:

```
Analyzing sinelog...
No issues found! (ran in 4.9s)
```

= Kesimpulan

Tahap 0 telah selesai. Fondasi proyek Sinelog sudah siap: kerangka aplikasi
berjalan pada perangkat fisik, logo terpasang sebagai launcher icon di seluruh
platform, dan package name sudah diganti menjadi `com.winatra.sinelog`.

Tahap berikutnya adalah penyusunan model data dan lapisan data, yang mencakup
penyimpanan lokal memakai SQLite serta pengambilan data film dari API TMDB.
