package gameObjects;

import kha.audio1.AudioChannel;
import kha.Assets;
import paths.PathWalker;
import paths.PathWalker.PlayMode;
import paths.LinearPath;
import paths.Path;
import com.collision.platformer.Sides;
import kha.math.FastVector2;
import GlobalGameData.GGD;
import com.collision.platformer.CollisionGroup;
import com.gEngine.display.Layer;
import com.collision.platformer.CollisionBox;
import com.gEngine.display.Sprite;
import com.framework.utils.Entity;

class Enemy extends Entity {
	var type:Float;
	var display:Sprite;
	var currentLayer:Layer;
	var collisionGroup:CollisionGroup;
	var shootCounter:Float = 0;
	var gunTimer:Int = 0;
	var attackCounter:Float = 0;

	public var collision:CollisionBox;
	public var gun:Gun;

	public function new(X:Float, Y:Float, _type:Float, _collisions:CollisionGroup, layer:Layer, timer:Int = 4) {
		super();
		type = _type;
		collision = new CollisionBox();
		gun = new Gun();
		currentLayer = layer;
		gunTimer = timer;
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
		collision.accelerationY = 800;
		collision.userData = this;
		if (type == 1) {
			collision.width = 17;
			collision.height = 35;
		} else {
			collision.width = 17;
			collision.height = 22;
		}
	}

	inline function setDisplay(_type:Float) {
		display.timeline.playAnimation("idle");
		display.timeline.frameRate = 1 / 6;
		display.scaleX = display.scaleY = 0.7;
		display.pivotX = display.width() * 0.5;
		display.pivotY = display.height();
		if (type == 1) {
			display.offsetX = -78;
			display.offsetY = -80;
		} else {
			display.offsetX = -75;
			display.offsetY = -30;
		}
	}

	public function explode():Void {
		collision.removeFromParent();
		collisionGroup.remove(collision);
	}

	public function endDeath() {
		display.removeFromParent();
	}

	override function die() {
		super.die();
		display.timeline.playAnimation("death", false);
		display.timeline.frameRate = 1 / 6;
		gun.destroyAllBullets();
		var deathSound:AudioChannel;
		if (type == 1)
			deathSound = kha.audio1.Audio.play(Assets.sounds.SKELETONDEATH, false);
		else
			deathSound = kha.audio1.Audio.play(Assets.sounds.MUSHROOMDIE, false);
		deathSound.volume = 0.3;
	}

	public function deathComplete():Bool {
		return display.timeline.isComplete();
	}

	override function update(dt:Float):Void {
		super.update(dt);
		collision.update(dt);
		if (type == 1) {
			collision.velocityX = 0;
			attackCounter += dt;
			if (!dead) {
				if (calculateDistance(GGD.player.collision.x, collision.x, GGD.player.collision.y, collision.y) < 20000) {
					followPlayer();
					if (collision.velocityX > 0) {
						display.scaleX = Math.abs(display.scaleX);
						display.offsetX = -78;
					} else {
						display.scaleX = -Math.abs(display.scaleX);
						display.offsetX = -72;
					}
				}
			}
		}
		if (type == 2) {
			shootCounter += dt;
			attackCounter += dt;
			if (shootCounter > gunTimer) {
				gun.shoot(collision.x, collision.y, 1, 0);
				gun.shoot(collision.x, collision.y, -1, 0);
				shootCounter = 0;
				display.timeline.playAnimation("attack", false);
				display.timeline.frameRate = 1 / 22;
				attackCounter = 0;
			}
			if (attackCounter > 0.55) {
				display.timeline.playAnimation("idle", false);
				display.timeline.frameRate = 1 / 6;
			}
		}
	}

	inline function calculateDistance(x2:Float, x1:Float, y2:Float, y1:Float):Float {
		return Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2);
	}

	inline function followPlayer() {
		var target:Player = GGD.player;
		var dir:FastVector2 = new FastVector2(target.x - (collision.x + collision.width * 0.5), 0);
		if (Math.abs(dir.x) > 5 && Math.abs(dir.y) > 5) {
			if (Math.abs(dir.x) > Math.abs(dir.y)) {
				dir.x = 0;
			} else {
				dir.y = 0;
			}
		}
		dir.setFrom(dir.normalized());
		dir.setFrom(dir.mult(100));
		collision.velocityX = dir.x;
	}

	override function render() {
		display.x = collision.x + collision.width * 0.5;
		display.y = collision.y;
		if (type == 1 && !dead) {
			if (collision.velocityX == 0) {
				display.timeline.playAnimation("idle");
			}
			if (collision.velocityX != 0) {
				display.timeline.playAnimation("run");
			}
		}
	}
}
