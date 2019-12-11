package com.benandow.android.gui.userStudy.graphics;

import java.awt.Checkbox;
import java.awt.Graphics;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.io.IOException;
import java.util.HashMap;

import javax.swing.JButton;
import javax.swing.JComponent;
import javax.swing.JLabel;
//import javax.swing.JOptionPane;
import javax.swing.JTextArea;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;

import org.xml.sax.SAXException;

import com.benandow.android.gui.layoutModel.HierarchyNode;
import com.benandow.android.gui.layoutModel.LayoutWriter;
import com.benandow.android.gui.userStudy.graphics.AnnotatedField.FieldType;

public class HierarchyCanvas extends JComponent{

	private static final long serialVersionUID = 5385545824846413000L;

//	private static String FIELD_TYPE_NOT_SELECTED = "Error: You must denote whether the field is a title or a label.";
	
	private ScreenPlot mPlot;
	
	private AnnotatedField mAnchorField;
	
	private JLabel mLayoutLabel;
	private Checkbox titleCB, labelCB;	
	private JTextArea associatedFields;
	private JButton clearButton, saveButton, doneButton;

	private boolean annotatingLayout = false;
	
	public HierarchyCanvas(int width, int height, ScreenPlot plot){
		this.mPlot = plot;
		
		mLayoutLabel = new JLabel("Field ID = null");
		mLayoutLabel.setBounds(0, 0, width, 20);
		
		initCheckBoxes();

		this.associatedFields = new JTextArea(5,5);
		this.associatedFields.setBounds(0, 80, width-50, 200);
		this.associatedFields.setLineWrap(true);
		
		initButtons();

		this.add(mLayoutLabel);
		this.add(titleCB);
		this.add(labelCB);
		this.add(this.associatedFields);
		this.add(saveButton);
		this.add(clearButton);
		this.add(doneButton);
		enableButtons(false);
		this.saveButton.setEnabled(true);
	}
	
	private void clearDataAndResetScreen(){
		mAnchorField.reset();
		resetScreen();
	}
	
	private void resetScreen(){
		this.mAnchorField.setAnchor(false);
		this.mAnchorField = null;
		this.annotatingLayout = false;
		this.titleCB.setState(false);
		this.labelCB.setState(false);
		this.associatedFields.setText("");
		setLabelText("null");
		enableButtons(false);
		this.mPlot.reset();
	}
	
	private void initButtons(){
		this.clearButton = new JButton("Clear");
		this.clearButton.setBounds(0, 300, 100, 20);
		
		ActionListener clearBtnListener = new ActionListener(){
			@Override
			public void actionPerformed(ActionEvent e) {
				if(e.getID() == ActionEvent.ACTION_PERFORMED){
					clearDataAndResetScreen();
				}
			}
		};
		this.clearButton.addActionListener(clearBtnListener);
		
		this.saveButton = new JButton("Begin");
		this.saveButton.setBounds(130, 300, 100, 20);
		
		ActionListener saveBtnListener = new ActionListener(){
			@Override
			public void actionPerformed(ActionEvent e) {
				if(e.getID() == ActionEvent.ACTION_PERFORMED){
					if(!mPlot.begin){
						mPlot.begin = true;
						saveButton.setText("Save");
						mPlot.draw();
						enableButtons(false);
					}else{
//						if(mAnchorField != null && mAnchorField.getType() == FieldType.UNKNOWN){
//							JOptionPane.showMessageDialog(null, FIELD_TYPE_NOT_SELECTED);
//						}else{
						if(mAnchorField != null){
							mAnchorField.setType(FieldType.LABEL);
						}
							resetScreen();
//						}
					}
				}
			}
		};
		
		this.saveButton.addActionListener(saveBtnListener);
		
		
		this.doneButton = new JButton("Done");
		this.doneButton.setBounds(130, 330, 100, 20);
		
		ActionListener doneButtonListener = new ActionListener(){
			@Override
			public void actionPerformed(ActionEvent e) {
				if(e.getID() == ActionEvent.ACTION_PERFORMED){
					HashMap<String, HierarchyNode> map = mPlot.getAnnotatedFields();
					try {
						LayoutWriter.transformHierarchy(mPlot.getInputFile(), mPlot.getOutputFile(), null, null, map);
						mPlot.nextLayout();					
					} catch (ParserConfigurationException e1) {
						e1.printStackTrace();
					} catch (SAXException e1) {
						e1.printStackTrace();
					} catch (IOException e1) {
						e1.printStackTrace();
					} catch (TransformerException e1) {
						e1.printStackTrace();
					}
				}
			}
		};
		
		this.doneButton.addActionListener(doneButtonListener);
		
	}
	
	private void enableButtons(boolean enable){
		this.titleCB.setEnabled(enable);
		this.labelCB.setEnabled(enable);
		this.saveButton.setEnabled(enable);
		this.clearButton.setEnabled(enable);
	}
	
	private void initCheckBoxes(){
		this.titleCB = new Checkbox("Title");
		this.titleCB.setBounds(0, 50, 100, 20);
		this.labelCB = new Checkbox("Label");
		this.labelCB.setBounds(100, 50, 100, 20);

		ItemListener cboxListener = new ItemListener(){
			@Override
			public void itemStateChanged(ItemEvent e) {
				if(titleCB.getState()){
					labelCB.setEnabled(false);
					if(mAnchorField != null){
						mAnchorField.setType(FieldType.TITLE);
					}
				}else if(labelCB.getState()){
					titleCB.setEnabled(false);
					if(mAnchorField != null){
						mAnchorField.setType(FieldType.LABEL);
					}
				}else if(titleCB.isEnabled() || labelCB.isEnabled() ){
					titleCB.setEnabled(true);
					labelCB.setEnabled(true);
					if(mAnchorField != null){
						mAnchorField.setType(FieldType.UNKNOWN);
					}
				}			
			}
		};
		this.titleCB.addItemListener(cboxListener);
		this.labelCB.addItemListener(cboxListener);
	}
	
	private void restoreData(AnnotatedField field){
		if(!field.getAssociatedFields().isEmpty()){
			for(AnnotatedField f : field.getAssociatedFields()){
				f.highlight();
			}
			setAssociatedFieldText();
		}
		if(field.getType() == FieldType.TITLE){
			this.titleCB.setState(true);
			this.labelCB.setEnabled(false);
		}else if(field.getType() == FieldType.LABEL){
			this.labelCB.setState(true);
			this.titleCB.setEnabled(false);
		}
	}
	
	public void selectField(AnnotatedField field){
		if(field == null || !this.mPlot.begin){
			return;
		}else if(field.equals(this.mAnchorField)){
			resetScreen();
			return;
		}
		
		if(annotatingLayout){			
			if((field.getNode().containsText() && field.isHighlighted()) ||
				(!field.getNode().containsText() && !field.isHighlighted())){
				this.mAnchorField.removeAssociatedField(field);
			}else{
				this.mAnchorField.addAssociatedField(field);
			}
			field.highlight();
			setAssociatedFieldText();
			return;
		}
		
		// We don't want to set empty nodes as anchor
//		if(!field.getNode().containsText()){
//			return;
//		}
		
		field.highlight();
		this.annotatingLayout = true;
		this.mAnchorField = field;
		this.mAnchorField.setAnchor(true);
		enableButtons(true);
		this.setLabelText(this.mAnchorField.getNode().getCounterId());
		restoreData(field);
	}
	
	private void setAssociatedFieldText(){		
		String text = "";
		for(AnnotatedField field :  this.mAnchorField.getAssociatedFields()){
			text += field.getNode().getCounterId()+", ";
		}
		this.associatedFields.setText(text.trim().replaceAll(",$",""));
	}
	
	private void setLabelText(String labelId){
		if(labelId.equals("null")){
			enableButtons(false);
		}
		this.mLayoutLabel.setText("Field ID = "+labelId);
	}
	
	@Override
	public void paintComponent(Graphics g) {
	}
}
