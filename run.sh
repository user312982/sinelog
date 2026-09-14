#!/usr/bin/env bash
# Jalankan app dengan TMDB_API_KEY dari tmdb.local.properties.
# Pakai: ./run.sh                (device otomatis kalau cuma satu)
#        ./run.sh -d <deviceId>  (pilih device tertentu)
set -eu
exec flutter run --dart-define-from-file="$(dirname "$0")/tmdb.local.properties" "$@"
