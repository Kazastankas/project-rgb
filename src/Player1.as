package  
{
import org.flixel.*;

/**
 * Player one class.
 * @author Katie Chironis, Zizhuang Yang
 */
public class Player1 extends Player
{
	[Embed(source="img/player1.png")] public var playerSprite:Class;
	
	public function Player1(x : int, y : int) 
	{
		super(x, y);
		loadGraphic(playerSprite, true, true);
		
		// Size variables.
		width = 40;
		height = 40;
		
		// Mechanical details.
		allegiance = 1;
		
		// Animation details go here.
		addAnimation("idle", [0, 1, 2, 3], 5, true);
		addAnimation("armed", [4, 5, 6, 7], 5, true);
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
	
	override public function getTrap():Boolean
	{
		var ret : Boolean = super.getTrap();
		if (hasTrap) {
			play("armed");
		}
		return ret;
	}
	
	override public function useTrap():Boolean
	{
		var ret : Boolean = super.useTrap();
		if (!hasTrap) {
			play("idle");
		}
		return ret;
	}
	
	override public function update():void
	{
		// Physics value resets.
		velocity.x = 0;
		velocity.y = 0;
		maxVelocity.x = runSpeed;
		maxVelocity.y = runSpeed;
		
		// Process input for movement.
		if (FlxG.keys.A)
		{
			facing = LEFT;
			velocity.x -= drag.x * 0.4;
		}
		else if (FlxG.keys.D)
		{
			facing = RIGHT;
			velocity.x += drag.x * 0.4;
		}
		
		if (FlxG.keys.W)
		{
			facing = UP;
			velocity.y -= drag.y * 0.4;
		}
		else if (FlxG.keys.S)
		{
			facing = DOWN;
			velocity.y += drag.y * 0.4;
		}
		
		super.update();
	}
}

}