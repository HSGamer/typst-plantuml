# ===== Configuration =====
name          := `grep '^name' typst.toml | cut -d'"' -f2`
version       := `grep '^version' typst.toml | cut -d'"' -f2`
dist_dir      := "dist" / version
packages_fork := "git@github.com:HSGamer/typst-packages.git"
packages_dir  := "typst-packages"

# List available recipes
default:
    @just --list

# ===== Build =====

# Build WASM, package into dist/
build:
    @echo "Building WASM..."
    cargo build --release --target wasm32-unknown-unknown
    @mkdir -p {{ dist_dir }}
    @echo "Copying files to {{ dist_dir }}..."
    cp typst.toml {{ dist_dir }}/
    sed 's|target/wasm32-unknown-unknown/release/||g' lib.typ > {{ dist_dir }}/lib.typ
    cp target/wasm32-unknown-unknown/release/typst_plantuml.wasm {{ dist_dir }}/
    cp README.md {{ dist_dir }}/ 2>/dev/null || true
    cp LICENSE {{ dist_dir }}/ 2>/dev/null || true
    @echo "Done! Package is ready in {{ dist_dir }}"

# Build and check (dev mode, no release optimization)
check:
    cargo check --target wasm32-unknown-unknown

# ===== Test =====

# Preprocess and compile the test document
test:
    #!/usr/bin/env bash
    set -euo pipefail
    cd test
    prequery --root .. test.typ
    typst compile --root .. test.typ
    rm -rf ../assets/

# ===== Publish =====

# Publish to typst/packages: sparse-clone fork, copy dist, commit and push
publish:
    #!/usr/bin/env bash
    set -euo pipefail
    BRANCH="packages/{{ name }}/{{ version }}"
    PKG_PATH="packages/preview/{{ name }}/{{ version }}"

    if [ ! -d "{{ dist_dir }}" ]; then
        echo "Error: {{ dist_dir }} does not exist. Run 'just build' first."
        exit 1
    fi

    echo "Cloning {{ packages_fork }} (sparse)..."
    rm -rf "{{ packages_dir }}"
    git clone --depth 1 --sparse --filter=blob:none "{{ packages_fork }}" "{{ packages_dir }}"

    cd "{{ packages_dir }}"
    # Delete remote branch if it exists from a previous attempt
    git push origin --delete "$BRANCH" 2>/dev/null || true
    git checkout -b "$BRANCH"
    git sparse-checkout set "$PKG_PATH"

    echo "Copying {{ dist_dir }} → $PKG_PATH..."
    mkdir -p "$PKG_PATH"
    cp -r "../{{ dist_dir }}/." "$PKG_PATH/"

    git add "$PKG_PATH"
    git commit -m "{{ name }}:{{ version }}"
    git push -u origin "$BRANCH"

    cd ..
    rm -rf "{{ packages_dir }}"
    echo "Done! Branch '$BRANCH' pushed to {{ packages_fork }}"
    echo "Open a PR at https://github.com/typst/packages to publish."
