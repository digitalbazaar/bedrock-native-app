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
you will need 4 env variables for this script:
```
cat native-app-config.sh
# NATIVE_APP_URL which is the server url
export NATIVE_APP_URL="https://myapp.mydomain.com"
# NATIVE_APP_DOMAIN which is the root domain with no subdomains
export NATIVE_APP_DOMAIN="mydomain.com"
# NATIVE_APP_ID A java namespace for the app and app id
export NATIVE_APP_ID="com.mydomain.native.app"
# NATIVE_APP_NAME The name of the app as kebab case string (no spaces)
export NATIVE_APP_NAME="My Native App"
```

You can store them in this repo in a file named `native-app-config.sh` if you wish.

Once those variables are set you can run this:
```
npm run set-app-manifests
```

Alternatively you can run:
```
bash ./scripts/set-native-app-manifests.sh 
```

### Bedrock / Server for Deep Links
In order to support deep links that open your application you will need to serve two json files
from your web app. Both of those files are served from the `/.well-known` route.

[Capacitor's App Links docs are recommended and here](https://capacitorjs.com/docs/guides/deep-links)
[Android App Links docs are here](https://developer.android.com/training/app-links/verify-android-applinks#multi-site)
[iOS Universal Links docs are here](https://developer.apple.com/documentation/xcode/supporting-associated-domains?language=objc)

Associated domains and app intents should be handled by the `set-app-manifests` command.
All you need to do is create the `apple-app-site-association` and `assetlinks.json` files.
A single site apple site association file will look like this:
```
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "APPLE-APP-DEVELOPER-SECRET.com.digitalbazaar.native",
        "paths": ["/native-app/*"]
      }
    ]
  }
}
```
A simple one site `assetlinks.json` file will look like this:
```
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target" : { "namespace": "android_app", "package_name": "com.digitalbazaar.native",
               "sha256_cert_fingerprints": ["ANDROID-APP-HASH"] }
}]
```
You will also need to modify your web application using the capacitor plugin `@capacitor/app`.

```js
// require capacitor core so it registers
import '@capacitor/core';
import {App} from '@capacitor/app';
 
export function forwardNativeAppLinks() {
  App.addListener('appUrlOpen', function(event) {
    // the event can be null so ?. is better
    const url = event?.url;
    // if the event has no url just return
    if(!url) {
      return;
    }
    // get the origin
    const {origin} = new URL(url);
    // remove the origin and the /native-app from it
    const path = event.url.replace(origin + '/native-app', '');
    // if there is a path go to it
    if(path) {
      window.location.href = path;
    }
  });
}
```

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
