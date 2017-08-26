TERMUX_PKG_HOMEPAGE=https://developer.android.com/tools/sdk/ndk/index.html
TERMUX_SUBPKG_DESCRIPTION="multilib binaries for cross-compilation"
TERMUX_PKG_VERSION=$TERMUX_NDK_VERSION
TERMUX_PKG_NO_DEVELSPLIT=yes
TERMUX_PKG_KEEP_STATIC_LIBRARIES="true"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

prepare_libs () {
	local ARCH="$1"
	local SUFFIX="$2"
	local NDK_SUFFIX=$SUFFIX

	if [ $ARCH = x86 ] || [ $ARCH = x86_64 ]; then
	    NDK_SUFFIX=$ARCH
	fi

	mkdir -p $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib
	local BASEDIR=$NDK/platforms/android-${TERMUX_PKG_API_LEVEL}/arch-$ARCH/usr/lib
	if [ $ARCH = x86_64 ] || [ $ARCH = mips64 ]; then BASEDIR+="64"; fi
	cp $BASEDIR/*.o $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib

	LIBATOMIC=$NDK/toolchains/${NDK_SUFFIX}-*/prebuilt/linux-*/${SUFFIX}/lib
	if [ $ARCH = arm64 ]; then LIBATOMIC+="64"; fi
	cp $LIBATOMIC/libatomic.a $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/$SUFFIX/lib/libatomic.a
}

termux_step_extract_into_massagedir () {
	prepare_libs "arm" "arm-linux-androideabi"
	prepare_libs "arm64" "aarch64-linux-android"
	prepare_libs "x86" "i686-linux-android"
	prepare_libs "x86_64" "x86_64-linux-android"
	prepare_libs "mips" "mipsel-linux-android"
	prepare_libs "mips64" "mips64el-linux-android"
}
