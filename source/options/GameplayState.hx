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
	var grpMenuShit:FlxTypedGroup<Alphabet>;
	var settingsSave:FlxSave = new FlxSave();

	var gtText:FlxText;

	var menuItems:Array<String> = ['Ghost Tapping', 'Mods', 'ME Watermarks In Gameplay', 'Framerate', 'Note Splashes', 'Downscroll'];
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
		
        FlxG.stage.frameRate = ClientPrefs.getOption('gameFrameRate');

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

			case "Mega Watermarks In Gameplay":
				if (controls.ACCEPT)
					ClientPrefs.setOption('MegaEngineWatermarks', !ClientPrefs.getOption('MegaEngineWatermarks'));

				gtText.text = 'A watermark for the engine (inside of a song) is set to ${ClientPrefs.getOption('MegaEngineWatermarks')}. This also includes a song watermark above.';

			case "Framerate":
				if (controls.LEFT)
					if (ClientPrefs.getOption('gameFrameRate') >20)
						(ClientPrefs.setOption('gameFrameRate', ClientPrefs.getOption('gameFrameRate') - 5));
				
				if (controls.RIGHT)
					if (ClientPrefs.getOption('gameFrameRate') <150)
						(ClientPrefs.setOption('gameFrameRate', ClientPrefs.getOption('gameFrameRate') + 5));
				gtText.text = 'Framerate is currently '+ (ClientPrefs.getOption('gameFrameRate')) + ' - Experimental!';
				//FlxG.stage.frameRate = ClientPrefs.getOption('gameFrameRate');

			case "Note Splashes":
				if (controls.ACCEPT)
					ClientPrefs.setOption('notesplashes', !ClientPrefs.getOption('notesplashes'));
	
				gtText.text = 'Note Splashes are currently set to ${ClientPrefs.getOption('notesplashes')}';

			case "Downscroll":
				if (controls.ACCEPT)
					ClientPrefs.setOption('downscroll', !ClientPrefs.getOption('downscroll'));
		
				gtText.text = 'Downscroll is currently set to ${ClientPrefs.getOption('downscroll')}';
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
