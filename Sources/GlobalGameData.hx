import kha.audio1.AudioChannel;
import js.html.Audio;
import com.gEngine.display.Camera;
import com.gEngine.display.Layer;

typedef GGD = GlobalGameData;

class GlobalGameData {
	public static var simulationLayer:Layer;
	public static var camera:Camera;
	public static var audioChannel:AudioChannel;

	public static function destroy() {
		simulationLayer = null;
		camera = null;
		audioChannel = null;
	}
}
