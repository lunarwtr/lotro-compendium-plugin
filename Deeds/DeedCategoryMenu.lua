

import "Compendium.Common.Utils";
import "Compendium.Common.UI";

DeedCategoryMenu = class( Compendium.Common.UI.CategoryMenu );
function DeedCategoryMenu:Constructor()
    Compendium.Common.UI.CategoryMenu.Constructor( self, {
		["Deed Type"] = {
			["Class"] = {
				["All"] = 0,
				["Beorning"] = 0,
				["Brawler"] = 0,
				["Burglar"] = 0,
				["Captain"] = 0,
				["Champion"] = 0,
				["Corsair"] = 0,
				["Guardian"] = 0,
				["Hunter"] = 0,
				["Lore-master"] = 0,
				["Minstrel"] = 0,
				["Rune-keeper"] = 0,
				["Warden"] = 0
			},
			["Event"] = 0,
			["Explorer"] = 0,
			["Lore"] = 0,
			["Race"] = 0,
			["Reputation"] = 0,
			["Slayer"] = 0
		},
		["Faction"] = {
			["Free People"] = 0,
			["Monster"] = 0
		},
		["Level Ranges"] = {
			["1-5"] = 0,
			["6-10"] = 0,
			["11-15"] = 0,
			["16-20"] = 0,
			["21-25"] = 0,
			["26-30"] = 0,
			["31-35"] = 0,
			["36-40"] = 0,
			["41-45"] = 0,
			["46-50"] = 0,
			["51-55"] = 0,
			["56-60"] = 0,
			["61-65"] = 0,
			["66-70"] = 0,
			["71-75"] = 0,
			["76-80"] = 0,
			["81-85"] = 0,
			["86-90"] = 0,
			["91-95"] = 0,
			["96-100"] = 0,
			["101-105"] = 0,
			["106-110"] = 0,
			["111-115"] = 0,
			["116-120"] = 0,
			["121-125"] = 0,
			["126-130"] = 0,
			["136-140"] = 0,
			["141-145"] = 0,
			["146-150"] = 0,
			["Custom"] = 0
		},
		["Progression"] = {
			["Complete"] = 0,
			["Incomplete"] = 0
		},
		["Rewarded"] = {
			["Emotes"] = 0,
			["Glory"] = 0,
			["Items"] = 0,
			["Lotro Points"] = 0,
			["Mount XP"] = 0,
			["Rep Item"] = 0,
			["Titles"] = 0,
			["Traits"] = 0,
			["Virtue XP"] = 0,
			["XP"] = 0
		},
		["Zone"] = {
			["All"] = 0,
			["A-E"] = {
				["All"] = 0,
				["Ambarûl"] = {
					["All"] = 0,
					["Fields of Duragâr"] = 0,
					["Unknown"] = 0
				},
				["Anfalas"] = 0,
				["Angmar"] = {
					["All"] = 0,
					["Carn Dûm"] = 0,
					["Fasach-larran"] = 0,
					["Nan Gurth"] = 0,
					["Rift of Nûrz Ghâshu"] = 0,
					["Unknown"] = 0,
					["Urugarth"] = 0
				},
				["Anórien (After Battle)"] = {
					["All"] = 0,
					["Osgiliath (After-battle)"] = 0
				},
				["Bree-land"] = {
					["All"] = 0,
					["Bree"] = 0,
					["Northern Barrow-downs"] = 0,
					["Southern Bree-fields"] = 0,
					["Unknown"] = 0
				},
				["Cardolan"] = {
					["All"] = 0,
					["Sarch Vorn"] = 0,
					["Unknown"] = 0
				},
				["Central Gondor"] = {
					["All"] = 0,
					["Lower Lebennin"] = 0,
					["Unknown"] = 0
				},
				["Dunland"] = {
					["All"] = 0,
					["Isengard"] = 0,
					["Nan Curunír"] = 0,
					["Unknown"] = 0
				},
				["Dwarf-holds"] = {
					["All"] = 0,
					["Ered Mithrin"] = 0,
					["Glimmerdeep"] = 0,
					["Stormwall"] = 0,
					["Unknown"] = 0
				},
				["Eastern Gondor"] = {
					["All"] = 0,
					["Lossarnach"] = 0,
					["Osgiliath"] = 0,
					["Unknown"] = 0,
					["Upper Lebennin"] = 0
				},
				["Elderslade"] = {
					["All"] = 0,
					["Unknown"] = 0,
					["War of Three Peaks"] = 0
				},
				["Enedwaith"] = {
					["All"] = 0,
					["Lich Bluffs"] = 0,
					["Thrór's Coomb"] = 0,
					["Unknown"] = 0
				},
				["Erebor"] = 0,
				["Ered Luin"] = {
					["All"] = 0,
					["Thorin's Gate"] = 0,
					["Unknown"] = 0
				},
				["Eregion"] = {
					["All"] = 0,
					["Emyn Naer"] = 0,
					["Mirobel"] = 0,
					["Tham Mírdain"] = 0,
					["Unknown"] = 0
				},
				["Ettenmoors"] = 0,
				["Evendim"] = 0
			},
			["F-Z"] = {
				["All"] = 0,
				["Far Anórien"] = {
					["All"] = 0,
					["Minas Tirith"] = 0,
					["Pelennor"] = 0,
					["Unknown"] = 0
				},
				["Festival Grounds"] = {
					["All"] = 0,
					["Frostbluff"] = 0
				},
				["Forochel"] = 0,
				["Great River"] = 0,
				["Gundabad"] = {
					["All"] = 0,
					["Clovengap"] = 0,
					["Deepscrave"] = 0,
					["Dhúrstrok"] = 0,
					["Gloomingtarn"] = 0,
					["Pit of Stonejaws"] = 0,
					["Unknown"] = 0
				},
				["Imhûlar"] = {
					["All"] = 0,
					["Sugâkh Mire"] = 0,
					["Unknown"] = 0
				},
				["Ithilien"] = {
					["All"] = 0,
					["North Ithilien"] = 0
				},
				["Khûd Zagin"] = {
					["All"] = 0,
					["Sang Dûshu"] = 0,
					["Unknown"] = 0
				},
				["King's Gondor"] = {
					["All"] = 0,
					["Blackroot Vale (King's Gondor)"] = 0,
					["Lossarnach (King's Gondor)"] = 0,
					["Lower Lebennin (King's Gondor)"] = 0,
					["Upper Lebennin (King's Gondor)"] = 0
				},
				["Lone-lands"] = {
					["All"] = 0,
					["Annunlos"] = 0,
					["Unknown"] = 0
				},
				["Lothlórien"] = 0,
				["Mirkwood"] = {
					["All"] = 0,
					["Dol Guldur"] = 0,
					["Unknown"] = 0
				},
				["Misty Mountains"] = {
					["All"] = 0,
					["Helegrod"] = 0,
					["Northern High Pass"] = 0,
					["Unknown"] = 0
				},
				["Mordor"] = {
					["All"] = 0,
					["Agarnaith"] = 0,
					["Gorgoroth"] = 0,
					["Imlad Morgul"] = 0,
					["Minas Morgul"] = 0,
					["Mordath"] = 0,
					["Talath Úrui"] = 0
				},
				["Moria"] = {
					["All"] = 0,
					["Flaming Deeps"] = 0,
					["Foundations of Stone"] = 0,
					["Grand Stair"] = 0,
					["Silvertine Lodes"] = 0,
					["Unknown"] = 0,
					["Water-works"] = 0,
					["Zirakzigil"] = 0
				},
				["North Downs"] = {
					["All"] = 0,
					["Stoneheight"] = 0,
					["Unknown"] = 0
				},
				["Old Anórien"] = 0,
				["Pinnath Gelin"] = 0,
				["Rohan - Eastemnet"] = {
					["All"] = 0,
					["East Wall"] = 0,
					["Eaves of Fangorn"] = 0,
					["Entwash Vale"] = 0,
					["Norcrofts"] = 0
				},
				["Rohan - Westemnet"] = {
					["All"] = 0,
					["Broadacres"] = 0,
					["Eastfold"] = 0,
					["Isengard"] = 0,
					["Kingstead"] = 0,
					["Nan Curunír"] = 0,
					["Stonedeans"] = 0,
					["Westfold"] = 0
				},
				["Rohan - Wildermore"] = {
					["All"] = 0,
					["Balewood"] = 0,
					["Fallows"] = 0,
					["Forlaw"] = 0,
					["High Knolls"] = 0,
					["Whitshaws"] = 0
				},
				["Shield Isles"] = 0,
				["Shire"] = {
					["All"] = 0,
					["Northcotton Farm"] = 0,
					["Unknown"] = 0
				},
				["Strongholds of the North"] = 0,
				["Swanfleet"] = 0,
				["Tales of Yore: Azanulbizar"] = {
					["All"] = 0,
					["Azanulbizar, T.A. 2799"] = 0
				},
				["Trollshaws"] = {
					["All"] = 0,
					["Nan Tornaeth"] = 0,
					["Rivendell Valley"] = 0,
					["Unknown"] = 0
				},
				["Umbar"] = {
					["All"] = 0,
					["Bej Mâgha"] = 0,
					["Umbar Baharbêl, City of the Corsairs"] = 0,
					["Unknown"] = 0
				},
				["Umbar-môkh"] = 0,
				["Unknown"] = 0,
				["Urash Dâr"] = 0,
				["Vales of Anduin"] = 0,
				["Wastes"] = 0,
				["Wells of Langflood"] = 0,
				["Western Gondor"] = 0
			}
		}
	});
end
