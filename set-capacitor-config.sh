echo "Creating capacitor.config.json from $NATIVE_APP_URL"
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
      "%s",
      "authn.io"
     ]
  },
  "plugins": {
    "CapacitorHttp": {
      "enabled": false
    }
  }
}' $NATIVE_APP_ID $NATIVE_APP_NAME $NATIVE_APP_URL $NATIVE_APP_URL > ./capacitor.config.json
