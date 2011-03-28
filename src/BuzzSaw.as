package  
{
import org.flixel.*;

/**
 * Base class for buzzsaw hazards.
 * @author Katie Chironis, Zizhuang Yang
 */
public class BuzzSaw extends StaticHazard
{
	[Embed(source = "img/buzzsaw.png")] public var sawSprite:Class;
	
	public function BuzzSaw(X : int, Y : int, group : uint) 
	{
		super(X, Y, group);
		fixed = true;
		loadGraphic(sawSprite, true, true);
	}
}

}