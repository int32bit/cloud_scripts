#!/bin/bash

cat >.git/hooks/pre-commit <<'EOF'
#!/bin/bash

echo "Generage README.md ..."

README_PATH="./README.md"

echo "# Catalog" >$README_PATH

declare i=1
CURRENT_DIR=""
for script in $(find . | grep '.sh$'); do
    DIR_NAME=$(dirname $script)
    SCRIPT_NAME=$(basename $script)
    if [[ $DIR_NAME == '.' ]]; then
        continue
    fi
    if [[ $DIR_NAME != $CURRENT_DIR ]]; then
        echo -e "\n## ${DIR_NAME:2}\n"
        CURRENT_DIR=$DIR_NAME
        i=1
    fi
    DESC=$(cat $script | grep '# Description:' | cut -d ':' -f 2)
    echo "$i. [$SCRIPT_NAME]($script):$DESC"
    let i++
done >>$README_PATH
git add README.md
echo "done."
EOF
