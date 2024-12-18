/**
 * Original code by aimozg on 27.01.14.
 * Extended for Mutations by Jtecx on 14.03.22.
 */
package classes.IMutations
{
import classes.BodyParts.Tail;
import classes.PerkClass;
import classes.PerkLib;
import classes.IMutationPerkType;
import classes.Creature;
import classes.Player;
import classes.Races;

public class StillHeartMutation extends IMutationPerkType
    {
        override public function get mName():String {
            return "Still Heart";
        }
        //v1 contains the mutation tier
        override public function mDesc(params:PerkClass, pTier:int = -1):String {
            var descS:String = "";
            pTier = (pTier == -1)? currentTier(this, player): pTier;
            if (pTier >= 1) descS += "Energy draining effect and spells and ability that drain health are "+(pTier*25)+"% stronger";
			if (pTier >= 2) descS += ". When hunger is sated above "+((6-pTier)*2)+"0% you gain doubled health generation from all sources";
            if (pTier >= 3) descS += ". You gain regeneration "+(pTier-2)+"%";
            if (pTier >= 4) descS += ". Bite attacks deals 50% more damage";
            if (descS != "")descS += ".";
            return descS;
        }

        //Mutation Requirements
        override public function pReqs(pCheck:int = -1):void{
            try{
                var pTier:int = (pCheck != -1 ? pCheck : currentTier(this, player));
                //This helps keep the requirements output clean.
                this.requirements = [];
                if (pTier == 0){
                    this.requireAdaptationsMutationSlot()
                    .requireAnyRace(Races.JIANGSHI, Races.MUMMY, Races.LICH);
                }
                else{
                    var pLvl:int = pTier * 30;
                    this.requireLevel(pLvl);
                }
            }catch(e:Error){
                trace(e.getStackTrace());
            }
        }
/*
        //Mutations Buffs
        override public function buffsForTier(pTier:int, target:Creature):Object {
            var pBuffs:Object = {};
            if (pTier == 1) pBuffs['lib.mult'] = 0.05;
            if (pTier == 2) pBuffs['tou.mult'] = 0.1;
            if (pTier == 3) pBuffs['tou.mult'] = 0.15;
            if (pTier == 4) pBuffs['tou.mult'] = 0.2;
            return pBuffs;
        }
*/
        public function StillHeartMutation() 
		{
			super(mName + " IM", mName, SLOT_ADAPTATIONS, 1);
		}
        
    }
}
