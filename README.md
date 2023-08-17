# bedrock-native-app
=======
# bedrock-native-wallet
Capacitor wrapper for Bedrock Web Apps as Native WebViews

## Table of Contents

- [Background](#background)
- [Install](#install)
- [Setup](#setup)
- [Usage](#usage)


## Background
Bedrock applications have typically not run as native apps on mobile platforms.
This library allows that to happen.

## Install
For this libraries dependencies:
```
npm i
```

### Android
- SdkMan (mostly for gradle)
- Android Studio

### iOS

Capacitor provides instructions [here.](https://capacitorjs.com/docs/getting-started/environment-setup#homebrew)

In total you will need:
- MacOs
- Brew
- Cocopods (installed via Brew)
- [Xcodes](https://github.com/RobotsAndPencils/xcodes) or
    - Xcode
    - Xcode Command Line Tools

If brew fails to install:

```sh
sudo rm -rf /opt/homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```
then try to install again



## Setup
Bedrock Native Wallet uses [Capacitor.js](https://capacitorjs.com/docs/) for the native app.
Capacitor has a large number of commands that can be used.

### Android
Capacitor needs several tools installed that don't necessarily come installed with Android Studio.
In Android Studio you can use either Preferences or Tools -> SDK Manager.
You will need to click on `SDK Tools` and then install `Android SDK Build Tools`, `Android SDK Command Line Tools`,
and `Android SDK Platform tools`. You might need to click on those items and install older versions of them.

You will need to copy the `Android SDK Location` from SDK Manager and use it as an environment variable called: `ANDROID_SDK_ROOT`
Then you will need to call `source setup-build-env.sh` to ensure the android command line tools etc are in your path.

Capacitor and the latest version of Android Studio might not be compatible.
If this is the case you will need to install an older version of Android SDK and an emulator.
[Capacitor provides these SDK setup docs](https://capacitorjs.com/docs/getting-started/environment-setup#android-sdk)
You can access SDK versions from preferences or use Tools -> SDK Manager to manage SDK versions.
You will then need to create an emulator that matches that SDK version from Tools -> Device Manager.

### iOS
For the most part iOS is prettty straight forward provided you have XCode and XCode command line tools.
If you have issues with xcodebuild:

"""
[error] xcode-select: error: tool 'xcodebuild' requires Xcode, but active developer directory
        '/Library/Developer/CommandLineTools' is a command line tools instance
"""

You need to select an Xcode version.

Determine where your desired `Xcode.app` is installed and replace the path below with it. 
```sh
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

That will set the xcode version to a different version (this is usually an older version of XCode).
Quite often the XCode installed on upgrade is incompatible wih Capacitor and will require you to select
an older version of XCode in order for Capacitor to work.

Build environemtns change with each version of Capacitor and as Mobile development
frameworks update. Below are some links to help with setup. Capacitor's list of 
supported platforms is [here](https://capacitorjs.com/docs/getting-started/faqs#official-platforms).


### Adding an Android or iOS project

To add a new Android project:
```
npx cap add android
```

To add a new iOs project:
```
npx cap add ios
```

These projects need various plugins in them so you will need to do a sync:

```
npx cap sync
```

These projects will need subtle modifications in order to work with Service Workers,
and allow external sites such as `authn.io` to be usable in a WebView.

## Usage
Bedrock Native Wallet uses [Capacitor.js](https://capacitorjs.com/docs/) for the native app.
Capacitor has a large number of commands that can be used.

To open the app in its respective development tool:
```
npx cap open ios
npx cap open android
```

To run the app in an emulator with out opening a development tool:
```
npx cap run ios
npx cap run android
```
