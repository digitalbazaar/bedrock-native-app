# first create the capacitor config
bash ./scripts/set-capacitor-config.sh
# then create the iOS project
npx cap add ios
# then create the android project
npx cap add android
# sync to make sure plugins are installed
npx cap sync
# for capacitor 4 we must patch the android project to work
# with a service worker
bash ./scripts/service-worker-android-patch.sh
# last the app manifests
bash ./scripts/set-native-app-manifests.sh
# generates icons and splash screens
npx capacitor-assets generate
# generate a generic application error screen
bash ./scripts/set-application-error.sh
