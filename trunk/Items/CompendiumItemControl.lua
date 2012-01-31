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

import "Compendium.Items.CompendiumItemsDB";
import "Compendium.Common.Utils";
import "Compendium.Common.UI";
import "Compendium.Items.ItemCategoryMenu";
import "Compendium.Common.Resources";
local rsrc = {};

local rowHeight = 25;
	
local qualityMap = {
	u = "Uncommon",
	c = "Common",
	e = "Epic",
	r = "Rare",
	i = "Incomparable",
	un = "Unknown"
};
	
CompendiumItemControl = class( Compendium.Common.UI.CompendiumControl );
function CompendiumItemControl:Constructor()
    Compendium.Common.UI.CompendiumControl.Constructor( self );
	rsrc = Compendium.Common.Resources.Bundle:GetResources();
	
    local font = Compendium.Common.Resources.Settings:GetSetting('FontSize');
    --Turbine.Shell.WriteLine('Font: ' .. font);
    if font == 'large' then
    	rowHeight = 35;
    else 
    	rowHeight = 25;
    end	
	
	self.searchDisabled = true;
	self.currentIndexFilters = {};
	self.currentManualFilters = {};
	
	self.range = Compendium.Common.UI.LevelRangeControl();
	self.range:SetParent(self);
	self.range.RangeApplied = function( s, from, to )
		local rec = {};
		if from ~= nil then rec.from = tonumber(from) end;
		if to ~= nil then rec.to = tonumber(to) end;
		self:AddFilters({ manual = { level = rec } });
	end

    self.menu = Compendium.Items.ItemCategoryMenu();
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
    filterButton:SetText(" "..rsrc['filterby']);
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
        	--if #text > 4 or #self.currentIndexFilters > 0 then
            	self.SearchText.Text = text;
            	self:BuildCursor();
            --end
        end
    end

    -- add a search reset button
    local reset = Turbine.UI.Lotro.Button();
    reset:SetParent( self );
    reset:SetText( rsrc['reset']);
    reset:SetPosition( self.SearchBorder:GetLeft() + self.SearchBorder:GetWidth() + 1, self.SearchBorder:GetTop() );
    reset:SetSize( 50, self.SearchBorder:GetHeight() );
    reset.Click = function( sender, args )
		self:Reset();
    end

    local filtersLabel = Turbine.UI.Label();
    filtersLabel:SetParent(self);
    filtersLabel:SetPosition(5,filterButton:GetTop() +  filterButton:GetHeight());
    filtersLabel:SetSize(self:GetWidth() - 7,20);
    filtersLabel:SetFont(self.fontFace);
    filtersLabel:SetForeColor(self.trimColor);
    filtersLabel:SetText(rsrc['nofiltersset']);	
	self.filtersLabel = filtersLabel;

    self.itemContainer=Turbine.UI.Control();
    self.itemContainer:SetParent(self);
    self.itemContainer:SetPosition(5, filtersLabel:GetTop() +  filtersLabel:GetHeight());
    self.itemContainer:SetSize(self:GetWidth() - 7,self:GetHeight() - self.itemContainer:GetTop() - 70);
    self.itemContainer:SetBackColor(Turbine.UI.Color(0,0,0)); -- this one has to stay fixed for grid to show
    self.itemContainer.ItemList=Turbine.UI.ListBox();
    self.itemContainer.ItemList:SetParent(self.itemContainer);
    self.itemContainer.ItemList:SetPosition(2,1);
    self.itemContainer.ItemList:SetSize(self.itemContainer:GetWidth()-4,self.itemContainer:GetHeight()-3);
    self.itemContainer.ItemList:SetBackColor(self.backColor);
    self.itemContainer.ItemList.VScrollBar=Turbine.UI.Lotro.ScrollBar();
    self.itemContainer.ItemList.VScrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
    self.itemContainer.ItemList.VScrollBar:SetParent(self.itemContainer.ItemList);
    self.itemContainer.ItemList.VScrollBar:SetBackColor(self.backColor);
    self.itemContainer.ItemList.VScrollBar:SetPosition(self.itemContainer:GetWidth()-16,0)
    self.itemContainer.ItemList.VScrollBar:SetWidth(12);
    self.itemContainer.ItemList.VScrollBar:SetHeight(self.itemContainer:GetHeight()-2);
    self.itemContainer.ItemList:SetVerticalScrollBar(self.itemContainer.ItemList.VScrollBar);
	
    local aliasMenu = Compendium.Common.UI.ItemAliasMenu();
    aliasMenu:SetParent(self.itemContainer.ItemList);
    self.aliasMenu = aliasMenu;
    
    self.ClickEvent = function( item, args )
    	if args.Button == Turbine.UI.MouseButton.Right then
    		-- right mouse button
    		self.aliasMenu:ShowAliasMenu(item.record);
    		local lh = self.itemContainer.ItemList:GetHeight();
    		local mh = self.aliasMenu:GetHeight();
    		local left = item:GetLeft() + args.X - 3;
    		local top = item:GetTop() + args.Y - 3;
    		
    		if (top + mh) > lh then
    			top = lh - mh;
    		end 
    		
    		self.aliasMenu:SetPosition(left, top);
    	end
    end 
    
    local pagination = Compendium.Common.UI.PaginationControl();
    pagination:SetParent(self);
    pagination:SetSize(self.itemContainer:GetWidth(),20);
    pagination:SetPosition(5,self.itemContainer:GetTop() + self.itemContainer:GetHeight());
	pagination.PageChanged = function(sender,direction,records)
   		self:ClearItems();
		self:LoadItems(records);
   	end
    self.pagination = pagination;

    self:ClearItems();
	self:CalcPageSize();    

	self.searchDisabled = false;

	-- build default cursor
	self:BuildCursor();
	
	-- build resizing functions
 	self.SetHeight = function(sender,height)
        if height<80 then height=80 end;
        Turbine.UI.Control.SetHeight(self,height);
        local icheight = height - self.itemContainer:GetTop() - pagination:GetHeight();
        self.itemContainer:SetHeight(icheight);
        self.itemContainer.ItemList:SetHeight(icheight - 3);
        self.itemContainer.ItemList.VScrollBar:SetHeight(icheight - 2);
        pagination:SetTop(self.itemContainer:GetTop() + self.itemContainer:GetHeight());

		-- recalculate # of rows we can show on screen per page
        self:CalcPageSize();
        if self.cursor ~= nil then
        	self.cursor:SetPageSize(self.pagesize);
	   		self:ClearItems();
			self:LoadItems(self.cursor:CurPage());
			self.pagination:UpdatePagination();
		end
    end
    
 	self.SetWidth = function(sender,width)
 		--Turbine.Shell.WriteLine(width);
        if width<100 then width=100 end;
        Turbine.UI.Control.SetWidth(self,width);
		local swidth = width - (searchLabel:GetWidth()+searchLabel:GetLeft())-55;
    	self.SearchBorder:SetWidth(swidth);
    	self.SearchText:SetWidth(swidth);
	    reset:SetLeft( self.SearchBorder:GetLeft() + self.SearchBorder:GetWidth() + 1 );
	
        local icwidth = width - 7;
        self.itemContainer:SetWidth(icwidth);
        self.itemContainer.ItemList:SetWidth(icwidth - 4);
		self.itemContainer.ItemList.VScrollBar:SetLeft(icwidth-16,0)        
		for index=1,self.itemContainer.ItemList:GetItemCount() do
			local label = self.itemContainer.ItemList:GetItem(index);
			label:SetWidth(icwidth - 13);
		end
		pagination:SetWidth(icwidth);
    end
	
	self.SetSize = function(sender,width, height) 
		self:SetWidth(width);
		self:SetHeight(height);
	end	
	
end

function CompendiumItemControl:ClearItems()
	for index=1,self.itemContainer.ItemList:GetItemCount() do
		local item = self.itemContainer.ItemList:GetItem(index);
		self:strip(item, 1);
	end	
    self.itemContainer.ItemList:ClearItems();
    self.prevIdx = nil;
end

function CompendiumItemControl:BuildCursor()
	if self.searchDisabled then
		return;
	end
	self.pagination:SetCursor(nil);
	self:ClearItems();
	
	-- filter results using our category indexes
	local ids = nil;
	for i,cat in pairs(self.currentIndexFilters) do
		if itemindexes[cat] ~= nil then
			ids = self:JoinIndex(ids,itemindexes[cat]);
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
			self.cursor = Compendium.Common.Utils.DataCursor(itemstable, self.pagesize);
			self:LoadItems(self.cursor:CurPage());
			self.pagination:SetCursor(self.cursor);   
			return;
		end 	
    end

	-- build data set	
	local data = itemstable;
	if ids ~= nil then
		data = ids 
	end;
	local recs = {};
    local count = 0;
	for a, b in pairs(data) do
		local id = a;
		if ids ~= nil then id = b end;

		--Turbine.Shell.WriteLine('a:' .. a .. ' b:' .. b .. ' id:' .. id);		
		local rec = itemstable[id];
        local include = true;
        if not ise then
            if string.find(string.lower(rec["n"]),escapedSearch) == nil then
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
					if rec['l'] < from or rec['l'] > to then
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
	self.cursor = Compendium.Common.Utils.DataCursor(recs, self.pagesize);
	
	-- load current page
	self:LoadItems(self.cursor:CurPage());
	self.pagination:SetCursor(self.cursor); 
	
end

function CompendiumItemControl:AddFilters(filters)
	
	local count = 0;
	local filterText = rsrc['filters']..' ';

	local distinctCats = {};
	for i,cat in pairs(self.currentIndexFilters) do distinctCats[cat] = i end;
	if filters.indexes ~= nil then
		for i,cat in pairs(filters.indexes) do
			if itemindexes[cat] ~= nil then distinctCats[cat] = i end; 
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

function CompendiumItemControl:JoinIndex(a, b)
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

local makesc = function(hex, quicks) 
	local shortcut = Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Item , string.format('0x0000000000000000,0x%s', hex ))
	quicks:SetShortcut( shortcut );
	quicks.DragDrop=function()
		--quicks:SetShortcut(shortcut);
	end
	quicks.MouseDown=function()
		-- hack to prevent real item from being consumed by a click
		quicks:SetShortcut(nil);
		quicks:SetShortcut(shortcut);
	end	
	return shortcut, type;
end

function CompendiumItemControl:LoadItems(records)

    local bgColor = self.itemContainer.ItemList:GetBackColor();
    local width = self.itemContainer.ItemList:GetWidth();
    local playerLevel = Turbine.Gameplay.LocalPlayer.GetInstance():GetLevel();
	local useItemQs = true == Compendium.Common.Resources.Settings:GetSetting('ShowItemQuickslots');
	
    for i,rec in pairs(records) do
        local level = rec["l"];
        local cats = {};
        for i,c in pairs(rec['c']) do
        	if 'Quest Reward' == categoryids[c] then
        		c = rsrc["questreward"] .. ' (' .. rec['qu'] .. ')';
        	elseif 'Craftable' == categoryids[c] then
        		c = rsrc["craftable"] .. ' (' .. rec['lb'] .. ')';
        	else
        		c = categoryids[c];
        	end
        	table.insert(cats,c);
        end
        local cat = table.concat(cats,', ');
        
        local name = self:FormatItem(rec) .. ' '..rsrc['lvl'] .. level .. ' | ' .. qualityMap[rec['q']] .. ' | ' .. cat;
        
        if rec['lg'] ~= nil then name = name .. ' | ' .. rsrc["legendary"] end;
        if rec['ib'] ~= nil then name = name .. ' | ' .. rec['ib'] end;
        if rec['nt'] ~= nil then name = name .. ' | ' .. rec['nt'] end;
        
        local itemRow = Turbine.UI.Control();
        itemRow:SetSize(width - 13, rowHeight);
        itemRow:SetBackColor(bgColor);

        local left = 0;
        local width = itemRow:GetWidth(); 
        
        if useItemQs then
			local qs = Turbine.UI.Lotro.Quickslot();
			qs:SetSize(35,35);
			qs:SetVisible(true);	        
	        qs:SetAllowDrop(false); 
	        qs:SetEnabled(false);	
	        local s = pcall(makesc, rec['id'], qs);
	        if s then
				qs:SetParent(itemRow);
				qs:SetPosition(left, 0);
				width = width - 35;
				left = 36;
			end
        end
        
        local label = Turbine.UI.Label();
        label:SetSize(width, rowHeight);
        label:SetParent(itemRow);
        label:SetPosition(left,0);
        label:SetText(name);
        label:SetBackColor(bgColor);
        label:SetFont(self.fontFaceSmall);
        label:SetSelectable(true);
        label.record = { id = rec['id'], name = rec['n'] };
        label.MouseClick = self.ClickEvent;        
        
        local color = self.fontColor;
        if level ~= nil and level ~= '' then
            color = self:GetLevelColor(playerLevel, tonumber(level));
        end
        label:SetForeColor(color);
        self.itemContainer.ItemList:AddItem(itemRow);

    end
    
end

function CompendiumItemControl:Reset() 
	self.searchDisabled = true;
	self:ClearItems();	
	self.SearchText:SetText('');
	self.currentIndexFilters = {};
	self.currentManualFilters = {};
	self.filtersLabel:SetText(rsrc['nofiltersset']);
	self.cursor = nil;
	self.searchDisabled = false;
	self:BuildCursor();	
end

function CompendiumItemControl:FormatItem(record)
	local item = '';
	if record['id'] ~= nil then
		local name = record['n'];
		--[[
		if #name > 30 then
			name = string.sub(name, 1, 30)  .. "...";
		end
		]]
		item = string.format(self.itemExampleTpl,record['id'],name);
	else
		--Turbine.Shell.WriteLine(record['id']);
		item = '['..record['n']..']';
	end
	return item; 
end

function CompendiumItemControl:CalcPageSize() 

	local listHeight = self.itemContainer.ItemList:GetHeight();

	self.pagesize = math.floor(listHeight / rowHeight);

end