

import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Compendium.Common.Utils";

DropDownList = class( Turbine.UI.Control );

function DropDownList:Constructor()
	Turbine.UI.Control.Constructor( self );
-- we use a Label as the default container for this control so that we can get a border
-- there will be a single label field in the first row with a dropdown button
-- the second and further rows will normally be hidden, only being displayed when the first row is clicked or the button or F4 is pressed
	self.CurrentValue=Turbine.UI.Label();
	self.CurrentValue:SetParent(self);
	self.CurrentValue:SetPosition(1,1);
	self.CurrentValue:SetHeight(18);
	self.CurrentValue:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	self.CurrentValue:SetFont(Turbine.UI.Lotro.Font.Verdana14);
	self.CurrentValue.DataValue=nil;
	self.DropButtonBack=Turbine.UI.Label();
	self.RowHeight=18; -- the default row height

	self.DropButtonBack:SetParent(self);
	self.DropButtonBack:SetPosition(0,1);
	self.DropButtonBack:SetSize(15,18);
	self.DropButtonBack:SetBackColor(Turbine.UI.Color(.1,.1,.1));

	self.DropButton=Turbine.UI.Button();
	self.DropButton:SetParent(self.DropButtonBack);
	self.DropButton:SetPosition(0,0);
	self.DropButton:SetSize(15,18);
	self.DropButton:SetBlendMode(Turbine.UI.BlendMode.Overlay);
	self.DropButton:SetBackground(0x41007e1b);
	self.ListData=Turbine.UI.ListBox();
	self.ListData:SetParent(self);
	self.ListData:SetPosition(1,21);
	self.ListData:SetHeight(0);
	-- test for the "bad base index" bug
	self.ListData:SetSelectedIndex(1);
	self.ListData.SelectedIndexChanged=function()
                if self.ListData:GetSelectedIndex()>0 then
                    self.CurrentValue:SetText(self.ListData:GetItem(self.ListData:GetSelectedIndex()):GetText());
                    self.DataValue=self.ListData:GetItem(self.ListData:GetSelectedIndex()):GetValue();
                    if (self.DropDownUpdate ~= nil) then
                        self.DropDownUpdate(self.DataValue);
                    end                        
		end
	end

	Turbine.UI.Label.SetBackColor(self,Turbine.UI.Color(.5,.5,.1));
	self.ListData.VScrollBar=Turbine.UI.Lotro.ScrollBar();
	self.ListData.VScrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
	self.ListData.VScrollBar:SetParent(self.ListData);
	self.ListData.VScrollBar:SetBackColor(Turbine.UI.Color(.1,.1,.1));
	self.ListData.VScrollBar:SetWidth(10);
	self.ListData.VScrollBar:SetHeight(0);
	self.DropRows=5;

--[[
	self.ListData.FocusLost = function(sender,args)
		self:GetParent():HideList();
	end
]]
	self.CurrentValue.MouseClick = function(sender,args)
		if (self.ListData:GetHeight()>0) then
			self:HideList();
		else
			self:ShowList();
		end
	end

	self.DropButton.Click = function (sender,args)
		if (self.ListData:GetHeight()>0) then
			self:HideList();
		else
			self:ShowList();
		end
	end

	self.SelectedIndexChanged = function() -- placeholder for the event handler
	end
end

function DropDownList:SetEnabled(state)
	self.CurrentValue:SetMouseVisible(state);
	self.DropButton:SetMouseVisible(state);
end

function DropDownList:SetDropRows(rows)
	self.DropRows=rows;
	if (self.ListData:GetHeight()>0) then
		-- redisplay the rows
		self:ShowList();
	end
end

function DropDownList:SetBorderColor( color )
	Turbine.UI.Label.SetBackColor(self,color);
end

function DropDownList:SetSize(width,height)
	Turbine.UI.Label.SetSize(self,width,height);
	self.CurrentValue:SetWidth(width-18);
	self.DropButtonBack:SetLeft(width-16);
	self.ListData:SetWidth(width-2);
	if (self.ListData:GetItemCount()>0) then
		for lIndex = 1, self.ListData:GetItemCount() do
			self.ListData:GetItem(lIndex):SetWidth(width-17);
		end
	end
	self.ListData.VScrollBar:SetPosition(width-11,1);
end

function DropDownList:SetWidth(width)
	Turbine.UI.Label.SetWidth(self,width);
	self.CurrentValue:SetWidth(width-18);
	self.DropButton:SetLeft(width-16);
	self.ListData:SetWidth(width-2);
	if (self.ListData:GetItemCount()>0) then
		for lIndex = 1, self.ListData:GetItemCount() do
			self.ListData:GetItem(lIndex):SetWidth(width-17);
		end
	end
	self.ListData.VScrollBar:SetPosition(width-11,1);
end

function DropDownList:AddItem(text, datavalue)
	local listItem = Turbine.UI.Label();
	listItem:SetMultiline(false);
	listItem:SetSize(self.ListData:GetWidth()-11,self.RowHeight);
	listItem:SetOpacity(self:GetOpacity());
	listItem:SetBackColor(self.ListData:GetBackColor());
	listItem:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	listItem:SetFont(Turbine.UI.Lotro.Font.Verdana14);
	listItem:SetText(text);
	listItem.DataValue=datavalue;
	listItem.isVisible=true;
	listItem.Index=self.ListData:GetItemCount()+1;
	listItem.MouseClick = function (sender, args)
		self.CurrentValue:SetText(listItem:GetText());
		self.CurrentValue.DataValue=listItem.DataValue;
		self:HideList();
		self.ListData:SetSelectedIndex(listItem.Index); 
		self:SelectedIndexChanged();
	end
	listItem.GetValue = function (sender)
		return listItem.DataValue;
	end
	self.ListData:AddItem (listItem);
	if (self.ListData:GetItemCount()==1) then
		-- autoselect the newly added item
		self.CurrentValue:SetText(text);
		self.ListData:SetSelectedIndex(listItem.Index);
	end
end


function DropDownList:GetValue()
	local dataValue=nil;
	if self.ListData:GetItemCount()>0 then
		local sel = self.ListData:GetSelectedIndex();
		--Turbine.Shell.WriteLine(sel);
		dataValue=self.ListData:GetItem(sel).DataValue;
	end
	return (dataValue);
end

function DropDownList:GetText()
	return (self.CurrentValue:GetText());
end

function DropDownList:SetCurrentBackColor( color )
	self.CurrentValue:SetBackColor( color );
end

function DropDownList:SetBackColor( color )
	local index;
	self.ListData:SetBackColor(color);
	if (self.ListData:GetItemCount()>0) then
		for index = 1,self.ListData:GetItemCount() do
			self.ListData:GetItem(index):SetBackColor( color );
		end
	end
	self.ListData.VScrollBar:SetBackColor(color);
end

function DropDownList:SetSelectedIndex(index)
	if index>0 and index<=self.ListData:GetItemCount() then
		self.ListData:SetSelectedIndex(index);
	end
end

function DropDownList:ShowList()
local visibleRows=0;
local index;
	for index=1,self.ListData:GetItemCount() do
		if self.ListData:GetItem(index).isVisible then
			visibleRows=visibleRows+1;
		end
	end
	if (visibleRows>self.DropRows) then
		self.ListData:SetHeight(self.RowHeight*self.DropRows);
		self.ListData.VScrollBar:SetHeight(self.ListData:GetHeight());
		self.ListData:SetVerticalScrollBar(self.ListData.VScrollBar);
		-- we use this bizarre combination of unbinding and rebinding the scrollbar to eliminate the odd
		-- resizing of the built in thumb button after the scrollbar is displayed the first time (comment out the next two lines to see the weird resizing)
		self.ListData:SetVerticalScrollBar();
		self.ListData:SetVerticalScrollBar(self.ListData.VScrollBar);
	else
		self.ListData:SetHeight(self.RowHeight*visibleRows);
		self.ListData:SetVerticalScrollBar();
	end
	self:SetHeight(self.ListData:GetHeight()+22);
	self.ListData:SetWantsKeyEvents(true);
	self.ListData:SetWantsUpdates(true);
end

function DropDownList:HideList()
	self.ListData:SetHeight(0);
	self.ListData.VScrollBar:SetHeight(0);
	self:SetHeight(20);
	self.ListData:SetWantsKeyEvents(false);
	self.ListData:SetWantsUpdates(false);
	self.ListData:SetVerticalScrollBar();
end

function DropDownList:SelectIndexByValue(value)
	for index=1,self.ListData:GetItemCount() do
		if self.ListData:GetItem(index).DataValue == value then
			self:SetSelectedIndex(index);
			return;
		end
	end
end