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
import "Compendium.Items.DataCursor";
import "Compendium.Items.CategoryMenu";
import "Compendium.Common";
import "Compendium.Common.UI";
import "Compendium.Items.ItemAliasMenu";

local rowHeight = 25;
	
CompendiumItemControl = class( Compendium.Common.UI.CompendiumControl );
function CompendiumItemControl:Constructor()
    Compendium.Common.UI.CompendiumControl.Constructor( self );

	self.searchDisabled = true;

    self.menu = Compendium.Items.CategoryMenu();
    self.menu.ClickCategory = function(categories) 
		self:AddFilters(categories);
	end
    
    local filterButton = Turbine.UI.Lotro.Button();
    filterButton:SetParent(self);
    filterButton:SetPosition(9,3);
    filterButton:SetSize(85,20);
    filterButton:SetText(" Filter By");
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
    searchLabel:SetText("Search:");

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
        	--if #text > 4 or #self.currentFilters > 0 then
            	self.SearchText.Text = text;
            	self:BuildCursor();
            --end
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

    local filtersLabel = Turbine.UI.Label();
    filtersLabel:SetParent(self);
    filtersLabel:SetPosition(5,filterButton:GetTop() +  filterButton:GetHeight());
    filtersLabel:SetSize(self:GetWidth() - 7,20);
    filtersLabel:SetFont(self.fontFace);
    filtersLabel:SetForeColor(self.trimColor);
    filtersLabel:SetText("No filters set");	
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
    
    local aliasMenu = Compendium.Items.ItemAliasMenu();
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
    
    local pagination = Turbine.UI.Label();
    pagination:SetParent(self);
    pagination:SetSize(self.itemContainer:GetWidth(),20);
    pagination:SetPosition(5,self.itemContainer:GetTop() + self.itemContainer:GetHeight());
   	pagination:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
    pagination:SetFont(self.fontFace);
    pagination:SetForeColor(self.fontColor);
    pagination:SetOutlineColor(Turbine.UI.Color(0,0,0));
    pagination:SetFontStyle(Turbine.UI.FontStyle.Outline);

   	local prev = function(sender,args)
   		self:ClearItems();
		self:LoadItems(self.cursor:PrevPage());
		self:UpdatePagination();   	
   	end
	local next = function(sender,args)
   		self:ClearItems();
		self:LoadItems(self.cursor:NextPage());
		self:UpdatePagination();   	
   	end   	
    
    local prevBtn = Turbine.UI.Lotro.Button();
    prevBtn:SetParent(pagination);
    prevBtn:SetText('  Prev');
    prevBtn:SetEnabled(false);
   	prevBtn:SetSize(55,20);
   	prevBtn:SetPosition(0,0);
   	prevBtn.Click = prev;
 	local prevIcon = Turbine.UI.Control();
    prevIcon:SetParent( prevBtn );
    prevIcon:SetBackground(0x41007e0e);
    prevIcon:SetBlendMode(Turbine.UI.BlendMode.Overlay);
    prevIcon:SetPosition( 3, 3 );
    prevIcon:SetSize( 16, 16 );
   	prevIcon.MouseClick = prev;
   	
    local nextBtn = Turbine.UI.Lotro.Button();
    nextBtn:SetParent(pagination);
    nextBtn:SetText(' Next');
    nextBtn:SetEnabled(false);
   	nextBtn:SetSize(55,20);
   	nextBtn:SetPosition(pagination:GetWidth() - nextBtn:GetWidth(),0);   
   	nextBtn:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
   	nextBtn.Click = next;
 	local nextIcon = Turbine.UI.Control();
    nextIcon:SetParent( nextBtn );
    nextIcon:SetBackground(0x41007e11);
    nextIcon:SetBlendMode(Turbine.UI.BlendMode.Overlay);
    nextIcon:SetPosition(nextBtn:GetWidth() - 20, 3 );
    nextIcon:SetSize( 16, 16 );   	
   	nextIcon.MouseClick = next;

	self.prevBtn = prevBtn;
	self.nextBtn = nextBtn;
    self.pagination = pagination;

    self:ClearItems();
	self:CalcPageSize();    
	self.searchDisabled = false;
	self.currentFilters = {};
	
	-- build default cursor
	self:BuildCursor();
end

function CompendiumItemControl:ClearItems()
    self.itemContainer.ItemList:ClearItems();
    self.prevIdx = nil;
	self.prevBtn:SetEnabled(false);
	self.nextBtn:SetEnabled(false);
	self.pagination:SetText('');
end

function CompendiumItemControl:BuildCursor()
	if self.searchDisabled then
		return;
	end
	
	self:ClearItems();
	
	-- filter results using our category indexes
	local ids = nil;
	for i,cat in pairs(self.currentFilters) do
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
    else
    	-- if no search and no indexes use default cursor
    	if ids == nil then
			self.cursor = DataCursor(itemstable, self.pagesize);
			self:LoadItems(self.cursor:CurPage());
			self:UpdatePagination();   
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
            if string.find(string.lower(rec["n"]),escapedSearch) ~= 1 then
                include = false;
            end
        end
        if include then
            count = count + 1;
            table.insert(recs,rec);
        end
	end;
	
	-- create pagination cursor for results
	self.cursor = DataCursor(recs, self.pagesize);
	
	-- load current page
	self:LoadItems(self.cursor:CurPage());
	self:UpdatePagination();
	
end

function CompendiumItemControl:UpdatePagination()
	self.prevBtn:SetEnabled(false);
	self.nextBtn:SetEnabled(false);
	self.pagination:SetText('');
	if self.cursor ~= nil then
		self.pagination:SetText(self.cursor:tostring());
		if self.cursor:HasPrev() then self.prevBtn:SetEnabled(true) end;
		if self.cursor:HasNext() then self.nextBtn:SetEnabled(true) end;
	end
end

function CompendiumItemControl:AddFilters(categories)
	
	local distinctCats = {};
	for i,cat in pairs(self.currentFilters) do distinctCats[cat] = i end;
	for i,cat in pairs(categories) do
		if itemindexes[cat] ~= nil then distinctCats[cat] = i end; 
	end
	self.currentFilters = {};
	local count = 0;
	local filterText = 'Filters: ';
	for cat,v in pairs(distinctCats) do
		if count > 0 then filterText = filterText .. ', ' end;
		filterText = filterText .. cat;
		table.insert(self.currentFilters, cat) 
		count = count + 1;
	end;
	
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

function CompendiumItemControl:LoadItems(records)

    local bgColor = self.itemContainer.ItemList:GetBackColor();
    local width = self.itemContainer.ItemList:GetWidth();
    local playerLevel = Turbine.Gameplay.LocalPlayer.GetInstance():GetLevel();

    for i,rec in pairs(records) do
        local level = rec["l"];
        local cat = table.concat(rec['c'],', ');
        local name = self:FormatItem(rec) .. ' lvl' .. level .. ' | ' .. rec['q'] .. ' | ' .. cat;
        
        if rec['lg'] ~= nil then name = name .. ' | Legendary' end;
        if rec['ib'] ~= nil then name = name .. ' | ' .. rec['ib'] end;
        
        local label = Turbine.UI.Label();
        label:SetSize(width - 10, rowHeight);
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
        self.itemContainer.ItemList:AddItem(label);

    end
    
end

function CompendiumItemControl:Reset() 
	self.searchDisabled = true;
	self:ClearItems();	
	self.SearchText:SetText('');
	self.currentFilters = {};
	self.filtersLabel:SetText('No filters set');
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
		--item = '['..record['n']..']';
	end
	return item; 
end

function CompendiumItemControl:CalcPageSize() 

	local listHeight = self.itemContainer.ItemList:GetHeight();

	self.pagesize = math.floor(listHeight / rowHeight);

end