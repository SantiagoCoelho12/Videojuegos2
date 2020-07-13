package paths;

import kha.math.FastVector2;

class BezierPath implements Path {
	var helperPoint:FastVector2;

	var origin:FastVector2;
	var end:FastVector2;
	var control1:FastVector2;
    var control2:FastVector2;
    var length:Float;

	public function new(origin:FastVector2, control1:FastVector2, control2:FastVector2, end:FastVector2) {
		this.origin = origin;
		this.control1 = control1;
		this.control2 = control2;
        this.end = end;
        
        helperPoint=new FastVector2();

        length=(origin.sub(control1).length+control1.sub(control2).length+control2.sub(end).length + origin.sub(end).length)/2;
	}
	public inline function setFrom(origin:FastVector2, control1:FastVector2, control2:FastVector2, end:FastVector2) {
		this.origin.setFrom(origin);
		this.control1.setFrom(control1);
		this.control2.setFrom(control2);
		this.end.setFrom(end);
		length=(origin.sub(control1).length+control1.sub(control2).length+control2.sub(end).length + origin.sub(end).length)/2;
	}
	public function getPos(s:Float):FastVector2 {
        var CI1=lerp(origin,control1,s);
        var CI2=lerp(control1,control2,s);
        var CI3=lerp(control2,end,s);

        var CI4=lerp(CI1,CI2,s);
        var CI5=lerp(CI2,CI3,s);

        helperPoint.setFrom(lerp(CI4,CI5,s));

		return helperPoint;
	}

	public function getLength():Float {
		return length;
	}

	inline function lerp(origin:FastVector2, end:FastVector2, s:Float):FastVector2 {
		return origin.add(end.sub(origin).mult(s));
	}
}
