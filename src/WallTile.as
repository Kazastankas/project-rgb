package  
{
import org.flixel.*;

/**
 * Base class for impassable walls.
 * @author Katie Chironis, Zizhuang Yang
 */
public class WallTile extends RGBSprite
{
	public function WallTile(X : int, Y : int, width : uint, height : uint, group : uint, color : uint) 
	{
		super(X, Y, group);
		fixed = true;
		createGraphic(width, height, color);
	}
}

}