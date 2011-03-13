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

LabelMenu = class( Turbine.UI.Control );
function LabelMenu:Constructor()
    Turbine.UI.Control.Constructor( self );
    
    self.rowHighlight = true;
    
    -- light blue border
    self:SetSize(100, 100);
    self:SetBackColor(Turbine.UI.Color(0.18,0.19,0.29)); 
    self:SetVisible(false);
    self:SetOpacity( 1 );
    self:SetZOrder(1001);
    self:SetBlendMode(Turbine.UI.BlendMode.Color);
    
	local container = Turbine.UI.Control();
    container:SetParent(self);
    container:SetPosition(1,1);
    container:SetSize(self:GetWidth()-2,self:GetHeight()-2);
    container:SetBackColor(Turbine.UI.Color(.05,.05,.05));
    container.MouseMove = function() self.hideTime = nil end;
    self.container = container;
    
	local mylist = Turbine.UI.ListBox();
	mylist:SetParent(container);
	mylist:SetSize(container:GetWidth()-7,container:GetHeight()-4);
	mylist:SetPosition(6,2);
	mylist.Update = function(sender,args)
		if self.hideTime ~= nil and Turbine.Engine.GetGameTime() >= self.hideTime then
			self:HideMenu();
		end
	end
	
	self.MouseLeave = function() 
		self.hideTime = Turbine.Engine.GetGameTime() + 1; 
	end;
	mylist.MouseMove = function() 
		self.hideTime = nil;
 	end;
		
	self.list = mylist;
	local outlinecolor = Turbine.UI.Color(1,.9,.5);
	self.ItemEnter = function(sender,a) 
		if self.rowHighlight == true then
			sender.oldOutlineColor = sender:GetOutlineColor();
			sender.oldStyle = sender:GetFontStyle();
			sender:SetOutlineColor(outlinecolor);
		    sender:SetFontStyle(Turbine.UI.FontStyle.Outline);
		end
	    self.hideTime = nil;
	end
	self.ItemLeave = function(sender,a) 
		if self.rowHighlight == true then
			sender:SetOutlineColor(sender.oldOutlineColor);
		    sender:SetFontStyle(sender.oldStyle);
		end
	end
	
end

function LabelMenu:AddItem( item )
	self.list:AddItem(item);
	item:SetParent(self.list);
	item:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	item.MouseEnter = self.ItemEnter;
	item.MouseLeave = self.ItemLeave;
	self:RecalcSize();
end

function LabelMenu:RecalcSize()
	local height = 0;
	local maxwidth = 100;
	for index=1,self.list:GetItemCount() do
		local item = self.list:GetItem(index);
		height = height + item:GetHeight();
		--Turbine.Shell.WriteLine(maxwidth .. '<=>' .. item:GetWidth());
		maxwidth = math.max(item:GetWidth(),maxwidth);
	end
	for index=1,self.list:GetItemCount() do
		local item = self.list:GetItem(index);
		item:SetWidth(maxwidth);
	end
	
	self:SetSize(maxwidth + 9, height + 6);
	self.container:SetSize(maxwidth + 7,height + 4);
	self.list:SetSize(maxwidth,height);

end

function LabelMenu:ClearMenu()
	for index=1,self.list:GetItemCount() do
		local item = self.list:GetItem(index);
		item.MouseEnter = nil;
		item.MouseLeave = nil;
	end
	self.list:ClearItems();
	self:RecalcSize();
end

function LabelMenu:ShowMenu()
	self.hideTime = nil;
	self:SetVisible(true);
	self.list:SetWantsUpdates(true);
end

function LabelMenu:HideMenu()
	self.hideTime = nil;
	self:SetVisible(false);
	self.list:SetWantsUpdates(false);
end

function LabelMenu:SetRowHighlight(val)
	self.rowHighlight = val;
end

function LabelMenu:destroy()
	self:ClearMenu();
	self.list:SetWantsUpdates(false);	
	self.list.Update = nil;
end