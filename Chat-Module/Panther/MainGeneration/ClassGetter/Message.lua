--module, parented to classgetter
local Class = {}
Class.__index = Class

setmetatable(Class, {
  	__call = function (cls, ...)
	return cls.new(...)
  end,
})

Class.new = function(classes, frame, deleteafter)
	local self = setmetatable({}, Class)
	self.classes = classes
	self.DistanceFromNewest = 0
	self.DeleteAfter = deleteafter
	self.PlayerReplications = {}
	local sizeX = 20
	local plrs = game.Players:GetChildren()
	for i=1, #plrs do
		if plrs[i]:FindFirstChild("PlayerGui") then
			if plrs[i]:FindFirstChild("PlayerGui"):FindFirstChild("chatGui") then
				if plrs[i]:FindFirstChild("PlayerGui"):FindFirstChild("chatGui"):FindFirstChild("Frame") then
					local msg = frame:Clone()
					msg.Parent = plrs[i]:FindFirstChild("PlayerGui"):FindFirstChild("chatGui"):FindFirstChild("Frame")
					msg.Position=UDim2.new(-1,0,1,sizeX-sizeX*2)
					--msg:TweenPosition(UDim2.new(0,0,1,sizeX-sizeX*2),"Out","Linear",0.05,true)
					self.PlayerReplications[plrs[i].Name] = msg
				end
			end
		end
	end
	
	return self
end

Class.UpdatePos = function(self)
	local sizeX = 20
	for k,v in pairs(self.PlayerReplications) do
		v:TweenPosition(UDim2.new(0,0,1,(sizeX-sizeX*2)-(sizeX*self.DistanceFromNewest)),"Out","Linear",0.05,true)
		if v.Position.Y.Offset < self.DeleteAfter then
			v:Destroy()
			self.PlayerReplications[k] = nil
		end
	end
end

Class.CheckForDeletion = function(self)
	local shoulddelete = true
	for k,v in pairs(self.PlayerReplications) do
		shoulddelete = false
	end
	return shoulddelete
end

return Class
