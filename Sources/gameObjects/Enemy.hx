package gameObjects;

import com.collision.platformer.CollisionGroup;
import com.gEngine.display.Layer;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;

class Enemy extends Entity {
	var SPEED:Float = 100;
	var type:Float;
	var display:Sprite;
	var currentLayer:Layer;
	var collisionGroup:CollisionGroup;

	public var collision:CollisionBox;
	public var gun:Gun;

	public function new(X:Float, Y:Float, _type:Float, _collisions:CollisionGroup, layer:Layer) {
		super();
		type = _type;
		collision = new CollisionBox();
		gun = new Gun();
		currentLayer = layer;
		collisionGroup = _collisions;
		if (type == 1) {
			display = new Sprite("skeleton");
		} else {
			display = new Sprite("mushroom");
			addChild(gun);
		}
		setCollisions(X, Y, type);
		setDisplay(type);
		collisionGroup.add(collision);
		layer.addChild(display);
	}

	inline function setCollisions(X:Float, Y:Float, _type:Float) {
		collision.x = X;
		collision.y = Y;
		collision.userData = this;
		if (type == 1) {} else {}
	}

	inline function setDisplay(_type:Float) {
		display.timeline.playAnimation("idle");
		display.timeline.frameRate = 1 / 6;
		display.scaleX = display.scaleY = 0.7;
		display.offsetX = display.offsetY = -10;

		if (type == 1) {} else {}
	}

	override function update(dt:Float):Void {
		super.update(dt);
		collision.update(dt);
	}

	override function render() {
		display.x = collision.x + collision.width * 0.5;
		display.y = collision.y;
	}
}
