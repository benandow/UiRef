package com.benandow.android.gui.userStudy.graphics;

import java.awt.Point;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

import com.benandow.android.gui.layoutModel.Rectangle;

public class MouseClickResolver extends MouseAdapter {

	private ScreenPlot mPlot;
	
	public MouseClickResolver(ScreenPlot plot){
		this.mPlot = plot;
	}
	
	@Override
    public void mouseClicked(MouseEvent me) {
        super.mouseClicked(me);
        AnnotatedField field = resolveClick(me.getPoint());
        if(field == null){
        	return;
        }
        
        System.out.println(field.getNode().toString());
        this.mPlot.selectField(field);
    }
	
	private boolean isTop(double y, double top){
		return (y < top);
	}
	
	private boolean isBottom(double y, double bottom){
		return (y > bottom);
	}
	
	private boolean isLeft(double x, double left){
		return (x < left);
	}
	
	private boolean isRight(double x, double right){
		return (x > right);
	}
	
	private boolean isCenter(double x, double left, double right){
		return !(isLeft(x, left) || isRight(x, right));
	}
	
	private boolean isMiddle(double y, double top, double bottom){
		return !(isTop(y, top) || isBottom(y,bottom));	
	}
	
	private boolean contains(Point p, Rectangle r){
		double 	left 	= 	ScreenPlot.scale(r.getLeft()), 
				right 	= 	ScreenPlot.scale(r.getRight()),
				top 	= 	ScreenPlot.scale(r.getTop()),
				bottom 	= 	ScreenPlot.scale(r.getBottom()),
				x 		= 	p.getX(), 
				y 		= 	p.getY();
		
		return(isMiddle(y, top, bottom) && isCenter(x, left, right));
	}
	
	public AnnotatedField resolveClick(Point p){
		for(AnnotatedField field : this.mPlot.mAnnotatedFields){
			if(contains(p, field.getNode().getRect())){
				return field;
			}
		}
		return null;
	}
}