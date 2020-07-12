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
	var SPEED:Float = 160;
	var JUMP:Float = -360;
	var currentLayer:Layer;
	var display:Sprite;
	var velocity:FastVector2;
	var attacking:Bool = false;
	var weaponSelection:Float = 1;

	public var mana:Int;
	public var sword:Sword;
	public var shield:Shield;
	public var gun:Gun;
	public var hearts:Int;
	public var collision:CollisionBox;
	public var x(get, null):Float;
	public var y(get, null):Float;

	public function new(X:Float = 0, Y:Float = 0, layer:Layer, _hearts:Int, _mana:Int) {
		super();
		display = new Sprite("player");
		collision = new CollisionBox();
		velocity = new FastVector2(SPEED, SPEED);
		gun = new Gun();
		addChild(gun);
		sword = new Sword();
		addChild(sword);
		shield = new Shield();
		addChild(shield);
		hearts = _hearts;
		mana = _mana;
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

	public function get_x():Float {
		return collision.x + collision.width * 0.5;
	}

	public function get_y():Float {
		return collision.y + collision.height;
	}

	public function get_width():Float {
		return collision.width;
	}

	public function get_height():Float {
		return collision.height;
	}

	public function drinkPotion() {
		mana += 50;
		if (mana > 100)
			mana = 100;
	}

	override function update(dt:Float):Void {
		super.update(dt);
		movement();
		collision.update(dt);
	}

	private inline function movement() {
		collision.velocityX = 0;
		if (Input.i.isKeyCodeDown(KeyCode.A) && (!attacking || attacking && weaponSelection == 1)) {
			collision.velocityX = -SPEED;
			display.scaleX = -Math.abs(display.scaleX);
		} else if (Input.i.isKeyCodeDown(KeyCode.D) && (!attacking || attacking && weaponSelection == 1)) {
			collision.velocityX = SPEED;
			display.scaleX = Math.abs(display.scaleX);
		}
		if (!attacking) {
			if (Input.i.isKeyCodeDown(KeyCode.S) && !collision.isTouching(Sides.BOTTOM)) {
				collision.velocityY = -JUMP * 0.8;
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
			if (Input.i.isKeyCodePressed(KeyCode.Three)) {
				weaponSelection = 3;
			}
		}
		if (Input.i.isMousePressed()) {
			if (weaponSelection == 2 && mana >= 20) {
				gun.shoot(collision.x, collision.y + collision.height * 0.5, display.scaleX, 0);
				attacking = true;
				mana -= 20;
			}
		} else if (Input.i.isMouseDown()) {
			if (weaponSelection == 1) {
				sword.attack(collision.x + collision.width, collision.y, display.scaleX);
				attacking = true;
			}
			if (weaponSelection == 3) {
				shield.getCover();
				attacking = true;
			}
		} else {
			attacking = false;
			sword.endAttack();
			shield.stopShield();
		}
		if (attacking) {
			SPEED = 10;
		} else {
			SPEED = 160;
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
			if (weaponSelection == 3)
				display.timeline.playAnimation("power2");
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
