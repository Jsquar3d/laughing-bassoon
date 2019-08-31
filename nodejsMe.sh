#!/bin/bash

priv=$(whoami)
if [ "$priv" != "root" ]
then
	printf "\nScript must be ran as root use sudo !!\n\n"
	exit
else
	cat banner.txt
	printf "\ntype: help for command list\n"
	 
fi

function userHelp(){

	printf "\nCommands:\n"
	printf "\n\t install \t Installs nodejs on system.\n"
	printf "\t update  \t Updates nodejs to new version.\n"
	printf "\t version \t Outputs current installed version.\n"
	printf "\t unistall\t Uninstalls nodejs from system.\n"
	printf "\t exit    \t Exits NodejsMe cleanly.\n"
}

function nodejsInstall(){	
	printf "\n [*] Installing latest stable nodejs\n\n"
	sleep "0.50"
	wget https://nodejs.org/en/download/
	cat index.html | grep linux-x64.tar.xz | awk -F/ '{ print $5 }' > .njsme
	rm index.html && wget https://nodejs.org/dist/$(cat .njsme)/node-$(cat .njsme)-linux-x64.tar.xz
        tar -xvf node-$(cat .njsme)-linux-x64.tar.xz && cd node-$(cat .njsme)-linux-x64
	cd bin && mv node npm npx /usr/bin
	cd .. && cd include && mv node /usr/include
	cd .. && cd lib && mv node_modules /usr/lib
	cd .. && cd share && cd doc && mv node /usr/share/doc
	cd .. && cd man && cd man1 && mv node.1 /usr/share/man/man1
	cd .. && cd .. && cd systemtap && cd tapset && mv node.stp /usr/share/systemtap/tapset
	cd .. && cd .. && cd .. && cd ..
	rm -r node-$(cat .njsme)-linux-x64 && rm node-$(cat .njsme)-linux-x64.tar.xz
}

function updateInstall(){       
        printf "\n [*] Updating with latest stable nodejs\n\n"
	sleep "0.50"
        wget https://nodejs.org/en/download/
        cat index.html | grep linux-x64.tar.xz | awk -F/ '{ print $5 }' > .njsme
        rm index.html && wget https://nodejs.org/dist/$(cat .njsme)/node-$(cat .njsme)-linux-x64.tar.xz
        tar -xvf node-$(cat .njsme)-linux-x64.tar.xz && cd node-$(cat .njsme)-linux-x64
        cd bin && mv node npm npx /usr/bin
        cd .. && cd include && mv node /usr/include
        cd .. && cd share && cd doc && mv node /usr/share/doc
        cd .. && cd man && cd man1 && mv node.1 /usr/share/man/man1
        cd .. && cd .. && cd systemtap && cd tapset && mv node.stp /usr/share/systemtap/tapset
        cd .. && cd .. && cd .. && cd ..
        rm -r node-$(cat .njsme)-linux-x64 && rm node-$(cat .njsme)-linux-x64.tar.xz
	printf "\n[*] Update completed\n\n"
}

function nodejsUpdate(){
       printf "\n[*] Checking if new nodejs version exists\n\n"
       sleep "0.50"
       wget https://nodejs.org/en/download/
       verCheck=$(cat index.html | grep linux-x64.tar.xz | awk -F/ '{ print $5 }')
       ver=$(cat .njsme)
       if [ "$ver" == "$verCheck" ]
       then
	       printf "\n[*] Current version is up to date doing nothing\n\n"
	       rm index.html
       else          
	       printf "\n[*] Updating nodejs and replacing old install\n\n"
	       rm index.html
	       chmod 777 .njsme && rm .njsme
	       cleanUp
	       updateInstall
	       printf "\n[*] All new and shiny\n\n"
       fi
}

function nodejsUninstall(){
	printf "\n[*] Removing nodejs from system completely\n"
	sleep "0.50"
	myDir=$(pwd)
	cd /usr/bin && rm node npm npx && cd ..
	cd include && rm -r node && cd ..
	cd lib && rm -r node_modules && cd ..
	cd share/doc && rm -r node && cd ..
	cd man/man1 && rm node.1 && cd /usr/share
	cd systemtap/tapset && rm node.stp && cd $myDir
	printf "\n[*] All files for nodejs have been removed\n\n"
}

function cleanUp(){
        printf "\n[*] Cleaning up files from previous version and leaving node_modules"
	sleep "0.50"
        myDir=$(pwd)
        cd /usr/bin && rm node npm npx && cd ..
        cd include && rm -r node && cd ..
        cd share/doc && rm -r node && cd ..
        cd man/man1 && rm node.1 && cd /usr/share
        cd systemtap/tapset && rm node.stp && cd $myDir
        rm .njsme CHANGELOG.md LICENSE README.md
}

function main(){
	printf "\nEnter command: "
	read userInput
	if [ "$userInput" == "version" ]
	then
		if [ -e .njsme ]
		then
			printf "\nInstalled version is: $(cat .njsme)\n"
                	main
		else
			printf "\nMust install first to check version\n"
			main
		fi
	elif [ "$userInput" == "install" ]
	then
		if [ -e .njsme ]
		then
			printf "\n You already have an install perhaps you want to update\n"
			main
		else
		    	nodejsInstall
			main
		fi
	elif [ "$userInput" == "update" ]
	then
		if [ -e .njsme ]
		then
			nodejsUpdate
			main
		else
			printf "\nMust install before trying to update ;)\n"
			main
		fi
	elif [ "$userInput" == "uninstall" ]
	then
		if [ -e .njsme ]
		then
			printf "\n[*] Uninstalling nodejs now\n\n"
			nodejsUninstall
			main
		else
			printf "\nMust install before trying to unistall ;)\n"
			main
		fi
	elif [ "$userInput" == "exit" ]
	then
		printf "\nExiting now\n\n"
		exit
	elif [ "$userInput" == "help" ]
	then
		userHelp
		main
	else
		printf "\nInvalid command entered!\n"
		main
	fi
}
main
