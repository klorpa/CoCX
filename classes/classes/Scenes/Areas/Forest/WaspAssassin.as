/**
 * ...
 * @author Ormael
 */
package classes.Scenes.Areas.Forest 
{
import classes.*;
import classes.GlobalFlags.*;
import classes.internals.ChainedDrop;
import classes.Scenes.Areas.Forest.WaspGirl;

	public class WaspAssassin extends WaspGirl {
		
		public function waspBottleThrow():void {
			outputText("The wasp assassin dances away from you, just out of reach before grabbing one of the bottles off her belt and throwing it at the ground in front of you!\n\n");
			if (player.spe > (this.spe + rand(15))) {
				outputText(" You leap out of the way, rolling to the side as a yellow haze envelopes the ground where you were standing a moment before. Though even at this distance, your skin tingles sensually...");
				player.takeLustDamage(5, true);
			}
			else {
				outputText(" You cry out as the bottle shatters, exploding in a yellow cloud that blows over you. You gag and cough and suddenly your hands are reaching to your crotch as if on their own. You yank back, but feel a hot haze washing across your exposed body.");
				player.takeLustDamage((25 + player.lib/20 + player.effectiveSensitivity()/5), true);
			}
		}
		
		override protected function performCombatAction():void
		{
			var choice:Number = rand(5);
			if (choice == 0) waspStingAttack();
			if (choice == 1) waspBarrageOfDarts();
			if (choice == 2) waspBottleThrow();
			if (choice >= 3) eAttack();
		}
		
		public function WaspAssassin() 
		{
			super();
			this.a = "an ";
			this.short = "wasp assassin";
			this.long = "An wasp assassin buzzes around you, filling the air with intoxicatingly sweet scents and a buzz that gets inside your head.  She has a humanoid face with small antennae, black chitin on her arms and legs that looks like shiny gloves and boots, sizable breasts, and a swollen abdomen tipped with a gleaming stinger.";
			createBreastRow(Appearance.breastCupInverse("E_BIG"));
			initStrTouSpeInte(110, 188, 200, 100);
			initWisLibSensCor(100, 129, 105, -100);
			this.weaponAttack = 53;
			this.armorDef = 49;
			this.armorMDef = 26;
			this.bonusHP = 400;
			this.bonusLust = 297;//lib+sens+lvl
			this.level = 63;
			this.gems = rand(42) + 28;
			this.drop = new ChainedDrop().add(consumables.OVIELIX, 1 / 4)
					.add(consumables.W__BOOK, 1 / 3)
					.add(consumables.BEEHONY, 1 / 2)
					.elseDrop(useables.B_CHITN);
			checkMonster();
		}
		
	}

}