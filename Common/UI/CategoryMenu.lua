

import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Compendium.Common.Resources";
local rsrc = {};

function levelCompare(a, b)
	local af, at = a:match("^(%d+)-(%d+)$")
	local bf, bt = b:match("^(%d+)-(%d+)$")
	if (af ~= nil and bf ~= nil) then
		return tonumber(af) < tonumber(bf)
	else
		return a < b
	end
end

CategoryMenu = class( Turbine.UI.ContextMenu );
function CategoryMenu:Constructor(categories, index)
    Turbine.UI.ContextMenu.Constructor( self );
	rsrc = Compendium.Common.Resources.Bundle:GetResources();

	self.ClickCategory = function(categories)
		-- do nothing (to be overriden
	end

	-- build menu structure
	self:BuildMenu("root", categories, self:GetItems(), {}, index);

end

function CategoryMenu:BuildMenu(name, treenode, menulist, categories, index)

	-- sort each level of keys in menu
	local sortedKeys = {}
	for key, rec in pairs(treenode) do
		table.insert( sortedKeys, key );
	end
	if name == "Level Ranges" then
		table.sort(sortedKeys, levelCompare);
	else
		table.sort(sortedKeys);
	end

	-- loop through this level of keys
    for i, cat in pairs(sortedKeys) do
    	local rec = treenode[cat];

    	-- build a menu row for them
    	local text = rsrc["FILTERS"][cat] or cat;
    	local item = Turbine.UI.MenuItem(text);
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
			self.ClickCategory(catcopy, args);
		end

    	-- if this category has child nodes, then process those
    	if rec ~= 0 then
    		--Turbine.Shell.WriteLine(cat);
    		self:BuildMenu(cat, rec, item:GetItems(), catcopy, index);
    	else
    		if index ~= nil and index[cat] == nil and cat ~= 'All' then
    			Turbine.Shell.WriteLine('Remove ' .. cat);
    		end
    	end

    end

end


