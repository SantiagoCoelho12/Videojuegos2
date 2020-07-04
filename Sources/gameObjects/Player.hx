package gameObjects;

import kha.Assets;
import kha.audio1.AudioChannel;
import js.html.Audio;
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
	var attacking:Bool = false;
	var weaponSelection:Float = 1;

	public var sword:Sword;
	public var gun:Gun;
	public var hitPoints:Int = 5;
	public var collision:CollisionBox;

	public function new(X:Float = 0, Y:Float = 0, layer:Layer) {
		super();
		direction = new FastVector2(0, 1);
		display = new Sprite("player");
		collision = new CollisionBox();
		velocity = new FastVector2(SPEED, SPEED);
		gun = new Gun();
		sword = new Sword();
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
		if (Input.i.isKeyCodePressed(KeyCode.One)) {
			weaponSelection = 1;
		}
		if (Input.i.isKeyCodePressed(KeyCode.Two)) {
			weaponSelection = 2;
		}
		if (Input.i.isMousePressed()) {
			if (weaponSelection == 2) {
				gun.shoot(collision.x, collision.y, direction.x, -direction.y);
				attacking = true;
			}
		} else if (Input.i.isMouseDown()) {
			if (weaponSelection == 1) {
				sword.attack(collision.x + collision.width, collision.y, display.scaleX);
				attacking = true;
			}
		} else {
			attacking = false;
			sword.endAttack();
		}
		if (Input.i.isKeyCodeDown(KeyCode.Shift)) {
			if (collision.isTouching(Sides.BOTTOM))
				SPEED = 210;
			JUMP = -400;
		} else {
			SPEED = 100;
			JUMP = -350;
		}
		if (collision.velocityX != 0 || collision.velocityY != 0) {
			direction.setFrom(new FastVector2(collision.velocityX, collision.velocityY));
			direction.setFrom(direction.normalized());
		} else {
			if (Math.abs(direction.x) > Math.abs(direction.y)) {
				direction.y = 0;
			} else {
				direction.x = 0;
			}
		}
	}

	override function render() {
		display.x = collision.x + collision.width * 0.5;
		display.y = collision.y;

		display.timeline.frameRate = 1 / 7;
		if (attacking) {
			if (weaponSelection == 1)
				display.timeline.playAnimation("sword");
			if (weaponSelection == 2)
				display.timeline.playAnimation("power");
			display.timeline.frameRate = 1 / 15;
		} else if (collision.isTouching(Sides.BOTTOM) && collision.velocityX == 0) {
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
