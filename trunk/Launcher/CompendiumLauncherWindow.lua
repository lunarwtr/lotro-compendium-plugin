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

import "Compendium.Common.Utils";
import "Compendium.Common.UI";
import "Compendium.Common.UI";
import "Compendium.Items";
import "Compendium.Quests";
import "Compendium.Crafts";
import "Compendium.Launcher.CompendiumShortcut";

CompendiumLauncherWindow = class( Compendium.Common.UI.CompendiumWindow );
function CompendiumLauncherWindow:Constructor()
    Compendium.Common.UI.CompendiumWindow.Constructor( self );

	self:LoadSettings();
	self:SetPosition(self.Settings.WindowPos.left,self.Settings.WindowPos.top);
	self:SetVisible(self.Settings.WindowVisible);
	
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
	self.VisibleChanged = function() 
		self.Settings.WindowVisible = self:IsVisible();
		self:SaveSettings();
	end

    self:SetText( "Compendium " );
 
 	local version = Turbine.UI.Label();
 	version:SetParent(self);
 	version:SetSize(100,15);
 	version:SetText('(' .. Plugins.Compendium:GetVersion() .. ')');
 	version:SetPosition((self:GetWidth() / 2) + 65,10);
 	version:SetFont(Turbine.UI.Lotro.Font.TrajanPro13);
    version:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
 	version:SetForeColor(self.fontColor);
 
    self.footer=Turbine.UI.Control();
    self.footer:SetSize(self:GetWidth() - 50, 20);
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

	local tabs = Compendium.Common.UI.TabControl();
	tabs:SetParent(self);
	tabs:SetSize(self:GetWidth() - 18, self:GetHeight() - 50);
	tabs:SetPosition(9,30);
	tabs:AddTab("Quests",  Compendium.Quests.CompendiumQuestControl());
	tabs:AddTab("Items",  Compendium.Items.CompendiumItemControl());
	tabs:AddTab("Crafting",  Compendium.Crafts.CompendiumCraftControl());
	tabs:SetActiveIndex(self.Settings.ActiveTabIndex);

	tabs.OnActiveTabChange = function (sender,index) 
		self.Settings.ActiveTabIndex = index;
		self:SaveSettings();
	end
	self.tabs = tabs;
	
 	self.SetHeight = function(sender,height)
        if height<150 then height=150 end;
        Turbine.UI.Lotro.Window.SetHeight(self,height);
        tabs:SetHeight(height - 35);
		self.footer:SetTop(height - 25);        
    end
 	self.SetWidth = function(sender,width)
        if width<110 then width=110 end;
        Turbine.UI.Lotro.Window.SetWidth(self,width);
        tabs:SetWidth(width - 18);
		self.footer:SetWidth(self:GetWidth() - 50);
		version:SetLeft((width / 2) + 35);		
    end
	self.SetSize = function(sender,width, height) 
		self:SetWidth(width);
		self:SetHeight(height);
	end	
	
    self.Resizing=false;
    self.MoveX=-1;
    self.MoveY=-1;
    self.MovingIcon=Turbine.UI.Control();
    self.MovingIcon:SetParent(self);
    self.MovingIcon:SetSize(32,32);
    self.MovingIcon:SetBackground(0x410081c0)
    self.MovingIcon:SetStretchMode(2);
    self.MovingIcon:SetPosition(self:GetWidth()/2-15,self:GetHeight()-21);
    self.MovingIcon:SetVisible(false);
    self.MouseDown=function(sender,args)
        if (args.Y>self:GetHeight()-50) and (args.X>self:GetWidth()-50) then
            self.MoveX=args.X;
            self.MoveY=args.Y;
            self.MovingIcon:SetLeft(args.X-12);
            self.MovingIcon:SetTop(args.Y-12);
            self.MovingIcon:SetSize(32,32);
            self.MovingIcon:SetBackground(0x41007e20)
            self.MovingIcon:SetVisible(true);
        elseif (args.Y>self:GetHeight()-12) then
            self.MoveY=args.Y;
            self.MovingIcon:SetLeft(args.X-22);
            self.MovingIcon:SetTop(args.Y-12);
            self.MovingIcon:SetSize(32,32);
            self.MovingIcon:SetBackground(0x410081c0)
            self.MovingIcon:SetVisible(true);
        elseif (args.X>self:GetWidth()-12) then
            self.MoveX=args.X;
            self.MovingIcon:SetLeft(args.X-12);
            self.MovingIcon:SetTop(args.Y-22);
            self.MovingIcon:SetSize(32,32);
            self.MovingIcon:SetBackground(0x410081bf)
            self.MovingIcon:SetVisible(true);
        elseif (args.Y<2) then
            self.MoveX=args.X;
            self.MoveY=args.Y;
            self.MovingIcon:SetLeft(args.X-12);
            self.MovingIcon:SetTop(args.Y-12);
            self.MovingIcon:SetSize(16,16);
            self.MovingIcon:SetBackground(0x41007e0c)
            self.MovingIcon:SetVisible(true);
        else
            self.MoveX=-1;
            self.MoveY=-1;
        end
    end

    self.MouseMove=function(sender,args)
        if (self.MoveY>-1) then
            if args.Y~= self.MoveY then
                self.Resizing=true;
                local newHeight=self:GetHeight()-(self.MoveY-args.Y);
                if newHeight<156 then newHeight=156 end;
                if newHeight>(Turbine.UI.Display.GetHeight()-self:GetTop()) then newHeight=Turbine.UI.Display.GetHeight()-self:GetTop() end;
                local newX=args.X-22;
                if newX<-13 then newX=-13 end
                if newX>(self:GetWidth()-18) then newX=self:GetWidth()-18 end
                self.MovingIcon:SetLeft(newX);
                self.MovingIcon:SetPosition(newX,args.Y - 9);
                self:SetHeight(newHeight);
                self.MoveY=args.Y;
            end
        end
        if (self.MoveX>-1) then
            if args.X~= self.MoveX then
                self.Resizing=true;
                local newWidth=self:GetWidth()-(self.MoveX-args.X);
                if newWidth<414 then newWidth=414 end;
                if newWidth>(Turbine.UI.Display.GetWidth()-self:GetLeft()) then newWidth=Turbine.UI.Display.GetWidth()-self:GetLeft() end;
                local newY=args.Y-22;
                if newY<-13 then newY=-13 end
                if newY>(self:GetHeight()-18) then newY=self:GetHeight()-18 end
                self.MovingIcon:SetPosition(args.X - 9,newY);
                self:SetWidth(newWidth);
                self.MoveX=args.X;
            end
        end
    end
    self.MouseUp=function(sender,args)
        self.MovingIcon:SetVisible(false);
        self.MoveX=-1;
        self.MoveY=-1;
        if self.Resizing == true then
        	self.Resizing = false;
			self.Settings.WindowSize.width = self:GetWidth();
			self.Settings.WindowSize.height = self:GetHeight();
			self:SaveSettings();
		end	        
    end
    
	self:SetSize(self.Settings.WindowSize.width, self.Settings.WindowSize.height);
	if Plugins.Compendium.Unload == nil then
		Plugins.Compendium.Unload = function() 
			self:destroy();
		end
	end
	
end

function CompendiumLauncherWindow:LoadSettings()
	self.Settings = Turbine.PluginData.Load( Turbine.DataScope.Account , "CompendiumSettings")
	
	if self.Settings == nil then
		self.Settings = { 
			WindowVisible = true,
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
			},
			ActiveTabIndex = 1
		};
	else
		-- for backwards compatibility
		if self.Settings.WindowVisible == nil then
			self.Settings.WindowVisible = true;
		end
		if self.Settings.ActiveTabIndex == nil then
			self.Settings.ActiveTabIndex = 1;
		end		
	end
end

function CompendiumLauncherWindow:SaveSettings()
	Turbine.PluginData.Save( Turbine.DataScope.Account, "CompendiumSettings", self.Settings );
end

function CompendiumLauncherWindow:destroy()
	Turbine.Shell.WriteLine('Unloading Compendium..');
	self.MouseDown = nil;
	self.MouseMove = nil;
	self.MouseUp = nil;
	self.PositionChanged = nil;
	self.VisibleChanged = nil;	
	self.tabs:destroy();
end