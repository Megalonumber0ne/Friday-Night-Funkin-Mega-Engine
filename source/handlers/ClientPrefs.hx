package handlers;

import flixel.FlxG;

class ClientPrefs
{
	public static var options:Map<String, Dynamic> = new Map();

	public static function getOption(option:String)
		return options.get(option);

	public static function setOption(optionName:String, optionValue:Dynamic){
		options.set(optionName, optionValue);
	
		FlxG.save.data.options = options;
		FlxG.save.flush();
	}

	public static function initOptions(){
		if (FlxG.save.data.options != null)
			options = FlxG.save.data.options;

		if (ClientPrefs.getOption('ghostTapping') == null)
			ClientPrefs.setOption('ghostTapping', true);
		if (ClientPrefs.getOption('mods') == null)
			ClientPrefs.setOption('mods', true);
		if (ClientPrefs.getOption('comboSplash') == null)
			ClientPrefs.setOption('comboSplash', true);
		if (ClientPrefs.getOption('showInfoText') == null)
			ClientPrefs.setOption('showInfoText', true);
		if (ClientPrefs.getOption('ratingColors') == null)
			ClientPrefs.setOption('ratingColors', true);
		if (ClientPrefs.getOption('chillMode') == null)
			ClientPrefs.setOption('chillMode', false);
		if (ClientPrefs.getOption('ratingOnCam') == null)
			ClientPrefs.setOption('ratingOnCam', true);
		if (ClientPrefs.getOption('MegaEngineWatermarks') == null)
			ClientPrefs.setOption('MegaEngineWatermarks', true);
		if (ClientPrefs.getOption('BetaTesterState') == null)
			ClientPrefs.setOption('BetaTesterState', true);
		if (ClientPrefs.getOption('gameFrameRate') == null)
			ClientPrefs.setOption('gameFrameRate', 60);
		if (ClientPrefs.getOption('naughtiness') == null)
			ClientPrefs.setOption('naughtiness', true);
		if (ClientPrefs.getOption('notesplashes') == null)
			ClientPrefs.setOption('notesplashes', true);
		if (ClientPrefs.getOption('downscroll') == null)
			ClientPrefs.setOption('downscroll', false);
	}
}