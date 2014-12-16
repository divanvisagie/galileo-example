#export IP="10.0.0.8"

function cleanup {
  rm -rf node_modules
}

function copy {
  echo  "Copying to:" "$IP"
  copy_command=$(printf "scp -r . root@%s:~/deploy" "$IP")
  $copy_command
}

function install {
  install_command=$(
    printf "ssh root@%s cd deploy; npm install ; exit" "$IP"
  )
  echo "$install_command"
  $install_command
}

function run {
  run_command=$(
    printf "ssh root@%s cd deploy; node index.js" "$IP"
  )
  echo "$run_command"
  $run_command
}

if [ $1 = "-i" ]; then 
  cleanup
  copy
  install

elif [ $1 = "-ir" ]; then
  cleanup
  copy
  install
  run

else
  cleanup
  copy
  run 
  
fi
