package;

import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import HealthIcon;
import handlers.ClientPrefs;
import NoteSplash;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var songAccuracy:Float = 0;
	public var coolNoteFloat:Float = 0; 

	var perfectMode:Bool = false;
	public static var curLevel:String = 'Tutorial';
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var instance:PlayState = null;
	private var allNotes:Int = 0;
	private var vocalsFinished:Bool = false;

	var halloweenLevel:Bool = false;

	private var vocals:FlxSound;

	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var notes:FlxTypedGroup<Note>;
	var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;
	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;

	private var camZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;
	private var misses:Int =0;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var talking:Bool = true;
	var songScore:Int = 0;
	var comboScore:Int = 0;
	var scoreTxt:FlxText;
	var comboTxt:FlxText;
	var missTxt:FlxText;
	var accuracyTxt:FlxText;
	var infoTxt:FlxText;
	public var ratingTxt:String;
	var songRating:FlxText;
	public var ratingColor:FlxColor;

	public static var campaignScore:Int = 0;

	override public function create()
	{
		recalculateAccuracy();

		FlxG.mouse.visible = false;
		instance = this;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson(curLevel);

		Conductor.changeBPM(SONG.bpm);

		switch (SONG.song.toLowerCase())
		{
			case 'tutorial':
				dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
			case 'bopeebo':
				dialogue = [
					'HEY!',
					"You think you can just sing\nwith my daughter like that?",
					"If you want to date her...",
					"You're going to have to go \nthrough ME first!"
				];
			case 'fresh':
				dialogue = ["Not too shabby boy.", ""];
			case 'dadbattle':
				dialogue = [
					"gah you think you're hot stuff?",
					"If you can beat me here...",
					"Only then I will even CONSIDER letting you\ndate my daughter!"
				];
		}

		if (SONG.song.toLowerCase() == 'bopeebo' || SONG.song.toLowerCase() == 'fresh' || SONG.song.toLowerCase() == 'dadbattle' || SONG.song.toLowerCase() == 'tutorial')
		{
			var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic('assets/images/stages/week1/stageback.png');
			bg.antialiasing = true;
			bg.scrollFactor.set(0.9, 0.9);
			bg.active = false;
			add(bg);

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
		}

		if (SONG.song.toLowerCase() == 'spookeez' || SONG.song.toLowerCase() == 'monster' || SONG.song.toLowerCase() == 'south')
		{
			halloweenLevel = true;

			var hallowTex = FlxAtlasFrames.fromSparrow('assets/images/stages/week2/halloween_bg.png', 'assets/images/stages/week2/halloween_bg.xml');

			halloweenBG = new FlxSprite(-200, -100);
			halloweenBG.frames = hallowTex;
			halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
			halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
			halloweenBG.animation.play('idle');
			halloweenBG.antialiasing = true;
			add(halloweenBG);

			isHalloween = true;
		}

		if (SONG.song.toLowerCase() == 'pico' || SONG.song.toLowerCase() == 'blammed' || SONG.song.toLowerCase() == 'philly nice')
			{
				curStage = 'philly';
	
				var bg:FlxSprite = new FlxSprite(-100).loadGraphic('assets/images/stages/week3/sky.png');
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);
	
				var city:FlxSprite = new FlxSprite(-10).loadGraphic('assets/images/stages/week3/city.png');
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);
	
				phillyCityLights = new FlxTypedGroup<FlxSprite>();
				add(phillyCityLights);
	
				for (i in 0...5)
				{
					var light:FlxSprite = new FlxSprite(city.x).loadGraphic('assets/images/stages/week3/win' + i + '.png');
					light.scrollFactor.set(0.3, 0.3);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					light.antialiasing = true;
					phillyCityLights.add(light);
				}
				var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic('assets/images/stages/week3/behindTrain.png');
				add(streetBehind);
	
				phillyTrain = new FlxSprite(2000, 360).loadGraphic('assets/images/stages/week3/train.png');
				add(phillyTrain);
	
				trainSound = new FlxSound().loadEmbedded('assets/sounds/train_passes' + TitleState.soundExt);
				FlxG.sound.list.add(trainSound);
	
				var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic('assets/images/stages/week3/street.png');
				add(street);
			}

		gf = new Character(400, 130, SONG.player3);
		gf.scrollFactor.set(0.95, 0.95);
		gf.antialiasing = true;
		add(gf);

		dad = new Character(100, 100, SONG.player2);
		add(dad);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
		}

		boyfriend = new Boyfriend(770, 450, SONG.player1);
		add(boyfriend);

		var doof:DialogueBox = new DialogueBox(false, dialogue);
		doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		//add (doof);
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<FlxSprite>();

		startingSong = true;
		
		generateSong(SONG.song);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);
		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		FlxG.camera.zoom = 1.05;

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic('assets/images/ui/healthBar.png');
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(dad.hpColor, boyfriend.hpColor); //0xFFFF0000, 0xFF66FF33);
		add(healthBar);
		
		infoTxt = new FlxText(healthBarBG.x + healthBarBG.width - 675, healthBarBG.y + 45, 0, "", 20);
		infoTxt.setFormat("assets/fonts/vcr.ttf", 22, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		//infoTxt.screenCenter();
		infoTxt.scrollFactor.set();

		missTxt = new FlxText(healthBarBG.x + healthBarBG.width - 600, healthBarBG.y + 45, 0, "", 20);
		missTxt.setFormat("assets/fonts/vcr.ttf", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		missTxt.scrollFactor.set();

		accuracyTxt = new FlxText(healthBarBG.x + healthBarBG.width - 600, healthBarBG.y + 45, 0, "", 20);
		accuracyTxt.setFormat("assets/fonts/vcr.ttf", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		accuracyTxt.scrollFactor.set();

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width - 600, healthBarBG.y + 45, 0, "", 20);
		scoreTxt.setFormat("assets/fonts/vcr.ttf", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();

		missTxt = new FlxText(healthBarBG.x + healthBarBG.width - 600, healthBarBG.y + 45, 0, "", 20);
		missTxt.setFormat("assets/fonts/vcr.ttf", 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		missTxt.scrollFactor.set();

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];

		startCountdown();

		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();

		var noteSplash:NoteSplash = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(noteSplash);
		noteSplash.alpha = 0.1;

		add(grpNoteSplashes);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		doof.cameras = [camHUD];
		infoTxt.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];

		var engineWatermark = new FlxText(5, FlxG.height - 18, 0, "", 12);
		engineWatermark.scrollFactor.set();
		engineWatermark.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		engineWatermark.cameras = [camHUD];
		engineWatermark.text = "Mega Engine v0.3.2";

		var songWatermark = new FlxText(5, FlxG.height - 34, 0, "", 12);
		songWatermark.scrollFactor.set();
		songWatermark.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		songWatermark.cameras = [camHUD];
		songWatermark.text = 'Song: ' + '${curSong}';

		if (ClientPrefs.getOption('showInfoText')){
			add(infoTxt);
		}

		if (ClientPrefs.getOption('MegaEngineWatermarks') == true)
			add(engineWatermark);
			add(songWatermark);

		super.create();
	}

	var startTimer:FlxTimer;

	function startCountdown():Void
	{
		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		var swagCounter:Int = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle');

			switch (swagCounter)
			{
				case 0:
					FlxG.sound.play('assets/sounds/intro3' + TitleState.soundExt, 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic('assets/images/ui/ready.png');
					ready.scrollFactor.set();
					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play('assets/sounds/intro2' + TitleState.soundExt, 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic('assets/images/ui/set.png');
					set.scrollFactor.set();
					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play('assets/sounds/intro1' + TitleState.soundExt, 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic('assets/images/ui/go.png');
					go.scrollFactor.set();
					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play('assets/sounds/introGo' + TitleState.soundExt, 0.6);
				case 4:
			}		
			swagCounter += 1;
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		startingSong = false;
		FlxG.sound.playMusic("assets/songs/" + SONG.song.toLowerCase() + "/Inst" + TitleState.soundExt, 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
		{	
			var songData = SONG;
			Conductor.changeBPM(songData.bpm);
	
			curSong = songData.song;
	
			if (SONG.needsVoices)
				vocals = new FlxSound().loadEmbedded("assets/songs/" + SONG.song.toLowerCase() + "/Voices" + TitleState.soundExt);
			else
				vocals = new FlxSound();
	
			FlxG.sound.list.add(vocals);

			vocals.onComplete = function()
				{
					vocalsFinished = true;
				};

			notes = new FlxTypedGroup<Note>();
			add(notes);
	
			var noteData:Array<SwagSection>;
	
			noteData = songData.notes;
	
			var daBeats:Int = 0;
			for (section in noteData)
			{
				var coolSection:Int = Std.int(section.lengthInSteps / 4);
	
				for (songNotes in section.sectionNotes)
				{
					var daStrumTime:Float = songNotes[0];
					var daNoteData:Int = Std.int(songNotes[1] % 4);
	
					var gottaHitNote:Bool = section.mustHitSection;
	
					if (songNotes[1] > 3)
					{
						gottaHitNote = !section.mustHitSection;
					}
	
					var oldNote:Note;
					if (unspawnNotes.length > 0)
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
					else
						oldNote = null;
	
					var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
					swagNote.sustainLength = songNotes[2];
					swagNote.scrollFactor.set(0, 0);
	
					var susLength:Float = swagNote.sustainLength;
	
					susLength = susLength / Conductor.stepCrochet;
					unspawnNotes.push(swagNote);
	
					for (susNote in 0...Math.floor(susLength))
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
	
						var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true);
						sustainNote.scrollFactor.set();
						unspawnNotes.push(sustainNote);
	
						sustainNote.mustPress = gottaHitNote;
	
						if (sustainNote.mustPress)
						{
							sustainNote.x += FlxG.width / 2; // general offset
						}
					}
	
					swagNote.mustPress = gottaHitNote;
	
					if (swagNote.mustPress)
					{
						swagNote.x += FlxG.width / 2; // general offset
					}
					else
					{
					}
				}
				daBeats += 1;
			}	
			unspawnNotes.sort(sortByShit);
	
			generatedMusic = true;
		}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);
			var arrTex = FlxAtlasFrames.fromSparrow('assets/images/ui/NOTE_assets.png', 'assets/images/ui/NOTE_assets.xml');
			babyArrow.frames = arrTex;
			babyArrow.animation.addByPrefix('green', 'arrowUP');
			babyArrow.animation.addByPrefix('blue', 'arrowDOWN');
			babyArrow.animation.addByPrefix('purple', 'arrowLEFT');
			babyArrow.animation.addByPrefix('red', 'arrowRIGHT');

			babyArrow.scrollFactor.set();
			babyArrow.setGraphicSize(Std.int(babyArrow.width * 0.7));
			babyArrow.updateHitbox();
			babyArrow.antialiasing = true;

			babyArrow.y -= 10;
			babyArrow.alpha = 0;
			FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});

			babyArrow.ID = i;

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}

			switch (Math.abs(i))
			{
				case 2:
					babyArrow.x += Note.swagWidth * 2;
					babyArrow.animation.addByPrefix('static', 'arrowUP');
					babyArrow.animation.addByPrefix('pressed', 'up press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'up confirm', 24, false);
				case 3:
					babyArrow.x += Note.swagWidth * 3;
					babyArrow.animation.addByPrefix('static', 'arrowRIGHT');
					babyArrow.animation.addByPrefix('pressed', 'right press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'right confirm', 24, false);
				case 1:
					babyArrow.x += Note.swagWidth * 1;
					babyArrow.animation.addByPrefix('static', 'arrowDOWN');
					babyArrow.animation.addByPrefix('pressed', 'down press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'down confirm', 24, false);
				case 0:
					babyArrow.x += Note.swagWidth * 0;
					babyArrow.animation.addByPrefix('static', 'arrowLEFT');
					babyArrow.animation.addByPrefix('pressed', 'left press', 24, false);
					babyArrow.animation.addByPrefix('confirm', 'left confirm', 24, false);
			}

			babyArrow.animation.play('static');
			babyArrow.x += 50;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
		}
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.play();
				Conductor.songPosition = FlxG.sound.music.time;
				vocals.time = Conductor.songPosition;
				vocals.play();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;
		}

		super.closeSubState();
	}

	function resyncVocals():Void
		{
			if (_exiting)
				return;
	
			vocals.pause();
			FlxG.sound.music.play();
			Conductor.songPosition = FlxG.sound.music.time + Conductor.offset;
	
			if (vocalsFinished)
				return;
	
			vocals.time = Conductor.songPosition;
			vocals.play();
		}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

		override public function update(elapsed:Float)
		{
			recalculateAccuracy();
						
		super.update(elapsed);
		
		var ratingArray:Array<Dynamic> = [
			[99.95, "[S++]", 0xFFFFD700],
			[99.5, "[S+]", 0xFF8D3D8D],
			[99, "[S]", 0xFF00FFFF],
			[95, "[A+]", 0xFF31CD31],
			[90, "[A]", 0xFF00FF00],
			[85, "[B+]", 0xFFFBC898],
			[80, "[B]", 0xFFFF8000],
			[75, "[C+]", 0xFFFA5D5D],
			[70, "[C]", 0xFFFFFFFF],
			[0, "[D]", 0xFFFFFFFF],
		  ];
		  
		  for (thing in ratingArray) {
			if (songAccuracy >= thing[0]) {
			  ratingTxt = thing[1];
			  ratingColor = thing[2];
			  break;
			}
		  }

		infoTxt.text = "Score: " + songScore + " || " + "Accuracy: " + songAccuracy + "% " +  ratingTxt + " || " + "Combo: " + comboScore + " || " + "Misses: " + misses;

		comboScore = combo;

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new ChartingState());
		}

		if (FlxG.keys.justPressed.NINE)
			{
				if (iconP1.animation.curAnim.name == 'bf-old')
					iconP1.animation.play(SONG.player1);
				else
					iconP1.animation.play('bf-old');
			}

			switch (curStage)
			{
				case 'philly':
					if (trainMoving)
					{
						trainFrameTiming += elapsed;
	
						if (trainFrameTiming >= 1 / 24)
						{
							updateTrainPos();
							trainFrameTiming = 0;
						}
					}
			}

			iconP1.scale.set(FlxMath.lerp(iconP1.scale.x, 1, elapsed * 9), FlxMath.lerp(iconP1.scale.y, 1, elapsed * 9));
			iconP2.scale.set(FlxMath.lerp(iconP2.scale.x, 1, elapsed * 9), FlxMath.lerp(iconP2.scale.y, 1, elapsed * 9));
			
			iconP1.updateHitbox();
			iconP2.updateHitbox();
	
			var iconOffset:Int = 26;
	
			iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
			iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
	
			if (health > 2)
				health = 2;
	
			if (healthBar.percent < 20)
				iconP1.animation.curAnim.curFrame = 1;
			else
				iconP1.animation.curAnim.curFrame = 0;
	
			if (healthBar.percent > 80)
				iconP2.animation.curAnim.curFrame = 1;
			else
				iconP2.animation.curAnim.curFrame = 0;

		#if debug
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(SONG.player2));
		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
				}
			}
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null)
		{
			if (camFollow.x != dad.getMidpoint().x + 150 && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
			{
				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn();
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && camFollow.x != boyfriend.getMidpoint().x - 100)
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(1.05, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", totalBeats);

		if (curSong == 'Fresh')
		{
			switch (totalBeats)
			{
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
			}
		}
		if (controls.RESET)
		{
			health = 0;
			trace("RESET = True");
		}

		if (health <= 0)
		{
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}

				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";

					if (SONG.notes[Math.floor(curStep / 16)] != null)
						{
							if (SONG.notes[Math.floor(curStep / 16)].altAnim)
								altAnim = '-alt';
						}

					switch (Math.abs(daNote.noteData))
					{
						case 2:
							dad.playAnim('singUP' + altAnim, true);
						case 3:
							dad.playAnim('singRIGHT' + altAnim, true);
						case 1:
							dad.playAnim('singDOWN' + altAnim, true);
						case 0:
							dad.playAnim('singLEFT' + altAnim, true);
					}

					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}

				daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				if (daNote.y < -daNote.height)
				{
					if (daNote.tooLate || !daNote.wasGoodHit)
					{
						health -= 0.045;
						vocals.volume = 0;
						misses += 1;
						allNotes++;
						combo = 0;
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}

		keyShit();
	}

	function endSong():Void
	{
		canPause = false;

		if (isStoryMode)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);

				FlxG.switchState(new StoryMenuState());

				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';

				trace('LOADING NEXT SONG');
				trace(PlayState.storyPlaylist[0].toLowerCase() + difficulty);

				PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
				FlxG.switchState(new PlayState());
			}
		}
		else
		{
			FlxG.switchState(new FreeplayState());
		}
	}

	var endingSong:Bool = false;

	private function popUpScore(strumtime:Float, daNote:Note):Void
		{
			var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
			vocals.volume = 1;
	
			var placement:String = Std.string(combo);
	
			var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
	
			var rating:FlxSprite = new FlxSprite();
			var score:Int = 350;
			var ratingMod:Float = 1;
	
			var daRating:String = "sick";
			var isSick:Bool = true;
	
			if (noteDiff > Conductor.safeZoneOffset * 0.9)
			{
				daRating = 'shit';
				score = 50;
				ratingMod = 0;
				isSick = false;
			}
			else if (noteDiff > Conductor.safeZoneOffset * 0.75)
			{
				daRating = 'bad';
				score = 100;
				ratingMod = 0.4;
				isSick = false;
			}
			else if (noteDiff > Conductor.safeZoneOffset * 0.275)
			{
				daRating = 'good';
				score = 200;
				ratingMod = 0.75;
				isSick = false;
			}

			if (isSick)
				{
					var noteSplash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
					noteSplash.setupNoteSplash(daNote.x, daNote.y, daNote.noteData);
					// new NoteSplash(note.x, daNote.y, daNote.noteData);
					grpNoteSplashes.add(noteSplash);
				}
			coolNoteFloat += ratingMod;

			songScore += score;
	
			var pixelShitPart1:String = "";
			var pixelShitPart2:String = '';
	
			if (curStage.startsWith('school'))
			{
				pixelShitPart1 = 'weeb/pixelUI/';
				pixelShitPart2 = '-pixel';
			}
	
			rating.loadGraphic('assets/images/ui/' + daRating + ".png");
			if (ClientPrefs.getOption('ratingColors') == true)
				rating.color = ratingColor;

			rating.screenCenter();
			rating.x = coolText.x - 40;
			rating.y -= 60;
			rating.acceleration.y = 550;
			rating.velocity.y -= FlxG.random.int(140, 175);
			rating.velocity.x -= FlxG.random.int(0, 10);
	
			var comboSpr:FlxSprite = new FlxSprite().loadGraphic('assets/images/ui/' + 'combo' + '.png');
			if (ClientPrefs.getOption('ratingColors') == true)
				comboSpr.color = ratingColor;
			comboSpr.screenCenter();
			comboSpr.x = coolText.x;
			comboSpr.acceleration.y = 600;
			comboSpr.velocity.y -= 150;

			if (ClientPrefs.getOption('ratingOnCam') == false)
				comboSpr.scrollFactor.set(1, 1);
			if (ClientPrefs.getOption('ratingOnCam') == true)
				comboSpr.scrollFactor.set(0, 0);			
	
			comboSpr.velocity.x += FlxG.random.int(1, 10);
			add(rating);
	
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = true;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;
			if (ClientPrefs.getOption('comboSplash')){	
				if (combo > 9) 
					add(comboSpr);
			}
			comboSpr.updateHitbox();
			rating.updateHitbox();
	
			if (ClientPrefs.getOption('ratingOnCam') == false)
				rating.scrollFactor.set(1, 1);
			if (ClientPrefs.getOption('ratingOnCam') == true)
				rating.scrollFactor.set(0, 0);	

			var seperatedScore:Array<Int> = [];
	
			seperatedScore.push(Math.floor(combo / 100));
			seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
			seperatedScore.push(combo % 10);
	
			var daLoop:Int = 0;
			for (i in seperatedScore)
			{
				var numScore:FlxSprite = new FlxSprite().loadGraphic('assets/images/ui/' + pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2 + '.png');
				if (ClientPrefs.getOption('ratingColors') == true)
					numScore.color = ratingColor;
				numScore.screenCenter();
				numScore.x = coolText.x + (43 * daLoop) - 90;
				numScore.y += 80;
				
				if (ClientPrefs.getOption('ratingOnCam') == false)
					numScore.scrollFactor.set(1, 1);
				if (ClientPrefs.getOption('ratingOnCam') == true)
					numScore.scrollFactor.set(0, 0);	

				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));

				numScore.updateHitbox();
	
				numScore.acceleration.y = FlxG.random.int(200, 300);
				numScore.velocity.y -= FlxG.random.int(140, 160);
				numScore.velocity.x = FlxG.random.float(-5, 5);
	
				if (combo >= 10 || combo == 0)
					add(numScore);
	
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.destroy();
					},
					startDelay: Conductor.crochet * 0.002
				});
	
				daLoop++;
			}
	
			coolText.text = Std.string(seperatedScore);
	
			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				startDelay: Conductor.crochet * 0.001
			});
	
			FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					coolText.destroy();
					comboSpr.destroy();
	
					rating.destroy();
				},
				startDelay: Conductor.crochet * 0.001
			});
	
			curSection += 1;
		}

		private function keyShit():Void
			{
				// HOLDING
				var up = controls.UP;
				var right = controls.RIGHT;
				var down = controls.DOWN;
				var left = controls.LEFT;
		
				var upP = controls.UP_P;
				var rightP = controls.RIGHT_P;
				var downP = controls.DOWN_P;
				var leftP = controls.LEFT_P;
		
				var upR = controls.UP_R;
				var rightR = controls.RIGHT_R;
				var downR = controls.DOWN_R;
				var leftR = controls.LEFT_R;
		
				var heldControlArray:Array<Bool> = [left, down, up, right];
				var controlArray:Array<Bool> = [leftP, downP, upP, rightP];
		
				if (heldControlArray.indexOf(true) != -1 && generatedMusic)
				{
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && heldControlArray[daNote.noteData])
						{
							goodNoteHit(daNote);
						}
					});
				};
		
				if (controlArray.indexOf(true) != -1 && generatedMusic) {
					boyfriend.holdTimer = 0;
		
					var pressedNotes:Array<Note> = [];
					var noteDatas:Array<Int> = [];
					var epicNotes:Array<Note> = [];
					notes.forEachAlive(function(daNote:Note)
					{
						if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
						{
							if (noteDatas.indexOf(daNote.noteData) != -1)
							{
								for (i in 0...pressedNotes.length)
								{
									var note:Note = pressedNotes[i];
									if (note.noteData == daNote.noteData && Math.abs(daNote.strumTime - note.strumTime) < 10)
									{
										epicNotes.push(daNote);
										break;
									} else if (note.noteData == daNote.noteData && note.strumTime > daNote.strumTime){
										pressedNotes.remove(note);
										pressedNotes.push(daNote);
										break;
									}
								}
							}else{
								pressedNotes.push(daNote);
								noteDatas.push(daNote.noteData);
							}
						}
					});
					for (i in 0...epicNotes.length) {
						var note:Note = epicNotes[i];
						note.kill();
						notes.remove(note);
						note.destroy();
					}
		
					if (pressedNotes.length > 0)
						pressedNotes.sort(sortByShit);
		
					if (perfectMode){
						goodNoteHit(pressedNotes[0]);
					}else if (pressedNotes.length > 0){
						for (i in 0...controlArray.length) {
							if (controlArray[i] && noteDatas.indexOf(i) == -1) {
								badNoteCheck();
							}
						}
						for (i in 0...pressedNotes.length) {
							var note:Note = pressedNotes[i];
							if (controlArray[note.noteData]) {
								goodNoteHit(note);
							}
						}
					}else{
						badNoteCheck(); //turn this back to BadNoteHit if no work
					}
				};
		
				if (boyfriend.holdTimer > 0.004 * Conductor.stepCrochet && heldControlArray.indexOf(true) == -1)
				{
					if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
					{
						boyfriend.playAnim('idle');
					}
				}
		
				playerStrums.forEach(function(spr:FlxSprite)
				{
					if (controlArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
					{
						spr.animation.play('pressed');
					}
					if (!heldControlArray[spr.ID])
					{
						spr.animation.play('static');
					}
					if (spr.animation.curAnim.name != 'confirm' || curStage.startsWith('school')) {
						spr.centerOffsets();
					} else {
						spr.centerOffsets();
						var d = spr.offset;
						d.set(d.x - 13, d.y - 13);
					}
				});
			}

	function noteMiss(direction:Int = 1):Void
	{
		if (!boyfriend.stunned)
		{
			health -= 0.035;
			if (combo > 5)
			{
				gf.playAnim('sad');
			}
			combo = 0;

			songScore -= 10;

			FlxG.sound.play('assets/sounds/missnote' + FlxG.random.int(1, 3) + TitleState.soundExt, FlxG.random.float(0.1, 0.2));

			boyfriend.stunned = true;

			new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
			{
				boyfriend.stunned = false;
			});

			switch (direction)
			{
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
			}
			misses += 1;
		}
	}

	function badNoteCheck() {
		if (ClientPrefs.getOption('ghostTapping'))
			return;
		
		var pressedIndex:Int = [
			controls.LEFT,
			controls.UP,
			controls.DOWN,
			controls.RIGHT
		].indexOf(true);
		if (pressedIndex != -1)
			noteMiss(pressedIndex); // totally not ripped from Test Engine
	}

	function noteCheck(keyP:Bool, note:Note):Void
	{
		if (keyP)
			goodNoteHit(note);
		else
			badNoteCheck();
	}

	function goodNoteHit(note:Note):Void
	{
			if (!note.isSustainNote) {
				combo += 1;
				allNotes++;
				popUpScore(note.strumTime, note);
			}

			if (note.noteData >= 0)
				health += 0.023;
			else
				health += 0.004;

			switch (note.noteData) {
				case 0:
					boyfriend.playAnim('singLEFT', true);
				case 1:
					boyfriend.playAnim('singDOWN', true);
				case 2:
					boyfriend.playAnim('singUP', true);
				case 3:
					boyfriend.playAnim('singRIGHT', true);
			}

			playerStrums.forEach(function(spr:FlxSprite) {
				if (Math.abs(note.noteData) == spr.ID) {
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			note.kill();
			notes.remove(note, true);
			note.destroy();
		}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play('assets/sounds/thunder_' + FlxG.random.int(1, 2) + TitleState.soundExt);
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	override function stepHit()
	{
		super.stepHit();
		if (Math.abs(FlxG.sound.music.time - (Conductor.songPosition - Conductor.offset)) > 20
			|| (SONG.needsVoices && Math.abs(vocals.time - (Conductor.songPosition - Conductor.offset)) > 20))
		{
			resyncVocals();
		}
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	override function beatHit()
	{
		super.beatHit();

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			else
				Conductor.changeBPM(SONG.bpm);

			if (SONG.notes[Math.floor(curStep / 16)].mustHitSection)
				dad.dance();
		}
		iconP1.setGraphicSize(Std.int(iconP1.width + 30));
		iconP2.setGraphicSize(Std.int(iconP2.width + 30));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (camZooming && FlxG.camera.zoom < 1.35 && totalBeats % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (totalBeats % gfSpeed == 0)
		{
			if (gfCanDance == true)
				gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing"))
			boyfriend.playAnim('idle');

		if (totalBeats % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
			gf.playAnim('cheer', true);

			if (SONG.song == 'Tutorial' && dad.curCharacter == 'gf')
			{
				gf.playAnim('cheer', true);
			}
		}

		switch (curStage)
		{
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}
	}

	var curLight:Int = 0;
	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
		{
			trainMoving = true;
			if (!trainSound.playing)
				trainSound.play(true);
		}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
		{
			if (trainSound.time >= 4700)
			{
				startedMoving = true;
				gf.playAnim('hairBlow');
				gfCanDance = false;
			}
	
			if (startedMoving)
			{
				phillyTrain.x -= 400;
	
				if (phillyTrain.x < -2000 && !trainFinishing)
				{
					phillyTrain.x = -1150;
					trainCars -= 1;
	
					if (trainCars <= 0)
						trainFinishing = true;
				}
	
				if (phillyTrain.x < -4000 && trainFinishing)
					trainReset();
			}
		}

	function trainReset():Void
		{
			gf.playAnim('hairFall');
			phillyTrain.x = FlxG.width + 200;
			trainMoving = false;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
			var timer:FlxTimer = new FlxTimer().start(0.46, resetGFAnim);
		}
	var gfCanDance = true;

	function resetGFAnim(timer:FlxTimer):Void
		{
			gfCanDance = true;
		}

	function recalculateAccuracy(miss:Bool = false) // Thank you Mackery
	{
        if (miss)
            coolNoteFloat -= 1;
    
        //to make sure we don't divide by 0
        if (allNotes == 0)
            songAccuracy = 100;
        else
            songAccuracy = FlxMath.roundDecimal(Math.max(0, coolNoteFloat / allNotes * 100), 2);
	}
}