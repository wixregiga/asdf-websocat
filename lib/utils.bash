#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/vi/websocat"

fail() {
  echo -e "asdf-websocat: $*"
  exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed -e '/^v[[:digit:]].*/!d' -e 's/^v//'
}

list_all_versions() {
  list_github_tags
}

function simple_gte() {
  local first_version second_version
  first_version=$(echo "${1//v/}" | awk -F'-' '{print $1}' | tr -d '.')
  if (( first_version >= 190 )); then
    echo 1
  fi
}

download_release() {
  local version filename platform architecture extension suffix url
  version="$1"
  filename="$2"
  platform="$3"
  architecture="$4"
  extension="$5"

  case "${platform}" in
    mac) suffix="${platform}" ;;
    linux)
      if simple_gte "${version}"; then
        suffix="${platform}${architecture//amd/}" #1
      else
        suffix="${architecture}-${platform}"
      fi
    ;;
    freebsd)
      if simple_gte "${version}"; then
        suffix="${platform}" #1
      else
        suffix="${architecture}-${platform}"
      fi
      ;;
    win) suffix="${platform}${architecture}" ;;
    *) fail "Unsupported platform: ${platform}" ;;
  esac
  url="$GH_REPO/releases/download/v${version}/websocat_${suffix}${extension}"

  echo "* Downloading websocat release $version..."
  curl "${curl_opts[@]}" -o "${filename}" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="$3"

  if [ "$install_type" != "version" ]; then
    fail "asdf-websocat supports release installs only"
  fi

  local platform extension
  extension=
  case "$OSTYPE" in
    darwin*) platform="mac" ;;
    FreeBSD*) platform="freebsd" ;;
    linux*) platform="linux" ;;
    msys*)
      platform=win
      extension=.exe
      ;;
    *) fail "Unsupported platform: ${OSTYPE}" ;;
  esac

  local architecture
  case "${HOSTTYPE}" in
    aarch64* | arm*) architecture="arm" ;;
    i686* | i386*) architecture="i386" ;;
    x86_64*) architecture="amd64" ;;
    mipsel*) architecture="mipsel" ;;
    32*) architecture="32" ;;
    64*) architecture="64" ;;
    *) fail "Unsupported architecture: ${HOSTTYPE}" ;;
  esac

  local release_file="$install_path/bin/websocat${extension}"
  (
    mkdir -p "$install_path/bin"
    download_release "$version" "$release_file" "$platform" "$architecture" "$extension"
    chmod +x "$release_file"

    echo "websocat $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing websocat $version."
  )
}
