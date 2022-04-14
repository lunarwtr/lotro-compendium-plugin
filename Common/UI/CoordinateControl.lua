

import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Compendium.Common.Utils";
import "Compendium.Common.UI";
import "Compendium.Common.Resources";

local moormapZones = {
	["gundabad"] = 515,
	["rohaneastemnet"] = 228,
	["rohanwestemnet"] = 287,
	["rohanwildermore"] = 277
}


CoordinateControl = class( Compendium.Common.UI.LabelMenu );
function CoordinateControl:Constructor()
    Compendium.Common.UI.LabelMenu.Constructor( self );

	self:SetRowHighlight(false);

	local foundMoor=false;
	local foundWay=false;
	local loaded = Turbine.PluginManager:GetLoadedPlugins();
	for i, p in pairs(loaded) do
		if p.Name=="MoorMap" then
			foundMoor=true;
		elseif p.Name=="Waypoint" then
			foundWay=true;
		end
	end

	self.showCompass = false;
	self.moormap = false;
	if not foundMoor or not foundWay then
		local avail = Turbine.PluginManager:GetAvailablePlugins();
		local moorCfg = nil;
		local wayCfg = nil;
		for i, p in pairs(avail) do
			if not foundMoor and p.Name == 'MoorMap' then
				moorCfg = p;
			elseif not foundWay and p.Name == 'Waypoint' then
				wayCfg = p;
			end
		end
		if moorCfg ~= nil then
			Turbine.PluginManager.LoadPlugin("MoorMap");
			foundMoor = true;
			self.moormap = true;

			-- Loading MoorMap IDS
			assert(pcall(function()
				import 'GaranStuff.MoorMap.Defaults';
				import 'GaranStuff.MoorMap.Strings';
				import 'GaranStuff.MoorMap.Table';
				local MM = GaranStuff.MoorMap;
				MM.PatchDataSave = function() end
				local mapData = {}
				MM.LoadDefaults({}, mapData);
				for i, rec in pairs(mapData) do
					moormapZones[self:CleanZone(MM.Resource[1][rec[2]])] = rec[1];
				end
			end))
		end
		if wayCfg ~= nil then
			Turbine.PluginManager.LoadPlugin("Waypoint");
			foundWay = true;
			self.showCompass = true;
		end
	end
	if foundMoor then self.moormap = true end;
	if foundWay then self.showCompass = true end;

	local left, width = 1, 40;
	if not self.showCompass then
		width = width - 16;
	end
	if not self.moormap then
		width = width - 16
	end

	local coord = Turbine.UI.Label();
    coord:SetVisible(true);
    coord:SetSize( width, 18 );

	if self.showCompass then
		local compassQS = Turbine.UI.Lotro.Quickslot();
		compassQS:SetParent(coord);
	    compassQS:SetSize( 16, 16 );
	    compassQS:SetPosition(left,1);
	    compassQS:SetEnabled(true);
	    compassQS:SetVisible(true);
	    compassQS:SetAllowDrop(false);
		compassQS.MouseClick = function()
			self:HideMenu();
		end
		local compass = Turbine.UI.Control();
		compass:SetBackground( "Compendium/Common/Resources/images/compass.tga" );
		compass:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
		compass:SetParent(coord);
	    compass:SetSize( 16, 16 );
	    compass:SetPosition(left,1);
	    compass:SetZOrder(compassQS:GetZOrder() + 1);
	    compass:SetMouseVisible(false);
	    self.compassQS = compassQS;
	    left = left + 16;
	end

    if self.moormap then
		local mapQS = Turbine.UI.Lotro.Quickslot();
		mapQS:SetParent(coord);
	    mapQS:SetSize( 16, 16 );
	    mapQS:SetPosition(left,1);
	    mapQS:SetEnabled(true);
	    --mapQS:SetShortcut( Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Alias, '/comp addcoord [;loc|;target]' ) );
	    mapQS:SetVisible(true);
	    mapQS:SetAllowDrop(false);
		mapQS.MouseClick = function(s,a)
			self:HideMenu();
		end
		local map = Turbine.UI.Control();
		map:SetBackground( "Compendium/Common/Resources/images/map.tga" );
		map:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
		map:SetParent(coord);
	    map:SetSize( 16, 16 );
	    map:SetPosition(left,1);
	    map:SetZOrder(mapQS:GetZOrder() + 1);
	    map:SetMouseVisible(false);
	    self.map = map;
	    self.mapQS = mapQS;
	end

	self:AddItem(coord);
	self.coord = coord;

end

function CoordinateControl:ShowMenu( y, ns, x, ew, zone, isdungeon, name, quest )
	--Turbine.Shell.WriteLine( y .. ', ' .. ns .. ', ' .. x .. ', ' .. ew .. ', ' .. zone);
	-- no support
	if not self.moormap and not self.showCompass then return end;

	local lang = Compendium.Common.Resources.Settings:GetSetting('Language');

	if zone == nil then zone = 'Unknown' end;
	if self.moormap then
		local id = moormapZones[self:CleanZone(zone)];
		if not isdungeon and id ~= nil then
			local mmy, mmx = y, x;
			if string.lower(ns) == 's' then
				mmy = '-' .. mmy
			end;
			local lew = string.lower(ew);
			if ( lew == 'w' or ( lang == 'fr' and lew == 'o' ) ) then
				mmx = '-' ..mmx
			end;

			local sc = Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Alias, '' );
			sc:SetData(string.format('/Moormap ping %s:%s:%s:%s:%s', id,mmy,mmx,name,quest));
			self.mapQS:SetShortcut( sc );
			self.mapQS.DragDrop=function()
				self.mapQS:SetShortcut(sc);
			end
			self.map:SetVisible(true);
			self.mapQS:SetVisible(true);
		else
			self.map:SetVisible(false);
			self.mapQS:SetVisible(false);
			if not self.showCompass then
				return
			end
		end
	end
	if self.showCompass then
		local sc = Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Alias, '' );
		sc:SetData(string.format('/way target %s%s, %s%s', y, ns, x, ew));
		self.compassQS:SetShortcut( sc );
		self.compassQS.DragDrop=function()
			self.compassQS:SetShortcut(sc);
		end
	end

	Compendium.Common.UI.LabelMenu.ShowMenu(self);
end

function CoordinateControl:CleanZone( zone )
	zone = string.lower(zone);
	zone = string.gsub(zone, "^the%s+", "");
	zone = string.gsub(zone, "^die%s+", "");
	zone = string.gsub(zone, "^das%s+", "");
	--zone = string.gsub(zone, "^rohan%s+-%s+", "");
	zone = string.gsub(zone, "[^a-z0-9]", "");
	return zone;
end

