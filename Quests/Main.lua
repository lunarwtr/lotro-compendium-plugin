import "Compendium.Quests";

Compendium = CompendiumQuestWindow();
Compendium:SetVisible( true );

CompendiumWindowCommand = Turbine.ShellCommand();

function CompendiumWindowCommand:Execute( command, arguments )
    Compendium:SetVisible( true );
end

function CompendiumWindowCommand:GetHelp()
    return "Shows the Compendium window.";
end

function CompendiumWindowCommand:GetShortHelp()
    return "Shows Compendium.";
end

Turbine.Shell.AddCommand( "Comp;Compendium", CompendiumWindowCommand );

listCommandsCommand = Turbine.ShellCommand();
