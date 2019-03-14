#!/bin/bash

echo "----------------Install the Retrieval Node----------------"
echo "--------------(1)--Install Go----------------" 
is_go_installed=false
if which go >/dev/null; then
    echo "Go is detected, no need to install" 
    is_go_installed=true
else
    is_go_installed=false
fi

if [ "$is_go_installed" = false ] ; then
   echo "Go is not detected, is going to install now" 
   cd /tmp
   if [[ "$OSTYPE" == "linux-gnu" ]]; then
       wget https://dl.google.com/go/go1.11.linux-amd64.tar.gz
       is_go_installed=true
   elif [[ "$OSTYPE" == "darwin"* ]]; then
       wget https://dl.google.com/go/go1.12.darwin-amd64.pkg
       is_go_installed=true
   elif [[ "$OSTYPE" == "cygwin" ]]; then
       echo "Sorry you are runnung in an unSupported System"
   elif [[ "$OSTYPE" == "msys" ]]; then
       echo "Sorry you are runnung in an unSupported System"
   elif [[ "$OSTYPE" == "win32" ]]; then
       wget https://dl.google.com/go/go1.12.windows-amd64.msi
       is_go_installed=true
   elif [[ "$OSTYPE" == "freebsd"* ]]; then
       echo "Sorry you are runnung in an unSupported System"
   else
       echo "Sorry you are runnung in an unSupported System"
       fi
       if [ "$is_go_installed" = true ] ; then
              tar -xvf go1.11.linux-amd64.tar.gz
              mv go /usr/local
       fi
fi

if [ "$is_go_installed" = true ] ; then
       export GOROOT=/usr/local/go
       export GOPATH=$HOME/go
       export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
       echo "--------------(2)--Install Git---------------" 
       if which git >/dev/null; then
            echo "Git is detected" 
       else
            echo "Git is not detected, is going to install now" 
            sudo apt-get install git
       fi
       echo "--------------(3)--Install Go Libraries------" 
       cd ~/go/src
       mkdir -p  golang.org/x/
       cd golang.org/x
       git clone https://github.com/golang/sys.git
       echo "Installing github.com/gin-gonic/gin..."
       go get github.com/gin-gonic/gin
       echo "Installing encoding/json..."
       go get encoding/json
       echo "Installing Go Libraries Finish..."
       echo "--------------(4)--Make Configuration File---" 
       echo "Making Configuration File (Press Enter to use default setting)"
       echo "Please input x64_program_path (Default: /ks/afs_1e/): "
       read x64_program_path
       if [ -z "$x64_program_path" ] ; then
              x64_program_path="/ks/afs_1e/"
       fi
       echo "Please input x64_program_name (Default: afs-x64): "
       read x64_program_name
       if [ -z "$x64_program_name" ] ; then
              x64_program_name="afs-x64"
       fi
       echo "Please input the installation path (Default: /home/steven/): "
       read install_path
       if [ -z "$install_path" ] ; then
              install_path="/home/steven/"
       fi
       echo "Please input the host port (Default: 8080): "
       read host_port
       if [ -z "$host_port" ] ; then
              echo host_port="8080"
       fi
       echo "--------------(5)--Clone the source code-----" 
       echo "Cloning the Program (UserName: isnsastri , Password: astrisns1)"
       cd $install_path
       git clone http://isnsastri@github.com/s31b18/afs_rnode.git 

       go_path=$install_path
       go_path+="afs_rnode/conf.json"
       rm -r $go_path
       echo "{
               \"x64_program_path\": \""$x64_program_path"\",
               \"x64_program_name\": \""$x64_program_name"\",
               \"current_dir\": \""$install_path"afs_rnode/\",
               \"port\": \""$host_port"\" ,
               \"restful\" : {
                     \"upload\" : \"file/upload\",
                     \"download\" : \"file/download/:afid/:localfile\",
                     \"notify\" : \"file/notify/:afid\"
              }
       }" >> $go_path

       go_path_back=$install_path
       go_path_back+="afs_rnode/conf_back.json"
       echo "{
               \"x64_program_path\": \""$x64_program_path"\",
               \"x64_program_name\": \""$x64_program_name"\",
               \"current_dir\": \""$install_path"afs_rnode/\",
               \"port\": \""$host_port"\" ,
               \"restful\" : {
                     \"upload\" : \"file/upload\",
                     \"download\" : \"file/download/:afid/:localfile\",
                     \"notify\" : \"file/notify/:afid\"
              }
       }" >> $go_path_back
       echo "--------------Installation Complete----------" 
       exit 1
else
       echo "Installation Fail"
       exit 1
fi






