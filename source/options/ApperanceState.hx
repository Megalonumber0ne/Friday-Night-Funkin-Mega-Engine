package options;

import handlers.ClientPrefs;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

class ApperanceState extends MusicBeatState {
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var gtText:FlxText;

	var menuItems:Array<String> = [
		'Old Graphics', 'Show Combo Splash', 'Show Info Text'
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
				case "Old Graphics":
					if (ClientPrefs.oldGraphics == false) {
						ClientPrefs.oldGraphics = true;
						trace("on");
						gtText.text = "Old Graphics are currently on";
					}
					else
					{
						ClientPrefs.oldGraphics = false;
						trace("off");
						gtText.text = "Old Graphics are currently off";
					}	
					trace("Old Graphics Toggled");	
					
				case "Show Combo Splash":
					if (ClientPrefs.comboSplash == false) {
						ClientPrefs.comboSplash = true;
						gtText.text = "The Combo Splash is currently on";
						trace("on");
					}
					else
					{
						ClientPrefs.comboSplash = false;
						gtText.text = "The Combo Splash is currently off";
						trace("off");
					}
					trace("Combo Splash Toggled");
					
				case "Show Info Text":
					if (ClientPrefs.showInfoText == false) {
						ClientPrefs.showInfoText = true;
						gtText.text = "Show Info Text is currently on";
						trace("on");
					}
					else
					{
						ClientPrefs.showInfoText = false;
						gtText.text = "Show Info Text is currently off";
						trace("off");
					}
					trace("Show Info Text Toggled");
					ClientPrefs.saveSettings();
					trace("Settings Saved.");			
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
