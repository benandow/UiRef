package com.benandow.uiref.layoutModel;

public class Rectangle {

	// Original values
	int mLeft, mTop, mRight, mBottom;
	private int mWidth, mHeight;
	private Coordinate mTopLeft, mTopRight, mBottomLeft, mBottomRight, mCentroid;
	
	public Rectangle(int left, int top, int right, int bottom){
		this.mLeft = left;
		this.mTop = top;
		this.mRight = right;
		this.mBottom = bottom;
		this.mWidth = this.mRight - this.mLeft;
		this.mHeight = this.mBottom - this.mTop;
		this.mTopLeft = new Coordinate(this.mLeft, this.mTop);
		this.mTopRight = new Coordinate(this.mRight, this.mTop);
		this.mBottomLeft = new Coordinate(this.mLeft, this.mBottom);
		this.mBottomRight = new Coordinate(this.mRight, this.mBottom);
		this.mCentroid = new Coordinate(((double)this.mWidth)/2.0+this.mLeft,
										((double)this.mHeight)/2.0+this.mTop);
	}
	
	public int getLeft() {
		return mLeft;
	}

	public int getTop() {
		return mTop;
	}

	public int getRight() {
		return mRight;
	}

	public int getBottom() {
		return mBottom;
	}

	public int getWidth() {
		return mWidth;
	}

	public int getHeight() {
		return mHeight;
	}

	public Coordinate getTopLeft() {
		return mTopLeft;
	}

	public Coordinate getTopRight() {
		return mTopRight;
	}

	public Coordinate getBottomLeft() {
		return mBottomLeft;
	}

	public Coordinate getBottomRight() {
		return mBottomRight;
	}

	public Coordinate getCentroid() {
		return mCentroid;
	}
	
	public Coordinate getCentroidClone() {
		return  new Coordinate(((double)this.mWidth)/2.0+this.mLeft,
				((double)this.mHeight)/2.0+this.mTop);
	}
	
	public Coordinate getTopCenter() {
		return new Coordinate(this.mCentroid.x(),this.mTop);
	}
	
	public Coordinate getBottomCenter() {
		return new Coordinate(this.mCentroid.x(),this.mBottom);
	}
	
	public Coordinate getMiddleLeft() {
		return new Coordinate(this.mLeft, this.mCentroid.y());
	}
	
	public Coordinate getMiddleRight() {
		return new Coordinate(this.mRight, this.mCentroid.y());
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + mBottom;
		result = prime * result + ((mBottomLeft == null) ? 0 : mBottomLeft.hashCode());
		result = prime * result + ((mBottomRight == null) ? 0 : mBottomRight.hashCode());
		result = prime * result + ((mCentroid == null) ? 0 : mCentroid.hashCode());
		result = prime * result + mHeight;
		result = prime * result + mLeft;
		result = prime * result + mRight;
		result = prime * result + mTop;
		result = prime * result + ((mTopLeft == null) ? 0 : mTopLeft.hashCode());
		result = prime * result + ((mTopRight == null) ? 0 : mTopRight.hashCode());
		result = prime * result + mWidth;
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Rectangle other = (Rectangle) obj;
		if (mBottom != other.mBottom)
			return false;
		if (mBottomLeft == null) {
			if (other.mBottomLeft != null)
				return false;
		} else if (!mBottomLeft.equals(other.mBottomLeft))
			return false;
		if (mBottomRight == null) {
			if (other.mBottomRight != null)
				return false;
		} else if (!mBottomRight.equals(other.mBottomRight))
			return false;
		if (mCentroid == null) {
			if (other.mCentroid != null)
				return false;
		} else if (!mCentroid.equals(other.mCentroid))
			return false;
		if (mHeight != other.mHeight)
			return false;
		if (mLeft != other.mLeft)
			return false;
		if (mRight != other.mRight)
			return false;
		if (mTop != other.mTop)
			return false;
		if (mTopLeft == null) {
			if (other.mTopLeft != null)
				return false;
		} else if (!mTopLeft.equals(other.mTopLeft))
			return false;
		if (mTopRight == null) {
			if (other.mTopRight != null)
				return false;
		} else if (!mTopRight.equals(other.mTopRight))
			return false;
		if (mWidth != other.mWidth)
			return false;
		return true;
	}

	@Override
	public String toString() {
		return String.format("TL=%s TR=%s BR=%s BL=%s", this.mTopLeft, this.mTopRight, this.mBottomRight, this.mBottomLeft);
	}
}
