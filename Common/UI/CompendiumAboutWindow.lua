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
import "Compendium.Common.Class";
import "Compendium.Common.UI.CompendiumWindow";

CompendiumAboutWindow = class( Compendium.Common.UI.CompendiumWindow );
function CompendiumAboutWindow:Constructor()
    Compendium.Common.UI.CompendiumWindow.Constructor( self );

    self:SetSize(400,200);
    self:SetOpacity( 1 );
    self:SetVisible(false);

    self:SetText( "About Compendium" );
    self.MainPanel=Turbine.UI.Control();
    self.MainPanel:SetParent(self);
    self.MainPanel:SetSize(self:GetWidth()-10,self:GetHeight()-10);
    self.MainPanel:SetPosition(5,30);
    self.MainPanel:SetBlendMode(Turbine.UI.BlendMode.Overlay);
    self.MainPanel:SetMouseVisible(false);
    
	self.logo = Turbine.UI.Control();
	self.logo:SetBlendMode(Turbine.UI.BlendMode.Screen)
	self.logo:SetBackground( "Compendium/Common/Resources/images/CompendiumLogoSmall.tga" );
	self.logo:SetPosition(0 ,0);
	self.logo:SetSize(75,100);
	self.logo:SetParent( self.MainPanel );
	
	local version = Turbine.UI.Label();
	version:SetParent(self.MainPanel);
	version:SetSize(70,30);
	version:SetPosition(3,102);
	version:SetText('version\n1.2-beta');
    version:SetFont(self.fontFace);
    version:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
    
	    
    local block = Turbine.UI.Label();
    block:SetSize(self.MainPanel:GetWidth() - self.logo:GetWidth() - 3,self.MainPanel:GetHeight() - 40);
    block:SetPosition(78, 5);
    block:SetParent(self.MainPanel);
    block:SetFont(self.fontFace);
    block:SetForeColor(self.fontColor);
    block:SetOutlineColor(Turbine.UI.Color(0,0,0));
    block:SetFontStyle(Turbine.UI.FontStyle.Outline);   
    block:SetSelectable(true);
    block:SetText('To Open Compendium:\n      /comp or /Compendium\n\n' ..
    			  'Visit us at: \n   http://lotrocompendium.sourceforge.net/\n\n' ..
    			  'More coming soon!\n\n'..
    			  'Special Thanks to the folks at lotrointerface.com\n\n'..
    			  '© 2011 Lunarwater  |  Apache License V2.0');
    	
    local scroll=Turbine.UI.Lotro.ScrollBar();
    scroll:SetOrientation(Turbine.UI.Orientation.Vertical);
    scroll:SetParent(block);
    scroll:SetBackColor(Turbine.UI.Color(.05,.05,.05));
    scroll:SetPosition(block:GetWidth()-16,0)
    scroll:SetWidth(12);
    scroll:SetHeight(block:GetHeight()-2);
    block:SetVerticalScrollBar(scroll);    	
    	
    		    
end
