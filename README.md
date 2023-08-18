# bedrock-native-app
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
Capacitor provides iOS Setup instructions [here.](https://capacitorjs.com/docs/getting-started/environment-setup#ios-requirements)

Libraries:
- SdkMan *optional* (mostly for gradle)
- Android Studio *required*

### iOS

Capacitor provides instructions [here.](https://capacitorjs.com/docs/getting-started/environment-setup#homebrew)

Libraries:
- MacOs *required*
- Brew *optional* (most popular package manager on MacOs)
- Cocopods *required* (installed via Brew)
- [Xcodes](https://github.com/RobotsAndPencils/xcodes) or
    - Xcode *required*
    - Xcode Command Line Tools *required*

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
In Android Studio use either Preferences or Tools -> SDK Manager.
Click on `SDK Tools` and then install `Android SDK Build Tools`, `Android SDK Command Line Tools`,
and `Android SDK Platform tools`. Check the version of those tools the installed versioned of Capacitor requires.

Copy the `Android SDK Location` from SDK Manager and use it as an environment variable called: `ANDROID_SDK_ROOT`
Call `source ./scripts/setup-build-env.sh` to ensure the android command line tools etc are in `$PATH`.

Capacitor and the latest version of Android Studio might not be compatible.
To add support for older Android versions install an older version of Android SDK and an emulator.
Access SDK versions from preferences or use Tools -> SDK Manager to manage SDK versions.
Create an emulator that matches that SDK version from Tools -> Device Manager.
[Capacitor provides these SDK setup docs](https://capacitorjs.com/docs/getting-started/environment-setup#android-sdk)

### iOS
For the most part iOS is prettty straight forward provided XCode and XCode command line tools are installed.
If xcodebuild throws this error:

```
[error] xcode-select: error: tool 'xcodebuild' requires Xcode, but active developer directory
        '/Library/Developer/CommandLineTools' is a command line tools instance
```

Select an Xcode version.

Determine where the needed version of `Xcode.app` is installed and replace the path below with it. 
```sh
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
```

That will set the xcode version to a different version (this is usually an older version of XCode).
Quite often the XCode installed on upgrade is incompatible wih Capacitor and will require selecting
an older version of XCode in order for Capacitor to work.

Build environemtns change with each version of Capacitor and as Mobile development
frameworks update. Capacitor's list of  supported platforms is [here](https://capacitorjs.com/docs/getting-started/faqs#official-platforms).


### Adding an Android or iOS project

To add a new Android project:
```
npx cap add android
```

To add a new iOS project:
```
npx cap add ios
```

These projects need various plugins in them provided by a sync:

```
npx cap sync
```

These projects will need subtle modifications in order to work with Service Workers,
and allow external sites such as `authn.io` to be usable in a WebView.
4 env variables are needed for this script:
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

The env variables can be stored in this repo in a file named `native-app-config.sh`.

Once those variables are set run this:
```
npm run set-app-manifests
```

or alternatively:
```
bash ./scripts/set-native-app-manifests.sh 
```

### Bedrock / Server for Deep Links
In order to support deep links that open the application the server will need to serve two json files.
Both of those files are served from the `/.well-known` route.

- [Capacitor's App Links docs are recommended and here](https://capacitorjs.com/docs/guides/deep-links)
- [Android App Links docs are here](https://developer.android.com/training/app-links/verify-android-applinks#multi-site)
- [iOS Universal Links docs are here](https://developer.apple.com/documentation/xcode/supporting-associated-domains?language=objc)

Associated domains and app intents should be handled by the `set-app-manifests` command.
Create the `apple-app-site-association` and `assetlinks.json` files using the docs above.
For iOS the app must be linked to an apple developer account inside of XCode.
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
The web application should use the capacitor plugin `@capacitor/app`.

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
