package  
{
import org.flixel.*;

/**
 * Menu state, deals with the opening menu behavior.
 * @author Katie Chironis, Zizhuang Yang
 */
public class MenuState extends FlxState
{
	[Embed(source = "img/rgb_tutorial_1.png")] protected var tutorial1:Class;
	[Embed(source = "img/rgb_tutorial_2.png")] protected var tutorial2:Class;
	[Embed(source = "img/rgb_menu.png")] protected var menu:Class;
	[Embed(source = "img/rgb_credits.png")] protected var credits:Class;
	
	[Embed(source = "img/menu_back.png")] protected var backButton:Class;
	[Embed(source = "img/menu_next.png")] protected var nextButton:Class;
	[Embed(source = "img/menu_howto.png")] protected var howToButton:Class;
	[Embed(source = "img/menu_play.png")] protected var playButton:Class;
	[Embed(source = "img/menu_credits.png")] protected var creditsButton:Class;
	
	protected var back : FlxSprite = new FlxSprite(40, 530, backButton);
	protected var next : FlxSprite = new FlxSprite(580, 530, nextButton);
	protected var howTo : FlxSprite = new FlxSprite(535, 295, howToButton);
	protected var play : FlxSprite = new FlxSprite(255, 295, playButton);
	protected var credit : FlxSprite = new FlxSprite(30, 295, creditsButton);
	
	private var menuPage : FlxSprite = new FlxSprite(0, 0, menu);
	private var tutorialPage1 : FlxSprite = new FlxSprite(0, 0, tutorial1);
	private var tutorialPage2 : FlxSprite = new FlxSprite(0, 0, tutorial2);
	private var creditsPage : FlxSprite = new FlxSprite(0, 0, credits);
	
	private var stateTag : Number = 0;
	
	override public function create() : void
	{
		super.create();
		FlxG.mouse.show();
		FlxState.bgColor = 0xff999999;
		loadState(0);
		FlxG.flash.start(0xff000000, 1);
	}
	
	override public function update() : void
	{
		switch (stateTag) {
			case 0: // Menu screen
				if (FlxG.mouse.justReleased()) { // something is happening!
					if (isOver(howTo)) { // move to tutorial mode
						loadState(2);
					}
					if (isOver(play)) { // play ball!
						FlxG.fade.start(0xffffff, 1, proceed);
					}
					if (isOver(credit)) { // move to credits mode
						loadState(1);
					}
				} else {
					if (isOver(howTo)) {
						howTo.color = 0xffff0000;
					} else {
						howTo.color = 0xffffffff;
					}
					if (isOver(play)) {
						play.color = 0xffff0000;
					} else {
						play.color = 0xffffffff;
					}
					if (isOver(credit)) {
						credit.color = 0xffff0000;
					} else {
						credit.color = 0xffffffff;
					}
				}
				break;
			case 1: // credits screen
				if (FlxG.mouse.justReleased()) { // something is happening!
					if (isOver(back)) { // move to menu mode
						loadState(0);
					}
				} else {
					if (isOver(back)) {
						back.color = 0xffff0000;
					} else {
						back.color = 0xffffffff;
					}
				}
				break;
			case 2: // tutorial screen 1
				if (FlxG.mouse.justReleased()) { // something is happening!
					if (isOver(back)) { // move to menu mode
						loadState(0);
					}
					if (isOver(next)) { // move to next page
						loadState(3);
					}
				} else {
					if (isOver(back)) {
						back.color = 0xffff0000;
					} else {
						back.color = 0xffffffff;
					}
					if (isOver(next)) {
						next.color = 0xffff0000;
					} else {
						next.color = 0xffffffff;
					}
				}
				break;
			case 3: // tutorial screen 2
				if (FlxG.mouse.justReleased()) { // something is happening!
					if (isOver(back)) { // move to previous page
						loadState(2);
					}
				} else {
					if (isOver(back)) {
						back.color = 0xffff0000;
					} else {
						back.color = 0xffffffff;
					}
				}
				break;
			default:
				break;
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
		back.exists = false;
		next.exists = false;
		howTo.exists = false;
		play.exists = false;
		credit.exists = false;
		menuPage.exists = false;
		tutorialPage1.exists = false;
		tutorialPage2.exists = false;
		creditsPage.exists = false;
		
		switch (state) {
			case 0:
				menuPage.exists = true;
				howTo.exists = true;
				play.exists = true;
				credit.exists = true;
				add(menuPage);
				add(howTo);
				add(play);
				add(credit);
				stateTag = 0;
				break;
			case 1:
				creditsPage.exists = true;
				back.exists = true;
				back.x = 40;
				back.y = 530;
				add(creditsPage);
				add(back);
				stateTag = 1;
				break;
			case 2:
				tutorialPage1.exists = true;
				back.exists = true;
				back.x = 40;
				back.y = 530;
				next.exists = true;
				add(tutorialPage1);
				add(back);
				add(next);
				stateTag = 2;
				break;
			case 3:
				tutorialPage2.exists = true;
				back.exists = true;
				back.x = 580;
				back.y = 530;
				add(tutorialPage2);
				add(back);
				stateTag = 3;
				break;
			default:
				break;
		}
	}
	
	public function proceed() : void
	{
		FlxG.mouse.hide();
		FlxG.state = new GameState();
	}
}
}