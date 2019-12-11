package com.benandow.android.gui.userStudy.graphics;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Shape;
import java.awt.Stroke;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;

import javax.swing.JComponent;

import com.benandow.android.gui.layoutModel.Rectangle;

public class ScreenCanvas extends JComponent{
	private static final long serialVersionUID = -7848348170306614433L;
	
	private int mWidth, mHeight;
	private ScreenPlot mPlot;
	private BufferedImage mScreenshot;
	private BasicStroke mBorderStroke;
	
	public ScreenCanvas(BufferedImage screenshot, int width, int height, ScreenPlot plot){
		this.mWidth = width;
		this.mHeight = height;
		this.mPlot = plot;
		this.mScreenshot = screenshot;
		this.mBorderStroke = new BasicStroke(0.3f);
		addMouseListener(new MouseClickResolver(plot));
	}
	
	private void drawRectangle(AnnotatedField field, Graphics2D g2d){
		if(!this.mPlot.begin){
			return;
		}
		
		Rectangle rect = field.getNode().getRect();
		double 	width = ScreenPlot.scale(rect.getRight() - rect.getLeft()),
				height = ScreenPlot.scale(rect.getBottom() - rect.getTop());
		Shape srec = new Rectangle2D.Double(ScreenPlot.scale(rect.getLeft()), 
							ScreenPlot.scale(rect.getTop()), width, height);
				
		if(field.isHighlighted() && field.getNode().containsText()){
			//Coloring Labels
			Stroke origStroke = g2d.getStroke();
			g2d.setColor(new Color(0, 0, 0, 255));
			g2d.setStroke(this.mBorderStroke);
			g2d.draw(srec);
			g2d.setStroke(origStroke);
			
			if(field.isAnchor()){
				g2d.setColor(new Color(0, 255, 0, 128));
				g2d.fill(srec);
			}else{
				g2d.setColor(new Color(0, 0, 255, 50));
				g2d.fill(srec);
			}
		}else if(!field.getNode().containsText()){
			//Coloring empty text fields (e.g., editText)
			Stroke origStroke = g2d.getStroke();
			g2d.setColor(new Color(0, 0, 0, 255));
			g2d.setStroke(this.mBorderStroke);
			g2d.draw(srec);
			g2d.setStroke(origStroke);
			
			if(!field.isHighlighted()){
				g2d.setColor(new Color(0, 0, 255, 50));
				g2d.fill(srec);
			}
		}
	}
	
	@Override
	public void paintComponent(Graphics g) {
		g.drawImage(mScreenshot, 0, 0, mWidth, mHeight, this);
		//Draw rectangles
		for(AnnotatedField field : this.mPlot.mAnnotatedFields){
				drawRectangle(field, (Graphics2D) g);
		}
	}
}
