package com.benandow.android.gui.layoutRendererApp;

import android.app.Activity;
import android.os.Bundle;

public class GuiRipperActivity extends Activity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		GuiRipperBase base = new GuiRipperBase(this);
		base.renderLayout();
	}
}
