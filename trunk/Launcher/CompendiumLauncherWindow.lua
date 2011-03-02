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
import "Turbine";
import "Turbine.Gameplay";
import "Turbine.UI";
import "Turbine.UI.Lotro";

import "Compendium.Common";
import "Compendium.Common.UI";
import "Compendium.Items";
import "Compendium.Quests";
import "Compendium.Launcher.CompendiumShortcut";

CompendiumLauncherWindow = class( Compendium.Common.UI.CompendiumWindow );
function CompendiumLauncherWindow:Constructor()
    Compendium.Common.UI.CompendiumWindow.Constructor( self );

	self:LoadSettings();
	self:SetPosition(self.Settings.WindowPos.left,self.Settings.WindowPos.top);
	self:SetSize(self.Settings.WindowSize.width, self.Settings.WindowSize.height);
	local shortcut = CompendiumShortcut();
	shortcut:SetPosition(self.Settings.IconPos.left,self.Settings.IconPos.top);
	shortcut.ShortcutClick = function() 
		self:SetVisible( not self:IsVisible() );
	end
	
	shortcut.ShortcutMoved = function(left, top)
		self.Settings.IconPos.left = left;
		self.Settings.IconPos.top = top;
		self:SaveSettings();
	end
	self.PositionChanged = function(sender,args) 
		self.Settings.WindowPos.left = self:GetLeft();
		self.Settings.WindowPos.top = self:GetTop();
		self:SaveSettings();		
	end

    self:SetText( "Compendium" );
 
    self.footer=Turbine.UI.Control();
    self.footer:SetSize(self:GetWidth() - 30, 20);
    self.footer:SetPosition(30, self:GetHeight() - 25);
    self.footer:SetParent(self);
    
    local footerText = Turbine.UI.Label();
    footerText:SetSize(300,18);
    footerText:SetPosition(18, 1);
    footerText:SetParent(self.footer);
    footerText:SetFont(self.fontFace);
    footerText:SetForeColor(self.fontColor);
    footerText:SetOutlineColor(Turbine.UI.Color(0,0,0));
    footerText:SetFontStyle(Turbine.UI.FontStyle.Outline);   
    footerText:SetSelectable(true);
    footerText:SetText('http://lotrocompendium.sourceforge.net/');
       
    -- add help/about button
    self.about = Compendium.Common.UI.CompendiumAboutWindow();
    local help = Turbine.UI.Label();
    help:SetParent( self.footer );
    help:SetText( "[?]" );
    help:SetPosition( 0, 1 );
    help:SetSize( 12, 18 );
    help:SetFont(self.fontFace);
    help:SetForeColor(self.white); 
    help.MouseClick = function( sender, args )
		self.about:SetVisible( true );
		self.about:Activate();
    end  

    local quest = Turbine.UI.Label();
    quest:SetParent( self );
    quest:SetText( "Quests" );
    quest:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
    quest:SetFont(self.fontFace);
    quest:SetForeColor(self.fontColor);
    quest:SetOutlineColor(Turbine.UI.Color(0,0,0));
    quest:SetFontStyle(Turbine.UI.FontStyle.Outline); 
   	quest:SetBackground( "Compendium/Common/Resources/images/compendium-tab-selected.tga" );
    quest:SetPosition( 30, 30 );
    quest:SetSize( 111, 23 );
    quest:SetZOrder(100);
    quest:SetBlendMode(Turbine.UI.BlendMode.Screen);
    
    local items = Turbine.UI.Label();
    items:SetParent( self );
    items:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
    items:SetText( "Items" );
    items:SetFont(self.fontFace);
    items:SetForeColor(self.fontColor);
    items:SetOutlineColor(Turbine.UI.Color(0,0,0));
    items:SetFontStyle(Turbine.UI.FontStyle.Outline);    
    items:SetPosition( 145, 30 );
    items:SetSize( 111, 23 );
   	items:SetBackground( "Compendium/Common/Resources/images/compendium-tab-nonselected.tga" );    
    items:SetZOrder(101);
    items:SetBlendMode(Turbine.UI.BlendMode.Screen);
    
    quest.MouseClick = function( sender, args )
    	self.activeTab = quest;
	   	quest:SetBackground( "Compendium/Common/Resources/images/compendium-tab-selected.tga" );
		items:SetBackground( "Compendium/Common/Resources/images/compendium-tab-nonselected.tga" );
		self.questControl:SetVisible(true);
		self.itemsControl:SetVisible(false);
    end
	quest.MouseEnter = function( sender, args )
	   	quest:SetBackground( "Compendium/Common/Resources/images/compendium-tab-selected.tga" );
	end
	quest.MouseLeave = function( sender, args )
		if sender ~= self.activeTab then
			quest:SetBackground( "Compendium/Common/Resources/images/compendium-tab-nonselected.tga" );
		end
	end

	items.MouseClick = function( sender, args )
    	self.activeTab = items;
	   	quest:SetBackground( "Compendium/Common/Resources/images/compendium-tab-nonselected.tga" );
	   	items:SetBackground( "Compendium/Common/Resources/images/compendium-tab-selected.tga" );    
		self.questControl:SetVisible(false);
		self.itemsControl:SetVisible(true);
    end
	items.MouseEnter = function( sender, args )
	   	items:SetBackground( "Compendium/Common/Resources/images/compendium-tab-selected.tga" );
	end
	items.MouseLeave = function( sender, args )
		if sender ~= self.activeTab then
			items:SetBackground( "Compendium/Common/Resources/images/compendium-tab-nonselected.tga" );
		end
	end

    local tabBorder = Turbine.UI.Control();
    tabBorder:SetParent(self);
    tabBorder:SetPosition(7,52);
    tabBorder:SetSize(self:GetWidth()-14,self:GetHeight() - quest:GetHeight() - 55);
    tabBorder:SetBackColor(Turbine.UI.Color(0.18,0.19,0.29)); 
    tabBorder:SetZOrder(99);
	local tabContainer = Turbine.UI.Control();
    tabContainer:SetParent(tabBorder);
    tabContainer:SetPosition(1,1);
    tabContainer:SetSize(tabBorder:GetWidth()-2,tabBorder:GetHeight()-2);
    tabContainer:SetBackColor(Turbine.UI.Color(0.9,0,0,0));
	
	self.questControl = Compendium.Quests.CompendiumQuestControl();
    self.questControl:SetParent(tabContainer);
    self.questControl:SetSize(tabContainer:GetWidth()-4,tabContainer:GetHeight()-3);
    self.questControl:SetPosition(2,1);
    self.questControl:SetVisible(true);
	
	self.itemsControl = Compendium.Items.CompendiumItemControl();
    self.itemsControl:SetVisible(false);
    self.itemsControl:SetParent(tabContainer);
    self.itemsControl:SetSize(tabContainer:GetWidth()-4,tabContainer:GetHeight()-3);
    self.itemsControl:SetPosition(2,1);
        
end

function CompendiumLauncherWindow:LoadSettings()
	self.Settings = Turbine.PluginData.Load( Turbine.DataScope.Account , "CompendiumSettings")
	
	if self.Settings == nil then
		self.Settings = { 
			WindowPos = {  
				["left"] = tostring(( Turbine.UI.Display:GetWidth() - 560) / 2),
				["top"] = tostring(( Turbine.UI.Display:GetHeight() - 480) / 2)
			},
			WindowSize = {
				["width"] = 560,
				["height"] = 480    
			},
			IconPos = {
				["left"] = tostring(Turbine.UI.Display.GetWidth()-55),
				["top"] = "230";
			}
		};
	end
end

function CompendiumLauncherWindow:SaveSettings()
	Turbine.PluginData.Save( Turbine.DataScope.Account, "CompendiumSettings", self.Settings );
end
