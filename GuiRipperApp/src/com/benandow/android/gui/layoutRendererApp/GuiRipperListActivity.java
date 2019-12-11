package com.benandow.android.gui.layoutRendererApp;

import android.app.ListActivity;
import android.os.Bundle;

public class GuiRipperListActivity extends ListActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		GuiRipperBase base = new GuiRipperBase(this);
		base.renderLayout();
	}
	
}
