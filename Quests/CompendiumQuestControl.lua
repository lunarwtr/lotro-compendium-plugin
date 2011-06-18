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
import "Compendium.Quests.QuestCommentsControl";
import "Compendium.Quests.QuestCategoryMenu";
import "Compendium.Common.Utils";
import "Compendium.Common.UI";
import "Compendium.Common.Resources.Bundle";
local rsrc = {};

local pagesize = 200;
local rewardLabels = { 
    reputation,destinypoints,money,receive,virtues,titles,selectoneof,traits 
};


CompendiumQuestControl= class( Compendium.Common.UI.CompendiumControl );
function CompendiumQuestControl:Constructor(language)
    Compendium.Common.UI.CompendiumControl.Constructor( self );
	rsrc = Compendium.Common.Resources.Bundle:GetResources();

	self.localquestdatamodified = false;
	self.localquestdata = {};
    self.currentIndexFilters = {};
    self.currentManualFilters = {};
	self.searchDisabled = true;
	self:LoadLocalQuests();
	
	self.range = Compendium.Common.UI.LevelRangeControl();
	self.range:SetParent(self);
	self.range.RangeApplied = function( s, from, to )
		local rec = {};
		if from ~= nil then rec.from = tonumber(from) end;
		if to ~= nil then rec.to = tonumber(to) end;
		self:AddFilters({ manual = { level = rec } });
	end

    self.menu = Compendium.Quests.QuestCategoryMenu();
    self.menu.ClickCategory = function(categories)
    	local size = #categories;
    	if size > 0 and categories[size] == 'Custom' then
			local x, y = self:PointToClient(Turbine.UI.Display:GetMousePosition());
			local mw, mh = self.range:GetSize();
			local w, h = self:GetSize();
			local left, top = x - (mw / 2), y - (mh / 2);
			if (top + mh) > h then top = h - mh end;
			if (left + mw) > w then left = w - mw end;
			self.range:SetPosition(left,top);
			self.range:ShowMenu(true);    		
    	else
			self:AddFilters({ indexes = categories });
    	end
	end        
    local filterButton = Turbine.UI.Lotro.Button();
    filterButton:SetParent(self);
    filterButton:SetPosition(9,3);
    filterButton:SetSize(85,20);
    filterButton:SetText(" " .. rsrc["filterby"]);
 	filterButton:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	filterButton.Click = function( sender, args ) 
    	self.menu:ShowMenu();
    end
    
    local filterIcon = Turbine.UI.Control();
    filterIcon:SetParent( filterButton );
    filterIcon:SetBackground(0x41007e19);
    filterIcon:SetBlendMode(Turbine.UI.BlendMode.Overlay);
    filterIcon:SetPosition( filterButton:GetWidth() - 20, 1 );
    filterIcon:SetSize( 16, 16 );
    filterIcon.MouseClick = function( sender, args ) 
    	self.menu:ShowMenu();
    end

    
      --[[ 
	self.logo = Turbine.UI.Control();
	self.logo:SetBlendMode(Turbine.UI.BlendMode.Screen);
	self.logo:SetBackground( "Compendium/Common/Resources/images/CompendiumLogoSmall.tga" );
	self.logo:SetPosition(self:GetWidth() - 80 ,0);
	self.logo:SetSize(75,100);
	self.logo:SetParent( self );    
     ]]
     
    local searchLabel = Turbine.UI.Label();
    searchLabel:SetParent(self);
    searchLabel:SetPosition(97,5);
    searchLabel:SetSize(55,20);
    searchLabel:SetFont(self.fontFace);
    searchLabel:SetForeColor(self.fontColor);
    searchLabel:SetOutlineColor(Turbine.UI.Color(0,0,0));
    searchLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);
    searchLabel:SetText(rsrc['search']);

    local searchWidth = self:GetWidth()-(searchLabel:GetWidth()+searchLabel:GetLeft())-55;
    self.SearchBorder=Turbine.UI.Control();
    self.SearchBorder:SetParent(self);
    self.SearchBorder:SetPosition(searchLabel:GetLeft()+searchLabel:GetWidth()+2,searchLabel:GetTop()-3);
    self.SearchBorder:SetSize(searchWidth,20);
    self.SearchBorder:SetBackColor(Turbine.UI.Color(.15,.25,.45))

    self.SearchText=Turbine.UI.Lotro.TextBox();
    self.SearchText:SetParent(self);
    self.SearchText:SetPosition(searchLabel:GetLeft()+searchLabel:GetWidth()+3,searchLabel:GetTop()-2);
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
    	local text = self.SearchText:GetText();
        if self.SearchText.Text ~= text then
        	self.SearchText.Text = text;
        	self:BuildCursor();
        end
    end
    --[[
    self.SearchText.Update=function()
        if self.SearchText.Text~=self.SearchText:GetText() then
                self.SearchText.Text=self.SearchText:GetText()
                self:SearchAndLoadQuests(self.SearchText:GetText(), self.ZoneList:GetValue(), self.LevelList:GetValue());
        end
    end
	--]]
	
    local filtersLabel = Turbine.UI.Label();
    filtersLabel:SetParent(self);
    filtersLabel:SetPosition(5,filterButton:GetTop() +  filterButton:GetHeight());
    filtersLabel:SetSize(self:GetWidth() - 7,20);
    filtersLabel:SetFont(self.fontFace);
    filtersLabel:SetForeColor(self.trimColor);
    filtersLabel:SetText(rsrc["nofiltersset"]);	
	self.filtersLabel = filtersLabel;	
	
    -- add a search reset button
    local reset = Turbine.UI.Lotro.Button();
    reset:SetParent( self );
    reset:SetText( rsrc["reset"] );
    reset:SetPosition( self.SearchBorder:GetLeft() + self.SearchBorder:GetWidth() + 1, self.SearchBorder:GetTop() );
    reset:SetSize( 50, self.SearchBorder:GetHeight() );
    reset.Click = function( sender, args )
		self:Reset();
    end

    self.qlContainer=Turbine.UI.Control();
    self.qlContainer:SetParent(self);
    self.qlContainer:SetPosition(5,filtersLabel:GetTop() + filtersLabel:GetHeight() + 1);
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

    local pagination = Compendium.Common.UI.PaginationControl();
    pagination:SetParent(self.qlContainer);
    pagination:SetVisible(false);
    pagination:SetSize(self.qlContainer:GetWidth(),20);
    pagination:SetPosition(0,self.qlContainer:GetHeight() - 22);
	pagination.PageChanged = function(sender,direction,records)
   		self:ClearQuests();
		self:LoadQuests(records);
   	end
   	pagination.VisibleChanged = function(s,a) 
   		local ql = self.qlContainer.QuestList;
   		local sb = ql.VScrollBar;
   		local ch = self.qlContainer:GetHeight();
   		if pagination:IsVisible() then
   			ql:SetHeight(ch - 23);
   			sb:SetHeight(ch - 22);
   		else
   			ql:SetHeight(ch - 3);
   			sb:SetHeight(ch - 2);
   		end
   	end
   	
    self.pagination = pagination;
    
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

    local bottom = self.qdContainer:GetTop() + self.qdContainer:GetHeight() + 2;
	local detailTabs = Compendium.Common.UI.TabControl();
	detailTabs:SetParent(self);
	detailTabs:SetPosition(7,bottom);
	    
    self.questDesc=Turbine.UI.Label();
    self.questDesc:SetPosition(0,0);
    self.questDesc:SetFont(self.fontFace);
    self.questDesc:SetForeColor(self.fontColor);
    self.questDesc:SetSelectable(true);
    self.questDesc.VScrollBar=Turbine.UI.Lotro.ScrollBar();
    self.questDesc.VScrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
    self.questDesc.VScrollBar:SetParent(self.questDesc);
    self.questDesc.VScrollBar:SetBackColor(self.backColor);
    self.questDesc.VScrollBar:SetPosition(self.questDesc:GetWidth()-12,0)
    self.questDesc.VScrollBar:SetWidth(12);
    self.questDesc.VScrollBar:SetHeight(self.questDesc:GetHeight()-2);
    self.questDesc:SetVerticalScrollBar(self.questDesc.VScrollBar);
    self.questDesc.SizeChanged = function(s,a) 
    	local width = s:GetWidth();
		local height = s:GetHeight();
	    self.questDesc.VScrollBar:SetPosition(width-12,0);
	    self.questDesc.VScrollBar:SetHeight(height - 2);
    end

    self.questObj=Turbine.UI.Label();
    self.questObj:SetPosition(0,0);
    self.questObj:SetFont(self.fontFace);
    self.questObj:SetForeColor(self.fontColor);
    self.questObj:SetSelectable(true);
    self.questObj.VScrollBar=Turbine.UI.Lotro.ScrollBar();
    self.questObj.VScrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
    self.questObj.VScrollBar:SetParent(self.questObj);
    self.questObj.VScrollBar:SetBackColor(self.backColor);
    self.questObj.VScrollBar:SetPosition(self.questObj:GetWidth()-12,0)
    self.questObj.VScrollBar:SetWidth(12);
    self.questObj.VScrollBar:SetHeight(self.questObj:GetHeight()-2);
    self.questObj:SetVerticalScrollBar(self.questObj.VScrollBar);
    self.questObj.SizeChanged = function(s,a) 
    	local width = s:GetWidth();
		local height = s:GetHeight();
	    self.questObj.VScrollBar:SetPosition(width-12,0);
	    self.questObj.VScrollBar:SetHeight(height - 2);
    end

	self.coord = Compendium.Common.UI.CoordinateControl();
	self.coord:SetParent(self);  	
    
    local comments= Compendium.Quests.QuestCommentsControl();
    comments.CommentAdded = function(s, value) 
    	if self.currentRecord ~= nil then
    		self:UpdateLocalRecord(self.currentRecord,'addcomment', { val = value , modifiable = true, time = Turbine.Engine:GetLocalTime() } );
    	end
    end
    comments.CommentDeleted  = function(s, value) 
    	if self.currentRecord ~= nil then
    		self:UpdateLocalRecord(self.currentRecord,'delcomment', value );
    	end
    end
    comments.CoordClicked = function( sender, y, ns, x, ew )
    	if self.currentRecord ~= nil then
    		self:CoordClicked( y, ns, x, ew, self.currentRecord['zone'], rsrc["miscpoi"], self.currentRecord['name']);
    	end		
    end
	self.comments = comments;

	detailTabs:AddTab(rsrc["objectives"],  self.questObj);
	detailTabs:AddTab(rsrc["description"],  self.questDesc);
	detailTabs:AddTab(rsrc["comments"],  comments);
	detailTabs:SetSize(self:GetWidth()-10, 150);
    
    self:ClearQuests();
	self.searchDisabled = false;

    
 	self.SetWidth = function(sender,width)
        if width<100 then width=100 end;
        Turbine.UI.Control.SetWidth(self,width);
        
        local qlwidth = (width/2) - 7;
        self.qlContainer:SetWidth(qlwidth);
        self.qdContainer:SetLeft(self.qlContainer:GetLeft() + qlwidth + 5);
        self.qdContainer:SetWidth(qlwidth);
        self.qlContainer.QuestList:SetWidth(qlwidth - 4);
        self.qdContainer.QuestDetails:SetWidth(qlwidth - 4);
        self.qlContainer.QuestList.VScrollBar:SetLeft(qlwidth-16);
        self.qdContainer.QuestDetails.VScrollBar:SetLeft(qlwidth-16);
        pagination:SetWidth(qlwidth - 4);
        
		local swidth = width - (searchLabel:GetWidth()+searchLabel:GetLeft())-55;
    	self.SearchBorder:SetWidth(swidth);
    	self.SearchText:SetWidth(swidth);
	    reset:SetLeft( self.SearchBorder:GetLeft() + self.SearchBorder:GetWidth() + 1 );
		
		detailTabs:SetWidth(width - 10);
		for index=1,self.qlContainer.QuestList:GetItemCount() do
			local label = self.qlContainer.QuestList:GetItem(index);
			label:SetWidth(qlwidth - 14);
		end
		for index=1,self.qdContainer.QuestDetails:GetItemCount() do
			local label = self.qdContainer.QuestDetails:GetItem(index);
			label:SetWidth(qlwidth - 14);
		end

    end
		
 	self.SetHeight = function(sender,height)
        if height<300 then height=300 end;
        local lheight = height - self.qlContainer:GetTop() - detailTabs:GetHeight() - 5;
        
        Turbine.UI.Control.SetHeight(self,height);
		self.qlContainer:SetHeight(lheight);
		local ql = self.qlContainer.QuestList;
   		local sb = ql.VScrollBar;
   		if pagination:IsVisible() then
   			ql:SetHeight(lheight - 23);
   			sb:SetHeight(lheight - 22);
   		else
   			ql:SetHeight(lheight - 3);
   			sb:SetHeight(lheight - 2);
   		end
		pagination:SetTop(lheight - 22);
		
		self.qdContainer:SetHeight(lheight);
		self.qdContainer.QuestDetails:SetHeight(lheight - 3);
		self.qdContainer.QuestDetails.VScrollBar:SetHeight(lheight - 2);
		detailTabs:SetTop(self.qdContainer:GetTop() + lheight + 2);   	
    end	
	
	self.SetSize = function(sender,width, height) 
		self:SetWidth(width);
		self:SetHeight(height);
	end	
	
	self:BuildCursor();
		    
end

function CompendiumQuestControl:ClearQuests()
	for index=1,self.qlContainer.QuestList:GetItemCount() do
		local item = self.qlContainer.QuestList:GetItem(index);
		self:strip(item, 1);
	end	
	self.qlContainer.QuestList:ClearItems();
	for index=1,self.qdContainer.QuestDetails:GetItemCount() do
		local item = self.qdContainer.QuestDetails:GetItem(index);
		self:strip(item, 1);
	end		
    self.qdContainer.QuestDetails:ClearItems();
    self.questDesc:SetText("");
    self.questObj:SetText("");
	self.comments:ClearComments();
    self:AddQuestDetail(rsrc["noquestselected"]);
    self.prevIdx = nil;
	self.currentRecord = nil;    
end

function CompendiumQuestControl:AddQuestDetail(text, hyperlink)
    local label = Turbine.UI.Label();
    label:SetSize(self.qdContainer.QuestDetails:GetWidth() - 10, 13);
    label:SetText(text);
    label:SetBackColor(self.backColor);
    label:SetFont(self.fontFaceSmall);
    label:SetSelectable(true);
	label:SetMultiline(false);
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

function CompendiumQuestControl:JoinIndex(a, b)
	if a == nil then return b; end
	
    local set = {};
    local data = {};
    for i,k in pairs(a) do set[tostring(k)] = true; end
    for i,k in pairs(b) do
        if set[tostring(k)] then 
        	table.insert(data, k); 
        end
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
        if rec["faction"] == 'Mon' then
        	name = name .. ' (M)';
        end
        local label = Turbine.UI.Label();
        label:SetMultiline(false);
        label:SetSize(width - 10, 15);
        label:SetSelectable(true);
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
	self.SearchText:SetText('');
    self:ClearQuests();	
	self.currentIndexFilters = {};
	self.currentManualFilters = {};
	self.filtersLabel:SetText(rsrc["nofiltersset"]);
	self.cursor = nil;
	self.searchDisabled = false;
	self:BuildCursor();
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
    
    local localrecord = self.localquestdata[record['name']];
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
    	["d"] = "The Elven scout Ianudirel was sent ahead to explore the far side of the river from Krul Lugu, but she has not yet returned.", 
    	["minlevel"] = 59, 
    	["repeatable"] = "No", 
    	["faction"] = "FrP", 
    	["instanced"] = "No"
    },]]
    
    self.qdContainer.QuestDetails:ClearItems();
	self.comments:ClearComments();
    self.currentRecord = record;
    
    self:AddQuestDetail(rsrc['name']);
    self:AddQuestDetail("  " .. record['name']);
    local levelinfo = rsrc["level"] .. " " .. record['level'];
    if record['minlevel'] ~= nil then levelinfo = levelinfo  .. " / ".. rsrc["minlevel"] .. " " .. record['minlevel'] end;
    self:AddQuestDetail(levelinfo);
    if record['t'] ~= nil then self:AddQuestDetail(rsrc["type"] .. " "  .. record['t']); end
    local repinst = rsrc["repeatable"] .. " "  .. record['repeatable'];
    if record['instanced'] ~= nil then repinst = repinst .. " / ".. rsrc["instanced"] .. " " .. record['instanced'] end;
    self:AddQuestDetail(repinst);

    if record['zone'] ~= nil then self:AddQuestDetail(rsrc["zone"] .. " " .. record['zone']); end
    if record['area'] ~= nil then self:AddQuestDetail(rsrc["area"] .. " " .. record['area']); end
    if record['faction'] ~= nil then self:AddQuestDetail(rsrc["faction"] .. " " .. record['faction']); end
    if record['b'] ~= nil then self:AddQuestDetail(rsrc["bestower"] .. " " .. record['b']); end
    
    for j, reward in pairs(rewardLabels) do
    	local display = rsrc[reward];
    	if record[reward] ~= nil then
    		local vals = record[reward];
	    	if #vals > 1 then
	    		for i,item in pairs(vals) do
	    			local prefix = "     ";
	    			if i == 1 then prefix = display .. ": "; end
	    			
	    			local dispval = item['val']
	    			if reward == 'receive' or reward == 'selectoneof' then
	    				dispval = self:FormatItem(item);
	    			end
	    			
	    			self:AddQuestDetail(prefix .. dispval)
	    		end
	    	else
    			local dispval = vals[1]['val']
    			if reward == 'receive' or reward == 'selectoneof' then
    				dispval = self:FormatItem(vals[1]);
    			end	    	
	    		self:AddQuestDetail(display .. ": " .. dispval);
	    	end
    	end
    end
        		
    local sep = false;
    if record['arcs'] ~= nil then
        self:AddQuestDetail("");
        sep = true;
        self:AddQuestDetail(rsrc["questchain"]);
        local arclabel = self:AddQuestDetail("  " .. record['arcs'], true);
        if questindexes[record['arcs']] ~= nil then
	        arclabel.MouseClick = function(sender, args)
	        	self:Reset();
	        	self:AddFilters({ record['arcs'] });
	        end;
	    end
    end
    if record['prev'] ~= nil then
        if sep == false then self:AddQuestDetail(""); end
        sep = true
        self:AddQuestDetail(rsrc["prereqs"]);
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
        self:AddQuestDetail(rsrc["nextquests"]);
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
        self:AddQuestDetail(rsrc["mobsnpcsofinterest"]);
        for i,mob in pairs(record['mobs']) do
            local name = "  " .. mob['name'];
            if mob['locations'] ~= nil then
	            if #mob['locations'] > 1 then
	            	self:AddQuestDetail(name); 
	            	for i,loc in pairs(mob['locations']) do
		            	self:AddQuestDetail('       ' .. loc).MouseClick = function(s,a)
		            		local tmp, tmp, tmp, y, ns, x, ew = string.find(loc, "((%d+%.%d+)([NSns])[, .]+(%d+%.%d+)([EWOewo]))");
		            		if i ~= nil then
		            			self:CoordClicked( y, ns, x, ew, mob['zone'], mob['name'], rsrc['quest'] .. ' - ' .. string.gsub(record['name'],':','-') .. ' / '.. rsrc["mob"] .. ' - ' .. mob['name']);
		            		end
		            	end
	            	end
	            elseif #mob['locations'] == 1 then
	            	name = name .. ' (' .. mob['locations'][1] .. ')';
	            	self:AddQuestDetail(name).MouseClick = function(s,a)
	            		local tmp, tmp, tmp, y, ns, x, ew = string.find(mob['locations'][1], "((%d+%.%d+)([NSns])[, .]+(%d+%.%d+)([EWOewo]))");
	            		if i ~= nil then
	            			self:CoordClicked( y, ns, x, ew, mob['zone'], mob['name'], rsrc['quest'] .. ' - ' .. string.gsub(record['name'],':','-') .. ' / '.. rsrc["mob"] .. ' - ' .. mob['name']);
	            		end
	            	end
	            end
	        else 
	        	self:AddQuestDetail(name);
	        end
        end
    end

    if record['pois'] ~= nil and #record['pois'] > 0 then
        if sep == false then self:AddQuestDetail(""); end
        sep = true
        self:AddQuestDetail(rsrc["pointsofinterest"]);
        for i,poi in pairs(record['pois']) do
            local name = "  " .. poi['name'];
            if poi['locations'] ~= nil then
	            if #poi['locations'] > 1 then
	            	self:AddQuestDetail(name); 
	            	for i,loc in pairs(poi['locations']) do
		            	self:AddQuestDetail('       ' .. loc).MouseClick = function(s,a)
		            		local tmp, tmp, tmp, y, ns, x, ew = string.find(loc, "((%d+%.%d+)([NSns])[, .]+(%d+%.%d+)([EWOewo]))");
		            		if i ~= nil then
		            			self:CoordClicked( y, ns, x, ew, poi['zone'], poi['name'], rsrc['quest'] .. ' - ' .. string.gsub(record['name'],':','-') .. ' / ' .. poi['name']);
		            		end
		            	end            	
	            	end
	            elseif #poi['locations'] == 1 then
	            	name = name .. ' (' .. poi['locations'][1] .. ')';
	            	self:AddQuestDetail(name).MouseClick = function(s,a)
	            		local tmp, tmp, tmp, y, ns, x, ew = string.find(poi['locations'][1], "((%d+%.%d+)([NSns])[, .]+(%d+%.%d+)([EWOewo]))");
	            		if i ~= nil then
	            			self:CoordClicked( y, ns, x, ew, poi['zone'], poi['name'], rsrc['quest'] .. ' - ' .. string.gsub(record['name'],':','-') .. ' / ' .. poi['name']);
	            		end
	            	end
	            end
	        else 
	        	self:AddQuestDetail(name);
	        end
        end
    end
    
    -- description
    self.questDesc:SetVerticalScrollBar(nil);
    self.questDesc:SetText(record['d']);
    self.questDesc:SetVerticalScrollBar(self.questDesc.VScrollBar);
	-- objective
    self.questObj:SetVerticalScrollBar(nil);
    self.questObj:SetText(record['o']);
    self.questObj:SetVerticalScrollBar(self.questObj.VScrollBar);
    
    if record['c'] ~= nil then
    	local comrecs = {};
    	for i, value in pairs(record['c']) do
    		table.insert(comrecs,  { val = value , modifiable = false, time = 0 } );
    	end
    	self.comments:AddCommentRecords(comrecs, false);
    else
    	self.comments:AddCommentRecords({}, false);
    end
    -- add any custom added comments user may have added
	if localrecord ~= nil and localrecord['c'] ~= nil then
		self.comments:AddCommentRecords(localrecord['c']);
	end

end

function CompendiumQuestControl:BuildCursor()

	if self.searchDisabled then
		return;
	end
    self:ClearQuests();
	self.pagination:SetCursor(nil);
	self.pagination:SetVisible(false);
	
	-- filter results using our category indexes
	local ids = nil;
	for i,cat in pairs(self.currentIndexFilters) do
		if questindexes[cat] ~= nil then
			ids = self:JoinIndex(ids,questindexes[cat]);
		end 
	end
	-- determine if a text search was used
	local searchText = self.SearchText:GetText();
    local ise = (searchText == nil or searchText == '');
    local escapedSearch = '';
    if not ise then
        -- some symbols need escaped in regex patterns
        escapedSearch = string.lower(string.gsub(searchText,'[%-%.%+%[%]%(%)%^%%%?%*]','%%%1'));
    elseif #self.currentManualFilters > 0 then
    	-- we'll take care of it below
    else
    	-- if no search and no indexes use default cursor
    	if ids == nil then
			self.cursor = Compendium.Common.Utils.DataCursor(questtable, pagesize);
			self.pagination:SetCursor(self.cursor);
			if self.cursor:PageCount() > 1 then
				self.pagination:SetVisible(true);
			end
			self:LoadQuests(self.cursor:CurPage());
			return;
		end
    end

	-- build data set	
	local data = questtable;
	if ids ~= nil then
		data = ids 
	end;
	local recs = {};
    local count = 0;
	for a, b in pairs(data) do
		local id = a;
		if ids ~= nil then id = b end;

		--Turbine.Shell.WriteLine('a:' .. a .. ' b:' .. b .. ' id:' .. id);		
		local rec = questtable[id];
        local include = true;
        if not ise then
            if string.find(string.lower(rec["name"]),escapedSearch) ~= 1 then
                include = false;
            end
        end
        -- only need to apply manual filters if passed text search
        if include then
			for i,filter in pairs(self.currentManualFilters) do
				if filter.type == 'level' then
					local from, to = filter.from, filter.to;
					if from == nil then from = 0 end;
					if to == nil then to = 1000 end;
					if rec['level'] < from or rec['level'] > to then
						include = false;
						break; 
					end			
				end
			end
		end        
        
        if include then
            count = count + 1;
            table.insert(recs,rec);
        end
	end;
	
	-- create pagination cursor for results
	self.cursor = Compendium.Common.Utils.DataCursor(recs, pagesize);
	self.pagination:SetCursor(self.cursor);
	if self.cursor:PageCount() > 1 then
		self.pagination:SetVisible(true);
	end
	
	-- load current page
	self:LoadQuests(self.cursor:CurPage());

end

function CompendiumQuestControl:AddFilters(filters)
	
	local count = 0;
	local filterText = rsrc["filters"] .. ' ';

	local distinctCats = {};
	for i,cat in pairs(self.currentIndexFilters) do distinctCats[cat] = i end;
	if filters.indexes ~= nil then
		for i,cat in pairs(filters.indexes) do
			if questindexes[cat] ~= nil then distinctCats[cat] = i end; 
		end
	end
	self.currentIndexFilters = {};
	for cat,v in pairs(distinctCats) do
		if count > 0 then filterText = filterText .. ', ' end;
		filterText = filterText .. cat;
		table.insert(self.currentIndexFilters, cat) 
		count = count + 1;
	end

	local manuals = {};
	for i,filter in pairs(self.currentManualFilters) do table.insert(manuals,filter) end;
	if filters.manual ~= nil then
		for cat,rec in pairs(filters.manual) do 
			rec.type = cat; 
			table.insert(manuals,rec); 
		end
	end
	self.currentManualFilters = {};
	for i,rec in pairs(manuals) do
		if count > 0 then filterText = filterText .. ', ' end;
		if rec.type == 'level' then
			if rec.from ~= nil and rec.to ~= nil then
				filterText = filterText .. string.format(rsrc["levelbtwn"], rec.from, rec.to);
				table.insert(self.currentManualFilters, rec); 
			elseif rec.from ~= nil then
				filterText = filterText .. string.format(rsrc["levelgt"],rec.from);
				table.insert(self.currentManualFilters, rec); 
			elseif rec.to ~= nil then
				filterText = filterText .. string.format(rsrc["levellt"],rec.to);
				table.insert(self.currentManualFilters, rec);
			end
		end
		count = count + 1;
	end
	
	self.filtersLabel:SetText(filterText);
	self:BuildCursor();
end

function CompendiumQuestControl:UpdateLocalRecord(questrecord, type, data)

	local quest = questrecord['name'];
	if self.localquestdata[quest] == nil then 
		self.localquestdata[quest] = {};
	end
	
	if type == 'addcomment' then
		if self.localquestdata[quest]['c'] == nil then
			self.localquestdata[quest]['c'] = { data }
		else
			table.insert(self.localquestdata[quest]['c'],data);
		end
		self.comments:AddCommentRecord(data, true);
		self.localquestdatamodified = true;
	elseif type == 'delcomment' then
		if self.localquestdata[quest]['c'] == nil then
			-- nothing to do
		else
			local comments = {};
			for i,c in pairs(self.localquestdata[quest]['c']) do 
				if c['time'] ~= data['time'] then
					table.insert(comments,c);
				end
			end
			self.localquestdata[quest]['c'] = comments;
			self.localquestdatamodified = true;
		end			
	else
		-- unknown update type
	end
			
end

function CompendiumQuestControl:persist()
	if self.localquestdatamodified then
		Turbine.Shell.WriteLine(rsrc["savingquests"]);
		Compendium.Common.Utils.PluginData.Save( Turbine.DataScope.Account, "LocalQuestData", self.localquestdata );
		self.localquestdatamodified = false;
		Turbine.Shell.WriteLine(rsrc["savingcomplete"]);
	end
end

function CompendiumQuestControl:LoadLocalQuests()
	self.localquestdata = Compendium.Common.Utils.PluginData.Load( Turbine.DataScope.Account , "LocalQuestData")
	if self.localquestdata == nil then
		self.localquestdata = {};
	end
end

function CompendiumQuestControl:AddCoordinate( record )
	if record == nil then return end;
	
	local coord = '';
	if record.target ~= rsrc["target"] then
		coord = record.target .. ' '..rsrc["in"]..' ';
	else
		coord = rsrc["inCapt"]..' ';
	end
	coord = coord .. record.area;
	if record.coord ~= nil then
		coord = coord .. ' @ ' .. record.coord;
	end  
	self.comments:AddToComment(coord);
	
end

function CompendiumQuestControl:CoordClicked( y, ns, x, ew, zone, name, quest )
	local mx, my = self:PointToClient(Turbine.UI.Display:GetMousePosition());
	local left, top = mx - 3, my - 3;
	self.coord:SetPosition(left, top);
	self.coord:ShowMenu( y, ns, x, ew, zone, name, quest );
end