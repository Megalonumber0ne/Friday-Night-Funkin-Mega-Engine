package;

import handlers.ClientPrefs;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import BuildNumber;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	override function create()
	{
		if (!FlxG.sound.music.playing) {
			FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt, 0);
		}

		persistentUpdate = persistentDraw = true;

		if (ClientPrefs.getOption('chillMode') == false)
			{
				var bg:FlxSprite = new FlxSprite(-80).loadGraphic('assets/images/menu_assets/menuBG.png');
				bg.scrollFactor.x = 0;
				bg.scrollFactor.y = 0.15;
				bg.setGraphicSize(Std.int(bg.width * 1.1));
				bg.updateHitbox();
				bg.screenCenter();
				bg.antialiasing = true;
				add(bg);

				camFollow = new FlxObject(0, 0, 1, 1);
				add(camFollow);

				magenta = new FlxSprite(-80).loadGraphic('assets/images/menu_assets/menuDesat.png');
				magenta.color = 0xFFfd719b;
				magenta.scrollFactor.x = 0;
				magenta.scrollFactor.y = 0.15;
				magenta.setGraphicSize(Std.int(magenta.width * 1.1));
				magenta.updateHitbox();
				magenta.screenCenter();
				magenta.visible = false;
				magenta.antialiasing = true;
				add(magenta);
			}
		else if (ClientPrefs.getOption('chillMode') == true)
			{
				var bg:FlxSprite = new FlxSprite(-80).loadGraphic('assets/images/menu_assets/menuDesat.png');
				bg.color = 0xff807122;
				bg.scrollFactor.x = 0;
				bg.scrollFactor.y = 0.15;
				bg.setGraphicSize(Std.int(bg.width * 1.1));
				bg.updateHitbox();
				bg.screenCenter();
				bg.antialiasing = true;
				add(bg);

				camFollow = new FlxObject(0, 0, 1, 1);
				add(camFollow);

				magenta = new FlxSprite(-80).loadGraphic('assets/images/menu_assets/menuDesat.png');
				magenta.color = 0xff8f2e4b;
				magenta.scrollFactor.x = 0;
				magenta.scrollFactor.y = 0.15;
				magenta.setGraphicSize(Std.int(magenta.width * 1.1));
				magenta.updateHitbox();
				magenta.screenCenter();
				magenta.visible = false;
				magenta.antialiasing = true;
				add(magenta);
			}

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = FlxAtlasFrames.fromSparrow('assets/images/menu_assets/FNF_main_menu_assets.png', 'assets/images/menu_assets/FNF_main_menu_assets.xml');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}

		FlxG.camera.follow(camFollow, null, 0.06);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'));
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		var buildNumShit:FlxText = new FlxText(5, FlxG.height - 52, 0, "Engine Build Number " + BuildNumber.getBuildNumber());
		buildNumShit.scrollFactor.set();
		buildNumShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(buildNumShit);

		var engineVerShit:FlxText = new FlxText(5, FlxG.height - 34, 0, "Mega Engine v0.3.1 - Beta Release 6");
		engineVerShit.scrollFactor.set();
		engineVerShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(engineVerShit);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					FlxG.openURL('https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story mode':
										FlxG.switchState(new StoryMenuState());
									case 'freeplay':
										FlxG.switchState(new FreeplayState());
									case 'options':
										FlxG.switchState(new options.OptionsState());
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
