package;

//import js.html.Client;
import flixel.FlxG;
import options.GameplayState;
import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var fpsCounter:FPS;

	public function new()
	{
		super();
		//addChild(new FlxGame(0, 0, TitleState));
		addChild(new FlxGame(0, 0, TitleState, 1, 144, 144, true, false));

		#if !mobile
		fpsCounter = new FPS(10, 3, 0xFFFFFF);
		addChild(fpsCounter);
		#end
	}
}
