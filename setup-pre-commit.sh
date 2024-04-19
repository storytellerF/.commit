destination_dir=".git/hooks"
target_file="${destination_dir}/pre-commit"
if [ -f "$target_file" ]; then
    if diff -q $target_file .commit/pre-commit.template >/dev/null; then
        echo "Replace old file."
    else
        echo "No op."
        exit 0
    fi
fi

# 将pre-commit.template 作为git hooks 的文件
# 实际执行的是pre-commit.sh，可以随意修改此文件而不必重复设置
# 生成时间戳，格式为YYYYMMDD-HHMMSS
timestamp=$(date +%Y%m%d-%H%M%S)

# 构造含有时间戳的目标文件名
destination_file="${destination_dir}/pre-commit.$timestamp"

[ -f "$target_file" ] && cp "$target_file" "$destination_file"
cp .commit/pre-commit.template "$target_file"
if xattr -p com.apple.provenance "$target_file" &>/dev/null; then
    if [[ "$(uname)" == "Darwin" ]]; then
        xattr -d com.apple.provenance "$target_file"
    fi
fi

chmod +x "$target_file"
