package com.benandow.android.gui.layoutRendererApp;

import android.accounts.AccountAuthenticatorActivity;
import android.os.Bundle;

public class GuiRipperAccountAuthenticatorActivity extends AccountAuthenticatorActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		GuiRipperBase base = new GuiRipperBase(this);
		base.renderLayout();
	}
	
}
