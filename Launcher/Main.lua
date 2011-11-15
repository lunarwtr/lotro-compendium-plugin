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
import "Compendium.Launcher.CompendiumLauncherWindow";
local clw = CompendiumLauncherWindow();
Turbine.Shell.WriteLine("<rgb=#008080>Compendium</rgb> " .. Plugins.Compendium:GetVersion() .. " by <rgb=#FF80FF>Lunarwater</rgb>");
		
CompendiumWindowCommand = Turbine.ShellCommand();

function CompendiumWindowCommand:Execute( command, arguments )
	if not clw:IsVisible() then
    	clw:SetVisible( true );
    end
    clw:ProcessCommandArguments(arguments);
end

function CompendiumWindowCommand:GetHelp()
    return clw:GetHelp(false);
end

function CompendiumWindowCommand:GetShortHelp()
    return "Compendium (/comp)";
end

Turbine.Shell.AddCommand( "Comp;Compendium;comp addcoord", CompendiumWindowCommand );

listCommandsCommand = Turbine.ShellCommand();
