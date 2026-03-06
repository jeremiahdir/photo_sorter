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

## Notes

If a photo's filename matches multiple numbers in the list, the second match attempt will silently skip it since the file was already moved.
