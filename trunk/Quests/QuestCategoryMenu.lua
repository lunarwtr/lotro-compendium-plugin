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

QuestCategoryMenu = class( Compendium.Common.UI.CategoryMenu );
function QuestCategoryMenu:Constructor()
    Compendium.Common.UI.CategoryMenu.Constructor( self, {
			["Faction"]={
				["Free People"]=0,
				["Monster"]=0
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
				["Custom"]=0
				},
			["Quest Chains"]={
				["A-I"]={
					["A"]={
						["Abominations"]=0,
						["A Champion's Weapons"]=0,
						["Addie's Missing Sons"]=0,
						["A Dwarf-made Blade"]=0,
						["A Faint Gleam"]=0,
						["A False Trail"]=0,
						["A Foul Wood"]=0,
						["Against the Cold"]=0,
						["Agents of the North"]=0,
						["Agents of the South"]=0,
						["A Gift from the Dwarves"]=0,
						["Agnes and the Bears"]=0,
						["Aid from the East"]=0,
						["Aid the Fallen"]=0,
						["All Glory"]=0,
						["An Army of Worms"]=0,
						["An Elf-swain's Lament"]=0,
						["An End to Enterprise"]=0,
						["Angmar Rising"]=0,
						["Angmar's Army"]=0,
						["An Incorrupt Heart"]=0,
						["An Unsettling Matter"]=0,
						["A Poor Guard"]=0,
						["A Right Proper Place"]=0,
						["A Striking Absence of Boar"]=0,
						["A Strong Shield"]=0,
						["A Tenuous Thread"]=0,
						["Avenging Lachenn"]=0,
						["Axes of the South"]=0
						},
					["B"]={
						["Balin's Camp"]=0,
						["Banding Together"]=0,
						["Banishing the Darkness"]=0,
						["Beacons in the Snow"]=0,
						["Beast of the Bog"]=0,
						["Bedbugs!"]=0,
						["Befuddled Giants"]=0,
						["Beneath the Hanging Tree"]=0,
						["Big Problems"]=0,
						["Blackwold Valuables"]=0,
						["Blood-price"]=0,
						["Bogbereth"]=0,
						["Bolster the Defences"]=0,
						["Breakfast in the Ruins"]=0,
						["Breaking the Front Lines"]=0,
						["Breaking the Pincer"]=0,
						["Breathing Space"]=0,
						["Bree-land Introduction"]=0,
						["Brew-master"]=0,
						["Brotherly Bond"]=0,
						["The Baying of Wolves"]=0,
						["The Black Fire"]=0,
						["The Black Tide of Angmar"]=0,
						["The Blade That Was Broken"]=0,
						["The Boldest Road"]=0,
						["The Bravest Deed"]=0,
						["The Burning Island"]=0
						},
					["C"]={
						["Calming the Wake"]=0,
						["Capture the Bride"]=0,
						["Caradhras the Cruel"]=0,
						["Cauldron of Death"]=0,
						["Churning Wheel"]=0,
						["Coming Battles"]=0,
						["Common Blood"]=0,
						["Craftsman of Destruction"]=0,
						["Crannog's Challenge"]=0,
						["Crebain of Caradhras"]=0,
						["Crebain on the Ridge"]=0,
						["The Cat's Meow"]=0,
						["The Creeping Shadow"]=0
						},
					["D"]={
						["Dangers in the High Passes"]=0,
						["Dark Delvings"]=0,
						["Dark Vengeance"]=0,
						["Defending the Harvest"]=0,
						["Delf-View: Dwarf Doors"]=0,
						["Dim Memories of the Dark"]=0,
						["Dire Pack"]=0,
						["Drake-hunter"]=0,
						["Drummers of the Deep"]=0,
						["Durin's Stone"]=0,
						["Dwaling's Plight"]=0,
						["Dwarves and Mammoths"]=0,
						["The Dunlendings of Nan Sirannon"]=0,
						["The Durub"]=0,
						["The Dwarf-canal"]=0
						},
					["E"]={
						["Eldo and Asphodel"]=0,
						["Entering the Vile Maw"]=0,
						["Ered Luin Introduction"]=0,
						["Every Last Ingot"]=0,
						["The Eglain - Honourless People"]=0,
						["The Eglain - People of the Lone-lands"]=0
						},
					["F"]={
						["Falco's Garden"]=0,
						["False Orders"]=0,
						["Fangs for Nothing"]=0,
						["Farmer's Bane"]=0,
						["Feathered Foes"]=0,
						["Fell Beasts"]=0,
						["Fighting the Brood"]=0,
						["Fighting the Fungus"]=0,
						["Fooling Mazog's Orcs"]=0,
						["Footsteps of the Company"]=0,
						["Forerunners"]=0,
						["Forests of Emyn Lûm"]=0,
						["Forges of Khazad-dûm"]=0,
						["Forts of Taur Morvith"]=0,
						["Foul Waters"]=0,
						["Free the Fallen"]=0,
						["Fresh Steeds"]=0,
						["Friendships Renewed"]=0,
						["Fungus"]=0,
						["Furred Worms"]=0,
						["The Father-lode"]=0,
						["The Fell Ruins"]=0,
						["The Finest Melody"]=0,
						["The Finest Shield in the Land"]=0,
						["The Forgotten Treasury"]=0,
						["The Forsaken Lone-lands"]=0,
						["The Founder's Book"]=0,
						["The Founding Writ"]=0,
						["The Fungus Among Us"]=0
						},
					["G"]={
						["Gauradan Curse"]=0,
						["General's Command"]=0,
						["Gentle Giants"]=0,
						["Ghash-Hai"]=0,
						["Ghost of the Old Took"]=0,
						["Giant Footprints"]=0,
						["Glass Spiders"]=0,
						["Goblin Fire"]=0,
						["Goblins in the Marshes"]=0,
						["Goblins of the Great Delving"]=0,
						["Goblin Threat"]=0,
						["Graves of Dol Guldur"]=0,
						["Grodbog Young"]=0,
						["The Garrison of Gondamon"]=0,
						["The Grand Stair"]=0,
						["The Great Escape"]=0,
						["The Great Pie Crust Robbery"]=0,
						["The Grim Tower"]=0
						},
					["H"]={
						["Hallowed Ground"]=0,
						["Herald of War"]=0,
						["Herding Elk"]=0,
						["Hidden by Drifts"]=0,
						["Hiders and Seekers"]=0,
						["Hiding Their Passage"]=0,
						["Highwayman"]=0,
						["Hillmen of the North"]=0,
						["History in the Barrow-downs"]=0,
						["History of the Red-maid"]=0,
						["Hobgoblin's Recipe"]=0,
						["Hot Pie Delivery"]=0,
						["Hunting for sport"]=0,
						["Hunting: Serious Business"]=0,
						["The Hand of the Enemy"]=0,
						["The History of Audaghaim"]=0,
						["The Host of Flame"]=0
						},
					["I"]={
						["In His Memory"]=0,
						["Inn Troubles"]=0,
						["In the Foe's Grasp"]=0,
						["Into the Woods"]=0,
						["Invaders of Barad Morlas"]=0,
						["Investigating Goblin-town"]=0,
						["The Icereave Mines"]=0
						}
					},
				["Epics"]={
					["Prologue"]={
						["Bree-land Epic Prologue"]=0,
						["Ered Luin Epic Prologue (Dwarf Path)"]=0,
						["Ered Luin Epic Prologue (Elf Path)"]=0,
						["Ered Luin Epic Prologue (United Path)"]=0,
						["Shire Epic Prologue"]=0
						},
					["Volume I"]={
						["Volume I, Book 10: The City of the Kings"]=0,
						["Volume I, Book 11: Prisoner of the Free Peoples"]=0,
						["Volume I, Book 12: The Ashen Wastes"]=0,
						["Volume I, Book 13: Doom of the Last-king"]=0,
						["Volume I, Book 14: The Ring-forges of Eregion"]=0,
						["Volume I, Book 1: Stirrings in the Darkness"]=0,
						["Volume I, Book 2: The Red Maid"]=0,
						["Volume I, Book 3: The Council of the North"]=0,
						["Volume I, Book 5: Chasing Shadows"]=0,
						["Volume I, Book 5: The Last Refuge"]=0,
						["Volume I, Book 6: Fires in the North"]=0,
						["Volume I, Book 7: The Hidden Hope"]=0,
						["Volume I, Book 8: The Scourge of the North"]=0,
						["Volume I, Book 9: The Shores of Evendim"]=0
						},
					["Volume II"]={
						["Volume II, Book 1: The Walls of Moria"]=0,
						["Volume II, Book 2: Echoes in the Dark"]=0,
						["Volume II, Book 3: The Lord of Moria"]=0,
						["Volume II, Book 4: Fire and Water"]=0,
						["Volume II, Book 5: Drums in the Deep"]=0,
						["Volume II, Book 6: The Shadowy Abyss"]=0,
						["Volume II, Book 7: Leaves of Lórien"]=0,
						["Volume II, Book 8: Scourge of Khazad-dûm"]=0
						},
					["Volume III"]={
						["Volume III, Book 1: Oath of the Rangers"]=0,
						["Volume III, Book 2: Ride of the Grey Company"]=0,
						["Volume III, Book 3: Echoes of the Dead"]=0
						}
					},
				["J-Z"]={
					["J"]={
						["Jaws of the Enemy"]=0,
						["Joy in the Time of Sorrow"]=0,
						["Jury Rigged"]=0
						},
					["K"]={
						["Kemp the Wheelwright"]=0,
						["Krithmog's Collar"]=0
						},
					["L"]={
						["Learned in Letters"]=0,
						["Lest We Forget"]=0,
						["Lifting the Yoke"]=0,
						["Líkmund's Tasks"]=0,
						["Little Menaces"]=0,
						["Little Revolution"]=0,
						["Lobelia's Fireworks"]=0,
						["Long Live the Queen"]=0,
						["Long Overdue Justice"]=0,
						["Lord of the Gertheryg"]=0,
						["Lost Fellowship: the Burglar"]=0,
						["Lost Innocence"]=0,
						["Lurking in the Shadows"]=0,
						["The Last Farm"]=0,
						["The Lost Explorers"]=0,
						["The Lost Fellowship Lore-Master"]=0
						},
					["M"]={
						["Making the Rounds"]=0,
						["Master of the Maethad"]=0,
						["Menace in the Midgewater"]=0,
						["Mighty Giants Indeed"]=0,
						["Mincham's Dream"]=0,
						["Missing the Meeting"]=0,
						["Mistress of Shadows"]=0,
						["Moria Reclamation"]=0,
						["My Brethren's Call"]=0,
						["The Masters of Moria"]=0,
						["The Mysterious Affliction"]=0
						},
					["N"]={
						["New Neighbours"]=0,
						["Nightmares of the Deep"]=0,
						["Noble Deeds"]=0,
						["The Noblest Path"]=0
						},
					["O"]={
						["Old Bones"]=0,
						["Old Forestry"]=0,
						["Oppression's Yoke"]=0,
						["Orcs of Mordor"]=0,
						["Orcs of Moria"]=0,
						["Out of the Mines"]=0,
						["The Oathbreakers"]=0
						},
					["P"]={
						["Peasant Halls"]=0,
						["Peikko-slayer"]=0,
						["Pembar's Unwelcome Visitors"]=0,
						["Planting Anew"]=0,
						["Poisoned Well"]=0,
						["Preparation for War"]=0,
						["Prospector of Angmar"]=0,
						["Protecting the Mammoths"]=0,
						["Protecting the Refugees"]=0,
						["Provisions for the Mines"]=0,
						["Pulling Beards"]=0,
						["The Path from Rivendell"]=0,
						["The Path of Healing Hands"]=0,
						["The Path of the Ancient Master"]=0,
						["The Path of the Defender of the Free"]=0,
						["The Path of the Martial Champion"]=0,
						["The Path of the Masterful Fist"]=0,
						["The Path of the Mischief Maker"]=0,
						["The Path of the Rune of Restoration"]=0,
						["The Path of the Trapper"]=0,
						["The Path of the Watcher of Resolve"]=0,
						["The Puzzle-vault"]=0
						},
					["Q"]={
						["Quelling the Storm"]=0
						},
					["R"]={
						["Rejecting Mazog"]=0,
						["Repairing the Damage"]=0,
						["Restoration"]=0,
						["Riddles in the Dark"]=0,
						["Riders in the Dale"]=0,
						["Riders of the North"]=0,
						["Rock-worms"]=0,
						["Rune Rocks"]=0,
						["The Riddle-game"]=0,
						["The Ruins of Barad Morlas"]=0,
						["The Ruins of Pembar"]=0
						},
					["S"]={
						["Sabretooth Isle"]=0,
						["Scaled Menace"]=0,
						["Scales of Vengeance"]=0,
						["Schemes of Sabotage"]=0,
						["Servants of the Enemy"]=0,
						["Shadow Map"]=0,
						["Shadows from Afar"]=0,
						["Shady Business"]=0,
						["Shattering the Alliance"]=0,
						["Shield-brother"]=0,
						["Shipment from Rivendell"]=0,
						["Sickening of the Land"]=0,
						["Skinning Beasts"]=0,
						["Skumfíl"]=0,
						["Sky Fall"]=0,
						["Song of the Red Swamp"]=0,
						["Spectre of the Black Rider"]=0,
						["Spider-bane"]=0,
						["Spider Plague"]=0,
						["Staying Agile"]=0,
						["Stealing Stores"]=0,
						["Stemming the Tide"]=0,
						["Stirrings in the Old Forest"]=0,
						["Stirrings Within Helegrod"]=0,
						["Stonecarver's Stash"]=0,
						["Stopping the Siege"]=0,
						["Strange Beasts"]=0,
						["Strength of Stone"]=0,
						["Sundered Shield"]=0,
						["Swamp-dweller"]=0,
						["The Search for Idalene"]=0,
						["The Sky is Falling"]=0,
						["The Southern Flank"]=0,
						["The Southern Road"]=0,
						["The Swiftest Arrow"]=0
						},
					["T"]={
						["Tainted Living"]=0,
						["Techniques of the Masters"]=0,
						["The Thief-takers"]=0,
						["The Treasure Hoard of Dannenglor"]=0,
						["The Treasure Hunt"]=0,
						["The Truest Course"]=0,
						["Thinning the Horde"]=0,
						["Thornley's Farm"]=0,
						["Threatened Camps"]=0,
						["Threat from the North"]=0,
						["Thunder in the Mountains"]=0,
						["Toad Stews"]=0,
						["Took and Tower"]=0,
						["Traders from Bree"]=0,
						["Traitors in the Midst"]=0,
						["Triumph and Tragedy"]=0,
						["Trouble at Nen Hilith"]=0,
						["Twisted Forest"]=0
						},
					["U"]={
						["Unfair Cost of Business"]=0
						},
					["V"]={
						["The Veiled Menace"]=0,
						["The Vigilance Committee"]=0,
						["Valley of the Worms"]=0,
						["Vengeance for the Lost"]=0,
						["Villains in the Vale"]=0,
						["Vintner's Aid"]=0
						},
					["W"]={
						["The Water-wheels"]=0,
						["The Wild Ruins"]=0,
						["The Wisest Way"]=0,
						["The Wood-cutter's Tale"]=0,
						["The Wood of Sâd Rechu"]=0,
						["The Wroth Glade"]=0,
						["War Against Lothórien"]=0,
						["Warg Poachers"]=0,
						["Wargs of Shadow"]=0,
						["Warning Signs"]=0,
						["Webs of Treachery"]=0,
						["Welcome to Bree-town"]=0,
						["Well-prepared"]=0,
						["Western Insects"]=0,
						["White-Hand Orders"]=0,
						["Winged Host"]=0,
						["Wolf-keepers of Barad Morlas"]=0,
						["Wolves at the Door"]=0,
						["Wolves of the Scrub"]=0,
						["Worms on the Heights"]=0,
						["Worries from Waymeet"]=0,
						["Worth of a Worker"]=0,
						["Wraiths of Fornost"]=0
						}
					}
				},
			["Progression"]={
				["Complete"]=0,
				["Incomplete"]=0,
				},
			["Quest Type"]={
				["Epic"]=0,
				["Fellowship"]=0,
				["Raid"]=0,
				["Repeatable"]=0,
				["Small Fellowship"]=0
				},
			["Rewarded"]={
				["Dest Pts"]=0,
				["Items"]=0,
				["Money"]=0,
				["Rep"]=0,
				["Titles"]=0,
				["Traits"]=0
				},
			["Zone"]={
				["A-E"]={
					["Angmar"]={
						["All"]=0,
						["Aughaire"]=0,
						["Carn Dûm"]=0,
						["Eastern Malenhad"]=0,
						["Fasach-falroid"]=0,
						["Fasach-larran"]=0,
						["Gabilshathur"]=0,
						["Gath Forthnir"]=0,
						["Gorothlad"]=0,
						["Himbar"]=0,
						["Imlad Balchorth"]=0,
						["Maethad"]=0,
						["Nan Gurth"]=0,
						["Ram Dúath"]=0,
						["Rift of Nûrz Ghâshu"]=0,
						["Western Malenhad"]=0
						},
					["Bree-land"]={
						["All"]=0,
						["Andrath"]=0,
						["Archet"]=0,
						["Bree"]=0,
						["Brigand Cave"]=0,
						["Buckland"]=0,
						["Chetwood"]=0,
						["Combe"]=0,
						["Hengstacer Farm"]=0,
						["Horsefields"]=0,
						["Midgewater Marshes"]=0,
						["Nen Harn"]=0,
						["Northern Barrow-downs"]=0,
						["Northern Bree-fields"]=0,
						["Old Forest"]=0,
						["Southern Barrow-downs"]=0,
						["Southern Bree-fields"]=0,
						["Staddle"]=0,
						["West Gate"]=0
						},
					["Enedwaith"]={
						["All"]=0,
						["Fordirith"]=0,
						["Gloomglens"]=0,
						["Lich Bluffs"]=0,
						["Mournshaws"]=0,
						["Nan Laeglin"]=0,
						["Thrór's Coomb"]=0,
						["Willow Glade"]=0,
						["Windfells"]=0
						},
					["Ered Luin"]={
						["All"]=0,
						["Celondim"]=0,
						["Duillond"]=0,
						["Falathlorn"]=0,
						["Haudh Lin"]=0,
						["Kheledûl"]=0,
						["Low Lands"]=0,
						["Rath Teraig"]=0,
						["Refuge of Edhelion (pre-instance)"]=0,
						["Thorin's Gate"]=0,
						["Thorin's Hall Homesteads"]=0,
						["Unknown"]=0,
						["Vale of Thrain"]=0
						},
					["Eregion"]={
						["All"]=0,
						["Glâd Ereg"]=0,
						["High Hollin"]=0,
						["Mirobel"]=0,
						["Nan Sirannon"]=0,
						["Redhorn Gate"]=0,
						["Tâl Caradhras"]=0,
						["Walls of Moria"]=0
						},
					["Ettenmoors"]={
						["All"]=0,
						["Arador's End"]=0,
						["Coldfells"]=0,
						["Dar-gazag"]=0,
						["Glain Vraig"]=0,
						["Gramsfoot"]=0,
						["Grimwood Lumber Camp"]=0,
						["Grothum"]=0,
						["Hithlad"]=0,
						["Hoardale"]=0,
						["Isendeep"]=0,
						["Lugazag"]=0,
						["Steps of Gram"]=0,
						["Tirith Rhaw"]=0,
						["Tol Ascarnen"]=0,
						["Unknown"]=0
						},
					["Evendim"]={
						["All"]=0,
						["Annúminas"]=0,
						["Barandalf"]=0,
						["Bullroarer's Sward"]=0,
						["Dwaling"]=0,
						["Elendil's Tomb"]=0,
						["Men Erain"]=0,
						["Northern Emyn Uial"]=0,
						["Parth Aduial"]=0,
						["Southern Emyn Uial"]=0,
						["Tinnudir"]=0,
						["Tyl Annûn"]=0,
						["Tyl Ruinen"]=0,
						["Tyrn Fornech"]=0,
						["Unknown"]=0
						}
					},
				["F-Z"]={
					["Forochel"]={
						["All"]=0,
						["Itä-mâ"]=0,
						["Jä-rannit"]=0,
						["Länsi-mâ"]=0,
						["Talvi-mûri"]=0,
						["Taur Orthon"]=0
						},
					["Frostbluff"]=0,
					["Lone-lands"]={
						["All"]=0,
						["Agamaur"]=0,
						["Annunlos"]=0,
						["Garth Agarwen"]=0,
						["Harloeg"]=0,
						["Minas Eriol"]=0,
						["Nain Enidh"]=0,
						["Talath Gaun"]=0,
						["Weather Hills"]=0
						},
					["Lothlórien"]={
						["All"]=0,
						["Caras Galadhon"]=0,
						["Cirin-en-Galadh"]=0,
						["Egladil"]=0,
						["Eryn Laer"]=0,
						["Gelirdor"]=0,
						["Mekhem-bizru"]=0,
						["Nan Celebrant"]=0,
						["Nanduhirion"]=0,
						["Nimrodel"]=0,
						["Talan Revail"]=0,
						["Taur Hith"]=0
						},
					["Middle-earth"]={
						["All"]=0,
						["Global"]=0
						},
					["Mirkwood"]={
						["All"]=0,
						["Ashenslades"]=0,
						["Dol Guldur"]=0,
						["Dourstocks"]=0,
						["Drownholt"]=0,
						["Emyn Lûm"]=0,
						["Gathburz"]=0,
						["Gathbúrz"]=0,
						["Minas Gil (Outside)"]=0,
						["Mirk-eaves"]=0,
						["Scuttledells"]=0,
						["Taur Morvith"]=0,
						["Unknown"]=0
						},
					["Misty Mountains"]={
						["All"]=0,
						["Bruinen Source North"]=0,
						["Bruinen Source West"]=0,
						["Giant Halls"]=0,
						["Goblin-town"]=0,
						["Helegrod"]=0,
						["Northern High Pass"]=0
						},
					["Moria"]={
						["All"]=0,
						["Durin's Way"]=0,
						["Fanged Pit"]=0,
						["Flaming Deeps"]=0,
						["Foundations of Stone"]=0,
						["Grand Stair"]=0,
						["Great Delving"]=0,
						["Nud-melek"]=0,
						["Redhorn Lodes"]=0,
						["Silvertine Lodes"]=0,
						["Twenty-first Hall"]=0,
						["Water-works"]=0,
						["Zelem-melek"]=0
						},
					["North Downs"]={
						["All"]=0,
						["Amon Raith"]=0,
						["Annúndir"]=0,
						["Esteldín"]=0,
						["Fields of Fornost"]=0,
						["Greenway"]=0,
						["Kingsfell"]=0,
						["Meluinen"]=0,
						["Nan Amlug East"]=0,
						["Nan Amlug West"]=0,
						["Trestlebridge"]=0
						},
					["Rivendell"]={
						["All"]=0,
						["Unknown"]=0
						},
					["Shire"]={
						["All"]=0,
						["Bindbole Wood"]=0,
						["Bridgefields"]=0,
						["Delving Fields"]=0,
						["Greenfields"]=0,
						["Green Hill Country"]=0,
						["Hill"]=0,
						["Hobbiton-Bywater"]=0,
						["Marish"]=0,
						["Pinglade"]=0,
						["Rushock Bog"]=0,
						["Tookland"]=0
						},
					["Trollshaws"]={
						["All"]=0,
						["Bruinen Gorges"]=0,
						["High Moor"]=0,
						["Nan Tornaeth"]=0,
						["North Trollshaws"]=0,
						["Rivendell Valley"]=0,
						["South Trollshaws"]=0,
						["Tâl Bruinen"]=0,
						["Unknown"]=0
						},
					["Unknown"]=0,
					["Walls of Moria"]=0
					}
				}
			});
end