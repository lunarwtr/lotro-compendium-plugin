

import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Compendium.Common.Utils";
import "Compendium.Common.UI";
import "Compendium.Common.UI.MiniAliasQuickslot";

ItemAliasMenu = class( Compendium.Common.UI.LabelMenu );

local channelConfig = {};

function ItemAliasMenu:Constructor()
    Compendium.Common.UI.LabelMenu.Constructor( self );
	rsrc = Compendium.Common.Resources.Bundle:GetResources();
	channelConfig = {
		{ label = rsrc['say'], shortcut = rsrc["saychat"]..' <Examine:IIDDID:0x0000000000000000:0x%s>[%s]<\Examine> <rgb=#FF80FF>('..rsrc['fromcomp']..')</rgb>' },  
		{ label = rsrc['kinship'], shortcut = rsrc["kinchat"]..' <Examine:IIDDID:0x0000000000000000:0x%s>[%s]<\Examine> <rgb=#FF80FF>('..rsrc['fromcomp']..')</rgb>' }, 
        { label = rsrc['officer'], shortcut = rsrc["officerchat"]..' <Examine:IIDDID:0x0000000000000000:0x%s>[%s]<\Examine> <rgb=#FF80FF>('..rsrc['fromcomp']..')</rgb>' }, 
		{ label = rsrc['fellowship'], shortcut = rsrc["fellowchat"]..' <Examine:IIDDID:0x0000000000000000:0x%s>[%s]<\Examine> <rgb=#FF80FF>('..rsrc['fromcomp']..')</rgb>' }, 
        { label = rsrc['advice'], shortcut = rsrc["advicechat"]..' <Examine:IIDDID:0x0000000000000000:0x%s>[%s]<\Examine> <rgb=#FF80FF>('..rsrc['fromcomp']..')</rgb>' }, 		
		{ label = rsrc['raid'], shortcut = rsrc["raidchat"]..' <Examine:IIDDID:0x0000000000000000:0x%s>[%s]<\Examine> <rgb=#FF80FF>('..rsrc['fromcomp']..')</rgb>' }, 
		{ label = rsrc['tradewtb'], shortcut = rsrc["tradechat"]..' WTB <Examine:IIDDID:0x0000000000000000:0x%s>[%s]<\Examine>' },  
		{ label = rsrc['user1'], shortcut = rsrc["userchat1"]..' <Examine:IIDDID:0x0000000000000000:0x%s>[%s]<\Examine> <rgb=#FF80FF>('..rsrc['fromcomp']..')</rgb>' },  
		{ label = rsrc['user2'], shortcut = rsrc["userchat2"]..' <Examine:IIDDID:0x0000000000000000:0x%s>[%s]<\Examine> <rgb=#FF80FF>('..rsrc['fromcomp']..')</rgb>' },  
		{ label = rsrc['user3'], shortcut = rsrc["userchat3"]..' <Examine:IIDDID:0x0000000000000000:0x%s>[%s]<\Examine> <rgb=#FF80FF>('..rsrc['fromcomp']..')</rgb>' },  
		{ label = rsrc['user4'], shortcut = rsrc["userchat4"]..' <Examine:IIDDID:0x0000000000000000:0x%s>[%s]<\Examine> <rgb=#FF80FF>('..rsrc['fromcomp']..')</rgb>' }
	}	
	
    local fontColor=Turbine.UI.Color(1,.9,.5);
    local fontFace=Turbine.UI.Lotro.Font.Verdana14;	
	
	self:SetSize(50,35);
	self:SetRowHighlight(false);
	
	local title = Turbine.UI.Label();
    title:SetParent( self );
    title:SetText( rsrc["linkitem"] );
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
		quickslot:SetShortcut( sc );
	end	
	
	-- display
	self:ShowMenu(self);

end