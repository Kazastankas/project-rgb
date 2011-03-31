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
	protected var colorMode : uint = 0;
	
	public function RGBSprite(X : int, Y : int, group : uint) 
	{
		super(X, Y);
		spriteGroup = group;
		alpha = 1.0;
		fadeIn = false;
		fadeOut = false;
		colorMode = 0;
		
		setTint();
	}
	
	override public function update() : void
	{
		// Figure out what colors to show given player proximity.
		updateColorMode();
			
		// If the game's color mode coincides with our group tagging and we aren't in, fade in.
		// Otherwise, fade out.
		if (alpha < 1.0 && (colorMode & spriteGroup) > 0) {
			alpha = Math.max(alpha, 0.1);
			fadeIn = true;
			fadeOut = false;
			setTint();
		} else if (alpha > 0.0 && (colorMode & spriteGroup) == 0) {
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
	
	protected function distance(point : FlxPoint) : Number
	{
		return Math.sqrt(Math.pow(point.x - x, 2) + Math.pow(point.y - y, 2));
	}
	
	protected function dist_coords(x1 : Number, y1 : Number) : Number
	{
		return Math.sqrt(Math.pow(x1 - x, 2) + Math.pow(y1 - y, 2));
	}
	
	protected function updateColorMode() : void
	{
		// Check distance from players.
		colorMode = 0;
		
		// making new poits
		if (dist_coords(GameState._player1.x, GameState._player1.y) < 200) {
			colorMode |= GameState._p1ColorMode;
		}
		if (dist_coords(GameState._player2.x, GameState._player2.y) < 200) {
			colorMode |= GameState._p2ColorMode;
		}
	}
	protected function setSpriteGroup(group : uint) : void
	{
		spriteGroup = group & 0x7;
	}
	
	protected function setTint() : void
	{
		switch (colorMode & spriteGroup) {
			case R:
				color = 0xb70909;
				break;
			case G:
				color = 0x6daa7e;
				break;
			case B:
				color = 0x3b5f7c;
				break;
			default:
				color = 0xffffff;
				break;
		}
	}
}
}