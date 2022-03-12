/**
 * ...
 * @author Ormael
 */
package classes.Items.Necklaces 
{
	import classes.Items.Necklace;
	import classes.Player;

	public class NecklaceOfToughness extends Necklace
	{
		
		public function NecklaceOfToughness() 
		{
			super("NeckTou", "NecklaceOfToughness", "Necklace of Toughness", "a Necklace of Toughness", 0, 0, 4000, "A simple necklace to boost toughness.","Necklace");
		}
		
		override public function get description():String {
			var desc:String = _description;
			//Type
			desc += "\n\nType: Jewelry (Necklace)";
			//Value
			desc += "\nBase value: " + String(value);
			//Perk
			desc += "\nSpecial: Toughness +50%";
			return desc;
		}
		
		override public function playerEquip():Necklace {
			game.player.statStore.addBuff('tou.mult',0.50,'NecklaceOfToughness',{text:'Necklace Of Toughness'});
			return super.playerEquip();
		}
		
		override public function playerRemove():Necklace {
			game.player.statStore.removeBuffs('NecklaceOfToughness');
			return super.playerRemove();
		}
		
	}

}