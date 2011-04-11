package  
{
import org.flixel.*;

/**
 * Base class for impassable walls.
 * @author Katie Chironis, Zizhuang Yang
 */
public class Wall extends RGBSprite
{
	public function Wall(X : int, Y : int, width : uint, height : uint, group : uint) 
	{
		super(X, Y, group);
		fixed = true;
		createGraphic(width, height, 0xffffffff);
	}
}

}