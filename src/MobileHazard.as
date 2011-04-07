package  
{
import org.flixel.*;
import org.flixel.data.FlxList;

/**
 * Base class for mobile hazards.
 * @author Katie Chironis, Zizhuang Yang
 */
public class MobileHazard extends RGBSprite
{	
	protected var moveSpeed : Number;
	
	public function MobileHazard(X : int, Y : int, speed : Number, group : uint) 
	{
		super(X, Y, group);
		moveSpeed = speed;
		
		// Arbitrary physics constants, perhaps to be tweaked later!
		drag.x = moveSpeed * 2;
		drag.y = moveSpeed * 2;
		offset.x = 0;
		offset.y = 0;
		maxVelocity.x = moveSpeed;
		maxVelocity.y = moveSpeed;
	}
}

}