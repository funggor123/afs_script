#!/bin/bash

echo "----------------Install the Proxy Node----------------"
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
   echo "Please input the go root (Default: /home/steven/go/): "
   read goroot
   if [ -z "$goroot" ] ; then
        goroot="/home/steven/go"
   fi
   echo "Please input the go path (Default: /home/steven/work/): "
   read gopath
   if [ -z "$gopath" ] ; then
        gopath="/home/steven/work"
   fi
   cd /tmp
   if [ "$OSTYPE" = "linux-gnu" ] ; then
       wget https://dl.google.com/go/go1.11.linux-amd64.tar.gz
       is_go_installed=true
   elif [ "$OSTYPE" = "darwin"* ] ; then
       wget https://dl.google.com/go/go1.12.darwin-amd64.pkg
       is_go_installed=true
   elif [ "$OSTYPE" = "cygwin" ] ; then
       echo "Sorry you are runnung in an unSupported System"
   elif [ "$OSTYPE" = "msys" ] ; then
       echo "Sorry you are runnung in an unSupported System"
   elif [ "$OSTYPE" = "win32" ] ; then
       wget https://dl.google.com/go/go1.12.windows-amd64.msi
       is_go_installed=true
   elif [ "$OSTYPE" = "freebsd"* ] ; then
       echo "Sorry you are runnung in an unSupported System"
   else
       wget https://dl.google.com/go/go1.11.linux-amd64.tar.gz
       is_go_installed=true
       fi
       if [ "$is_go_installed" = true ] ; then
              tar -xvf go1.11.linux-amd64.tar.gz
              mv go $goroot
	      mkdir $gopath/src
              mkdir $gopath/bin
              export GOROOT=$goroot
              export GOPATH=$gopath
              export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
       fi
fi

if [ "$is_go_installed" = true ] ; then
       goro=$(go env GOPATH)/src
       echo $goro
       echo "--------------(2)--Install Git---------------" 
       if which git >/dev/null; then
            echo "Git is detected" 
       else
            echo "Git is not detected, is going to install now" 
            sudo apt-get install git
       fi
       echo "--------------(3)--Make Configuration File---" 
       echo "Making Configuration File (Press Enter to use default setting)"
       echo "Please input the host domain (Default: 127.0.0.1): "
       read host_domain
       if [ -z "$host_domain" ] ; then
              host_domain="127.0.0.1"
       fi
       echo "Please input the installation path (Default: /home/steven/): "
       read install_path
       if [ -z "$install_path" ] ; then
              install_path="/home/steven/"
       fi
       echo "--------------(3)--Clone the source code-----" 
       echo "Cloning the Program (UserName: isnsastri , Password: astrisns1)"
       cd $install_path
       git clone http://isnsastri@github.com/s31b18/afs_pnode.git 
       echo "--------------(4)--Install Ngrok------" 
       a=afs_pnode
       cd $install_path$a
       echo "Cloning Ngrok"
       git clone https://github.com/inconshreveable/ngrok.git
       echo "Installing Ngrok"
       cd ngrok
       make

       b="afs_pnode/conf.json"
       go_path=$install_path$b
       rm -r $go_path
       echo "{
               \"host_domain\": \""$host_domain"\"
       }" >> $go_path

       b="afs_pnode/conf_back.json"
       go_path_back=$install_path$b
       echo "{
               \"host_domain\": \""$host_domain"\"
       }" >> $go_path_back

       echo "
	      export GOROOT=$goroot
              export GOPATH=$gopath
              export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
       " >> ./gosource
       echo "--------------Installation Complete----------" 
       exit 1
else
       echo "Installation Fail"
       exit 1
fi






