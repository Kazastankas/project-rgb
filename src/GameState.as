package  
{
import adobe.utils.CustomActions;
import org.flixel.*;

/**
 * Game state. Important to note: Everything here is on a 50, 50 offset to have an outer wall.
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
	protected var _player1 : Player1;
	protected var _p1Life : HealthBar;
	protected var _p1Start : FlxPoint;
	
	protected var _player2 : Player2;
	protected var _p2Life : HealthBar;
	protected var _p2Start : FlxPoint;
	
	[Embed(source = "img/goal.png")] protected var goalImg:Class;
	protected var goals : FlxGroup;
	protected var _goal : FlxSprite;
	
	protected var walls : FlxGroup;
	
	protected var hazards : FlxGroup;
	protected var buzzsaws : FlxGroup;
	protected var patrollers : FlxGroup;
	
	protected var traps : FlxGroup;
	protected var playerTraps : FlxGroup;

	protected var _camera : CameraCue;
	
	override public function GameState()
	{
		_p1Start = new FlxPoint(50, 50);
		_p2Start = new FlxPoint(800, 600);
		super();
	}
	
	override public function create() : void
	{	
		var i : int;
		
		walls = new FlxGroup();
		// Outer walls.
		var northWall : Wall = new Wall(50, 30, 800, 20, RGBSprite.R | RGBSprite.G | RGBSprite.B);
		var westWall : Wall = new Wall(30, 30, 20, 640, RGBSprite.R | RGBSprite.G | RGBSprite.B);
		var eastWall : Wall = new Wall(850, 30, 20, 640, RGBSprite.R | RGBSprite.G | RGBSprite.B);
		var southWall : Wall = new Wall(50, 650, 800, 20, RGBSprite.R | RGBSprite.G | RGBSprite.B);
		walls.add(northWall);
		walls.add(westWall);
		walls.add(eastWall);
		walls.add(southWall);
		
		// Add some huge wall tiles. Here I find out that color goes alpha, red, green, blue.
		var redWall : Wall = new Wall(500, 500, 50, 50, RGBSprite.R);
		var greenWall : Wall = new Wall(500, 550, 50, 50, RGBSprite.G);
		var blueWall : Wall = new Wall(500, 600, 50, 50, RGBSprite.B);
		walls.add(redWall);
		walls.add(greenWall);
		walls.add(blueWall);
		add(walls);
		
		hazards = new FlxGroup();
		buzzsaws = new FlxGroup();
		var redSaw : BuzzSaw = new BuzzSaw(300, 400, RGBSprite.R);
		var greenSaw : BuzzSaw = new BuzzSaw(400, 500, RGBSprite.G);
		var blueSaw : BuzzSaw = new BuzzSaw(400, 300, RGBSprite.B);
		buzzsaws.add(redSaw);
		buzzsaws.add(greenSaw);
		buzzsaws.add(blueSaw);
		hazards.add(buzzsaws);
		
		patrollers = new FlxGroup();
		var redPatroller : Patroller = new Patroller(300, 300, 100, RGBSprite.R);
		redPatroller.addWaypoint(new FlxPoint(300, 500));
		var greenPatroller : Patroller = new Patroller(300, 500, 100, RGBSprite.G);
		greenPatroller.addWaypoint(new FlxPoint(500, 500));
		var bluePatroller : Patroller = new Patroller(300, 300, 100, RGBSprite.B);
		bluePatroller.addWaypoint(new FlxPoint(500, 300));
		patrollers.add(redPatroller);
		patrollers.add(greenPatroller);
		patrollers.add(bluePatroller);
		hazards.add(patrollers);
		add(hazards);
		
		traps = new FlxGroup();
		playerTraps = new FlxGroup();
		
		// Player traps off to the sides.
		for(i = 0; i < 64; i++)
		{
			var s : PlayerTrap = new PlayerTrap(-100, -100, RGBSprite.R);
			s.exists = false;
			playerTraps.add(s);
		}
		traps.add(playerTraps);
		add(traps);
		
		// Goal init
		goals = new FlxGroup();
		_goal = new FlxSprite(550, 550);
		_goal.loadGraphic(goalImg, false, true, 50, 50);
		_goal.fixed = true;
		goals.add(_goal);
		add(goals);
		
		// Player init
		players = new FlxGroup();
		_player1 = new Player1(_p1Start.x, _p1Start.y);
		_player2 = new Player2(_p2Start.x, _p2Start.y);
		players.add(_player1);
		players.add(_player2);
		add(players);
		
		_p1Life = new HealthBar(_player1);
		_p2Life = new HealthBar(_player2);
		add(_p1Life);
		add(_p2Life);
		
		// Camera init
		_camera = new CameraCue();
		add(_camera);
		FlxG.follow(_camera, 9);
	}
	
	
	override public function update():void
	{
		super.update();
		
		// First process anything that might happen when a player touches something. 
		FlxU.overlap(players, goals, acquire_goal);
		FlxU.overlap(players, hazards, process_hazard);
		FlxU.overlap(players, traps, process_trap);
		
		// Make sure players can't go through walls or other players.
		FlxU.collide(players, players);
		FlxU.collide(players, walls);
		
		handle_input();
	}
	
	protected function handle_input():void
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
		if (FlxG.keys.justPressed('E')) // Player 1 trap
		{
			var s1 : PlayerTrap;
			s1 = (playerTraps.getFirstAvail() as PlayerTrap);
			if (s1 != null)
			{
				s1.create(_player1.x, _player1.y, colorMode);
			}
		}
		if (FlxG.keys.justPressed('SLASH')) // Player 2 trap
		{
			var s2 : PlayerTrap;
			s2 = (playerTraps.getFirstAvail() as PlayerTrap);
			if (s2 != null)
			{
				s2.create(_player2.x, _player2.y, colorMode);
			}
		}
	}
	
	protected function acquire_goal(a : FlxObject, b : FlxObject):void
	{
		if (a is Player)
		{
			trace("Yeeeah goal get!");
		}
	}
	
	// Hazards do less damage than traps, but are persistent.
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
	
	protected function process_trap(a : FlxObject, b : FlxObject):void
	{
		if (a is Player && b is Trap && Trap(b).isArmed())
		{
			Player(a).hurt(3);
			b.kill();
		} else if (b is Player && a is Trap && Trap(a).isArmed())
		{
			Player(b).hurt(3);
			a.kill();
		}
	}
}
}