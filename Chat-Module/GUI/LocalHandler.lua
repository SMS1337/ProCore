-- I WARN YOU. THIS SCRIPT IS GROSS.

--Generic variables
repeat wait() print'Waiting for player to load' until game.Players.LocalPlayer
local player = game.Players.LocalPlayer
	local mouse = player:GetMouse()

wait(2) -- For some reason it is running to fast lmao. 

--more variables
SendBtn=script.Parent.MobileSendBtn
typer = script.Parent.input
maxnumber=150
stockphrase = 'Press "/" to type.'
UID = game:GetService("UserInputService")

--Remove CoreGUI. 
local StarterGui = game:GetService('StarterGui')
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

--Temporary fix for mobile users
if UID.TouchEnabled==true then
	script.Parent.Position=UDim2.new(0.01,0,0.55,0)
	stockphrase='Tap to start typing.'
	SendBtn.Visible=true
end
	
--Captures focus	
function animate()
	typer.Text = ""
	typer:CaptureFocus()
	for i = 0.5,0,-.1 do
		game:GetService("RunService").RenderStepped:wait()
		typer.TextTransparency=i
		script.Parent.char.TextTransparency=i
	end
end

function detectMention(message)	
	repeat wait() until message:findFirstChild'msg'
	for w in string.gmatch(message.msg.Text, "%a+") do
	    if string.len(w)>1 and string.lower(w)==string.lower(string.sub(player.Name,1,string.len(w))) then
	    	message.BackgroundColor3=Color3.new(41/255, 128/255, 185/255)
	    	message.Transparency=.7
	    end
	end
end

-- To send the message
function send()
	if typer.Text ~= stockphrase and typer.Text ~= "" and typer.Text ~=" " then
		--Good good, let's continue.
		if workspace:findFirstChild'ProChat' then
			workspace.ProChat.Chatted2:FireServer(string.sub(typer.Text,0,maxnumber))
			typer.Text = stockphrase
			for i = 0,0.5,.1 do
				game:GetService("RunService").RenderStepped:wait()
				typer.TextTransparency=i
				script.Parent.char.TextTransparency=i
			end
		end		
	end
end

--Catches the "/" keydown
mouse.KeyUp:connect(function(key)
	if key=="/" then
		animate()
	end
end)

--workspace["Chat Servers"].ChatStrapper:FireServer(msg)
UID.InputBegan:connect(function(input)
	if input.KeyCode == Enum.KeyCode.Return then
		send()
	end
end)

SendBtn.MouseButton1Click:connect(function()
	send()
end)

script.Parent.Parent.Frame.ChildAdded:connect(function(c)
	repeat wait() until c:findFirstChild('name')
	if c:IsA'Frame' and c.Name=="message" and string.lower(c.name.Text)~=string.lower(" "..player.Name..":") then detectMention(c) end
end)

--This is to track the character count of the textbox, ugly because I can't find a proper event.
while wait() do
	
	local number = string.len(script.Parent.input.Text)
	
	--Fill the label
	if typer.Text ~= stockphrase and typer.Text ~= "" then
		script.Parent.char.Text = maxnumber-number.." characters left"
	else
		number=0
		script.Parent.char.Text = maxnumber-number.." characters left"
	end
	
	--Set the color
	if number>(maxnumber-(maxnumber/3)) then
		script.Parent.char.TextColor3=Color3.new(212/255, 19/255, 22/255)
		else
		script.Parent.char.TextColor3=Color3.new(10/255, 151/255, 212/255)
	end
	
	--Set it back to the correct length.
	if number>maxnumber then
		typer.Text = string.sub(typer.Text,0,maxnumber)
	end 
	
end
