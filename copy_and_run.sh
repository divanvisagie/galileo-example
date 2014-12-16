#export IP="10.0.0.8"

function cleanup {
  rm -rf node_modules
}

function copy {
  echo  "Copying to:" "$IP"
  copy_command=$(printf "scp -r . root@%s:~/deploy_run" "$IP")
  $copy_command
}

function install {
  install_command=$(
    printf "ssh root@%s cd deploy_run; npm install ; exit" "$IP"
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

#this version uses git instead
function init_git {
  init_command=$(
    printf "ssh root@%s rm -rf deploy; mkdir deploy; cd deploy; git init --bare; exit" "$IP"
  )
  echo "$init_command"
  $init_command
  
  $add_remote=$("git remote add deploy ssh://root@%s/home/root/deploy" "$IP")
  echo $add_remote
  $add_remote
}

function push_and_checkout {
  $command = "git push --set-upstream deploy master"
  echo "$command"
  $command

  $checkout_command = $(
    printf "ssh root@%s git clone deploy deploy_run" "$IP"
  )
  echo $checkout_command
  $checkout_command
}

function git_run {
  run
}

#scp functions
if [ $1 = "-i" ]; then 
  cleanup
  copy
  install

elif [ $1 = "-ir" ]; then
  cleanup
  copy
  install
  run

#git functions
elif [ $1 = "--git" ]; then
  echo "Warning: using git may have issues, this is a work in progress"
  if [ $2 = "init" ]; then
    init_git
  elif [ $2 = "run" ]; then
    push_and_checkout
    install
    git_run
  fi

#default
else
  cleanup
  copy
  run 
  
fi
