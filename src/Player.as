package  
{
import org.flixel.*;
import org.flixel.data.FlxPanel;

/**
 * Player base class.
 * @author Katie Chironis, Zizhuang Yang
 */
public class Player extends FlxSprite
{
	protected var runSpeed : Number = 200;
	
	protected var allegiance : Number = 0;
	protected var carryingGoal : Boolean;
	protected var carriedGoal : Goal;
	protected var hasTrap : Boolean;
	
	protected var invincibilityTimer : Number = 0;
	
	public function Player(x : int, y : int) 
	{
		super(x, y);
		
		// Arbitrary physics constants, perhaps to be tweaked later!
		drag.x = runSpeed * 2;
		drag.y = runSpeed * 2;
		maxVelocity.x = runSpeed;
		maxVelocity.y = runSpeed;
		
		// Mechanics stuff go here.
		health = 6;
		hasTrap = false;
		carryingGoal = false;
		carriedGoal = null;
	}
	
	public function create(x : int, y : int):void
	{
		velocity.x = velocity.y = 0;
		health = 6;
		hasTrap = false;
		carryingGoal = false;
		carriedGoal = null;
		color = 0xFFFFFF;
		reset(x, y);
	}
	
	public function capture(goal : Goal):void
	{
		carryingGoal = true;
		carriedGoal = goal;
		goal.capture(this);
	}
	
	public function isCarrying():Boolean
	{
		return carryingGoal;
	}
	
	public function scoreGoal():void
	{
		carriedGoal.startRespawn();
		carryingGoal = false;
		carriedGoal = null;
	}
	
	public function getAllegiance():Number
	{
		return allegiance;
	}
	
	public function getTrap():Boolean
	{
		if (hasTrap) { // Return unsuccessful if you already have one.
			return false;
		} else {
			hasTrap = true;
			return true;
		}
	}
	
	public function useTrap():Boolean
	{
		if (!hasTrap) { // Return unsuccessful if you don't have one.
			return false;
		} else {
			hasTrap = false;
			return true;
		}
	}
	
	override public function kill():void
	{
		super.kill();
		
		if (carryingGoal) {
			carriedGoal.startRespawn();
		}
	}
	
	override public function hurt(damage : Number):void
	{
		if (invincibilityTimer <= 0.0) {
			super.hurt(damage);
			invincibilityTimer = 1.0;
		}
	}
	
	override public function update():void
	{		
		// Deal with ticking invincibility.
		if (invincibilityTimer > 0.0) {
			invincibilityTimer -= FlxG.elapsed;
			
			// Cap off the minimum.
			if (invincibilityTimer <= 0.0) {
				invincibilityTimer = 0.0;
			}
			
			// Have a little flashing effect.
			if (Math.floor(invincibilityTimer * 6) % 2 == 1) {
				alpha = 0.0;
			} else {
				alpha = 1.0;
			}
		}
		
		super.update();
	}
}

}