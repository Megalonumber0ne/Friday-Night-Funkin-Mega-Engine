package;

import handlers.Paths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			//case 'fading':
				//FlxG.sound.playMusic(Paths.music('city_ambience'), 0);
				//FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		if(PlayState.SONG.song.toLowerCase()=='senpai' || PlayState.SONG.song.toLowerCase()=='roses' || PlayState.SONG.song.toLowerCase()=='thorns' )
			box = new FlxSprite(-20, 45);
		else
			box = new FlxSprite(-20, 375);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'tutorial':
				hasDialog = true;
				
				box.frames = Paths.getSparrowAtlas('ui/speech_bubble_talking');
				box.animation.addByIndices('normal', 'speech bubble normal1', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], "", 24, true);
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);

			case 'bopeebo':
				hasDialog = true;
				
				box.frames = Paths.getSparrowAtlas('ui/speech_bubble_talking');
				box.animation.addByIndices('normal', 'speech bubble normal1', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], "", 24, true);
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);

			case 'fresh':
				hasDialog = true;
				
				box.frames = Paths.getSparrowAtlas('ui/speech_bubble_talking');
				box.animation.addByIndices('normal', 'speech bubble normal1', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], "", 24, true);
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);

			case 'dadbattle':
				hasDialog = true;
				
				box.frames = Paths.getSparrowAtlas('ui/speech_bubble_talking');
				box.animation.addByIndices('normal', 'speech bubble normal1', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19], "", 24, true);
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);				

			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('stages/week6/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('stages/week6/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('stages/week6/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('stages/week6/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		if(PlayState.SONG.song.toLowerCase()=='senpai' || PlayState.SONG.song.toLowerCase()=='roses' || PlayState.SONG.song.toLowerCase()=='thorns' )
		{
			portraitLeft = new FlxSprite(-20, 40);
			portraitLeft.frames = Paths.getSparrowAtlas('stages/week6/senpaiPortrait');
			portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * /*PlayState.daPixelZoom*/ 6  * 0.9));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			add(portraitLeft);
			portraitLeft.visible = false;
		}

		if(PlayState.SONG.song.toLowerCase()=='senpai' || PlayState.SONG.song.toLowerCase()=='roses' )
		{
			portraitRight = new FlxSprite(0, 40);
			portraitRight.frames = Paths.getSparrowAtlas('portraits/bfPortrait');
			portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
			portraitRight.setGraphicSize(Std.int(portraitRight.width * /*PlayState.daPixelZoom*/ 6  * 0.9));
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
			add(portraitRight);
			portraitRight.visible = false;
		}


		if(PlayState.SONG.song.toLowerCase()=='tutorial')
		{
			portraitLeft = new FlxSprite(100, 175);
			portraitLeft.frames = Paths.getSparrowAtlas('portraits/gfPortrait');
			portraitLeft.animation.addByPrefix('enter', 'GF portrait enter', 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 0.9)); ///*PlayState.daPixelZoom*/ 6  * 0.9));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			add(portraitLeft);
			portraitLeft.visible = false;
			portraitLeft.antialiasing = true;

			portraitRight = new FlxSprite(750, 185);
			portraitRight.frames = Paths.getSparrowAtlas('portraits/bfPortrait');
			portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
			portraitRight.setGraphicSize(Std.int(portraitRight.width * 0.9)); ///*PlayState.daPixelZoom*/ 6  * 0.9));
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
			add(portraitRight);
			portraitRight.visible = false;
			portraitRight.antialiasing = true;
		}
		if(PlayState.SONG.song.toLowerCase()=='bopeebo' || PlayState.SONG.song.toLowerCase()=='fresh' || PlayState.SONG.song.toLowerCase()=='dadbattle')
		{
			portraitRight = new FlxSprite(750, 185);
			portraitRight.frames = Paths.getSparrowAtlas('portraits/bfPortrait');
			portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
			portraitRight.setGraphicSize(Std.int(portraitRight.width * 0.9)); ///*PlayState.daPixelZoom*/ 6  * 0.9));
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
			add(portraitRight);
			portraitRight.visible = false;
			portraitRight.antialiasing = true;

			portraitLeft = new FlxSprite(100, 140);
			portraitLeft.frames = Paths.getSparrowAtlas('portraits/dadPortrait');
			portraitLeft.animation.addByPrefix('enter', 'Dad portrait enter', 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 0.9)); ///*PlayState.daPixelZoom*/ 6  * 0.9));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			add(portraitLeft);
			portraitLeft.visible = false;
			portraitLeft.antialiasing = true;
		}

		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * 0.9)); ///*PlayState.daPixelZoom*/ 6  * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('stages/week6/pixelUI/hand_textbox'));
		add(handSelect);
		
		if (PlayState.SONG.song.toLowerCase()=='bopeebo')
		{
			handSelect.antialiasing = true;
		}

		if (!talkingRight)
		{
			box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'assets/fonts/vcr.ttf';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'assets/fonts/vcr.ttf';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}
		else if (PlayState.SONG.song.toLowerCase() == 'bopeebo' || PlayState.SONG.song.toLowerCase() == 'fresh' || PlayState.SONG.song.toLowerCase() == 'dadbattle' || PlayState.SONG.song.toLowerCase() == 'tutorial')
			{
				swagDialogue.color = FlxColor.BLACK;
				dropText.color = FlxColor.BLACK;
			}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ENTER && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('Generic_Text'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns') //|| PlayState.SONG.song.toLowerCase() == 'fading' )
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();

		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'bf':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
					box.flipX = false;
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
