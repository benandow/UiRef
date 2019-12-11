package com.benandow.android.gui.layoutRendererApp;

import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;

@SuppressWarnings("deprecation")
public class GuiRipperActionBarActivity extends ActionBarActivity {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		GuiRipperBase base = new GuiRipperBase(this);
		base.renderLayout();
	}
}
