package classes.Scenes.Combat.Soulskills {
import classes.Scenes.Combat.AbstractSoulSkill;
import classes.StatusEffects;
import classes.Monster;
import classes.GlobalFlags.kFLAGS;
import classes.PerkLib;

public class BladeDanceSkill extends AbstractSoulSkill {
    public function BladeDanceSkill() {
        super(
            "Blade Dance",
            "Attack twice (four times if double attack is active, six times if triple attack is active and etc.).",
            TARGET_ENEMY,
            TIMING_INSTANT,
            [TAG_DAMAGING],
            null
        )
		baseSFCost = 50;
    }

	override public function get buttonName():String {
		return "Blade Dance";
	}

	override public function get isKnown():Boolean {
		return player.hasPerk(PerkLib.BladeWarden);
	}

	override public function describeEffectVs(target:Monster):String {
		return "Deals 2 sets of physical damage attacks"
	}

	override public function sfCost():int {
		var soulforcecost:Number = baseSFCost * soulskillCost() * (1 + flags[kFLAGS.MULTIATTACK_STYLE]);
        return Math.round(soulforcecost);
	}

    override public function doEffect(display:Boolean = true):void {		
		if (display) outputText("You momentarily attune yourself to the song of the mother tree, and dance forward, darting around your enemy, your blade slicing the air and foe alike.\n\n");
		player.createStatusEffect(StatusEffects.BladeDance,0,0,0,0);
		combat.basemeleeattacks();
    }

	//Prevent default enemyAI function call, since post ability cleanup will be handled by combat.basemeleeattacks()
	override public function buttonCallback():void {
		combat.callbackBeforeAbility(this);
		if (timingType == TIMING_TOGGLE && isActive()) {
			toggleOff();
		} else {
			perform();
		}
	}
}
}