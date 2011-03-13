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
		["Type"] = {
			["All"] = 0,
			["Metalsmith"] = 0,
			["Woodworker"] = 0,
			["Tailor"] = 0,
			["Forester"] = 0,
			["Scholar"] = 0,
			["Weaponsmith"] = 0,
			["Cook"] = 0,
			["Prospector"] = 0,
			["Farmer"] = 0,
			["Jeweller"] = 0
		},
		["Tier"] = {
				["All"] = 0,
				["Tier 1"] = 0,
				["Tier 2"] = 0,
				["Tier 3"] = 0,
				["Tier 4"] = 0,
				["Tier 5"] = 0,
				["Tier 6"] = 0
			}
		});
end
