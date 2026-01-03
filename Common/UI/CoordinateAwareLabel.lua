
import "Turbine.UI";
import "Turbine.UI.Lotro";

-- Helper: map character index to byte index in UTF-8 string
function utf8_char_to_byte_index(str, char_index)
	local byte_index = 1
	local count = 0
	while byte_index <= #str do
		count = count + 1
		if count == char_index then
			return byte_index
		end
		local c = string.byte(str, byte_index)
		if c >= 0xF0 then
			byte_index = byte_index + 4
		elseif c >= 0xE0 then
			byte_index = byte_index + 3
		elseif c >= 0xC0 then
			byte_index = byte_index + 2
		else
			byte_index = byte_index + 1
		end
	end
	return nil -- out of range
end
function utf8_byte_to_char_index(str, byte_index)
	local char_index = 1
	local i = 1
	while i < byte_index do
		local c = string.byte(str, i)
		if c >= 0xF0 then
			i = i + 4
		elseif c >= 0xE0 then
			i = i + 3
		elseif c >= 0xC0 then
			i = i + 2
		else
			i = i + 1
		end
		char_index = char_index + 1
	end
	return char_index
end

CoordinateAwareLabel = class( Turbine.UI.Label );
function CoordinateAwareLabel:Constructor()
    Turbine.UI.Label.Constructor( self );
	self.CoordClicked = nil;
	self.MouseClick = function(s, args)
		local text = self:GetText();
		if text ~= nil then
			local charPos = self:GetSelectionStart();
			local bytePos = utf8_char_to_byte_index(text, charPos);
			local found = false;
			local pattern = "(%d+%.?%d*)([NSns])[, .]+(%d+%.?%d*)([EWOewo])";
			local searchStart = 1;
			while true do
				local i, j, y, ns, x, ew = string.find(text, pattern, searchStart);
				if i == nil then break end
				-- Check if bytePos is within this match
				if bytePos and bytePos >= i and bytePos <= j then
					self:SetSelection(nil, nil);
					local start_char = utf8_byte_to_char_index(text, i)
					local end_char = utf8_byte_to_char_index(text, j)
					self:SetSelection(start_char, end_char - start_char + 1)
					if self.CoordClicked ~= nil then
						self:CoordClicked(y, ns, x, ew);
					end
					found = true;
					break;
				end
				searchStart = j + 1;
			end
			if not found then self:SetSelection(nil, nil); end
		end
	end
end

function CoordinateAwareLabel:destroy()
	self.MouseClick = nil;
	self.CoordClicked = nil;
end