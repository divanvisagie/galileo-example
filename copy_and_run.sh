#export IP="10.0.0.8"

function cleanup {
  rm -rf node_modules
}

function copy {
  echo  "Copying to:" "$IP"
  command=$(printf "ssh root@%s mkdir deploy_run" "$IP")
  echo "$command"
  $command
  for i in $( ls ); do
    echo item: $i
    copy_command=$(printf "scp -r %s root@%s:~/deploy_run/" "$i" "$IP")
    $copy_command
  done
 }

function install {
  install_command=$(
    printf "ssh root@%s cd deploy_run; npm install" "$IP"
  )
  echo "$install_command"
  $install_command
}

function run {
  run_command=$(
    printf "ssh root@%s cd deploy_run; node index.js" "$IP"
  )
  echo "$run_command"
  $run_command
}


#scp functions
if [ $1 = "-i" ]; then 
  copy
  install

elif [ $1 = "-ir" ]; then
  copy
  install
  run

else
  copy
  run 
  
fi
