package com.benandow.android.gui.layoutRendererApp;

import android.app.AliasActivity;
import android.os.Bundle;

public class GuiRipperAliasActivity extends AliasActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		GuiRipperBase base = new GuiRipperBase(this);
		base.renderLayout();
	}
	
}
