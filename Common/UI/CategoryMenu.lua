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


CategoryMenu = class( Turbine.UI.ContextMenu );
function CategoryMenu:Constructor(categories, index)
    Turbine.UI.ContextMenu.Constructor( self );

	self.ClickCategory = function(categories) 
		-- do nothing (to be overriden
	end

	-- build menu structure
	self:BuildMenu(categories, self:GetItems(), {}, index);
		    
end

function CategoryMenu:BuildMenu(treenode, menulist, categories, index) 
	
	-- sort each level of keys in menu
	local sortedKeys = {}
	for key, rec in pairs(treenode) do
		table.insert( sortedKeys, key );
	end
	table.sort(sortedKeys);
	
	-- loop through this level of keys
    for i, cat in pairs(sortedKeys) do
    	local rec = treenode[cat];
    	
    	-- build a menu row for them
    	local item = Turbine.UI.MenuItem(cat);
    	menulist:Add(item);
		
		-- build a copy of the categories up to this point 
		-- and add the current one
		local catcopy = {};
		for i,c in pairs(categories) do
			catcopy[i] = c;
		end
    	catcopy[#catcopy + 1] = cat;
    	
    	-- register even handler for this category listing
    	item.Click = function(sender,args)
			self.ClickCategory(catcopy);
		end
    	
    	-- if this category has child nodes, then process those
    	if rec ~= 0 then
    		--Turbine.Shell.WriteLine(cat);
    		self:BuildMenu(rec, item:GetItems(), catcopy, index);
    	else
    		if index ~= nil and index[cat] == nil and cat ~= 'All' then
    			Turbine.Shell.WriteLine('Remove ' .. cat);	
    		end
    	end
    	
    end
    
end


