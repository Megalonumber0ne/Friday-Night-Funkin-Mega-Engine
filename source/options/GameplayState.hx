package options;

// import js.html.Client;
import handlers.ClientPrefs;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import Controls.KeyboardScheme;

class GameplayState extends MusicBeatState
{
	//public static var framerate:Int = 144;

	var grpMenuShit:FlxTypedGroup<Alphabet>;
	var settingsSave:FlxSave = new FlxSave();

	var gtText:FlxText;

	var menuItems:Array<String> = ['Ghost Tapping', 'Mods'];
	var curSelected:Int = 0;

	public var isFreeplayItem:Bool = false;

	override public function create()
	{
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

		gtText = new FlxText(5, FlxG.height - 18, 0, "", 12);
		gtText.scrollFactor.set();
		gtText.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(gtText);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);
		if (controls.BACK)
			FlxG.switchState(new OptionsState());
		var daSelected:String = menuItems[curSelected];

		switch (daSelected)
		{
			case "Ghost Tapping":
				if (controls.ACCEPT)
					ClientPrefs.setOption('ghostTapping', !ClientPrefs.getOption('ghostTapping'));

				gtText.text = 'Ghost Tapping is currently set to ${ClientPrefs.getOption('ghostTapping')}';

			case "Mods":
				if (controls.ACCEPT)
					ClientPrefs.setOption('mods', !ClientPrefs.getOption('mods'));

				gtText.text = 'Mods are currently set to ${ClientPrefs.getOption('mods')}';

			/*case "Framerate":
				if (controls.LEFT_P)
					if (framerate >20)
						framerate = framerate - 5;

				if (controls.RIGHT_P)
					if (framerate <150)
						framerate = framerate + 5;
				gtText.text = 'Framerate is currently '+ framerate + ' - Experimental!';*/
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
