package  
{
import org.flixel.*;

/**
 * Base class for impassable walls.
 * @author Katie Chironis, Zizhuang Yang
 */
public class BuzzSaw extends RGBSprite
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