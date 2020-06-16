import com.gEngine.display.Camera;
import com.gEngine.display.Layer;

typedef GGD = GlobalGameData;

class GlobalGameData {
	public static var simulationLayer:Layer;
	public static var camera:Camera;

	public static function destroy() {
		simulationLayer = null;
		camera = null;
	}
}
