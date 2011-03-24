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

	protected var _camera : CameraCue;
	
	override public function GameState()
	{
		_p1Start = new FlxPoint(0, 0);
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
		_goal = new FlxSprite(150, 150);
		_goal.loadGraphic(goalImg, false, true, 50, 50);
		_goal.fixed = true;
		goals.add(_goal);
		add(goals);
		
		// Add some huge wall tiles.
		walls = new FlxGroup();
		var redWall : WallTile = new WallTile(100, 100, 50, 50, RGBSprite.R, 0xffff0000);
		var greenWall : WallTile = new WallTile(100, 150, 50, 50, RGBSprite.G, 0xff00ff00);
		var blueWall : WallTile = new WallTile(100, 200, 50, 50, RGBSprite.B, 0xff0000ff);
		walls.add(redWall);
		walls.add(greenWall);
		walls.add(blueWall);
		add(walls);
	}
	
	
	override public function update():void
	{
		super.update();
		
		// First process anything that might happen when a player touches a goal. 
		FlxU.overlap(players, goals, acquire_goal);
		
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
}
}