#!/usr/bin/env bash

set -euo pipefail

SCRIPT="$(cd "$(dirname "$0")/.." && pwd)/select_photos.sh"
TESTS_DIR="$(cd "$(dirname "$0")" && pwd)"
SAMPLE_PHOTOS_SRC="$TESTS_DIR/sample_photos"
NUMBERS_FILE="$TESTS_DIR/numbers.txt"

pass=0
fail=0

assert() {
    local description="$1"
    local condition="$2"
    if eval "$condition"; then
        echo "  PASS: $description"
        pass=$((pass + 1))
    else
        echo "  FAIL: $description"
        fail=$((fail + 1))
    fi
}

# Set up a fresh working copy of the sample photos for each test run
setup() {
    local dir="$TESTS_DIR/tmp_photos"
    rm -rf "$dir"
    cp -r "$SAMPLE_PHOTOS_SRC" "$dir"
    echo "$dir"
}

echo ""
echo "=== Test: Matched photos are moved to 'good photos' ==="
photos_dir="$(setup)"
bash "$SCRIPT" "$NUMBERS_FILE" "$photos_dir" > /dev/null
assert "IMG_1001.jpg moved"       "[[ -f '$photos_dir/good photos/IMG_1001.jpg' ]]"
assert "IMG_2044.jpg moved"       "[[ -f '$photos_dir/good photos/IMG_2044.jpg' ]]"
assert "vacation_5500.jpg moved"  "[[ -f '$photos_dir/good photos/vacation_5500.jpg' ]]"
assert "trip_7890.jpg moved"      "[[ -f '$photos_dir/good photos/trip_7890.jpg' ]]"
assert "DSC_0042.jpg moved"       "[[ -f '$photos_dir/good photos/DSC_0042.jpg' ]]"

echo ""
echo "=== Test: Unmatched photos remain in original folder ==="
assert "IMG_1002.jpg untouched"   "[[ -f '$photos_dir/IMG_1002.jpg' ]]"
assert "IMG_1003.jpg untouched"   "[[ -f '$photos_dir/IMG_1003.jpg' ]]"
assert "IMG_2045.jpg untouched"   "[[ -f '$photos_dir/IMG_2045.jpg' ]]"
assert "DSC_0099.jpg untouched"   "[[ -f '$photos_dir/DSC_0099.jpg' ]]"
assert "random_photo.jpg untouched" "[[ -f '$photos_dir/random_photo.jpg' ]]"

echo ""
echo "=== Test: Matched photos no longer in root folder ==="
assert "IMG_1001.jpg not in root" "[[ ! -f '$photos_dir/IMG_1001.jpg' ]]"
assert "IMG_2044.jpg not in root" "[[ ! -f '$photos_dir/IMG_2044.jpg' ]]"
assert "vacation_5500.jpg not in root" "[[ ! -f '$photos_dir/vacation_5500.jpg' ]]"
assert "trip_7890.jpg not in root" "[[ ! -f '$photos_dir/trip_7890.jpg' ]]"
assert "DSC_0042.jpg not in root" "[[ ! -f '$photos_dir/DSC_0042.jpg' ]]"

echo ""
echo "=== Test: 'good photos' folder is created automatically ==="
photos_dir2="$(setup)"
rm -rf "$photos_dir2/good photos"
bash "$SCRIPT" "$NUMBERS_FILE" "$photos_dir2" > /dev/null
assert "'good photos' folder created" "[[ -d '$photos_dir2/good photos' ]]"

echo ""
echo "=== Test: Custom output folder path ==="
photos_dir3="$(setup)"
custom_out="$TESTS_DIR/tmp_custom_output"
rm -rf "$custom_out"
bash "$SCRIPT" "$NUMBERS_FILE" "$photos_dir3" "$custom_out" > /dev/null
assert "Custom output folder created"        "[[ -d '$custom_out' ]]"
assert "IMG_1001.jpg in custom folder"       "[[ -f '$custom_out/IMG_1001.jpg' ]]"
assert "IMG_1001.jpg not in photos root"     "[[ ! -f '$photos_dir3/IMG_1001.jpg' ]]"
assert "Default 'good photos' not created"   "[[ ! -d '$photos_dir3/good photos' ]]"
rm -rf "$custom_out"

echo ""
echo "=== Test: Script exits with error on missing arguments ==="
set +e
bash "$SCRIPT" 2>/dev/null
exit_code=$?
set -e
assert "Exits non-zero with no args" "[[ $exit_code -ne 0 ]]"

echo ""
echo "=== Test: Script exits with error on bad numbers file ==="
set +e
bash "$SCRIPT" "/nonexistent/file.txt" "$photos_dir" 2>/dev/null
exit_code=$?
set -e
assert "Exits non-zero with bad numbers file" "[[ $exit_code -ne 0 ]]"

echo ""
echo "=== Test: Script exits with error on bad photos folder ==="
set +e
bash "$SCRIPT" "$NUMBERS_FILE" "/nonexistent/folder" 2>/dev/null
exit_code=$?
set -e
assert "Exits non-zero with bad photos folder" "[[ $exit_code -ne 0 ]]"

# Cleanup
rm -rf "$TESTS_DIR/tmp_photos"

echo ""
echo "================================"
echo "Results: $pass passed, $fail failed"
echo "================================"
echo ""

[[ $fail -eq 0 ]]
