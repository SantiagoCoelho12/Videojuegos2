package gameObjects;

import com.collision.platformer.ICollider;
import com.framework.utils.Input;
import GlobalGameData.GGD;
import com.gEngine.display.Sprite;
import com.collision.platformer.CollisionGroup;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;

class Sword extends Entity {
    public var collision:CollisionBox;
    private static inline var PLAYER_WIDTH:Float = 16;

	public function new() {
		super();
		collision = new CollisionBox();
		collision.width = 12;
		collision.height = 30;
		collision.userData = this;
	}

	override function update(dt:Float) {
		super.update(dt);
		collision.update(dt);
	}

	public function endAttack() {
		collision.x = -5000;
		collision.y = -5000;
	}

	public function attack(x:Float, y:Float, dir:Float):Void {
		if (dir >= 0)
			collision.x = x;
		else
			collision.x = x-(PLAYER_WIDTH+collision.width);
		collision.y = (y - 4);
	}
}
