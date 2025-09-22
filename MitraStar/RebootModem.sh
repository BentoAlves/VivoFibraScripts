 #!/bin/bash
#set -x
#PASSWD=$1

PASSWD=<sua senha>

CURLTMP=$(curl http://192.168.15.1/cgi-bin/login.cgi -s | grep "var sid =")
SID=${CURLTMP:12:8}
echo "SID: ${SID}."

MD5TMP=$(echo -n "${PASSWD}:${SID}" | md5sum)
echo "MD5TMP: ${MD5TMP}."
LoginPasswordValue=${MD5TMP:0:32}
echo "LoginPasswordValue: ${LoginPasswordValue}."

CURLTMP=$(curl 'http://192.168.15.1/cgi-bin/login.cgi' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'Accept-Language: pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7' \
  -H 'Cache-Control: max-age=0' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Origin: http://192.168.15.1' \
  -H 'Referer: http://192.168.15.1/cgi-bin/login.cgi' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36' \
  --data-raw "Loginuser=admin&LoginPasswordValue=${LoginPasswordValue}&acceptLoginIndex=1" \
  --compressed \
  --insecure -v -s 2>&1 | grep "Set-Cookie: COOKIE_SESSION_KEY=")
echo "[${CURLTMP}]"
COOKIE_SESSION_KEY=${CURLTMP:33:32}
echo "data-raw: \"Loginuser=admin&LoginPasswordValue=${LoginPasswordValue}&acceptLoginIndex=1\""
echo "COOKIE_SESSION_KEY: ${COOKIE_SESSION_KEY}"

CURLTMP=$(curl 'http://192.168.15.1/cgi-bin/device-management-resets.cgi' \
  -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'Accept-Language: pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7' \
  -H 'Cache-Control: max-age=0' \
  -H 'Connection: keep-alive' \
  -H "Cookie: COOKIE_SESSION_KEY=${COOKIE_SESSION_KEY}" \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  -H 'Origin: http://192.168.15.1' \
  -H 'Referer: http://192.168.15.1/cgi-bin/login.cgi' \
  -H 'Upgrade-Insecure-Requests: 1' \
  -H 'User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/104.0.0.0 Safari/537.36' \
  --data-raw "restoreFlag=1&RestartBtn=RESTART" \
  --compressed \
  --insecure -v -s 2>&1 | grep sessionKey)
echo $CURLTMP
