
import "Compendium.Common.Utils";


SettingsClass = class();

function SettingsClass:Constructor( settings )
	self.settings = settings
end

function SettingsClass:SetSettings(settings)
	self.settings = settings;
end

function SettingsClass:GetSettings()
	return self.settings;
end

function SettingsClass:GetSetting(key)
	return self.settings[key];
end

Settings = SettingsClass();