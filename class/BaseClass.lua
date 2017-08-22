ObjBase = {}
ObjBase.__index = ObjBase

setmetatable(ObjBase, {
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})


function ObjBase:_init()

	--Default Values
	self.isDelete = false
	self.type = "base"
	self.value = {}
end

function ObjBase:setValue(name,value)
	self.value[name] = value
end

function ObjBase:getValue(name)
	local value = self.value[name]
	if not value then error(name.."does not exist") end
	return value
end

function ObjBase:getValueD(name,default)
	local value = self.value[name]
	if not value then return default
	else return value end
end

function ObjBase:deleteValue(name)
	self.value[name] = nil
end

function ObjBase:getType()
	return self.type
end

function ObjBase:delete()
	self.isDelete = true
end

function ObjBase:isAlive()
	return not self.isDelete
end

function ObjBase:isDeleted()
	return self.isDelete
end
