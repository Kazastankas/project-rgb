package  
{
import org.flixel.*;
/**
 * Handles the camera following an object.
 * @author Katie Chironis, Zizhuang Yang
 */
public class CameraCue extends FlxObject
{
	protected var target : FlxObject;
	protected var defaultPos : FlxPoint;
	
	public function CameraCue(target : FlxObject, defaultPos : FlxPoint) 
	{
		this.target = target;
		this.defaultPos = defaultPos;
	}
	
	override public function update():void
	{
		// Currently just centers itself on the target's location.
		this.x = target.x;
		this.y = target.y;
	}
}
}