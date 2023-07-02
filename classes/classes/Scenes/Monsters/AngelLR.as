/**
 * ...
 * @author Ormael
 */
package classes.Scenes.Monsters 
{

	import classes.*;
	import classes.BodyParts.Wings;
	import classes.Scenes.SceneLib;
	import classes.internals.ChainedDrop;
	
	public class AngelLR extends AbstractAngel
	{
		private function angelReactsToLustiness():void {
			outputText("Angel with it lil helpers stops their actions clearly overflowing with lust.");
			outputText("\n\n\"<i>Tricky one opponent. Fighting like a demon.</i>\"");
			outputText("\n\nThe angel starts then to shine with pure white light so intense you must temporaly avert your gaze. When you look again at spot it was you could only see a bit of powder.");
			gems = 0;
			XP = 0;
			HP = minHP() - 1;
			SceneLib.combat.cleanupAfterCombatImpl();
		}
		
		private function AngelEnergyRays():void {
			outputText("Angel lil helpers fixates at you with all of their eyes unleashing a barrage of rays at you! ");
			var omni:Number = 4;
			if (hasStatusEffect(StatusEffects.TrueFormAngel)) omni *= 3;
			while (omni-->0) AngelEnergyRaysD();
			outputText("\n\n");
		}
		private function AngelEnergyRaysD():void {
			var damage:Number = eBaseWisdomDamage() * 0.75;
			damage += eBaseIntelligenceDamage() * 0.15;
			damage = Math.round(damage);
			damage = player.takeMagicDamage(damage, true);
		}
		
		private function AngelBaseAttack():void {
			outputText("Angel gather energy between his palms and then blasts it toward you. ");
			var damage:Number = eBaseWisdomDamage();
			damage += eBaseIntelligenceDamage() * 0.2;
			damage = Math.round(damage);
			damage = player.takeMagicDamage(damage, true);
			outputText("\n\n");
		}
		
		override protected function performCombatAction():void
		{
			if (hasStatusEffect(StatusEffects.TrueFormAngel)) {
				if (!hasStatusEffect(StatusEffects.ATranscendentSoulField) && soulforce >= (soulfieldsustaincost()*2)) createStatusEffect(StatusEffects.ATranscendentSoulField, (soulfieldsustaincost()*2), (soulfieldsustaincost()*2), 0, 0);
				if (hasStatusEffect(StatusEffects.ATranscendentSoulField)) {
					if (soulforce >= (soulfieldsustaincost()*2)) soulforce -= (soulfieldsustaincost()*2);
					else removeStatusEffect(StatusEffects.ATranscendentSoulField);
				}
			}
			else {
				if (!hasStatusEffect(StatusEffects.ATranscendentSoulField) && soulforce >= soulfieldsustaincost()) createStatusEffect(StatusEffects.ATranscendentSoulField, soulfieldsustaincost(), soulfieldsustaincost(), 0, 0);
				if (hasStatusEffect(StatusEffects.ATranscendentSoulField)) {
					if (soulforce >= soulfieldsustaincost()) soulforce -= soulfieldsustaincost();
					else removeStatusEffect(StatusEffects.ATranscendentSoulField);
				}
			}
			var choice:Number = rand(5);
			if (choice == 0) AngelEnergyRays();
			if (choice > 0) AngelBaseAttack();
		}
		private function soulfieldsustaincost():Number {
			var sfsc:Number = 10;
			if (player.hasStatusEffect(StatusEffects.RiverDungeonA)) sfsc *= 2.4;
			return sfsc;
		}
		
		private function angelification():void {
			clearOutput();
			var TB:Number = Math.round(touStat.core.value * 0.4);
			var SB:Number = Math.round(speStat.core.value * 0.2);
			var WB:Number = Math.round(wisStat.core.value * 0.6);
			touStat.core.value += TB;
			speStat.core.value += SB;
			wisStat.core.value += WB;
			addPerkValue(PerkLib.MonsterRegeneration, 1, 2);
			if (player.hasStatusEffect(StatusEffects.RiverDungeonA)) {
				addPerkValue(PerkLib.DieHardHP, 1, 24);
				addStatusValue(StatusEffects.TranscendentSoulField, 1, 24);
				addStatusValue(StatusEffects.TranscendentSoulField, 2, 24);
				bonusWrath += 600;
				bonusSoulforce += 1200;
			}
			else {
				addPerkValue(PerkLib.DieHardHP, 1, 10);
				addStatusValue(StatusEffects.TranscendentSoulField, 1, 10);
				addStatusValue(StatusEffects.TranscendentSoulField, 2, 10);
				bonusWrath += 300;
				bonusSoulforce += 600;
			}
			HP = maxHP();
			outputText("Staggering back, angelic trio wastes no time and above their heads starts to manifest sort of halo. All their irises become uniform purple colored. And around bodies manifest two crossed circles with pair of eyes looking exactly the same as main eye down to each detail including dual irises.");
			outputText("\n\n\"<i>Don't be afraid"+(player.hasStatusEffect(StatusEffects.RiverDungeonA)?" of the Mist":"")+"!!!</i>\" it whispers loud enough for you to hear before launching up to continue the fight.");
			createStatusEffect(StatusEffects.TrueFormAngel, 0, 0, 0, 0);
			SceneLib.combat.combatRoundOver();
		}
		
		override public function defeated(hpVictory:Boolean):void
		{
			if (hpVictory) {
				if (!hasStatusEffect(StatusEffects.TrueFormAngel)) {
					angelification();
					return;
				}
				cleanupAfterCombat();
			}
			else angelReactsToLustiness();
		}
		
		override public function get long():String
		{
			var str:String = "You're currently fighting low-rank angel"+(player.hasStatusEffect(StatusEffects.RiverDungeonA)?" of mist":"")+". It's looks like example of perfect human with large pair of wings and around it hoover pair of winged eyeballs with small mouth full of jagged teeth and one eyes having two";
			if (hasStatusEffect(StatusEffects.TrueFormAngel)) str += " purple irises each. Around each of their bodies are two circles each with pair of eyes looking the same as the main eye and above angel head hoover halo.";
			else str += " irises each, one red and the other blue. Angel eyes also mirrors this with right one been red and left blue one.";
			if (player.hasStatusEffect(StatusEffects.RiverDungeonA)) str += " All three of them have their bodies covered in nearly not visible purple lines that glows ocassionaly.";
			if (hasStatusEffect(StatusEffects.TranscendentSoulField))
			{
				str += "\n\n<i>From time to time you can notice faint glimmers of ";
				if (player.hasStatusEffect(StatusEffects.RiverDungeonA)) str += "puple";
				else str += "orange";
				str += " protective field surrounding it.";
				if (hasStatusEffect(StatusEffects.TrueFormAngel)) str += " After your attacks it take octagonal shapes for a brief moment.";
				str += "</i>";
			}
			return str;
		}
		
		public function AngelLR() 
		{
			super(false);
			if (player.hasStatusEffect(StatusEffects.RiverDungeonA)) {
				this.short = "low-rank angel of mist";
				initStrTouSpeInte(14, 160, 80, 40);
				initWisLibSensCor(240, 4, 60, 0);
				this.drop = new ChainedDrop()
						.add(useables.SRESIDUE, 0.5)
						.add(useables.PCSHARD, 1);
				this.level = 36;
				this.bonusHP = 1200;
				this.bonusLust = 100;
				this.bonusWrath = 300;
				this.bonusSoulforce = 600;
				this.additionalXP = 180;
				this.weaponAttack = 12;
				this.armorDef = 42;
				this.armorMDef = 42;
				this.createStatusEffect(StatusEffects.ATranscendentSoulField, 24, 24, 0, 0);//X times less dmg, +X lvl diff bonus
				this.createPerk(PerkLib.DieHardHP, 24, 0, 0, 0);
			}
			else {
				this.short = "low-rank angel";
				initStrTouSpeInte(7, 80, 40, 20);
				initWisLibSensCor(120, 4, 30, 0);
				this.drop = new ChainedDrop()
						.add(useables.SRESIDUE, 1);
				this.level = 15;
				this.bonusHP = 600;
				this.bonusLust = 49;
				this.bonusWrath = 150;
				this.bonusSoulforce = 300;
				this.additionalXP = 90;
				this.weaponAttack = 6;
				this.armorDef = 18;
				this.armorMDef = 18;
				this.createStatusEffect(StatusEffects.ATranscendentSoulField, 10, 10, 0, 0);//X times less dmg, +X lvl diff bonus
				this.createPerk(PerkLib.DieHardHP, 10, 0, 0, 0);
			}
			this.a = "the ";
			this.imageName = "angel";
			this.long = "";
			this.tallness = 30;
			this.weaponName = "energy blast";
			this.weaponVerb = "shoot";
			this.armorName = "skin";
			this.wings.type = Wings.FEATHERED_AVIAN;
			if (player.cor < 67) this.createPerk(PerkLib.AlwaysSuccesfullRunaway, 9, 0, 0, 0);
			this.createStatusEffect(StatusEffects.Flying, 50, 0, 0, 0);
			this.createPerk(PerkLib.MonsterRegeneration, 1, 0, 0, 0);
			checkMonster();
		}
		
	}

}