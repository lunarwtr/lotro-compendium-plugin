
import "Turbine";
import "Turbine.UI";
import "Compendium.Common.Utils";

Reloader=class(Turbine.UI.Window);
function Reloader:Constructor()
	Turbine.UI.Window.Constructor(self);
    self.reloaded=false;
    self.Update=function()
        if (not self.reloaded) and (Plugins["CompendiumReloader"] ~= nil) then
            self:SetWantsUpdates(false);
            self.reloaded=true;
			Turbine.PluginManager.UnloadScriptState("Compendium");
			Turbine.PluginManager.LoadPlugin("Compendium");
        end
    end
    self:SetWantsUpdates(true);
	
end
makeItSoNumberOne = Reloader();
