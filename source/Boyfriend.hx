package;

using StringTools;

class Boyfriend extends Character
{
	public var stunned:Bool = false;

	public function new(x:Float, y:Float, ?char:String = 'bf')
	{
		super(x, y, char);
		flipX = !flipX;
	}

	override function update(elapsed:Float)
	{
		if (animation.curAnim.name.startsWith('sing'))
		{
			holdTimer += elapsed;
		}
		else

		if (animation.curAnim.name.endsWith('miss') && animation.curAnim.finished && !debugMode)
		{
			playAnim('idle', true, false, 10);
		}

		if (animation.curAnim.name == 'firstDeath' && animation.curAnim.finished)
		{
			playAnim('deathLoop');
		}

		super.update(elapsed);
	}
}
