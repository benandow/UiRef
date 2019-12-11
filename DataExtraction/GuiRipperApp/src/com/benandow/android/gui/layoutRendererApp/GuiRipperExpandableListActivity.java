package com.benandow.android.gui.layoutRendererApp;

import android.app.ExpandableListActivity;
import android.os.Bundle;

public class GuiRipperExpandableListActivity extends ExpandableListActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		GuiRipperBase base = new GuiRipperBase(this);
		base.renderLayout();
	}
	
}
