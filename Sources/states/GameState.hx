package states;

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
	var heart:Sprite;

	override function load(resources:Resources) {
		resources.add(new DataLoader(Assets.blobs.lvl1_tmxName));
		var atlas:JoinAtlas = new JoinAtlas(4000, 4000);
		atlas.add(new TilesheetLoader("lvl1ground", 16, 16, 0));
		atlas.add(new ImageLoader("lvl1Background"));
		atlas.add(new ImageLoader("bullet"));
		atlas.add(new ImageLoader("heart"));
		atlas.add(new ImageLoader("sword"));
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
		heart = new Sprite("heart");
		heart.scaleX = heart.scaleY = 0.27;
		heart.x = GEngine.virtualWidth * 0.005;
		heart.y = GEngine.virtualHeight * 0.05;
		hudLayer.addChild(heart);
	}

	override function update(dt:Float) {
		super.update(dt);
		updateHUD();
		stage.defaultCamera().setTarget(player.collision.x, player.collision.y - 133);
		CollisionEngine.collide(player.collision, worldMap.collision);
		CollisionEngine.overlap(player.gun.bulletsCollisions, worldMap.collision);
		CollisionEngine.overlap(player.sword.collision, worldMap.collision);
		reset();
	}

	inline function updateHUD() {

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
