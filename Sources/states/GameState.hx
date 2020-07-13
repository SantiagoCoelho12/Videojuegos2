package states;

import com.collision.platformer.CollisionGroup;
import com.collision.platformer.CollisionBox;
import com.loading.basicResources.FontLoader;
import com.gEngine.display.Text;
import gameObjects.Bullet;
import com.gEngine.display.StaticLayer;
import com.gEngine.GEngine;
import kha.audio1.AudioChannel;
import com.collision.platformer.ICollider;
import com.loading.basicResources.ImageLoader;
import com.collision.platformer.CollisionEngine;
import gameObjects.Player;
import gameObjects.Enemy;
import com.loading.basicResources.SpriteSheetLoader;
import kha.Assets;
import com.loading.basicResources.JoinAtlas;
import com.loading.basicResources.DataLoader;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.loading.Resources;
import com.framework.utils.State;
import com.collision.platformer.Tilemap;
import com.gEngine.display.Layer;
import com.gEngine.display.Sprite;
import GlobalGameData.GGD;
import com.loading.basicResources.TilesheetLoader;
import format.tmx.Data.TmxObject;

class GameState extends State {
	var worldMap:Tilemap;
	var simulationLayer:Layer;
	var hudLayer:Layer;
	var player:Player;
	var spawnX:Float;
	var spawnY:Float;
	var audio:AudioChannel;
	var arrow:Text;
	var heartCounter:Text;
	var fireBall:Sprite;
	var manaCounter:Text;
	var fireBallYLevitation:Float = 1;
	var nextLvlCollision:CollisionGroup;
	var manaCollision:CollisionGroup;
	var manaPotion:Sprite;
	var enemyCollision:CollisionGroup;
	var enemies:Array<Enemy>;
	var score:Float;
	var scoreText:Text;
	var lvl:Int;
	var playerHeart:Int;
	var playerMana:Int;

	public function new(lvl:Int, score:Float, _playerHeart:Int = 5, _playerMana:Int = 100) {
		super();
		this.lvl = lvl;
		this.score = score;
		playerHeart = _playerHeart;
		playerMana = _playerMana;
	}

	override function load(resources:Resources) {
		lvl = 2;
		resources.add(new DataLoader(Assets.blobs.lvl1_tmxName));
		resources.add(new DataLoader(Assets.blobs.lvl2_tmxName));
		resources.add(new DataLoader(Assets.blobs.finalLvl_tmxName));
		var atlas:JoinAtlas = new JoinAtlas(4000, 4000);
		atlas.add(new FontLoader(Assets.fonts.ArialName, 27));
		atlas.add(new TilesheetLoader("lvl2ground", 16, 16, 0));
		atlas.add(new TilesheetLoader("lvl1TileSet", 16, 16, 0));
		if (lvl == 1)
			atlas.add(new ImageLoader("lvl1Background"));
		if (lvl == 2)
			atlas.add(new ImageLoader("lvl2Background"));
		atlas.add(new ImageLoader("bullet"));
		atlas.add(new ImageLoader("heart"));
		atlas.add(new ImageLoader("mana"));
		atlas.add(new ImageLoader("sword"));
		atlas.add(new ImageLoader("shield"));
		atlas.add(new ImageLoader("nextlvl"));
		atlas.add(new ImageLoader("fireballHUD"));
		atlas.add(new ImageLoader("hand"));
		atlas.add(new SpriteSheetLoader("player", 50, 37, 0, [
			Sequence.at("idle", 0, 3), Sequence.at("run", 8, 13), Sequence.at("jump", 15, 17), Sequence.at("sword", 42, 48), Sequence.at("sword2", 49, 52),
			Sequence.at("sword3", 53, 58), Sequence.at("power", 89, 91), Sequence.at("death", 65, 65), Sequence.at("power2", 102, 108),
			Sequence.at("fall", 22, 23)]));
		atlas.add(new SpriteSheetLoader("mushroom", 150, 75, 0, [
			Sequence.at("run", 4, 11),
			Sequence.at("idle", 12, 15),
			Sequence.at("death", 16, 19),
			Sequence.at("attack", 20, 27)
		]));
		atlas.add(new SpriteSheetLoader("skeleton", 154, 83, 0, [
			Sequence.at("run", 0, 3),
			Sequence.at("idle", 12, 15),
			Sequence.at("death", 16, 19),
			Sequence.at("attack", 20, 27)
		]));
		atlas.add(new SpriteSheetLoader("bubble", 182, 182, 0, [Sequence.at("shield", 0, 14)]));
		resources.add(atlas);
	}

	override function init() {
		loadBackground();
		simulationLayer = new Layer();
		enemyCollision = new CollisionGroup();
		enemies = new Array<Enemy>();
		score = 0;
		lvlControl();
		cameraSettings();
		createPlayer();
		setHUD();
		setGGD();
		stage.addChild(simulationLayer);
	}

	inline function setGGD() {
		GGD.simulationLayer = simulationLayer;
		GGD.player = player;
	}

	inline function createPlayer() {
		player = new Player(spawnX, spawnY, simulationLayer, playerHeart, playerMana);
		addChild(player);
	}

	inline function cameraSettings() {
		stage.defaultCamera().limits(0, 0, worldMap.widthIntTiles * 16, (worldMap.heightInTiles * 16));
		stage.defaultCamera().scale = 1.7;
	}

	inline function lvlControl() {
		if (lvl == 1) {
			worldMap = new Tilemap("lvl1_tmx", 1);
			worldMap.init(function(layerTilemap, tileLayer) {
				if (!tileLayer.properties.exists("noCollision")) {
					layerTilemap.createCollisions(tileLayer);
				}
				simulationLayer.addChild(layerTilemap.createDisplay(tileLayer, new Sprite("lvl1TileSet")));
			}, parseMapObjects);
		} else if (lvl == 2) {
			worldMap = new Tilemap("lvl2_tmx", 1);
			worldMap.init(function(layerTilemap, tileLayer) {
				if (!tileLayer.properties.exists("noCollision")) {
					layerTilemap.createCollisions(tileLayer);
				}
				simulationLayer.addChild(layerTilemap.createDisplay(tileLayer, new Sprite("lvl2ground")));
			}, parseMapObjects);
		} else if (lvl == 3) {
			worldMap = new Tilemap("finalLvl_tmx", 1);
			worldMap.init(function(layerTilemap, tileLayer) {
				if (!tileLayer.properties.exists("noCollision")) {
					layerTilemap.createCollisions(tileLayer);
				}
				simulationLayer.addChild(layerTilemap.createDisplay(tileLayer, new Sprite("lvl2ground")));
			}, parseMapObjects);
		}
	}

	inline function loadBackground() {
		var backgraundLayer = new Layer();
		if (lvl == 1) {
			var background = new Sprite("lvl1Background");
			background.smooth = true;
			backgraundLayer.addChild(background);
			audio = kha.audio1.Audio.play(Assets.sounds.FOREST, true);
		} else if (lvl == 2) {
			var background = new Sprite("lvl2Background");
			background.smooth = true;
			backgraundLayer.addChild(background);
			audio = kha.audio1.Audio.play(Assets.sounds.FOREST, true);
		} else if (lvl == 3) {
			var background = new Sprite("lvl2Background");
			background.smooth = true;
			backgraundLayer.addChild(background);
			audio = kha.audio1.Audio.play(Assets.sounds.FOREST, true);
		}
		stage.addChild(backgraundLayer);
	}

	inline function setHUD() {
		hudLayer = new StaticLayer();
		stage.addChild(hudLayer);
		var heart = new Sprite("heart");
		heart.scaleX = heart.scaleY = 0.27;
		heart.x = GEngine.virtualWidth * 0.005;
		heart.y = GEngine.virtualHeight * 0.05;
		hudLayer.addChild(heart);

		var hand = new Sprite("hand");
		hand.scaleX = hand.scaleY = 0.09;
		hand.x = GEngine.virtualWidth * 0.957;
		hand.y = GEngine.virtualHeight * 0.15;
		hudLayer.addChild(hand);

		var sword = new Sprite("sword");
		sword.scaleX = sword.scaleY = 0.26;
		sword.x = GEngine.virtualWidth * 0.957;
		sword.y = GEngine.virtualHeight * 0.045;
		hudLayer.addChild(sword);

		var mana = new Sprite("mana");
		mana.scaleX = mana.scaleY = 0.15;
		mana.x = GEngine.virtualWidth * 0.006;
		mana.y = GEngine.virtualHeight * 0.1;
		hudLayer.addChild(mana);

		fireBall = new Sprite("fireballHUD");
		fireBall.scaleX = fireBall.scaleY = 0.036;
		fireBall.x = GEngine.virtualWidth * 0.974;
		fireBall.y = GEngine.virtualHeight * 0.145;
		hudLayer.addChild(fireBall);

		var shield = new Sprite("shield");
		shield.scaleX = shield.scaleY = 0.06;
		shield.x = GEngine.virtualWidth * 0.956;
		shield.y = GEngine.virtualHeight * 0.215;
		hudLayer.addChild(shield);

		arrow = new Text(Assets.fonts.ArialName);
		arrow.x = GEngine.virtualWidth * 0.935;
		arrow.y = GEngine.virtualHeight * 0.067;
		arrow.text = "->";
		hudLayer.addChild(arrow);

		heartCounter = new Text(Assets.fonts.ArialName);
		heartCounter.x = GEngine.virtualWidth * 0.042;
		heartCounter.y = GEngine.virtualHeight * 0.0532;
		heartCounter.text = "5";
		hudLayer.addChild(heartCounter);

		manaCounter = new Text(Assets.fonts.ArialName);
		manaCounter.x = GEngine.virtualWidth * 0.041;
		manaCounter.y = GEngine.virtualHeight * 0.123;
		manaCounter.text = "100";
		hudLayer.addChild(manaCounter);

		scoreText = new Text(Assets.fonts.ArialName);
		scoreText.x = GEngine.virtualWidth * 0.42;
		scoreText.y = GEngine.virtualHeight * 0.02;
		scoreText.text = "Time: ";
		hudLayer.addChild(scoreText);
	}

	override function update(dt:Float) {
		super.update(dt);
		stage.defaultCamera().setTarget(player.collision.x, player.collision.y - 133);
		score += dt;
		updateHUD();
		fallControl();
		coliisionsControl();
		playerDeathControl();
		reset();
	}

	inline function coliisionsControl() {
		CollisionEngine.collide(player.collision, worldMap.collision);
		CollisionEngine.collide(enemyCollision, worldMap.collision);
		CollisionEngine.collide(player.gun.bulletsCollisions, worldMap.collision, destroyBullet);
		for (i in 0...enemies.length) {
			CollisionEngine.collide(enemies[i].gun.bulletsCollisions, worldMap.collision, destroyBullet);
			CollisionEngine.overlap(enemies[i].gun.bulletsCollisions, player.collision, characterDeath);
			CollisionEngine.collide(enemies[i].gun.bulletsCollisions, player.shield.collision, destroyBullet);
			enemyDeathControl(enemies[i]);
		}
		CollisionEngine.collide(enemyCollision, player.collision, characterDeath);
		CollisionEngine.collide(enemyCollision, player.gun.bulletsCollisions, killEnemyAndDestroyBullet);
		CollisionEngine.collide(enemyCollision, player.shield.collision);
		CollisionEngine.overlap(enemyCollision, player.sword.collision, killEnemy);
		CollisionEngine.overlap(manaCollision, player.collision, manaPotionCollision);
		CollisionEngine.overlap(nextLvlCollision, player.collision, nextLvl);
	}

	public inline function playerDeathControl() {
		if (player.isDead() && player.deathComplete()) {
			killThePlayer();
		}
	}

	public inline function enemyDeathControl(enemy:Enemy) {
		if (enemy.isDead() && enemy.deathComplete()) {
			enemy.endDeath();
		}
	}

	public inline function killThePlayer() {
		player.hearts--;
		if (player.hearts == 0) {
			audio.stop();
			changeState(new GameOver(lvl, score));
		} else {
			audio.stop();
			changeState(new GameState(lvl, score, player.hearts, player.mana));
		}
	}

	public function destroyBullet(a:ICollider, b:ICollider) {
		var bullet:Bullet = cast b.userData;
		if (bullet != null)
			bullet.die();
		var bullet2:Bullet = cast a.userData;
		if (bullet2 != null)
			bullet2.die();
	}

	public function killEnemyAndDestroyBullet(a:ICollider, b:ICollider) {
		killEnemy(a, b);
		destroyBullet(a, b);
	}

	public function nextLvl(a:ICollider, b:ICollider) {
		audio.stop();
		changeState(new GameState(lvl + 1, score, player.hearts, player.mana));
	}

	public function characterDeath(a:ICollider, b:ICollider) {
		player.die();
	}

	public function killEnemy(a:ICollider, b:ICollider) {
		var enemy:Enemy = cast a.userData;
		enemy.die();
		enemy.explode();
	}

	public function manaPotionCollision(a:ICollider, b:ICollider) {
		player.drinkPotion();
		manaCollision.colliders.pop();
		manaPotion.removeFromParent();
	}

	inline function updateHUD() {
		fireBallLevitation();
		arrowUpdate();
		manaAndHeartsUpdate();
		updateScore();
	}

	inline function updateScore() {
		scoreText.text = "Time: " + Std.int(score);
	}

	inline function manaAndHeartsUpdate() {
		heartCounter.text = player.hearts + "";
		manaCounter.text = player.mana + "";
	}

	inline function arrowUpdate() {
		if (player.getWeaponNumber() == 1) {
			arrow.y = GEngine.virtualHeight * 0.067;
		}
		if (player.getWeaponNumber() == 2) {
			arrow.y = GEngine.virtualHeight * 0.16;
		}
		if (player.getWeaponNumber() == 3) {
			arrow.y = GEngine.virtualHeight * 0.22;
		}
	}

	inline function fireBallLevitation() {
		fireBall.y += 0.12 * fireBallYLevitation;
		if (fireBall.y > ((GEngine.virtualHeight * 0.145) + 3) || fireBall.y < ((GEngine.virtualHeight * 0.145) - 3)) {
			fireBallYLevitation *= -1;
		}
	}

	private inline function fallControl() {
		if (player.y > 1000) {
			killThePlayer();
		}
	}

	override function render() {
		super.render();
	}

	inline function reset() {
		if (Input.i.isKeyCodePressed(KeyCode.Escape)) {
			audio.stop();
			changeState(new StartingMenu());
		}
	}

	function parseMapObjects(layerTilemap:Tilemap, object:TmxObject) {
		switch (object.objectType) {
			case OTRectangle:
				if (object.type == "spawn") {
					var x = object.properties.get("spawnX");
					var y = object.properties.get("spawnY");
					spawnX = Std.parseFloat(x);
					spawnY = Std.parseFloat(y);
				}
				if (object.type == "nextLvl") {
					var sign = new Sprite("nextlvl");
					sign.scaleX = sign.scaleY = 0.05;
					sign.y = object.y;
					sign.x = object.x;
					simulationLayer.addChild(sign);
					var nextlvl = new CollisionBox();
					nextLvlCollision = new CollisionGroup();
					nextlvl.y = object.y;
					nextlvl.height = object.height;
					nextlvl.width = object.width;
					nextlvl.x = object.x;
					nextLvlCollision.add(nextlvl);
				}
				if (object.type == "enemy") {
					var x = object.properties.get("spawnX");
					var y = object.properties.get("spawnY");
					var enemyTypeString = object.properties.get("type");
					var eX = Std.parseFloat(x);
					var eY = Std.parseFloat(y);
					var enemyType = Std.parseFloat(enemyTypeString);
					var timer = Std.int(5 * Math.random());
					var enemy = new Enemy(eX, eY, enemyType, enemyCollision, simulationLayer, timer + 1);
					enemies.push(enemy);
					addChild(enemy);
				}
				if (object.type == "mana") {
					manaPotion = new Sprite("mana");
					manaPotion.scaleX = manaPotion.scaleY = 0.05;
					manaPotion.offsetX = manaPotion.offsetY = -3;
					manaPotion.y = object.y;
					manaPotion.x = object.x;
					simulationLayer.addChild(manaPotion);
					manaCollision = new CollisionGroup();
					var manaPotionCollision = new CollisionBox();
					manaPotionCollision.y = object.y;
					manaPotionCollision.height = object.height;
					manaPotionCollision.width = object.width;
					manaPotionCollision.x = object.x;
					manaCollision.add(manaPotionCollision);
				}
			default:
		}
	}

	#if DEBUGDRAW
	override function draw(framebuffer:kha.Canvas) {
		super.draw(framebuffer);
		var camera = stage.defaultCamera();
		CollisionEngine.renderDebug(framebuffer, camera);
	}
	#end
}
