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
		
		setTint();
	}
	
	override public function update() : void
	{
		// Set the necessary tint.
			
		// If the game's color mode coincides with our group tagging and we aren't in, fade in.
		// Otherwise, fade out.
		if (alpha < 1.0 && (GameState.colorMode & spriteGroup) > 0) {
			alpha = Math.max(alpha, 0.1);
			fadeIn = true;
			fadeOut = false;
			setTint();
		} else if (alpha > 0.0 && (GameState.colorMode & spriteGroup) == 0) {
			fadeIn = false;
			fadeOut = true;
		}
		
		// Fade in multiplicatively until 'close enough' to the end, then snap to end.
		// Same with fading out. Fading in works because we jump straight to at least 0.1 when 
		// we start.
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
		
		// If we're alpha 1.0 here, then we haven't faded and thus would not change colors
		// if, say, the mode change to another mode that this object is still visible in.
		if (alpha == 1.0) {
			setTint();
		}
		
		super.update();
	}
	
	protected function setSpriteGroup(group : uint) : void
	{
		spriteGroup = group & 0x7;
	}
	
	protected function setTint() : void
	{
		switch (GameState.colorMode) {
			case R:
				color = 0xff0000;
				break;
			case G:
				color = 0x00ff00;
				break;
			case B:
				color = 0x0000ff;
				break;
			default:
				color = 0xffffff;
				break;
		}
	}
}
}