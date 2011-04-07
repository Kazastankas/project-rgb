package  
{
import org.flixel.*;

/**
 * Base class for traps, which are player-owned.
 * @author Katie Chironis, Zizhuang Yang
 */
public class Trap extends RGBSprite
{	
	protected var armed : Boolean;
	
	public function Trap(X : int, Y : int, group : uint) 
	{
		armed = false;
		super(X, Y, group);
	}
	
	public function isArmed():Boolean
	{
		return armed;
	}
}

}