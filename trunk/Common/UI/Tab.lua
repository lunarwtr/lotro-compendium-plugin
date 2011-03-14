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

local image = function(loc, status)
	return string.format("Compendium/Common/Resources/images/tab-%s%s.tga", loc, status);
end

Tab = class( Turbine.UI.Control );
function Tab:Constructor( text )
    Turbine.UI.Control.Constructor( self );
    
    local fontColor=Turbine.UI.Color(1,.9,.5);
    local fontFace=Turbine.UI.Lotro.Font.TrajanPro14;
    
	self:SetSize(50,20);
	
	local tableft = Turbine.UI.Control();
	tableft:SetSize(10,23);
	tableft:SetParent(self);
	tableft:SetBackground(image('l','i'));
    tableft:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	tableft:SetPosition(0,0);
	
	local tabright = Turbine.UI.Control();
	tabright:SetSize(10,23);
	tabright:SetParent(self);
	tabright:SetBackground(image('r','i'));
    tabright:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	tabright:SetPosition(10,0);	
	
	local label = Compendium.Common.UI.AutoSizingLabel();
	label:SetPosition(10,0);
	label:SetBackground(image('c','i'));
    label:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);	
    label:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );	
	label:SetMultiline(false);
    label:SetFont(fontFace);
    label:SetForeColor(fontColor);
    label:SetOutlineColor(Turbine.UI.Color(0,0,0));
    label:SetFontStyle(Turbine.UI.FontStyle.Outline);
	label:SetParent(self);
	label:SetText(text);
	label:SetSize('auto',23);
	--label:SetWidth('auto');
	label.SizeChanged = function(sender, args)
		local width = sender:GetWidth();
		self:SetWidth(10 + width + 10);
		tabright:SetPosition(10 + width,0);
	end
    self.pieces = { tableft, label, tabright };
    
    -- propagate events
	for i, item in pairs(self.pieces) do
		item.MouseClick = function(s,a) 
			if self.MouseClick ~= nil then self:MouseClick(self,a) end 
		end;
		item.MouseEnter = function(s,a) 
			if self.MouseEnter ~= nil then self:MouseEnter(self,a) end
		end;
		item.MouseLeave = function(s,a) 
			if self.MouseLeave ~= nil then self:MouseLeave(self,a) end
		end;
	end
   
    self.active = false; 
    self:SetHeight(23);
    
end

function Tab:IsActive()
	return self.active;
end

function Tab:SetActive( active )
	
	self.active = active;
	
	local status = 'i';
	if active then
		status = 'a';
	end

	self.pieces[1]:SetBackground(image('l',status));
	self.pieces[2]:SetBackground(image('c',status));
	self.pieces[3]:SetBackground(image('r',status));
	
end

function Tab:destroy() 
	for i, item in pairs(self.pieces) do
		item.MouseClick = nil;
		item.MouseEnter = nil;
		item.MouseLeave = nil;
	end
	self:GetControls():Clear();	
end