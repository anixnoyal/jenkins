find /path/to/efs/mounted/files -type f ! -name "secret.key" -exec grep -Iq . {} \; -and -exec cat {} > /dev/null \;
