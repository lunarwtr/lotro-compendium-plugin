
import "Turbine";
import "Turbine.Gameplay";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Compendium.Common.Utils";

--[[
	A base window class with reusable constants	and functions defined.
]]
CompendiumWindow = class( Turbine.UI.Lotro.Window );
function CompendiumWindow:Constructor()
    Turbine.UI.Lotro.Window.Constructor( self );

    self.fontColor=Turbine.UI.Color(1,.9,.5);
    self.backColor=Turbine.UI.Color(.05,.05,.05);
    self.selBackColor=Turbine.UI.Color(.09,.09,.09);
    self.trimColor=Turbine.UI.Color(.75,.75,.75);
    self.colorDarkGrey=Turbine.UI.Color(.1,.1,.1);
    self.fontFace=Turbine.UI.Lotro.Font.Verdana14;
    self.fontFaceSmall=Turbine.UI.Lotro.Font.Verdana12;

    self.white = Turbine.UI.Color(1,1,1);

    self:SetSize(560,480);
    local initHeight=480;
    local initWidth=560;
    local initLeft=(Turbine.UI.Display:GetWidth() - initWidth) / 2;
    local initTop=(Turbine.UI.Display:GetHeight() - initHeight) / 2;
    self:SetPosition( initLeft, initTop );
    self:SetHeight(initHeight);
    self:SetWidth(initWidth);
    self:SetOpacity( 1 );
    self:SetVisible(false);

end

-- to easily debug an array or table
function CompendiumWindow:tostring(set)
  if set == nil then return "nil"; end
  local s = "{"
  local sep = ""
  for i,e in pairs(set) do
    s = s .. sep .. e
    sep = ", "
  end
  return s .. "}"
end