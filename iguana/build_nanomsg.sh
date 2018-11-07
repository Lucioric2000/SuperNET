#!/bin/bash

#Check if libnanomsg-static.a file is already exists or not
if [[ "$OSTYPE" == "linux-gnu" ]]; then
	echo "Linux"
	file="../OSlibs/linux/$(uname -m)/libnanomsg.so.5"
	makedir="../OSlibs/linux/$(uname -m)/"
	copytarget="../OSlibs/linux/$(uname -m)/libnanomsg.so.5"
elif [[ "$OSTYPE" == "darwin"* ]]; then
	# Mac OSX
	echo "Mac OSX"
	file="../OSlibs/osx/$(uname -m)/libnanomsg.so.5"
	makedir="../OSlibs/osx/$(uname -m)/"
	copytarget="../OSlibs/osx/$(uname -m)/libnanomsg.so.5"
fi

if [ ! -f "$file" ]
then
    echo "$0: File '${file}' not found."
    #Download nanomsg library 1.0 stable
    rm -rf nanomsgsrc
	git clone https://github.com/nanomsg/nanomsg.git nanomsgsrc

	#Create destination folder
	mkdir nanomsglib

	#Switch into nanomsgsrc folder
	cd nanomsgsrc

	#Create build directory and switch into it
	mkdir build && cd build

	#Compile
	cmake .. -DCMAKE_INSTALL_PREFIX=../../nanomsglib/ -DCMAKE_BUILD_TYPE=Debug
	cmake --build .
	ctest -C Debug .
	cmake --build . --target install

	cd ../..
	pwd
	mkdir -p $makedir
	if [ -d nanomsglib/lib64 ];
	then
		#In x86_64 Sometimes the nanomsg libraries are written to a directory named lib64, and sometimes the directory is named lib 
		# (for example inside docker containers)
		cp -av nanomsglib/lib64/libnanomsg.so.5 $copytarget
	else
		cp -av nanomsglib/lib/libnanomsg.so.5 $copytarget
	fi
fi


