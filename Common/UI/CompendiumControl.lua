
import "Turbine";
import "Turbine.Gameplay";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Compendium.Common.Utils";
import "Compendium.Common.Resources";

--[[
	A base window class with reusable constants	and functions defined.
]]
CompendiumControl = class( Turbine.UI.Control );
function CompendiumControl:Constructor()
    Turbine.UI.Control.Constructor( self );

    self:SetBlendMode(Turbine.UI.BlendMode.Overlay);
    self:SetMouseVisible(false);
    self:SetSize(540,445);

    self.itemExampleTpl = "<Examine:IIDDID:0x0000000000000000:0x%s>[%s]<\Examine>";
    self.fontColor=Turbine.UI.Color(1,.9,.5);
    self.backColor=Turbine.UI.Color(.05,.05,.05);
    self.selBackColor=Turbine.UI.Color(.09,.09,.09);
    self.trimColor=Turbine.UI.Color(.75,.75,.75);
    self.colorDarkGrey=Turbine.UI.Color(.1,.1,.1);
    self.fontFace=Turbine.UI.Lotro.Font.Verdana14;

    local font = Compendium.Common.Resources.Settings:GetSetting('FontSize');
    --Turbine.Shell.WriteLine('Font: ' .. font);
    if font == 'large' then
    	self.fontFaceSmall = Turbine.UI.Lotro.Font.Verdana14;
    else
    	self.fontFaceSmall = Turbine.UI.Lotro.Font.Verdana12;
    end

    -- colors for quest levels
    self.purple = Turbine.UI.Color(1,0,1);
    self.red = Turbine.UI.Color(1,0,0);
    self.orange = Turbine.UI.Color(1,0.5,0);
    self.yellow = Turbine.UI.Color(1,1,0);
    self.white = Turbine.UI.Color(1,1,1);
    self.darkBlue = Turbine.UI.Color(0,0,1);
    self.lightBlue = Turbine.UI.Color(0,0.6,0.6);
    self.green = Turbine.UI.Color(0,0.7,0);
    self.gray = Turbine.UI.Color(0.3,0.3,0.3);

end

function CompendiumControl:GetLevelColor(playerLevel, level)
    --[[
    1, 0, 1 : Purple = more than 8 levels above you. You'll probably die if you attempt it.
    1, 0, 0 : Red = 5 -8 levels above you. Very tough fight and expect lots of resists. You'll survive but barely and try not to take on multiples.
    1, 0.5, 0 : Orange = 3-4 levels above you. Manageable but you'll barely crit.
    1, 1, 0 : Yellow = 1-2 levels above you. Not so difficult and you'll crit a bit.
    1, 1, 1 : White = On level.
    0, 0, 1 : Dark Blue = 1-2 levels below you. Still good xp and you'll crit more often against mobs
    0, 0.6, 0.6 :  Light Blue = 3-4 levels below you. Not much xp because it's not a challenge.
    0, 0.7, 0 : Green = 5-8 levels below you. Snoozer, don't bother
    0.3, 0.3, 0.3 : Gray = more than 8 levels below you.
    ]]
    local diff = playerLevel - level;

    if diff < -8 then
        return self.purple;
    elseif diff <= -5 then
        return self.red;
    elseif diff <= -3 then
        return self.orange;
    elseif diff <= -1 then
        return self.yellow;
    elseif diff == 0 then
        return self.white;
    elseif diff > 8 then
        return self.gray;
    elseif diff >= 5 then
        return self.green;
    elseif diff >= 3 then
        return self.lightBlue;
    elseif diff >= 1 then
        return self.darkBlue;
    else
        return self.white;
    end

end

-- to easily debug an array or table
function CompendiumControl:tostring(set)
  if set == nil then return "nil"; end
  local s = "{"
  local sep = ""
  for i,e in pairs(set) do
    s = s .. sep .. e
    sep = ", "
  end
  return s .. "}"
end

function CompendiumControl:destroy()
	self:strip(self);
end

local stripVars = { 'record', 'MouseEnter', 'MouseLeave', 'Click', 'MouseClick', 'MouseHover', 'SizeChanged', 'VisibleChanged', 'Update' };
function CompendiumControl:strip( control, depth )
	if depth == nil then depth = 1 end;
	if depth > 5 then return end;
	--Turbine.Shell.WriteLine('Cleaning item at depth ' .. depth);

	if control.GetControls ~= nil then
		local conts = control:GetControls();
		for i = 1,conts:GetCount() do
			local child = conts:Get(i);
			if child.destroy ~= nil then
				child:destroy();
			else
				self:strip( child, depth + 1 );
			end
		end
		conts:Clear();
	end

	if control.GetItemCount ~= nil and control.Getitem ~= nil then
		for index=1,control:GetItemCount() do
			local item = control:GetItem(index);
			if item.destroy ~= nil then
				item:destroy();
			else
				self:strip( item, depth + 1);
			end
		end
	end

	for i,var in pairs(stripVars) do
		if control[var] ~= nil then
			control[var] = nil
		end;
	end
end

function CompendiumControl:persist()

	if self.GetControls ~= nil then
		local conts = self:GetControls();
		for i = 1,conts:GetCount() do
			local child = conts:Get(i);
			if child.persist ~= nil then
				child:persist();
			end
		end
	end

end


