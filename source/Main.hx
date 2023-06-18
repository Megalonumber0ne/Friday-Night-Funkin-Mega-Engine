package;

//import js.html.Client;
import flixel.FlxG;
import handlers.ClientPrefs;
import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;
class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, TitleState));

		#if !mobile
		addChild(new FPS(10, 3, 0xFFFFFF));
		#end
		
		if (ClientPrefs.getOption('autoPause') == false)
			FlxG.autoPause = false;
	}
}
