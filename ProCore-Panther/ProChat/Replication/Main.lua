--[[
	Use to replicate the GUI to new players.
--]]

-- Scripts --
GUI=script.chatGui
function insert(player)
	if not player.PlayerGui:findFirstChild(GUI.Name) then
		GUI:Clone().Parent=player.PlayerGui
	end
end

game.Players.PlayerAdded:connect(function(p)
	p.CharacterAdded:connect(function()
		insert(p)
	end)
end)
