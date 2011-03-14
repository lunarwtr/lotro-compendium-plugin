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

import "Compendium.Common.Utils";
import "Compendium.Common.UI";
import "Compendium.Crafts.CompendiumCraftsDB";
import "Compendium.Crafts.CraftCategoryMenu";

local rowHeight = 45;
	
CompendiumCraftControl = class( Compendium.Common.UI.CompendiumControl );
function CompendiumCraftControl:Constructor()
    Compendium.Common.UI.CompendiumControl.Constructor( self );

	self.searchDisabled = true;

    self.menu = Compendium.Crafts.CraftCategoryMenu();
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

    self.craftContainer=Turbine.UI.Control();
    self.craftContainer:SetParent(self);
    self.craftContainer:SetPosition(5, filtersLabel:GetTop() +  filtersLabel:GetHeight());
    self.craftContainer:SetSize(self:GetWidth() - 7,self:GetHeight() - self.craftContainer:GetTop() - 70);
    self.craftContainer:SetBackColor(Turbine.UI.Color(0,0,0)); -- this one has to stay fixed for grid to show
    self.craftContainer.CraftList=Turbine.UI.ListBox();
    self.craftContainer.CraftList:SetParent(self.craftContainer);
    self.craftContainer.CraftList:SetPosition(2,1);
    self.craftContainer.CraftList:SetSize(self.craftContainer:GetWidth()-4,self.craftContainer:GetHeight()-3);
    self.craftContainer.CraftList:SetBackColor(self.backColor);
    self.craftContainer.CraftList.VScrollBar=Turbine.UI.Lotro.ScrollBar();
    self.craftContainer.CraftList.VScrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
    self.craftContainer.CraftList.VScrollBar:SetParent(self.craftContainer.CraftList);
    self.craftContainer.CraftList.VScrollBar:SetBackColor(self.backColor);
    self.craftContainer.CraftList.VScrollBar:SetPosition(self.craftContainer:GetWidth()-16,0)
    self.craftContainer.CraftList.VScrollBar:SetWidth(12);
    self.craftContainer.CraftList.VScrollBar:SetHeight(self.craftContainer:GetHeight()-2);
    self.craftContainer.CraftList:SetVerticalScrollBar(self.craftContainer.CraftList.VScrollBar);
	
	-- item linking menu
    local aliasMenu = Compendium.Common.UI.ItemAliasMenu();
    aliasMenu:SetParent(self.craftContainer.CraftList);
    self.aliasMenu = aliasMenu;
    
    -- ingrediants menu
	self.ingMenu = Compendium.Common.UI.LabelMenu();
	self.ingMenu:SetParent(self.craftContainer.CraftList);
    self.ingMenu:SetRowHighlight(false);
    
    self.itemEvents = {
    	ItemClickEvent = function( item, args )
	    	if args.Button == Turbine.UI.MouseButton.Right then
	    		-- right mouse button
	    		self.aliasMenu:ShowAliasMenu(item.record);
	    		local lh = self.craftContainer.CraftList:GetHeight();
	    		local mh = self.aliasMenu:GetHeight();
	    		local left = item:GetParent():GetLeft() + item:GetLeft() + args.X - 3;
	    		local top = item:GetParent():GetTop() + item:GetTop() + args.Y - 3;
	    		
	    		if (top + mh) > lh then
	    			top = lh - mh;
	    		end 
	    		
	    		self.aliasMenu:SetPosition(left, top);
	    	end
	    end,
	    RecipeClickEvent = function( recipe, args, record )
    		self:LoadIngrediants(record);
			self.ingMenu:ShowMenu();
    		local lh = self.craftContainer.CraftList:GetHeight();
    		local mh = self.ingMenu:GetHeight();
    		local left = recipe:GetParent():GetLeft() + recipe:GetLeft() + args.X - 3;
    		local top = recipe:GetParent():GetTop() + recipe:GetTop() + args.Y - 3;
    		if (top + mh) > lh then
    			top = lh - mh;
    		end 
    		self.ingMenu:SetPosition(left, top);
	    end,
		LabelEnter = function(sender,a) 
			sender:SetOutlineColor(self.fontColor);
		    sender:SetFontStyle(Turbine.UI.FontStyle.Outline);
		end,
		LabelLeave = function(sender,a) 
			sender:SetOutlineColor(Turbine.UI.Color(0,0,0));
		    sender:SetFontStyle(nil);
		end	    
	     
    };
    
    local pagination = Turbine.UI.Label();
    pagination:SetParent(self);
    pagination:SetSize(self.craftContainer:GetWidth(),20);
    pagination:SetPosition(5,self.craftContainer:GetTop() + self.craftContainer:GetHeight());
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
	
	-- build resizing functions
 	self.SetHeight = function(sender,height)
        if height<80 then height=80 end;
        Turbine.UI.Control.SetHeight(self,height);
        local icheight = height - self.craftContainer:GetTop() - pagination:GetHeight();
        self.craftContainer:SetHeight(icheight);
        self.craftContainer.CraftList:SetHeight(icheight - 3);
        self.craftContainer.CraftList.VScrollBar:SetHeight(icheight - 2);
        pagination:SetTop(self.craftContainer:GetTop() + self.craftContainer:GetHeight());

		-- recalculate # of rows we can show on screen per page
        self:CalcPageSize();
        if self.cursor ~= nil then
        	self.cursor:SetPageSize(self.pagesize);
	   		self:ClearItems();
			self:LoadItems(self.cursor:CurPage());
			self:UpdatePagination();  
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
        self.craftContainer:SetWidth(icwidth);
        self.craftContainer.CraftList:SetWidth(icwidth - 4);
		self.craftContainer.CraftList.VScrollBar:SetLeft(icwidth-16,0)        
		for index=1,self.craftContainer.CraftList:GetItemCount() do
			local label = self.craftContainer.CraftList:GetItem(index);
			label:SetWidth(icwidth - 13);
		end
		pagination:SetWidth(icwidth);
		nextBtn:SetLeft(icwidth - nextBtn:GetWidth());
    end
	
	self.SetSize = function(sender,width, height) 
		self:SetWidth(width);
		self:SetHeight(height);
	end	

end

function CompendiumCraftControl:ClearItems()
	for index=1,self.craftContainer.CraftList:GetItemCount() do
		local item = self.craftContainer.CraftList:GetItem(index);
		self:strip(item, 1);
	end	
    self.craftContainer.CraftList:ClearItems();
    self.prevIdx = nil;
	self.prevBtn:SetEnabled(false);
	self.nextBtn:SetEnabled(false);
	self.pagination:SetText('');
end

function CompendiumCraftControl:BuildCursor()
	if self.searchDisabled then
		return;
	end
	
	self:ClearItems();
	
	-- filter results using our category indexes
	local ids = nil;
	for i,cat in pairs(self.currentFilters) do
		if craftindexes[cat] ~= nil then
			ids = self:JoinIndex(ids,craftindexes[cat]);
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
			self.cursor = Compendium.Common.Utils.DataCursor(crafttable, self.pagesize);
			self:LoadItems(self.cursor:CurPage());
			self:UpdatePagination();   
			return;
		end 	
    end

	-- build data set	
	local data = crafttable;
	if ids ~= nil then
		data = ids 
	end;
	local recs = {};
    local count = 0;
	for a, b in pairs(data) do
		local id = a;
		if ids ~= nil then id = b end;

		--Turbine.Shell.WriteLine('a:' .. a .. ' b:' .. b .. ' id:' .. id);		
		local rec = crafttable[id];
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
	self.cursor = Compendium.Common.Utils.DataCursor(recs, self.pagesize);
	
	-- load current page
	self:LoadItems(self.cursor:CurPage());
	self:UpdatePagination();
	
end

function CompendiumCraftControl:UpdatePagination()
	self.prevBtn:SetEnabled(false);
	self.nextBtn:SetEnabled(false);
	self.pagination:SetText('');
	if self.cursor ~= nil then
		self.pagination:SetText(self.cursor:tostring());
		if self.cursor:HasPrev() then self.prevBtn:SetEnabled(true) end;
		if self.cursor:HasNext() then self.nextBtn:SetEnabled(true) end;
	end
end

function CompendiumCraftControl:AddFilters(categories)
	
	local distinctCats = {};
	for i,cat in pairs(self.currentFilters) do distinctCats[cat] = i end;
	for i,cat in pairs(categories) do
		if craftindexes[cat] ~= nil then distinctCats[cat] = i end; 
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

function CompendiumCraftControl:JoinIndex(a, b)
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

function CompendiumCraftControl:LoadItems(records)

    local bgColor = self.craftContainer.CraftList:GetBackColor();
    local width = self.craftContainer.CraftList:GetWidth();
    local playerLevel = Turbine.Gameplay.LocalPlayer.GetInstance():GetLevel();

	--[[
	{
		["r"] = {["n"] = "Ancient Silver Flint Rune-stone", ["id"] = 1879112496}, 
		["c"] = {["n"] = "Splendid Ancient Silver Flint Rune-stone", ["id"] = 1879112489}, 
		["u"] = "Unlimited", 
		["tr"] = 5, 
		["n"] = "Ancient Silver Flint Rune-stone Recipe", 
		["ing"] = {
			{["n"] = "Ancient Silver Ingot", ["id"] = 1879055415, ["nu"] = "x2"}, 
			{["n"] = "Chunk of Blue Rock-salt", ["id"] = 1879157857, ["nu"] = "x1 (optional)"}
		}, 
		["t"] = "Jeweller",
		["f"] = {["n"] = "Heavy Cotton Robe Recipe", ["id"] = 1879087416}
	}
	]]


    for i,rec in pairs(records) do
        --Turbine.Shell.WriteLine(rec['n']);
        
        local det = rec['t'];
        if rec['tr'] ~= '' then
        	det = det .. ' Tier ' .. rec['tr'];
        end
        det = det .. ' | Usage: ' .. rec['u'];

        local row = Turbine.UI.Control();
        row:SetSize(width - 13, rowHeight);

		local lwidth = (row:GetWidth() / 2) - 80; 
        local label = Compendium.Common.UI.AutoSizingLabel(); --Turbine.UI.Label();
        
        label:SetText(rec['n']);
        label:SetBackColor(bgColor);
        label:SetFont(Turbine.UI.Lotro.Font.Verdana14);
        label:SetSelectable(true);
        label:SetParent(row);
        label:SetForeColor(self.fontColor);
        label:SetPosition(0,0);
		label:SetSize(lwidth, 'auto');
		label.MouseClick = function(s,a) 
			self.itemEvents.RecipeClickEvent(s,a,rec);
		end
		label.MouseEnter = self.itemEvents.LabelEnter;
		label.MouseLeave = self.itemEvents.LabelLeave;
		
        local detail = Turbine.UI.Label();
		detail:SetParent(row);
        detail:SetSize(lwidth, 10);
        detail:SetMultiline(false);
        detail:SetText(det);
        detail:SetBackColor(bgColor);
        detail:SetFont(Turbine.UI.Lotro.Font.Verdana12);
        detail:SetSelectable(true);     
        detail:SetForeColor(self.trimColor);
		detail:SetPosition(0, 26);
		label.SizeChanged = function(s,a)
			detail:SetPosition(0, label:GetHeight());
		end        
        
        local iwidth = row:GetWidth() - lwidth;
        
        local top = 0;
        local regular = Turbine.UI.Label();
		regular:SetParent(row);
        regular:SetSize(iwidth, 13);
        regular:SetMultiline(false);
        regular:SetText('Reg:' .. self:FormatItem(rec['r']));
        regular:SetBackColor(bgColor);
        regular:SetFont(Turbine.UI.Lotro.Font.Verdana13);
        regular:SetSelectable(true);
        if rec['r']['id'] ~= nil then
	        regular.record = { name = rec['r']['n'], id = rec['r']['id'] };
	        regular.MouseClick = self.itemEvents.ItemClickEvent;        
        end
        regular:SetForeColor(self.white);
		regular:SetPosition(label:GetWidth(),0);
		top = regular:GetHeight();
		
		if rec['c'] ~= nil then
	 		local crit = Turbine.UI.Label();
	        crit:SetParent(row);
	        crit:SetSize(iwidth, 13);
	        crit:SetMultiline(false);
	        crit:SetText('Crit:' .. self:FormatItem(rec['c']));
	        crit:SetBackColor(bgColor);
	        crit:SetFont(Turbine.UI.Lotro.Font.Verdana13);
	        crit:SetSelectable(true);
	        if rec['c']['id'] ~= nil then
		        crit.record = { name = rec['c']['n'], id = rec['c']['id'] };
		        crit.MouseClick = self.itemEvents.ItemClickEvent;
	        end        
	        crit:SetForeColor(self.white);
	        crit:SetPosition(label:GetWidth(),top);
	        top = top + crit:GetHeight();
        end
        
        if rec['f'] ~= nil then
        	local learn = Turbine.UI.Label();
			learn:SetParent(row);
	        learn:SetSize(iwidth, 13);
	        learn:SetMultiline(false);
	        learn:SetText('Learn:' .. self:FormatItem(rec['f']));
	        learn:SetBackColor(bgColor);
	        learn:SetFont(Turbine.UI.Lotro.Font.Verdana13);
	        learn:SetSelectable(true);
	        if rec['f']['id'] ~= nil then
		        learn.record = { name = rec['f']['n'], id = rec['f']['id'] };
		        learn.MouseClick = self.itemEvents.ItemClickEvent;
		    end        
	        learn:SetForeColor(self.white);
			learn:SetPosition(label:GetWidth(), top);
        end
        self.craftContainer.CraftList:AddItem(row);
    end
    
end

function CompendiumCraftControl:LoadIngrediants( rec )

	local menu = self.ingMenu;
	
	-- if that item is currently loaded, return
	if menu.loadedItem == rec['n'] then return end;
	
	menu:ClearMenu();
	
	local label = Turbine.UI.Label();
    label:SetParent( menu );
    label:SetText('Ingrediants');
    label:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
    label:SetSize( 250, 18 );
    label:SetFont(self.fontFace);
    label:SetForeColor(self.fontColor);	
	menu:AddItem(label);
	
	if rec['ing'] ~= nil and #rec['ing'] > 0 then
		for i, r in pairs(rec['ing']) do
			label = Turbine.UI.Label();
		    label:SetParent( menu );
		    label:SetMultiline(false);
		    label:SetText(self:FormatItem(r));
		    label:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		    label:SetSize( 250, 18 );
		    label:SetFont(self.fontFace);
		    label:SetForeColor(self.fontColor);		
			menu:AddItem(label);
		end
	else
		label = Turbine.UI.Label();
	    label:SetParent( menu );
	    label:SetText( '  (unknown)' );
	    label:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	    label:SetSize( 250, 18 );
	    label:SetFont(self.fontFace);
	    label:SetForeColor(self.fontColor);			
		menu:AddItem(label);
	end
	
end

function CompendiumCraftControl:Reset() 
	self.searchDisabled = true;
	self.ingMenu:ClearMenu();	
	self:ClearItems();
	self.SearchText:SetText('');
	self.currentFilters = {};
	self.filtersLabel:SetText('No filters set');
	self.cursor = nil;
	self.searchDisabled = false;
	self:BuildCursor();	
end

function CompendiumCraftControl:FormatItem(record)
	local item = '';
	if record['id'] ~= nil then
		local name = record['n'];
		item = string.format(self.itemExampleTpl,record['id'],name);
	else
		item = '['..record['n']..']';
	end
	if record['nu'] ~= nil then
		item = item .. ' ' .. record['nu'];
	end
	return item; 
end

function CompendiumCraftControl:CalcPageSize() 

	local listHeight = self.craftContainer.CraftList:GetHeight();

	self.pagesize = math.floor(listHeight / rowHeight);

end