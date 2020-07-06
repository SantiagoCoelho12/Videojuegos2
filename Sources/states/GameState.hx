package states;

import com.loading.basicResources.FontLoader;
import com.gEngine.display.Text;
import gameObjects.Bullet;
import com.gEngine.display.StaticLayer;
import com.gEngine.GEngine;
import js.html.Audio;
import kha.audio1.AudioChannel;
import js.html.Console;
import com.collision.platformer.ICollider;
import com.loading.basicResources.ImageLoader;
import com.collision.platformer.CollisionEngine;
import com.gEngine.helper.Screen;
import gameObjects.Player;
import com.loading.basicResources.SpriteSheetLoader;
import com.gEngine.display.Blend;
import com.gEngine.shaders.ShRetro;
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

	override function load(resources:Resources) {
		resources.add(new DataLoader(Assets.blobs.lvl1_tmxName));
		var atlas:JoinAtlas = new JoinAtlas(4000, 4000);
		atlas.add(new FontLoader(Assets.fonts.ArialName, 27));
		atlas.add(new TilesheetLoader("lvl1ground", 16, 16, 0));
		atlas.add(new ImageLoader("lvl1Background"));
		atlas.add(new ImageLoader("bullet"));
		atlas.add(new ImageLoader("heart"));
		atlas.add(new ImageLoader("mana"));
		atlas.add(new ImageLoader("sword"));
		atlas.add(new ImageLoader("fireballHUD"));
		atlas.add(new ImageLoader("hand"));
		atlas.add(new SpriteSheetLoader("player", 50, 37, 0, [
			Sequence.at("idle", 0, 3), Sequence.at("run", 8, 13), Sequence.at("jump", 15, 17), Sequence.at("sword", 42, 48), Sequence.at("sword2", 49, 52),
			Sequence.at("sword3", 53, 58), Sequence.at("power", 89, 91), Sequence.at("dead", 65, 68), Sequence.at("power2", 102, 108),
			Sequence.at("fall", 22, 23)]));
		resources.add(atlas);
	}

	override function init() {
		loadBackground();
		audio = kha.audio1.Audio.play(Assets.sounds.FOREST, true); // meter en background con lvl 1
		simulationLayer = new Layer();
		GGD.simulationLayer = simulationLayer;
		stage.addChild(simulationLayer);
		worldMap = new Tilemap("lvl1_tmx", 1);
		worldMap.init(function(layerTilemap, tileLayer) {
			if (!tileLayer.properties.exists("noCollision")) {
				layerTilemap.createCollisions(tileLayer);
			}
			simulationLayer.addChild(layerTilemap.createDisplay(tileLayer, new Sprite("lvl1ground")));
		}, parseMapObjects);

		stage.defaultCamera().limits(0, 0, worldMap.widthIntTiles * 32, (worldMap.heightInTiles * 32));
		player = new Player(35, 415, simulationLayer);
		addChild(player);
		setHUD();
		stage.defaultCamera().scale = 2;
	}

	inline function loadBackground() {
		var backgraundLayer = new Layer();
		var background = new Sprite("lvl1Background");
		background.smooth = true;
		backgraundLayer.addChild(background);
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
		fireBall.x = GEngine.virtualWidth * 0.975;
		fireBall.y = GEngine.virtualHeight * 0.145;
		hudLayer.addChild(fireBall);

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
	}

	override function update(dt:Float) {
		super.update(dt);
		updateHUD();
		stage.defaultCamera().setTarget(player.collision.x, player.collision.y - 133);
		CollisionEngine.collide(player.collision, worldMap.collision);
		CollisionEngine.collide(player.gun.bulletsCollisions, worldMap.collision, destroyBullet);
		CollisionEngine.overlap(player.sword.collision, worldMap.collision);
		reset();
	}

	public function destroyBullet(a:ICollider, b:ICollider) {
		/*var bullet:Bullet=cast a.userData;
			bullet.collision.x=-5000;
			bullet.collision.y=-5000; */
	}

	inline function updateHUD() {
		fireBallLevitation();
		arrowUpdate();
		manaAndHeartsUpdate();
	}

	inline function manaAndHeartsUpdate() {
		heartCounter.text = player.hearts+"";
		manaCounter.text = player.mana+"";
	}

	inline function arrowUpdate() {
		if (Input.i.isKeyCodePressed(KeyCode.One)) {
			arrow.y = GEngine.virtualHeight * 0.067;
		}
		if (Input.i.isKeyCodePressed(KeyCode.Two)) {
			arrow.y = GEngine.virtualHeight * 0.145;
		}
	}

	inline function fireBallLevitation() {
		fireBall.y += 0.12 * fireBallYLevitation;
		if (fireBall.y > ((GEngine.virtualHeight * 0.145) + 3) || fireBall.y < ((GEngine.virtualHeight * 0.145) - 3)) {
			fireBallYLevitation *= -1;
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
			case OTTile(gid):
			/*var sprite = new Sprite("salt");
				sprite.smooth = false;
				sprite.x = object.x;
				sprite.y = object.y - sprite.height();
				sprite.pivotY=sprite.height();
				sprite.scaleX = object.width/sprite.width();
				sprite.scaleY = object.height/sprite.height();
				sprite.rotation = object.rotation*Math.PI/180;
				simulationLayer.addChild(sprite); */
			case OTRectangle:
				if (object.type == "spawn") {
					/*var x = object.properties.get("X");
						var y = object.properties.get("Y");
						spawnX = Std.parseFloat(x);
						spawnY = Std.parseFloat(y); */
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
