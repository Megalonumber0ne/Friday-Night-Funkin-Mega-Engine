package;

import flixel.graphics.FlxGraphic;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import Controls.Control;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.math.FlxRect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
#if discord_rpc
import handlers.DiscordHandler;
#end

class OptionsState extends MusicBeatState {
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	static var initialized:Bool = false;
	var transitioning:Bool = true;

	var menuItems:Array<String> = [
		'Apperance', 'Gameplay'
	];
	var curSelected:Int = 0;

	override public function create() {
		var bg = new FlxSprite().loadGraphic(('assets/images/menuDesat.png'));
		bg.color = 0x340666;
		add(bg);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length) {
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		startTransition();
	}

	function startTransition()
		{
			if (!initialized)
			{
				var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
				diamond.persist = true;
				diamond.destroyOnNoUse = false;
	
				FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
					new FlxRect(0, 0, FlxG.width, FlxG.height));
				FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
					{asset: diamond, width: 32, height: 32}, new FlxRect(0, 0, FlxG.width, FlxG.height));
	
				FlxTransitionableState.defaultTransIn.tileData = {asset: diamond, width: 32, height: 32};
				FlxTransitionableState.defaultTransOut.tileData = {asset: diamond, width: 32, height: 32};
	
				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;
	
				FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt, 0);
	
				FlxG.sound.music.fadeIn(4, 0, 0.7);
			}
		}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);

		#if discord_rpc
		DiscordHandler.changePresence('Viewing the credits', 'In the credits menu', 'credits');
		#end

		if (controls.BACK)
			FlxG.switchState(new MainMenuState());
		if (controls.ACCEPT) {
			var daSelected:String = menuItems[curSelected].toLowerCase();

			switch (daSelected) {
				case "Apperance":
					trace("Apperance selected");
				case "Gameplay":
					trace("Gameplay selected");
			}
		}
	}

	function changeSelection(change:Int = 0):Void {
		curSelected = FlxMath.wrap(curSelected + change, 0, menuItems.length - 1);

		for (i in 0...grpMenuShit.length) {
			var item = grpMenuShit.members[i];
			item.targetY = i - curSelected;
			item.alpha = item.targetY == 0 ? 1 : 0.6;
		}
	}
}
