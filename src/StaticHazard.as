package  
{
import org.flixel.*;

/**
 * Base class for non-moving hazards.
 * @author Katie Chironis, Zizhuang Yang
 */
public class StaticHazard extends RGBSprite
{	
	public function StaticHazard(X : int, Y : int, group : uint) 
	{
		super(X, Y, group);
		fixed = true;
	}
}

}