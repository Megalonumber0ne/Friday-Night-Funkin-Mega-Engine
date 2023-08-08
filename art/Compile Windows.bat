@ECHO OFF
ECHO Installing Libraries
haxelib install lime
haxelib install openfl
haxelib --never install flixel
haxelib run lime setup flixel
haxelib run lime setup
haxelib install flixel-tools
haxelib install flixel-ui
haxelib install flixel-addons
haxelib git scriptless-polymod https://github.com/SrtHero278/scriptless-polymod
haxelib git hscript-improved https://www.github.com/YoshiCrafter29/hscript-improved
haxelib git openfl https://github.com/openfl/openfl
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib install hxcpp-debug-server
haxelib list
echo Compiling...
lime build windows
echo Done!