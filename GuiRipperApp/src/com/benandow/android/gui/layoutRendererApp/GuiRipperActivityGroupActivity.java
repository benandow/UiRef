package com.benandow.android.gui.layoutRendererApp;

import android.app.ActivityGroup;
import android.os.Bundle;

@SuppressWarnings("deprecation")
public class GuiRipperActivityGroupActivity extends ActivityGroup {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		GuiRipperBase base = new GuiRipperBase(this);
		base.renderLayout();
	}
	
}
