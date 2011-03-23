package  
{
import org.flixel.*;

/**
 * Game state.
 * @author Katie Chironis, Zizhuang Yang
 */
public class GameState extends FlxState
{
	protected var players : FlxGroup;
	protected var _player1 : Player;
	protected var _p1Start : FlxPoint;
	
	protected var goals : FlxGroup;
	protected var _goal : FlxSprite;
	protected var _goalPos : FlxPoint;
	
	//protected var _camera : Camera;
	
	// All objects that aren't the players or the goal is in one of these.
	protected var objsRed : FlxGroup;
	protected var objsGreen : FlxGroup;
	protected var objsBlue : FlxGroup;
	
	override public function GameState()
	{
		_p1Start = new FlxPoint(0, 0);
		_goalPos = new FlxPoint(50, 50);
		super();
	}
	
	override public function create() : void
	{
		players = new FlxGroup();
		_player1 = new Player(_p1Start.x, _p1Start.y);
		players.add(_player1);
		add(players);
		
		//_camera = new Camera(_player1, _p1Start);
		//add(_camera);
		//FlxG.follow(_player1, 1);
		
		goals = new FlxGroup();
		_goal = new FlxSprite(_goalPos.x + 38, _goalPos.y);
		// goal.loadGraphic(goalFrontImg, false, true, 42, 41);
		_goal.fixed = true;
		goals.add(_goal);
		add(goals);
		
		// Render groups, determines what is rendered when in a color mode.
		/* Not intended for collisions, because they can pretty much be anything - including
		 * non-colliding objects like bullets and traps. If we care about color-specified interactions,
		 * however, these could be used for overlaps. */
		objsRed = new FlxGroup();
		objsRed.add(_player1);
		objsRed.add(_goal);
		add(objsRed);
		
		objsGreen = new FlxGroup();
		objsGreen.add(_player1);
		objsGreen.add(_goal);
		add(objsGreen);
		
		objsBlue = new FlxGroup();
		objsBlue.add(_player1);
		objsBlue.add(_goal);
		add(objsBlue);
	}
	
	
	override public function update():void
	{
		super.update();
		FlxU.overlap(players, goals, acquire_goal);
		
		if (FlxG.keys.justPressed('Q'))
		{
			trace("X: " + FlxG.mouse.x + " Y: " + FlxG.mouse.y);
		}
	}
	
	protected function acquire_goal(a : FlxObject, b : FlxObject):void
	{
		if (a is Player)
		{
			trace("Yeeeah goal get!");
		}
	}
}
}