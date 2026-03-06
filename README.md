# Photo Selector

A bash script that selects photos by number and moves them into a collection folder.

## Usage

```bash
./select_photos.sh <numbers_file> <photos_folder>
```

- `<numbers_file>`: A text file with one number per line
- `<photos_folder>`: A folder containing `.jpg`/`.JPG` photos

## Behavior

- Reads each number from the text file (skips blank lines)
- Searches the photos folder (non-recursively) for `.jpg`/`.JPG` files whose filename contains that number
- Moves any matches into `<photos_folder>/good photos/`, creating it if needed
- Leaves unmatched photos in place
- Prints each moved file and a final count

## Example

If `numbers.txt` contains `1042` and the folder has `IMG_1042.jpg`, that file gets moved to `good photos/`.

## Running the Tests

The `tests/` folder contains sample data and a test suite that verifies the script's behavior.

```bash
bash tests/run_tests.sh
```

The test suite uses:
- `tests/sample_photos/` — 10 fake `.jpg` files with various names
- `tests/numbers.txt` — 5 numbers that match exactly 5 of the photos

It verifies that:
- All 5 matched photos are moved into `good photos/`
- All 5 unmatched photos remain in their original location
- The `good photos/` folder is auto-created if it doesn't exist
- The script exits with an error on bad arguments, a missing numbers file, or a missing photos folder

A temporary working copy of the sample photos is created and cleaned up automatically on each run.

## Notes

If a photo's filename matches multiple numbers in the list, the second match attempt will silently skip it since the file was already moved.
