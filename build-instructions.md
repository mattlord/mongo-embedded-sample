# MongoDB Embedded Tarball Build Steps

## Machine
I used a Debian 9.2 x86_64 build host to cross compile for Debian 9 armhf.

## Steps

1. Specify our build details:
```
$ export BUILD_DIR=$HOME/mongodb-embedded
$ export MONGOC_VERSION=1.13.0
$ export MONGO_VERSION=4.0.6
$ export BUILD_TYPE=debian9-armhf
$ export INSTALL_DIR=$HOME/mongo-embedded-sdk-$MONGO_VERSION
``` 

2. Create directories for the work:
```
$ mkdir $BUILD_DIR
$ mkdir $INSTALL_DIR
```

3. Install the ARM cross compilation toolchain:
``` $ sudo apt install crossbuild-essential-armhf ```

4. Build the Mongo C Driver

    1. Get the Mongo C Driver source (1.13.0 or later is required):
    ``` $  cd $BUILD_DIR && git clone -b $MONGOC_VERSION --depth 1 https://github.com/mongodb/mongo-c-driver.git ```

    1. Install cmake: `$ sudo apt install cmake`

    1. Build and install it: 
    ``` $ cd mongo-c-driver/ && cmake -DENABLE_SHM_COUNTERS=OFF -DENABLE_SNAPPY=OFF -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF -DENABLE_ZLIB=OFF -DENABLE_SSL=OFF -DENABLE_SASL=OFF -DENABLE_TESTS=OFF -DENABLE_SRV=OFF -DENABLE_TESTS=OFF -DENABLE_EXAMPLES=OFF -DENABLE_STATIC=OFF -DCMAKE_C_COMPILER=/usr/bin/arm-linux-gnueabihf-gcc -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_RPATH=\$ORIGIN/../lib -DCMAKE_C_FLAGS="-flto" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" . && make install ```

1. Build the MongoDB Embedded SDK

    1. Setup the bfd-plugins dir so that we can use LTO and link-model=dynamic-sdk:
    ```
    $ sudo mkdir /usr/lib/bfd-plugins && cd /usr/lib/bfd-plugins/
    $ sudo ln -s /usr/lib/gcc/x86_64-linux-gnu/6/liblto_plugin.so
    ```
      Note: *This step should only be necessary on Debian/Ubuntu machines due to [this bug](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=865690).*

    2. Get the MongoDB source (4.0.4 or later is required):
    ``` $ cd $BUILD_DIR && git clone -b r$MONGO_VERSION --depth 1 https://github.com/mongodb/mongo.git ``` 

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
    ``` $ cd mongo && python ./buildscripts/scons.py CC=/usr/bin/arm-linux-gnueabihf-gcc CXX=/usr/bin/arm-linux-gnueabihf-g++ --link-model=dynamic-sdk --install-mode=hygienic --disable-warnings-as-errors --enable-free-mon=off --js-engine=none --dbg=off --opt=size --wiredtiger=off --use-system-mongo-c=on --allocator=system --lto --prefix=$INSTALL_DIR CPPPATH="$INSTALL_DIR/include/libbson-1.0 $INSTALL_DIR/include/libmongoc-1.0" LIBPATH="$INSTALL_DIR/lib" install-embedded-dev -j$(grep -c ^processor /proc/cpuinfo) ```

    1. Save the build:
    ``` $ cd $HOME && tar czvf mongo-embedded-sdk-$MONGO_VERSION-$BUILD_TYPE.tar.gz ./mongo-embedded-sdk-$MONGO_VERSION/ ```

1. Download and build the sample app:
```
$ wget https://gist.githubusercontent.com/mattlord/4926ddb4a1d46292e1296f9951f7ca17/raw/5901c318a0aa55f7c9c731b69ebdfa4ac1ca6e41/iot_guestbook.c
$ /usr/bin/arm-linux-gnueabihf-gcc -flto -I$INSTALL_DIR/include/{libbson-1.0,libmongoc-1.0,mongoc_embedded/v1,mongo_embedded/v1} -L$INSTALL_DIR/lib -lmongoc_embedded -lmongo_embedded -lmongoc-1.0 -lbson-1.0 -w -o iot_guestbook iot_guestbook.c
```
