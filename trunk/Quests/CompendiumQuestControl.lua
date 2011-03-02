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

import "Compendium.Quests.CompendiumQuestsDB";
import "Compendium.Common";
import "Compendium.Common.UI";

CompendiumQuestControl= class( Compendium.Common.UI.CompendiumControl );
function CompendiumQuestControl:Constructor()
    Compendium.Common.UI.CompendiumControl.Constructor( self );

	self.searchDisabled = true;
    
	self.logo = Turbine.UI.Control();
	self.logo:SetBlendMode(Turbine.UI.BlendMode.Screen);
	self.logo:SetBackground( "Compendium/Common/Resources/images/CompendiumLogoSmall.tga" );
	self.logo:SetPosition(self:GetWidth() - 80 ,0);
	self.logo:SetSize(75,100);
	self.logo:SetParent( self );    
    
    self.ZoneCaption=Turbine.UI.Label();
    self.ZoneCaption:SetParent(self);
    self.ZoneCaption:SetPosition(9,6);
    self.ZoneCaption:SetSize(110,20);
    self.ZoneCaption:SetFont(self.fontFace);
    self.ZoneCaption:SetForeColor(self.fontColor);
    self.ZoneCaption:SetOutlineColor(Turbine.UI.Color(0,0,0));
    self.ZoneCaption:SetFontStyle(Turbine.UI.FontStyle.Outline);
    self.ZoneCaption:SetText("Filter By Zone:");

    self.LevelCaption=Turbine.UI.Label();
    self.LevelCaption:SetParent(self);
    self.LevelCaption:SetPosition(9,31);
    self.LevelCaption:SetSize(110,20);
    self.LevelCaption:SetFont(self.fontFace);
    self.LevelCaption:SetForeColor(self.fontColor);
    self.LevelCaption:SetOutlineColor(Turbine.UI.Color(0,0,0));
    self.LevelCaption:SetFontStyle(Turbine.UI.FontStyle.Outline);
    self.LevelCaption:SetText("Filter By Level:");

    self.ArcCaption=Turbine.UI.Label();
    self.ArcCaption:SetParent(self);
    self.ArcCaption:SetPosition(9,56);
    self.ArcCaption:SetSize(110,20);
    self.ArcCaption:SetFont(self.fontFace);
    self.ArcCaption:SetForeColor(self.fontColor);
    self.ArcCaption:SetOutlineColor(Turbine.UI.Color(0,0,0));
    self.ArcCaption:SetFontStyle(Turbine.UI.FontStyle.Outline);
    self.ArcCaption:SetText("Filter By Chain:");
    
    self.SearchCaption=Turbine.UI.Label();
    self.SearchCaption:SetParent(self);
    self.SearchCaption:SetPosition(9,81);
    self.SearchCaption:SetSize(70,20);
    self.SearchCaption:SetFont(self.fontFace);
    self.SearchCaption:SetForeColor(self.fontColor);
    self.SearchCaption:SetOutlineColor(Turbine.UI.Color(0,0,0));
    self.SearchCaption:SetFontStyle(Turbine.UI.FontStyle.Outline);
    self.SearchCaption:SetText("Search:");

    local searchWidth = self:GetWidth()-(self.SearchCaption:GetWidth()+self.SearchCaption:GetLeft())-140;
    self.SearchBorder=Turbine.UI.Control();
    self.SearchBorder:SetParent(self);
    self.SearchBorder:SetPosition(self.SearchCaption:GetLeft()+self.SearchCaption:GetWidth()+2,self.SearchCaption:GetTop()-5);
    self.SearchBorder:SetSize(searchWidth,20);
    self.SearchBorder:SetBackColor(Turbine.UI.Color(.15,.25,.45))

    self.SearchText=Turbine.UI.Lotro.TextBox();
    self.SearchText:SetParent(self);
    self.SearchText:SetPosition(self.SearchCaption:GetLeft()+self.SearchCaption:GetWidth()+3,self.SearchCaption:GetTop()-4);
    self.SearchText:SetSize(searchWidth,18);
    self.SearchText:SetBackColor(Turbine.UI.Color(.25,.35,.55));
    self.SearchText:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.SearchText:SetFont(Turbine.UI.Lotro.Font.TrajanPro16);
    self.SearchText:SetForeColor(self.fontColor);
    self.SearchText:SetOutlineColor(Turbine.UI.Color(0,0,0));
    self.SearchText:SetFontStyle(Turbine.UI.FontStyle.Outline);
    self.SearchText:SetWantsUpdates(false);
    self.SearchText.Text="";
    self.SearchText.FocusGained=function()
            self.SearchText:SetWantsUpdates(true);
    end
    self.SearchText.FocusLost=function()
            self.SearchText:SetWantsUpdates(false);
    end
    self.SearchText.Update=function()
        if self.SearchText.Text~=self.SearchText:GetText() then
                self.SearchText.Text=self.SearchText:GetText()
                self:SearchAndLoadQuests(self.SearchText:GetText(), self.ZoneList:GetValue(), self.LevelList:GetValue());
        end
    end

    -- add a search reset button
    local reset = Turbine.UI.Lotro.Button();
    reset:SetParent( self );
    reset:SetText( "reset" );
    reset:SetPosition( self.SearchBorder:GetLeft() + self.SearchBorder:GetWidth() + 1, self.SearchBorder:GetTop() );
    reset:SetSize( 50, self.SearchBorder:GetHeight() );
    reset.Click = function( sender, args )
		self:Reset();
    end

    self.qlContainer=Turbine.UI.Control();
    self.qlContainer:SetParent(self);
    self.qlContainer:SetPosition(5,106);
    self.qlContainer:SetSize((self:GetWidth()/2) - 7, self:GetHeight()-270);
    self.qlContainer:SetBackColor(Turbine.UI.Color(0,0,0)); -- this one has to stay fixed for grid to show
    self.qlContainer.QuestList=Turbine.UI.ListBox();
    self.qlContainer.QuestList:SetParent(self.qlContainer);
    self.qlContainer.QuestList:SetPosition(2,1);
    self.qlContainer.QuestList:SetSize(self.qlContainer:GetWidth()-4,self.qlContainer:GetHeight()-3);
    self.qlContainer.QuestList:SetBackColor(self.backColor);
    self.qlContainer.QuestList.VScrollBar=Turbine.UI.Lotro.ScrollBar();
    self.qlContainer.QuestList.VScrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
    self.qlContainer.QuestList.VScrollBar:SetParent(self.qlContainer.QuestList);
    self.qlContainer.QuestList.VScrollBar:SetBackColor(self.backColor);
    self.qlContainer.QuestList.VScrollBar:SetPosition(self.qlContainer:GetWidth()-16,0)
    self.qlContainer.QuestList.VScrollBar:SetWidth(12);
    self.qlContainer.QuestList.VScrollBar:SetHeight(self.qlContainer:GetHeight()-2);
    self.qlContainer.QuestList:SetVerticalScrollBar(self.qlContainer.QuestList.VScrollBar);
    self.qlContainer.QuestList.SelectedIndexChanged=function(sender, args)
        local idx = self.qlContainer.QuestList:GetSelectedIndex();
        if self.prevIdx ~= nil then
            local oldItem = self.qlContainer.QuestList:GetItem(self.prevIdx);
            if oldItem ~= nil then
                oldItem:SetBackColor(self.backColor);
            end
        end
        if idx ~= 0 then
            self.prevIdx = idx;
            local item = self.qlContainer.QuestList:GetItem(idx);
            item:SetBackColor(self.selBackColor);
            -- Display Quest
            self:LoadQuestDetails(questtable[item.QuestId]);
        end

    end
    
    self.qdContainer=Turbine.UI.Control();
    self.qdContainer:SetParent(self);
    self.qdContainer:SetPosition(self.qlContainer:GetLeft()+self.qlContainer:GetWidth()+5,self.qlContainer:GetTop());
    self.qdContainer:SetSize(self.qlContainer:GetWidth(),self.qlContainer:GetHeight());
    self.qdContainer:SetBackColor(Turbine.UI.Color(0,0,0)); -- this one has to stay fixed for grid to show
    self.qdContainer.QuestDetails = Turbine.UI.ListBox();
    self.qdContainer.QuestDetails:SetParent(self.qdContainer);
    self.qdContainer.QuestDetails:SetPosition(2,1);
    self.qdContainer.QuestDetails:SetSize(self.qdContainer:GetWidth()-4,self.qdContainer:GetHeight()-3);
    self.qdContainer.QuestDetails:SetBackColor(self.backColor);
    self.qdContainer.QuestDetails.VScrollBar=Turbine.UI.Lotro.ScrollBar();
    self.qdContainer.QuestDetails.VScrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
    self.qdContainer.QuestDetails.VScrollBar:SetParent(self.qdContainer.QuestDetails);
    self.qdContainer.QuestDetails.VScrollBar:SetBackColor(self.backColor);
    self.qdContainer.QuestDetails.VScrollBar:SetPosition(self.qdContainer:GetWidth()-16,0)
    self.qdContainer.QuestDetails.VScrollBar:SetWidth(12);
    self.qdContainer.QuestDetails.VScrollBar:SetHeight(self.qdContainer:GetHeight()-2);
    self.qdContainer.QuestDetails:SetVerticalScrollBar(self.qdContainer.QuestDetails.VScrollBar);    

    local bottom = self.qdContainer:GetTop() + self.qdContainer:GetHeight() + 5;
    self.commentsCtr=Turbine.UI.Control();
    self.commentsCtr:SetParent(self);
    self.commentsCtr:SetPosition(5,bottom);
    self.commentsCtr:SetSize(self:GetWidth()-7, self:GetHeight() - bottom - 50);
    self.commentsCtr:SetBackColor(Turbine.UI.Color(0,0,0)); 
    self.QuestComments=Turbine.UI.Label();
    self.QuestComments:SetParent(self.commentsCtr);
    self.QuestComments:SetPosition(2,1);
    self.QuestComments:SetSize(self.commentsCtr:GetWidth()-4,self.commentsCtr:GetHeight()-3);
    self.QuestComments:SetFont(self.fontFace);
    self.QuestComments:SetForeColor(self.fontColor);
    self.QuestComments:SetBackColor(self.backColor)
    self.QuestComments:SetSelectable(true);
    self.QuestComments.VScrollBar=Turbine.UI.Lotro.ScrollBar();
    self.QuestComments.VScrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
    self.QuestComments.VScrollBar:SetParent(self.QuestComments);
    self.QuestComments.VScrollBar:SetBackColor(self.backColor);
    self.QuestComments.VScrollBar:SetPosition(self.commentsCtr:GetWidth()-16,0)
    self.QuestComments.VScrollBar:SetWidth(12);
    self.QuestComments.VScrollBar:SetHeight(self.commentsCtr:GetHeight()-2);
    self.QuestComments:SetVerticalScrollBar(self.QuestComments.VScrollBar);     
--    Turbine.Shell.WriteLine("Top: " .. self.qdContainer:GetTop() .. " Height: " .. self.qdContainer:GetHeight());

    
    self.ArcList=Compendium.Common.UI.DropDownList();
    self.ArcList:SetParent(self);
    self.ArcList:SetPosition(self.ArcCaption:GetLeft()+self.ArcCaption:GetWidth()+3,self.ArcCaption:GetTop()-3);
    self.ArcList:SetSize(self:GetWidth()-(self.ArcCaption:GetWidth()+self.ArcCaption:GetLeft())-95,20);
    self.ArcList:SetBorderColor(self.trimColor);
    self.ArcList:SetCurrentBackColor(self.colorDarkGrey);
    self.ArcList:SetBackColor(self.backColor);
    self.ArcList:SetCurrentBackColor(self.backColor);
    self.ArcList:SetDropRows(6);
    self.ArcList:AddItem( '(Choose a Quest Chain)', '');
    self.ArcList.DropDownUpdate=function(levelText)
        self:SearchAndLoadQuests(self.SearchText:GetText(), self.ZoneList:GetValue(), self.LevelList:GetValue(), self.ArcList:GetValue());
    end
    for i = 1, #self.arcs do
        self.ArcList:AddItem( self.arcs[i], self.arcs[i] );
    end    

    self.LevelList=Compendium.Common.UI.DropDownList();
    self.LevelList:SetParent(self);
    self.LevelList:SetPosition(self.LevelCaption:GetLeft()+self.LevelCaption:GetWidth()+3,self.LevelCaption:GetTop()-3);
    self.LevelList:SetSize(self:GetWidth()-(self.LevelCaption:GetWidth()+self.LevelCaption:GetLeft())-95,20);
    self.LevelList:SetBorderColor(self.trimColor);
    self.LevelList:SetCurrentBackColor(self.colorDarkGrey);
    self.LevelList:SetBackColor(self.backColor);
    self.LevelList:SetCurrentBackColor(self.backColor);
    self.LevelList:SetDropRows(6);
    self.LevelList:AddItem( '(Choose a Level Range)', '');
    self.LevelList.DropDownUpdate=function(levelText)
        self:SearchAndLoadQuests(self.SearchText:GetText(), self.ZoneList:GetValue(), self.LevelList:GetValue(), self.ArcList:GetValue());
    end
    for i = 1, #self.levels do
        self.LevelList:AddItem( self.levels[i], self.levels[i] );
    end

    
    self.ZoneList=Compendium.Common.UI.DropDownList();
    self.ZoneList:SetParent(self);
    self.ZoneList:SetPosition(self.ZoneCaption:GetLeft()+self.ZoneCaption:GetWidth()+3,self.ZoneCaption:GetTop()-3);
    self.ZoneList:SetSize(self:GetWidth()-(self.ZoneCaption:GetWidth()+self.ZoneCaption:GetLeft())-95,20);
    self.ZoneList:SetBorderColor(self.trimColor);
    self.ZoneList:SetCurrentBackColor(self.colorDarkGrey);
    self.ZoneList:SetBackColor(self.backColor);
    self.ZoneList:SetCurrentBackColor(self.backColor);
    self.ZoneList:SetDropRows(6);
    self.ZoneList:AddItem( '(Choose a Zone)', '');
    self.ZoneList.DropDownUpdate=function(zoneText)
        self:SearchAndLoadQuests(self.SearchText:GetText(), self.ZoneList:GetValue(), self.LevelList:GetValue(), self.ArcList:GetValue());
    end
    for i = 1, #self.zones do
        self.ZoneList:AddItem( self.zones[i], self.zones[i] );
    end
    
    self:ClearQuests();
	self.searchDisabled = false;
		    
end

function CompendiumQuestControl:ClearQuests()
    self.qlContainer.QuestList:ClearItems();
    self.qdContainer.QuestDetails:ClearItems();
    self.QuestComments:SetText("");
    self:AddQuestDetail("No quest selected");
    self.prevIdx = nil;
end

function CompendiumQuestControl:AddQuestDetail(text, hyperlink)
    local label = Turbine.UI.Label();
    label:SetSize(self.qdContainer.QuestDetails:GetWidth() - 10, 15);
    label:SetText(text);
    label:SetBackColor(self.backColor);
    label:SetFont(self.fontFaceSmall);

    if hyperlink == true then
        label:SetFontStyle( Turbine.UI.FontStyle.Outline );
        label:SetForeColor(self.yellow);
        label:SetOutlineColor(self.darkBlue);
    else
        label:SetForeColor(self.fontColor);
    end

    self.qdContainer.QuestDetails:AddItem(label);
    return label;
end

function CompendiumQuestControl:SearchAndLoadQuests(searchText, zoneText, levelText, arcText)
	if self.searchDisabled then
		return;
	end
	
    self:ClearQuests();

    local ize = (zoneText == nil or zoneText == '');
    local ise = (searchText == nil or searchText == '');
    local ile = (levelText == nil or levelText == '');
    local iae = (arcText == nil or arcText == '');

    if ise and ize and ile and iae then
        -- no point in searching
        return;
    end

    
    local escapedSearch = '';
    if not ise then
        -- some symbols need escaped in regex patterns
        escapedSearch = string.lower(string.gsub(searchText,'[%-%.%+%[%]%(%)%^%%%?%*]','%%%1'));
    end
    
    local count = 0;
    
    --[[
	local msg = "Searching";
    if not ise then
       msg = msg .. ' ' .. searchText;
    end
    msg = msg .. ' in ' .. zoneText;
    Turbine.Shell.WriteLine(msg);
    ]]
    
    local type = 'all';
    local data = nil;
    
    if ize and ile and iae then
    	-- full text search w/o filters
    	data = questtable;
    else
    	if not ize then data = self:JoinIndex(data, zoneindex[zoneText]); end
    	if not ile then data = self:JoinIndex(data, levelindex[levelText]); end
    	if not iae then data = self:JoinIndex(data, arcindex[arcText]); end
    	type = 'ids';
    end

	--Turbine.Shell.WriteLine('Data: ' .. self:tostring(data));

    local records = {};
    for a,b in pairs(data) do
        local quest = nil;
        local id = nil;
        if type == 'all' then
            id = a;
            quest = b;
        else
            id = b;
            quest = questtable[tonumber(id)];
            --if count < 10 then Turbine.Shell.WriteLine(id) end
        end
        
        if quest ~= nil then
            local name = quest["name"];
            local include = true;
            if not ise then
                if string.find(string.lower(name),escapedSearch) ~= 1 then
                    include = false;
                end
            end
            --if count < 10 then Turbine.Shell.WriteLine(name) end
            if include then
                count = count + 1;
                records[#records + 1] = quest;
            end
        end
    end
    
    -- if full text search then it has to be sorted
    if type == 'all' then
        table.sort(records, function(a,b)
            return a["name"] < b["name"];
        end);
    end
    self:LoadQuests(records);
    
    --Turbine.Shell.WriteLine("Found " .. count .. " quests.");

end

function CompendiumQuestControl:JoinIndex(a, b)
	if a == nil then return b; end
	
    local set = {};
    local data = {};
    for i,k in pairs(a) do set[tostring(k)] = true; end
    for i,k in pairs(b) do
        if set[tostring(k)] then data[#data + 1] = k; end
    end
    return data;
end

function CompendiumQuestControl:LoadQuests(records)

    local bgColor = self.qlContainer.QuestList:GetBackColor();
    local width = self.qlContainer.QuestList:GetWidth();
    local playerLevel = Turbine.Gameplay.LocalPlayer.GetInstance():GetLevel();

    for i,rec in pairs(records) do
        local level = rec["level"];
        local name = rec["name"] .. ' (' .. level .. ')';
        local label = Turbine.UI.Label();
        label:SetSize(width - 10, 15);
        label:SetText(name);
        label:SetBackColor(bgColor);
        label:SetFont(self.fontFaceSmall);
        
        local color = self.fontColor;
        if level ~= nil and level ~= '' then
            color = self:GetLevelColor(playerLevel, tonumber(level));
        end
        label:SetForeColor(color);
                
        label.QuestId = tonumber(rec["id"]);
        self.qlContainer.QuestList:AddItem(label);
    end
    
end

function CompendiumQuestControl:Reset() 
	self.searchDisabled = true;
	self.ZoneList:SetSelectedIndex(1);
	self.LevelList:SetSelectedIndex(1);
	self.ArcList:SetSelectedIndex(1);
	self.SearchText:SetText('');
	self.searchDisabled = false;
end

function CompendiumQuestControl:FormatItem(record)
	local item = '';
	if record['id'] ~= nil then
		item = string.format(self.itemExampleTpl,record['id'],record['val']);
	else
		item = '['..record['val']..']';
	end
	
	if record['q'] ~= nil and record['q'] ~= '' then
		item = item .. ' ' .. record['q'];
	end
	
	return item; 
end

function CompendiumQuestControl:LoadQuestDetails(record)
    
    --[[{
    	["next"] = {1276, 2025}, 
    	["reputation"] = {"+700 with Malledhrim"}, 
    	["zone"] = "Mirkwood", 
    	["area"] = "Taur Morvith", 
    	["money"] = {"45s 36c"}, 
		["receive"] = {"Malledhrim Bronze Feather (x4)"},
    	["mobs"] = {{["locations"] = {"16.60S, 50.55W"}, ["name"] = "Iavassúl"}}, 
    	["category"] = "Mirkwood", 
    	["id"] = 2222, 
    	["scope"] = "n/a", 
    	["prev"] = {862, 1620}, 
    	["name"] = "The Narrow Way", 
    	["arcs"] = "Forts of Taur Morvith", 
    	["description"] = "The Elven scout Ianudirel was sent ahead to explore the far side of the river from Krul Lugu, but she has not yet returned.", 
    	["minlevel"] = 59, 
    	["repeatable"] = "No", 
    	["faction"] = "FrP", 
    	["instanced"] = "No"
    },]]
    
    self.qdContainer.QuestDetails:ClearItems();
    self:AddQuestDetail("Name:");
    self:AddQuestDetail("  " .. record['name']);
    self:AddQuestDetail("Level: " .. record['level'] .. " / Min Level: " .. record['minlevel']);
    self:AddQuestDetail("Repeatable: " .. record['repeatable'] .. " / Instanced: " .. record['instanced']);

    if record['zone'] ~= nil then self:AddQuestDetail("Zone: " .. record['zone']); end
    if record['area'] ~= nil then self:AddQuestDetail("Area: " .. record['area']); end
    if record['faction'] ~= nil then self:AddQuestDetail("Faction: " .. record['faction']); end
    if record['money'] ~= nil then self:AddQuestDetail("Money: " .. record['money'][1]['val']); end
    if record['reputation'] ~= nil then 
    	if #record['reputation'] > 1 then
    		for i,rep in pairs(record['reputation']) do
    			local prefix = "     ";
    			if i == 1 then prefix = "Rep: "; end
    			self:AddQuestDetail(prefix .. rep['val'])
    		end
    	else
    		self:AddQuestDetail("Rep: " .. record['reputation'][1]['val']);
    	end
    end
    if record['receive'] ~= nil then 
    	if #record['receive'] > 1 then
    		for i,item in pairs(record['receive']) do
    			local prefix = "     ";
    			if i == 1 then prefix = "Recieve: "; end
    			
    			self:AddQuestDetail(prefix .. self:FormatItem(item))
    		end
    	else
    		self:AddQuestDetail("Recieve: " .. self:FormatItem(record['receive'][1]));
    	end
    end     
        		
    local sep = false;
    if record['arcs'] ~= nil then
        self:AddQuestDetail("");
        sep = true;
        self:AddQuestDetail("Arc:");
        self:AddQuestDetail("  " .. record['arcs'], true).MouseClick = function(sender, args)
        	self:Reset();
        	self.ArcList:SelectIndexByValue(record['arcs']);
        end;
    end
    if record['prev'] ~= nil then
        if sep == false then self:AddQuestDetail(""); end
        sep = true
        self:AddQuestDetail("Prereq(s):");
        for i,previd in pairs(record['prev']) do     
        	local name = questtable[previd]['name'];   
	        self:AddQuestDetail("  " .. name, true).MouseClick = function(sender, args)
	            self:LoadQuestDetails(questtable[previd]);
	        end;
        end
    end
    if record['next'] ~= nil then
        if sep == false then self:AddQuestDetail(""); end
        sep = true
        self:AddQuestDetail("Next Quest(s):");
        for i,nextid in pairs(record['next']) do     
        	local name = questtable[nextid]['name'];   
	        self:AddQuestDetail("  " .. name, true).MouseClick = function(sender, args)
	            self:LoadQuestDetails(questtable[nextid]);
	        end;
        end
    end
    
    sep = false
    if record['mobs'] ~= nil and #record['mobs'] > 0 then
        if sep == false then self:AddQuestDetail(""); end
        sep = true
        self:AddQuestDetail("Mobs of Interest:");
        for i,mob in pairs(record['mobs']) do
            local name = "  " .. mob['name'];
            if mob['locations'] ~= nil then
	            if #mob['locations'] > 1 then
	            	self:AddQuestDetail(name); 
	            	for i,loc in pairs(mob['locations']) do
		            	self:AddQuestDetail('       ' .. loc);	            	
	            	end
	            elseif #mob['locations'] == 1 then
	            	name = name .. ' (' .. mob['locations'][1] .. ')';
	            	self:AddQuestDetail(name);
	            end
	        else 
	        	self:AddQuestDetail(name);
	        end
        end
    end

    if record['pois'] ~= nil and #record['pois'] > 0 then
        if sep == false then self:AddQuestDetail(""); end
        sep = true
        self:AddQuestDetail("Points of Interest:");
        for i,poi in pairs(record['pois']) do
            local name = "  " .. poi['name'];
            if poi['locations'] ~= nil then
	            if #poi['locations'] > 1 then
	            	self:AddQuestDetail(name); 
	            	for i,loc in pairs(poi['locations']) do
		            	self:AddQuestDetail('       ' .. loc);	            	
	            	end
	            elseif #poi['locations'] == 1 then
	            	name = name .. ' (' .. poi['locations'][1] .. ')';
	            	self:AddQuestDetail(name);
	            end
	        else 
	        	self:AddQuestDetail(name);
	        end
        end
    end
    
    self.QuestComments:SetText(record['description']);

end

