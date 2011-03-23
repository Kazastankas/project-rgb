package 
{
import org.flixel.*;

// Flash file setting silliness.
[SWF(width="800", height="600", backgroundColor="#000000")]
[Frame(factoryClass="Preloader")]

/**
 * Obligatory Main.as file.
 * @author Katie Chironis, Zizhuang Yang
 */
public class Main extends FlxGame
{
	public function Main()
	{
		super(800, 600, MenuState);
	}
}	
}