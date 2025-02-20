
import "Turbine";
import "Turbine.Gameplay";
import "Turbine.UI";
import "Turbine.UI.Lotro";

import "Compendium.Deeds.CompendiumDeedsDB";
import "Compendium.Deeds.DeedCommentsControl";
import "Compendium.Deeds.DeedCategoryMenu";
import "Compendium.Common.Utils";
import "Compendium.Common.UI";
import "Compendium.Common.Resources.Bundle";

---@type Deed[]
---@diagnostic disable-next-line: lowercase-global
deedtable = deedtable or {}

local rsrc = {};

local pagesize = 200;
local rewardLabels = {
	"xp", "cp", "cx", "em", "gl", "ix", "lp", "mo", "mx", "rc", "ri", "so", "ti", "tr", "vr", "vx"
};

CompendiumDeedControl= class( Compendium.Common.UI.CompendiumControl );
function CompendiumDeedControl:Constructor(language)
    Compendium.Common.UI.CompendiumControl.Constructor( self );
	rsrc = Compendium.Common.Resources.Bundle:GetResources();

	self.deedprogressionmodified = false;
	self.deedprogression = {};
	self.localdeeddatamodified = false;
	self.localdeeddata = {};
    self.currentIndexFilters = {};
    self.currentManualFilters = {};
	self.searchDisabled = true;
	self:LoadLocalDeeds();

	self.range = Compendium.Common.UI.LevelRangeControl();
	self.range:SetParent(self);
	self.range.RangeApplied = function( s, from, to )
		local rec = {};
		if from ~= nil then rec.from = tonumber(from) end;
		if to ~= nil then rec.to = tonumber(to) end;
		self:AddFilters({ manual = { level = rec } });
	end

    self.menu = Compendium.Deeds.DeedCategoryMenu();
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
    	elseif size > 0 and (categories[size] == 'Complete' or categories[size] == 'Incomplete') then
	   		self:AddFilters({ manual = { progression = { value = (categories[size] == 'Complete') } } });
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
                self:SearchAndLoadDeeds(self.SearchText:GetText(), self.ZoneList:GetValue(), self.LevelList:GetValue());
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
    self.qlContainer.DeedList=Turbine.UI.ListBox();
    self.qlContainer.DeedList:SetParent(self.qlContainer);
    self.qlContainer.DeedList:SetPosition(2,19);
    self.qlContainer.DeedList:SetSize(self.qlContainer:GetWidth()-4,self.qlContainer:GetHeight()-21);
    self.qlContainer.DeedList:SetBackColor(self.backColor);
    self.qlContainer.DeedList.VScrollBar=Turbine.UI.Lotro.ScrollBar();
    self.qlContainer.DeedList.VScrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
    self.qlContainer.DeedList.VScrollBar:SetParent(self.qlContainer.DeedList);
    self.qlContainer.DeedList.VScrollBar:SetBackColor(self.backColor);
    self.qlContainer.DeedList.VScrollBar:SetPosition(self.qlContainer:GetWidth()-16,0)
    self.qlContainer.DeedList.VScrollBar:SetWidth(12);
    self.qlContainer.DeedList.VScrollBar:SetHeight(self.qlContainer.DeedList:GetHeight()-2);
    self.qlContainer.DeedList:SetVerticalScrollBar(self.qlContainer.DeedList.VScrollBar);
    self.qlContainer.DeedList.SelectedIndexChanged=function(sender, args)
        local idx = self.qlContainer.DeedList:GetSelectedIndex();
        if self.prevIdx ~= nil then
            local oldItem = self.qlContainer.DeedList:GetItem(self.prevIdx);
            if oldItem ~= nil then
                oldItem:GetControls():Get(1):SetBackColor(self.backColor);
            end
        end
        if idx ~= 0 then
            self.prevIdx = idx;
            local item = self.qlContainer.DeedList:GetItem(idx);
            item:GetControls():Get(1):SetBackColor(self.selBackColor);
            -- Display Deed
            self:LoadDeedDetails( deedtable[item.DeedId]);
        end

    end

    local qlHeader = Turbine.UI.Control();
    qlHeader:SetSize(self.qlContainer:GetWidth()-16, 19);
    qlHeader:SetParent(self.qlContainer);
    qlHeader:SetPosition(2, 1);
    qlHeader:SetBackColor( self.colorDarkGrey);
    local nameCol = Turbine.UI.Label();
    nameCol:SetMultiline(false);
    nameCol:SetParent(qlHeader);
    nameCol:SetPosition( 2, 1 );
    nameCol:SetSize(qlHeader:GetWidth() - 30, 17);
    nameCol:SetSelectable(true);
    nameCol:SetText(rsrc['deedheader']);
    nameCol:SetBackColor( self.colorDarkGrey);
    nameCol:SetFont(self.fontFace);
    nameCol:SetForeColor(self.fontColor);
    nameCol:SetOutlineColor(Turbine.UI.Color(0,0,0));
    nameCol:SetFontStyle(Turbine.UI.FontStyle.Outline);
    nameCol:SetTextAlignment( Turbine.UI.CheckBox.MiddleCenter );

	local selectAllCB = Turbine.UI.Lotro.CheckBox();
    selectAllCB:SetParent( qlHeader );
    selectAllCB:SetPosition(nameCol:GetWidth(), 1);
    selectAllCB:SetSize( 25, 18 );
    selectAllCB:SetChecked(false);
    selectAllCB:SetText('');
    selectAllCB.undo = false;
	selectAllCB.CheckedChanged = function(s,a)
		if s.undo then return end;
		local val = s:IsChecked();
		local type = rsrc['complete'];
		if not val then type = rsrc['incomplete'] end;
		Compendium.Common.UI.Dialog.Confirm:Show(rsrc['confirm'], string.format(rsrc['selectdeedmsg'],type),
							function()
								self:UpdateAllFilteredRecord('modifyprog',s:IsChecked());
							end,
							function()
								s.undo = true;
								s:SetChecked(not val);
								s.undo = false;
							end);
	end
	qlHeader.SetWidth = function(s, w)
		Turbine.UI.Control.SetWidth(s, w);
		local ncw = w - 16;
		nameCol:SetWidth(ncw);
		selectAllCB:SetLeft(ncw);
	end

    local pagination = Compendium.Common.UI.PaginationControl();
    pagination:SetParent(self.qlContainer);
    pagination:SetVisible(false);
    pagination:SetSize(self.qlContainer:GetWidth(),20);
    pagination:SetPosition(0,self.qlContainer:GetHeight() - 22);
	pagination.PageChanged = function(sender,direction,records)
   		self:ClearDeeds();
		self:LoadDeeds(records);
   	end
   	pagination.VisibleChanged = function(s,a)
   		local ql = self.qlContainer.DeedList;
   		local sb = ql.VScrollBar;
   		local ch = self.qlContainer:GetHeight();
   		if pagination:IsVisible() then
   			ql:SetHeight(ch - 41);
   			sb:SetHeight(ch - 40);
   		else
   			ql:SetHeight(ch - 21);
   			sb:SetHeight(ch - 20);
   		end
   	end

    self.pagination = pagination;

    self.qdContainer=Turbine.UI.Control();
    self.qdContainer:SetParent(self);
    self.qdContainer:SetPosition(self.qlContainer:GetLeft()+self.qlContainer:GetWidth()+5,self.qlContainer:GetTop());
    self.qdContainer:SetSize(self.qlContainer:GetWidth(),self.qlContainer:GetHeight());
    self.qdContainer:SetBackColor(Turbine.UI.Color(0,0,0)); -- this one has to stay fixed for grid to show
    self.qdContainer.DeedDetails = Turbine.UI.ListBox();
    self.qdContainer.DeedDetails:SetParent(self.qdContainer);
    self.qdContainer.DeedDetails:SetPosition(2,1);
    self.qdContainer.DeedDetails:SetSize(self.qdContainer:GetWidth()-4,self.qdContainer:GetHeight()-3);
    self.qdContainer.DeedDetails:SetBackColor(self.backColor);
    self.qdContainer.DeedDetails.VScrollBar=Turbine.UI.Lotro.ScrollBar();
    self.qdContainer.DeedDetails.VScrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
    self.qdContainer.DeedDetails.VScrollBar:SetParent(self.qdContainer.DeedDetails);
    self.qdContainer.DeedDetails.VScrollBar:SetBackColor(self.backColor);
    self.qdContainer.DeedDetails.VScrollBar:SetPosition(self.qdContainer:GetWidth()-16,0)
    self.qdContainer.DeedDetails.VScrollBar:SetWidth(12);
    self.qdContainer.DeedDetails.VScrollBar:SetHeight(self.qdContainer:GetHeight()-2);
    self.qdContainer.DeedDetails:SetVerticalScrollBar(self.qdContainer.DeedDetails.VScrollBar);

    local bottom = self.qdContainer:GetTop() + self.qdContainer:GetHeight() + 2;
	local detailTabs = Compendium.Common.UI.TabControl();
	detailTabs:SetParent(self);
	detailTabs:SetPosition(7,bottom);

    self.deedDesc=Turbine.UI.Label();
    self.deedDesc:SetPosition(0,0);
    self.deedDesc:SetFont(self.fontFace);
    self.deedDesc:SetForeColor(self.fontColor);
    self.deedDesc:SetSelectable(true);
	self.deedDesc:SetMarkupEnabled(true);
    self.deedDesc.VScrollBar=Turbine.UI.Lotro.ScrollBar();
    self.deedDesc.VScrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
    self.deedDesc.VScrollBar:SetParent(self.deedDesc);
    self.deedDesc.VScrollBar:SetBackColor(self.backColor);
    self.deedDesc.VScrollBar:SetPosition(self.deedDesc:GetWidth()-12,0)
    self.deedDesc.VScrollBar:SetWidth(12);
    self.deedDesc.VScrollBar:SetHeight(self.deedDesc:GetHeight()-2);
    self.deedDesc:SetVerticalScrollBar(self.deedDesc.VScrollBar);
    self.deedDesc.SizeChanged = function(s,a)
    	local width = s:GetWidth();
		local height = s:GetHeight();
	    self.deedDesc.VScrollBar:SetPosition(width-12,0);
	    self.deedDesc.VScrollBar:SetHeight(height - 2);
    end

    self.deedObj=Turbine.UI.Label();
    self.deedObj:SetPosition(0,0);
    self.deedObj:SetFont(self.fontFace);
    self.deedObj:SetForeColor(self.fontColor);
    self.deedObj:SetSelectable(true);
	self.deedObj:SetMarkupEnabled(true);
    self.deedObj.VScrollBar=Turbine.UI.Lotro.ScrollBar();
    self.deedObj.VScrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
    self.deedObj.VScrollBar:SetParent(self.deedObj);
    self.deedObj.VScrollBar:SetBackColor(self.backColor);
    self.deedObj.VScrollBar:SetPosition(self.deedObj:GetWidth()-12,0)
    self.deedObj.VScrollBar:SetWidth(12);
    self.deedObj.VScrollBar:SetHeight(self.deedObj:GetHeight()-2);
    self.deedObj:SetVerticalScrollBar(self.deedObj.VScrollBar);
    self.deedObj.SizeChanged = function(s,a)
    	local width = s:GetWidth();
		local height = s:GetHeight();
	    self.deedObj.VScrollBar:SetPosition(width-12,0);
	    self.deedObj.VScrollBar:SetHeight(height - 2);
    end

	self.coord = Compendium.Common.UI.CoordinateControl();
	self.coord:SetParent(self);

    local comments= Compendium.Deeds.DeedCommentsControl();
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
			local isdungeon, target, name = self:PoiPlace(self.currentRecord);
    		self:CoordClicked( y, ns, x, ew, target, isdungeon, rsrc["miscpoi"], self.currentRecord['name']);
    	end
    end
	self.comments = comments;

	detailTabs:AddTab(rsrc["objectives"],  self.deedObj);
	detailTabs:AddTab(rsrc["description"],  self.deedDesc);
	detailTabs:AddTab(rsrc["comments"],  comments);
	detailTabs:SetSize(self:GetWidth()-10, 150);

    self:ClearDeeds();
	self.searchDisabled = false;


 	self.SetWidth = function(sender,width)
        if width<100 then width=100 end;
        Turbine.UI.Control.SetWidth(self,width);

        local qlwidth = (width/2) - 7;
        self.qlContainer:SetWidth(qlwidth);
        self.qdContainer:SetLeft(self.qlContainer:GetLeft() + qlwidth + 5);
        self.qdContainer:SetWidth(qlwidth);
        qlHeader:SetWidth(qlwidth - 16);
        self.qlContainer.DeedList:SetWidth(qlwidth - 4);
        self.qdContainer.DeedDetails:SetWidth(qlwidth - 4);
        self.qlContainer.DeedList.VScrollBar:SetLeft(qlwidth-16);
        self.qdContainer.DeedDetails.VScrollBar:SetLeft(qlwidth-16);
        pagination:SetWidth(qlwidth - 4);

		local swidth = width - (searchLabel:GetWidth()+searchLabel:GetLeft())-55;
    	self.SearchBorder:SetWidth(swidth);
    	self.SearchText:SetWidth(swidth);
	    reset:SetLeft( self.SearchBorder:GetLeft() + self.SearchBorder:GetWidth() + 1 );

		detailTabs:SetWidth(width - 10);
		for index=1,self.qlContainer.DeedList:GetItemCount() do
			local label = self.qlContainer.DeedList:GetItem(index);
			label:GetControls():Get(1):SetWidth(qlwidth - 32);
			label:GetControls():Get(2):SetLeft(qlwidth - 32);
			label:SetWidth(qlwidth - 14);
		end
		for index=1,self.qdContainer.DeedDetails:GetItemCount() do
			local label = self.qdContainer.DeedDetails:GetItem(index);
			label:SetWidth(qlwidth - 14);
		end

    end

 	self.SetHeight = function(sender,height)
        if height<300 then height=300 end;
        local lheight = height - self.qlContainer:GetTop() - detailTabs:GetHeight() - 5;

        Turbine.UI.Control.SetHeight(self,height);
		self.qlContainer:SetHeight(lheight);
		local ql = self.qlContainer.DeedList;
   		local sb = ql.VScrollBar;
   		if pagination:IsVisible() then
   			ql:SetHeight(lheight - 41);
   			sb:SetHeight(lheight - 40);
   		else
   			ql:SetHeight(lheight - 21);
   			sb:SetHeight(lheight - 20);
   		end
		pagination:SetTop(lheight - 22);

		self.qdContainer:SetHeight(lheight);
		self.qdContainer.DeedDetails:SetHeight(lheight - 3);
		self.qdContainer.DeedDetails.VScrollBar:SetHeight(lheight - 2);
		detailTabs:SetTop(self.qdContainer:GetTop() + lheight + 2);
    end

	self.SetSize = function(sender,width, height)
		self:SetWidth(width);
		self:SetHeight(height);
	end

	self:BuildCursor();

end

function CompendiumDeedControl:ClearDeeds()
	for index=1,self.qlContainer.DeedList:GetItemCount() do
		local item = self.qlContainer.DeedList:GetItem(index);
		self:strip(item, 1);
	end
	self.qlContainer.DeedList:ClearItems();
	for index=1,self.qdContainer.DeedDetails:GetItemCount() do
		local item = self.qdContainer.DeedDetails:GetItem(index);
		self:strip(item, 1);
	end
    self.qdContainer.DeedDetails:ClearItems();
    self.deedDesc:SetText("");
    self.deedObj:SetText("");
	self.comments:ClearComments();
    self:AddDeedDetail(rsrc["nodeedselected"]);
    self.prevIdx = nil;
	self.currentRecord = nil;
end

function CompendiumDeedControl:AddDeedDetail(text, hyperlink)
    local label = Turbine.UI.Label();
    label:SetSize(self.qdContainer.DeedDetails:GetWidth() - 10, 13);
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

    self.qdContainer.DeedDetails:AddItem(label);
    return label;
end

function CompendiumDeedControl:JoinIndex(a, b)
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

function CompendiumDeedControl:LoadDeeds(records)

    local bgColor = self.qlContainer.DeedList:GetBackColor();
    local width = self.qlContainer.DeedList:GetWidth();
    local playerLevel = Turbine.Gameplay.LocalPlayer.GetInstance():GetLevel();

    for i,rec in pairs(records) do
        local level = rec["level"];
        local name = rec["name"];
		if level ~= nil then
			name = name .. ' (' .. level .. ')';
		end
        if rec["faction"] == 'Mon' then
        	name = name .. ' (M)';
        end

        local deed = Turbine.UI.Control();
        deed:SetSize(width - 10, 18);

        local label = Turbine.UI.Label();
        label:SetMultiline(false);
        label:SetParent(deed);
        label:SetPosition( 0, 0 );
        label:SetSize(deed:GetWidth() - 18, 18);
        label:SetSelectable(true);
        label:SetText(name);
        label:SetBackColor(bgColor);
        label:SetFont(self.fontFaceSmall);
	    label:SetTextAlignment( Turbine.UI.CheckBox.MiddelCenter );

	    local complete = self.deedprogression[rec["id"]];
	    if complete == nil then complete = false end;

		local checkbox = Turbine.UI.Lotro.CheckBox();
	    checkbox:SetParent( deed );
	    checkbox:SetPosition(label:GetWidth(), 0);
	    checkbox:SetSize( 25, 18 );
	    checkbox:SetChecked(complete);
		checkbox.CheckedChanged = function(s,a)
			self:UpdateLocalRecord(self.currentRecord,'modifyprog',s:IsChecked());
		end

        local color = self.fontColor;
        if level ~= nil then
			local relLevel = playerLevel;
			if level == 'Scaling' then
				if rec['minlevel'] ~= nil then
					relLevel = tonumber(rec['minlevel']);
				else
					relLevel = playerLevel;
				end
			else
				relLevel = tonumber(level);
			end
			color = self:GetLevelColor(playerLevel, relLevel);
        end
        label:SetForeColor(color);

        deed.DeedId = tonumber(rec["ndx"]);
        self.qlContainer.DeedList:AddItem(deed);
    end

end

function CompendiumDeedControl:Reset()
	self.searchDisabled = true;
	self.SearchText:SetText('');
    self:ClearDeeds();
	self.currentIndexFilters = {};
	self.currentManualFilters = {};
	self.filtersLabel:SetText(rsrc["nofiltersset"]);
	self.cursor = nil;
	self.searchDisabled = false;
	self:BuildCursor();
end

function CompendiumDeedControl:FormatItem(record)
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

---@param record Deed
function CompendiumDeedControl:LoadDeedDetails(record)

    local localrecord = self.localdeeddata[record['name']];
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
    	["instance"] = "No"
    },]]

    self.qdContainer.DeedDetails:ClearItems();
	self.comments:ClearComments();
    self.currentRecord = record;

    self:AddDeedDetail(rsrc['name']);
    self:AddDeedDetail("  " .. record['name']);
	if record['level'] ~= nil then
		local levelinfo = rsrc["level"] .. " " .. record['level'];
		if record['minlevel'] ~= nil then levelinfo = levelinfo  .. " / ".. rsrc["minlevel"] .. " " .. record['minlevel'] end;
		self:AddDeedDetail(levelinfo);
	end
    if record['t'] ~= nil then
		local typeval = record['t'];
		if record['class'] ~= nil then typeval = typeval .. " (" .. record['class'] .. ")" end
		self:AddDeedDetail(rsrc["type"] .. " "  .. typeval);
	end
    if record['zone'] ~= nil then self:AddDeedDetail(rsrc["zone"] .. " " .. record['zone']); end
    if record['area'] ~= nil then self:AddDeedDetail(rsrc["area"] .. " " .. record['area']); end
	if record['dungeon'] ~= nil then self:AddDeedDetail(rsrc["dungeon"] .. " " .. record['dungeon']); end
    if record['faction'] ~= nil then self:AddDeedDetail(rsrc["faction"] .. " " .. record['faction']); end

	if record['r'] ~= nil then
		for j, reward in pairs(rewardLabels) do
			local display = rsrc[reward];
			if record['r'][reward] ~= nil then
				local vals = record['r'][reward];
				if #vals > 1 then
					for i,item in pairs(vals) do
						local prefix = "     ";
						if i == 1 then prefix = display .. ": "; end

						local dispval = item['val']
						if reward == 'rc' or reward == 'so' then
							dispval = self:FormatItem(item);
						elseif reward == 'cx' then
							dispval = item['craft'] .. ' ' .. item['val'];
						end

						self:AddDeedDetail(prefix .. dispval)
					end
				else
					local dispval = vals[1]['val']
					if reward == 'rc' or reward == 'so' then
						dispval = self:FormatItem(vals[1]);
					elseif reward == 'cx' then
						dispval = vals[1]['craft'] .. ' ' .. vals[1]['val'];
					end
					self:AddDeedDetail(display .. ": " .. dispval);
				end
			end
		end
	end

    local sep = false;
    if record['prev'] ~= nil then
        if sep == false then self:AddDeedDetail(""); end
        sep = true
        self:AddDeedDetail(rsrc["prereqs"]);
        for i,previd in pairs(record['prev']) do
        	local name = deedtable[previd]['name'];
	        self:AddDeedDetail("  " .. name, true).MouseClick = function(sender, args)
	            self:LoadDeedDetails(deedtable[previd]);
	        end;
        end
    end
    if record['next'] ~= nil then
        if sep == false then self:AddDeedDetail(""); end
        sep = true
        self:AddDeedDetail(rsrc["nextdeeds"]);
        for i,nextid in pairs(record['next']) do
        	local name = deedtable[nextid]['name'];
	        self:AddDeedDetail("  " .. name, true).MouseClick = function(sender, args)
	            self:LoadDeedDetails(deedtable[nextid]);
	        end;
        end
    end

    sep = false
    if record['mobs'] ~= nil and #record['mobs'] > 0 then
        if sep == false then self:AddDeedDetail(""); end
        sep = true
        self:AddDeedDetail(rsrc["mobsnpcsofinterest"]);
        for i,mob in pairs(record['mobs']) do
            local isdungeon, target, name = self:PoiPlace(mob);
            if mob['loc'] ~= nil then
				self:AddDeedDetail("  " .. name);
				for i, loc in pairs(mob['loc']) do
					self:AddDeedDetail('       ' .. loc).MouseClick = function(s,a)
						local start, len, tmp, y, ns, x, ew = string.find(loc, "(([%d%.]+)([NSns])[, ]+([%d%.]+)([EWOewo]))");
						--Turbine.Shell.WriteLine('start: ' .. tostring(start) .. ', len: ' .. tostring(len) .. ', y: ' .. tostring(y) .. ', ns: ' .. tostring(ns) .. ', x: ' .. tostring(x) .. ', ew: '.. tostring(ew));
						if start ~= nil then
							self:CoordClicked( y, ns, x, ew, target, isdungeon, mob['name'], rsrc['deed'] .. ' - ' .. string.gsub(record['name'],':','-') .. ' / '.. rsrc["mob"] .. ' - ' .. mob['name']);
						end
					end
				end
	        else
	        	self:AddDeedDetail(name);
	        end
        end
    end

    if record['pois'] ~= nil and #record['pois'] > 0 then
        if sep == false then self:AddDeedDetail(""); end
        sep = true
        self:AddDeedDetail(rsrc["pointsofinterest"]);
        for i,poi in pairs(record['pois']) do
            local isdungeon, target, name = self:PoiPlace(poi);
            if poi['loc'] ~= nil then
				self:AddDeedDetail("  " .. name);
				for i,loc in pairs(poi['loc']) do
					self:AddDeedDetail('       ' .. loc).MouseClick = function(s,a)
						local start, len, tmp, y, ns, x, ew = string.find(loc, "(([%d%.]+)([NSns])[, ]+([%d%.]+)([EWOewo]))");
						--Turbine.Shell.WriteLine('start: ' .. tostring(start) .. ', len: ' .. tostring(len) .. ', y: ' .. tostring(y) .. ', ns: ' .. tostring(ns) .. ', x: ' .. tostring(x) .. ', ew: '.. tostring(ew));
						if start ~= nil then
							self:CoordClicked( y, ns, x, ew, target, isdungeon, poi['name'], rsrc['deed'] .. ' - ' .. string.gsub(record['name'],':','-') .. ' / ' .. poi['name']);
						end
					end
				end
	        else
	        	self:AddDeedDetail(name);
	        end
        end
    end

    -- description
    self.deedDesc:SetVerticalScrollBar(nil);
    self.deedDesc:SetText(record['d']);
    self.deedDesc:SetVerticalScrollBar(self.deedDesc.VScrollBar);
	-- objective
    self.deedObj:SetVerticalScrollBar(nil);
    self.deedObj:SetText(record['o']);
    self.deedObj:SetVerticalScrollBar(self.deedObj.VScrollBar);

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

function CompendiumDeedControl:PoiPlace(poi)
	local zad = {};
	local target = poi['zone'];
	if poi['zone'] ~= nil then table.insert(zad, poi['zone']); end
	if poi['area'] ~= nil then
		table.insert(zad, poi['area']);
		--target = poi['area'];
	end
	if poi['dungeon'] ~= nil then table.insert(zad, poi['dungeon']); end
	return poi['dungeon'] ~= nil, target, poi['name'] .. ' (' .. table.concat(zad, " > ") .. ')';
end

function CompendiumDeedControl:BuildCursor()

	if self.searchDisabled then
		return;
	end
    self:ClearDeeds();
	self.pagination:SetCursor(nil);
	self.pagination:SetVisible(false);

	-- filter results using our category indexes
	local ids = nil;
	for i,cat in pairs(self.currentIndexFilters) do
		if deedindexes[cat] ~= nil then
			ids = self:JoinIndex(ids,deedindexes[cat]);
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
			self.cursor = Compendium.Common.Utils.DataCursor(deedtable, pagesize);
			self.pagination:SetCursor(self.cursor);
			if self.cursor:PageCount() > 1 then
				self.pagination:SetVisible(true);
			end
			self:LoadDeeds(self.cursor:CurPage());
			return;
		end
    end

	-- build data set
	local data = deedtable;
	if ids ~= nil then
		data = ids
	end;
	local recs = {};
    local count = 0;
	for a, b in pairs(data) do
		local id = a;
		if ids ~= nil then id = b end;

		--Turbine.Shell.WriteLine('a:' .. a .. ' b:' .. b .. ' id:' .. id);
		local rec = deedtable[id];
        local include = true;
        if not ise then
            if string.find(string.lower(rec["name"]),escapedSearch) == nil then
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
					if rec['level'] == 'Scaling' then
						if rec['minlevel'] ~= nil and (rec['minlevel'] < from or rec['minlevel'] > to) then
							include = false;
							break;
						end
					else
						if rec['level'] < from or rec['level'] > to then
							include = false;
							break;
						end
					end
				elseif filter.type == 'progression' then
					local prog = self.deedprogression[rec["id"]];
					if filter.value and (prog == nil or false == prog ) then
						include = false;
						break;
					elseif not filter.value and true == prog then
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
	self:LoadDeeds(self.cursor:CurPage());

end

function CompendiumDeedControl:AddFilters(filters)

	local count = 0;
	local filterText = rsrc["filters"] .. ' ';

	local distinctCats = {};
	for i,cat in pairs(self.currentIndexFilters) do distinctCats[cat] = i end;
	if filters.indexes ~= nil then
		for i,cat in pairs(filters.indexes) do
			if deedindexes[cat] ~= nil then distinctCats[cat] = i end;
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
		elseif rec.type == 'progression' then
			if rec.value then
				filterText = filterText .. rsrc["complete"];
			else
				filterText = filterText .. rsrc["incomplete"];
			end
			table.insert(self.currentManualFilters, rec);
		end
		count = count + 1;
	end

	self.filtersLabel:SetText(filterText);
	self:BuildCursor();
end


function CompendiumDeedControl:UpdateAllFilteredRecord(type, data)
	if self.cursor ~= nil then
		local records = self.cursor.data;
		for i, rec in pairs(records) do
			self:UpdateLocalRecord(rec, type, data);
		end
		self:ClearDeeds();
		self:LoadDeeds(records);
	end
end

function CompendiumDeedControl:UpdateLocalRecord(deedrecord, type, data)

	local id = deedrecord['id'];
	if self.localdeeddata[id] == nil then
		self.localdeeddata[id] = {};
	end

	if type == 'addcomment' then
		if self.localdeeddata[id]['c'] == nil then
			self.localdeeddata[id]['c'] = { data }
		else
			table.insert(self.localdeeddata[id]['c'],data);
		end
		self.comments:AddCommentRecord(data, true);
		self.localdeeddatamodified = true;
	elseif type == 'delcomment' then
		if self.localdeeddata[id]['c'] == nil then
			-- nothing to do
		else
			local comments = {};
			for i,c in pairs(self.localdeeddata[id]['c']) do
				if c['time'] ~= data['time'] then
					table.insert(comments,c);
				end
			end
			self.localdeeddata[id]['c'] = comments;
			self.localdeeddatamodified = true;
		end
	elseif type == 'modifyprog' then
		self.deedprogression[id] = data;
		self.deedprogressionmodified = true;
	else
		-- unknown update type
	end

end

function CompendiumDeedControl:persist()
	if self.localdeeddatamodified or self.deedprogressionmodified then
		Turbine.Shell.WriteLine(rsrc["savingdeeds"]);
	end
	if self.localdeeddatamodified then
		Compendium.Common.Utils.PluginData.Save( Turbine.DataScope.Account, "LocalDeedData", self.localdeeddata );
		self.localdeeddatamodified = false;
	end
	if self.deedprogressionmodified then
		Compendium.Common.Utils.PluginData.Save( Turbine.DataScope.Character, "CompendiumDeedProgression", self.deedprogression );
		self.localdeeddatamodified = false;
	end
	if self.localdeeddatamodified or self.deedprogressionmodified then
		Turbine.Shell.WriteLine(rsrc["savingcomplete"]);
	end

end

function CompendiumDeedControl:ImportLotroCompanion()
	if self.lcData == nil then return end;

	-- check for companion progression data to import
	local completedCount = 0;
	for key, value in pairs(self.lcData) do
		if value == 'COMPLETED' then
			completedCount = completedCount + 1
		end
	end
	if completedCount == 0 then
		self:ClearLCDeedsFile()
	else
		Compendium.Common.UI.Dialog.Confirm:Show(rsrc['importtitle'], string.format(rsrc['importdeed'], completedCount),
		function()
			for key, value in pairs(self.lcData) do
				local id = string.upper(string.format('%x', key))
				if value == 'COMPLETED' then
					self.deedprogression[id] = true
					self.deedprogressionmodified = true
				end
			end
			self:ClearLCDeedsFile()
			self:BuildCursor();
		end,
		function()
			self:ClearLCDeedsFile()
		end);
	end
end

function CompendiumDeedControl:LoadLocalDeeds()
	self:LoadLocalDeedsData(Turbine.DataScope.Account, "LocalDeedData", "localdeeddata", "localdeeddatamodified")
	self:LoadLocalDeedsData(Turbine.DataScope.Character, "CompendiumDeedProgression", "deedprogression", "deedprogressionmodified")

	local lcd = Compendium.Common.Utils.PluginData.Load(Turbine.DataScope.Character, "CompendiumDeedProgression_CompanionImport")
	if type(lcd) == 'table' and lcd["SKIP"] == nil then
		self.lcData = lcd;
	end
end

function CompendiumDeedControl:ClearLCDeedsFile()
	Compendium.Common.Utils.PluginData.Save(Turbine.DataScope.Character, "CompendiumDeedProgression_CompanionImport", {["SKIP"] = true})
	self.lcData = nil;
end

function CompendiumDeedControl:LoadLocalDeedsData( scope, name, property, flag)
	local data = Compendium.Common.Utils.PluginData.Load(scope , name)
	if data ~= nil then
		if data["__version"] == nil then
			-- upgrade progression to version 2
			self[property] = {["__version"] = 2};
			for a, b in pairs(deedtable) do
				if data[b.name] then
					self[property][b.id] = true;
					self[flag] = true;
				end
			end
		else
			if name == "deedprogression" then
				local copy = {};
				for k, v in pairs(data) do
					copy[tostring(k)] = v;
				end
				data = copy;
			end
			self[property] = data;
		end
	else
		self[property] = {["__version"] = 2};
	end
end

function CompendiumDeedControl:AddCoordinate( record )
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

--[[
-- not sure how to do this yet
function CompendiumDeedControl:ProcessDeedChat( message )
	local chatComplete = rsrc["chatcompleted"];
	local name = string.match(message, '^.*' .. chatComplete .. "%s*(.-)'?%s*$")
	if (name) then
        name = string.gsub(name,"\n","");
		self:MarkDeedCompleted(name);
    end
end

function CompendiumDeedControl:MarkDeedCompleted( name )
	for i, rec in ipairs(deedtable) do
		if rec.name == name then
			self.deedprogression[rec.id] = true;
			self.deedprogressionmodified = true;
			self:BuildCursor();
			break;
		end
	end
end
]]

function CompendiumDeedControl:CoordClicked( y, ns, x, ew, target, isdungeon, name, deed )
	local mx, my = self:PointToClient(Turbine.UI.Display:GetMousePosition());
	local left, top = mx - 3, my - 3;
	self.coord:SetPosition(left, top);
	self.coord:ShowMenu( y, ns, x, ew, target, isdungeon, name, deed );
end
