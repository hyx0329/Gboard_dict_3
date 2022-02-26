# 注意 这不是占位符！！这个代码的作用是将模块里的东西全部塞系统里，然后挂上默认权限
SKIPUNZIP=0

install_counter=0

if [ -z "$MODPATH" ]; then
  MODPATH="."
fi

users=$(ls /data/user)

for user in $users; do

  uid=$(ls -n /data/user/$user | grep "com.google.android.inputmethod.latin" | awk '{print $3}')
  if [ -z "$uid" ]; then
    echo "- 用户 $user 没有安装Gboard"
    echo "- 跳过"
    continue
  fi

  echo "- 为用户 $user 安装词库"
  DICT_FILE=/data/user/$user/com.google.android.inputmethod.latin/files/user_dict_3_3
  mv $DICT_FILE $DICT_FILE.bak
  cp -f $MODPATH/user_dict_3_3 $DICT_FILE
  chown $uid $DICT_FILE
  chgrp $uid $DICT_FILE
  chmod 600 $DICT_FILE

  am force-stop --user $user com.google.android.inputmethod.latin

  install_counter=$(echo $install_counter + 1 | bc)

done

echo "- 有" $install_counter "位用户安装了词库"

if [ 0 -eq $install_counter ]; then
  abort "- 没有用户安装有Gboard"
  abort "- 终止安装"
fi
