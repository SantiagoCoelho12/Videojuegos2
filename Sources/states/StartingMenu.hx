package states;

import com.loading.basicResources.ImageLoader;
import com.gEngine.display.Sprite;
import kha.audio1.AudioChannel;
import kha.Color;
import kha.input.KeyCode;
import com.gEngine.display.Text;
import com.loading.Resources;
import com.gEngine.display.StaticLayer;
import kha.Assets;
import com.loading.basicResources.FontLoader;
import com.loading.basicResources.JoinAtlas;
import com.framework.utils.Input;
import com.gEngine.display.Layer;
import com.gEngine.GEngine;
import com.framework.utils.Random;
import com.framework.utils.State;
import com.gEngine.helper.RectangleDisplay;

class StartingMenu extends State {
	var layer:Layer;
	var rectangle:RectangleDisplay;
	var start:Text;
	var soundFlag:Bool = true;

	override function load(resources:Resources) {
		var atlas:JoinAtlas = new JoinAtlas(2048, 2048);
		atlas.add(new ImageLoader("RUNZER"));
		atlas.add(new FontLoader(Assets.fonts.GalaxyName, 40));
		atlas.add(new FontLoader(Assets.fonts.ArialName, 23));
		resources.add(atlas);
	}

	override function init() {
		logoImg();
		layer = new StaticLayer();
		start = new Text(Assets.fonts.GalaxyName);
		start.x = GEngine.virtualWidth * 0.37;
		start.y = GEngine.virtualHeight * 0.53;
		start.text = "Start game";
		layer.addChild(start);
		var instructions = new Text(Assets.fonts.ArialName);
		instructions.x = GEngine.virtualWidth * 0.4;
		instructions.y = GEngine.virtualHeight * 0.75;

		instructions.text = "HOW TO PLAY:\n\n-Move: W A S D \n-Run:  Shift \n-Hit:  Right click (Keep pressed)\n-Change Weapon:  1 2 3";

		layer.addChild(instructions);
		stage.addChild(layer);
	}

	inline function logoImg() {
		var image = new Sprite("RUNZER");
		image.x = GEngine.virtualWidth * 0.72 - image.width() * 0.5;
		image.y = 100;
		image.scaleX = image.scaleY = 0.7;
		image.offsetX = -100;
		stage.addChild(image);
	}

	override function update(dt:Float) {
		super.update(dt);
		var x = Input.i.getMouseX();
		var y = Input.i.getMouseY();
		if (overStarText(x, y)) {
			if (soundFlag) {
				var beep:AudioChannel = kha.audio1.Audio.play(Assets.sounds.DECIDE);
				soundFlag = false;
			}
			start.color = Color.Green;
			start.scaleX = 1.01;
			start.scaleY = 1.01;
			start.offsetX = -0.5;
			start.offsetY = -0.5;
			if (Input.i.isMouseReleased()) {
				var beep:AudioChannel = kha.audio1.Audio.play(Assets.sounds.START);
				changeState(new GameState());
			}
		} else {
			start.color = Color.fromBytes(116, 132, 65);
			soundFlag = true;
			start.scaleX = 1;
			start.scaleY = 1;
			start.offsetX = 0;
			start.offsetY = 0;
		}
		reset();
	}

	private function overStarText(x:Float, y:Float):Bool {
		var flag:Bool = false;
		var valuex:Float = GEngine.virtualWidth * 0.37;
		var valuey:Float = GEngine.virtualHeight * 0.53;
		if ((x >= valuex && x <= valuex + 290) && (y >= valuey && y <= valuey + 40))
			flag = true;
		return flag;
	}

	inline function reset() {
		if (Input.i.isKeyCodePressed(KeyCode.Escape)) {
			changeState(new StartingMenu());
		}
	}

	override function render() {
		super.render();
	}
}
