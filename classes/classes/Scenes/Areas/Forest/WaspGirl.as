/**
 * ...
 * @author Ormael
 */
package classes.Scenes.Areas.Forest
{
import classes.*;
import classes.BodyParts.Antennae;
import classes.BodyParts.Butt;
import classes.BodyParts.Hips;
import classes.BodyParts.LowerBody;
import classes.BodyParts.Tail;
import classes.BodyParts.Wings;
import classes.Scenes.SceneLib;
import classes.internals.ChainedDrop;

	public class WaspGirl extends Monster {

		public function waspBarrageOfDarts():void {
			outputText("The "+short+" launches a barrage of darts in your direction! ");
			if (player.buff("wasp paralyze venom").isPresent()) {
				outputText("  You've fallen prey to paralyzation venom!  Better end this quick!");
				player.buff("wasp paralyze venom").addStats( {"str":-2, "spe":-2, "tou":-4} ).withText("wasp paralyze venom").combatPermanent();
			} else {
				outputText("  It's getting much harder to move, you're not sure how many more darts like that you can take!");
				player.buff("wasp paralyze venom").addStats( {"str":-2, "spe":-2, "tou":-4} ).withText("wasp paralyze venom").combatPermanent();
			}
			var damage:int = 0;
			damage += (str + rand(20));
			player.takePhysDamage(damage, true);
			player.takePhysDamage(damage, true);
			player.takePhysDamage(damage, true);
			player.takePhysDamage(damage, true);
			player.takePhysDamage(damage, true);
			player.takePhysDamage(damage, true);
		}
		
		public function waspStingAttack():void {
			//Blind dodge change
			if (hasStatusEffect(StatusEffects.Blind)) {
				outputText(capitalA + short + " completely misses you with a blind sting!!");
				return;
			}
			//Determine if dodged!
			if (player.spe - spe > 0 && int(Math.random() * (((player.spe - spe) / 4) + 160)) > 160) {
				if (player.spe - spe < 16) outputText("You narrowly avoid " + a + short + "'s stinger!");
				if (player.spe - spe >= 16 && player.spe - spe < 40) outputText("You dodge " + a + short + "'s stinger with superior quickness!");
				if (player.spe - spe >= 40) outputText("You deftly avoid " + a + short + "'s slow attempts to sting you.");
				return;
			}
			//determine if avoided with armor.
			if (player.armorDef >= 20 && rand(4) > 0) {
				outputText("Despite her best efforts, " + a + short + "'s sting attack can't penetrate your armor.");
				return;
			}
			//Sting successful!  Paralize or lust?
			//Lust 50% of the time
			if (rand(2) == 0) {
				outputText("Searing pain lances through you as " + a + short + " manages to sting you multiple times!  You stagger back a step and nearly trip, flushing hotly.  ");
				outputText("Oh no!  You've been injected with some kind of aphrodisiac.  You've got to keep focused, you can't think about... fucking... ");
				if (player.gender == 1) outputText("or dripping honey-slicked cunts beckoning you. ");
				if (player.gender == 2) outputText("planting your aching sex over her face while you lick her sweet honeypot. ");
				if (player.gender == 3) outputText("or cocks, tits, and puffy nipples. ");
				player.takeLustDamage(40, true);
				if (player.lust > player.lust100 * 0.6) {
					outputText(" You shake your head and struggle to stay focused,");
					if (player.gender == 1 || player.gender == 3) outputText(" but it's difficult with the sensitive bulge in your groin.");
					if (player.gender == 2) outputText(" but can't ignore the soaking wetness in your groin.");
					if (player.sens > 50) outputText("  The sensitive nubs of your nipples rub tightly under your [armor].");
				}
				else outputText(" You shake your head and clear the thoughts from your head, focusing on the task at hand.");
				if (!player.hasStatusEffect(StatusEffects.lustvenom)) player.createStatusEffect(StatusEffects.lustvenom, 0, 0, 0, 0);
			}
			//Paralise the other 50%!
			else {
				outputText("Searing pain lances through you as " + a + short + " manages to sting you multiple times!  You stagger back a step and nearly trip, finding it hard to move yourself.");
				if (player.buff("wasp paralyze venom").isPresent()) {
					outputText("  You've fallen prey to paralyzation venom!  Better end this quick!");
					player.buff("wasp paralyze venom").addStats( {"str":-10, "spe":-10, "tou":-20} ).withText("wasp paralyze venom").combatPermanent();
				} else {
					outputText("  It's getting much harder to move, you're not sure how many more stings like that you can take!");
					player.buff("wasp paralyze venom").addStats( {"str":-10, "spe":-10, "tou":-20} ).withText("wasp paralyze venom").combatPermanent();
				}
			}
			if (player.lust >= player.maxOverLust() && !SceneLib.combat.tyrantiaTrainingExtension()) doNext(SceneLib.combat.endLustLoss);
			else doNext(EventParser.playerMenu);
		}

		override protected function performCombatAction():void
		{
			var choice:Number = rand(4);
			if (choice == 0) waspStingAttack();
			if (choice == 1) waspBarrageOfDarts();
			if (choice >= 2) eAttack();
		}

		public function WaspGirl()
		{
			super();
			this.a = "a ";
			this.short = "wasp girl";
			this.imageName = "beegirl";
			this.long = "A wasp girl buzzes around you, filling the air with intoxicatingly sweet scents and a buzz that gets inside your head.  She has a humanoid face with small antennae, black chitin on her slim quad arms and legs that looks like shiny gloves and boots, sizable breasts, and an abdomen tipped with a gleaming stinger.";
			this.createVagina(false, VaginaClass.WETNESS_SLAVERING, VaginaClass.LOOSENESS_GAPING);
			createBreastRow(Appearance.breastCupInverse("D"));
			this.ass.analLooseness = AssClass.LOOSENESS_STRETCHED;
			this.ass.analWetness = AssClass.WETNESS_NORMAL;
			this.tallness = rand(14) + 59;
			this.hips.type = Hips.RATING_CURVY + 1;
			this.butt.type = Butt.RATING_JIGGLY + 2;
			this.lowerBody = LowerBody.BEE;
			this.bodyColor = "yellow";
			this.hairColor = randomChoice("black","black and yellow");
			this.hairLength = 6;
			initStrTouSpeInte(67, 115, 67, 43);
			initWisLibSensCor(43, 106, 82, -100);
			this.weaponName = "chitin-plated fist";
			this.weaponVerb="armored punch";
			this.weaponAttack = 19;
			this.armorName = "chitin";
			this.armorDef = 27;
			this.armorMDef = 12;
			this.bonusHP = 200;
			this.bonusLust = 221;//lib+sens+lvl
			this.lust = 20 + rand(40);
			this.lustVuln = 0.9;
			this.level = 33;
			this.gems = rand(33) + 20;
			this.drop = new ChainedDrop().add(consumables.OVIELIX, 1 / 6)
					.add(consumables.W__BOOK, 1 / 4)
					.add(consumables.BEEHONY, 1 / 2)
					.elseDrop(useables.B_CHITN);
			this.antennae.type = Antennae.BEE;
			this.wings.type = Wings.BEE_SMALL;
			this.tailType = Tail.BEE_ABDOMEN;
			this.tailVenom = 100;
			checkMonster();
		}

	}

}
