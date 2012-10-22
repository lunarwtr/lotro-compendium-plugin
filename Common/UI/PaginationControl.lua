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

import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Compendium.Common.Utils";
import "Compendium.Common.UI";
import "Compendium.Common.Resources.Bundle";
local rsrc = {};

PaginationControl = class( Turbine.UI.Label );
function PaginationControl:Constructor( cursor )
    Turbine.UI.Label.Constructor( self );
	rsrc = Compendium.Common.Resources.Bundle:GetResources();

    local fontColor=Turbine.UI.Color(1,.9,.5);
    local fontFace=Turbine.UI.Lotro.Font.Verdana14;

    self:SetSize(100,20);
   	self:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
    self:SetFont(fontFace);
    self:SetForeColor(fontColor);
    self:SetOutlineColor(Turbine.UI.Color(0,0,0));
    self:SetFontStyle(Turbine.UI.FontStyle.Outline);

   	local prev = function(sender,args)
   		self:PrevPage();  	
   	end
	local next = function(sender,args)
   		self:NextPage();
   	end
    
    local prevBtn = Turbine.UI.Lotro.Button();
    prevBtn:SetParent(self);
    prevBtn:SetText(rsrc["prev"]);
    prevBtn:SetVisible(false);
   	prevBtn:SetSize(55,20);
   	prevBtn:SetPosition(0,0);
   	prevBtn.Click = prev;
 	local prevIcon = Turbine.UI.Control();
    prevIcon:SetParent( prevBtn );
    prevIcon:SetBackground(0x41007e0e);
    prevIcon:SetBlendMode(Turbine.UI.BlendMode.Overlay);
    prevIcon:SetPosition( 3, 3 );
    prevIcon:SetSize( 16, 16 );
   	prevIcon.MouseClick = prev;
   	
    local nextBtn = Turbine.UI.Lotro.Button();
    nextBtn:SetParent(self);
    nextBtn:SetText(rsrc["next"]);
    nextBtn:SetVisible(false);
   	nextBtn:SetSize(55,20);
   	nextBtn:SetPosition(self:GetWidth() - nextBtn:GetWidth(),0);   
   	nextBtn:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
   	nextBtn.Click = next;
 	local nextIcon = Turbine.UI.Control();
    nextIcon:SetParent( nextBtn );
    nextIcon:SetBackground(0x41007e11);
    nextIcon:SetBlendMode(Turbine.UI.BlendMode.Overlay);
    nextIcon:SetPosition(nextBtn:GetWidth() - 20, 3 );
    nextIcon:SetSize( 16, 16 );   	
   	nextIcon.MouseClick = next;
   	
   	self.SizeChanged = function (s,a) 
   		local width = self:GetWidth();
		nextBtn:SetLeft(width - nextBtn:GetWidth());
   	end
   	
   	self.prevBtn = prevBtn;
   	self.nextBtn = nextBtn;
   	self.paginationText = rsrc["results"];
   	self:UpdatePagination();
   	
end

function PaginationControl:SetWidth(w)
	Turbine.UI.Label.SetWidth(self, w);
	if self.SizeChanged ~= nil then self:SizeChanged() end;
end

function PaginationControl:NextPage()
	if self.cursor ~= nil then
		local records = self.cursor:NextPage();
		if self.PageChanged ~= nil then
			self.PageChanged(self, 'next', records);
		end 
		self:UpdatePagination();
	end
end

function PaginationControl:PrevPage()
	if self.cursor ~= nil then
		local records = self.cursor:PrevPage();
		if self.PageChanged ~= nil then
			self.PageChanged(self, 'prev', records);
		end 
		self:UpdatePagination();
	end	
end

function PaginationControl:SetCursor( cursor )
	self.cursor = cursor;
	self:UpdatePagination();
end

function PaginationControl:SetPaginationText( value )
	self.paginationText = value;
	self:UpdatePagination();
end


function PaginationControl:UpdatePagination()
	self.prevBtn:SetVisible(false);
	self.nextBtn:SetVisible(false);
	self:SetText('');
	if self.cursor ~= nil then
		self:SetText(self.cursor:tostring() .. ' ' .. self.paginationText);
		if self.cursor:HasPrev() then self.prevBtn:SetVisible(true) end;
		if self.cursor:HasNext() then self.nextBtn:SetVisible(true) end;
	end
end
