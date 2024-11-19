#!/bin/sh -e

echo "Creating capacitor.config.json for $NATIVE_APP_URL"
ALLOW_NAVIGATION="";
if [ "$NATIVE_APP_DOMAINS" ]; then
  for value in $NATIVE_APP_DOMAINS; do
    ALLOW_NAVIGATION="$ALLOW_NAVIGATION \"${value}\","
  done
fi
# remove trailing commas and/or spaces
ALLOW_NAVIGATION=$(sed 's/,*[ \t]*$//g' <<< "$ALLOW_NAVIGATION");

printf '{
  "appId": "%s",
  "appName": "%s",
  "bundledWebRuntime": false,
  "webDir": "./www",
  "loggingBehavior": "debug",
  "android": {
    "webContentsDebuggingEnabled": true,
    "allowMixedContent": true
  },
  "ios": {
    "limitsNavigationsToAppBoundDomains": true
  },
  "server": {
    "url": "https://%s",
    "allowNavigation": [
      %s
     ],
    "errorPath": "applicationError.html"
  },
  "plugins": {
    "CapacitorHttp": {
      "enabled": false
    }
  }
}' $NATIVE_APP_ID "$NATIVE_APP_NAME" $NATIVE_APP_URL "$ALLOW_NAVIGATION" > ./capacitor.config.json
