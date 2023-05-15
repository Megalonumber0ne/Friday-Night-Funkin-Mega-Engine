package handlers;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

class ClientPrefs {
	// For load and save.
	static var settingNames:Array<String> = [
		'OldGraphics', 'ghostTapping', 'comboSplash' 
	];
	public static var ghostTapping:Bool;
	public static var oldGraphics:Bool;
	public static var comboSplash:Bool;
	public static var showInfoText:Bool;
	public static var mods:Bool;

	public static var leftKeybinds:Array<FlxKey> = [FlxKey.A, FlxKey.LEFT];
	public static var downKeybinds:Array<FlxKey> = [FlxKey.S, FlxKey.DOWN];
	public static var upKeybinds:Array<FlxKey> = [FlxKey.W, FlxKey.UP];
	public static var rightKeybinds:Array<FlxKey> = [FlxKey.D, FlxKey.RIGHT];
	public static var resetKeybind:FlxKey = FlxKey.R;
	public static final controls:Controls = new Controls("player0", Solo);

	public static var antialiasing:Bool = true;
	public static var framerate:Int = 60;

	public static var fullscreen:Bool = false;
	public static var autoPause:Bool = true;

	public static var defaultFont:String = 'vcr';

	public static function saveSettings() {
		FlxG.save.data.framerate = framerate;
		#if (flixel > "5.0.0")
		FlxSprite.defaultAntialiasing = antialiasing;
		#end
		
		FlxG.save.flush();

		var settingsSave:FlxSave = new FlxSave();
		settingsSave.bind('settings', 'Mega-Engine-Save');
		settingsSave.data.ghostTapping = ghostTapping;
		settingsSave.data.comboSplash = comboSplash;
		settingsSave.data.oldGraphics = oldGraphics;
		settingsSave.data.showInfoText = showInfoText;
		settingsSave.flush();

		var controlSave:FlxSave = new FlxSave();
		controlSave.bind('controls', 'Mega-Engine-Save'); // Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		controlSave.data.leftBinds = leftKeybinds;
		controlSave.data.downBinds = downKeybinds;
		controlSave.data.upBinds = upKeybinds;
		controlSave.data.rightBinds = rightKeybinds;
		controlSave.data.resetBind = resetKeybind;
		controlSave.flush();
		controlSave.destroy();
	}

	public static function loadPrefs() {
		var settingsSave:FlxSave = new FlxSave();
		settingsSave.bind('settings', 'Mega-Engine-Save');
        if(settingsSave.data.comboSplash != null)
			comboSplash = settingsSave.data.comboSplash;

        if(settingsSave.data.oldGraphics != null)
			oldGraphics = settingsSave.data.oldGraphics;

        if(settingsSave.data.ghostTapping != null)
			ghostTapping = settingsSave.data.ghostTapping;

		if(settingsSave.data.showInfoText != null)
			showInfoText = settingsSave.data.showInfoText;

		if(settingsSave.data.ghostTapping == null)
			trace('Ghost Tapping Setting not present, defaulting to OFF');
			ghostTapping = false;
			ClientPrefs.saveSettings();

		if(settingsSave.data.comboSplash == null)
			trace('Combo Splash Setting not present, defaulting to ON');
			comboSplash = true;
			ClientPrefs.saveSettings();

		if(settingsSave.data.oldGraphics == null)
			trace('Old Graphics Setting not present, defaulting to OFF');
			oldGraphics = false;
			ClientPrefs.saveSettings();

		if(settingsSave.data.showInfoText == null)
			trace('Show Info Text Setting not present, defaulting to ON');
			showInfoText = true;
			ClientPrefs.saveSettings();

		var controlSave:FlxSave = new FlxSave();
		controlSave.bind('controls', 'Funkin-0.2.2-Engine-Save');
		if (controlSave.data.leftBinds != null)
			leftKeybinds = controlSave.data.leftBinds;
		if (controlSave.data.downBinds != null)
			downKeybinds = controlSave.data.downBinds;
		if (controlSave.data.upBinds != null)
			upKeybinds = controlSave.data.upBinds;
		if (controlSave.data.rightBinds != null)
			rightKeybinds = controlSave.data.rightBinds;
		if (controlSave.data.resetBind != null)
			resetKeybind = controlSave.data.resetBind;
		controlSave.destroy();

		if (FlxG.save.data.framerate != null) {
			framerate = FlxG.save.data.framerate;
			if (framerate > FlxG.drawFramerate) {
				FlxG.updateFramerate = framerate;
				FlxG.drawFramerate = framerate;
			} else {
				FlxG.drawFramerate = framerate;
				FlxG.updateFramerate = framerate;
			}
		}

		#if (flixel > "5.0.0")
		FlxSprite.defaultAntialiasing = antialiasing;
		#end

		FlxG.autoPause = autoPause;
		FlxG.fullscreen = fullscreen;
	}
}
