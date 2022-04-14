

import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Compendium.Common.Utils";

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
    quick:SetAllowDrop(false);
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
	self.quick.DragDrop=function()
		self.quick:SetShortcut(s);
	end    
	self.quick:SetVisible(true);
end

