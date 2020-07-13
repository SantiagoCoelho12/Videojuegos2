package paths;

import kha.math.FastVector2;

class LinearPath implements Path {
	var helperPos:FastVector2;
	var origin:FastVector2;
    var end:FastVector2;
    var length:Float;

	public function new(origin:FastVector2, end:FastVector2) {
		helperPos = new FastVector2();
		this.origin = origin;
        this.end = end;
        length = end.sub(origin).length;
	}

	public function getPos(s:Float):FastVector2 {
        helperPos.setFrom(origin.add(end.sub(origin).mult(s)));
		return helperPos;
	}

	public function getLength():Float {
		return length;
	}
}
