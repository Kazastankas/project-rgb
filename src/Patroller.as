package  
{
import org.flixel.*;
import org.flixel.data.FlxList;

/**
 * Base class for patrolling hazards.
 * @author Katie Chironis, Zizhuang Yang
 */
public class Patroller extends MobileHazard
{	
	[Embed(source = "img/rgb_minetrap.png")] public var trapSprite:Class;
	protected var waypoints : Array;
	protected var currentIndex : uint;
	protected var rising : Boolean;
	
	public function Patroller(X : int, Y : int, speed : Number, group : uint) 
	{
		super(X, Y, speed, group);
		loadGraphic(trapSprite, true, true);
		waypoints = new Array();
		waypoints.push(new FlxPoint(X, Y));
		currentIndex = 0;
		rising = true;
	}
	
	public function addWaypoint(point : FlxPoint) : void
	{
		waypoints.push(point);
	}
	
	protected function advanceIndex() : void
	{
		if (rising) {
			if (currentIndex + 1 < waypoints.length) {
				currentIndex++;
			} else {
				rising = false;
				currentIndex--;
			}
		} else {
			if (currentIndex - 1 >= 0) {
				currentIndex--;
			} else {
				rising = true;
				currentIndex++;
			}
		}
	}
	
	override public function update() : void
	{
		// Physics resets.
		acceleration.x = 0;
		acceleration.y = 0;
		maxVelocity.x = moveSpeed;
		maxVelocity.y = moveSpeed;
		
		var target : FlxPoint = waypoints[currentIndex];	
		
		if (distance(target) < 1) {
			x = target.x;
			y = target.y;
			advanceIndex();
		} else {
			var accelVector : FlxPoint = new FlxPoint(target.x - x, target.y - y);
			var vecLength : Number = Math.sqrt(Math.pow(accelVector.x, 2) + Math.pow(accelVector.y, 2));
			accelVector.x /= vecLength;
			accelVector.y /= vecLength;
			
			acceleration.x = drag.x * accelVector.x;
			acceleration.y = drag.y * accelVector.y;
		}
		super.update();
	}
}

}