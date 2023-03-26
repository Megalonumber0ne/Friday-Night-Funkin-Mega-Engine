package;

import openfl.Assets;

using StringTools;

class CoolUtil{
    public static function loadText(path:String):Array<String> {
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length) {
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function loadTextLowercase(path:String):Array<String> {
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length) {
			daList[i] = daList[i].trim().toLowerCase();
		}

		return daList;
	}
    
    public static function loadMods() {
        #if sys
		polymod.Polymod.init({
			modRoot: "mods",
			dirs: sys.FileSystem.readDirectory('./mods'),
			errorCallback: (e) ->
			{
				trace(e.message);
			},
			frameworkParams: {
				assetLibraryPaths: [
					"songs" => "assets/songs",
					"images" => "assets/images",
					"data" => "assets/data",
					"fonts" => "assets/fonts",
					"sounds" => "assets/sounds",
					"music" => "assets/music",
				]
			}
		});
		#end
    }
}