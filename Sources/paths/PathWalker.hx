package paths;
import kha.math.FastVector2;

 enum PlayMode
 {
	 Loop;
	 Pong;
	 None;
 }
class PathWalker
{
	private var path:Path;
	private var totalTime:Float;
	private var time:Float=0;
	private var playMode:PlayMode;
	
	public var x(get, null):Float;
	public var y(get, null):Float;
	
	private var direction:Int;
	
	private var position:FastVector2;
	
	public static function fromSpeed(path:Path, speed:Float, playMode:PlayMode):PathWalker
	{
		return new PathWalker(path,path.getLength()/speed,playMode);
	}
	public function new(path:Path,totalTime:Float,playMode:PlayMode) 
	{
		this.playMode = playMode;
		this.path = path;
		this.totalTime = totalTime;
		position = new FastVector2();
		direction = 1;
	}
	public function update(dt:Float):Void
	{
		var s = getTimeScale(dt);
		var pos= path.getPos(s);
		position.x = pos.x;
		position.y = pos.y;
	}
	private function getTimeScale(dt:Float):Float
	{
		time+=dt*direction;
		var s=time/totalTime;
		switch (playMode){
			case None:
				if(s>1){
					s=1;
					time=totalTime;
				}
			case Loop:
				if(s>1){
					s=0;
					time=0;
				}
			case Pong:
				if(s>1){
					direction=-1;
					time=totalTime;
					s=1;
				}
				if(s<0){
					direction=1;
					time=0;
					s=0;
				}
		}
		return s;
	}
	private function get_x():Float
	{
		return position.x;
	}
	private function get_y():Float
	{
		return position.y;
	}
	public function finish():Bool
	{
		return time == totalTime && playMode == PlayMode.None;
	}
	public function reset():Void
	{
		time = 0;
		direction = 1;
	}
}