package com.benandow.android.gui.layoutRendererApp;

import android.os.Bundle;
import android.preference.PreferenceActivity;

public class GuiRipperPreferenceActivity extends PreferenceActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		GuiRipperBase base = new GuiRipperBase(this);
		base.renderLayout();
	}
	
}
