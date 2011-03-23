package  
{
import org.flixel.*;

/**
 * Player class.
 * @author Katie Chironis, Zizhuang Yang
 */
public class Player extends FlxSprite
{
	[Embed(source="img/metaknight.png")] public var playerSprite:Class;
	protected var runSpeed : Number = 100;
	protected var landVelocity : FlxPoint;
	
	public function Player(x : int, y : int) 
	{
		super(x, y);
		loadGraphic(playerSprite, true, true);
		
		// size-based variables
		width = 50;
		height = 50;
		
		// arbitrary physics constants to be tweaked later!
		drag.x = runSpeed * 2;
		drag.y = runSpeed * 2;
		offset.x = 0;
		offset.y = 0;
		landVelocity = new FlxPoint(runSpeed, 62 + Math.random() * 20);
		maxVelocity.x = landVelocity.x;
		maxVelocity.y = landVelocity.y;
		
		// mechanics
		health = 6;
		
		// animations
		addAnimation("idle", [0], 5, true);
		play("idle");
	}
	
	public function create(x : int, y : int):void
	{
		velocity.x = velocity.y = 0;
		health = 6;
		color = 0xFFFFFF;
		reset(x, y);
	}
	
	override public function update():void
	{
		// physics resets?
		acceleration.x = 0;
		acceleration.y = 0;
		maxVelocity.x = landVelocity.x;
		maxVelocity.y = landVelocity.y;
		
		if (FlxG.keys.LEFT)
		{
			facing = LEFT;
			acceleration.x -= drag.x;
		}
		else if (FlxG.keys.RIGHT)
		{
			facing = RIGHT;
			acceleration.x += drag.x;
		}
		
		if (FlxG.keys.UP)
		{
			facing = UP;
			acceleration.y -= drag.y;
		}
		else if (FlxG.keys.DOWN)
		{
			facing = DOWN;
			acceleration.y += drag.y;
		}
		
		super.update();
	}
}

}