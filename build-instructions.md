# MongoDB Embedded Tarball Build Steps

## Machine
I used a Debian 9 x86_64 build host to cross compile for Debian 9 armhf.

## Steps

1. Create directories for the work:
```
$ mkdir ~/mongodb-embedded && cd ~/mongodb-embedded
$ mkdir mongo-embedded-sdk-4.0.latest 
```

2. Install the ARM cross compilation toolchain:
``` $ sudo apt install crossbuild-essential-armhf ```

3. Build the Mongo C Driver

    1. Get the latest Mongo C Driver source (1.13):
    ``` $ git clone -b r1.13 https://github.com/mongodb/mongo-c-driver.git ```

    1. Install cmake: `$ sudo apt install cmake`

    1. Build and install it: 
    ``` $ cd mongo-c-driver/ && cmake -DENABLE_SHM_COUNTERS=OFF -DENABLE_SNAPPY=OFF -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF -DENABLE_ZLIB=OFF -DENABLE_SSL=OFF -DENABLE_SASL=OFF -DENABLE_TESTS=OFF -DENABLE_SRV=OFF -DENABLE_TESTS=OFF -DENABLE_EXAMPLES=OFF -DENABLE_STATIC=OFF -DCMAKE_C_COMPILER=/usr/bin/arm-linux-gnueabihf-gcc -DCMAKE_INSTALL_RPATH=\$ORIGIN/../lib -DCMAKE_C_FLAGS="-flto" -DCMAKE_INSTALL_PREFIX=\$ORIGIN/../.. . && make install ```

1. Build the MongoDB 4.0 Embedded SDK

    1. Setup the bfd-plugins so that we can use LTO and library collapse (link-model=dynamic-sdk):
    ```
    $ sudo apt install llvm-3.8-dev
    $ sudo mkdir /usr/lib/bfd-plugins && cd /usr/lib/bfd-plugins/
    $ sudo ln -s /usr/lib/llvm-3.8/lib/LLVMgold.so
    $ sudo ln -s /usr/lib/gcc/x86_64-linux-gnu/6/liblto_plugin.so
    ```
      Note: *step 4.i should only be necessary on Debian/Ubuntu machines.*

    2. Get the latest MongoDB 4.0 source:
    ``` $ cd ~/mongodb-embedded && git clone -b v4.0 https://github.com/mongodb/mongo.git ``` 

    1. Install the python requirements:
    ```
    $ cat > ./python-requirements.txt <<EOF
    cheetah3==3.1.0
    pyyaml==3.13
    typing==3.6.4
    EOF
    $ sudo pip install -r ./python-requirements.txt
    ```
    
    1. Build and install the Embedded SDK:
    ``` $ cd mongo && python ./buildscripts/scons.py CC=/usr/bin/arm-linux-gnueabihf-gcc CXX=/usr/bin/arm-linux-gnueabihf-g++ --link-model=dynamic-sdk --install-mode=hygienic --disable-warnings-as-errors --enable-free-mon=off --js-engine=none --dbg=off --opt=size --wiredtiger=off --use-system-mongo-c=on --allocator=system --prefix=$PWD/.. CCFLAGS="-flto" CPPPATH="$PWD/../include/libbson-1.0 $PWD/../include/libmongoc-1.0" LIBPATH="$PWD/../lib" install-embedded-dev -j16 ```

    1. Save the build:
    ``` $ cd ~/mongodb-embedded && tar czvf mongo-embedded-sdk-4.0.latest-debian9-armhf.tar.gz ./mongo-embedded-sdk-4.0.latest/ ```

1. Download and build the sample app:
```
$ wget https://gist.githubusercontent.com/mattlord/4926ddb4a1d46292e1296f9951f7ca17/raw/5901c318a0aa55f7c9c731b69ebdfa4ac1ca6e41/iot_guestbook.c
$ /usr/bin/arm-linux-gnueabihf-gcc -flto -I$HOME/mongodb-embedded/mongo-embedded-sdk-4.0.latest/include/{libbson-1.0,libmongoc-1.0,mongoc_embedded/v1,mongo_embedded/v1} -L$HOME/mongodb-embedded/mongo-embedded-sdk-4.0.latest/lib -lmongoc_embedded -lmongo_embedded -lmongoc-1.0 -lbson-1.0 -w -o iot_guestbook iot_guestbook.c
```
