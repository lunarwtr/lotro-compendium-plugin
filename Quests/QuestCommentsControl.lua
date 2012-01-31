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
import "Turbine.UI";
import "Turbine.UI.Lotro";

import "Compendium.Common.Utils";
import "Compendium.Common.UI";
import "Compendium.Common.Resources.Bundle";
local rsrc = {};

QuestCommentsControl= class( Compendium.Common.UI.CompendiumControl );
function QuestCommentsControl:Constructor()
    Compendium.Common.UI.CompendiumControl.Constructor( self );
	rsrc = Compendium.Common.Resources.Bundle:GetResources();
	
    local comments=Turbine.UI.Label();
    comments:SetParent(self);
    comments:SetPosition(0,0);
    comments:SetFont(self.fontFaceSmall);
    comments:SetForeColor(self.fontColor);
    comments:SetMultiline(true);
    comments:SetSelectable(true);
    comments.VScrollBar=Turbine.UI.Lotro.ScrollBar();
    comments.VScrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
    comments.VScrollBar:SetParent(comments);
    comments.VScrollBar:SetBackColor(self.backColor);
    comments.VScrollBar:SetPosition(comments:GetWidth()-12,0)
    comments.VScrollBar:SetWidth(12);
    comments.VScrollBar:SetHeight(comments:GetHeight()-2);
    comments:SetVerticalScrollBar(comments.VScrollBar); 
	self.comments = comments;
	
	comments.MouseClick = function(s,args)
		local text = comments:GetText();
		if text ~= nil then
			local s = math.max(comments:GetSelectionStart() - 13,1);
			local e = math.min(string.len(text),s + 26);
			local piece = string.sub(text,s,e);
			local i, j, whole, y, ns, x, ew = string.find(piece, "((%d+%.%d+)([NSns])[, .]+(%d+%.%d+)([EWOewo]))");
			if i ~= nil then
				comments:SetSelection(nil,nil);
				comments:SetSelection(s + (i - 1), string.len(whole));
				self:CoordClicked(y, ns, x, ew);
			end
		end
	end

	
    local pagination = Compendium.Common.UI.PaginationControl();
    pagination:SetParent(self);
    pagination:SetPosition(3,0);
    pagination:SetPaginationText(rsrc['comments']);
	pagination.PageChanged = function(sender,direction,records)
		self.comments:SetText(records[1].val);
	    if records[1].modifiable == true then
	    	self.del:SetEnabled(true);
	    	self.del:SetVisible(true);
	    else
	    	self.del:SetEnabled(false);
	    	self.del:SetVisible(false);
	    end		
   	end
    self.pagination = pagination;	
	
    local centry =Turbine.UI.Lotro.TextBox();
    centry:SetParent(self);
    centry:SetPosition(3,0);
    centry:SetFont(Turbine.UI.Lotro.Font.Verdana12);
    centry:SetForeColor(self.fontColor);
    centry:SetBackColor(self.backColor)
    centry:SetSelectable(true);
	self.centry = centry;

	-- build add coordinate button	
	local coord = Turbine.UI.Control();
    coord:SetVisible(false);
    coord:SetParent(self);
    coord:SetSize( 30, 30 );
    coord:SetPosition(centry:GetWidth() + 8, centry:GetTop() + 2);

	local shortcut = Turbine.UI.Lotro.Shortcut( Turbine.UI.Lotro.ShortcutType.Alias, '/comp addcoord ['..rsrc['loc']..'|'..rsrc['target']..']' );	    	
	local quick = Turbine.UI.Lotro.Quickslot();
	quick:SetParent(coord);
    quick:SetSize( 30, 30 );
    quick:SetPosition(0,0);
    quick:SetEnabled(true);
    quick:SetShortcut( shortcut );
    quick:SetVisible(true);
    quick:SetAllowDrop(false);
	quick.DragDrop=function()
		quick:SetShortcut(shortcut);
	end
	
	local coordicon = Turbine.UI.Control();
	coordicon:SetBackground( "Compendium/Common/Resources/images/add-coords.tga" );
	coordicon:SetBlendMode(Turbine.UI.BlendMode.AlphaBlend);    
	coordicon:SetParent(coord);    
    coordicon:SetSize( 30, 30 );
    coordicon:SetPosition(0,0);	
    coordicon:SetZOrder(quick:GetZOrder() + 1);
    coordicon:SetMouseVisible(false);
	self.coord = coord;  	
	    
    -- add a search add button
    local add = Turbine.UI.Lotro.Button();
    add:SetParent( self );
    add:SetText( rsrc['add'] );
    add:SetSize( 50, 30 );
    add:SetPosition(coord:GetLeft() + coord:GetWidth() + 2, centry:GetTop() + 5 );
    add.Click = function( sender, args )
		if self.CommentAdded ~= nil then
			self.CommentAdded(self,centry:GetText());
		end
		centry:SetText('');
    end
	self.add = add;
	
    local del = Turbine.UI.Control();
    del:SetParent( comments );
	--del:SetBlendMode(Turbine.UI.BlendMode.Screen);
	del:SetBackground( "Compendium/Common/Resources/images/delete.tga" );    
    del:SetVisible(false);
    del:SetEnabled(false);
    del:SetSize( 16, 16 );
    del:SetPosition(comments:GetWidth()-28, 4);
    del.MouseClick = function( sender, args )
    	if self.cursor ~= nil then
	    	local curpagenum = self.cursor:CurPageNum();
	    	local oldpage = self:RemoveCommentRecord(curpagenum);
			if self.CommentDeleted ~= nil then
				self.CommentDeleted(self,oldpage);
			end
		end
    end
	self.del = del;
	
    self.SizeChanged = function(s,a) 
    	local width = s:GetWidth();
		local height = s:GetHeight();
		local ch = (height - 20) * .6;
		comments:SetSize(width,ch);
	    comments.VScrollBar:SetPosition(width - 12,0);
	    comments.VScrollBar:SetHeight(ch - 2);

	    pagination:SetPosition(7, ch);
		pagination:SetWidth(width - 12);
		
		local ceh = height - ch - 23;
	    centry:SetTop(ch + pagination:GetHeight() + 2);
		centry:SetSize(width- 90,ceh);
	    coord:SetPosition(centry:GetWidth() + 8, centry:GetTop()+2);
	    add:SetPosition(coord:GetLeft() + coord:GetWidth() + 2, centry:GetTop() + 5 );
	    --coordbtn:SetPosition(add:GetLeft(), add:GetTop() + add:GetHeight());
 		del:SetPosition(width-28, 4);	    
    end
    
    self.records = {};
    
end

function QuestCommentsControl:RemoveCommentRecord(page)
	local recs = {};
	local newpage = 0;
	local oldpage = nil;
	for i, rec in pairs(self.records) do
		if i == page and rec.modifiable then
			-- do nothing
			oldpage = rec;
		else
			table.insert(recs,rec);
			newpage = math.max(i - 1, 1);
		end
	end
	
	-- no page was removed
	if oldpage == nil then return nil end;
	
	self.records = recs;
	local c = Compendium.Common.Utils.DataCursor(self.records, 1);
	self:SetCursor(c, newpage);
	return oldpage;
	
end

function QuestCommentsControl:AddCommentRecord(record, setpage)
	table.insert(self.records, record);
	local c = Compendium.Common.Utils.DataCursor(self.records, 1);
	if setpage == true then
		self:SetCursor(c, #self.records);
	else
		self:SetCursor(c, 1);
	end
end

function QuestCommentsControl:AddCommentRecords(records)
	for i, rec in pairs(records) do
		table.insert(self.records, rec);	
	end
	local c = Compendium.Common.Utils.DataCursor(self.records, 1);
	self:SetCursor(c, 1);
end

function QuestCommentsControl:SetCursor(c, page) 

	self.del:SetEnabled(false);
	self.del:SetVisible(false);
	
	if page == nil or page < 1 then page = 1 end;
	c:SetPage(page);
	local records = c:CurPage();
	if #records > 0 then
	    self.comments:SetVerticalScrollBar(nil);    
		self.comments:SetText(records[1].val);
	    self.comments:SetVerticalScrollBar(self.comments.VScrollBar);
	    if records[1].modifiable == true then
	    	self.del:SetEnabled(true);
	    	self.del:SetVisible(true);
	    end
	else
    	self.comments:SetText('');
	end
	self.pagination:SetCursor(c);
	self.add:SetEnabled(true);
    self.coord:SetVisible(true);
	self.cursor = c;
	
end

function QuestCommentsControl:ClearComments()
	self.records = {};
	self.pagination:SetCursor(nil);
	self.cursor = nil;
	self.comments:SetText('');
	self.add:SetEnabled(false);
	self.del:SetEnabled(false);
	self.del:SetVisible(false);	
    self.coord:SetVisible(false);
end

function QuestCommentsControl:AddToComment( comment )
	local text = self.centry:GetText();
	if text == nil then
		text = comment
	else
		text = text .. ' ' .. comment;
	end
	self.centry:SetText(text);
end

function QuestCommentsControl:CoordClicked(y, ns, x, ew)
	-- override 
end