package gameObjects;

import com.gEngine.display.Layer;
import com.collision.platformer.ICollider;
import com.framework.utils.Input;
import GlobalGameData.GGD;
import com.gEngine.display.Sprite;
import com.collision.platformer.CollisionGroup;
import com.collision.platformer.CollisionBox;
import com.framework.utils.Entity;

class Shield extends Entity {
	public var collision:CollisionBox;

	var layer:Layer;
	var display:Sprite;

	private static inline var PLAYER_WIDTH:Float = 16;

	public function new(_layer:Layer) {
		super();
		layer = _layer;
		collision = new CollisionBox();
		collision.width = collision.height = 43;
		collision.userData = this;
		display = new Sprite("bubble");
	}

	override function update(dt:Float) {
		super.update(dt);
		collision.update(dt);
		display.x = collision.x;
		display.y = collision.y;
	}

	public function stopShield():Void {
		layer.remove(display);
		collision.x = -5000;
		collision.y = -5000;
	}

	public function getCover():Void {
		display.timeline.playAnimation("shield");
		display.timeline.frameRate = 1 / 11;
		layer.addChild(display);
		display.scaleX = display.scaleY = 0.5;
		display.offsetX = -24;
		display.offsetY = -27;
		collision.x = GGD.player.collision.x - 13;
		collision.y = GGD.player.collision.y - 6;
	}
}
