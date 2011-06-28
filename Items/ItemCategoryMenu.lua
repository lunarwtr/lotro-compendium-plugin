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

ItemCategoryMenu = class( Compendium.Common.UI.CategoryMenu );
function ItemCategoryMenu:Constructor()
    Compendium.Common.UI.CategoryMenu.Constructor( self, {
		["Armour"] = {
			["All"] =0,
			["Back"] = 0,	
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
			["Craftable"] = 0,
			["Crafting"] = 0,
			["Craft: Component"] = 0,
			["Craft: Ingredient"] = 0,
			["Craft: Optional Ingredient"] = 0,
			["Craft: Resource"] = 0,
		},
		["Home"] = {
			["Home: Ceiling"] = 0,
			["Home: Floor"] = 0,
			["Home: Furniture"] = 0,
			["Home: Music"] = 0,
			["Home: Paints & Surfaces"] = 0,
			["Home: Special"] = 0,
			["Home: Trophy"] = 0,
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
			["MoreCowbell"] = 0,
			["Bagpipe"] = 0,
			["Cowbell"] = 0,
			["Horn"] = 0
		},	
		 ["Jewellery"] = {
		 	 ["All"] = 0,
		     ["Wrist"] = 0,
		     ["Pocket"] = 0,
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
		 	["71-80"] = 0,
		 	["Custom"]=0
		 },
		["Other"] = {
			["A-M"] = {
				["Bait"] = 0,
				["Barter"] = 0,
				["Barter: Reputation"] = 0,
				["Barter: Skirmish"] = 0,
				["Book"] = 0,
				["Deconstructables"] = 0,
				["Device"] = 0,
				["Dye"] = 0,
				["Fish"] = 0,
				["Food"] = 0,	
				["Key"] = 0,
				["Misc."] = 0,
				["Mounts"] = 0,		
			},
			["N-Z"] = {
				["Outfit: Class"] = 0,
				["Perks"] = 0,
				["Pipeweed"] = 0,
				["Poles"] = 0,
				["Potion"] = 0,
				["Quest Item"] = 0,
				["Scroll"] = 0,
				["Shield-spikes"] = 0,
				["Social Item"] = 0,
				["Special"] = 0,
				["Tomes"] = 0,
				["Tool"] = 0,
				["Trap"] = 0,
				["Travel & Maps"] = 0,
				["Trophy"] = 0,
				["Weapon Oils"] = 0		
			}
		},
		["Legendary"] = 0,
		["Source"] = {
			["Craftable"] = 0,
		    ["Dungeon Drop"]={
		    	["All"]=0,
		        ["A-H"]={
		            ["Annuminas"]=0,
		            ["Barad Gularan"]=0,
		            ["Barad Guldur"]=0,
		            ["Carn Dum"]=0,
		            ["Dark Delvings"]=0,
		            ["Dar Narbugud"]=0,
		            ["Dungeons of Dol Guldur"]=0,
		            ["Epic II.6.8 - Azanarukar"]=0,
		            ["Fil Gashan"]=0,
		            ["Filikul"]=0,
		            ["Fornost"]=0,
		            ["Garth Agarwen"]=0,
		            ["Great Barrows"]=0,
		            ["Halls of Crafting"]=0,
		            ["Halls of Night"]=0,
		            ["Haudh Iarchith"]=0,
		            ["Helegrod"]=0
	            },
		        ["I-Z"]={
		            ["Inn of the Forsaken"]=0,
		            ["Lost Temple"]=0,
		            ["Lumul-nar"]=0,
		            ["Nala-dum"]=0,
		            ["Northcotton Farms"]=0,
		            ["Ost Dunhoth"]=0,
		            ["Sammath Gul"]=0,
		            ["Sâri-surma"]=0,
		            ["Sarnur"]=0,
		            ["Skumfil"]=0,
		            ["Sword-hall of Dol Guldur"]=0,
		            ["The Forges of Khazad-dum"]=0,
		            ["The Forgotten Treasury"]=0,
		            ["The Grand Stair"]=0,
		            ["The Library at Tham Mirdain"]=0,
		            ["The Rift of Nurz Ghashu"]=0,
		            ["The School at Tham Mirdain"]=0,
		            ["The Sixteenth Hall"]=0,
		            ["The Vile Maw"]=0,
		            ["Town of Stoneheight"]=0,
		            ["Urugarth"]=0,
		            ["Warg-pens of Dol Guldur"]=0
		            }
		        },
		    ["PvP"]={
		    	["All"]=0,
		        ["Ettenmoors"]=0
        	},
			["Quest Reward"] = 0
		},
		["Recipe"] = {
			["All"] =0,
			["Cooking"] = {
				["All"] =0,
				["Tier 1"] = 0,
				["Tier 2"] = 0,
				["Tier 3"] = 0,
				["Tier 4"] = 0,
				["Tier 5"] = 0,
				["Tier 6"] = 0
			},
			["Farming"] = {
				["All"] =0,
				["Tier 1"] = 0,
				["Tier 2"] = 0,
				["Tier 3"] = 0,
				["Tier 4"] = 0,
				["Tier 5"] = 0,
				["Tier 6"] = 0
			},
			["Forestry"] = {
				["All"] =0,
				["Tier 1"] = 0,
				["Tier 2"] = 0,
				["Tier 3"] = 0,
				["Tier 4"] = 0,
				["Tier 5"] = 0,
				["Tier 6"] = 0
			},
			["Jeweller"] = {
				["All"] =0,
				["Tier 1"] = 0,
				["Tier 2"] = 0,
				["Tier 3"] = 0,
				["Tier 4"] = 0,
				["Tier 5"] = 0,
				["Tier 6"] = 0
			},
			["Metalworking"] = {
				["All"] =0,
				["Tier 1"] = 0,
				["Tier 2"] = 0,
				["Tier 3"] = 0,
				["Tier 4"] = 0,
				["Tier 5"] = 0,
				["Tier 6"] = 0
			},
			["Prospecting"] = {
				["All"] =0,
				["Tier 1"] = 0,
				["Tier 2"] = 0,
				["Tier 3"] = 0,
				["Tier 4"] = 0,
				["Tier 5"] = 0,
				["Tier 6"] = 0
			},
			["Scholar"] = {
				["All"] =0,
				["Tier 1"] = 0,
				["Tier 2"] = 0,
				["Tier 3"] = 0,
				["Tier 4"] = 0,
				["Tier 5"] = 0,
				["Tier 6"] = 0
			},
			["Tailor"] = {
				["All"] =0,
				["Tier 1"] = 0,
				["Tier 2"] = 0,
				["Tier 3"] = 0,
				["Tier 4"] = 0,
				["Tier 5"] = 0,
				["Tier 6"] = 0
			},
			["Weaponsmith"] = {
				["All"] =0,
				["Tier 1"] = 0,
				["Tier 2"] = 0,
				["Tier 3"] = 0,
				["Tier 4"] = 0,
				["Tier 5"] = 0,
				["Tier 6"] = 0
			},			
			["Woodworking"] = {
				["All"] =0,
				["Tier 1"] = 0,
				["Tier 2"] = 0,
				["Tier 3"] = 0,
				["Tier 4"] = 0,
				["Tier 5"] = 0,
				["Tier 6"] = 0
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
