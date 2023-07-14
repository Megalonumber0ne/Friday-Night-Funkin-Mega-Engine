package options;

import handlers.ClientPrefs;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.FlxState;
import Controls;

class SocialsState extends MusicBeatState{
    var grpMenuShit:FlxTypedGroup<Alphabet>;

    var menuItems:Array<String> = ['Funkin Kickstarter', 'Funkin Crew', 'Mega Engine Discord'];
	var curSelected:Int = 0;

    override function create(){
        super.create();

		if (ClientPrefs.getOption('chillMode') == true)
			{
				var bg = new FlxSprite().loadGraphic(('assets/images/menu_assets/menuDesat.png'));
				bg.color = 0x130127;
				add(bg);
			}
		else
			{
				var bg = new FlxSprite().loadGraphic(('assets/images/menu_assets/menuDesat.png'));
				bg.color = 0x340666;
				add(bg);
			}

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.screenCenter(X);
			songText.isFreeplayItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
    }

    override function update(elapsed)
        {
            super.update(elapsed);

            if (controls.UP_P)
                changeSelection(-1);
            if (controls.DOWN_P)
                changeSelection(1);
            if (controls.BACK)
                FlxG.switchState(new OptionsState());

            if (controls.ACCEPT) {
            var daSelected:String = menuItems[curSelected];

            switch (daSelected)
                {
                    case 'Funkin Kickstarter':
                        FlxG.openURL('https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game/');
                    case 'Funkin Sound Team':
                        FlxG.openURL('https://open.spotify.com/artist/4fqDivs0BnIje4XZ10cF2d');
                    case 'Mega Engine Discord':
                        FlxG.openURL('https://discord.gg/Mb78ZKtEYY');
                }
            }
        }

    function changeSelection(change:Int = 0):Void
        {
            curSelected = FlxMath.wrap(curSelected + change, 0, menuItems.length - 1);
        
            for (i in 0...grpMenuShit.length)
            {
                var item = grpMenuShit.members[i];
                item.targetY = i - curSelected;
                item.alpha = item.targetY == 0 ? 1 : 0.6;
            }
        }
}