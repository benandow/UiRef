package com.benandow.uiref.labelResolver;

public class Tuple<L,M,R> {

	private L l;
	private M m;
	private R r;
	
	public Tuple(L l, M m, R r){
		this.l = l;
		this.m = m;
		this.r = r;
	}

	public L getL() {
		return l;
	}

	public void setL(L l) {
		this.l = l;
	}

	public M getM() {
		return m;
	}

	public void setM(M m) {
		this.m = m;
	}

	public R getR() {
		return r;
	}

	public void setR(R r) {
		this.r = r;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((l == null) ? 0 : l.hashCode());
		result = prime * result + ((m == null) ? 0 : m.hashCode());
		result = prime * result + ((r == null) ? 0 : r.hashCode());
		return result;
	}

	@SuppressWarnings("rawtypes")
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Tuple other = (Tuple) obj;
		if (l == null) {
			if (other.l != null)
				return false;
		} else if (!l.equals(other.l))
			return false;
		if (m == null) {
			if (other.m != null)
				return false;
		} else if (!m.equals(other.m))
			return false;
		if (r == null) {
			if (other.r != null)
				return false;
		} else if (!r.equals(other.r))
			return false;
		return true;
	}
}
