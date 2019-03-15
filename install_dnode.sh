#!/bin/bash

echo "----------------Install the Download Node----------------"
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
       echo "--------------(3)--Install Go Libraries------" 
       cd $goro
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
       echo "Please input search_node_url (Default: http://39.108.80.53:8081/search/node/db/): (You can add more in conf_back.json)"
       read search_node_url
       if [ -z "$search_node_url" ] ; then
              search_node_url="http://39.108.80.53:8081/search/node/db/"
       fi
       echo "Please input current node url (Default: http://127.0.0.1): "
       read current_node_url
       if [ -z "$current_node_url" ] ; then
              current_node_url="http://127.0.0.1"
       fi
       echo "Please input max download thread (Default: 2): "
       read max_download_thread
       if [ -z "$max_download_thread" ] ; then
              max_download_thread=2
       fi
       echo "Please input the host port (Default: 8080): "
       read host_port
       if [ -z "$host_port" ] ; then
              host_port="8080"
       fi
       echo "Please input the installation path (Default: /home/steven/): "
       read install_path
       if [ -z "$install_path" ] ; then
              install_path="/home/steven/"
       fi
       echo "--------------(5)--Clone the source code-----" 
       echo "Cloning the Program (UserName: isnsastri , Password: astrisns1)"
       cd $install_path
       git clone http://isnsastri@github.com/s31b18/afs_dnode.git  

       b="afs_dnode/conf.json"
       go_path=$install_path$b
       rm -r $go_path
       echo "{
              \"search_node_url\": [ \""$search_node_url"\" ] ,
               \"max_download_thread\": $max_download_thread,
               \"download_retry\": 5,
               \"notify_retry\": 5,
               \"port\": \""$host_port"\" ,
               \"restful\" : {
                     \"download\" : \"/download/file/\"
                       },
               \"current_node_url\": \""$current_node_url"\" 
       }"  >> $go_path

       b="afs_dnode/conf_back.json"
       go_path_back=$install_path$b
       echo "{
              \"search_node_url\": [ \""$search_node_url"\" ] ,
               \"max_download_thread\": $max_download_thread,
               \"download_retry\": 5,
               \"notify_retry\": 5,
               \"port\": \""$host_port"\" ,
               \"restful\" : {
                     \"download\" : \"/download/file/\"
                       },
               \"current_node_url\": \""$current_node_url"\" 
       }"   >> $go_path_back

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











