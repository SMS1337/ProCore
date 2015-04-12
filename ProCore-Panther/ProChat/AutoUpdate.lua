local version = script.Parent:WaitForChild("Version").Value
local modelid = 234218451

local model = game:GetService("InsertService"):LoadAsset(modelid)
model = model:GetChildren()[1]
if model:WaitForChild("Version").Value > version then
	model:WaitForChild("Settings"):Destroy()
	local realsettings = script.Parent:WaitForChild("Settings"):Clone()
	realsettings.Parent = model
	print("------------------------------------PROCHAT AUTO UPDATER------------------------------------")
	game:GetService('TestService'):Warn(false, "ProChat just automagically updated to version " .. model:WaitForChild("Version").Value..", courtesy of the ProChat contributers")
	game:GetService('TestService'):Warn(false, "Don't worry, all your settings should carry over, you should consider manually updating sometime though")	
	game:GetService('TestService'):Warn(false, "If an update added new settings, they will be set to their default values")	
	print("------------------------------------PROCHAT AUTO UPDATER------------------------------------")	
	model.Parent = script.Parent.Parent
	script.Parent:Destroy()
else
	canrun = Instance.new("BoolValue")
	canrun.Name = "StartExec"
	canrun.Parent = script.Parent
end