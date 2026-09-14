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

## Struktur

```
lib/main.dart          # entry point — saat ini Hello World + logo
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
