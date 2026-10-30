package com.cleanyourtv.launcher;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    private boolean isLocked = true;
    private View lockScreenView;
    private View homeScreenView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        lockScreenView = findViewById(R.id.lock_screen_view);
        homeScreenView = findViewById(R.id.home_screen_view);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (isLocked && (keyCode == KeyEvent.KEYCODE_DPAD_CENTER || keyCode == KeyEvent.KEYCODE_ENTER)) {
            unlockWithLiquidAnimation();
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }

    private void unlockWithLiquidAnimation() {
        isLocked = false;

        ObjectAnimator scaleX = ObjectAnimator.ofFloat(lockScreenView, "scaleX", 1.0f, 1.25f);
        ObjectAnimator scaleY = ObjectAnimator.ofFloat(lockScreenView, "scaleY", 1.0f, 1.25f);
        ObjectAnimator alpha = ObjectAnimator.ofFloat(lockScreenView, "alpha", 1.0f, 0.0f);

        AnimatorSet liquidRipple = new AnimatorSet();
        liquidRipple.playTogether(scaleX, scaleY, alpha);
        liquidRipple.setDuration(450);

        liquidRipple.addListener(new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                lockScreenView.setVisibility(View.GONE);
                if (homeScreenView != null) {
                    homeScreenView.requestFocus();
                }
            }
        });

        liquidRipple.start();
    }
}
