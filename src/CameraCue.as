package  
{
import org.flixel.*;
/**
 * Handles the camera following an object.
 * @author Katie Chironis, Zizhuang Yang
 */
public class CameraCue extends FlxObject
{
	protected var target : FlxPoint;
	
	public function CameraCue() 
	{
		this.target = new FlxPoint(FlxG.width / 2 + 50, FlxG.height / 2 + 50);
	}
	
	override public function update():void
	{
		// Currently just centers itself on the target's location.
		this.x = target.x;
		this.y = target.y;
	}
}
}