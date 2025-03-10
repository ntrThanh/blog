#!/bin/bash

PDF_DIR="./assets/files"
POST_DIR="./_posts"

DATE=$(date +'%Y-%m-%d')

for file in "$PDF_DIR"/*.pdf; do
    if [ -f "$file" ]; then
        filename=$(basename -- "$file")
        title="${filename%.*}"
        
        post_file="$POST_DIR/${DATE}-${title// /-}.md"
        
        if [ ! -f "$post_file" ]; then
            echo "📝 Đang tạo bài viết cho $filename..."

            cat <<EOL > "$post_file"
---
layout: post
title: "$title"
date: $DATE
categories: [pdf, tài liệu]
---

## 📚 Tài liệu: $title

<iframe 
    src="https://docs.google.com/gview?url={{ site.url }}/assets/files/$filename.pdf&embedded=true" 
    style="width: 100%; height: 600px;" 
    frameborder="0">
</iframe>

[📥 Tải xuống PDF](./assets/files/$filename.pdf)

EOL

            echo "✅ Đã tạo bài viết: $post_file"
        else
            echo "⚠️ Bài viết cho $filename đã tồn tại, bỏ qua..."
        fi
    fi
done

# Tự động commit và push lên GitHub
echo "Đẩy bài viết mới lên GitHub..."
git add _posts/
git commit -m "Thêm bài viết mới từ PDF: $(date +'%Y-%m-%d %H:%M:%S')"
git push

echo "Hoàn thành! Trang web đã được cập nhật."
