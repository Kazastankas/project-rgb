package  
{
import org.flixel.*;

/**
 * Base class for buzzsaw hazards.
 * @author Katie Chironis, Zizhuang Yang
 */
public class BuzzSaw extends StaticHazard
{
	[Embed(source = "img/rgb_hacksaw.png")] public var sawSprite:Class;
	
	public function BuzzSaw(X : int, Y : int, group : uint) 
	{
		super(X, Y, group);
		fixed = true;
		loadGraphic(sawSprite, true, true)
		
		// Size variables.
		width = 40;
		height = 40;
		offset.x = 5;
		offset.y = 5;
		
		// Animation details go here.
		addAnimation("idle", [0, 1, 2], 100, true);
		play("idle");
	}
}

}