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

import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Compendium.Common.Utils";
import "Compendium.Common.UI";

TabControl = class( Compendium.Common.UI.CompendiumControl );
function TabControl:Constructor()
    Compendium.Common.UI.CompendiumControl.Constructor( self );
    
    self.tabs = {};
    self.activeTab = nil;
	self.tabCount = 1;
	
	self.events = {
		MouseClick = function( sender, args )
	    	self:SetActiveTabById(sender.id);
			self:OnActiveTabChange(self:GetActiveIndex());
	    end,
		MouseEnter = function( sender, args )
		   	sender:SetActive(true);
		end,
		MouseLeave = function( sender, args )
			if sender.id ~= self.activeTab then
				sender:SetActive(false);
			end
		end,
		SizeChanged = function(sender, args)
			self:RefreshUI();
		end
	};

    local tabBorder = Turbine.UI.Control();
    tabBorder:SetParent(self);
    tabBorder:SetPosition(0,22);
    tabBorder:SetSize(self:GetWidth(),self:GetHeight() - 23); -- 43
    tabBorder:SetBackColor(Turbine.UI.Color(0.18,0.19,0.29)); 
    tabBorder:SetZOrder(99);
	local tabContainer = Turbine.UI.Control();
    tabContainer:SetParent(tabBorder);
    tabContainer:SetPosition(1,1);
    tabContainer:SetSize(tabBorder:GetWidth()-2,tabBorder:GetHeight()-2);
    tabContainer:SetBackColor(Turbine.UI.Color(0.9,0,0,0));
	self.tabContainer = tabContainer;
 
 	self.SetHeight = function(sender,height)
        if height<100 then height=100 end;
        Turbine.UI.Control.SetHeight(self,height);
        tabBorder:SetHeight(height-23);
        local contHeight = tabBorder:GetHeight()-2;
        tabContainer:SetHeight(contHeight);
       	for index, rec in pairs(self.tabs) do
			rec.control:SetHeight(contHeight-3);
		end
    end
 	self.SetWidth = function(sender,width)
        if width<100 then width=100 end;
        Turbine.UI.Control.SetWidth(self,width);
        tabBorder:SetWidth(width);
        local contWidth = tabBorder:GetWidth()-2;
        tabContainer:SetWidth(contWidth);
       	for index, rec in pairs(self.tabs) do
			rec.control:SetWidth(contWidth-4);
		end
    end
    self.SetSize = function(s,w,h)
    	s:SetWidth(w);
    	s:SetHeight(h);
    end
end

function TabControl:OnActiveTabChange(index)
	-- for folks to override
end

function TabControl:GetTabById(id)
	for index, rec in pairs(self.tabs) do
		if index == id then 
			return rec;
		end;
	end
end

function TabControl:AddTab(title, control)
	-- build label
    local tab = Compendium.Common.UI.Tab(title);
	tab:SetVisible(false);
    tab:SetParent( self );
	tab:SetHeight(23);
    tab:SetZOrder(101);
    --tab:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	
	-- apply events to tab
	for name, func in pairs(self.events) do
		tab[name] = func;
	end
	
    control:SetVisible(false);
    control:SetParent(self.tabContainer);
	control:SetSize(self.tabContainer:GetWidth()-4,self.tabContainer:GetHeight()-3);
    control:SetPosition(1,1);
    
	local id = self.tabCount;
	tab.id = id;
	self.tabCount = self.tabCount + 1; 

	table.insert(self.tabs, { id = id, tab = tab , control = control });
	
	if self.activeTab == nil then
		self.activeTab = id;
	end	
	
	self:RefreshUI();
	
	return id;
end

function TabControl:RefreshUI()
	local left = 30;
	for index, rec in pairs(self.tabs) do
		local tab = rec.tab;
		tab:SetPosition(left,0);
		tab:SetVisible(true);
		if index == self.activeTab then 
			tab:SetActive(true);
			rec.control:SetVisible(true);
		else
			tab:SetActive(false);
			rec.control:SetVisible(false);
		end
		left = left + tab:GetWidth() + 4;
	end
end

function TabControl:SetActiveIndex(index)
	if (index > #self.tabs) then
		index = #self.tabs;
	end
	local id = self.tabs[index].id;
	self:SetActiveTabById(id);
end

function TabControl:SetActiveTabById(id)
	if self.activeTab ~= id then
		self.activeTab = id;
		self:RefreshUI();
	end
end

function TabControl:GetActiveIndex()
	for index, rec in pairs(self.tabs) do
		if index == self.activeTab then return index end;
	end
	return -1;
end

function TabControl:GetActiveControl()
	for index, rec in pairs(self.tabs) do
		if index == self.activeTab then return rec.control end;
	end
	return nil;
end

function TabControl:destroy()
	for index, rec in pairs(self.tabs) do
		if rec.tab.destroy ~= nil then
			rec.tab:destroy();
		else
			self:strip(rec.tab);
		end;
		if rec.control.destroy ~= nil then
			rec.control:destroy();
		else
			self:strip(rec.control);
		end;
		rec.tab = nil;
		rec.control = nil;
	end
	self.tabs = nil;
	self.events = nil;
	Compendium.Common.UI.CompendiumControl.destroy(self);
end

function CompendiumControl:persist()
	if self.tabs ~= nil then
		for index, rec in pairs(self.tabs) do
			if rec.control.persist ~= nil then
				rec.control:persist();
			end;
		end	
	end
end
