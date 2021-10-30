package com.example.khsplan.dayfragments;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentManager;
import androidx.lifecycle.Lifecycle;
import androidx.viewpager2.adapter.FragmentStateAdapter;

import com.example.khsplan.dayfragments.fragment1;
import com.example.khsplan.dayfragments.fragment2;
import com.example.khsplan.dayfragments.fragment3;
import com.example.khsplan.dayfragments.fragment4;
import com.example.khsplan.dayfragments.fragment5;

public class FragmentAdapter extends FragmentStateAdapter {
    public FragmentAdapter(@NonNull FragmentManager fragmentManager, @NonNull Lifecycle lifecycle) {
        super(fragmentManager, lifecycle);
    }

    @NonNull
    @Override
    public Fragment createFragment(int position) {
        switch (position){
            case 1:
                return new fragment2();
            case 2:
                return new fragment3();
            case 3:
                return new fragment4();
            case 4:
                return new fragment5();
        }
        return new fragment1();
    }

    @Override
    public int getItemCount() {
        return 5;
    }
}
