#!/bin/bash -x

add_user_to_passwd() {
  myuid=$(id -u)
  mygid=$(id -g)
  uidentry=$(getent passwd $myuid)

  if [ -z "$uidentry" ] ; then
      # assumes /etc/passwd has root-group (gid 0) ownership
      echo "$myuid:x:$myuid:$mygid:anonymous uid:/home/user:/bin/false" >> /etc/passwd
  fi
}

id=$(id -u)
if [ $id != 0 ]; then
    add_user_to_passwd
    set -e
    if [[ "$1" =~ '-' ]]; then
        exec /idea-cli-inspector $@
    fi
else
    set -e
    if [[ "$1" =~ '-' ]]; then
        CMD="cd /project && /idea-cli-inspector $@"
        echo "Calling $CMD"
        exec sudo -H -n -u ideainspect bash -l -c "$CMD"
    fi
fi

echo "Executing $@"
exec "$@"
