#!/usr/bin/env bash
set -euo pipefail

api_url="${PETFOOD_API_BASE_URL:-${PETFOOD_API_URL:-}}"
api_key="${PETFOOD_API_KEY:-}"

if [[ -z "${api_url}" ]]; then
  echo "Missing PETFOOD_API_BASE_URL or PETFOOD_API_URL for iOS build." >&2
  exit 1
fi

if [[ -z "${api_key}" ]]; then
  echo "Missing PETFOOD_API_KEY for iOS build." >&2
  exit 1
fi

mkdir -p ios/Config

# xcconfig treats // as a comment marker, so escape URL slashes with $().
escaped_api_url="$(printf '%s' "${api_url}" | sed 's#//#/$()/#g')"

{
  echo "PETFOOD_API_BASE_URL = ${escaped_api_url}"
  echo "PETFOOD_API_KEY = ${api_key}"
} > ios/Config/Secrets.xcconfig
