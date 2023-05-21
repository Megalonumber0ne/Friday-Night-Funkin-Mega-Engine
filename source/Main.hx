package;

//import js.html.Client;
import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.display.Sprite;
import handlers.Files;
import handlers.ClientPrefs;
import flixel.FlxG;
#if sys
import sys.io.File;
import sys.FileSystem;
#end
class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, TitleState));

		ClientPrefs.initOptions();

		#if !mobile
		addChild(new FPS(10, 3, 0xFFFFFF));
		#end
	}
}
