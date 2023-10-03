package;

import haxe.display.Display.Package;
import haxe.macro.Context;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class BuildNumber {
    public static macro function getBuildTime() {
        return Context.parse('${Math.floor(Date.now().getTime() / 1000)}', Context.currentPos());
    }

    public static macro function getBuildNumber() {
        var buildNumber = 0;
        #if !display
        if (!FileSystem.exists("export/release/.build")) {
        //File.saveContent(".build", Std.string(buildNumber));
        }
        else {
            //buildNumber = Std.parseInt(File.getContent("export/release/.build"));
            var releaseBuilds = Std.parseInt(File.getContent("export/release/.build"));
            var debugBuilds = Std.parseInt(File.getContent("export/debug/.build"));
            
            buildNumber = (releaseBuilds + debugBuilds);
            // File.saveContent(".build", Std.string(buildNumber + 1));
        }
        #end

        // File.saveContent("./test.txt", #if display "display" #else "not display" #end + " " + Std.string(buildNumber));
        return macro $v{buildNumber + 0};
    }
}