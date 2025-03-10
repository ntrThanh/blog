#!/bin/bash

PDF_DIR="./assets/files"
POST_DIR="./_posts"

# Kiểm tra thư mục tồn tại
if [ ! -d "$PDF_DIR" ] || [ ! -d "$POST_DIR" ]; then
    echo "❗ Thư mục PDF hoặc bài viết không tồn tại. Vui lòng kiểm tra lại!"
    exit 1
fi

DATE=$(date +'%Y-%m-%d')
created_count=0
skipped_count=0

for file in "$PDF_DIR"/*.pdf; do
    if [ -f "$file" ]; then
        filename=$(basename -- "$file")
        title="${filename%.*}"
        safe_filename=$(echo "$filename" | sed 's/ /%20/g')  # Mã hóa khoảng trắng

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
    src="https://docs.google.com/gview?url={{ site.url }}/assets/files/$safe_filename&embedded=true" 
    style="width: 100%; height: 600px;" 
    frameborder="0">
</iframe>

[📥 Tải xuống PDF](./assets/files/$safe_filename)

EOL

            echo "✅ Đã tạo bài viết: $post_file"
            ((created_count++))
        else
            echo "⚠️ Bài viết cho $filename đã tồn tại, bỏ qua..."
            ((skipped_count++))
        fi
    fi
done

# Thông báo kết quả
echo "📊 Tổng kết:"
echo "  - Bài viết mới tạo: $created_count"
echo "  - Bỏ qua bài viết trùng: $skipped_count"

# Tự động commit và push lên GitHub
if (( created_count > 0 )); then
    echo "🚀 Đẩy bài viết mới lên GitHub..."
    git add _posts/
    git commit -m "Thêm bài viết mới từ PDF: $(date +'%Y-%m-%d %H:%M:%S')"
    git push
    echo "✅ Hoàn thành! Trang web đã được cập nhật."
else
    echo "🔔 Không có bài viết mới để đẩy lên GitHub."
fi
