--[[
   Copyright 2011 Kelly Riley (lunarwater)

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
]]

import "Compendium.Common.Utils";
import "Compendium.Common.UI";

CraftCategoryMenu = class( Compendium.Common.UI.CategoryMenu );
function CraftCategoryMenu:Constructor()
    Compendium.Common.UI.CategoryMenu.Constructor( self, {
		["Armour"] = {
			["All"] =0,
			["Back"] = 0,
			["Light"] = 0,
			["Medium"] = 0,
			["Heavy"] = 0,				
			["Feet"] = {
				["All"] =0,
				["Light"] = 0,
				["Medium"] = 0,
				["Heavy"] = 0
			},
			["Hands"] = {
				["All"] =0,
				["Light"] = 0,
				["Medium"] = 0,
				["Heavy"] = 0
			},
			["Head"] = {
				["All"] =0,
				["Light"] = 0,
				["Medium"] = 0,
				["Heavy"] = 0
			},
			["Legs"] = {
				["All"] =0,
				["Light"] = 0,
				["Medium"] = 0,
				["Heavy"] = 0
			},
			["Shield"] = 0,
			["Shoulders"] = {
				["All"] =0,
				["Light"] = 0,
				["Medium"] = 0,
				["Heavy"] = 0
			},
			["Upperbody"] = {
				["All"] =0,
				["Light"] = 0,
				["Medium"] = 0,
				["Heavy"] = 0
			}
		},
		["Class Items"] = {
			["Rune-keeper"] = 0, 
			["Guardian"] = 0, 
			["Warden"] = 0, 
			["Lore-master"] = 0, 
			["Burglar"] = 0, 
			["Captain"] = 0, 
			["Champion"] = 0, 
			["Minstrel"] = 0, 
			["Hunter"] = 0
		},
		["Craft"] = {
			["Craft: Component"] = 0,
			["Craft: Ingredient"] = 0
		},
		["Home"] = {
			["Home: Ceiling"] = 0,
			["Home: Floor"] = 0,
			["Home: Furniture"] = 0,
			["Home: Paints & Surfaces"] = 0,
			["Home: Special"] = 0,
			["Home: Wall"] = 0,
			["Home: Yard"] = 0
		},
		["Instrument"] = {
			["All"] =0,
			["Harp"] = 0,
			["Flute"] = 0,
			["Clarinet"] = 0,
			["Lute"] = 0,
			["Drum"] = 0,
			["Theorbo"] = 0,
			["Bagpipe"] = 0,
			["Cowbell"] = 0,
			["Horn"] = 0
		},	
		 ["Jewellery"] = {
		 	 ["All"] = 0,
		     ["Wrist"] = 0,
		     ["Ear"] = 0,
		     ["Finger"] = 0,
		     ["Neck"] = 0
		 },
		 ["Level Ranges"] = {
		 	["1-10"] = 0,
		 	["11-20"] = 0, 
		 	["21-30"] = 0, 
		 	["31-40"] = 0,
		 	["41-50"] = 0, 
		 	["51-60"] = 0, 
		 	["61-70"] = 0, 
		 	["71-80"] = 0
		 },
		["Other"] = {
			["Barter"] = 0,
			["Barter: Reputation"] = 0,
			["Device"] = 0,
			["Dye"] = 0,
			["Food"] = 0,
			["Pipeweed"] = 0,
			["Poles"] = 0,
			["Potion"] = 0,
			["Scroll"] = 0,
			["Shield-spikes"] = 0,
			["Tool"] = 0,
			["Trap"] = 0,
			["Trophy"] = 0,
			["Weapon Oils"] = 0		
		},
		["Recipe"] = {
	
			["All"] =0,
			["Cook"] = {
				["All"] =0,
				["Tier 1"] = 0,
				["Tier 2"] = 0,
				["Tier 3"] = 0,
				["Tier 4"] = 0,
				["Tier 5"] = 0,
				["Tier 6"] = 0,
				["Tier 7"] = 0
			},
			["Farmer"] = {
				["All"] =0,
				["Tier 1"] = 0,
				["Tier 2"] = 0,
				["Tier 3"] = 0,
				["Tier 4"] = 0,
				["Tier 5"] = 0,
				["Tier 6"] = 0,
				["Tier 7"] = 0
			},
			["Forester"] = {
				["All"] =0,
				["Tier 1"] = 0,
				["Tier 2"] = 0,
				["Tier 3"] = 0,
				["Tier 4"] = 0,
				["Tier 5"] = 0,
				["Tier 6"] = 0,
				["Tier 7"] = 0
			},
			["Jeweller"] = {
				["All"] =0,
				["Tier 1"] = 0,
				["Tier 2"] = 0,
				["Tier 3"] = 0,
				["Tier 4"] = 0,
				["Tier 5"] = 0,
				["Tier 6"] = 0,
				["Tier 7"] = 0
			},
			["Metalsmith"] = {
				["All"] =0,
				["Tier 1"] = 0,
				["Tier 2"] = 0,
				["Tier 3"] = 0,
				["Tier 4"] = 0,
				["Tier 5"] = 0,
				["Tier 6"] = 0,
				["Tier 7"] = 0
			},
			["Prospector"] = {
				["All"] =0,
				["Tier 1"] = 0,
				["Tier 2"] = 0,
				["Tier 3"] = 0,
				["Tier 4"] = 0,
				["Tier 5"] = 0,
				["Tier 6"] = 0,
				["Tier 7"] = 0
			},
			["Scholar"] = {
				["All"] =0,
				["Tier 1"] = 0,
				["Tier 2"] = 0,
				["Tier 3"] = 0,
				["Tier 4"] = 0,
				["Tier 5"] = 0,
				["Tier 6"] = 0,
				["Tier 7"] = 0
			},
			["Tailor"] = {
				["All"] =0,
				["Tier 1"] = 0,
				["Tier 2"] = 0,
				["Tier 3"] = 0,
				["Tier 4"] = 0,
				["Tier 5"] = 0,
				["Tier 6"] = 0,
				["Tier 7"] = 0
			},
			["Weaponsmith"] = {
				["All"] =0,
				["Tier 1"] = 0,
				["Tier 2"] = 0,
				["Tier 3"] = 0,
				["Tier 4"] = 0,
				["Tier 5"] = 0,
				["Tier 6"] = 0,
				["Tier 7"] = 0
			},			
			["Woodworker"] = {
				["All"] =0,
				["Tier 1"] = 0,
				["Tier 2"] = 0,
				["Tier 3"] = 0,
				["Tier 4"] = 0,
				["Tier 5"] = 0,
				["Tier 6"] = 0,
				["Tier 7"] = 0
			},
		},
		["Weapon"] = {
			["All"] =0,
			["One-handed"] = {
				["All"] =0,
				["Dagger"] = 0,
				["Axe"] = 0,
				["Club"] = 0,
				["Hammer"] = 0,
				["Mace"] = 0,
				["Spear"] = 0,
				["Sword"] = 0
			},
			["Two-handed"] = {
				["All"] =0,
				["Halberd"] = 0,
				["Staff"] = 0,
				["Axe"] = 0,
				["Club"] = 0,
				["Hammer"] = 0,
				["Sword"] = 0
			},
			["Ranged"] = {
				["All"] =0,
				["Crossbow"] = 0,
				["Bow"] = 0,
				["Javelin"] = 0
			},
			["Rune-stone"] = 0
		}	
	});
end
