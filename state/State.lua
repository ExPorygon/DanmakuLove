State = {}
State.__index = State

setmetatable(State, {
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function State:_init(id)
	self.id = id
	self.entities = {}
	self.systems = {}
end

function State:register(system)
	table.insert(self.systems, system)
end

function State:update(dt)
	for i=1, #self.systems do
        local system = self.systems[i]
        for j=1, #self.entities do
            local entity = self.entities[j]
            if system:match(entity) then
                system:update(dt,entity)
            end
        end
    end
end

function State:draw()
	for i=1, #self.systems do
        local system = self.systems[i]
        for j=1, #self.entities do
            local entity = self.entities[j]
            if system:match(entity) then
                system:draw(entity)
            end
        end
    end
end
