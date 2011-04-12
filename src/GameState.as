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
	[Embed(source = "img/base1.png")] protected var base1Sprite:Class;
	[Embed(source = "img/base2.png")] protected var base2Sprite:Class;
	[Embed(source = "img/keytemplate_player1.png")] protected var keys1Sprite:Class;
	[Embed(source = "img/keytemplate_player2.png")] protected var keys2Sprite:Class;
	
	[Embed(source = "sounds/loop.mp3")] protected var loopMusic:Class;
	[Embed(source = "sounds/score.mp3")] protected var scoreSound:Class;
	[Embed(source = "sounds/player_trap.mp3")] protected var playerTrapSound:Class;
	[Embed(source = "sounds/hazard.mp3")] protected var hazardSound:Class;
	
	// Bits representing color mode currently viewed.
	static public const ALL : uint = 0x7;
	static public const R : uint = 0x1;
	static public const G : uint = 0x2;
	static public const B : uint = 0x4;
	
	// This is static across the entire game state, which is not sustainable for multiplayer.
	// Will have to be either player-based or hackily have two color modes.
	static public var _p1ColorMode : uint = R;
	static public var _player1 : Player1;
	static public var _p2ColorMode : uint = R;
	static public var _player2 : Player2;
	
	// Other constants. Tweak as necessary.
	static public const cooldownTimer : Number = 0.5;
	static public const trapDamage : Number = 2;
	static public const hazardDamage : Number = 1;
	static public const winningScore : Number = 3;
	static public const respawnTime : Number = 1.5;
	
	protected var players : FlxGroup;
	protected var _p1Life : HealthBar;
	protected var _p1Start : FlxPoint;
	protected var _p1BaseLoc : FlxPoint;
	protected var _p1Base : FlxGroup;
	protected var _p1Scoreboard : Scoreboard;
	protected var _p1RespawnTimer : Number = 0;
	protected var _p1Score : Number = 0;
	protected var _p1Cooldown : Number = 0;
	
	protected var _p2Life : HealthBar;
	protected var _p2Start : FlxPoint;
	protected var _p2BaseLoc : FlxPoint;
	protected var _p2Base : FlxGroup;
	protected var _p2Scoreboard : Scoreboard;
	protected var _p2RespawnTimer : Number = 0;
	protected var _p2Score : Number = 0;
	protected var _p2Cooldown : Number = 0;
	
	protected var walls : FlxGroup;
	protected var goals : FlxGroup;
	
	protected var hazards : FlxGroup;
	protected var buzzsaws : FlxGroup;
	protected var patrollers : FlxGroup;
	
	protected var traps : FlxGroup;
	protected var playerTraps : FlxGroup;
	protected var trapPickups : FlxGroup;

	protected var _camera : CameraCue;
	protected var _transitioning : Boolean = false;
	
	override public function GameState()
	{
		_p1Start = new FlxPoint(1, 1);
		_p1BaseLoc = new FlxPoint(0, 0);
		_p2Start = new FlxPoint(750, 550);
		_p2BaseLoc = new FlxPoint(725, 525);
		_p1ColorMode = R;
		_p2ColorMode = R;
		super();
	}
	
	override public function create() : void
	{	
		var i : int;
		var j : int;
		
		FlxG.playMusic(loopMusic, 0.2);
			
		walls = new FlxGroup();
		generateOuterWalls();
		generateRedWalls();
		generateGreenWalls();
		generateBlueWalls();
		add(walls);
		
		hazards = new FlxGroup();
		buzzsaws = new FlxGroup();
		generateBuzzsaws();
		hazards.add(buzzsaws);
		patrollers = new FlxGroup();
		generatePatrollers();
		hazards.add(patrollers);
		add(hazards);
		
		trapPickups = new FlxGroup();
		generateTrapPickups();
		add(trapPickups);
		
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
		
		// Bases init
		_p1Base = new FlxGroup();
		var p1_base : FlxSprite = new FlxSprite(_p1BaseLoc.x, _p1BaseLoc.y);
		p1_base.loadGraphic(base1Sprite, false, true, 75, 75);
		p1_base.fixed = true;
		_p1Base.add(p1_base);
		add(_p1Base);
		
		_p2Base = new FlxGroup();
		var p2_base : FlxSprite = new FlxSprite(_p2BaseLoc.x, _p2BaseLoc.y);
		p2_base.loadGraphic(base2Sprite, false, true, 75, 75);
		p2_base.fixed = true;
		_p2Base.add(p2_base);
		add(_p2Base);
		
		goals = new FlxGroup();
		var p1_goal : Goal = new Goal(_p1BaseLoc.x, _p1BaseLoc.y, _p1BaseLoc, 1);
		var p2_goal : Goal = new Goal(_p2BaseLoc.x, _p2BaseLoc.y, _p2BaseLoc, 2);
		goals.add(p1_goal);
		goals.add(p2_goal);
		add(goals);
		
		// Scoreboards init
		_p1Scoreboard = new Scoreboard(_p1BaseLoc.x, _p1BaseLoc.y, _p1BaseLoc, 0);
		_p2Scoreboard = new Scoreboard(_p2BaseLoc.x, _p2BaseLoc.y, _p2BaseLoc, 0);
		add(_p1Scoreboard);
		add(_p2Scoreboard);
		
		// Player init
		players = new FlxGroup();
		_player1 = new Player1(_p1Start.x, _p1Start.y);
		_player2 = new Player2(_p2Start.x, _p2Start.y);
		players.add(_player1);
		players.add(_player2);
		add(players);
		
		_p1Life = new HealthBar(_player1);
		add(_p1Life);
		
		_p2Life = new HealthBar(_player2);
		add(_p2Life);
		
		// Key overlays
		var p1_keys : FlxSprite = new FlxSprite(0, 544);
		p1_keys.loadGraphic(keys1Sprite, false, true, 244, 56);
		p1_keys.alpha = 0.8;
		p1_keys.fixed = true;
		add(p1_keys);
		
		var p2_keys : FlxSprite = new FlxSprite(556, 0);
		p2_keys.loadGraphic(keys2Sprite, false, true, 244, 56);
		p2_keys.alpha = 0.8;
		p2_keys.fixed = true;
		add(p2_keys);
		
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
		FlxU.overlap(players, _p1Base, check_p1_capture);
		FlxU.overlap(players, _p2Base, check_p2_capture);
		FlxU.overlap(players, hazards, process_hazard);
		FlxU.overlap(players, traps, process_trap);
		FlxU.overlap(players, trapPickups, process_pickup);
		
		// Make sure players can't go through walls.
		FlxU.collide(players, walls);
		
		// Tick down color mode change timers.
		if (_p1Cooldown > 0) {
			_p1Cooldown -= FlxG.elapsed;
			if (_p1Cooldown <= 0) {
				_p1Cooldown = 0;
			}
		}
		if (_p2Cooldown > 0) {
			_p2Cooldown -= FlxG.elapsed;
			if (_p2Cooldown <= 0) {
				_p2Cooldown = 0;
			}
		}
		
		// Check for dead players and put them on a resurrection timer.
		if (_player1.dead) {
			_p1RespawnTimer += FlxG.elapsed;
			if (_p1RespawnTimer > respawnTime) {
				_p1RespawnTimer = 0;
				_player1.create(_p1Start.x, _p1Start.y);
			}
		}
		if (_player2.dead) {
			_p2RespawnTimer += FlxG.elapsed;
			if (_p2RespawnTimer > respawnTime) {
				_p2RespawnTimer = 0;
				_player2.create(_p2Start.x, _p2Start.y);
			}
		}
		
		handle_input();
		
		// Check for victory condition.
		if (_p1Score >= winningScore || _p2Score >= winningScore) {
			if (_p1Score > _p2Score) {
				trace("Player 1 wins! " + _p1Score + "-" + _p2Score);
				endGame(1, _p1Score, _p2Score);
			} else if (_p1Score < _p2Score) {
				trace("Player 2 wins! " + _p2Score + "-" + _p1Score);
				endGame(2, _p2Score, _p1Score);
			} else {
				trace("Draw game! " + _p1Score + "-" + _p2Score);
				endGame(3, _p1Score, _p2Score);
			}
		}
	}
	
	protected function endGame(outcome : uint, score1 : uint, score2 : uint):void
	{
		if (!_transitioning)
		{
			trace("Changing to endgame");
			_transitioning = true;
			FlxG.fade.start(0xff000000, 0.4, function():void {
												_transitioning = false; 
												FlxG.state = new EndState(outcome, score1, score2);
											 });
		}
	}
	
	protected function handle_input():void
	{
		if (FlxG.keys.justPressed('Q') && _p1Cooldown <= 0) // Color mode switch
		{
			p1SwitchColor();
			_p1Cooldown = cooldownTimer;
		}
		if (FlxG.keys.justPressed('SLASH') && _p2Cooldown <= 0)
		{
			p2SwitchColor();
			_p2Cooldown = cooldownTimer;
		}
		if (FlxG.keys.justPressed('E') && _player1.useTrap()) // Player 1 trap
		{
			var s1 : PlayerTrap;
			s1 = (playerTraps.getFirstAvail() as PlayerTrap);
			if (s1 != null)
			{
				s1.create(_player1.x, _player1.y, _p1ColorMode);
			}
		}
		if (FlxG.keys.justPressed('PERIOD') && _player2.useTrap()) // Player 2 trap
		{
			var s2 : PlayerTrap;
			s2 = (playerTraps.getFirstAvail() as PlayerTrap);
			if (s2 != null)
			{
				s2.create(_player2.x, _player2.y, _p2ColorMode);
			}
		}
	}
	
	protected function p1SwitchColor():void
	{
		switch (_p1ColorMode) {
			case R:
				_p1ColorMode = G;
				break;
			case G:
				_p1ColorMode = B;
				break;
			case B:
				_p1ColorMode = R;
				break;
			default:
				_p1ColorMode = ALL;
				break;
		}
	}
	
	protected function p2SwitchColor():void
	{
		switch (_p2ColorMode) {
			case R:
				_p2ColorMode = G;
				break;
			case G:
				_p2ColorMode = B;
				break;
			case B:
				_p2ColorMode = R;
				break;
			default:
				_p2ColorMode = ALL;
				break;
		}
	}
	
	protected function acquire_goal(a : FlxObject, b : FlxObject):void
	{
		if (a is Player && b is Goal)
		{
			if (Player(a).getAllegiance() != Goal(b).getAllegiance())
			{
				Player(a).capture(Goal(b));
			}
		}
	}
	
	protected function check_p1_capture(a : FlxObject, b : FlxObject):void
	{
		if (a is Player1)
		{
			if (Player(a).isCarrying()) {
				FlxG.play(scoreSound);
				Player(a).scoreGoal();
				_p1Score++;
				_p1Scoreboard.changeScore(_p1Score);
			}
		}
	}
	
	protected function check_p2_capture(a : FlxObject, b : FlxObject):void
	{
		if (a is Player2)
		{
			if (Player(a).isCarrying()) {
				FlxG.play(scoreSound);
				Player(a).scoreGoal();
				_p2Score++;
				_p2Scoreboard.changeScore(_p2Score);
			}
		}
	}
	
	// Hazards do less damage than traps, but are persistent.
	protected function process_hazard(a : FlxObject, b : FlxObject):void
	{
		if (a is Player)
		{
			Player(a).damageEvent(hazardDamage, hazardSound);
		}
	}
	
	protected function process_trap(a : FlxObject, b : FlxObject):void
	{
		if (a is Player && b is Trap && Trap(b).isArmed())
		{
			Player(a).damageEvent(trapDamage, playerTrapSound);
			b.kill();
		}
	}
	
	protected function process_pickup(a : FlxObject, b : FlxObject):void
	{
		if (a is Player && b is TrapPickup)
		{
			if (Player(a).getTrap()) {
				TrapPickup(b).kill();
			}
		}
	}
	
	// Outer walls.
	private function generateOuterWalls() : void
	{
		var northWall : Wall = new Wall(0, 0, 800, 1, RGBSprite.R | RGBSprite.G | RGBSprite.B);
		var westWall : Wall = new Wall(0, 1, 1, 598, RGBSprite.R | RGBSprite.G | RGBSprite.B);
		var eastWall : Wall = new Wall(799, 1, 1, 598, RGBSprite.R | RGBSprite.G | RGBSprite.B);
		var southWall : Wall = new Wall(0, 599, 800, 1, RGBSprite.R | RGBSprite.G | RGBSprite.B);
		walls.add(northWall);
		walls.add(westWall);
		walls.add(eastWall);
		walls.add(southWall);
	}
		
	// Red walls. All of them. Done left to right, then top to bottom.
	private function generateRedWalls() : void
	{
		var redWall : Wall;
		var i : uint;
		
		// top lines
		for (i = 0; i < 2; i++) {
			redWall = new Wall(125, 75 + 25 * i, 25, 25, RGBSprite.R);
			walls.add(redWall);
		}
		for (i = 0; i < 2; i++) {
			redWall = new Wall(200, 50 + 25 * i, 25, 25, RGBSprite.R);
			walls.add(redWall);
		}
		
		// horz bars (the -_-)
		for (i = 0; i < 5; i++) {
			redWall = new Wall(275 + 25 * i, 100, 25, 25, RGBSprite.R);
			walls.add(redWall);
		}
		for (i = 0; i < 4; i++) {
			redWall = new Wall(525 + 25 * i, 100, 25, 25, RGBSprite.R);
			walls.add(redWall);
		}
		for (i = 0; i < 6; i++) {
			redWall = new Wall(400 + 25 * i, 225, 25, 25, RGBSprite.R);
			walls.add(redWall);
		}
		
		// vert bar
		for (i = 0; i < 5; i++) {
			redWall = new Wall(675, 175 + 25 * i, 25, 25, RGBSprite.R);
			walls.add(redWall);
		}
		
		// rotated L
		for (i = 0; i < 4; i++) {
			redWall = new Wall(200 + 25 * i, 350, 25, 25, RGBSprite.R);
			walls.add(redWall);
		}
		for (i = 0; i < 2; i++) {
			redWall = new Wall(300, 325 + 25 * i, 25, 25, RGBSprite.R);
			walls.add(redWall);
		}
		
		// vert bar
		for (i = 0; i < 5; i++) {
			redWall = new Wall(300, 425 + 25 * i, 25, 25, RGBSprite.R);
			walls.add(redWall);
		}
		for (i = 0; i < 2; i++) {
			redWall = new Wall(375 + 25 * i, 450, 25, 25, RGBSprite.R);
			walls.add(redWall);
		}
		
		// rotated L
		for (i = 0; i < 2; i++) {
			redWall = new Wall(400, 475 + 25 * i, 25, 25, RGBSprite.R);
			walls.add(redWall);
		}
		
		// horz bar
		for (i = 0; i < 3; i++) {
			redWall = new Wall(550 + 25 * i, 475, 25, 25, RGBSprite.R);
			walls.add(redWall);
		}
	}
	
	// Green walls. All of them.
	private function generateGreenWalls() : void
	{
		var greenWall : Wall;
		var i : uint;
		var j : uint;
		
		// between the -_-
		for (i = 0; i < 3; i++) {
			greenWall = new Wall(450, 100 + 25 * i, 25, 25, RGBSprite.G);
			walls.add(greenWall);
		}
		
		// middle vert bars
		for (i = 0; i < 7; i++) {
			greenWall = new Wall(225, 175 + 25 * i, 25, 25, RGBSprite.G);
			walls.add(greenWall);
		}
		for (i = 0; i < 4; i++) {
			greenWall = new Wall(600, 175 + 25 * i, 25, 25, RGBSprite.G);
			walls.add(greenWall);
		}
		for (i = 0; i < 3; i++) {
			greenWall = new Wall(600, 325 + 25 * i, 25, 25, RGBSprite.G);
			walls.add(greenWall);
		}
		
		// left lines
		for (i = 0; i < 4; i++) {
			greenWall = new Wall(0, 325 + 25 * i, 25, 25, RGBSprite.G);
			walls.add(greenWall);
		}
		for (i = 0; i < 3; i++) {
			greenWall = new Wall(25 * i, 475, 25, 25, RGBSprite.G);
			walls.add(greenWall);
		}
		
		// right lines
		for (i = 0; i < 3; i++) {
			for (j = 0; j < 3; j++) {
				greenWall = new Wall(775, 75 + 125 * j + 25 * i, 25, 25, RGBSprite.G);
				walls.add(greenWall);
			}
			greenWall = new Wall(750, 325 + 25 * i, 25, 25, RGBSprite.G);
			walls.add(greenWall);
		}
		greenWall = new Wall(725, 375, 25, 25, RGBSprite.G);
		walls.add(greenWall);
		
		// bottom block
		for (i = 0; i < 5; i++) {
			greenWall = new Wall(475 + 25 * i, 550, 25, 25, RGBSprite.G);
			walls.add(greenWall);
			greenWall = new Wall(475 + 25 * i, 575, 25, 25, RGBSprite.G);
			walls.add(greenWall);
		}
	}
		
	// Blue walls. All of them.
	private function generateBlueWalls() : void
	{
		var blueWall : Wall;
		var i : uint;
		var j : uint;
		
		// Headliner
		for (i = 1; i < 3; i++) {
			blueWall = new Wall(275 + 25 * i, 25, 25, 25, RGBSprite.B);
			walls.add(blueWall);
		}
		for (i = 14; i < 16; i++) {
			blueWall = new Wall(275 + 25 * i, 25, 25, 25, RGBSprite.B);
			walls.add(blueWall);
		}
		
		// Left remnants of the 5x6
		for (i = 0; i < 3; i++) {
			blueWall = new Wall(25 * i, 200, 25, 25, RGBSprite.B);
			walls.add(blueWall);
			blueWall = new Wall(25 * i, 275, 25, 25, RGBSprite.B);
			walls.add(blueWall);
			blueWall = new Wall(25 * i, 300, 25, 25, RGBSprite.B);
			walls.add(blueWall);
		}
		blueWall = new Wall(125, 200, 25, 25, RGBSprite.B);
		walls.add(blueWall);
		blueWall = new Wall(125, 275, 25, 25, RGBSprite.B);
		walls.add(blueWall);
		blueWall = new Wall(125, 300, 25, 25, RGBSprite.B);
		walls.add(blueWall);
		
		// Center blocks
		for (i = 0; i < 2; i++) {
			for (j = 0; j < 2; j++) {
				blueWall = new Wall(300 + 25 * i, 225 + 25 * j, 25, 25, RGBSprite.B);
				walls.add(blueWall);
			}
		}
		for (i = 0; i < 4; i++) {
			for (j = 0; j < 3; j++) {
				blueWall = new Wall(400 + 25 * i, 325 + 25 * j, 25, 25, RGBSprite.B);
				walls.add(blueWall);
			}
		}
		
		// Lower left smiley
		for (i = 0; i < 2; i++) {
			for (j = 0; j < 2; j++) {
				if (!(j == 1 && i == 0)) {
					blueWall = new Wall(100 + 25 * i, 400 + 25 * j, 25, 25, RGBSprite.B);
					walls.add(blueWall);
				}
				if (i + j > 0) {
					blueWall = new Wall(100 + 25 * i, 525 + 25 * j, 25, 25, RGBSprite.B);
					walls.add(blueWall);
				}
			}
		}
		for (i = 0; i < 5; i++) {
			blueWall = new Wall(225, 425 + 25 * i, 25, 25, RGBSprite.B);
			walls.add(blueWall);
		}
	}
	
	private function generateBuzzsaws() : void
	{
		var greenSaw : BuzzSaw;
		greenSaw = new BuzzSaw(443, 143, RGBSprite.G);
		buzzsaws.add(greenSaw);
		greenSaw = new BuzzSaw(218, 168, RGBSprite.G);
		buzzsaws.add(greenSaw);
		greenSaw = new BuzzSaw(593, 368, RGBSprite.G);
		buzzsaws.add(greenSaw);
	}
	
	private function generatePatrollers() : void
	{
		var bluePatroller : Patroller;
		bluePatroller = new Patroller(300, 150, 100, RGBSprite.B);
		bluePatroller.addWaypoint(new FlxPoint(300, 175));
		patrollers.add(bluePatroller);
		bluePatroller = new Patroller(450, 490, 100, RGBSprite.B);
		bluePatroller.addWaypoint(new FlxPoint(475, 490));
		patrollers.add(bluePatroller);
	}
	
	private function generateTrapPickups() : void
	{
		trapPickups.add(new TrapPickup(125, 25));
		trapPickups.add(new TrapPickup(550, 50));
		trapPickups.add(new TrapPickup(350, 75));
		trapPickups.add(new TrapPickup(50, 100));
		trapPickups.add(new TrapPickup(175, 150));
		trapPickups.add(new TrapPickup(525, 150));
		trapPickups.add(new TrapPickup(725, 150));
		trapPickups.add(new TrapPickup(650, 175));
		trapPickups.add(new TrapPickup(350, 200));
		trapPickups.add(new TrapPickup(450, 275));
		trapPickups.add(new TrapPickup(350, 300));
		trapPickups.add(new TrapPickup(550, 325));
		trapPickups.add(new TrapPickup(150, 325));
		trapPickups.add(new TrapPickup(275, 375));
		trapPickups.add(new TrapPickup(650, 400));
		trapPickups.add(new TrapPickup(25, 425));
		trapPickups.add(new TrapPickup(375, 425));
		trapPickups.add(new TrapPickup(475, 450));
		trapPickups.add(new TrapPickup(750, 450));
		trapPickups.add(new TrapPickup(25, 500));
		trapPickups.add(new TrapPickup(150, 500));
		trapPickups.add(new TrapPickup(350, 500));
		trapPickups.add(new TrapPickup(250, 550));
		trapPickups.add(new TrapPickup(650, 550));
	}
}
}