--[[
	This is the main server script for the chat GUI. I'm not going to comment on it very much.
	It basically creates a trigger in Workspace and then renders it and loops it through each player.
	
	Warning! If you have firewall "ro-ware" in your game, it may break the chat. Or vice-versa. 	
	
	Need to do: Clean this fucking mess up. Ugly coding, I know lol.
--]]

-- This is an API (correct term?) to prompt moderation shit.
function promptModeration(player)

	-- Connect compatible moderation systems here for gold text
	
	--[[ EXAMPLE:
	if player.Name=="eprent" or player.Name=="Player" then
		return true
	end
	]]--

end


--To fix my ugly color3 statements
function rgb(r,g,b)
	return Color3.new(r/165,g/165,b/165)
end

sizeX=18

----------------------------------------------------------------------------------------------------------- ACTUAL SCRIPT

-- This creates the RemoteEvent in workspace so users can locally trigger it.
function bootRemote()
	script.Parent=game.ServerScriptService
	if not workspace:findFirstChild'ProChat' then
		local dire = Instance.new'Folder'
			dire.Name="ProChat"
			dire.Parent=workspace
		local reTrigger = Instance.new'RemoteEvent'
			reTrigger.Parent=dire
			reTrigger.Name="Chatted2"
	else
		return true
	end
end

--Loops through each player and moves them up + adds the newest message.
function deliver(instanc)
	local triggerdel=-117 -- This is to delete the ones after a certain point.
	for _,a in pairs(game.Players:GetChildren()) do
		if a.PlayerGui:findFirstChild'chatGui' then
			for _,b in pairs(a.PlayerGui.chatGui.Frame:GetChildren()) do
				if b:IsA'Frame' and b.Name=='message' then
					b:TweenPosition(UDim2.new(0,0,1,b.Position.Y.Offset-sizeX),"Out","Linear",.1,true)
					if b.Position.Y.Offset < triggerdel then -- Most likely going to scale this in the future. 
						b:Destroy()
					end
				end
			end
			local newMsg=instanc:Clone()
			newMsg.Parent=a.PlayerGui.chatGui.Frame
				newMsg.Position=UDim2.new(-1,0,1,sizeX-sizeX*2)--To make sure it animates correctly
				newMsg:TweenPosition(UDim2.new(0,0,1,sizeX-sizeX*2),"Out","Linear",.1,true)
		end
	end
end

-- Does the calculations to generate the messageholder.
function generateMessage(msg,player)
	--Create the frame to hold the name + message.
	local newFrame=Instance.new'Frame'
		newFrame.Size=UDim2.new(1,0,0,sizeX)
		newFrame.Transparency=1 -- Invisible!
		newFrame.Position=UDim2.new(0,0,.9,-sizeX)
		newFrame.Name="message" -- We'll use this 
		
	--Create the name
	local nameLabel=Instance.new'TextLabel'
	
	--Ths following "if" statement will detect if the player is using nicknames. Long "if" statement warning.
	if player:findFirstChild'.nickname' and player[".nickname"]:IsA'StringValue' and player[".nickname"].Value~=string.rep(" ",string.len(player[".nickname"].Value)) and string.len(player[".nickname"].Value)<21 then
			nameLabel.Text=" ~"..player[".nickname"].Value..": "
	else
		--If there is no nickname, just use regular name.
		nameLabel.Text=" "..player.Name..": " wait() --For some reason it was failing without a delay.
	end
	
		--Finish the generation
		nameLabel.Size=UDim2.new(0,string.len(nameLabel.Text)*7,1,0) -- Textbounds is a fucktard
		nameLabel.TextColor3=player.TeamColor.Color
		nameLabel.TextStrokeTransparency=.9
		nameLabel.Parent=newFrame
		nameLabel.TextScaled=true ----EHHHHHHHHHHHHHH Not sure if I should keep it scaled or not. Could cause issues.
		nameLabel.Font = Enum.Font.ArialBold
		nameLabel.BackgroundTransparency=1 -- invisible!
		nameLabel.BorderSizePixel=0
		
		--The textlabel to hold the message
	local textLabel=Instance.new'TextLabel'
		textLabel.Text=msg -- Don't judge.
		textLabel.Size=UDim2.new(0,string.len(textLabel.Text)*8.9,1,0) --Calculate the size. Because TextBounds is a PIECE OF SHIT.
		textLabel.TextColor3=BrickColor.White().Color 
		textLabel.TextStrokeTransparency=0.8 --Text shadow
		textLabel.BackgroundTransparency=1
		textLabel.BorderSizePixel=0
		textLabel.Parent=newFrame
		textLabel.Position = UDim2.new(0,string.len(nameLabel.Text)*7,0,0)
		textLabel.TextScaled=true
		textLabel.Font = Enum.Font.SourceSansBold
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		
	-- Set the size at the end.
	newFrame.Size=UDim2.new(0,nameLabel.Size.X.Offset + textLabel.Size.X.Offset,0,16)

	-- If the player is connected as a moderator it will make their text gold. I should really improve this lmao.
	if promptModeration(player) then
		textLabel.TextColor3=rgb(241, 196, 15)
	end
	
	--Shoot the function to send the message
	deliver(newFrame)
end

-- This will continue the function bootRemote until it is launched.
repeat bootRemote() wait() print'Booting Chat events...' until workspace:findFirstChild'ProChat'

-- Calculate OnServerEvent
workspace.ProChat.Chatted2.OnServerEvent:connect(function(player,msg)
	if player and msg~=nil then
		generateMessage(msg,player)
	end
end)

