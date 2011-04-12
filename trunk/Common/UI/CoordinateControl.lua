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

local moormapZones = {
	["angmar"] = 4,
	["annuminas"] = 20,
	["archet"] = 6,
	["bree"] = 9,
	["breeland"] = 5,
	["breelandhomesteads"] = 10,
	["carasgaladhon"] = 32,
	["durinsway"] = 35,
	["enedwaith"] = 12,
	["eredluin"] = 13,
	["eregion"] = 17,
	["eriador"] = 3,
	["ettenmoors"] = 1,
	["evendim"] = 19,
	["falathlornhomesteads"] = 14,
	["flamingdeeps"] = 36,
	["forochel"] = 21,
	["foundationsofstone"] = 37,
	["frostbluff"] = 22,
	["grandstair"] = 40,
	["greatdelving"] = 41,
	["lonelands"] = 23,
	["lothlrien"] = 31,
	["middleearth"] = 2,
	["mirkwood"] = 33,
	["mistymountatins"] = 24,
	["mistymountains"] = 24,
	["moria"] = 34,
	["northdowns"] = 25,
	["northernbarrowdowns"] = 7,
	["nudmelek"] = 38,
	["oldforest"] = 11,
	["redhornlodes"] = 39,
	["rhovanion"] = 30,
	["rivendell"] = 29,
	["shire"] = 26,
	["shirehomesteads"] = 27,
	["silvertinelodes"] = 42,
	["southernbarrowdowns"] = 8,
	["thorinsgate"] = 15,
	["thorinshallhomesteads"] = 16,
	["trollshaws"] = 28,
	["wallsofmoria"] = 18,
	["waterworks"] = 43,
	["zelemmelek"] = 44,
	["zirakzigil"] = 45
}


CoordinateControl = class( Compendium.Common.UI.LabelMenu );
function CoordinateControl:Constructor()
    Compendium.Common.UI.LabelMenu.Constructor( self );
	
	self:SetRowHighlight(false);

	local found=false;
	local loaded = Turbine.PluginManager:GetLoadedPlugins();
	for i, p in pairs(loaded) do
		if p.Name=="MoorMap" then
			found=true;
			break;
		end
	end
	
	self.showCompass = false; -- disabling for now
	self.moormap = false;
	if not found then
		local avail = Turbine.PluginManager:GetAvailablePlugins();
		local moorCfg = nil;
		for i, p in pairs(avail) do
			if p.Name == 'MoorMap' then
				moorCfg = p;
				break;
			end
		end
		if moorCfg ~= nil then
			Turbine.PluginManager.LoadPlugin("MoorMap");
			found = true;
			self.moormap = true;
		end
	else
		self.moormap = true;
	end	
	
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

function CoordinateControl:ShowMenu( y, ns, x, ew, zone, name, quest )
	-- no support
	if not self.moormap and not self.showCompass then return end;
	
	if zone == nil then zone = 'Unknown' end;
	if self.moormap then
		local id = moormapZones[self:CleanZone(zone)];
		if id ~= nil then
			local mmy, mmx = y, x;
			if string.lower(ns) == 's' then mmy = - mmy end;
			if string.lower(ew) == 'w' then mmx = - mmx end;
			
			local sc = Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Alias, '' );
			sc:SetData(string.format('/Moormap ping %s:%s:%s:%s:%s', id,mmy,mmx,name,quest));
			self.mapQS:SetShortcut( sc );
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
		sc:SetData(string.format('/comp waypoint [;loc|%s%s|%s%s|%s|%s]', y, ns, x, ew, name, quest));
		self.compassQS:SetShortcut( sc );
	end
	
	Compendium.Common.UI.LabelMenu.ShowMenu(self);
end

function CoordinateControl:CleanZone( zone )
	zone = string.lower(zone);
	zone = string.gsub(zone, "^the%s+", "");
	zone = string.gsub(zone, "[^a-z0-9]", "");
	return zone;
end

