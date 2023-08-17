package io.veres.wallet;

import android.os.Build;
import android.webkit.WebResourceResponse;
import android.webkit.ServiceWorkerController;
import android.webkit.ServiceWorkerClient;
import android.webkit.WebResourceRequest;
import androidx.annotation.RequiresApi;
import com.getcapacitor.Plugin;
import com.getcapacitor.annotation.CapacitorPlugin;

/*
 *
 * Adapted from https://stackoverflow.com/questions/55894716/how-to-package-a-hosted-web-app-with-ionic-capacitor
 *
 * This allows Capacitor plugins and service workers in Android WebView Apps.
 * This solves an issue where Capacitor's javascript injection conflicts or is delayed
 * by a ServiceWorker.
 */
@CapacitorPlugin(name = "ServiceWorker")
public class ServiceWorker extends Plugin {
    @RequiresApi(api = Build.VERSION_CODES.N)
    @Override
    public void load() {
        ServiceWorkerController swController = ServiceWorkerController.getInstance();

        swController.setServiceWorkerClient(new ServiceWorkerClient() {
            @Override
            public WebResourceResponse shouldInterceptRequest(WebResourceRequest request) {
                return bridge.getLocalServer().shouldInterceptRequest(request);
            }
        });
    }
}
