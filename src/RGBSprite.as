package  
{
import org.flixel.*;

/**
 * Base class for objects that are attached to specific colors.
 * @author Katie Chironis, Zizhuang Yang
 */
public class RGBSprite extends FlxSprite
{
	// Bits representing color group membership. Can apply bitwise OR to combine.
	static public const R : uint = 0x1;
	static public const G : uint = 0x2;
	static public const B : uint = 0x4;
	
	protected var spriteGroup : uint = 0;
	protected var fadeIn : Boolean;
	protected var fadeOut : Boolean;
	
	public function RGBSprite(X : int, Y : int, group : uint) 
	{
		super(X, Y);
		spriteGroup = group;
		alpha = 1.0;
		fadeIn = false;
		fadeOut = false;
	}
	
	override public function update():void
	{
		if (alpha < 1.0 && (GameState.colorMode & spriteGroup) > 0) {
			alpha = Math.max(alpha, 0.1);
			fadeIn = true;
			fadeOut = false;
		} else if (alpha > 0.0 && (GameState.colorMode & spriteGroup) == 0) {
			fadeIn = false;
			fadeOut = true;
		}
		
		if (alpha < 1.0 && fadeIn) {
			if (alpha > 0.9) {
				alpha = 1.0;
				fadeIn = false;
			} else {
				alpha *= 1.1;
			}
		} else if (alpha > 0.0 && fadeOut) {
			if (alpha < 0.1) {
				alpha = 0.0;
				fadeOut = false;
			} else {
				alpha *= 0.9;
			}
		}
		
		super.update();
	}
}
}