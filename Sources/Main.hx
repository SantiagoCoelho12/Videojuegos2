package;


import kha.Assets;
import kha.WindowMode;
import com.framework.Simulation;
import kha.System;
import kha.System.SystemOptions;
import kha.FramebufferOptions;
import kha.WindowOptions;
import states.StartingMenu;

class Main {
    public static function main() {
		#if hotml new hotml.Client(); #end
		
			var windowsOptions=new WindowOptions("Obligatorio2",0,0,1280,720,null,true,WindowFeatures.FeatureResizable,WindowMode.Windowed);
		var frameBufferOptions=new FramebufferOptions();
		System.start(new SystemOptions("RUNZER",1280,720,windowsOptions,frameBufferOptions), function (w) {
			new Simulation(StartingMenu,1280,720);
			Assets.loadEverything(function() {});
        });
    }
}
