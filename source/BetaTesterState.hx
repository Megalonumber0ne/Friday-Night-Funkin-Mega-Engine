package;

import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;

class BetaTesterState extends MusicBeatState
{
    override function create()
        {
            super.create();
            var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
            add(bg);
            var txt:FlxText = new FlxText(0, 0, FlxG.width,
                "Hey! Thanks for helping to beta test Mega Engine!\nThis project is still in heavy development\nPlease report any issues to the GitHub,\nHappy Funkin'!",
                32);
            txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
            txt.screenCenter();
            add(txt);
        }
    
        override function update(elapsed:Float)
        {
            if (controls.ACCEPT)
            {
                FlxG.camera.flash(FlxColor.WHITE, 1);
                FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt, 0.7);
                
                new FlxTimer().start(2, function(tmr:FlxTimer){
                    FlxG.switchState(new MainMenuState());
                });
            }
            super.update(elapsed);
        }
}