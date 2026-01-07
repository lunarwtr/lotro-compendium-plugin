import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Compendium.Common.UI";

-- CompendiumListHeader: A reusable header row for quest lists with sorting and select-all checkbox
CompendiumListHeader = class( Compendium.Common.UI.CompendiumControl );

function CompendiumListHeader:Constructor(args)
    Compendium.Common.UI.CompendiumControl.Constructor(self);
    args = args or {};
    self.nameLabelText = args.nameLabelText or "Quest Name";
    self.levelLabelText = args.levelLabelText or "Quest Level";
    self.sortColumn = "name"; -- "name" or "level"
    self.sortDirection = "asc"; -- "asc" or "desc"
    self.SortChanged = nil; -- function(sender, column, direction)
    self.CheckChanged = nil; -- function(sender, checked)

    self:SetSize(200, 19);
    self:SetBackColor(self.colorDarkGrey);

    -- Quest Name Label
    self.nameLabel = Compendium.Common.UI.AutoSizingLabel();
    self.nameLabel:SetMultiline(false);
    self.nameLabel:SetParent(self);
    self.nameLabel:SetPosition(2, 1);
    self.nameLabel:SetSelectable(false);
    self.nameLabel:SetMouseVisible(true);
    self.nameLabel:SetBackColor(self.colorDarkGrey);
    self.nameLabel:SetFont(self.fontFace);
    self.nameLabel:SetForeColor(self.fontColor);
    self.nameLabel:SetOutlineColor(Turbine.UI.Color(0,0,0));
    self.nameLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);
    self.nameLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.nameLabel:SetText(self.nameLabelText);
    self.nameLabel:SetSize('auto', 17);

    -- Sort Indicator for Name
    self.sortIndicatorName = Turbine.UI.Control();
    self.sortIndicatorName:SetParent(self);
    self.sortIndicatorName:SetSize(16, 16);
    self.sortIndicatorName:SetPosition(self.nameLabel:GetWidth() + 2, 1);
    self.sortIndicatorName:SetBackground(0x41007e19); -- Down Arrow by default
    self.sortIndicatorName:SetBlendMode(Turbine.UI.BlendMode.Overlay);

    -- Quest Level Label
    self.levelLabel = Compendium.Common.UI.AutoSizingLabel();
    self.levelLabel:SetMultiline(false);
    self.levelLabel:SetParent(self);
    self.levelLabel:SetPosition(self.nameLabel:GetWidth() + self.sortIndicatorName:GetWidth() + 4, 1);
    self.levelLabel:SetSelectable(false);
    self.levelLabel:SetMouseVisible(true);
    self.levelLabel:SetBackColor(self.colorDarkGrey);
    self.levelLabel:SetFont(self.fontFace);
    self.levelLabel:SetForeColor(self.fontColor);
    self.levelLabel:SetOutlineColor(Turbine.UI.Color(0,0,0));
    self.levelLabel:SetFontStyle(Turbine.UI.FontStyle.Outline);
    self.levelLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    self.levelLabel:SetText('/ ' .. self.levelLabelText);
    self.levelLabel:SetSize('auto', 17);

    -- Sort Indicator for Level
    self.sortIndicatorLevel = Turbine.UI.Control();
    self.sortIndicatorLevel:SetParent(self);
    self.sortIndicatorLevel:SetSize(16, 16);
    self.sortIndicatorLevel:SetPosition(self.levelLabel:GetLeft() + self.levelLabel:GetWidth() + 2, 1);
    self.sortIndicatorLevel:SetBackground(nil);
    self.sortIndicatorLevel:SetBlendMode(Turbine.UI.BlendMode.Overlay);

    -- Select All Checkbox
    self.selectAllCB = Turbine.UI.Lotro.CheckBox();
    self.selectAllCB:SetParent(self);
    self.selectAllCB:SetPosition(self:GetWidth() - 16, 1);
    self.selectAllCB:SetSize(25, 18);
    self.selectAllCB:SetChecked(false);
    self.selectAllCB:SetText('');
    self.suppressCheckChanged = false;

    -- Sizing logic
    local function updatePositions()
        self.sortIndicatorName:SetPosition(self.nameLabel:GetWidth() + 2, 1);
        self.levelLabel:SetLeft(self.sortIndicatorName:GetLeft() + self.sortIndicatorName:GetWidth() + 2);
        self.sortIndicatorLevel:SetPosition(self.levelLabel:GetLeft() + self.levelLabel:GetWidth() + 2, 1);
        self.selectAllCB:SetLeft(self:GetWidth() - 16);
    end
    self.nameLabel.SizeChanged = function() updatePositions(); end
    self.levelLabel.SizeChanged = function() updatePositions(); end
    self.SizeChanged = function() updatePositions(); end

    -- Sort indicator update
    function self:UpdateSortIndicators()
        if self.sortColumn == "name" then
            self.sortIndicatorName:SetBackground(self.sortDirection == "desc" and 0x41007e19 or 0x4101db45);
            self.sortIndicatorLevel:SetBackground(nil);
        else
            self.sortIndicatorLevel:SetBackground(self.sortDirection == "desc" and 0x41007e19 or 0x4101db45);
            self.sortIndicatorName:SetBackground(nil);
        end
    end
    self:UpdateSortIndicators();

    -- Sorting events
    self.nameLabel.MouseClick = function()
        if self.sortColumn ~= "name" then
            self.sortColumn = "name";
        else
            self.sortDirection = (self.sortDirection == "desc") and "asc" or "desc";
        end
        self:UpdateSortIndicators();
        if self.SortChanged ~= nil then self.SortChanged(self, self.sortColumn, self.sortDirection); end
    end
    self.levelLabel.MouseClick = function()
        if self.sortColumn ~= "level" then
            self.sortColumn = "level";
        else
            self.sortDirection = (self.sortDirection == "desc") and "asc" or "desc";
        end
        self:UpdateSortIndicators();
        if self.SortChanged ~= nil then self.SortChanged(self, self.sortColumn, self.sortDirection); end
    end

    -- Checkbox event
    self.selectAllCB.CheckedChanged = function(s, a)
        if self.suppressCheckChanged then return end;
        if self.CheckChanged ~= nil then self.CheckChanged(self, s:IsChecked()); end
    end

    -- SetWidth override
    self.SetWidth = function(s, w)
        Turbine.UI.Control.SetWidth(s, w);
        updatePositions();
    end
end

function CompendiumListHeader:destroy()
    self.CheckChanged = nil;
    self.SortChanged = nil;
	Compendium.Common.UI.CompendiumControl.destroy(self);
end


function CompendiumListHeader:SetSelectAllChecked(checked, suppressCallback)
    if suppressCallback then
        self.suppressCheckChanged = true;
    end
    self.selectAllCB:SetChecked(checked);
    if suppressCallback then
        self.suppressCheckChanged = false;
    end
end

-- Global factory for sorting comparator
CreateSortComparator = function (sortColumn, sortDirection, playerLevel)
    return function(a, b)
        local aval, bval
        if sortColumn == 'level' then
            aval = a['level']
            bval = b['level']
            if aval == 'Scaling' then
                local minlevel = tonumber(a['minlevel'])
                if minlevel ~= nil then
                    if playerLevel < minlevel then
                        aval = minlevel
                    else
                        aval = playerLevel
                    end
                else
                    aval = playerLevel
                end
            else
                aval = tonumber(aval)
            end
            if bval == 'Scaling' then
                local minlevel = tonumber(b['minlevel'])
                if minlevel ~= nil then
                    if playerLevel < minlevel then
                        bval = minlevel
                    else
                        bval = playerLevel
                    end
                else
                    bval = playerLevel
                end
            else
                bval = tonumber(bval)
            end
        else
            aval = a[sortColumn]
            bval = b[sortColumn]
        end
        if aval == nil then aval = '' end
        if bval == nil then bval = '' end

        if sortColumn == 'level' and aval == bval then
            -- Secondary sort by name (always ascending for tie-breaker)
            local aname = a["name"] or ""
            local bname = b["name"] or ""
            return aname < bname
        end
        if sortDirection == 'asc' then
            return aval < bval
        else
            return aval > bval
        end
    end
end