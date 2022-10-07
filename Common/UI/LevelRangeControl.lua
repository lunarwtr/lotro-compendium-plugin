

import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Compendium.Common.Utils";
import "Compendium.Common.UI";
import "Compendium.Common.Resources.Bundle";
local rsrc = {};

LevelRangeControl = class( Compendium.Common.UI.LabelMenu );
function LevelRangeControl:Constructor( )
    Compendium.Common.UI.LabelMenu.Constructor( self );
	rsrc = Compendium.Common.Resources.Bundle:GetResources();

	self:SetSize(175,25);
	self:SetRowHighlight(false);

    local fontColor = Turbine.UI.Color(1,.9,.5);
    local backColor = Turbine.UI.Color(.05,.05,.05);
   	local gray = Turbine.UI.Color(0.3,0.3,0.3);
   	local fontFace = Turbine.UI.Lotro.Font.Verdana14;

	local range = Turbine.UI.Label();
	range:SetSize(150,20);
	range:SetText(rsrc['from']..'       '..rsrc['to']);
    range:SetFont(fontFace);
    range:SetForeColor(fontColor);
    self.range = range;

	local from = Turbine.UI.TextBox();
	from:SetParent(range);
	from:SetSize(30,16);
	from:SetPosition(35,2);
    from:SetBackColor(gray);
    from:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    from:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
    from:SetForeColor(fontColor);
    from:SetOutlineColor(Turbine.UI.Color(0,0,0));
	self.from = from;

	local to = Turbine.UI.TextBox();
	to:SetParent(range);
	to:SetSize(30,16);
	to:SetPosition(90,2);
    to:SetBackColor(gray);
    to:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    to:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
    to:SetForeColor(fontColor);
    to:SetOutlineColor(Turbine.UI.Color(0,0,0));
    self.to = to;

    --local player = Turbine.Gameplay.LocalPlayer:GetInstance();
    --local level = player:GetLevel();
    self.from:SetText(1);
    self.to:SetText(140);

    local apply = Turbine.UI.Control();
    apply:SetParent( range );
	apply:SetBackground( "Compendium/Common/Resources/images/apply.tga" );
    apply:SetSize( 13, 13 );
    apply:SetPosition(to:GetLeft() + to:GetWidth() + 10, 4);
    apply.MouseClick = function( sender, args )
    	self:HideMenu();
    	self:RangeApplied(from:GetText(), to:GetText());
    end
	self.apply = apply;
   	self:AddItem(range);

end

function LevelRangeControl:ShowMenu()
	Compendium.Common.UI.LabelMenu.ShowMenu(self);
end

-- override this event
function LevelRangeControl:RangeApplied( from, to )

end
