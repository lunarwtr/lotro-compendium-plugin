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
import "Compendium.Items";
import "Compendium.Quests";
import "Compendium.Deeds";
import "Compendium.Crafts";
import "Compendium.Launcher.CompendiumShortcut";
import "Compendium.Common.Resources";

split = function (t,p)
local pat,n,count,L = "(.-)"..p, 1,0,#t
	local f = function (s,v)
          local i,j,x = s:find(pat,n)
          if i then
            count = count + 1
            n = j + 1
            return count,x
          elseif n < L then
            count = count + 1
            x = s:sub(n,-1)
            n = L + 1
            return count,x
          end -- if
    end -- function
	return f,t,n
end

local rsrc = {};
local compendiumdbs = { 
		{ key = 'Quest', title = 'Quest', init = function() return Compendium.Quests.CompendiumQuestControl() end },
		{ key = 'Deeds', title = 'Deeds', init = function() return Compendium.Deeds.CompendiumDeedControl() end },
		{ key = 'Items', title = 'Items', init = function() return Compendium.Items.CompendiumItemControl() end },
		{ key = 'Crafting', title = 'Crafting', init = function() return Compendium.Crafts.CompendiumCraftControl() end }
	};

CompendiumLauncherWindow = class( Compendium.Common.UI.CompendiumWindow );
function CompendiumLauncherWindow:Constructor()
    Compendium.Common.UI.CompendiumWindow.Constructor( self );

	self:LoadSettings();
	-- load correct language resources
	Compendium.Common.Resources.Bundle:SetLanguage(self.Settings.Language);
	rsrc = Compendium.Common.Resources.Bundle:GetResources();
	-- the different compendium dbs using resource names
	compendiumdbs[1]["title"] = rsrc['quest'];
	compendiumdbs[2]["title"] = rsrc['deeds'];
	compendiumdbs[3]["title"] = rsrc['items'];
	compendiumdbs[4]["title"] = rsrc['crafting'];
	
	self:SetPosition(self.Settings.WindowPos.left,self.Settings.WindowPos.top);
	self:SetVisible(self.Settings.WindowVisible);
	
	local shortcut = CompendiumShortcut();
	shortcut:SetPosition(self.Settings.IconPos.left,self.Settings.IconPos.top);
	shortcut.ShortcutClick = function() 
		self:SetVisible( not self:IsVisible() );
	end
	if self.Settings.UseMiniIcon then shortcut:SetMode('mini') end;
	shortcut:SetVisible(self.Settings.UseIcon);		
	
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
 
 	self.allowFade = false;
	self:SetOpacity( 1 );
	self:SetFadeSpeed( 5 );
    self.MouseEnter = function( sender, args )
    	if self.Settings.FadeWindow then
	    	self:SetFadeSpeed( .3 );
	        sender:SetOpacity( 1 );
        end
    end
    self.MouseLeave = function( sender, args )
    	if self.Settings.FadeWindow and self.allowFade then
	    	self:SetFadeSpeed( 5 );
	        sender:SetOpacity( 0.5 );
        end
    end

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
    help:SetSize( 13, 18 );
    help:SetFont(Turbine.UI.Lotro.Font.Verdana12);
    help:SetForeColor(self.white); 
    help.MouseClick = function( sender, args )
		self.about:SetVisible( true );
		self.about:Activate();
    end  

	local tabs = Compendium.Common.UI.TabControl();
	tabs:SetParent(self);
	tabs:SetSize(self:GetWidth() - 18, self:GetHeight() - 55);
	tabs:SetPosition(9,30);

	local settingControl = Turbine.UI.Control();
	settingControl:SetSize(200,200);
	
	local cbtop = 20;
	local checkbox = Turbine.UI.Lotro.CheckBox();
    checkbox:SetParent( settingControl );
    checkbox:SetMultiline( true );
    checkbox:SetPosition( 20, cbtop );
    checkbox:SetSize( 250, 20 );
    checkbox:SetFont(self.fontFace);
    checkbox:SetForeColor(self.fontColor);    
    checkbox:SetTextAlignment( Turbine.UI.CheckBox.BottomCenter );
    checkbox:SetText( "  " .. rsrc["fadewindow"] );
    checkbox:SetChecked(self.Settings.FadeWindow);
	checkbox.CheckedChanged = function(s,a)
		if s:IsChecked() then
			self.Settings.FadeWindow = true;
			self.allowFade = true;
		else
			self.Settings.FadeWindow = false;
		end
		self:SaveSettings();			
	end
    
	cbtop = cbtop + 40;
	
	local langlbl = Turbine.UI.Label();
	langlbl:SetParent( settingControl );
	langlbl:SetText(rsrc["language"]);
	langlbl:SetPosition(20, cbtop);
    langlbl:SetSize( 195, 40 );
    langlbl:SetFont(self.fontFace);
    langlbl:SetForeColor(self.fontColor);    
    langlbl:SetTextAlignment( Turbine.UI.CheckBox.BottomCenter );
    
    local langlist=Compendium.Common.UI.DropDownList();
    langlist:SetParent(settingControl);
    langlist:SetPosition(langlbl:GetLeft()+langlbl:GetWidth()+3,langlbl:GetTop()-3);
    langlist:SetSize(100,20);
    langlist:SetBorderColor(self.trimColor);
    langlist:SetCurrentBackColor(self.colorDarkGrey);
    langlist:SetBackColor(self.backColor);
    langlist:SetCurrentBackColor(self.backColor);
    langlist:SetDropRows(6);
    langlist:SetZOrder(150);
    langlist:AddItem(rsrc['en'], 'en');
    langlist:AddItem(rsrc['de'], 'de');
    langlist:AddItem(rsrc['fr'], 'fr');
    langlist:SelectIndexByValue(self.Settings.Language);
    langlist.DropDownUpdate=function()
		self.Settings.Language = langlist:GetValue();
		--Turbine.Shell.WriteLine(self.Settings.Language);
    	self:SaveSettings();
    end	
	cbtop = cbtop + 40;
	
	local fontlbl = Turbine.UI.Label();
	fontlbl:SetParent( settingControl );
	fontlbl:SetText(rsrc["fontsize"]);
	fontlbl:SetPosition(20, cbtop);
    fontlbl:SetSize( 195, 40 );
    fontlbl:SetFont(self.fontFace);
    fontlbl:SetForeColor(self.fontColor);    
    fontlbl:SetTextAlignment( Turbine.UI.CheckBox.BottomCenter );
    
    local fontlist=Compendium.Common.UI.DropDownList();
    fontlist:SetParent(settingControl);
    fontlist:SetPosition(fontlbl:GetLeft()+fontlbl:GetWidth()+3,fontlbl:GetTop()-3);
    fontlist:SetSize(100,20);
    fontlist:SetBorderColor(self.trimColor);
    fontlist:SetCurrentBackColor(self.colorDarkGrey);
    fontlist:SetBackColor(self.backColor);
    fontlist:SetCurrentBackColor(self.backColor);
    fontlist:SetDropRows(6);
    fontlist:SetZOrder(145);
    fontlist:AddItem(rsrc['fontsmall'], 'small');
    fontlist:AddItem(rsrc['fontlarge'], 'large');
    fontlist:SelectIndexByValue(self.Settings.FontSize);
    fontlist.DropDownUpdate=function()
		self.Settings.FontSize = fontlist:GetValue();
		--Turbine.Shell.WriteLine(self.Settings.Language);
    	self:SaveSettings();
    end		
	cbtop = cbtop + 40;
	
	for i, rec in pairs(compendiumdbs) do
		local db = rec.key;
		checkbox = Turbine.UI.Lotro.CheckBox();
	    checkbox:SetParent( settingControl );
	    checkbox:SetMultiline( true );
	    checkbox:SetPosition( 20, cbtop );
	    checkbox:SetSize( 400, 20 );
	    checkbox:SetFont(self.fontFace);
	    checkbox:SetForeColor(self.fontColor);    
	    checkbox:SetTextAlignment( Turbine.UI.CheckBox.BottomCenter );
	    checkbox:SetText( "  "..string.format(rsrc["loadscompendium"], rec.title) );
	    checkbox:SetChecked(self.Settings.Components[db]);
		checkbox.CheckedChanged = function(s,a)
			if s:IsChecked() then
				self.Settings.Components[db] = true;
			else
				self.Settings.Components[db] = false;
			end
			self.Settings.ActiveTabIndex = 1;
			self:SaveSettings();
		end	
		cbtop = cbtop + 20;
		
		if self.Settings.Components[db] == true then
			tabs:AddTab(rec.title, rec.init());
		end
	end
	
	cbtop = cbtop + 20;
	checkbox = Turbine.UI.Lotro.CheckBox();
    checkbox:SetParent( settingControl );
    checkbox:SetMultiline( true );
    checkbox:SetPosition( 20, cbtop );
    checkbox:SetSize( 250, 20 );
    checkbox:SetFont(self.fontFace);
    checkbox:SetForeColor(self.fontColor);    
    checkbox:SetTextAlignment( Turbine.UI.CheckBox.BottomCenter );
    checkbox:SetText( "  " .. rsrc["icon"] );
    checkbox:SetChecked(self.Settings.UseIcon);
	checkbox.CheckedChanged = function(s,a)
		if s:IsChecked() then
			self.Settings.UseIcon = true;
			self.allowFade = true;
		else
			self.Settings.UseIcon = false;
		end
		self:SaveSettings();
		shortcut:SetVisible(self.Settings.UseIcon);		
	end	
	
	cbtop = cbtop + 20;
	checkbox = Turbine.UI.Lotro.CheckBox();
    checkbox:SetParent( settingControl );
    checkbox:SetMultiline( true );
    checkbox:SetPosition( 40, cbtop );
    checkbox:SetSize( 250, 20 );
    checkbox:SetFont(self.fontFace);
    checkbox:SetForeColor(self.fontColor);    
    checkbox:SetTextAlignment( Turbine.UI.CheckBox.BottomCenter );
    checkbox:SetText( "  " .. rsrc["iconmini"] );
    checkbox:SetChecked(self.Settings.UseMiniIcon);
	checkbox.CheckedChanged = function(s,a)
		if s:IsChecked() then
			self.Settings.UseMiniIcon = true;
			self.allowFade = true;
		else
			self.Settings.UseMiniIcon = false;
		end
		self:SaveSettings();
		if self.Settings.UseMiniIcon then
			shortcut:SetMode('mini');
		else
			shortcut:SetMode('large');
		end;
	end		
	
	local plugs = Turbine.PluginManager.GetAvailablePlugins();
	local loaded = Turbine.PluginManager.GetLoadedPlugins();
	local loadedhash = {};
	for i,a in pairs(loaded) do
		loadedhash[a.Name] = a;
	end
	local moormap = false
	for i,a in pairs(plugs) do
		if string.find(a.Name, "CompendiumExtension") ~= nil then
			if loadedhash[a.Name] == nil then
				Turbine.Shell.WriteLine(rsrc["loading"].. ' ' .. a.Name);
				Turbine.PluginManager.LoadPlugin(a.Name);
			end
			local cls = _G;
			for j, b in split(a.Package, '%.') do
				cls = cls[b];
			end	

			local ext = cls();
			tabs:AddTab(ext:GetExtensionName(), ext);
		end
		if a.Name == 'MoorMap' then moormap = true end
	end
	
	if moormap == false and self.Settings.MoorMapNotice ~= true then
	
		local notice = Compendium.Common.UI.CompendiumWindow()
		notice:SetSize(300,290);
		notice:SetText('Notice');
		local noticeImg = Turbine.UI.Control();
		noticeImg:SetSize(200,150);
		noticeImg:SetBackground('Compendium/Common/Resources/images/moormaps.tga');
	    noticeImg:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);
	    noticeImg:SetParent(notice);
	    noticeImg:SetPosition((notice:GetWidth() / 2) - (noticeImg:GetWidth() / 2), 45);
	    local noticeMsg = Turbine.UI.Label()
	    noticeMsg:SetSize(250, 40);
	    noticeMsg:SetParent(notice);
	 	noticeMsg:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	    noticeMsg:SetFont(self.fontFace);
	    noticeMsg:SetForeColor(self.fontColor);
	    noticeMsg:SetOutlineColor(Turbine.UI.Color(0,0,0));
	    noticeMsg:SetFontStyle(Turbine.UI.FontStyle.Outline);   
		noticeMsg:SetText(rsrc["download"]);
		noticeMsg:SetPosition((notice:GetWidth() / 2) - (noticeMsg:GetWidth() / 2), noticeImg:GetTop() + noticeImg:GetHeight() + 5);
		local ok = Turbine.UI.Lotro.Button();
		ok:SetSize(50,20);
	 	ok:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		ok:SetText(rsrc["ok"]);
		ok:SetParent(notice);
		ok:SetPosition((notice:GetWidth() / 2) - (ok:GetWidth() / 2), notice:GetHeight() - 40);
		ok.Click = function(s,a)
			self.Settings.MoorMapNotice = true;
			self:SaveSettings();
			notice:SetVisible(false);
		end
		notice:SetVisible(true);
		notice:Activate();
		self.notice = notice;
		
	end
	
	tabs:AddTab(rsrc["settings"],  settingControl);
	tabs:SetActiveIndex(self.Settings.ActiveTabIndex);

	tabs.OnActiveTabChange = function (sender,index) 
		self.Settings.ActiveTabIndex = index;
		self:SaveSettings();
	end
	self.tabs = tabs;
	
 	self.SetHeight = function(sender,height)
        if height<150 then height=150 end;
        Turbine.UI.Lotro.Window.SetHeight(self,height);
        tabs:SetHeight(height - 55);
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
        self.allowFade = false;
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
    	self.allowFade = true;
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
			self:persist();
			self:destroy();
		end
	end
	
    self:SetWantsKeyEvents( true );
    self.KeyDown = function( sender, args )
        if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
            self:SetVisible( false );
        end
	end
    	
    self.allowFade = true;
    
end

function CompendiumLauncherWindow:LoadSettings()
	self.Settings = Compendium.Common.Utils.PluginData.Load( Turbine.DataScope.Account , "CompendiumSettings")
	
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
			FadeWindow = true,
			ActiveTabIndex = 1,
			Components = {},
			Language = 'en',
			FontSize = 'small',
			UseIcon = true,
			UseMiniIcon = false
		};
		for i, rec in pairs(compendiumdbs) do
			self.Settings.Components[rec.title] = true;
		end
		
	else
		-- for backwards compatibility
		if self.Settings.WindowVisible == nil then
			self.Settings.WindowVisible = true;
		end
		if self.Settings.ActiveTabIndex == nil then
			self.Settings.ActiveTabIndex = 1;
		end	
		if self.Settings.FadeWindow == nil then
			self.Settings.FadeWindow = true;
		end
		if self.Settings.Language == nil then
			self.Settings.Language = 'en';
		end
		if self.Settings.Components == nil then
			self.Settings.Components = {}
		end
		if self.Settings.FontSize == nil then
			self.Settings.FontSize = 'small';
		end
		if self.Settings.UseIcon == nil then
			self.Settings.UseIcon = true;
		end
		if self.Settings.UseMiniIcon == nil then
			self.Settings.UseMiniIcon = false;
		end
		for i, rec in pairs(compendiumdbs) do
			if self.Settings.Components[rec.title] == nil then
				self.Settings.Components[rec.title] = true;
			end
		end
	end
	Compendium.Common.Resources.Settings:SetSettings(self.Settings);
	
end

function CompendiumLauncherWindow:SaveSettings()
	Compendium.Common.Resources.Settings:SetSettings(self.Settings);
	Compendium.Common.Utils.PluginData.Save(Turbine.DataScope.Account, "CompendiumSettings", self.Settings );
end

function CompendiumLauncherWindow:destroy()
	Turbine.Shell.WriteLine(rsrc["unloadingcompendium"]);
	self.MouseDown = nil;
	self.MouseMove = nil;
	self.MouseUp = nil;
	self.PositionChanged = nil;
	self.VisibleChanged = nil;	
	self.tabs:destroy();
end

function CompendiumLauncherWindow:persist()
	Compendium.Common.Resources.Settings:SetSettings(self.Settings);
	Compendium.Common.Utils.PluginData.Save( Turbine.DataScope.Account, "CompendiumSettings", self.Settings );
	self.tabs:persist();
end


function CompendiumLauncherWindow:SetFadeSpeed( value )
    self.fadeSpeed = 1 / value;
end

function CompendiumLauncherWindow:SetVisible( value )

	if ( value == true ) then
		Compendium.Common.UI.CompendiumWindow.SetVisible(self, true);
        self:SetOpacity( 1 );
    else
		Compendium.Common.UI.CompendiumWindow.SetVisible(self, false);
    end
end

function CompendiumLauncherWindow:SetOpacity( value )
    self.realOpacity = value;
    self.currentTime = Turbine.Engine.GetGameTime();
    self.currentOpacity = Compendium.Common.UI.CompendiumWindow.GetOpacity( self );
    self.targetOpacity = value;

    if ( self.targetOpacity ~= self.currentOpacity ) then
        self:SetWantsUpdates( true );
    end
end

function CompendiumLauncherWindow:Update( sender, args )
    local newOpacity;

    local now = Turbine.Engine.GetGameTime();
    local delta = now - self.currentTime;
    self.currentTime = now;

    delta = delta * self.fadeSpeed;

    if ( self.currentOpacity < self.targetOpacity ) then
        newOpacity = self.currentOpacity + delta;

        if ( newOpacity > self.targetOpacity ) then
            self:SetWantsUpdates( false )
            newOpacity = self.targetOpacity
        end
    else
        newOpacity = self.currentOpacity - delta;

        if ( newOpacity < self.targetOpacity ) then
            self:SetWantsUpdates( false )
            newOpacity = self.targetOpacity

            if ( self.hideOnClose ) then
                Compendium.Common.UI.CompendiumWindow.SetVisible( self, false );
                self.hideOnClose = false
            end
        end
    end

    self.currentOpacity = newOpacity;
    Compendium.Common.UI.CompendiumWindow.SetOpacity( self, newOpacity );
end


function CompendiumLauncherWindow:ProcessCommandArguments(args)

	if args == 'help' then
		Turbine.Shell.WriteLine(self:GetHelp(true));
	elseif args == 'hide' then
		self:SetVisible(false);
	elseif args == 'show' then
		self:SetVisible(true);
	else
		local cmd, loc, target = args:match "^%s*(addcoord)%s*%[([^%|]+)%|([^%]]+)%]"; --%[[^:]+:%\s*([^:]+):\s*([^%|]+)%|([^%]]+)%s*%]$";
		if cmd == 'addcoord' then
			 local area, coord = loc:match "%s*([^:]+):%s*([^:]+)$";
			 
			 local coordrec = nil
			 if area ~= nil then
			 	coordrec = { area = area, coord = coord, target = target };
			 else
			 	coordrec = { area = loc, target = target };
			 end
			 
			 local control = self.tabs:GetActiveControl();
			 if control.AddCoordinate ~= nil then
			 	control:AddCoordinate(coordrec);
			 end
		else
			Turbine.Shell.WriteLine(self:GetHelp(true));
		end
	end

end

function CompendiumLauncherWindow:GetHelp(tagged)

	if tagged then
		return "<rgb=#008080>Compendium</rgb> " .. Plugins.Compendium:GetVersion() .. " by <rgb=#FF80FF>Lunarwater</rgb>\n" ..
			 "    <rgb=#008080>/comp help</rgb> : shows Compendium help \n" ..
			 "    <rgb=#008080>/comp show</rgb> : shows Compendium \n" ..
			 "    <rgb=#008080>/comp hide</rgb> : hides Compendium \n";
	else
		return "Compendium " .. Plugins.Compendium:GetVersion() .. " by Lunarwater\n" ..
			 "    /comp help : shows Compendium help \n" ..
			 "    /comp show : shows Compendium \n" ..
			 "    /comp hide : hides Compendium \n";
	end 
end