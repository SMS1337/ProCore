--[[
	This is the main server script for the chat GUI. I'm not going to comment on it very much.
	It basically creates a trigger in Workspace and then renders it and loops it through each player.
	
	Warning! If you have firewall "ro-ware" in your game, it may break the chat. Or vice-versa. 	
	
	Need to do: Clean this fucking mess up. Ugly coding, I know lol.
--]]

--Enables the remoteevent server

function promptModeration(player)
	-- Connect compatible moderation systems here for gold text
	if player.Name=="eprent" or player.Name=="Player" then
		return true
	end
end


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

--To fix my ugly color3 statements
function rgb(r,g,b)
	return Color3.new(r/165,g/165,b/165)
end

--Loops through each player and moves them up + adds the newest message.
function deliver(instanc)
	for _,a in pairs(game.Players:GetChildren()) do
		if a.PlayerGui:findFirstChild'chatGui' then
			for _,b in pairs(a.PlayerGui.chatGui.Frame:GetChildren()) do
				if b:IsA'Frame' and b.Name=='message' then
					b:TweenPosition(UDim2.new(0,0,1,b.Position.Y.Offset - 17),"Out","Linear",.1,true)
					if b.Position.Y.Offset < -117 then -- Most likely going to scale this in the future. 
						b:Destroy()
					end
				end
			end
			local newMsg=instanc:Clone()
			newMsg.Parent=a.PlayerGui.chatGui.Frame
				newMsg.Position=UDim2.new(-1,0,1,-16)--To make sure it animates correctly
				newMsg:TweenPosition(UDim2.new(0,0,1,-16),"Out","Linear",.1,true)
		end
	end
end

function generateMessage(msg,player)
	--Create the frame to hold the name + message.
	local newFrame=Instance.new'Frame'
		newFrame.Size=UDim2.new(1,0,0,16)
		newFrame.Transparency=0.5
		newFrame.BackgroundColor3=player.TeamColor.Color
		newFrame.Position=UDim2.new(0,0,.9,-16)
		newFrame.Name="message"
		newFrame.BorderSizePixel=0
		
	--Create the name
	local nameLabel=Instance.new'TextLabel'
	
	--Ths following "if" statement will detect if the player is using nicknames
	if player:findFirstChild'.nickname' and player[".nickname"]:IsA'StringValue' and player[".nickname"].Value~=string.rep(" ",string.len(player[".nickname"].Value)) and string.len(player[".nickname"].Value)<21 then
			nameLabel.Text=" ~"..player[".nickname"].Value.." "
	else
		--If there is no nickname, just use regular name.
		nameLabel.Text=" "..player.Name.." " wait() --NAME
	end
	
		--Finish the generation
		nameLabel.Size=UDim2.new(0,string.len(nameLabel.Text)*7,1,0) -- Textbounds is a fucktard
		nameLabel.TextColor3=BrickColor.White().Color
		nameLabel.BackgroundColor3=BrickColor.Black().Color
		nameLabel.TextStrokeTransparency=0.7
		nameLabel.Parent=newFrame
		nameLabel.TextScaled=true
		nameLabel.Font = Enum.Font.SourceSansBold
--		nameLabel.TextXAlignment = Enum.TextXAlignment.Right
		nameLabel.BackgroundTransparency=0.6
		nameLabel.BorderSizePixel=0
		nameLabel.ZIndex=2
		
		--The textlabel to hold the message
	local textLabel=Instance.new'TextLabel'
		
		textLabel.Text=" "..msg.." "
		textLabel.Size=UDim2.new(0,string.len(textLabel.Text)*9,1,0)
		textLabel.TextColor3=BrickColor.White().Color 
		textLabel.TextStrokeTransparency=0.7
		textLabel.BackgroundTransparency=1
		textLabel.BackgroundColor3=player.TeamColor.Color
		textLabel.BorderSizePixel=0
		textLabel.Parent=newFrame
		textLabel.Position = UDim2.new(0,string.len(nameLabel.Text)*7,0,0)
		textLabel.TextScaled=true
		textLabel.Font = Enum.Font.SourceSansBold
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.ZIndex=2
		
	-- Set the size at the end.
	newFrame.Size=UDim2.new(
		0,
		nameLabel.Size.X.Offset + textLabel.Size.X.Offset,
		0,
		16
	)
		-- If the player is connected as a moderator it will make their text gold.
	if promptModeration(player) then
		textLabel.TextColor3=rgb(241, 196, 15)
	end
	
	--Shoot the function to send the message
	deliver(newFrame)
end

repeat bootRemote() wait() print'Booting Chat events...' until workspace:findFirstChild'ProChat'

--onserverevent
workspace.ProChat.Chatted2.OnServerEvent:connect(function(player,msg)
	if player and msg~=nil then
		generateMessage(msg,player)
	end
end)

