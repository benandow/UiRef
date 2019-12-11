package com.benandow.android.gui.labelResolver;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.benandow.android.gui.layoutModel.HierarchyNode;

public class LabelResolver {
	
	private static boolean DEBUG = false;

	//TODO experimentally find this value
	private static double MAX_DIST = 80.00;//30pixels
	private static double DEGREE_THRESHOLD = 5.0;//10degrees
		
	private static boolean is90or180(Vector v){
		return (Math.abs(v.getDirection() - 180.0) <= DEGREE_THRESHOLD) || (Math.abs(v.getDirection() - 90.0) <= DEGREE_THRESHOLD);
	}
	
	private static List<Pair<HierarchyNode, HierarchyNode>> getMaxCandidateSet(HashMap<Vector, List<Pair<HierarchyNode, HierarchyNode>>> map){
		List<Pair<HierarchyNode, HierarchyNode>> resolved = null;
		Vector resolvedV = null;
		for(Vector v : map.keySet()){
			List<Pair<HierarchyNode, HierarchyNode>> lst = map.get(v);
			if(resolved == null || lst.size() > resolved.size()){
					resolvedV = v;
					resolved = lst;
			}else if(lst.size() == resolved.size()){
				if((is90or180(v) && !is90or180(resolvedV)) ||
					(((is90or180(v) && is90or180(resolvedV)) || (!is90or180(v) && !is90or180(resolvedV))) && v.getMagnitude() < resolvedV.getMagnitude())
						){
					resolvedV = v;
					resolved = lst;
				}
			}
		}
		return resolved;
	}
		
	public static List<Pair<HierarchyNode, HierarchyNode>> resolveLabels(List<HierarchyNode> labels, List<HierarchyNode> ifields){
		//Make shallow copies of lists
		List<HierarchyNode> labelsCpy = new ArrayList<HierarchyNode>(labels);
		List<HierarchyNode> ifieldsCpy = new ArrayList<HierarchyNode>(ifields);
		
		List<Pair<HierarchyNode, HierarchyNode>> resolved = new ArrayList<Pair<HierarchyNode, HierarchyNode>>();
		if(labelsCpy.isEmpty() || ifieldsCpy.isEmpty()){
			return resolved;
		}
		
		int size = -1;
		while(size != resolved.size()){
			size = resolved.size();
			HashMap<Vector, List<Pair<HierarchyNode, HierarchyNode>>> map = new HashMap<Vector, List<Pair<HierarchyNode, HierarchyNode>>>();
			for(int i = 0; i < ifieldsCpy.size(); i++){
				for(int j = 0; j < labelsCpy.size(); j++){
					HierarchyNode uifield = ifieldsCpy.get(i);
					HierarchyNode label = labelsCpy.get(j);
					
					Vector v = CollisionPredictor.calcCollisionVector(uifield.getRect(), label.getRect())[0];
	//				System.out.println(v.getMagnitude() +" "+v.getDirection() +": "+uifield.getCounterId() + "--->"+label.getCounterId());

					if(v.getMagnitude() > MAX_DIST){
						continue;
					}
					
					Pair<HierarchyNode, HierarchyNode> pair = new Pair<HierarchyNode, HierarchyNode>(uifield, label);
					if(map.containsKey(v)){
						//If we already have a mapping for the input field or label don't re-add to list
						boolean contains = false;
						for(Pair<HierarchyNode, HierarchyNode> p : map.get(v)){
							if(p.getL().equals(uifield) || p.getR().equals(label)){
								contains = true;
								break;
							}
						}
						if(!contains){
							map.get(v).add(pair);
						}
					}else{
						List<Pair<HierarchyNode,HierarchyNode>> lst = new ArrayList<Pair<HierarchyNode,HierarchyNode>>();
						lst.add(pair);
						map.put(v, lst);
					}
				}
			}
		
			List<Pair<HierarchyNode, HierarchyNode>> mCset = getMaxCandidateSet(map);
			if(mCset != null){
				if(DEBUG){
					System.out.println("-----BEGIN_RUN-----");
				}
				for(Pair<HierarchyNode, HierarchyNode> c : mCset){
					if(DEBUG){
						Vector[] v = CollisionPredictor.calcCollisionVector(c.getL().getRect(), c.getR().getRect());
						System.out.printf("InputField(%s) %s-->Label(%s - %s) = <magnitude, direction>=<%f, %f>AND<%f, %f>\n",
								c.getL().getCounterId(), c.getL().getHint(), c.getR().getCounterId(), c.getR().getText(),
								v[0].getMagnitude(), v[0].getDirection(), v[1].getMagnitude(), v[1].getDirection());						
					}
					
					resolved.add(c);
					ifieldsCpy.remove(c.getL());
					labelsCpy.remove(c.getR());
				}
				if(DEBUG){
					System.out.println("-----END_RUN-----");
				}
			}
			if(DEBUG){
				dumpCandidateMap(map);
			}
		}
		return resolved;
	}
	
	private static void dumpCandidateMap(HashMap<Vector, List<Pair<HierarchyNode, HierarchyNode>>> map){
		for(Vector v : map.keySet()){
			System.out.println("\n"+v.getMagnitude() + " "+v.getDirection());
			for(Pair<HierarchyNode, HierarchyNode> p : map.get(v)){
				System.out.printf("\t%s --> %s (%s) ---> %s\n", p.getL().getCounterId(), p.getR().getCounterId(), p.getR().getText(), p.getL().getAnnotatedLabelCounter());
			}
		}
	}
}