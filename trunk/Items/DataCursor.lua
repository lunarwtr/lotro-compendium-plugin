
import "Compendium.Common.Class";

DataCursor = class();

function DataCursor:Constructor(data, pagesize)
	self.data = data;
	self.pagesize = pagesize;
	self.total = #data;
	self.offset = 1;
	return cur;
end

function DataCursor:NextPage()
	if self.offset > self.total then
		self.offset = self.total;
	end
	self.offset = self.offset + self.pagesize;
	return self:CurPage();
end

function DataCursor:PrevPage()
	self.offset = self.offset - self.pagesize;
	if self.offset < 1 then self.offset = 1 end;
	return self:CurPage();
end

function DataCursor:CurPage() 
	local pd = {};
	local ndx = self.offset;
	local count = 0;
	while count < self.pagesize and ndx <= self.total do
		table.insert(pd, self.data[ndx]);
		ndx = ndx + 1;
		count = count + 1;
	end
	return pd;
end

function DataCursor:HasNext()
	return self.offset < ( self.total - self.pagesize);
end

function DataCursor:HasPrev()
	return self.offset > self.pagesize;
end

function DataCursor:PageCount() 
	return math.ceil(self.total / self.pagesize); 
end

function DataCursor:CurPageNum()
	if self.total == 0 then return 0 end;
	return math.ceil(self.offset / self.pagesize);
end

function DataCursor:tostring()
	if self.total > 1 then
		return "Page " .. self:CurPageNum() .. "/" .. self:PageCount() .. " | " .. self.total .. " Results";
	else 
		return "0 Results";
	end
end