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

class Win extends State {
	var score:Int;
	var ship:Player;
	var time:Float = 0;
	var simulationLayer:Layer;

	public function new(time:Float) {
		super();
		score = Std.int(time);
	}

	override function load(resources:Resources) {
		var atlas:JoinAtlas = new JoinAtlas(2048, 2048);
		atlas.add(new ImageLoader("win"));
		atlas.add(new ImageLoader("enter"));
		atlas.add(new FontLoader(Assets.fonts.ArialName, 27));
		resources.add(atlas);
	}

	override function init() {
		winImg();
		scoreText();
		resetText();
        enterImg();
        creatorsText();
	}

	inline function winImg() {
		var image = new Sprite("win");
		image.x = GEngine.virtualWidth * 0.8 - image.width() * 0.5;
		image.y = 100;
		image.scaleX = image.scaleY = 0.5;
		image.offsetX = -100;
		stage.addChild(image);
	}

	inline function enterImg() {
		var image = new Sprite("enter");
		image.x = GEngine.virtualWidth * 0.50;
		image.y = GEngine.virtualHeight * 0.70;
		image.scaleX = image.scaleY = 0.5;
		image.offsetX = -100;
		stage.addChild(image);
	}

	inline function scoreText() {
		var textScore = new Text(Assets.fonts.ArialName);
		textScore.text = "     Congratulations!" + "\nTime played: " + score + " seconds";
		textScore.x = GEngine.virtualWidth / 2 - textScore.width() * 0.63;
		textScore.y = GEngine.virtualHeight * 0.46;
		textScore.color = Color.fromBytes(255, 212, 100);
		stage.addChild(textScore);
	}

	inline function resetText() {
		var replay = new Text(Assets.fonts.ArialName);
		var press = new Text(Assets.fonts.ArialName);
		press.x = GEngine.virtualWidth * 0.37;
		press.y = GEngine.virtualHeight * 0.70;
		press.color = Color.fromBytes(255, 212, 100);
		replay.x = GEngine.virtualWidth * 0.49;
		replay.y = GEngine.virtualHeight * 0.70;
		replay.color = Color.fromBytes(255, 212, 100);
		press.text = "Press";
		replay.text = "to play again!";
		stage.addChild(press);
		stage.addChild(replay);
    }
    
    inline function creatorsText() {
        var textCreators = new Text(Assets.fonts.ArialName);
        textCreators.fontSize = 14;
        textCreators.smooth = true;
		textCreators.text = "Developed by Santiago Coelho & Keshet Hertz";
		textCreators.x = GEngine.virtualWidth / 2 - textCreators.width() * 0.59;
        textCreators.y = GEngine.virtualHeight * 0.94;
		textCreators.color = Color.White;
		stage.addChild(textCreators);
	}

	override function update(dt:Float) {
		super.update(dt);
		if (Input.i.isKeyCodePressed(KeyCode.Return)) {
			changeState(new StartingMenu());
		}
	}
}
