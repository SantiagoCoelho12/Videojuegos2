package states;

import gameObjects.Player;
import com.gEngine.display.Sprite;
import kha.Color;
import com.loading.basicResources.JoinAtlas;
import com.gEngine.GEngine;
import com.gEngine.display.Text;
import kha.Assets;
import com.loading.basicResources.FontLoader;
import com.gEngine.display.Layer;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.loading.basicResources.ImageLoader;
import com.loading.Resources;
import com.framework.utils.State;

class GameOver extends State {
	var score:Int;
	var lvl:Int;
	var ship:Player;
	var time:Float = 0;
	var simulationLayer:Layer;

	public function new(_lvl:Int, time:Float) {
		super();
		lvl = _lvl;
		score = Std.int(time);
	}

	override function load(resources:Resources) {
		var atlas:JoinAtlas = new JoinAtlas(2048, 2048);
		// atlas.add(new ImageLoader("gameOver"));
		atlas.add(new FontLoader(Assets.fonts.ArialName, 27));
		resources.add(atlas);
	}

	override function init() {
		//	gameOverImg();
		scoreText();
		resetText();
	}

	inline function gameOverImg() {
		var image = new Sprite("gameOver");
		image.x = GEngine.virtualWidth * 0.5 - image.width() * 0.5;
		image.y = 100;
		image.scaleX = image.scaleY = 1.5;
		image.offsetX = -100;
		stage.addChild(image);
	}

	inline function scoreText() {
		var textScore = new Text(Assets.fonts.ArialName);
		textScore.text = "Time played " + score +"\n You died at level "+ lvl;
		textScore.x = GEngine.virtualWidth / 2 - textScore.width() * 0.63;
		textScore.y = GEngine.virtualHeight * 0.46;
		textScore.color = Color.fromBytes(128, 61, 117);
		stage.addChild(textScore);
	}

	inline function resetText() {
		var replay = new Text(Assets.fonts.ArialName);
		replay.x = GEngine.virtualWidth * 0.22;
		replay.y = GEngine.virtualHeight * 0.52;
		replay.color = Color.fromBytes(128, 61, 117);
		replay.text = "Press enter to play again!";
		stage.addChild(replay);
	}

	override function update(dt:Float) {
		super.update(dt);
		if (Input.i.isKeyCodePressed(KeyCode.Return)) {
			changeState(new StartingMenu());
		}
	}
}
