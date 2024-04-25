local Effects_Manager = {}
Effects_Manager.__index = Effects_Manager

local Debris = game:GetService("Debris")

function Effects_Manager.Create()
	local self = setmetatable({
		Effects = {}, 
	}, Effects_Manager)
	return self
end

function Effects_Manager:AddEffect(Name : string, Settings : table)
	self.Effects[Name] = {
		Limit = Settings.Limit,   
		LifeTime = Settings.LifeTime, 
		Action = Settings.Action or function() end, 
		Instances = {} 
	}
end

function Effects_Manager:Emit(Name : string, Properties : table)
	if self.Effects[Name] then
		local Effect = self.Effects[Name]
        
		if #Effect.Instances >= Effect.Limit then
			local oldestInstance = table.remove(Effect.Instances, 1) 
			oldestInstance:Destroy() 
		end

		local EffectEmitted = Effect.Action(Properties) 
        assert(EffectEmitted, "Action has to have a return.")
		Effect.Instances[#Effect.Instances + 1]= EffectEmitted
		Debris:AddItem(EffectEmitted, Effect.LifeTime)
	end
end

return Effects_Manager


--[[ rushed and toolboxed example

local NewManager = Effects_Manager.Create()

NewManager:AddEffect("RockHit", {
	Action = function(Properties)
		local A = workspace["FREE VFX"]:Clone()
		A.Parent = workspace
		
		A.Position = Properties.Position
        return A
	end,
	Limit = 5,
	LifeTime = 6
})


game:GetService("UserInputService").InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		NewManager:Emit("RockHit", {
			Position = game.Players.LocalPlayer:GetMouse().Hit.Position
		})
	end
end) 
]]
