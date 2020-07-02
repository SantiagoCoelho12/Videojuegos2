package gameObjects;

import com.framework.utils.Entity;
import com.gEngine.display.Layer;
import kha.math.FastVector2;
import kha.input.KeyCode;
import com.framework.utils.Input;

class Player extends Entity {
    static private inline var SPEED:Float = 250;

	var currentLayer:Layer;
    var direction:FastVector2;
    var isJumping:Bool = false;

	public function new(X:Float = 0, Y:Float = 0, layer:Layer) {
        super();
        direction=new FastVector2(0,1);
	}

	override function update(dt:Float):Void {
        super.update(dt);
        movement();
 
    }
    
    private inline function movement() {
        if(Input.i.isKeyCodeDown(KeyCode.A)){
			//collision.velocityX=-SPEED;
		}
		if(Input.i.isKeyCodeDown(KeyCode.D)){
			//collision.velocityX=SPEED;
        }
        if(Input.i.isKeyCodeDown(KeyCode.W) && !isJumping){
			//jump
		}
    }

	override function render() {}
}
