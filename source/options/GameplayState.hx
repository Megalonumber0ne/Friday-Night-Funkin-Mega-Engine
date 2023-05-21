package options;

//import js.html.Client;
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

class GameplayState extends MusicBeatState {
	var grpMenuShit:FlxTypedGroup<Alphabet>;
	var settingsSave:FlxSave = new FlxSave();

	var gtText:FlxText;
	
	var menuItems:Array<String> = [
		'Ghost Tapping', 'Mods'
	];
	var curSelected:Int = 0;
	public var isFreeplayItem:Bool = false;
	override public function create() {
		var bg = new FlxSprite().loadGraphic(('assets/images/menu_assets/menuDesat.png'));
		bg.color = 0x340666;
		add(bg);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length) {
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

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);
		if (controls.BACK)
			FlxG.switchState(new OptionsState());
		if (controls.ACCEPT) {
			var daSelected:String = menuItems[curSelected];

			switch (daSelected) {
				case "Ghost Tapping":
						ClientPrefs.setOption('ghostTapping', !ClientPrefs.getOption('ghostTapping'));
						gtText.text = 'Ghost Tapping Is Currently ${ClientPrefs.getOption('ghostTapping')}';

				case "Mods":
						ClientPrefs.setOption('mods', !ClientPrefs.getOption('mods'));
						gtText.text = 'Mods are Is Currently ${ClientPrefs.getOption('mods')}';
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
