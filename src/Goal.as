package  
{
import org.flixel.*;
import org.flixel.data.FlxPanel;

/**
 * Goal base class.
 * @author Katie Chironis, Zizhuang Yang
 */
public class Goal extends FlxSprite
{
	[Embed(source = "img/rgb_goal_obj1.png")] public var goalSprite:Class;
	
	protected var baseLocation : FlxPoint;
	protected var following : Boolean;
	protected var followedPlayer : Player;
	protected var allegiance : Number;
	
	protected var respawnTimer : Number;
	protected var isRespawning : Boolean;
	
	public function Goal(x : int, y : int, startLocation : FlxPoint, side : Number) 
	{
		super(x, y);
		loadGraphic(goalSprite, true, true)
		baseLocation = startLocation;
		following = false;
		followedPlayer = null;
		allegiance = side;
		respawnTimer = 0;
		isRespawning = false;
	}
	
	public function create():void
	{
		following = false;
		followedPlayer = null;
		respawnTimer = 0;
		isRespawning = false;
		reset(baseLocation.x, baseLocation.y);
	}
	
	public function isCaptured():Boolean
	{
		return following;
	}
	
	public function capture(captor : Player):void
	{
		following = true;
		followedPlayer = captor;
	}
	
	public function startRespawn():void
	{
		x = -100;
		y = -100;
		following = false;
		followedPlayer = null;
		respawnTimer = 2;
		isRespawning = true;
	}
	
	public function getAllegiance():Number
	{
		return allegiance;
	}
	
	override public function update():void
	{
		if (isRespawning && respawnTimer > 0) {
			respawnTimer -= FlxG.elapsed;
			if (respawnTimer < 0) {
				respawnTimer = 0;
				isRespawning = false;
				create();
			}
		}
		
		if (following) {
			x = followedPlayer.x;
			y = followedPlayer.y;
		}
		
		super.update();
	}
}

}