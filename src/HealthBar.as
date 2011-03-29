package  
{
import org.flixel.*;

/**
 * Base class for health bars.
 * @author Katie Chironis, Zizhuang Yang
 */
public class HealthBar extends FlxSprite
{
	// Offset constants.
	static private const yOffset : Number = -5;
	static private const xOffset : Number = 1;
	static private const barHeight : Number = 5;
	static private const barWidth : Number = 8;
	
	protected var parentPlayer : Player;
	
	public function HealthBar(player : Player) 
	{
		super(player.x + xOffset, player.y + yOffset);
		parentPlayer = player;
	}
	
	override public function update() : void
	{
		// Orient at correct location.
		x = parentPlayer.x + xOffset;
		y = parentPlayer.y + yOffset;
		
		// Determine color and width from player's life.
		var red : Number = 255 * (1 - parentPlayer.health / 6);
		var green : Number = 255 * (parentPlayer.health / 6);
		
		// Draw the lifebar.
		if (parentPlayer.health > 0)
		{
			createGraphic(barWidth * parentPlayer.health, barHeight,
		   				  0xff000000 | (red << 16) | (green << 8));
		} else { // All red for 'dead'.
			createGraphic(barWidth * 6, barHeight, 0xffff0000);
		}
	}
}

}