package states;

import kha.Assets;
import com.loading.basicResources.JoinAtlas;
import com.loading.basicResources.DataLoader;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.loading.Resources;
import com.framework.utils.State;
import com.collision.platformer.Tilemap;
import com.gEngine.display.Layer;

class GameState extends State {
	var worldMap:Tilemap;
	var simulationLayer:Layer;

	override function load(resources:Resources) {
		resources.add(new DataLoader(Assets.blobs.lvl1_tmxName));
		var atlas:JoinAtlas = new JoinAtlas(2048, 2048);
	}

	override function init() {
		/*worldMap = new Tilemap("lvl1_tmx", 1);
			worldMap.init(function(layerTilemap, tileLayer) {
				if (!tileLayer.properties.exists("noCollision")) {
					layerTilemap.createCollisions(tileLayer);
				}
				simulationLayer.addChild(layerTilemap.createDisplay(tileLayer, new Sprite("tiles2")));
		}, parseMapObjects);*/
	}

	override function update(dt:Float) {
		super.update(dt);
		reset();
	}

	override function render() {
		super.render();
	}

	inline function reset() {
		if (Input.i.isKeyCodePressed(KeyCode.Escape)) {
			changeState(new StartingMenu());
		}
	}
}
