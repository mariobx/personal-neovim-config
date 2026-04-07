#!/bin/bash

# --- Configuration ---
SOURCE_DIR="$HOME/Downloads"
BASE_DOCS="$HOME/Documents"
LOG_FILE="$SOURCE_DIR/filemove.log"

# Setup destinations (Mapping extension to folder)
declare -A DEST_MAP=(
    ["pdf"]="$BASE_DOCS/PDFs"
    ["txt"]="$BASE_DOCS/TXTs" ["doc"]="$BASE_DOCS/TXTs" ["docx"]="$BASE_DOCS/TXTs" ["md"]="$BASE_DOCS/TXTs"
    ["iso"]="$BASE_DOCS/ISOs" ["img"]="$BASE_DOCS/ISOs"
    ["csv"]="$BASE_DOCS/CSVs" ["xlsx"]="$BASE_DOCS/CSVs" ["ods"]="$BASE_DOCS/CSVs"
    ["zip"]="$BASE_DOCS/ZIPs" ["tar"]="$BASE_DOCS/ZIPs" ["gz"]="$BASE_DOCS/ZIPs" ["7z"]="$BASE_DOCS/ZIPs"
    ["deb"]="$BASE_DOCS/DEBs" ["rpm"]="$BASE_DOCS/DEBs"
    ["xopp"]="$BASE_DOCS/Xjournalpp"
    ["epub"]="$BASE_DOCS/EPUBs" ["mobi"]="$BASE_DOCS/EPUBs"
    ["png"]="$BASE_DOCS/IMAGEs" ["jpg"]="$BASE_DOCS/IMAGEs" ["webp"]="$BASE_DOCS/IMAGEs"
    ["ppt"]="$BASE_DOCS/PPTs" ["pptx"]="$BASE_DOCS/PPTs"
    ["mp4"]="$BASE_DOCS/Media" ["mp3"]="$BASE_DOCS/Media" ["mkv"]="$BASE_DOCS/Media"
)

# Create folders
for dir in "${DEST_MAP[@]}"; do
    mkdir -p "$dir"
done

# Ensure log exists
touch "$LOG_FILE"

# --- Logic ---
shopt -s nocaseglob

for FILE in "$SOURCE_DIR"/*; do
    # Skip if not a file or if it's an active download
    [[ -f "$FILE" ]] || continue
    [[ "$FILE" == *.part ]] || [[ "$FILE" == *.crdownload ]] && continue

    EXT="${FILE##*.}"
    DEST="${DEST_MAP[${EXT,,}]}"

    if [[ -n "$DEST" ]]; then
        # Fixed the -t flag you broke. Target directory comes FIRST.
        if mv -t "$DEST" "$FILE"; then
            echo "$(date): Moved $(basename "$FILE") to $DEST" >> "$LOG_FILE"
        else
            echo "$(date): ERROR - Failed to move $(basename "$FILE")" >> "$LOG_FILE"
        fi
    fi
done
