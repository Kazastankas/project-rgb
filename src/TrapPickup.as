package  
{
import org.flixel.*;

/**
 * Base class for trap pickups.
 * @author Katie Chironis, Zizhuang Yang
 */
public class TrapPickup extends FlxSprite
{
	[Embed(source = "img/player_trap_unplaced.png")] public var pickupSprite:Class;
	
	public function TrapPickup(X : int, Y : int) 
	{
		super(X, Y);
		fixed = true;
		loadGraphic(pickupSprite, true, true)
		
		// Size variables.
		width = 25;
		height = 25;
	}
}

}