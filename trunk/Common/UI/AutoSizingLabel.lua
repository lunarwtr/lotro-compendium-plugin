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

AutoSizingLabel = class( Turbine.UI.Label );
function AutoSizingLabel:Constructor()
    Turbine.UI.Label.Constructor( self );

    local vert =Turbine.UI.Lotro.ScrollBar();
    vert:SetOrientation(Turbine.UI.Orientation.Vertical);
    vert:SetBackColor(Turbine.UI.Color(0,0,0));
    vert:SetPosition(0,0);
    vert:SetSize(1,1);
    vert:SetParent(self);
    vert.VisibleChanged = function(s,a)
		if s:IsVisible() then self:SetHeight('auto') end
	end 
    
    local hor =Turbine.UI.Lotro.ScrollBar();
    hor:SetOrientation(Turbine.UI.Orientation.Horizontal);
    hor:SetBackColor(Turbine.UI.Color(0,0,0));
    hor:SetPosition(0,0);
    hor:SetSize(1,1);
    hor:SetParent(self);
	hor.VisibleChanged = function(s,a)
		if s:IsVisible() then self:SetWidth('auto') end
	end   
	
	self.bars = { vert = vert, hor = hor };
	self:SetSize(2,2);
	self:SetWantsUpdates(false);
	self.Update = function()
		if self.bars ~= nil and not self.issizing then 
			self:SetSize(self.width, self.height);
		end
	end
	--self:SetSize('auto','auto');
	self.issizing = false;
	
end

function AutoSizingLabel:SetText( text )
	Turbine.UI.Label.SetText(self, text);
	self:SetSize(self.width, self.height);
end

function AutoSizingLabel:SetSize(w,h)
	Turbine.UI.Label.SetSize(self,2,2);
	self:SetWantsUpdates(false);
	self.issizing = true;
	self:SetWidth(w);
	self:SetHeight(h);
	self.issizing = false;
end

function AutoSizingLabel:SetWidth(w)
	self:SetWantsUpdates(false);
	self:SetHorizontalScrollBar(nil);
	self.width = w;
	if w == 'auto' then
		if self.bars == nil then
			for a,b in getmetatable(pairs(self)) do
				Turbine.Shell.WriteLine(a);
			end
		end 
	
		self:SetHorizontalScrollBar(self.bars.hor);
		if  self.bars.hor:IsVisible() then
			local count = 1; 
			while self.bars.hor:IsVisible() do
				Turbine.UI.Label.SetWidth(self,self:GetWidth() + 2);
				count = count + 1;
			end
		else
			self:SetWantsUpdates(true);
		end			
	else
	 	Turbine.UI.Label.SetWidth(self,w);
	end
end

function AutoSizingLabel:SetHeight(h)
	self:SetWantsUpdates(false);
	self:SetVerticalScrollBar(nil);
	self.height = h;
	if h == 'auto' then
	
		if self.bars == nil then
			for a,b in pairs(self) do
				Turbine.Shell.WriteLine(a);
			end
		end 
		
		self:SetVerticalScrollBar(self.bars.vert);
		if self.bars.vert:IsVisible() then 
			local count = 1;
			--Turbine.UI.Label.SetHeight(self,1);
			while self.bars.vert:IsVisible() and count < 100 do
				Turbine.UI.Label.SetHeight(self,self:GetHeight() + 2);
				count = count + 1;
			end
		else
			self:SetWantsUpdates(true);
		end
	else
	 	Turbine.UI.Label.SetHeight(self,h);
	end
end

function AutoSizingLabel:destroy()
	self.bars.vert.VisibleChanged = nil;
	self.bars.hor.VisibleChanged = nil;
	self.bars = nil;
	self:GetControls():Clear();
end