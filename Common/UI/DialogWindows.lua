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
import "Compendium.Common.UI.CompendiumWindow";
import "Compendium.Common.Resources.Bundle";
local rsrc = {};

--[[
	Confirmation Dialog
]]
ConfirmWindow = class( Compendium.Common.UI.CompendiumWindow );
function ConfirmWindow:Constructor()
    Compendium.Common.UI.CompendiumWindow.Constructor( self );
	rsrc = Compendium.Common.Resources.Bundle:GetResources();
	
	self:SetSize(300,120);
	self:SetText('Confirm');
	
    local noticeMsg = Turbine.UI.Label()
    noticeMsg:SetSize(250, 40);
    noticeMsg:SetParent(self);
 	noticeMsg:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
    noticeMsg:SetFont(self.fontFace);
    noticeMsg:SetForeColor(self.fontColor);
    noticeMsg:SetOutlineColor(Turbine.UI.Color(0,0,0));
    noticeMsg:SetFontStyle(Turbine.UI.FontStyle.Outline);   
	noticeMsg:SetText('');
	noticeMsg:SetPosition((self:GetWidth() / 2) - (noticeMsg:GetWidth() / 2), 35);
	self.noticeMsg = noticeMsg;
	local ok = Turbine.UI.Lotro.Button();
	ok:SetSize(80,20);
 	ok:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	ok:SetText(rsrc["ok"]);
	ok:SetParent(self);
	ok:SetPosition((self:GetWidth() / 3) - (ok:GetWidth() / 2), self:GetHeight() - 40);
	self.ok = ok;
	
	local cancel = Turbine.UI.Lotro.Button();
	cancel:SetSize(80,20);
 	cancel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	cancel:SetText(rsrc["cancel"]);
	cancel:SetParent(self);
	cancel:SetPosition(((self:GetWidth() / 3) * 2) - (cancel:GetWidth() / 2), self:GetHeight() - 40);
	self.cancel = cancel;
	self:SetVisible(false);

end

function ConfirmWindow:Show(title, message, okCallback, cancelCallback)
	
	rsrc = Compendium.Common.Resources.Bundle:GetResources();
	self.ok:SetText(rsrc["ok"]);
	self.cancel:SetText(rsrc["cancel"]);
	
	self.noticeMsg:SetText(message);
	self:SetText(title);
	self.Closed = function()
		pcall(cancelCallback, self);
	end
	self.ok.Click = function()
		pcall(okCallback, self);
		self:SetVisible(false);
	end
	self.cancel.Click = function()
		pcall(cancelCallback, self);
		self:SetVisible(false);
	end
	self:SetVisible(true);
	self:Activate();
end

Dialog = class();
Dialog.Confirm = ConfirmWindow();