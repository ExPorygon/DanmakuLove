PlayerData = {}
PlayerData.__index = PlayerData

setmetatable(PlayerData, {
    __index = Component,
	__call = function (cls, ...)
		local self = setmetatable({}, cls)
		self:_init(...)
		return self
	end,
})

function PlayerData:_init()
    Component._init(self,"player")

    -- self.type = "player"
	self.life = 2
	self.life_max = 8
	self.life_piece = 0
	self.life_piece_max = 3
	self.spell = 3
	self.spell_max = 8
	self.spell_piece = 0
	self.spell_piece_max = 3
	self.hitbox = 4
	self.power = 1
	self.power_max = 4
	self.grazeHitbox = 40
	self.slowSpeed = 1.9
	self.fastSpeed = 6
	self.shotDefinition = {}
	self.autoCollectLine = 160

    self.isBombing = false

	self.shotAllow = true
	self.bombAllow = true
	self.invincibility_init = 210
	self.invincibility = 0
	self.deathbomb_frames_init = 15
	self.deathbomb_frames = self.deathbomb_frames_init
	self.death_frames_init = 10
	self.death_frames = self.death_frames_init
	self.respawn_frames_init = 60
	self.respawn_frames = self.respawn_frames_init
	self.state = "normal"
end
