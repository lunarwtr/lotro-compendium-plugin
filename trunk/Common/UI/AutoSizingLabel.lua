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
    
    Turbine.UI.Label.SetSize(self,1,1);
    
    local vert =Turbine.UI.Lotro.ScrollBar();
    vert:SetOrientation(Turbine.UI.Orientation.Vertical);
    vert:SetBackColor(Turbine.UI.Color(0,0,0));
    vert:SetPosition(0,0);
    vert:SetWidth(1,1);
    vert:SetParent(self);
    vert.VisibleChanged = function(s,a)
		self:SetHeight('auto');
	end 
    
    local hor =Turbine.UI.Lotro.ScrollBar();
    hor:SetOrientation(Turbine.UI.Orientation.Horizontal);
    hor:SetBackColor(Turbine.UI.Color(0,0,0));
    hor:SetPosition(0,0);
    hor:SetSize(1,1);
    hor:SetParent(self);
	hor.VisibleChanged = function(s,a)
		self:SetWidth('auto');
	end   

	self.bars = { vert = vert, hor = hor };
	self:SetSize('auto','auto');
	
end
function AutoSizingLabel:SetSize(w,h)
	self:SetWidth(w);
	self:SetHeight(h);
end

function AutoSizingLabel:SetWidth(w)
	if w == 'auto' then
		self:SetHorizontalScrollBar(self.bars.hor);
		local count = 1;
		--Turbine.UI.Label.SetWidth(self,1);
		while self.bars.hor:IsVisible() do
			Turbine.UI.Label.SetWidth(self,self:GetWidth() + 2);
			count = count + 1;
		end			
	else
		self:SetHorizontalScrollBar(nil);
	 	Turbine.UI.Label.SetWidth(self,w);
	end
end

function AutoSizingLabel:SetHeight(h)
	if h == 'auto' then
		self:SetVerticalScrollBar(self.bars.vert);
		local count = 1;
		--Turbine.UI.Label.SetHeight(self,1);
		while self.bars.vert:IsVisible() and count < 100 do
			Turbine.UI.Label.SetHeight(self,self:GetHeight() + 2);
			count = count + 1;
		end
	else
		self:SetVerticalScrollBar(nil);
	 	Turbine.UI.Label.SetHeight(self,h);
	end
end

