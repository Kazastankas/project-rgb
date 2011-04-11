package  
{
import org.flixel.*;

/**
 * Scoreboard base class.
 * @author Katie Chironis, Zizhuang Yang
 */
public class Scoreboard extends FlxSprite
{
	[Embed(source = "img/base_score0.png")] public var score0:Class;
	[Embed(source = "img/base_score1.png")] public var score1:Class;
	[Embed(source = "img/base_score2.png")] public var score2:Class;
	[Embed(source = "img/base_score3.png")] public var score3:Class;
	
	static private const animationTime : Number = 0.5;
	
	protected var baseLocation : FlxPoint;
	protected var animationTimer : Number;
	protected var fadeState : Number;
	protected var value : Number;
	
	public function Scoreboard(x : int, y : int, startLocation : FlxPoint, score : Number) 
	{
		super(x, y);
		baseLocation = startLocation;
		animationTimer = 0;
		value = 0;
		fadeState = 0;
		changeScore(score);
		loadScore();
	}
	
	public function create():void
	{
		animationTimer = 0;
		value = 0;
		fadeState = 0;
		reset(baseLocation.x, baseLocation.y);
	}
	
	public function changeScore(newScore : Number):void
	{
		fadeState = 1;
		value = newScore;
		animationTimer = animationTime;
	}
	
	public function loadScore():void
	{
		switch (value) {
			case 0:
				loadGraphic(score0, false, false);
				break;
			case 1:
				loadGraphic(score1, false, false);
				break;
			case 2:
				loadGraphic(score2, false, false);
				break;
			case 3:
				loadGraphic(score3, false, false);
				break;
			default:
				loadGraphic(score0, false, false);
				break;
		}
	}
	
	override public function update():void
	{
		if (animationTimer > 0) {
			if (fadeState == 1) {
				animationTimer -= FlxG.elapsed;
				if (animationTimer < 0) {
					alpha = 0;
					loadScore();
					fadeState = 2;
					animationTimer = animationTime;
				} else {
					alpha = animationTimer / animationTime;
				}
			} else if (fadeState == 2) {
				animationTimer -= FlxG.elapsed;
				if (animationTimer < 0) {
					alpha = 1;
					fadeState = 0;
					animationTimer = 0;
				} else {
					alpha = 1 - (animationTimer / animationTime);
				}
			}
		}
		
		super.update();
	}
}

}