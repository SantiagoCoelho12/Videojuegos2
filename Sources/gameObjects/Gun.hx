package gameObjects;

import com.loading.basicResources.SoundLoader;
import kha.audio1.AudioChannel;
import kha.audio1.Audio;
import kha.Assets;
import kha.Sound;
import com.framework.utils.Entity;
import com.collision.platformer.CollisionGroup;

class Gun extends Entity {
	public var bulletsCollisions:CollisionGroup;

	public function new() {
		super();
		pool = true;
		bulletsCollisions = new CollisionGroup();
	}

	public function shoot(aX:Float, aY:Float, dirX:Float, dirY:Float):Void {
		var bullet:Bullet = cast recycle(Bullet);
		bullet.shoot(aX, aY, dirX, dirY, bulletsCollisions);
	}
}
