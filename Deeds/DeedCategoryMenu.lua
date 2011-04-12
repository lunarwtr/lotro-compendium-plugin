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

DeedCategoryMenu = class( Compendium.Common.UI.CategoryMenu );
function DeedCategoryMenu:Constructor()
    Compendium.Common.UI.CategoryMenu.Constructor( self, {
		["Deed Type"]={
			["Class"] = {
				["All"]=0,
				["Burglar"]=0,
				["Captain"]=0,
				["Champion"]=0,
				["Guardian"]=0,
				["Hunter"]=0,
				["Lore-master"]=0,
				["Minstrel"]=0,
				["Rune-keeper"]=0,
				["Warden"]=0
			},
			["Event"]=0,
			["Explorer"]=0,
			["Lore"]=0,
			["Other"]=0,
			["Reputation"]=0,
			["Slayer"]=0
			},
		["Level Ranges"]={
			["11-15"]=0,
			["1-5"]=0,
			["16-20"]=0,
			["21-25"]=0,
			["26-30"]=0,
			["31-35"]=0,
			["36-40"]=0,
			["41-45"]=0,
			["46-50"]=0,
			["51-55"]=0,
			["56-60"]=0,
			["6-10"]=0,
			["61-65"]=0,
		 	["Custom"] = 0
			},
		["Rewarded"]={
			["Emote"]=0,
			["Items"]=0,
			["Rep"]=0,
			["Titles"]=0,
			["Traits"]=0,
			["Virtues"]=0
			},
		["Zone"]={
			["All"]=0,
			["Angmar"]=0,
			["Bree-land"]=0,
			["Enedwaith"]=0,
			["Ered Luin"]=0,
			["Eregion"]=0,
			["Ettenmoors"]=0,
			["Evendim"]=0,
			["Forochel"]=0,
			["Lone-lands"]=0,
			["Lothlórien"]=0,
			["Mirkwood"]=0,
			["Misty Mountains"]=0,
			["Moria"]=0,
			["North Downs"]=0,
			["Shire"]=0,
			["Trollshaws"]=0
			}
		});
end
