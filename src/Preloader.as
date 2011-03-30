package
{
import org.flixel.*;

/**
 * Preloader hook into the game.
 * @author Katie Chironis, Zizhuang Yang
 */
public class Preloader extends FlxPreloader
{
	public function Preloader()
	{
		className = "Main";
		super();
	}
}
}