package gameObjects;

import com.collision.platformer.ICollider;
import com.framework.utils.Input;
import GlobalGameData.GGD;
import com.gEngine.display.Sprite;
import com.collision.platformer.CollisionGroup;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;

class Shield extends Entity {
	public var collision:CollisionBox;

	private static inline var PLAYER_WIDTH:Float = 16;

	public function new() {
		super();
		collision = new CollisionBox();
		collision.width = 35;
		collision.height = 40;
		collision.userData = this;
	}

	override function update(dt:Float) {
		super.update(dt);
		collision.update(dt);
	}

	public function stopShield():Void {
		collision.x = -5000;
		collision.y = -5000;
	}

	public function getCover():Void {
		collision.x = GGD.player.collision.x-10;
		collision.y = GGD.player.collision.y-5;
	}
}
