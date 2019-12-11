package com.benandow.android.gui.layoutRendererApp;

import android.app.TabActivity;
import android.os.Bundle;

@SuppressWarnings("deprecation")
public class GuiRipperTabActivity extends TabActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		GuiRipperBase base = new GuiRipperBase(this);
		base.renderLayout();
	}
	
}
