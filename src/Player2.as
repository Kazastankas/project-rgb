package  
{
import org.flixel.*;

/**
 * Player one class.
 * @author Katie Chironis, Zizhuang Yang
 */
public class Player2 extends Player
{
	[Embed(source="img/player2.png")] public var playerSprite:Class;
	
	public function Player2(x : int, y : int) 
	{
		super(x, y);
		loadGraphic(playerSprite, true, true);
		
		// Animation details go here.
		addAnimation("idle", [0, 1, 2, 3], 5, true);
		play("idle");
	}
	
	override public function create(x : int, y : int):void
	{
		super.create(x, y);
	}
	
	override public function hurt(damage : Number):void
	{
		super.hurt(damage);
	}
	
	override public function update():void
	{
		// Physics value resets.
		acceleration.x = 0;
		acceleration.y = 0;
		maxVelocity.x = landVelocity.x;
		maxVelocity.y = landVelocity.y;
		
		// Process input for movement.
		if (FlxG.keys.A)
		{
			facing = LEFT;
			acceleration.x -= drag.x;
		}
		else if (FlxG.keys.D)
		{
			facing = RIGHT;
			acceleration.x += drag.x;
		}
		
		if (FlxG.keys.W)
		{
			facing = UP;
			acceleration.y -= drag.y;
		}
		else if (FlxG.keys.S)
		{
			facing = DOWN;
			acceleration.y += drag.y;
		}
		
		super.update();
	}
}

}