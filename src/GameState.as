package  
{
import adobe.utils.CustomActions;
import org.flixel.*;

/**
 * Game state.
 * @author Katie Chironis, Zizhuang Yang
 */
public class GameState extends FlxState
{
	// Bits representing color mode currently viewed.
	static public const ALL : uint = 0x7;
	static public const R : uint = 0x1;
	static public const G : uint = 0x2;
	static public const B : uint = 0x4;
	
	// This is static across the entire game state, which is not sustainable for multiplayer.
	// Will have to be either player-based or hackily have two color modes.
	static public var colorMode : uint = ALL;
	
	protected var players : FlxGroup;
	protected var _player1 : Player;
	protected var _p1Start : FlxPoint;
	
	[Embed(source = "img/goal.png")] protected var goalImg:Class;
	protected var goals : FlxGroup;
	protected var _goal : FlxSprite;
	
	protected var walls : FlxGroup;
	protected var hazards : FlxGroup;

	protected var _camera : CameraCue;
	
	override public function GameState()
	{
		_p1Start = new FlxPoint(400, 400);
		super();
	}
	
	override public function create() : void
	{		
		// Player init
		players = new FlxGroup();
		_player1 = new Player(_p1Start.x, _p1Start.y);
		players.add(_player1);
		add(players);
		
		// Camera init, follows player for no1
		_camera = new CameraCue(_player1, _p1Start);
		add(_camera);
		FlxG.follow(_camera, 9);
		
		// Goal init
		goals = new FlxGroup();
		_goal = new FlxSprite(550, 550);
		_goal.loadGraphic(goalImg, false, true, 50, 50);
		_goal.fixed = true;
		goals.add(_goal);
		add(goals);
		
		// Add some huge wall tiles. Here I find out that color goes alpha, red, green, blue.
		walls = new FlxGroup();
		var redWall : Wall = new Wall(500, 500, 50, 50, RGBSprite.R);
		var greenWall : Wall = new Wall(500, 550, 50, 50, RGBSprite.G);
		var blueWall : Wall = new Wall(500, 600, 50, 50, RGBSprite.B);
		walls.add(redWall);
		walls.add(greenWall);
		walls.add(blueWall);
		add(walls);
		
		hazards = new FlxGroup();
		var redSaw : BuzzSaw = new BuzzSaw(300, 400, RGBSprite.R);
		var greenSaw : BuzzSaw = new BuzzSaw(400, 500, RGBSprite.G);
		var blueSaw : BuzzSaw = new BuzzSaw(400, 300, RGBSprite.B);
		hazards.add(redSaw);
		hazards.add(greenSaw);
		hazards.add(blueSaw);
		add(hazards);
	}
	
	
	override public function update():void
	{
		super.update();
		
		// First process anything that might happen when a player touches something. 
		FlxU.overlap(players, goals, acquire_goal);
		FlxU.overlap(players, hazards, process_hazard);
		
		// Make sure players can't go through walls.
		FlxU.collide(players, walls);
		
		handle_input();
	}
	
	protected function handle_input()
	{
		if (FlxG.keys.justPressed('Q')) // print out cursor location
		{
			trace("X: " + FlxG.mouse.x + " Y: " + FlxG.mouse.y);
		}
		if (FlxG.keys.justPressed('Z')) // color mode switches
		{
			colorMode = ALL;
		}
		if (FlxG.keys.justPressed('X'))
		{
			colorMode = R;
		}
		if (FlxG.keys.justPressed('C'))
		{
			colorMode = G;
		}
		if (FlxG.keys.justPressed('V'))
		{
			colorMode = B;
		}
	}
	
	protected function acquire_goal(a : FlxObject, b : FlxObject):void
	{
		if (a is Player)
		{
			trace("Yeeeah goal get!");
		}
	}
	
	// Hazards do less damage than traps.
	protected function process_hazard(a : FlxObject, b : FlxObject):void
	{
		if (a is Player)
		{
			Player(a).hurt(1);
		} else if (b is Player)
		{
			Player(b).hurt(1);
		}
	}
}
}