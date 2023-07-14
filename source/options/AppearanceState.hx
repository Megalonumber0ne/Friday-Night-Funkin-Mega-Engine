package options;

import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.tweens.misc.NumTween;
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

class AppearanceState extends MusicBeatState
{	
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var gtText:FlxText;

	var menuItems:Array<String> = ['Chill Mode', 'Show Combo Splash', 'Show Info Text', 'Use Rating Based Colors', 'Cool Splash Stuff On Camera'];

	var curSelected:Int = 0;

	public var isFreeplayItem:Bool = false;
	

	override public function create():Void
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
			case "Show Combo Splash":
				if (controls.ACCEPT)
					ClientPrefs.setOption('comboSplash', !ClientPrefs.getOption('comboSplash'));

				gtText.text = 'The Combo Splash is currently set to ${ClientPrefs.getOption('comboSplash')}';

			case "Show Info Text":
				if (controls.ACCEPT)
					ClientPrefs.setOption('showInfoText', !ClientPrefs.getOption('showInfoText'));

				gtText.text = 'Show Info Text is currently set to ${ClientPrefs.getOption('showInfoText')}';

			case "Use Rating Based Colors":
				if (controls.ACCEPT)
					ClientPrefs.setOption('ratingColors', !ClientPrefs.getOption('ratingColors'));

				gtText.text = 'Using Rating Based Colors is currently set to ${ClientPrefs.getOption('ratingColors')}';

			case "Chill Mode":
				if (controls.ACCEPT){
					ClientPrefs.setOption('chillMode', !ClientPrefs.getOption('chillMode'));
					songUpdate();}

				gtText.text = 'Chill Mode is currently set to be ${ClientPrefs.getOption('chillMode')}';

			case "Cool splash stuff on camera":
				if (controls.ACCEPT)
					ClientPrefs.setOption('ratingOnCam', !ClientPrefs.getOption('ratingOnCam'));

					if (ClientPrefs.getOption('ratingOnCam') == true)
						gtText.text = 'This option is currently set to ${ClientPrefs.getOption('ratingOnCam')}. This puts the rating, combo and combo splash on the camera rather than the world.';
					if (ClientPrefs.getOption('ratingOnCam') == false)
						gtText.text = 'This option is currently set to ${ClientPrefs.getOption('ratingOnCam')}. This puts the rating, combo and combo splash on the world rather than the camera.';
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

	function songUpdate()
		{
			FlxG.sound.music.fadeOut(0.5, 0);
			var timer:FlxTimer = new FlxTimer().start(0.5, stopMusic);
			var timer:FlxTimer = new FlxTimer().start(0.5, songUpdateFromNull);
		}

	function stopMusic(timer:FlxTimer)
		{
			FlxG.sound.music.stop();
		}

	function songUpdateFromNull(timer:FlxTimer):Void
		{
			if (ClientPrefs.getOption('chillMode') == true)
				{
					FlxG.sound.playMusic('assets/music/ChillMenu' + TitleState.soundExt, 0);
					FlxG.sound.music.fadeIn(2, 0, 0.7);
				}
			else
				{
					FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt, 0);
					FlxG.sound.music.fadeIn(2, 0, 0.7);
				}
		}
}