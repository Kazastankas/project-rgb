package  
{
import org.flixel.*;

/**
 * Dummy menu state, currently doesn't do anything and moves right along.
 * @author Katie Chironis, Zizhuang Yang
 */
public class MenuState extends FlxState
{
	override public function create() : void
	{
		super.create();
		FlxState.bgColor = 0xff999999;
		FlxG.flash.start(0xff000000, 1);
	}
	
	override public function update() : void
	{
		FlxG.fade.start(0x000000, 1, proceed);
		super.update();
	}
	
	
	public function proceed() : void
	{
		FlxG.state = new GameState();
	}
}
}