package  
{
import org.flixel.*;

/**
 * Base class for player traps.
 * @author Katie Chironis, Zizhuang Yang
 */
public class PlayerTrap extends Trap
{
	[Embed(source = "img/player_trap_spike.png")] public var trapSprite : Class;
	protected var armingTimer : Number;
	
	public function PlayerTrap(X : int, Y : int, group : uint) 
	{
		super(X, Y, group);
		fixed = true;
		armingTimer = 0;
		loadGraphic(trapSprite, true, true);
	}
	
	public function create(x : int, y : int, group : uint):void
	{
		setSpriteGroup(group);
		armed = false;
		armingTimer = 2;
		reset(x, y);
	}
	
	override public function update():void
	{
		if (!armed && armingTimer > 0.0) {
			armingTimer -= FlxG.elapsed;
			if (armingTimer <= 0.0) {
				armed = true;
			}
		}
		
		super.update();
	}
}

}