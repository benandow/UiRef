package com.benandow.android.gui.layoutRendererApp;

import android.os.Bundle;
import android.support.v4.app.FragmentActivity;

public class GuiRipperFragmentActivity extends FragmentActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		GuiRipperBase base = new GuiRipperBase(this);
		base.renderLayout();
	}
	
}
