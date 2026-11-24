# Sinelog

Aplikasi pencatat film yang sudah ditonton, dibangun dengan Flutter.

- **Package name:** `com.winatra.sinelog`
- **Status:** Tahap 0 — scaffold, logo, dan package name selesai.

## Menjalankan

```bash
flutter pub get
flutter run --dart-define-from-file=tmdb.local.properties
```

`tmdb.local.properties` berisi API key TMDB dan tidak ikut di-commit.

## Verifikasi

```bash
flutter analyze                # wajib bersih
flutter test                   # mulai dipakai di tahap 2
flutter build apk --debug
```

## Build release

```bash
flutter build apk --release --dart-define-from-file=tmdb.local.properties
# hasil: build/app/outputs/flutter-apk/app-release.apk

flutter build appbundle --release --dart-define-from-file=tmdb.local.properties
# hasil: build/app/outputs/bundle/release/app-release.aab (untuk Play Store)
```


Release ditandatangani dengan upload key dari `android/key.properties`
(isi: `storePassword`, `keyPassword`, `keyAlias`, `storeFile`). File itu
dan keystore `.jks` tidak ikut di-commit — simpan cadangannya sendiri.

## Sumber data & gambar

Koleksi dan rating pribadi disimpan di SQLite di perangkat. Data dan poster film diambil dari [TMDB](https://www.themoviedb.org) lewat
API (tidak ada poster yang dibundel di aplikasi). Atribusi TMDB ada di tombol
info di halaman Cari. Film dewasa disaring dengan `include_adult=false`.

## Struktur

```
lib/main.dart          # entry point, buka database lalu jalankan app
lib/app_state.dart     # koleksi + rating pribadi, disimpan di SQLite
lib/services/          # akses API TMDB
lib/features/          # halaman Cari dan Collection
assets/images/logo.png # sumber logo & launcher icon
docs/                  # laporan per tahap (Typst)
RENCANA_PENGERJAAN.md  # rencana pengerjaan bertahap
```

## Laporan

Laporan tiap tahap ditulis dengan [Typst](https://typst.app) di `docs/`:

```bash
cd docs
typst compile laporan-tahap0.typ   # sekali build
typst watch laporan-tahap0.typ     # auto-rebuild saat disimpan
```

## Regenerasi launcher icon

```bash
flutter pub run flutter_launcher_icons
```
