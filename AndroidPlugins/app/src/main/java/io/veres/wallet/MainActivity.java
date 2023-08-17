package io.veres.wallet;

import com.getcapacitor.BridgeActivity;
import android.os.Bundle;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
                registerPlugin(ServiceWorker.class);
        super.onCreate(savedInstanceState);
    }
}
