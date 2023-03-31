package;

import flixel.FlxSprite;
import PlayState;
import Song.SwagSong;
import lime.utils.Assets;

class Stages extends FlxSprite
{
    public static var SONG:SwagSong;
    private var game:Dynamic = PlayState.instance;
    
	function create()
	{
        if (SONG.song.toLowerCase() == 'tutorial' || SONG.song.toLowerCase() == 'bopeebo' || SONG.song.toLowerCase() == 'fresh' || SONG.song.toLowerCase() == 'dadbattle'){

        var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic('assets/images/stageback.png');
        bg.antialiasing = true;
        bg.scrollFactor.set(0.9, 0.9);
        bg.active = false;
        game.add(bg);

        var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic('assets/images/stagefront.png');
        stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
        stageFront.updateHitbox();
        stageFront.antialiasing = true;
        stageFront.scrollFactor.set(0.9, 0.9);
        stageFront.active = false;
        game.add(stageFront);

        var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic('assets/images/stagecurtains.png');
        stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
        stageCurtains.updateHitbox();
        stageCurtains.antialiasing = true;
        stageCurtains.scrollFactor.set(1.3, 1.3);
        stageCurtains.active = false;

        game.add(stageCurtains);
        }
    }
}