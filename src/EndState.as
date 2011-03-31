package  
{
import org.flixel.*;

/**
 * Endgame state, deals with postgame menu behavior.
 * @author Katie Chironis, Zizhuang Yang
 */
public class EndState extends FlxState
{
	[Embed(source = "img/p1_wins.png")] protected var p1Win:Class;
	[Embed(source = "img/p2_wins.png")] protected var p2Win:Class;
	[Embed(source = "img/draw_game.png")] protected var draw:Class;
	
	[Embed(source = "img/menu_back.png")] protected var backButton:Class;
	
	protected var back : FlxSprite = new FlxSprite(40, 530, backButton);
	
	private var p1WinPage : FlxSprite = new FlxSprite(0, 0, p1Win);
	private var p2WinPage : FlxSprite = new FlxSprite(0, 0, p2Win);
	private var drawPage : FlxSprite = new FlxSprite(0, 0, draw);
	private var score : FlxText = new FlxText(250, 295, 300);
	
	private var stateTag : Number = 0;
	
	override public function EndState(outcome : uint, score1 : uint, score2 : uint)
	{
		stateTag = outcome;
		score.text = score1 + " - " + score2;
		score.setFormat(null, 72, 0x404040, "center", 0x000000);
		score.exists = true;
		super();
	}
	
	override public function create() : void
	{
		super.create();
		FlxG.mouse.show();
		FlxState.bgColor = 0xff999999;
		loadState(stateTag);
		FlxG.flash.start(0xff000000, 1);
	}
	
	override public function update() : void
	{
		if (FlxG.mouse.justReleased()) { // something is happening!
			if (isOver(back)) { // move to previous page
				FlxG.fade.start(0x000000, 1, toMenu);
			}
		} else {
			if (isOver(back)) {
				back.color = 0xffff0000;
			} else {
				back.color = 0xffffffff;
			}
		}
		
		super.update();
	}
	
	protected function isOver(sprite : FlxSprite) : Boolean 
	{
		return (sprite.exists &&
				FlxG.mouse.x >= sprite.x && FlxG.mouse.x <= sprite.x + sprite.width &&
				FlxG.mouse.y >= sprite.y && FlxG.mouse.y <= sprite.y + sprite.height);
	}
	
	protected function loadState(state : uint) : void
	{
		p1WinPage.exists = false;
		p2WinPage.exists = false;
		drawPage.exists = false;
		
		switch (state) {
			case 1:
				p1WinPage.exists = true;
				add(p1WinPage);
				break;
			case 2:
				p2WinPage.exists = true;
				add(p2WinPage);
				break;
			case 3:
				drawPage.exists = true;
				add(drawPage);
				break;
			default:
				break;
		}
		
		back.exists = true;
		add(back);
		add(score);
	}
	
	public function toMenu() : void
	{
		FlxG.state = new MenuState();
	}
}
}