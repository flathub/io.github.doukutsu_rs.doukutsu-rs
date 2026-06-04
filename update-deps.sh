#!/usr/bin/env bash

set -xeuo pipefail

TARGET_DOUKUTSU_VERSION="${1:-1.0.0}"
TARGET_EXTRACTOR_VERSION="${1:-1.0.2}"

DOUKUTSU_LOCK_FILE_DIR=$(mktemp -d)
EXTRACTOR_LOCK_FILE_DIR=$(mktemp -d)
cleanup() {
  rm -r "$DOUKUTSU_LOCK_FILE_DIR"
  rm -r "$EXTRACTOR_LOCK_FILE_DIR"
}

trap cleanup EXIT

# curl -fsSL "https://github.com/doukutsu-rs/doukutsu-rs/archive/refs/tags/${TARGET_DOUKUTSU_VERSION}.tar.gz" | tar xzf - -C "$DOUKUTSU_LOCK_FILE_DIR"
curl -fsSL "https://github.com/doukutsu-rs/doukutsu-rs/archive/${TARGET_DOUKUTSU_VERSION}.tar.gz" |  tar xzf - -C "$DOUKUTSU_LOCK_FILE_DIR"
podman run --rm -it \
  -v .:/tmp/build:Z \
  -v "$DOUKUTSU_LOCK_FILE_DIR:$DOUKUTSU_LOCK_FILE_DIR:Z" \
  --pull newer \
  docker.io/library/python:latest \
  sh -c "pip install aiohttp toml && /tmp/build/flatpak-builder-tools/cargo/flatpak-cargo-generator.py ${DOUKUTSU_LOCK_FILE_DIR}/doukutsu-rs-${TARGET_DOUKUTSU_VERSION}/Cargo.lock -o /tmp/build/cargo-sources-doukutsu.json"

curl -fsSL "https://github.com/doukutsu-rs/vanilla-extractor/archive/refs/tags/v${TARGET_EXTRACTOR_VERSION}.tar.gz" | tar xzf - -C "$EXTRACTOR_LOCK_FILE_DIR"
podman run --rm -it \
  -v .:/tmp/build:Z \
  -v "$EXTRACTOR_LOCK_FILE_DIR:$EXTRACTOR_LOCK_FILE_DIR:Z" \
  --pull newer \
  docker.io/library/python:latest \
  sh -c "pip install aiohttp toml && /tmp/build/flatpak-builder-tools/cargo/flatpak-cargo-generator.py ${EXTRACTOR_LOCK_FILE_DIR}/vanilla-extractor-${TARGET_EXTRACTOR_VERSION}/Cargo.lock -o /tmp/build/cargo-sources-vanilla-extractor.json"
