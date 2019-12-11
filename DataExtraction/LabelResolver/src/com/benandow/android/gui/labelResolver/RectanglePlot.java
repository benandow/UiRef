package com.benandow.android.gui.labelResolver;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Shape;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.geom.Rectangle2D;
import java.util.ArrayList;

import javax.swing.JComponent;
import javax.swing.JFrame;

import com.benandow.android.gui.layoutModel.HierarchyNode;
import com.benandow.android.gui.layoutModel.HierarchyTree;

public class RectanglePlot {

	private JFrame mWindow;
	
	public RectanglePlot(){
	    this.mWindow = new JFrame();
	    this.mWindow.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	    this.mWindow.setBounds(0, 0, 1080/3, 1701/3+100);
	}
	
	public void draw(HierarchyTree tree){
	    this.mWindow.getContentPane().add(new Canvas(tree));
	    this.mWindow.setVisible(true);
	}
	
	private class Canvas extends JComponent {
		
		private static final long serialVersionUID = -7848348170306614433L;

		private HierarchyTree mTree;
		
		private Color[] colors = new Color[]{
				Color.WHITE, Color.BLACK, Color.DARK_GRAY, Color.GRAY,
				Color.LIGHT_GRAY, Color.RED, Color.PINK, Color.ORANGE,
				Color.YELLOW, Color.GREEN, Color.CYAN, Color.BLUE, Color.MAGENTA };
		
		private ArrayList<Shape> shapes;
		private ArrayList<HierarchyNode> nodes;
		
		public Canvas(HierarchyTree tree){
			this.mTree = tree;
			this.shapes = new ArrayList<Shape>();
			this.nodes = new ArrayList<HierarchyNode>();
			
			addMouseListener(new MouseAdapter() {
	            @Override
	            public void mouseClicked(MouseEvent me) {
	                super.mouseClicked(me);
	                System.out.println("("+me.getPoint().getX() +", "+me.getPoint().getY()+")");
	                int lastShape = -1;
	                for (int i = 0; i < shapes.size(); i++) {
	                	Shape s = shapes.get(i);
	                    if (s.contains(me.getPoint())) {//check if mouse is clicked within shape
	                    	lastShape = i;
	                        //we can either just print out the object class name
	                    }
	                }
                    System.out.println("Clicked "+nodes.get(lastShape).toString());
	            }
	        });
			
		}
		
		public Color getColor(int depth){
			return colors[(depth % colors.length)];
		}
		
		private void convert(HierarchyNode base, int depth, String indent, Graphics g){
			Graphics2D g2d = (Graphics2D)g;
			Shape rect = new Rectangle2D.Double(base.getLeft()/3, base.getTop()/3, base.getRight()/3, base.getBottom()/3);
			g2d.setPaint(getColor(depth));
			g2d.fill(rect);
			
			if(base.getHint() != null && base.getHint().length() > 0){
				g2d.setColor(getColor(depth+2));
				g2d.drawString(base.getHint(), base.getLeft()/3,base.getBottom()/3);
			}else if(base.getText() != null && base.getText().length() > 0){
				g2d.setColor(getColor(depth+2));
				g2d.drawString(base.getText(), base.getLeft()/3,base.getBottom()/3);
			}
			this.shapes.add(rect);
			this.nodes.add(base);
//			g.setColor(getColor(depth));
//			g.fillRect(base.getmLeft()/3, base.getmTop()/3, base.getmRight()/3, base.getmBottom()/3);
			System.out.println(indent+depth+" - "+base.toString());
			for(HierarchyNode node : base.getChildren()){
				convert(node, depth+1, indent+"\t", g);
			}
		}
		
		@Override
		public void paintComponent(Graphics g) {
			convert(this.mTree.getTreeRoot(), 0, "", g);		
		}
	}
	
}
