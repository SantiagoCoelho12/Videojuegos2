package states;

import com.loading.basicResources.JoinAtlas;
import kha.input.KeyCode;
import com.framework.utils.Input;
import com.loading.Resources;
import com.framework.utils.State;

class GameState extends State {


	override function load(resources:Resources) {
		var atlas:JoinAtlas = new JoinAtlas(2048, 2048);
	}

	override function init() {}

	override function update(dt:Float) {
        super.update(dt);
		reset();
	}

	override function render() {
		super.render();
	}

	inline function reset() {
		if (Input.i.isKeyCodePressed(KeyCode.Escape)) {
			changeState(new Menu());
		}
	}
}
