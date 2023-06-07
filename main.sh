tag=$(curl -s "https://api.github.com/repos/Lu7fer/Jar4Halo/releases" | grep -o '"tag_name": "[^"]*' | head -n 1 | cut -d '"' -f 4)

compare_versions() {
  local v1=$1
  local v2=$2

  if [[ $v1 == $v2 ]]; then
    echo 0
    return
  fi

  local IFS=.
  local i a=($v1) b=($v2)

  for ((i=${#a[@]}; i<${#b[@]}; i++)); do
    a[i]=0
  done
  for ((i=${#b[@]}; i<${#a[@]}; i++)); do
    b[i]=0
  done

  for ((i=0; i<${#a[@]}; i++)); do
    if [[ -z ${a[i]//[-._]/} ]] && [[ -z ${b[i]//[-._]/} ]]; then
      # 如果两个部分都不包含非数字字符，则直接比较
      if ((10#${a[i]} < 10#${b[i]})); then
        echo -1
        return
      fi
      if ((10#${a[i]} > 10#${b[i]})); then
        echo 1
        return
      fi
    else

      if [[ ${a[i]} < ${b[i]} ]]; then
        echo -1
        return
      fi
      if [[ ${a[i]} > ${b[i]} ]]; then
        echo 1
        return
      fi
    fi
  done

  echo 0
}

compare_result=$(compare_versions "${tag%-SNAPSHOT}" "$(cat version.txt | sed 's/-SNAPSHOT//')")

if [[ $compare_result -gt 0 ]]; then
  echo "$tag" > version.txt
  echo "检测到更新，开始更新..."
  rm -f halo_*.jar
  wget "https://github.com/Lu7fer/Jar4Halo/releases/download/$tag/application-$tag.jar" -O halo_${tag}.jar
  echo "更新完毕！正在立即启动..."
else
  echo "已经是最新版本，无需更新！"
fi

export HALO_WORK_DIR="/home/runner/${REPL_SLUG}/.halo2"
export HALO_EXTERNAL_URL="https://${REPL_SLUG}.${REPL_OWNER}.repl.co"
export HALO_SECURITY_INITIALIZER_SUPERADMINUSERNAME="${USERNAME}"
export HALO_SECURITY_INITIALIZER_SUPERADMINPASSWORD="${PASSWORD}"
java -jar -Duser.timezone=Asia/Shanghai halo_${tag}.jar
