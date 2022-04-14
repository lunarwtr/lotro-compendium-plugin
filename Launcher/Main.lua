
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
