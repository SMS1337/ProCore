-- I WARN YOU. THIS SCRIPT IS GROSS.
local player = game.Players.LocalPlayer
	local mouse = player:GetMouse()
typer = script.Parent.input
maxnumber=150
stockphrase = 'Press "/" to type.'
UID = game:GetService("UserInputService")

--Remove CoreGUI. 
local StarterGui = game:GetService('StarterGui')
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
	
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

--Catches the "/" keydown
mouse.KeyUp:connect(function(key)
	if key=="/" then
		animate()
	end
end)

--workspace["Chat Servers"].ChatStrapper:FireServer(msg)
UID.InputBegan:connect(function(input)
	if input.KeyCode == Enum.KeyCode.Return then
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
