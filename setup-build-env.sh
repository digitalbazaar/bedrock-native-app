
# setup the android stuff
# export ANDROID_HOME="/usr/lib/Android/sdk"
# export ANDROID_SDK_ROOT="/usr/lib/Android/sdk"
# it helps if JAVA_HOME is the one android sdk uses internally
# export JAVA_HOME="/usr/lib/Android/Contents/jre/Contents/Home/"

# you will need to install the command line tools via android studio -> tools
# then you need to append them to PATH
PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/build-tools:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator

