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
import "Compendium.Common.UI.MiniAliasQuickslot";

ItemAliasMenu = class( Compendium.Common.UI.LabelMenu );

local channelConfig = {
	{ label = 'Say', shortcut = '/say <Examine:IIDDID:0x0000000000000000:0x%s>[%s]<\Examine> <rgb=#FF80FF>(from compendium)</rgb>' },  
	{ label = 'Kinship', shortcut = '/k <Examine:IIDDID:0x0000000000000000:0x%s>[%s]<\Examine> <rgb=#FF80FF>(from compendium)</rgb>' }, 
	{ label = 'Fellowship', shortcut = '/f <Examine:IIDDID:0x0000000000000000:0x%s>[%s]<\Examine> <rgb=#FF80FF>(from compendium)</rgb>' }, 
	{ label = 'Raid', shortcut = '/ra <Examine:IIDDID:0x0000000000000000:0x%s>[%s]<\Examine> <rgb=#FF80FF>(from compendium)</rgb>' }, 
	{ label = 'Trade WTB', shortcut = '/trade WTB <Examine:IIDDID:0x0000000000000000:0x%s>[%s]<\Examine>' }  
};

function ItemAliasMenu:Constructor()
    Compendium.Common.UI.LabelMenu.Constructor( self );
	
    local fontColor=Turbine.UI.Color(1,.9,.5);
    local fontFace=Turbine.UI.Lotro.Font.TrajanPro14;	
	
	self:SetSize(50,35);
	self:SetRowHighlight(false);
	
	local title = Turbine.UI.Label();
    title:SetParent( self );
    title:SetText( 'Link Item To Chat' );
    title:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
    title:SetSize( 130, 18 );
    title:SetFont(fontFace);
    title:SetForeColor(fontColor);
	--title:SetOutlineColor(fontColor);
    --title:SetFontStyle(Turbine.UI.FontStyle.Outline);    
	self:AddItem(title);
	
	for i,cfg in pairs(channelConfig) do
	
		local listitem = Turbine.UI.Label();
	    listitem:SetParent( self );
	    listitem:SetText( cfg.label );
	    listitem:SetPosition( 5, 0 );
	    listitem:SetSize(100, 18);
	    listitem:SetFont(fontFace);
	    listitem:SetForeColor(fontColor); 	
	
		local quickslot = Compendium.Common.UI.MiniAliasQuickslot();
	    quickslot:SetParent( listitem );
	    quickslot:SetPosition( listitem:GetWidth(), 1 );
	    quickslot.QuickslotClick = function() self:HideMenu() end;
	    listitem:SetWidth(listitem:GetWidth() + quickslot:GetWidth());
		self:AddItem(listitem);		
	
		self[cfg.label] = quickslot; 
	end
  	
end

function ItemAliasMenu:ShowAliasMenu( record ) 
	if record == nil then return end;
	
	-- add shortcuts
	for i,cfg in pairs(channelConfig) do
		local quickslot = self[cfg.label];
		local sc = Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Alias, '' );
		sc:SetData(string.format(cfg.shortcut,record['id'], record['name']));		
		quickslot:SetShortcut( Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Alias, sc ));
	end	
	
	-- display
	self:ShowMenu(self);

end