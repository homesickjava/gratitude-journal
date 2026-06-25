#!/bin/bash
DATE=$(date +%Y-%m-%d)
FILE="journals/$DATE.md"

if [ ! -f "$FILE" ]; then
    cp templates/daily-template.md "$FILE"
    echo "✅ 已创建 $FILE"
else
    echo "⚠️  $FILE 已存在"
fi