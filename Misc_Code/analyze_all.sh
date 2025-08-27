#!/bin/bash

set -e

mkdir -p logs

for core in *.core; do
  base="${core%.core}"
  echo "[*] Processing: $base"

  # Run kallsyms recovery
  docker run --rm -v "$PWD":/mnt -it randcompile-katana \
    python3 kallsyms_finder.py /mnt/"$core"

  # Rename symtab if needed
  if [ ! -f "$base.core-symtab" ] && [ -f "$base.core-kallsym" ]; then
    cp "$base.core-kallsym" "$base.core-symtab"
  fi

  # Run layout recovery
  docker run --rm -v "$PWD":/mnt -it randcompile-katana \
    evaluation/recover-offsets-from-dump.sh \
    /mnt/"$core" \
    db/fields.v5.15.5-def.txt \
    db/structinfo.v5.15.5-def.json

  # Run list_procs
  docker run --rm -v "$PWD":/mnt -it randcompile-katana \
    python3 list_procs.py \
    -s db/structinfo.v5.15.5-def.json \
    /mnt/"$core" > logs/katana_"$base".log 2>&1

  echo "✓ Done: $base → logs/katana_${base}.log"
done

