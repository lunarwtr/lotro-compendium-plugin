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
import "Compendium.Common.Class";

--[[
	A base window class with reusable constants	and functions defined.
]]
CompendiumWindow = class( Turbine.UI.Lotro.Window );
function CompendiumWindow:Constructor()
    Turbine.UI.Lotro.Window.Constructor( self );
    
	self.zones = {"Angmar : Aughaire", "Angmar : Carn Dûm", "Angmar : Eastern Malenhad", "Angmar : Fasach-falroid", "Angmar : Fasach-larran", "Angmar : Gabilshathur", "Angmar : Gath Forthnir", "Angmar : Gorothlad", "Angmar : Himbar", "Angmar : Imlad Balchorth", "Angmar : Maethad", "Angmar : Nan Gurth", "Angmar : Ram Dúath", "Angmar : The Rift of Nûrz Ghâshu", "Angmar : Western Malenhad", "Bree-land : Andrath", "Bree-land : Archet", "Bree-land : Barrow-downs", "Bree-land : Bree", "Bree-land : Buckland", "Bree-land : Chetwood", "Bree-land : Combe", "Bree-land : Hengstacer Farm", "Bree-land : Nen Harn", "Bree-land : Northern Barrow-downs", "Bree-land : Northern Bree-fields", "Bree-land : Old Forest", "Bree-land : Southern Barrow-downs", "Bree-land : Southern Bree-fields", "Bree-land : Staddle", "Bree-land : The Horsefields", "Bree-land : The Midgewater Marshes", "Bree-land : West Gate", "Enedwaith : Fordirith", "Enedwaith : Gloomglens", "Enedwaith : Lhe Lhechu", "Enedwaith : Lich Bluffs", "Enedwaith : Mournshaws", "Enedwaith : Nan Laeglin", "Enedwaith : Thrór's Coomb", "Enedwaith : Willow Glade", "Enedwaith : Windfells", "Ered Luin : Celondim", "Ered Luin : Duillond", "Ered Luin : Falathlorn", "Ered Luin : Haudh Lin", "Ered Luin : Low Lands", "Ered Luin : Nen Hilith", "Ered Luin : Rath Teraig", "Ered Luin : Refuge of Edhelion (pre-instance)", "Ered Luin : Thorin's Gate", "Ered Luin : Thorin's Hall Homesteads", "Ered Luin : Vale of Thrain", "Eregion : Glâd Ereg", "Eregion : High Hollin", "Eregion : Mirobel", "Eregion : Nan Sirannon", "Eregion : Redhorn Gate", "Eregion : Tâl Caradhras", "Eregion : Walls of Moria", "Ettenmoors : Dar-gazag", "Ettenmoors : Glain Vraig", "Ettenmoors : Grimwood Lumber Camp", "Ettenmoors : Grothum", "Ettenmoors : Isendeep", "Ettenmoors : Lugazag", "Ettenmoors : Tirith Rhaw", "Ettenmoors : Tol Ascarnen", "Evendim : Annúminas", "Evendim : Bullroarer's Sward", "Evendim : Elendil's Tomb", "Evendim : Northern Emyn Uial", "Evendim : Parth Aduial", "Evendim : Southern Emyn Uial", "Evendim : Tyl Ruinen", "Evendim : Tyrn Fornech", "Forochel : Itä-mâ", "Forochel : Jä-rannit", "Forochel : Länsi-mâ", "Forochel : Talvi-mûri", "Forochel : Taur Orthon", "Foundations of Stone : Foundations of Stone", "Foundations of Stone : The Shadowed Refuge", "Lone-Lands : Minas Eriol", "Lone-Lands : Talath Gaun", "Lothlórien : Caras Galadhon", "Lothlórien : Cirin-en-Galadh", "Lothlórien : Egladil", "Lothlórien : Eryn Laer", "Lothlórien : Gelirdor", "Lothlorien : Mekhem-bizru", "Lothlórien : Nan Celebrant", "Lothlórien : Nanduhirion", "Lothlórien : Nimrodel", "Lothlorien : Talan Revail", "Lothlórien : Taur Hith", "Middle-earth : Global", "Mirkwood : Ashenslades", "Mirkwood : Dol Guldur", "Mirkwood : Emyn Lum", "Mirkwood : Emyn Lûm", "Mirkwood : Gathbúrz", "Mirkwood : Minas Gil (Outside)", "Mirkwood : Mirk-eaves", "Mirkwood : Taur Morvith", "Mirkwood : The Dourstocks", "Mirkwood : The Drownholt", "Mirkwood : The Scuttledells", "Misty Mountains : Goblin-town", "Moria : Durin's Way", "Moria : Nud-melek", "Moria : Redhorn Lodes", "Moria : Silvertine Lodes", "Moria : The Fanged Pit", "Moria : The Flaming Deeps", "Moria : The Foundations of Stone", "Moria : The Grand Stair", "Moria : The Great Delving", "Moria : The Twenty-first Hall", "Moria : The Water-works", "Moria : Zelem-melek", "North Downs : Amon Raith", "North Downs : Dol Dinen", "The Ettenmoors : Arador's End", "The Ettenmoors : Coldfells", "The Ettenmoors : Gramsfoot", "The Ettenmoors : Hithlad", "The Ettenmoors : Hoardale", "The Ettenmoors : Steps of Gram", "The Lone-lands : Agamaur", "The Lone-lands : Annunlos", "The Lone-lands : Garth Agarwen", "The Lone-lands : Harloeg", "The Lone-lands : Nain Enidh", "The Lone-lands : The Weather Hills", "The Misty Mountains : Bruinen Source North", "The Misty Mountains : Bruinen Source West", "The Misty Mountains : Giant Halls", "The Misty Mountains : Helegrod", "The Misty Mountains : Northern High Pass", "The North Downs : Esteldín", "The North Downs : Fields of Fornost", "The North Downs : Greenway", "The North Downs : Kingsfell", "The North Downs : Meluinen", "The North Downs : Nan Amlug East", "The North Downs : Nan Amlug West", "The North Downs : Trestlebridge", "The Shire : Bindbole Wood", "The Shire : Bridgefields", "The Shire : Greenfields", "The Shire : Green Hill Country", "The Shire : Hobbiton-Bywater", "The Shire : Pinglade", "The Shire : Rushock Bog", "The Shire : The Delving Fields", "The Shire : The Hill", "The Shire : The Marish", "The Shire : Tookland", "The Silvertine Lodes : The Silvertine Lodes", "The Trollshaws : Bruinen Gorges", "The Trollshaws : Nan Tornaeth", "The Trollshaws : North Trollshaws", "The Trollshaws : Rivendell Valley", "The Trollshaws : South Trollshaws", "The Trollshaws : Tâl Bruinen", "The Walls of Moria : The Walls of Moria", "Trollshaws : High Moor", "Trollshaws : Tal Bruinen", "Unknown", "Unknown : Lugazag", "Unknown : Tirith Rhaw", "Unknown : Tol Ascarnen"};
	self.levels = {"1-5","6-10","11-15","16-20","21-25","26-30","31-35","36-40","41-45","46-50","51-55","56-60","61-65","66-70"};
	self.arcs = {"Abominations", "A Champion's Weapons", "Addie's Missing Sons", "A Dwarf-made Blade", "A Faint Gleam", "A False Trail", "A Foul Wood", "Against the Cold", "Agents of the North", "Agents of the South", "A Gift from the Dwarves", "Agnes and the Bears", "Aid from the East", "Aid the Fallen", "All Glory", "An Army of Worms", "An Elf-swain's Lament", "An End to Enterprise", "Angmar Rising", "Angmar's Army", "An Incorrupt Heart", "An Unsettling Matter", "A Poor Guard", "A Right Proper Place", "A Striking Absence of Boar", "A Strong Shield", "A Tenuous Thread", "Avenging Lachenn", "Axes of the South", "Balin's Camp", "Banding Together", "Banishing the Darkness", "Beacons in the Snow", "Beast of the Bog", "Bedbugs!", "Befuddled Giants", "Beneath the Hanging Tree", "Big Problems", "Blackwold Valuables", "Blood-price", "Bogbereth", "Bolster the Defences", "Breakfast in the Ruins", "Breaking the Front Lines", "Breaking the Pincer", "Breathing Space", "Bree-land Epic Prologue", "Bree-land Introduction", "Brew-master", "Brotherly Bond", "Calming the Wake", "Canopy and Hollow", "Capture the Bride", "Caradhras the Cruel", "Cauldron of Death", "Churning Wheel", "Coming Battles", "Common Blood", "Craftsman of Destruction", "Crannog's Challenge", "Crebain of Caradhras", "Crebain on the Ridge", "Dangers in the High Passes", "Dark Delvings", "Dark Vengeance", "Defending the Harvest", "Delf-View: Dwarf Doors", "Dim Memories of the Dark", "Dire Pack", "Drake-hunter", "Drummers of the Deep", "Durin's Stone", "Dwaling's Plight", "Dwarves and Mammoths", "Eldo and Asphodel", "Entering the Vile Maw", "Ered Luin Epic Prologue (Dwarf Path)", "Ered Luin Epic Prologue (Elf Path)", "Ered Luin Epic Prologue (United Path)", "Ered Luin Introduction", "Every Last Ingot", "Falco's Garden", "False Orders", "Fangs for Nothing", "Farmer's Bane", "Feathered Foes", "Fell Beasts", "Fighting the Brood", "Fighting the Fungus", "Fooling Mazog's Orcs", "Footsteps of the Company", "Forerunners", "Forests of Emyn Lûm", "Forges of Khazad-dûm", "Forts of Taur Morvith", "Foul Waters", "Free the Fallen", "Fresh Steeds", "Friendships Renewed", "Fungus", "Furred Worms", "Gauradan Curse", "General's Command", "Gentle Giants", "Ghash-Hai", "Ghost of the Old Took", "Giant Footprints", "Glass Spiders", "Goblin Fire", "Goblins in the Marshes", "Goblins of the Great Delving", "Goblin Threat", "Graves of Dol Guldur", "Grodbog Young", "Hallowed Ground", "Herald of War", "Herding Elk", "Hidden by Drifts", "Hiders and Seekers", "Hiding Their Passage", "Highwayman", "Hillmen of the North", "History in the Barrow-downs", "History of the Red-maid", "Hobgoblin's Recipe", "Hot Pie Delivery", "Hunting for sport", "Hunting: Serious Business", "In His Memory", "Inn Troubles", "In the Foe's Grasp", "Into the Woods", "Invaders of Barad Morlas", "Investigating Goblin-town", "Jaws of the Enemy", "Joy in the Time of Sorrow", "Jury Rigged", "Kemp the Wheelwright", "Krithmog's Collar", "Learned in Letters", "Lest We Forget", "Lifting the Yoke", "Líkmund's Tasks", "Little Menaces", "Little Revolution", "Lobelia's Fireworks", "Long Live the Queen", "Long Overdue Justice", "Lord of the Gertheryg", "Lost Fellowship: the Burglar", "Lost Innocence", "Lurking in the Shadows", "Making the Rounds", "Master of the Maethad", "Menace in the Midgewater", "Mighty Giants Indeed", "Mincham's Dream", "Missing the Meeting", "Mistress of Shadows", "Moria Reclamation", "My Brethren's Call", "New Neighbours", "Nightmares of the Deep", "Noble Deeds", "Old Bones", "Old Forestry", "Oppression's Yoke", "Orcs of Mordor", "Orcs of Moria", "Out of the Mines", "Peasant Halls", "Peikko-slayer", "Pembar's Unwelcome Visitors", "Planting Anew", "Poisoned Well", "Preparation for War", "Prospector of Angmar", "Protecting the Mammoths", "Protecting the Refugees", "Provisions for the Mines", "Pulling Beards", "Quelling the Storm", "Rejecting Mazog", "Repairing the Damage", "Restoration", "Riddles in the Dark", "Riders in the Dale", "Riders of the North", "Rock-worms", "Rune Rocks", "Sabretooth Isle", "Scaled Menace", "Scales of Vengeance", "Schemes of Sabotage", "Servants of the Enemy", "Shadow Map", "Shadows from Afar", "Shady Business", "Shattering the Alliance", "Shield-brother", "Shipment from Rivendell", "Shire Epic Prologue", "Sickening of the Land", "Skinning Beasts", "Skumfíl", "Sky Fall", "Song of the Red Swamp", "Spectre of the Black Rider", "Spider-bane", "Spider Plague", "Staying Agile", "Stealing Stores", "Stemming the Tide", "Stirrings in the Old Forest", "Stirrings Within Helegrod", "Stonecarver's Stash", "Stopping the Siege", "Stopping the Spread of Death", "Strange Beasts", "Strength of Stone", "Sundered Shield", "Swamp-dweller", "Tainted Living", "Techniques of the Masters", "The Baying of Wolves", "The Black Fire", "The Black Tide of Angmar", "The Blade That Was Broken", "The Boldest Road", "The Bravest Deed", "The Burning Island", "The Cat's Meow", "The Creeping Shadow", "The Dunlendings of Nan Sirannon", "The Durub", "The Dwarf-canal", "The Eglain - Honourless People", "The Eglain - People of the Lone-lands", "The Father-lode", "The Fell Ruins", "The Finest Melody", "The Finest Shield in the Land", "The Forgotten Treasury", "The Forsaken Lone-lands", "The Founder's Book", "The Founding Writ", "The Fungus Among Us", "The Garrison of Gondamon", "The Grand Stair", "The Great Escape", "The Great Pie Crust Robbery", "The Grim Tower", "The Hand of the Enemy", "The History of Audaghaim", "The Host of Flame", "The Icereave Mines", "The Last Farm", "The Lost Explorers", "The Lost Fellowship Lore-Master", "The Masters of Moria", "The Mysterious Affliction", "The Noblest Path", "The Oathbreakers", "The Path from Rivendell", "The Path of Healing Hands", "The Path of the Ancient Master", "The Path of the Defender of the Free", "The Path of the Martial Champion", "The Path of the Masterful Fist", "The Path of the Mischief Maker", "The Path of the Rune of Restoration", "The Path of the Trapper", "The Path of the Watcher of Resolve", "The Puzzle-vault", "The Riddle-game", "The Ruins of Barad Morlas", "The Ruins of Pembar", "The Search for Idalene", "The Sky is Falling", "The Southern Flank", "The Southern Road", "The Swiftest Arrow", "The Thief-takers", "The Treasure Hoard of Dannenglor", "The Treasure Hunt", "The Truest Course", "The Veiled Menace", "The Vigilance Committee", "The Water-wheels", "The Wild Ruins", "The Wisest Way", "The Wood-cutter's Tale", "The Wood of Sâd Rechu", "The Wroth Glade", "Thinning the Horde", "Thornley's Farm", "Threatened Camps", "Threat from the North", "Thunder in the Mountains", "Toad Stews", "Took and Tower", "Traders from Bree", "Traitors in the Midst", "Triumph and Tragedy", "Trouble at Nen Hilith", "Twisted Forest", "Unfair Cost of Business", "Valley of the Worms", "Vengeance for the Lost", "Villains in the Vale", "Vintner's Aid", "Volume I, Book 10: The City of the Kings", "Volume I, Book 11: Prisoner of the Free Peoples", "Volume I, Book 12: The Ashen Wastes", "Volume I, Book 13: Doom of the Last-king", "Volume I, Book 14: The Ring-forges of Eregion", "Volume I, Book 1: Stirrings in the Darkness", "Volume I, Book 2: The Red Maid", "Volume I, Book 3: The Council of the North", "Volume I, Book 5: Chasing Shadows", "Volume I, Book 5: The Last Refuge", "Volume I, Book 6: Fires in the North", "Volume I, Book 7: The Hidden Hope", "Volume I, Book 8: The Scourge of the North", "Volume I, Book 9: The Shores of Evendim", "Volume II, Book 1: The Walls of Moria", "Volume II, Book 2: Echoes in the Dark", "Volume II, Book 3: The Lord of Moria", "Volume II, Book 4: Fire and Water", "Volume II, Book 5: Drums in the Deep", "Volume II, Book 6: The Shadowy Abyss", "Volume II, Book 7: Leaves of Lórien", "Volume II, Book 8: Scourge of Khazad-dûm", "Volume III, Book 1: Oath of the Rangers", "War Against Lothórien", "Warg Poachers", "Wargs of Shadow", "Warning Signs", "Webs of Treachery", "Welcome to Bree-town", "Well-prepared", "Western Insects", "White-Hand Orders", "Winged Host", "Wolf-keepers of Barad Morlas", "Wolves at the Door", "Wolves of the Scrub", "Worms on the Heights", "Worries from Waymeet", "Worth of a Worker", "Wraiths of Fornost"};

    self.fontColor=Turbine.UI.Color(1,.9,.5);
    self.backColor=Turbine.UI.Color(.05,.05,.05);
    self.selBackColor=Turbine.UI.Color(.09,.09,.09);
    self.trimColor=Turbine.UI.Color(.75,.75,.75);
    self.colorDarkGrey=Turbine.UI.Color(.1,.1,.1);
    self.fontFace=Turbine.UI.Lotro.Font.TrajanPro14;
    
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

    self:SetSize(560,480);
    local initHeight=480;    
    local initWidth=560;
    local initLeft=(Turbine.UI.Display:GetWidth() - initWidth) / 2;
    local initTop=(Turbine.UI.Display:GetHeight() - initHeight) / 2;    
    self:SetPosition( initLeft, initTop );
    self:SetHeight(initHeight);
    self:SetWidth(initWidth);
    self:SetOpacity( 1 );
    self:SetVisible(false);    

end

function CompendiumWindow:GetLevelColor(playerLevel, level)
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
function CompendiumWindow:tostring(set)
  if set == nil then return "nil"; end
  local s = "{"
  local sep = ""
  for i,e in pairs(set) do
    s = s .. sep .. e
    sep = ", "
  end
  return s .. "}"
end
