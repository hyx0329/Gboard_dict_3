#!/system/bin/sh

for user in $(ls /data/user); do
  uid=$(ls -n /data/user/$user | grep "com.google.android.inputmethod.latin" | awk '{print $3}')
  if [ -n "$uid" ]; then
    echo "- 尝试为用户 $user 恢复备份(如果有)"
    DICT_FILE=/data/user/$user/com.google.android.inputmethod.latin/files/user_dict_3_3
    mv $DICT_FILE.bak $DICT_FILE
    chown $uid $DICT_FILE
    chgrp $uid $DICT_FILE
    chmod 600 $DICT_FILE
    am force-stop --user $user com.google.android.inputmethod.latin
  fi
done
