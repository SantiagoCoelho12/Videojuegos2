package gameObjects;

import com.g3d.OgexData.Key;
import com.collision.platformer.Sides;
import com.gEngine.display.Sprite;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;
import com.gEngine.display.Layer;
import kha.math.FastVector2;
import kha.input.KeyCode;
import com.framework.utils.Input;

class Player extends Entity {
	static private inline var GRAVITY:Float = 10;

	var SPEED:Float = 100;
	var JUMP:Float = -350;
	var currentLayer:Layer;
	var direction:FastVector2;
	var display:Sprite;
	var velocity:FastVector2;

	public var isJumping:Bool = false;
	public var collision:CollisionBox;

	public function new(X:Float = 0, Y:Float = 0, layer:Layer) {
		super();
		direction = new FastVector2(0, 1);
		display = new Sprite("player");
		collision = new CollisionBox();
		velocity = new FastVector2(SPEED, SPEED);
		display.timeline.playAnimation("idle");
		display.timeline.frameRate = 1 / 7;
		display.pivotX = display.width() * 0.5;
		display.pivotY = display.height();
		display.offsetX = -25;
		display.offsetY = -5;
		collision.accelerationY = 800;
		collision.maxVelocityY = 800;
		collision.width = 16;
		collision.height = 30;
		collision.x = X;
		collision.y = Y;
		layer.addChild(display);
	}

	override function update(dt:Float):Void {
		super.update(dt);
		movement();
		collision.update(dt);
	}

	private inline function movement() {
		collision.velocityX = 0;
		if (Input.i.isKeyCodeDown(KeyCode.A)) {
			collision.velocityX = -SPEED;
			display.scaleX = -Math.abs(display.scaleX);
		} else if (Input.i.isKeyCodeDown(KeyCode.D)) {
			collision.velocityX = SPEED;
			display.scaleX = Math.abs(display.scaleX);
		}
		if (Input.i.isKeyCodePressed(KeyCode.W) && collision.isTouching(Sides.BOTTOM)) {
			collision.velocityY = JUMP;
		}
		if (Input.i.isKeyCodeDown(KeyCode.Shift)) {
			if (collision.isTouching(Sides.BOTTOM))
				SPEED = 210;
			JUMP = -400;
		} else {
			SPEED = 100;
			JUMP = -350;
		}
		/*if (collision.velocityX != 0 || collision.velocityY != 0) {
				direction.setFrom(new FastVector2(collision.velocityX, collision.velocityY));
				direction.setFrom(direction.normalized());
			} else {
				if (Math.abs(direction.x) > Math.abs(direction.y)) {
					direction.y = 0;
				} else {
					direction.x = 0;
				}
		}*/
	}

	override function render() {
		display.x = collision.x + collision.width * 0.5;
		display.y = collision.y;
		if (collision.isTouching(Sides.BOTTOM) && collision.velocityX == 0) {
			display.timeline.playAnimation("idle");
		} else if (collision.isTouching(Sides.BOTTOM) && collision.velocityX != 0) {
			display.timeline.playAnimation("run");
		} else if (!collision.isTouching(Sides.BOTTOM) && collision.velocityY < 0) {
			display.timeline.playAnimation("jump");
		} else if (!collision.isTouching(Sides.BOTTOM) && collision.velocityY > 0) {
			display.timeline.playAnimation("fall");
		}
	}
}
