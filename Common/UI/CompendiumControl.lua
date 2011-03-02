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
import "Turbine";
import "Turbine.Gameplay";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Compendium.Common";

--[[
	A base window class with reusable constants	and functions defined.
]]
CompendiumControl = class( Turbine.UI.Control );
function CompendiumControl:Constructor()
    Turbine.UI.Control.Constructor( self );
    
    self:SetBlendMode(Turbine.UI.BlendMode.Overlay);
    self:SetMouseVisible(false);    
    self:SetSize(540,445);    
    
    self.itemExampleTpl = "<Examine:IIDDID:0x0000000000000000:0x%s>[%s]<\Examine>";
	self.zones = {"Agamaur (Lone-lands)", "Amon Raith (North Downs)", "Andrath (Bree-land)", "Angmar", "Annúminas (Evendim)", "Annunlos (Lone-lands)", "Arador's End (Ettenmoors)", "Archet (Bree-land)", "Ashenslades (Mirkwood)", "Aughaire (Angmar)", "Barrow-downs (Bree-land)", "Bindbole Wood (Shire)", "Bree (Bree-land)", "Bree-land", "Bridgefields (Shire)", "Bruinen Gorges (Trollshaws)", "Bruinen Source North (Misty Mountains)", "Bruinen Source West (Misty Mountains)", "Buckland  (Bree-land)", "Bullroarer's Sward (Evendim)", "Caras Galadhon (Lothlórien)", "Carn Dûm (Angmar)", "Celondim (Ered Luin)", "Chetwood (Bree-land)", "Cirin-en-Galadh (Lothlórien)", "Coldfells (Ettenmoors)", "Combe (Bree-land)", "Dar-gazag (Ettenmoors)", "Delving Fields (Shire)", "Dol Dinen (North Downs)", "Dol Guldur (Mirkwood)", "Dourstocks (Mirkwood)", "Drownholt (Mirkwood)", "Duillond (Ered Luin)", "Durin's Way (Moria)", "Eastern Malenhad (Angmar)", "Egladil (Lothlórien)", "Elendil's Tomb (Evendim)", "Emyn Lûm (Mirkwood)", "Enedwaith", "Ered Luin", "Eregion", "Eryn Laer (Lothlórien)", "Esteldín (North Downs)", "Ettenmoors", "Evendim", "Falathlorn (Ered Luin)", "Fanged Pit (Moria)", "Fasach-falroid (Angmar)", "Fasach-larran (Angmar)", "Fields of Fornost (North Downs)", "Flaming Deeps (Moria)", "Fordirith (Enedwaith)", "Forochel", "Foundations of Stone (Moria)", "Gabilshathur (Angmar)", "Garth Agarwen (Lone-lands)", "Gathbúrz (Mirkwood)", "Gath Forthnir (Angmar)", "Gelirdor (Lothlórien)", "Giant Halls (Misty Mountains)", "Glâd Ereg (Eregion)", "Glain Vraig (Ettenmoors)", "Global (Middle-earth)", "Gloomglens (Enedwaith)", "Goblin-town (Misty Mountains)", "Gorothlad (Angmar)", "Gramsfoot (Ettenmoors)", "Grand Stair (Moria)", "Great Delving (Moria)", "Greenfields (Shire)", "Green Hill Country (Shire)", "Greenway (North Downs)", "Grimwood Lumber Camp (Ettenmoors)", "Grothum (Ettenmoors)", "Harloeg (Lone-lands)", "Haudh Lin (Ered Luin)", "Helegrod (Misty Mountains)", "Hengstacer Farm (Bree-land)", "High Hollin (Eregion)", "High Moor (Trollshaws)", "Hill (Shire)", "Himbar (Angmar)", "Hithlad (Ettenmoors)", "Hoardale (Ettenmoors)", "Hobbiton-Bywater (Shire)", "Horsefields (Bree-land)", "Imlad Balchorth (Angmar)", "Isendeep (Ettenmoors)", "Itä-mâ (Forochel)", "Jä-rannit (Forochel)", "Kingsfell (North Downs)", "Länsi-mâ (Forochel)", "Lhe Lhechu (Enedwaith)", "Lich Bluffs (Enedwaith)", "Lone-lands", "Lothlórien", "Low Lands (Ered Luin)", "Lugazag (Ettenmoors)", "Maethad (Angmar)", "Marish (Shire)", "Mekhem-bizru (Lothlórien)", "Meluinen (North Downs)", "Middle-earth", "Midgewater Marshes (Bree-land)", "Minas Eriol (Lone-lands)", "Minas Gil (Outside) (Mirkwood)", "Mirk-eaves (Mirkwood)", "Mirkwood", "Mirobel (Eregion)", "Misty Mountains", "Moria", "Mournshaws (Enedwaith)", "Nain Enidh (Lone-lands)", "Nan Amlug East (North Downs)", "Nan Amlug West (North Downs)", "Nan Celebrant (Lothlórien)", "Nanduhirion (Lothlórien)", "Nan Gurth (Angmar)", "Nan Laeglin (Enedwaith)", "Nan Sirannon (Eregion)", "Nan Tornaeth (Trollshaws)", "Nen Harn (Bree-land)", "Nen Hilith (Ered Luin)", "Nimrodel (Lothlórien)", "North Downs", "Northern Barrow-downs (Bree-land)", "Northern Bree-fields (Bree-land)", "Northern Emyn Uial (Evendim)", "Northern High Pass (Misty Mountains)", "North Trollshaws (Trollshaws)", "Nud-melek (Moria)", "Old Forest  (Bree-land)", "Parth Aduial (Evendim)", "Pinglade (Shire)", "Ram Dúath (Angmar)", "Rath Teraig (Ered Luin)", "Redhorn Gate (Eregion)", "Redhorn Lodes (Moria)", "Refuge of Edhelion (pre-instance) (Ered Luin)", "Rift of Nûrz Ghâshu (Angmar)", "Rivendell", "Rivendell Valley (Trollshaws)", "Rushock Bog (Shire)", "Scuttledells (Mirkwood)", "Shire", "Silvertine Lodes (Moria)", "Southern Barrow-downs (Bree-land)", "Southern Bree-fields (Bree-land)", "Southern Emyn Uial (Evendim)", "South Trollshaws (Trollshaws)", "Staddle (Bree-land)", "Steps of Gram (Ettenmoors)", "Talan Revail (Lothlórien)", "Talath Gaun (Lone-lands)", "Tâl Bruinen (Trollshaws)", "Tâl Caradhras (Eregion)", "Talvi-mûri (Forochel)", "Taur Hith (Lothlórien)", "Taur Morvith (Mirkwood)", "Taur Orthon (Forochel)", "Thorin's Gate (Ered Luin)", "Thorin's Hall Homesteads (Ered Luin)", "Thrór's Coomb (Enedwaith)", "Tirith Rhaw (Ettenmoors)", "Tol Ascarnen (Ettenmoors)", "Tookland (Shire)", "Trestlebridge (North Downs)", "Trollshaws", "Twenty-first Hall (Moria)", "Tyl Ruinen (Evendim)", "Tyrn Fornech (Evendim)", "Unknown", "Vale of Thrain (Ered Luin)", "Walls of Moria", "Walls of Moria (Eregion)", "Water-works (Moria)", "Weather Hills (Lone-lands)", "Western Malenhad (Angmar)", "West Gate (Bree-land)", "Willow Glade (Enedwaith)", "Windfells (Enedwaith)", "Zelem-melek (Moria)"};
	self.levels = {"1-5","6-10","11-15","16-20","21-25","26-30","31-35","36-40","41-45","46-50","51-55","56-60","61-65","66-70"};
	self.arcs = {"Abominations", "A Champion's Weapons", "Addie's Missing Sons", "A Dwarf-made Blade", "A Faint Gleam", "A False Trail", "A Foul Wood", "Against the Cold", "Agents of the North", "Agents of the South", "A Gift from the Dwarves", "Agnes and the Bears", "Aid from the East", "Aid the Fallen", "All Glory", "An Army of Worms", "An Elf-swain's Lament", "An End to Enterprise", "Angmar Rising", "Angmar's Army", "An Incorrupt Heart", "An Unsettling Matter", "A Poor Guard", "A Right Proper Place", "A Striking Absence of Boar", "A Strong Shield", "A Tenuous Thread", "Avenging Lachenn", "Axes of the South", "Balin's Camp", "Banding Together", "Banishing the Darkness", "Beacons in the Snow", "Beast of the Bog", "Bedbugs!", "Befuddled Giants", "Beneath the Hanging Tree", "Big Problems", "Blackwold Valuables", "Blood-price", "Bogbereth", "Bolster the Defences", "Breakfast in the Ruins", "Breaking the Front Lines", "Breaking the Pincer", "Breathing Space", "Bree-land Epic Prologue", "Bree-land Introduction", "Brew-master", "Brotherly Bond", "Calming the Wake", "Canopy and Hollow", "Capture the Bride", "Caradhras the Cruel", "Cauldron of Death", "Churning Wheel", "Coming Battles", "Common Blood", "Craftsman of Destruction", "Crannog's Challenge", "Crebain of Caradhras", "Crebain on the Ridge", "Dangers in the High Passes", "Dark Delvings", "Dark Vengeance", "Defending the Harvest", "Delf-View: Dwarf Doors", "Dim Memories of the Dark", "Dire Pack", "Drake-hunter", "Drummers of the Deep", "Durin's Stone", "Dwaling's Plight", "Dwarves and Mammoths", "Eldo and Asphodel", "Entering the Vile Maw", "Ered Luin Epic Prologue (Dwarf Path)", "Ered Luin Epic Prologue (Elf Path)", "Ered Luin Epic Prologue (United Path)", "Ered Luin Introduction", "Every Last Ingot", "Falco's Garden", "False Orders", "Fangs for Nothing", "Farmer's Bane", "Feathered Foes", "Fell Beasts", "Fighting the Brood", "Fighting the Fungus", "Fooling Mazog's Orcs", "Footsteps of the Company", "Forerunners", "Forests of Emyn Lûm", "Forges of Khazad-dûm", "Forts of Taur Morvith", "Foul Waters", "Free the Fallen", "Fresh Steeds", "Friendships Renewed", "Fungus", "Furred Worms", "Gauradan Curse", "General's Command", "Gentle Giants", "Ghash-Hai", "Ghost of the Old Took", "Giant Footprints", "Glass Spiders", "Goblin Fire", "Goblins in the Marshes", "Goblins of the Great Delving", "Goblin Threat", "Graves of Dol Guldur", "Grodbog Young", "Hallowed Ground", "Herald of War", "Herding Elk", "Hidden by Drifts", "Hiders and Seekers", "Hiding Their Passage", "Highwayman", "Hillmen of the North", "History in the Barrow-downs", "History of the Red-maid", "Hobgoblin's Recipe", "Hot Pie Delivery", "Hunting for sport", "Hunting: Serious Business", "In His Memory", "Inn Troubles", "In the Foe's Grasp", "Into the Woods", "Invaders of Barad Morlas", "Investigating Goblin-town", "Jaws of the Enemy", "Joy in the Time of Sorrow", "Jury Rigged", "Kemp the Wheelwright", "Krithmog's Collar", "Learned in Letters", "Lest We Forget", "Lifting the Yoke", "Líkmund's Tasks", "Little Menaces", "Little Revolution", "Lobelia's Fireworks", "Long Live the Queen", "Long Overdue Justice", "Lord of the Gertheryg", "Lost Fellowship: the Burglar", "Lost Innocence", "Lurking in the Shadows", "Making the Rounds", "Master of the Maethad", "Menace in the Midgewater", "Mighty Giants Indeed", "Mincham's Dream", "Missing the Meeting", "Mistress of Shadows", "Moria Reclamation", "My Brethren's Call", "New Neighbours", "Nightmares of the Deep", "Noble Deeds", "Old Bones", "Old Forestry", "Oppression's Yoke", "Orcs of Mordor", "Orcs of Moria", "Out of the Mines", "Peasant Halls", "Peikko-slayer", "Pembar's Unwelcome Visitors", "Planting Anew", "Poisoned Well", "Preparation for War", "Prospector of Angmar", "Protecting the Mammoths", "Protecting the Refugees", "Provisions for the Mines", "Pulling Beards", "Quelling the Storm", "Rejecting Mazog", "Repairing the Damage", "Restoration", "Riddles in the Dark", "Riders in the Dale", "Riders of the North", "Rock-worms", "Rune Rocks", "Sabretooth Isle", "Scaled Menace", "Scales of Vengeance", "Schemes of Sabotage", "Servants of the Enemy", "Shadow Map", "Shadows from Afar", "Shady Business", "Shattering the Alliance", "Shield-brother", "Shipment from Rivendell", "Shire Epic Prologue", "Sickening of the Land", "Skinning Beasts", "Skumfíl", "Sky Fall", "Song of the Red Swamp", "Spectre of the Black Rider", "Spider-bane", "Spider Plague", "Staying Agile", "Stealing Stores", "Stemming the Tide", "Stirrings in the Old Forest", "Stirrings Within Helegrod", "Stonecarver's Stash", "Stopping the Siege", "Stopping the Spread of Death", "Strange Beasts", "Strength of Stone", "Sundered Shield", "Swamp-dweller", "Tainted Living", "Techniques of the Masters", "The Baying of Wolves", "The Black Fire", "The Black Tide of Angmar", "The Blade That Was Broken", "The Boldest Road", "The Bravest Deed", "The Burning Island", "The Cat's Meow", "The Creeping Shadow", "The Dunlendings of Nan Sirannon", "The Durub", "The Dwarf-canal", "The Eglain - Honourless People", "The Eglain - People of the Lone-lands", "The Father-lode", "The Fell Ruins", "The Finest Melody", "The Finest Shield in the Land", "The Forgotten Treasury", "The Forsaken Lone-lands", "The Founder's Book", "The Founding Writ", "The Fungus Among Us", "The Garrison of Gondamon", "The Grand Stair", "The Great Escape", "The Great Pie Crust Robbery", "The Grim Tower", "The Hand of the Enemy", "The History of Audaghaim", "The Host of Flame", "The Icereave Mines", "The Last Farm", "The Lost Explorers", "The Lost Fellowship Lore-Master", "The Masters of Moria", "The Mysterious Affliction", "The Noblest Path", "The Oathbreakers", "The Path from Rivendell", "The Path of Healing Hands", "The Path of the Ancient Master", "The Path of the Defender of the Free", "The Path of the Martial Champion", "The Path of the Masterful Fist", "The Path of the Mischief Maker", "The Path of the Rune of Restoration", "The Path of the Trapper", "The Path of the Watcher of Resolve", "The Puzzle-vault", "The Riddle-game", "The Ruins of Barad Morlas", "The Ruins of Pembar", "The Search for Idalene", "The Sky is Falling", "The Southern Flank", "The Southern Road", "The Swiftest Arrow", "The Thief-takers", "The Treasure Hoard of Dannenglor", "The Treasure Hunt", "The Truest Course", "The Veiled Menace", "The Vigilance Committee", "The Water-wheels", "The Wild Ruins", "The Wisest Way", "The Wood-cutter's Tale", "The Wood of Sâd Rechu", "The Wroth Glade", "Thinning the Horde", "Thornley's Farm", "Threatened Camps", "Threat from the North", "Thunder in the Mountains", "Toad Stews", "Took and Tower", "Traders from Bree", "Traitors in the Midst", "Triumph and Tragedy", "Trouble at Nen Hilith", "Twisted Forest", "Unfair Cost of Business", "Valley of the Worms", "Vengeance for the Lost", "Villains in the Vale", "Vintner's Aid", "Volume I, Book 10: The City of the Kings", "Volume I, Book 11: Prisoner of the Free Peoples", "Volume I, Book 12: The Ashen Wastes", "Volume I, Book 13: Doom of the Last-king", "Volume I, Book 14: The Ring-forges of Eregion", "Volume I, Book 1: Stirrings in the Darkness", "Volume I, Book 2: The Red Maid", "Volume I, Book 3: The Council of the North", "Volume I, Book 5: Chasing Shadows", "Volume I, Book 5: The Last Refuge", "Volume I, Book 6: Fires in the North", "Volume I, Book 7: The Hidden Hope", "Volume I, Book 8: The Scourge of the North", "Volume I, Book 9: The Shores of Evendim", "Volume II, Book 1: The Walls of Moria", "Volume II, Book 2: Echoes in the Dark", "Volume II, Book 3: The Lord of Moria", "Volume II, Book 4: Fire and Water", "Volume II, Book 5: Drums in the Deep", "Volume II, Book 6: The Shadowy Abyss", "Volume II, Book 7: Leaves of Lórien", "Volume II, Book 8: Scourge of Khazad-dûm", "Volume III, Book 1: Oath of the Rangers", "War Against Lothórien", "Warg Poachers", "Wargs of Shadow", "Warning Signs", "Webs of Treachery", "Welcome to Bree-town", "Well-prepared", "Western Insects", "White-Hand Orders", "Winged Host", "Wolf-keepers of Barad Morlas", "Wolves at the Door", "Wolves of the Scrub", "Worms on the Heights", "Worries from Waymeet", "Worth of a Worker", "Wraiths of Fornost"};

    self.fontColor=Turbine.UI.Color(1,.9,.5);
    self.backColor=Turbine.UI.Color(.05,.05,.05);
    self.selBackColor=Turbine.UI.Color(.09,.09,.09);
    self.trimColor=Turbine.UI.Color(.75,.75,.75);
    self.colorDarkGrey=Turbine.UI.Color(.1,.1,.1);
    self.fontFace=Turbine.UI.Lotro.Font.TrajanPro14;
    self.fontFaceSmall=Turbine.UI.Lotro.Font.Verdana12;
    
    -- colors for quest levels
    self.purple = Turbine.UI.Color(1,0,1);
    self.red = Turbine.UI.Color(1,0,0);
    self.orange = Turbine.UI.Color(1,0.5,0);
    self.yellow = Turbine.UI.Color(1,1,0);
    self.white = Turbine.UI.Color(1,1,1);
    self.darkBlue = Turbine.UI.Color(0,0,1);
    self.lightBlue = Turbine.UI.Color(0,0.6,0.6);
    self.green = Turbine.UI.Color(0,0.7,0);
    self.gray = Turbine.UI.Color(0.3,0.3,0.3);

end

function CompendiumControl:GetLevelColor(playerLevel, level)
    --[[
    1, 0, 1 : Purple = more than 8 levels above you. You'll probably die if you attempt it.
    1, 0, 0 : Red = 5 -8 levels above you. Very tough fight and expect lots of resists. You'll survive but barely and try not to take on multiples.
    1, 0.5, 0 : Orange = 3-4 levels above you. Manageable but you'll barely crit.
    1, 1, 0 : Yellow = 1-2 levels above you. Not so difficult and you'll crit a bit.
    1, 1, 1 : White = On level.
    0, 0, 1 : Dark Blue = 1-2 levels below you. Still good xp and you'll crit more often against mobs
    0, 0.6, 0.6 :  Light Blue = 3-4 levels below you. Not much xp because it's not a challenge.
    0, 0.7, 0 : Green = 5-8 levels below you. Snoozer, don't bother
    0.3, 0.3, 0.3 : Gray = more than 8 levels below you.
    ]]
    local diff = playerLevel - level;

    if diff < -8 then
        return self.purple;
    elseif diff <= -5 then
        return self.red;
    elseif diff <= -3 then
        return self.orange;
    elseif diff <= -1 then
        return self.yellow;
    elseif diff == 0 then
        return self.white;
    elseif diff > 8 then
        return self.gray;
    elseif diff >= 5 then
        return self.green;
    elseif diff >= 3 then
        return self.lightBlue;
    elseif diff >= 1 then
        return self.darkBlue;
    else
        return self.white;
    end
    
end

-- to easily debug an array or table
function CompendiumControl:tostring(set)
  if set == nil then return "nil"; end
  local s = "{"
  local sep = ""
  for i,e in pairs(set) do
    s = s .. sep .. e
    sep = ", "
  end
  return s .. "}"
end
