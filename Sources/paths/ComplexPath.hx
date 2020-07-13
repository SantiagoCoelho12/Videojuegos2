package paths;

import kha.math.FastVector2;

class ComplexPath implements Path {
    var paths:Array<Path>;
    var length:Float=0;
    public function new(paths:Array<Path>) {
        this.paths=paths;
        for(path in paths){
            length+=path.getLength();
        }
    }
    public function getPos(s:Float):FastVector2 {
        var distance=length*s;
        for(path in paths){
            if(distance<=path.getLength()){
                return path.getPos(distance/path.getLength());
            }else{
                distance-=path.getLength();
            }
        }
        throw "s is not in range";
    }
    public function getLength():Float {
        return length;
    }
}