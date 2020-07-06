package gameObjects;

import com.gEngine.display.Sprite;
import GlobalGameData.GGD;
import com.collision.platformer.CollisionGroup;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;

class Bullet extends Entity {
	public var collision:CollisionBox;

	var display:Sprite;
	var counter:Float = 0;

	static inline var MAX_COUNTER:Float = 4;
	static inline var BALL_VELOCITY:Float = 400;

	public function new() {
		super();

		display = new Sprite("bullet");
		collision = new CollisionBox();
		collision.width =15;
		collision.height = 4;

		collision.userData = this;

		display.scaleX = display.scaleY = 0.08;
		//display.offsetY= -5;
		display.offsetY= -1.5;
	}

	override function limboStart() {
		display.removeFromParent();
		collision.removeFromParent();
	}

	override function update(dt:Float) {
		super.update(dt);
		autoDestroy(dt);
		collision.update(dt);
		display.x = collision.x;
		display.y = collision.y;
	}

	inline function autoDestroy(dt:Float) {
		counter += dt;
		if (counter > MAX_COUNTER) {
			die();
			limboStart();
		}
	}

	public function shoot(x:Float, y:Float, dirX:Float, dirY:Float, bulletsCollision:CollisionGroup):Void {
		counter = 0;
		collision.x = x;
		collision.y = y;
		collision.velocityX = BALL_VELOCITY * dirX;
		collision.velocityY = BALL_VELOCITY * dirY;
		bulletsCollision.add(collision);
		GGD.simulationLayer.addChild(display);
	}
}