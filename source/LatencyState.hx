package;

import flixel.util.FlxColor;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import Character;

class LatencyState extends FlxState
{
	var offsetText:FlxText;
	var strumLine:FlxSprite;
	
	override function create()
	{
		FlxG.camera.zoom = 0.75;
		FlxG.sound.playMusic('assets/sounds/soundTest' + TitleState.soundExt);

		var stageback:FlxSprite = new FlxSprite(-600, -200).loadGraphic('assets/images/stages/week1/stageback.png');
		stageback.antialiasing = true;
		stageback.scrollFactor.set(0.9, 0.9);
		stageback.active = false;
		add(stageback);

		var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic('assets/images/stages/week1/stagefront.png');
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		stageFront.updateHitbox();
		stageFront.antialiasing = true;
		stageFront.scrollFactor.set(0.9, 0.9);
		stageFront.active = false;
		add(stageFront);

		var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic('assets/images/stages/week1/stagecurtains.png');
		stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
		stageCurtains.updateHitbox();
		stageCurtains.antialiasing = true;
		stageCurtains.scrollFactor.set(1.3, 1.3);
		stageCurtains.active = false;
		add(stageCurtains);

		offsetText = new FlxText();
		offsetText.screenCenter();
		add(offsetText);

		strumLine = new FlxSprite(FlxG.width / 2, 100).makeGraphic(FlxG.width, 5);
		add(strumLine);

		Conductor.changeBPM(120);

		super.create();
	}

	override function update(elapsed:Float)
	{
		offsetText.text = "Offset: " + Conductor.offset + "ms";
		offsetText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		Conductor.songPosition = FlxG.sound.music.time - Conductor.offset;

		var multiply:Float = 1;

		if (FlxG.keys.pressed.SHIFT)
			multiply = 10;

		if (FlxG.keys.justPressed.RIGHT)
			Conductor.offset += 1 * multiply;
		if (FlxG.keys.justPressed.LEFT)
			Conductor.offset -= 1 * multiply;

		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.sound.music.stop();

			FlxG.resetState();
		}

		if (FlxG.keys.justPressed.ESCAPE)
			{
				FlxG.sound.music.stop();

				FlxG.switchState(new options.OptionsState());
			}		

		super.update(elapsed);
	}
}
