find /path/to/efs/mounted/files -type f ! -name "*secret.key*" -atime +7 -exec sh -c '
  for file; do
    if grep -Iq . "$file"; then
      echo "Processing: $file"
      cat "$file" > /dev/null
    else
      echo "Skipping binary file: $file"
    fi
  done
' sh {} +
#
