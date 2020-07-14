package gameObjects;

import com.collision.platformer.Sides;
import com.gEngine.display.Layer;
import com.gEngine.display.Sprite;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;

class Boss extends Entity {
	public var collision:CollisionBox;
	public var gun:Gun;

	var shootCounter:Float = 0;
	var gunTimer:Int = 0;
	var display:Sprite;
	var currentLayer:Layer;
	var hitPoints:Int = 8;
	var direction:Int = 1;
	var running:Float = 8;
	var pause:Float = 2;
	var counter:Float = 0;

	public function new(X:Float, Y:Float, layer:Layer) {
		super();
		display = new Sprite("wizard");
		collision = new CollisionBox();
		gun = new Gun();
		addChild(gun);
		currentLayer = layer;
		collision.x = X;
		collision.y = Y;
		collision.userData = this;
		collision.width = 17;
		collision.height = 35;
		display.timeline.playAnimation("idle");
		display.timeline.frameRate = 1 / 6;
		display.scaleX = display.scaleY = 0.7;
		display.offsetX = 0;
		display.offsetY = 0;
		layer.addChild(display);
	}

	override function update(dt:Float):Void {
		super.update(dt);
        collision.update(dt);
        collision.x = 0;
		counter += dt;
		if (counter > pause) {
            collision.x += 200 * direction;
            display.scaleX = Math.abs(display.scaleX)*direction;
			if (collision.isTouching(Sides.RIGHT) || collision.isTouching(Sides.RIGHT))
				direction *= -1;
			if (counter > running) {
				counter = 0;
				pause = 0;
			}
		}
	}

	override function render() {
		display.x = collision.x + collision.width * 0.5;
		display.y = collision.y;
		if (collision.velocityX == 0) {
			display.timeline.playAnimation("idle");
		}
		if (collision.velocityX != 0) {
			display.timeline.playAnimation("run");
		}
	}
}
