package  
{
import org.flixel.*;

/**
 * Player base class.
 * @author Katie Chironis, Zizhuang Yang
 */
public class Player extends FlxSprite
{
	protected var runSpeed : Number = 200;
	protected var invincibilityTimer : Number = 0;
	
	public function Player(x : int, y : int) 
	{
		super(x, y);
		
		// Arbitrary physics constants, perhaps to be tweaked later!
		drag.x = runSpeed * 2;
		drag.y = runSpeed * 2;
		maxVelocity.x = runSpeed;
		maxVelocity.y = runSpeed;
		
		// Mechanics stuff go here.
		health = 6;
	}
	
	public function create(x : int, y : int):void
	{
		velocity.x = velocity.y = 0;
		health = 6;
		color = 0xFFFFFF;
		reset(x, y);
	}
	
	override public function hurt(damage : Number):void
	{
		if (invincibilityTimer <= 0.0) {
			super.hurt(damage);
			invincibilityTimer = 1.0;
		}
	}
	
	override public function update():void
	{		
		// Deal with ticking invincibility.
		if (invincibilityTimer > 0.0) {
			invincibilityTimer -= FlxG.elapsed;
			
			// Cap off the minimum.
			if (invincibilityTimer <= 0.0) {
				invincibilityTimer = 0.0;
			}
			
			// Have a little flashing effect.
			if (Math.floor(invincibilityTimer * 6) % 2 == 1) {
				alpha = 0.0;
			} else {
				alpha = 1.0;
			}
		}
		
		super.update();
	}
}

}