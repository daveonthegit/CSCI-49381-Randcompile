#!/bin/bash

echo "[*] Generating *_symbol_table files from core-mappings..."

for mapfile in *.core-mappings; do
    base="${mapfile%.core-mappings}"
    symfile="${base}.core_symbol_table"

    # Try multiple fallback symbols
    addr=$(grep -E 'init_task_union|init_task|swapper_pg_dir' "$mapfile" | head -n1 | awk '{print $1}' | sed 's/^0x//')

    if [[ -n "$addr" ]]; then
        echo "$addr T init_task" > "$symfile"
        echo "✓ $symfile created (from fallback @ $addr)"
    else
        echo "⚠️  Skipped $base — no known anchor symbol found"
    fi
done

