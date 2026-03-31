#!/bin/bash

# --- Configuration ---
SOURCE_DIR="$HOME/Downloads"
BASE_DOCS="$HOME/Documents"
DEST_FILE_LOG="$SOURCE_DIR/filemove.log"

# Define destinations
DEST_DIR_PDF="${BASE_DOCS}/PDFs"
DEST_DIR_TXT="${BASE_DOCS}/TXTs"
DEST_DIR_ISO="${BASE_DOCS}/ISOs"
DEST_DIR_CSV="${BASE_DOCS}/CSVs"
DEST_DIR_ZIP="${BASE_DOCS}/ZIPs"
DEST_DIR_DEB="${BASE_DOCS}/DEBs"
DEST_DIR_XJORPP="${BASE_DOCS}/Xournalpp/"
DEST_DIR_EPUB="${BASE_DOCS}/EPUBs/"
DEST_DIR_PICS="${BASE_DOCS}/IMAGEs/"
DEST_DIR_PPT="${BASE_DOCS}/PPTs/"
DEST_DIR_MP4="${BASE_DOCS}/MP3_4s/"



# --- Setup ---

# 1. Enable Case Insensitive Matching (matches .png and .PNG)
shopt -s nocaseglob

# 2. Ensure all destination directories exist
DEST_DIRS=(
  "$DEST_DIR_PDF" "$DEST_DIR_TXT" "$DEST_DIR_ISO" 
  "$DEST_DIR_CSV" "$DEST_DIR_ZIP" "$DEST_DIR_DEB" 
  "$DEST_DIR_XJORPP" "$DEST_DIR_EPUB" "$DEST_DIR_PICS"
  "$DEST_DIR_PPT" "$DEST_DIR_MP4"
)

for dir in "${DEST_DIRS[@]}"; do
  mkdir -p "$dir"
done

# 3. Ensure the directory for the log file exists
mkdir -p "$(dirname "$DEST_FILE_LOG")"

# --- Functions ---

move_and_log() {
  local file_path="$1"
  local dest_dir="$2"
  local file_name
  
  file_name=$(basename "$file_path")

  # Attempt to move the file
  if mv "$file_path" "$dest_dir"; then
    echo "$(date): Moved existing file: $file_name to $dest_dir" >> "$DEST_FILE_LOG"
  else
    echo "$(date): ERROR - Failed to move $file_name" >> "$DEST_FILE_LOG"
  fi
}

# --- Main Execution ---

for FILE in "$SOURCE_DIR"/*; do
  # Check if it is a file (not a directory)
  if [ -f "$FILE" ]; then
    case "$FILE" in
      *.pdf)
        move_and_log "$FILE" "$DEST_DIR_PDF"
        ;;
      *.txt|*.doc|*.docx|*.odt|*.rtf|*.md) # Added odt, rtf, md for completeness
        move_and_log "$FILE" "$DEST_DIR_TXT"
        ;;
      *.iso|*.img) # Added img
        move_and_log "$FILE" "$DEST_DIR_ISO"
        ;;
      *.csv|*.xls|*.xlsx|*.xlsm|*.ods) # Added ods (LibreOffice)
        move_and_log "$FILE" "$DEST_DIR_CSV"
        ;;
      *.zip|*.tar|*.tar.gz|*.tar.xz|*.tar.bz2|*.7z|*.rar|*.tar.lz|*.gz)
        move_and_log "$FILE" "$DEST_DIR_ZIP"
        ;;
      *.deb|*.rpm)
        move_and_log "$FILE" "$DEST_DIR_DEB"
        ;;
      *.xopp)
        move_and_log "$FILE" "$DEST_DIR_XJORPP"
        ;;
      *.epub|*.mobi|*.azw3) # Added Kindle formats
        move_and_log "$FILE" "$DEST_DIR_EPUB"
        ;;
      *.png|*.jpg|*.jpeg|*.gif|*.webp|*.svg|*.bmp|*.tiff|*.ico|*.heic)
        move_and_log "$FILE" "$DEST_DIR_PICS"
        ;;
      *.ppt|*.pptx|*.pps|*.ppsx|*.pot|*.potx|*.odp)
        move_and_log "$FILE" "$DEST_DIR_PPT"
        ;;
      *.mp4|*.mkv|*.avi|*.mov|*.wmv|*.flv|*.webm|*.m4v|*.mpg|*.mpeg|*.3gp|*.ts|*.ogv|*.mp3|*.wav|*.flac|*.aac|*.ogg|*.m4a|*.wma|*.aiff|*.opus|*.srt|*.vtt|*.sub|*.ass|*.ssa|*.idx)
        move_and_log "$FILE" "$DEST_DIR_MP4"
        ;;
      *)
        # File type not configured, do nothing
        ;;
    esac
  fi
done
