owner="Lu7fer"
repo="Jar4Halo"


release_info=$(curl -sL "https://api.github.com/repos/$owner/$repo/releases/latest")


release_url=$(echo "$release_info" | grep -o "https://github.com/[^'\"]*\.jar")


curl -f -L -C -o halo.jar "$release_url"


export HALO_WORK_DIR="/home/runner/${REPL_SLUG}/.halo2"
export HALO_EXTERNAL_URL="https://${REPL_SLUG}.${REPL_OWNER}.repl.co"
export HALO_SECURITY_INITIALIZER_SUPERADMINUSERNAME="${USERNAME:-admin}"
export HALO_SECURITY_INITIALIZER_SUPERADMINPASSWORD="${PASSWORD:-password}"
java -jar -Duser.timezone=Asia/Shanghai halo.jar

