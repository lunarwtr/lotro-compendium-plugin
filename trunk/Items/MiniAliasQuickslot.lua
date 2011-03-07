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

MiniAliasQuickslot = class( Turbine.UI.Control );

function MiniAliasQuickslot:Constructor()
    Turbine.UI.Control.Constructor( self );
	
	local nothighlight = Turbine.UI.Color(0.18,0.19,0.29);
	local highlight = Turbine.UI.Color(1,.9,.5);
	
	self:SetSize(15,15);
	self:SetBackColor(nothighlight);
	
	local quick = Turbine.UI.Lotro.Quickslot();
	quick:SetParent(self);
    quick:SetSize( 10, 10 );
    quick:SetPosition(1,1);
  	self.quick = quick;
  	
	quick.MouseEnter = function(sender, args) 
		self:SetBackColor(highlight);
	end
	quick.MouseLeave = function(sender, args) 
		self:SetBackColor(nothighlight);
	end	
  	
	self.quick.MouseClick = function(s,a)
		if self.QuickslotClick  ~= nil then
			self.QuickslotClick(self.quick, a);
		end
	end
  	
end

function MiniAliasQuickslot:SetShortcut( s )
	self.quick:SetShortcut(s);
	self.quick:SetVisible(true);
end

