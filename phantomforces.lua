if Drawing and getgc and writefile and readfile then
    local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Spoorloos/avlonhub/master/finity.lua"))() --http://finity.vip/scripts/finity_lib.lua https://pastebin.com/raw/y4eeFHp0

	local Main_Settings = {
		visuals = {
			enabled = false,
			boxesp = false,
			nameesp = false,
			chams = false,
			tracers = false,
			bullettracers = false,
			crosshair = false,
			grenadeesp = false,
			transparency = 0.5,
			visualscolor = {0.980000019073486328125, 0.9900000095367431640625, 1},
			visualsrainbow = true
		},
		aimbot = {
			enabled = false,
			silentaim = false,
			wallcheck = false,
			aimbotbind = {"UserInputType", "MouseButton2"},
			aimat = "Head",
			aimatrandom = false,
			headshotchance = 50,
			smoothness = 10,
			autoshoot = false,
			fov = false,
			fovradius = 200,
			ignorefov = false,
			fovfilled = false
		},
		mods1 = {
			norecoil = false,
			instantreload = false,
			noreload,
			nofalldamage = false,
			nospread = false,
			rapidfire = false,
			instantknife = false,
			grenadetp = false,
			knifeaura = false,
			granadefuzetime = 4.052476644516,
			firerate = 43
		},
		mods2 = {
			allauto = false,
			hidefromradar = false,
			nosway = false
		},
		other = {
			walkspeed = 15,
			jumppower = 20,
			infinitejump = false,
			fullbright = false,
		}
	}
	
	local loaded = false

    local sirhurt = false
    if (identifyexecutor ~= nil) and string.find(identifyexecutor():lower(), "sirhurt") then
        sirhurt = true
    end
	
	local CurrentTexts = { }
    local function WriteToConsole(message)
        local Msg = game.ReplicatedStorage.Misc.Msger
        local Message = Msg:Clone()
        local MTag = Message.Tag
        local Offset = 5
        Message.Parent = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui").ChatGame.GlobalChat
        Message.Text = "AvlonHub "
        Message.TextColor3 = Color3.new(0, 0.6, 1)
        table.insert(CurrentTexts, Message)
        Message.Msg.Text = message
        Message.Msg.Position = UDim2.new(0, Message.TextBounds.x, 0, 0)
        Message.Visible = true
        Message.Msg.Visible = true
    end
    
    local getbodyparts = nil
    for i, v in pairs(getgc(true)) do
        if typeof(v) == 'table' and rawget(v, 'getbodyparts') then
            getbodyparts = v["getbodyparts"]
        end
    end

	local network
	local funcs
	local gamelogic
	local effects
	local _oldeffects
	local trajectory

	repeat 
		for i,v in next, getgc() do
			if type(v) == "function" then
                if (debug.getinfo(v) and debug.getinfo(v).name) and string.find(string.lower(debug.getinfo(v).name), "trajectory") then
                    trajectory = v
                end
				for i2,v2 in next, debug.getupvalues(v) do
					if type(v2) == "table" and rawget(v2, 'send') then
						network = v2;
					end
					if type(v2) == "table" and rawget(v2, 'add') then
						funcs = v2;
					end
					if type(v2) == "table" and rawget(v2, 'gammo') then
						gamelogic = v2;
					end
				end
			end
		end
		for i,v in next, getgc(true) do
			if type(v) == "table" and rawget(v,'bullethit') and rawget(v,'breakwindow') then
				effects = v
				_oldeffects = v
			end
		end	
		wait(0.1)
	until network and funcs and gamelogic and effects and _oldeffects and trajectory and game.ReplicatedStorage:FindFirstChild("GunModules")

	local player = game:GetService("Players").LocalPlayer
	
	local fileexist = false
	if isfile then
		fileexist = isfile(game.PlaceId .. ".avlonhub")
	elseif readfile then
		pcall(function()
			if readfile(game.PlaceId .. ".avlonhub") then
				fileexist = true
			end
		end)
	else
		playerstable.LocalPlayer:Kick("Exploit not supported!")
	end
	
	if fileexist then
	    Main_Settings = game:GetService("HttpService"):JSONDecode(readfile(game.PlaceId .. ".avlonhub"))
	else
	    writefile(game.PlaceId .. ".avlonhub", game:GetService("HttpService"):JSONEncode(Main_Settings))
	end
	
	local function saveSettings()
	    writefile(game.PlaceId .. ".avlonhub", game:GetService("HttpService"):JSONEncode(Main_Settings))
	end
	
	local backupModules = game:GetService("ReplicatedStorage").GunModules:Clone()
	backupModules.Name = "backupGunModules"
	backupModules.Parent = game:GetService("ReplicatedStorage")


    local Window = library.new(true)
    Window.ChangeToggleKey(Enum.KeyCode.RightShift)
	
	if Main_Settings.aimbot.fovfilled == nil then
	    Main_Settings.aimbot.fovfilled = false
	    saveSettings()
	end

	if Main_Settings.visuals.transparency > 1 then
	    Main_Settings.visuals.transparency = 0.5
	    saveSettings()
	end

	if Main_Settings.aimbot.smoothness < 3 then
		Main_Settings.aimbot.smoothness = 3
		saveSettings()
	end

	if Main_Settings.aimbot.fovradius == 0 then
		Main_Settings.aimbot.fovradius = 200
		saveSettings()
	end

	if Main_Settings.aimbot.walkspeed == 0 then
		Main_Settings.aimbot.walkspeed = 15
		saveSettings()
	end

	if Main_Settings.aimbot.jumppower == 0 then
		Main_Settings.aimbot.jumppower = 20
		saveSettings()
	end
	
	
	local function HeadshotOrNot()
        local r = math.random(1,100)
        local add = 0
        local item
        for i,v in pairs({Head = tonumber(Main_Settings.aimbot.headshotchance), Torso = 100 - tonumber(Main_Settings.aimbot.headshotchance)}) do
            if (r > add) and r <= (add + v) then
                item = i
            end
            add = add + v
        end
        return item
	end
	
	function roundNumber(num, numDecimalPlaces)
		return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
	end

	--///////////////////////////////////////////////////////////////////////--
	--                                 ESP                                   --
	--///////////////////////////////////////////////////////////////////////--
	
	function zigzag(X) return math.acos(math.cos(X*math.pi))/math.pi end
	local counter = 0
	
	
    local Visuals_Catagory = Window:Category("Visuals")
    local ESP_Sector = Visuals_Catagory:Sector("ESP")
	
	local ESP_Toggle = ESP_Sector:Cheat("Checkbox", "Enabled", function(bool)
		Main_Settings.visuals.enabled = bool
	end, { ["enabled"] = Main_Settings.visuals.enabled })
	
	local ESP_BoxESPToggle = ESP_Sector:Cheat("Checkbox", "Box ESP", function(bool)
		Main_Settings.visuals.boxesp = bool
	end, { ["enabled"] = Main_Settings.visuals.boxesp })

	local ESP_NameESPToggle = ESP_Sector:Cheat("Checkbox", "Name ESP", function(bool)
		Main_Settings.visuals.nameesp = bool
	end, { ["enabled"] = Main_Settings.visuals.nameesp })
	
	local ESP_ChamsToggle = ESP_Sector:Cheat("Checkbox", "Chams", function(bool)
		Main_Settings.visuals.chams = bool
	end, { ["enabled"] = Main_Settings.visuals.chams })

	local ESP_TracersToggle = ESP_Sector:Cheat("Checkbox", "Tracers", function(bool)
		Main_Settings.visuals.tracers = bool
	end, { ["enabled"] = Main_Settings.visuals.tracers })

	local ESP_BulletTracersToggle = ESP_Sector:Cheat("Checkbox", "Bullet Tracers", function(bool)
		Main_Settings.visuals.bullettracers = bool
	end, { ["enabled"] = Main_Settings.visuals.bullettracers })
	
	local ESP_CrosshairToggle = ESP_Sector:Cheat("Checkbox", "Crosshair", function(bool)
		Main_Settings.visuals.crosshair = bool
	end, { ["enabled"] = Main_Settings.visuals.crosshair })

	local ESP_GrenadeESPToggle = ESP_Sector:Cheat("Checkbox", "Grenade ESP", function(bool)
		Main_Settings.visuals.grenadeesp = bool
	end, { ["enabled"] = Main_Settings.visuals.grenadeesp })
    
    local VisualsColor_Sector = Visuals_Catagory:Sector("Visuals Color")

    local VisualsColor_Transparency = VisualsColor_Sector:Cheat("Slider", "Transparency", function(trans)
		if loaded then
			Main_Settings.visuals.transparency = trans / 10
		end
	end, { 
        ["default"] = Main_Settings.visuals.transparency * 10,
		["min"] = 0, 
		["max"] = 10, 
		["suffix"] = "",
    })

    local VisualsColor_ColorPicker = VisualsColor_Sector:Cheat("Colorpicker", "Visuals Color", function(color)
        local hue, saturation, value = color:ToHSV()
        Main_Settings.visuals.visualscolor = {hue, saturation, value}
    end, { ["color"] = Color3.fromHSV(Main_Settings.visuals.visualscolor[1], Main_Settings.visuals.visualscolor[2], Main_Settings.visuals.visualscolor[3]) })
    
    local VisualsColor_RainBowToggle = VisualsColor_Sector:Cheat("Checkbox", "Rainbow", function(bool)
		Main_Settings.visuals.rainbow = bool
	end, { ["enabled"] = Main_Settings.visuals.rainbow })
	
	VisualsColor_Sector:Cheat("Button", "Reset", function()
		Main_Settings.visuals.rainbow = false
		
		local hue, saturation, value = Color3.new(1, 0, 0):ToHSV()
		Main_Settings.visuals.visualscolor = {hue, saturation, value}
	end)
	
    local CrossLine1 = Drawing.new("Line")
    CrossLine1.Visible = false
    CrossLine1.From = Vector2.new((workspace.CurrentCamera.ViewportSize.X / 2) - 12, workspace.CurrentCamera.ViewportSize.Y / 2)
    CrossLine1.To = Vector2.new((workspace.CurrentCamera.ViewportSize.X / 2) + 12, workspace.CurrentCamera.ViewportSize.Y / 2)
    CrossLine1.Thickness = 1
    CrossLine1.Transparency = 1
    
    local CrossLine2 = Drawing.new("Line")
    CrossLine2.Visible = false
    CrossLine2.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, (workspace.CurrentCamera.ViewportSize.Y / 2) - 12)
    CrossLine2.To = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, (workspace.CurrentCamera.ViewportSize.Y / 2) + 12)
    CrossLine2.Thickness = 1
	CrossLine2.Transparency = 1
	
	local FOVCircle = Drawing.new("Circle")
	FOVCircle.Transparency = roundNumber(Main_Settings.visuals.transparency, 1)
	FOVCircle.Visible = false
	FOVCircle.Radius = 200
	FOVCircle.Thickness = 0.1
	FOVCircle.NumSides = 1000
	FOVCircle.Filled = Main_Settings.aimbot.fovfilled
	FOVCircle.Position = Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X / 2, game.Workspace.CurrentCamera.ViewportSize.Y / 2)
	
	local allTracers = { }
	local allNameESPs = { }
	local allESPs = { }
	
	local function TracerExists(element)
		for _, value in pairs(allTracers) do
			if value.AssignedTo == element then
				return true
			end
		end
		return false
	end
	local function ESPExists(element)
		for _, value in pairs(allESPs) do
			if value["AssignedTo"] == element then
				return true
			end
		end
		return false
	end
	local function NameESPExists(element)
		for _, value in pairs(allNameESPs) do
			if value["AssignedTo"] == element then
				return true
			end
		end
		return false
	end

	local gethealth
	for i,v in pairs(getgc()) do
		if type(v) == "function" and debug.getinfo(v).name ~= nil then
			if string.find(string.lower(debug.getinfo(v).name), "gethealth") then
				gethealth = v
			end
		end
    end
    
	game:GetService("RunService").Heartbeat:Connect(function()
	    local rainbowcolor = Color3.fromHSV(zigzag(counter),1,1)
        pcall(function()
            FOVCircle.Filled = Main_Settings.aimbot.fovfilled
            FOVCircle.Visible = Main_Settings.aimbot.fov
            if Main_Settings.aimbot.fovfilled then
                FOVCircle.Transparency = 0.2
            else
                FOVCircle.Transparency = roundNumber(Main_Settings.visuals.transparency, 1)
            end
    		FOVCircle.Position = Vector2.new(game:GetService("Players").LocalPlayer:GetMouse().X, game:GetService("Players").LocalPlayer:GetMouse().Y + 43.5)
    		if Main_Settings.visuals.rainbow then
    			FOVCircle.Color = rainbowcolor
    		else
    			FOVCircle.Color = Color3.fromHSV(Main_Settings.visuals.visualscolor[1], Main_Settings.visuals.visualscolor[2], Main_Settings.visuals.visualscolor[3])
    		end
    		FOVCircle.Radius = Main_Settings.aimbot.fovradius
        end)
        
		if Main_Settings.visuals.enabled then
            --Tracers
			if Main_Settings.visuals.tracers then
				pcall(function()
					for i,v in pairs(allTracers) do
						if (gethealth(v.AssignedTo)["alive"] ~= nil) and not gethealth(v.AssignedTo)["alive"] then
							pcall(function()
								allTracers[i].value:Remove();
							end)
							allTracers[i] = nil
						end
						local vector, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(v.AssignedToBody.Torso.CFrame * CFrame.new(0, v.AssignedToBody.Torso.Size.Y, 0).p);
						if onScreen == false then
							pcall(function()
								allTracers[i].value:Remove();
							end)
							allTracers[i] = nil
						end
					end
					wait()
					for i,v in pairs(game:GetService("Players"):GetPlayers()) do
						if v.Team ~= game:GetService("Players").LocalPlayer.Team and (getbodyparts and v and getbodyparts(v)) and rawget(getbodyparts(v), "rootpart") and gethealth(v)["alive"] ~= false then
							local playerchar = getbodyparts(v)["rootpart"].Parent
							for i2,v2 in pairs(allTracers) do
								if v2 and v2.AssignedTo == v and v2.value then
									local Size = Vector3.new(2, 3, 0) * ((game:GetService("Players").LocalPlayer.Character.Head.Size.Y / 2) * 2)
									local vector1, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint((playerchar["HumanoidRootPart"].CFrame * CFrame.new(-Size.X, -Size.Y, 0)).p);
									local vector2, onScreen2 = game.Workspace.CurrentCamera:WorldToViewportPoint((playerchar["HumanoidRootPart"].CFrame * CFrame.new( Size.X, -Size.Y, 0)).p);
									local vector = (Vector2.new(vector1.X, vector1.Y) + Vector2.new(vector2.X, vector2.Y)) / 2
									local v22 = (Vector2.new(vector.X, vector.Y) - Vector2.new((game.Workspace.CurrentCamera.ViewportSize.X / 2), game.Workspace.CurrentCamera.ViewportSize.Y / 2)).Magnitude
									if onScreen then
										local ccccc
										if Main_Settings.aimbot.fov and Main_Settings.aimbot.ignorefov == false and v22 <= Main_Settings.aimbot.fovradius then
											ccccc = Color3.fromRGB(255, 255, 255)
										else
											if Main_Settings.visuals.rainbow then
												ccccc = rainbowcolor
											else
												ccccc = Color3.fromHSV(Main_Settings.visuals.visualscolor[1], Main_Settings.visuals.visualscolor[2], Main_Settings.visuals.visualscolor[3])
											end
										end
										
										v2.value.To = Vector2.new(vector.X, vector.Y)
										v2.value.Transparency = roundNumber(Main_Settings.visuals.transparency, 1)
										v2.value.Color = ccccc
									end
								end
							end
					
							if playerchar and v and not TracerExists(v) then
								local vector, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(playerchar.Torso.CFrame * CFrame.new(0, playerchar.Torso.Size.Y, 0).p);
								local v22 = (Vector2.new(vector.X, vector.Y) - Vector2.new((game.Workspace.CurrentCamera.ViewportSize.X / 2), game.Workspace.CurrentCamera.ViewportSize.Y / 2)).Magnitude
								if onScreen then
									local ccccc
									if Main_Settings.aimbot.fov and Main_Settings.aimbot.ignorefov == false and v22 <= Main_Settings.aimbot.fovradius then
										ccccc = Color3.fromRGB(255, 255, 255)
									else
										if Main_Settings.visuals.rainbow then
											ccccc = rainbowcolor
										else
											ccccc = Color3.fromHSV(Main_Settings.visuals.visualscolor[1], Main_Settings.visuals.visualscolor[2], Main_Settings.visuals.visualscolor[3])
										end
									end
									
									local Line = Drawing.new("Line")
									Line.Visible = true
									Line.From = Vector2.new(game.Workspace.CurrentCamera.ViewportSize.X / 2, game.Workspace.CurrentCamera.ViewportSize.Y)
									Line.To = Vector2.new(vector.X, vector.Y)
									Line.Color = ccccc
									Line.Thickness = 1
									Line.Transparency = roundNumber(Main_Settings.visuals.transparency, 1)

									local _Line = { value = Line, AssignedTo = v, AssignedToBody = playerchar }
									table.insert(allTracers, _Line)
								end
							end
						end
					end
				end)
			end
		    
		    --Name ESP
			if Main_Settings.visuals.nameesp then
			    pcall(function()
    				for i,v in pairs(allNameESPs) do
    					if (gethealth(v.AssignedTo)["alive"] ~= nil) and not gethealth(v.AssignedTo)["alive"] then
    						pcall(function()
    							allNameESPs[i].value:Remove();
    						end)
    						allNameESPs[i] = nil
    					end
    					local vector, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(v.AssignedToBody.Torso.CFrame * CFrame.new(0, v.AssignedToBody.Torso.Size.Y, 0).p);
    					if onScreen == false then
    						pcall(function()
    							allNameESPs[i].value:Remove();
    						end)
    						allNameESPs[i] = nil
    					end
    				end
				end)
				for i,v in pairs(game:GetService("Players"):GetPlayers()) do
				    if getbodyparts and v and not NameESPExists(v) and getbodyparts(v) and rawget(getbodyparts(v), "rootpart") and v ~= game:GetService("Players").LocalPlayer and v.Team.Name ~= game:GetService("Players").LocalPlayer.Team.Name and gethealth(v)["alive"] ~= false then
    					local playerchar = getbodyparts(v)["rootpart"].Parent
						local Location, VisibleOnScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(playerchar.Head.CFrame * CFrame.new(0, playerchar.Head.Size.Y, 0).p);
						if VisibleOnScreen then
							local NameESP1 = Drawing.new("Text") 
							NameESP1.Text = math.floor(gethealth(v)["health0"]) .. " - " .. v.Name
							NameESP1.Size = 14
							NameESP1.Center = true
							NameESP1.Outline = true
							NameESP1.OutlineColor = Color3.fromRGB(30, 30, 30)
							NameESP1.Position = Vector2.new(Location.X, Location.Y + 40)
							NameESP1.Visible = true
							NameESP1.Transparency = roundNumber(Main_Settings.visuals.transparency, 1)
							if gethealth(v)["health0"] <= 65 then
								if gethealth(v)["health0"] <= 40 then
									NameESP1.Color = Color3.fromRGB(186, 40, 28)
								elseif gethealth(v)["health0"] <= 20 then
									NameESP1.Color = Color3.fromRGB(255, 0, 0)
								else
									NameESP1.Color = Color3.fromRGB(190, 104, 98)
								end
							else
								NameESP1.Color = Color3.fromRGB(52, 142, 64)
							end


							local _NameESP = { value = NameESP1, AssignedTo = v, AssignedToBody = playerchar }
							table.insert(allNameESPs, _NameESP)
						end
					elseif getbodyparts and v and NameESPExists(v) and getbodyparts(v) and rawget(getbodyparts(v), "rootpart") and v ~= game:GetService("Players").LocalPlayer and v.Team.Name ~= game:GetService("Players").LocalPlayer.Team.Name then
						for i2,v2 in pairs(allNameESPs) do
							if v2.AssignedTo == v then
								local playerchar = v2.AssignedToBody
								local Location, VisibleOnScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(playerchar.Head.CFrame * CFrame.new(0, playerchar.Head.Size.Y, 0).p);
								if VisibleOnScreen then
									v2["value"].Text = math.floor(gethealth(v)["health0"]) .. " - " .. v.Name
									v2["value"].Position = Vector2.new(Location.X, Location.Y + 40)
									v2["value"].Transparency = roundNumber(Main_Settings.visuals.transparency, 1)
									if gethealth(v)["health0"] <= 65 then
										if gethealth(v)["health0"] <= 40 then
											v2["value"].Color = Color3.fromRGB(186, 40, 28)
										elseif gethealth(v)["health0"] <= 20 then
											v2["value"].Color = Color3.fromRGB(255, 0, 0)
										else
											v2["value"].Color = Color3.fromRGB(190, 104, 98)
										end
									else
										v2["value"].Color = Color3.fromRGB(52, 142, 64)
									end
								end
							end
						end
					end
				end
			else
			    for i,v in pairs(allNameESPs) do 
    			    if v["value"] then
        			    pcall(function()
        					v["value"]:Remove()
        				end)
        				allNameESPs[i] = nil
    				end
    			end
			end
			
			--Crosshair
			if Main_Settings.visuals.crosshair then
                CrossLine1.Visible = true
                CrossLine2.Visible = true
                
                CrossLine1.From = Vector2.new(game:GetService("Players").LocalPlayer:GetMouse().X - 12, game:GetService("Players").LocalPlayer:GetMouse().Y + 43.5)
                CrossLine1.To = Vector2.new(game:GetService("Players").LocalPlayer:GetMouse().X + 12, game:GetService("Players").LocalPlayer:GetMouse().Y + 43.5)
                
                CrossLine2.From = Vector2.new(game:GetService("Players").LocalPlayer:GetMouse().X, (game:GetService("Players").LocalPlayer:GetMouse().Y + 43.5) - 12)
                CrossLine2.To = Vector2.new(game:GetService("Players").LocalPlayer:GetMouse().X, (game:GetService("Players").LocalPlayer:GetMouse().Y + 43.5) + 12)
                
                if Main_Settings.visuals.rainbow then
            		CrossLine2.Color = rainbowcolor
            	else
            		CrossLine2.Color = Color3.fromHSV(Main_Settings.visuals.visualscolor[1], Main_Settings.visuals.visualscolor[2], Main_Settings.visuals.visualscolor[3])
            	end
            	if Main_Settings.visuals.rainbow then
            		CrossLine1.Color = rainbowcolor
            	else
            		CrossLine1.Color = Color3.fromHSV(Main_Settings.visuals.visualscolor[1], Main_Settings.visuals.visualscolor[2], Main_Settings.visuals.visualscolor[3])
            	end
			else
                CrossLine1.Visible = false
                CrossLine2.Visible = false
			end
		    
			--ESP
			if Main_Settings.visuals.boxesp then
			    pcall(function()
    			    for i,v in pairs(allESPs) do
    					if (gethealth(v.AssignedTo)["alive"] ~= nil) and not gethealth(v.AssignedTo)["alive"] then
    						pcall(function()
    						    v.RemoveLines()
    						end)
    						allESPs[i] = nil
    					end
    					local vector, onScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(v.AssignedToBody:FindFirstChild("Head").Position)
    					if onScreen == false then
    						pcall(function()
    						    v.RemoveLines()
    						end)
    						allESPs[i] = nil
    					end
    			    end
    			end)
				wait()
				for i,v in pairs(game:GetService("Players"):GetPlayers()) do
				    if ESPExists(v) == false and getbodyparts and (v) and getbodyparts(v) and gethealth(v)["alive"] ~= false then
                        local playerchar = getbodyparts(v)
    					if playerchar ~= nil and rawget(playerchar, "rootpart") and v ~= game:GetService("Players").LocalPlayer and v.Team.Name ~= game:GetService("Players").LocalPlayer.Team.Name and (game:GetService("Players").LocalPlayer.Character ~= nil) and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Head") ~= nil then
				            local f = game.Workspace.CurrentCamera:WorldToScreenPoint(playerchar.rootpart.Parent:FindFirstChild("Head").Position)
            				local v22 = (Vector2.new(f.X, f.Y) - Vector2.new((game.Workspace.CurrentCamera.ViewportSize.X / 2), game.Workspace.CurrentCamera.ViewportSize.Y / 2)).Magnitude

            				local ccccc
            				if Main_Settings.aimbot.fov and Main_Settings.aimbot.ignorefov == false and v22 <= Main_Settings.aimbot.fovradius then
            				    ccccc = Color3.fromRGB(255, 255, 255)
            				else
                                if Main_Settings.visuals.rainbow then
                            		ccccc = rainbowcolor
                            	else
                            		ccccc = Color3.fromHSV(Main_Settings.visuals.visualscolor[1], Main_Settings.visuals.visualscolor[2], Main_Settings.visuals.visualscolor[3])
                            	end
            				end
    					    
        					local Size = Vector3.new(2, 3, 0) * ((game:GetService("Players").LocalPlayer.Character:FindFirstChild("Head").Size.Y / 2) * 2)
        					local line1loc, Visible1 = game.Workspace.CurrentCamera:WorldToViewportPoint((playerchar.rootpart.CFrame * CFrame.new( Size.X,  Size.Y, 0)).p);
                            local line2loc, Visible2 = game.Workspace.CurrentCamera:WorldToViewportPoint((playerchar.rootpart.CFrame * CFrame.new(-Size.X,  Size.Y, 0)).p);
                            local line3loc, Visible3 = game.Workspace.CurrentCamera:WorldToViewportPoint((playerchar.rootpart.CFrame * CFrame.new( Size.X, -Size.Y, 0)).p);
                            local line4loc, Visible4 = game.Workspace.CurrentCamera:WorldToViewportPoint((playerchar.rootpart.CFrame * CFrame.new(-Size.X, -Size.Y, 0)).p);
                                	
        					local f1 = Drawing.new("Line")
        					local f2 = Drawing.new("Line")
        					local f3 = Drawing.new("Line")
        					local f4 = Drawing.new("Line")
        					if Visible1 then
                                f1.Visible = true
                                f1.Color = ccccc
                                f1.From = Vector2.new(line1loc.X, line1loc.Y)
                                f1.To = Vector2.new(line2loc.X, line2loc.Y)
                                f1.Transparency = roundNumber(Main_Settings.visuals.transparency, 1)
                                f1.Thickness = 1
            				end
        					if Visible2 then
                                f2.Visible = true
                                f2.Color = ccccc
                                f2.From = Vector2.new(line2loc.X, line2loc.Y)
                                f2.To = Vector2.new(line4loc.X, line4loc.Y)
                                f2.Transparency = roundNumber(Main_Settings.visuals.transparency, 1)
                                f2.Thickness = 1
                            end
        					if Visible3 then
                                f3.Visible = true
                                f3.Color = ccccc
                                f3.From = Vector2.new(line3loc.X, line3loc.Y)
                                f3.To = Vector2.new(line1loc.X, line1loc.Y)
                                f3.Transparency = roundNumber(Main_Settings.visuals.transparency, 1)
                                f3.Thickness = 1
            				end
        					if Visible4 then
                                f4.Visible = true
                                f4.Color = ccccc
                                f4.From = Vector2.new(line4loc.X, line4loc.Y)
                                f4.To = Vector2.new(line3loc.X, line3loc.Y)
                                f4.Transparency = roundNumber(Main_Settings.visuals.transparency, 1)
                                f4.Thickness = 1
        					end
        					
        					table.insert(allESPs, { 
								AssignedTo = v,
								AssignedToBody = playerchar.rootpart.Parent,
								RemoveLines = function() 
								    f1:Remove()
								    f2:Remove()
								    f3:Remove()
								    f4:Remove()
							    end,
    					        Lines = {
            					    f1,
            					    f2,
            					    f3,
            					    f4
            					}
    					    })
    					end
					else
                        for i2,v2 in pairs(allESPs) do
                            if v2["AssignedTo"] == v then
                                local playerchar = getbodyparts(v)
    					        if playerchar ~= nil and rawget(playerchar, "rootpart") and v ~= game:GetService("Players").LocalPlayer and v.Team.Name ~= game:GetService("Players").LocalPlayer.Team.Name and gethealth(v)["alive"] ~= false then
    					            local f = game.Workspace.CurrentCamera:WorldToScreenPoint(playerchar.rootpart.Parent:FindFirstChild("Head").Position)
                    				local v22 = (Vector2.new(f.X, f.Y) - Vector2.new((game.Workspace.CurrentCamera.ViewportSize.X / 2), game.Workspace.CurrentCamera.ViewportSize.Y / 2)).Magnitude
                    				
                    				local ccccc
                    				if Main_Settings.aimbot.fov and Main_Settings.aimbot.ignorefov == false and v22 <= Main_Settings.aimbot.fovradius then
                    				    ccccc = Color3.fromRGB(255, 255, 255)
                    				else
                                        if Main_Settings.visuals.rainbow then
                                    		ccccc = rainbowcolor
                                    	else
                                    		ccccc = Color3.fromHSV(Main_Settings.visuals.visualscolor[1], Main_Settings.visuals.visualscolor[2], Main_Settings.visuals.visualscolor[3])
                                    	end
                    				end
    					            
                                    local Size = Vector3.new(2, 3, 0) * ((game:GetService("Players").LocalPlayer.Character.Head.Size.Y / 2) * 2)
                					local line1loc, Visible1 = game.Workspace.CurrentCamera:WorldToViewportPoint((playerchar.rootpart.CFrame * CFrame.new( Size.X,  Size.Y, 0)).p);
                                    local line2loc, Visible2 = game.Workspace.CurrentCamera:WorldToViewportPoint((playerchar.rootpart.CFrame * CFrame.new(-Size.X,  Size.Y, 0)).p);
                                    local line3loc, Visible3 = game.Workspace.CurrentCamera:WorldToViewportPoint((playerchar.rootpart.CFrame * CFrame.new( Size.X, -Size.Y, 0)).p);
                                    local line4loc, Visible4 = game.Workspace.CurrentCamera:WorldToViewportPoint((playerchar.rootpart.CFrame * CFrame.new(-Size.X, -Size.Y, 0)).p);
                                    
                					if Visible1 then
                                        v2["Lines"][1].Visible = true
                                        v2["Lines"][1].Color = ccccc
                                        v2["Lines"][1].From = Vector2.new(line1loc.X, line1loc.Y)
                                        v2["Lines"][1].To = Vector2.new(line2loc.X, line2loc.Y)
                                        v2["Lines"][1].Transparency = roundNumber(Main_Settings.visuals.transparency, 1)
                                        v2["Lines"][1].Thickness = 1
                    				end
                					if Visible2 then
                                        v2["Lines"][2].Visible = true
                                        v2["Lines"][2].Color = ccccc
                                        v2["Lines"][2].From = Vector2.new(line2loc.X, line2loc.Y)
                                        v2["Lines"][2].To = Vector2.new(line4loc.X, line4loc.Y)
                                        v2["Lines"][2].Transparency = roundNumber(Main_Settings.visuals.transparency, 1)
                                        v2["Lines"][2].Thickness = 1
                    				end
                					if Visible3 then
                                        v2["Lines"][3].Visible = true
                                        v2["Lines"][3].Color = ccccc
                                        v2["Lines"][3].From = Vector2.new(line3loc.X, line3loc.Y)
                                        v2["Lines"][3].To = Vector2.new(line1loc.X, line1loc.Y)
                                        v2["Lines"][3].Transparency = roundNumber(Main_Settings.visuals.transparency, 1)
                                        v2["Lines"][3].Thickness = 1
                    				end
                					if Visible4 then
                                        v2["Lines"][4].Visible = true
                                        v2["Lines"][4].Color = ccccc
                                        v2["Lines"][4].From = Vector2.new(line4loc.X, line4loc.Y)
                                        v2["Lines"][4].To = Vector2.new(line3loc.X, line3loc.Y)
                                        v2["Lines"][4].Transparency = roundNumber(Main_Settings.visuals.transparency, 1)
                                        v2["Lines"][4].Thickness = 1
                					end
            				    else
            					    pcall(function()
            					        v2.RemoveLines()
            					    end)
                    				allESPs[i2] = nil
            				    end
                            end
                        end
                    end
				end
			else
				for i,v in pairs(allESPs) do 
					if v["Lines"] and v["Lines"][1] then
		            	pcall(function()
					        v.RemoveLines()
					    end)
						allESPs[i] = nil
					end
				end
			end
	
			--Chams
			if Main_Settings.visuals.chams then
				for i,v in pairs(game:GetService("Players"):GetPlayers()) do
					if v and getbodyparts and getbodyparts(v) and rawget(getbodyparts(v), "rootpart") and v.Team.Name ~= game:GetService("Players").LocalPlayer.Team.Name and gethealth(v)["alive"] ~= false then
						local playerchar = getbodyparts(v)["rootpart"].Parent
						local f = game.Workspace.CurrentCamera:WorldToScreenPoint(playerchar:FindFirstChild("Head").Position)
						local v22 = (Vector2.new(f.X, f.Y) - Vector2.new((game.Workspace.CurrentCamera.ViewportSize.X / 2), game.Workspace.CurrentCamera.ViewportSize.Y / 2)).Magnitude

						local ccccc
						if Main_Settings.aimbot.fov and Main_Settings.aimbot.ignorefov == false and v22 <= Main_Settings.aimbot.fovradius then
							ccccc = Color3.fromRGB(255, 255, 255)
						else
							if Main_Settings.visuals.rainbow then
								ccccc = rainbowcolor
							else
								ccccc = Color3.fromHSV(Main_Settings.visuals.visualscolor[1], Main_Settings.visuals.visualscolor[2], Main_Settings.visuals.visualscolor[3])
							end
						end
						for i2,v2 in pairs(playerchar:GetChildren()) do
							if (v2:IsA("BasePart") and not v2:IsA("Model")) and not v2:FindFirstChild("BoxHandleAdornment") and v2.Name ~= "HumanoidRootPart" then
								local adornment = Instance.new("BoxHandleAdornment", v2)
								adornment.AlwaysOnTop = true

								local num1 = roundNumber(Main_Settings.visuals.transparency, 1)
								local num

								if num1 == 0 then num = 1
								elseif num1 == 0.1 then num = 0.9
								elseif num1 == 0.2 then num = 0.8
								elseif num1 == 0.3 then num = 0.7
								elseif num1 == 0.4 then num = 0.6
								elseif num1 == 0.5 then num = 0.5
								elseif num1 == 0.6 then num = 0.4
								elseif num1 == 0.7 then num = 0.3
								elseif num1 == 0.8 then num = 0.2
								elseif num1 == 0.9 then num = 0.1
								elseif num1 == 1 then num = 0.0 end

								adornment.Transparency = num
								adornment.Adornee = v2
								adornment.ZIndex = 5
								adornment.Size = v2.Size
								adornment.Color3 = ccccc
							elseif v2:FindFirstChild("BoxHandleAdornment") then
								local c = v2:FindFirstChild("BoxHandleAdornment")
								c.Size = v2.Size

								local num1 = roundNumber(Main_Settings.visuals.transparency, 1)
								local num

								if num1 == 0 then num = 1
								elseif num1 == 0.1 then num = 0.9
								elseif num1 == 0.2 then num = 0.8
								elseif num1 == 0.3 then num = 0.7
								elseif num1 == 0.4 then num = 0.6
								elseif num1 == 0.5 then num = 0.5
								elseif num1 == 0.6 then num = 0.4
								elseif num1 == 0.7 then num = 0.3
								elseif num1 == 0.8 then num = 0.2
								elseif num1 == 0.9 then num = 0.1
								elseif num1 == 1 then num = 0.0 end

								c.Transparency = num
								c.Color3 = ccccc
							end
						end
					end
				end
			else
				for i,v in pairs(game:GetService("Players"):GetChildren()) do
					if (getbodyparts and v) and (getbodyparts(v)) and rawget(getbodyparts(v), "rootpart") then
						local plrchar = getbodyparts(v)["rootpart"].Parent
						for i2,v2 in pairs(plrchar:GetChildren()) do
							if v2:FindFirstChild("BoxHandleAdornment") then
								v2:FindFirstChild("BoxHandleAdornment"):Remove()
							end
						end
					end
				end
			end
		else
			for i,v in pairs(game:GetService("Players"):GetChildren()) do
				if (getbodyparts and v) and (getbodyparts(v)) and rawget(getbodyparts(v), "rootpart") then
					local plrchar = getbodyparts(v)["rootpart"].Parent
					for i2,v2 in pairs(plrchar:GetChildren()) do
						if v2:FindFirstChild("BoxHandleAdornment") then
							v2:FindFirstChild("BoxHandleAdornment"):Remove()
						end
					end
				end
			end
			
		    for i,v in pairs(allNameESPs) do 
			    if v["value"] then
    			    pcall(function()
    					v["value"]:Remove()
    				end)
    				allNameESPs[i] = nil
				end
			end

			for i,v in pairs(allTracers) do
				pcall(function()
					v.value:Remove();
				end)
				v = nil
			end
			
			for i,v in pairs(allESPs) do 
				if v["Lines"] and v["Lines"][1] then
	            	pcall(function()
				        v.RemoveLines()
				    end)
					allESPs[i] = nil
				end
			end
		end

		if Main_Settings.visuals.boxesp == false then
			for i,v in pairs(allESPs) do 
				if v["Lines"] and v["Lines"][1] then
	            	pcall(function()
				        v.RemoveLines()
				    end)
					allESPs[i] = nil
				end
			end
		end
		
		if Main_Settings.visuals.nameesp == false then
		    for i,v in pairs(allNameESPs) do 
			    if v["value"] then
    			    pcall(function()
    					v["value"]:Remove()
    				end)
    				allNameESPs[i] = nil
				end
			end
		end

		if Main_Settings.visuals.chams == false then
			for i,v in pairs(game:GetService("Players"):GetChildren()) do
				if (getbodyparts and v) and (getbodyparts(v)) and rawget(getbodyparts(v), "rootpart") then
					local plrchar = getbodyparts(v)["rootpart"].Parent
					for i2,v2 in pairs(plrchar:GetChildren()) do
						if v2:FindFirstChild("BoxHandleAdornment") then
							v2:FindFirstChild("BoxHandleAdornment"):Remove()
						end
					end
				end
			end
		else
			for i,v in pairs(game:GetService("Players"):GetChildren()) do
				if (getbodyparts and v) and (getbodyparts(v)) and rawget(getbodyparts(v), "rootpart") and v.Team.Name == game:GetService("Players").LocalPlayer.Team.Name then
					local plrchar = getbodyparts(v)["rootpart"].Parent
					for i2,v2 in pairs(plrchar:GetChildren()) do
						if v2:FindFirstChild("BoxHandleAdornment") then
							v2:FindFirstChild("BoxHandleAdornment"):Remove()
						end
					end
				end
			end
		end

		if Main_Settings.visuals.tracers == false then
			for i,v in pairs(allTracers) do
				pcall(function()
					v.value:Remove();
				end)
				v = nil
			end
		end

		--Rainbow
        if Main_Settings.visuals.rainbow then
            local hue, saturation, value = rainbowcolor:ToHSV()
            Main_Settings.visuals.visualscolor = {hue, saturation, value}
			esp_color = rainbowcolor
		end
		counter = counter + 0.001
	end)
	
	game:GetService('RunService').Heartbeat:Connect(function()
        if Main_Settings.visuals.grenadeesp and Main_Settings.visuals.enabled then
            for i,v in pairs(game:GetService("Workspace").Ignore.Misc:GetChildren()) do
                if v.Name == "Trigger" and v:FindFirstChild("Indicator") then
                    if v:FindFirstChild("grenesp") == nil then
                        local grenadeesp = Instance.new("BoxHandleAdornment", v)
                        grenadeesp.AlwaysOnTop = true
                        grenadeesp.Transparency = 0
                        grenadeesp.Adornee = v
                        grenadeesp.Size = Vector3.new(1, 1, 1)
                        grenadeesp.Name = "grenesp"
                        grenadeesp.ZIndex = 5
                        if v:FindFirstChild("Indicator"):FindFirstChild("Enemy").Visible == true then
                            grenadeesp.Color3 = Color3.fromRGB(196, 40, 28)
                        elseif v:FindFirstChild("Indicator"):FindFirstChild("Friendly").Visible == true then
                            grenadeesp.Color3 = Color3.fromRGB(91, 154, 76)
                        end
                    end
                end
            end
        end
    end)

	local currentshootat = "Head"
	--///////////////////////////////////////////////////////////////////////--
	--                                Aimbot                                 --
	--///////////////////////////////////////////////////////////////////////--
	
    local Aimbot_Catagory = Window:Category("Aimbot")
    local Aimbot_Sector = Aimbot_Catagory:Sector("Aimbot")

		--Enabled
    local Aimbot_EnabledToggle = Aimbot_Sector:Cheat("Checkbox", "Aimbot", function(bool)
        Main_Settings.aimbot.enabled = bool
    end, { ["enabled"] = Main_Settings.aimbot.enabled })
    
		--Silent Aim
    local Aimbot_SilentAimToggle = Aimbot_Sector:Cheat("Checkbox", "Silent Aim", function(bool)
        Main_Settings.aimbot.silentaim = bool
    end, { ["enabled"] = Main_Settings.aimbot.silentaim })

        --Wallcheck
    local Aimbot_WallcheckToggle = Aimbot_Sector:Cheat("Checkbox", "Wallcheck", function(bool)
        Main_Settings.aimbot.wallcheck = bool
    end, { ["enabled"] = Main_Settings.aimbot.wallcheck })
    
        --AutoShoot
    local Aimbot_AutoShootToggle = Aimbot_Sector:Cheat("Checkbox", "Auto Shoot", function(bool)
        Main_Settings.aimbot.autoshoot = bool
    end, { ["enabled"] = Main_Settings.aimbot.autoshoot })

    local Aimbot_HeadshotChance, Aimbot_HeadshotChanceSlider
    
    local keu
    if Main_Settings.aimbot.aimbotbind == nil then
        keu = Enum.UserInputType.MouseButton2
    else
        keu = Enum[Main_Settings.aimbot.aimbotbind[1]][Main_Settings.aimbot.aimbotbind[2]]
    end
    
    function str_split(str, sep)
        if sep == nil then
            sep = '%s'
        end 
    
        local res = {}
        local func = function(w)
            table.insert(res, w)
        end 
    
        string.gsub(str, '[^'..sep..']+', func)
        return res 
    end
    
        --AimbotBind
    local Aimbot_AimbotBindToggle = Aimbot_Sector:Cheat("Keybind", "Aimbot Bind", function(key)
        Main_Settings.aimbot.aimbotbind = str_split(tostring(key):gsub("Enum.", ""), ".")
	end, { ["bind"] = keu })

    local Aimbot_HeadshotChance

    local ddo
    if Main_Settings.aimbot.aimatrandom then ddo = "Random" else ddo = Main_Settings.aimbot.aimat end

        --AimAt
    local Aimbot_AimAtDropdown = Aimbot_Sector:Cheat("Dropdown", "Aim At", function(object)
        if tostring(object) == "Head" then
			Main_Settings.aimbot.aimat = "Head"
			Main_Settings.aimbot.aimatrandom = false
            Aimbot_HeadshotChance.sliderbar.Visible = false
            Aimbot_HeadshotChance.numbervalue.Visible = false
            Aimbot_HeadshotChance.visiframe.Visible = false
            Aimbot_HeadshotChance.label.Visible = false
        elseif tostring(object) == "Torso" then
			Main_Settings.aimbot.aimat = "Torso"
			Main_Settings.aimbot.aimatrandom = false
            Aimbot_HeadshotChance.sliderbar.Visible = false
            Aimbot_HeadshotChance.numbervalue.Visible = false
            Aimbot_HeadshotChance.visiframe.Visible = false
            Aimbot_HeadshotChance.label.Visible = false
        elseif tostring(object) == "Random" then
	        Main_Settings.aimbot.aimat = ""
			Main_Settings.aimbot.aimatrandom = true
            Aimbot_HeadshotChance.sliderbar.Visible = true
            Aimbot_HeadshotChance.numbervalue.Visible = true
            Aimbot_HeadshotChance.visiframe.Visible = true
            Aimbot_HeadshotChance.label.Visible = true
        end
    end, { ["default"] = ddo, ["options"] = {
        "Head",
        "Torso",
        "Random"
    }})
	
	Aimbot_HeadshotChance = Aimbot_Sector:Cheat("Slider", "Headshot Chance", function(trans)
	    pcall(function()
    	    if loaded then
                Main_Settings.aimbot.headshotchance = trans
    	    end 
        end)
	end, { 
        ["default"] = Main_Settings.aimbot.headshotchance,
		["min"] = 0, 
		["max"] = 100, 
		["suffix"] = "%",
    })
    if Main_Settings.aimbot.headshotchance == nil then Main_Settings.aimbot.headshotchance = 50 end
    Aimbot_HeadshotChance.sliderbar.Visible = Main_Settings.aimbot.aimatrandom
    Aimbot_HeadshotChance.numbervalue.Visible = Main_Settings.aimbot.aimatrandom
    Aimbot_HeadshotChance.visiframe.Visible = Main_Settings.aimbot.aimatrandom
    Aimbot_HeadshotChance.label.Visible = Main_Settings.aimbot.aimatrandom
    
    local Aimbot_Smoothness = Aimbot_Sector:Cheat("Slider", "Aimbot Smoothness", function(trans)
        pcall(function()
            if loaded then
                if trans ~= 0 then
                    Main_Settings.aimbot.smoothness = trans * 10
                else
                    Main_Settings.aimbot.smoothness = 3
                end
            end
        end)
	end, { 
        ["default"] = tonumber(Main_Settings.aimbot.smoothness) / 10,
		["min"] = 0, 
		["max"] = 10, 
		["suffix"] = "%",
    })
    
    local FOV_Sector = Aimbot_Catagory:Sector("FOV")

        --FOV
	local Aimbot_FovToggle = FOV_Sector:Cheat("Checkbox", "FOV Enabled", function(bool)
		Main_Settings.aimbot.fov = bool
	end, { ["enabled"] = Main_Settings.aimbot.fov })

        --Ignore FOV
	local Aimbot_IgnoreFovToggle = FOV_Sector:Cheat("Checkbox", "Ignore FOV", function(bool)
		Main_Settings.aimbot.ignorefov = bool
	end, { ["enabled"] = Main_Settings.aimbot.ignorefov })
	
        --FOV Filled
	local Aimbot_FovFilledToggle = FOV_Sector:Cheat("Checkbox", "FOV Filled", function(bool)
		Main_Settings.aimbot.fovfilled = bool
    end, { ["enabled"] = Main_Settings.aimbot.fovfilled })
    
		--Fov Radius
    local Aimbot_FovRadiusSlider = FOV_Sector:Cheat("Slider", "FOV Radius", function(x)
        if loaded then
		    Main_Settings.aimbot.fovradius = x
		end
	end, { 
        ["default"] = Main_Settings.aimbot.fovradius,
		["min"] = 0, 
		["max"] = 1000, 
		["suffix"] = "",
	})

    local PLAYER = game:GetService("Players").LocalPlayer
    local MOUSE = PLAYER:GetMouse()
    local CC = game.Workspace.CurrentCamera
    
    local Aimbot_ENABLED = false
        
    
    local function WallChecker(p, ...)
        local f = #game.Workspace.CurrentCamera:GetPartsObscuringTarget({p}, {game.Workspace.CurrentCamera, player.Character, ...})
        if f == 0 or f == 1 then
            return true
        end
        return false
    end
    
        
	local function GetClosestPlayer()
	    local aimatpart2 = Main_Settings.aimbot.aimat
        if Main_Settings.aimbot.aimatrandom then
			aimatpart2 = tostring(HeadshotOrNot())
		end
	    
		local closestdist = math.huge
		local closestplr = nil
		local closestplrbody = nil
		for _,plr in pairs(game:GetService("Players"):GetPlayers()) do
		    if getbodyparts and plr then
    		    local playerchar = getbodyparts(plr)
        		if playerchar ~= nil and rawget(playerchar, "rootpart") and plr ~= game:GetService("Players").LocalPlayer and plr.Team.Name ~= game:GetService("Players").LocalPlayer.Team.Name then
        			local f = game.Workspace.CurrentCamera:WorldToScreenPoint(playerchar.rootpart.Parent["Head"].Position)
        			local f2 = Vector2.new(f.X, f.Y)
        			local mouseloc = Vector2.new(MOUSE.X, MOUSE.Y)
        			local v = (f2 - mouseloc).Magnitude
        			if v < closestdist then
        				closestdist = v
        				closestplr = plr
        				closestplrbody = playerchar.rootpart.Parent
        			end
        		end
    		end
		end

		if closestplr and closestplrbody then
			local f = game.Workspace.CurrentCamera:WorldToScreenPoint(closestplrbody["Head"].Position)
			local f2 = Vector2.new(f.X, f.Y)
			local center = Vector2.new((game.Workspace.CurrentCamera.ViewportSize.X / 2), game.Workspace.CurrentCamera.ViewportSize.Y / 2)
			local v = (f2 - center).Magnitude

			if Main_Settings.aimbot.fov and Main_Settings.aimbot.ignorefov == false then
			    if Main_Settings.aimbot.wallcheck then
			        if WallChecker(closestplrbody[aimatpart2].Position, closestplrbody) then
				        if v <= Main_Settings.aimbot.fovradius then
					        return closestplrbody, closestplr
				        end
			        end
			    else
			        if v <= Main_Settings.aimbot.fovradius then
				        return closestplrbody, closestplr
			        end
			    end
			else
                if Main_Settings.aimbot.wallcheck then
			        if WallChecker(closestplrbody[aimatpart2].Position, closestplrbody) then
					    return closestplrbody, closestplr
			        end
			    else
				    return closestplrbody, closestplr
			    end
			end
		end
		return nil
	end

	local function GetClosestPlayer2()
		local closestdist = math.huge
		local closestplr = nil
		local closestplrbody = nil
		for _,plr in pairs(game:GetService("Players"):GetPlayers()) do
		    if getbodyparts and plr then
    		    local playerchar = getbodyparts(plr)
        		if playerchar ~= nil and rawget(playerchar, "rootpart") and plr ~= game:GetService("Players").LocalPlayer and plr.Team.Name ~= game:GetService("Players").LocalPlayer.Team.Name then
        			local f = game.Workspace.CurrentCamera:WorldToScreenPoint(playerchar.rootpart.Parent["Head"].Position)
        			local f2 = Vector2.new(f.X, f.Y)
        			local mouseloc = Vector2.new(player:GetMouse().X, player:GetMouse().Y)
        			local v = (f2 - mouseloc).Magnitude
        			if v < closestdist then
        				closestdist = v
        				closestplr = plr
        				closestplrbody = playerchar.rootpart.Parent
        			end
        		end
		    end
		end
		
		if closestplr and closestplrbody then if closestplrbody:FindFirstChild("Head") then return closestplrbody, closestplr end end
		return false
	end

    game:GetService("UserInputService").InputBegan:Connect(function(a, b)
        if a.KeyCode == Enum[Main_Settings.aimbot.aimbotbind[1]][Main_Settings.aimbot.aimbotbind[2]] then
    		Aimbot_ENABLED = true
    		if Main_Settings.aimbot.aimatrandom then
    			currentshootat = tostring(HeadshotOrNot())
    		end
        elseif a.UserInputType == Enum[Main_Settings.aimbot.aimbotbind[1]][Main_Settings.aimbot.aimbotbind[2]] then
    		Aimbot_ENABLED = true
    		if Main_Settings.aimbot.aimatrandom then
    			currentshootat = tostring(HeadshotOrNot())
    		end
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(a, b)
        if a.KeyCode == Enum[Main_Settings.aimbot.aimbotbind[1]][Main_Settings.aimbot.aimbotbind[2]] then
            Aimbot_ENABLED = false
        elseif a.UserInputType == Enum[Main_Settings.aimbot.aimbotbind[1]][Main_Settings.aimbot.aimbotbind[2]] then
            Aimbot_ENABLED = false
        end
    end)

    game:GetService('RunService').Heartbeat:connect(function()
        if Aimbot_ENABLED and Main_Settings.aimbot.enabled then 
			local Target = GetClosestPlayer()
			if Target then
			    local aimAtpart = Target["Head"]
			    if Main_Settings.aimbot.aimatrandom then
			        aimAtpart = Target[tostring(currentshootat)]
			    else
			        aimAtpart = Target[tostring(Main_Settings.aimbot.aimat)]
			    end
			    local aimAt = game.workspace.CurrentCamera:WorldToScreenPoint(aimAtpart.Position)

				local mouseLocation = game.workspace.CurrentCamera:WorldToScreenPoint(MOUSE.Hit.p)
				local incrementX, incrementY = (aimAt.X - mouseLocation.X) / Main_Settings.aimbot.smoothness, (aimAt.Y - mouseLocation.Y) / Main_Settings.aimbot.smoothness

				if (isrbxactive) and isrbxactive() then
				    mousemoverel(incrementX, incrementY)
				elseif isrbxactive == nil then
				    mousemoverel(incrementX, incrementY)
				end
			end
        end
    end)
    
    game:GetService('RunService').Heartbeat:Connect(function()
        if Main_Settings.aimbot.autoshoot then
        	local Target = player:GetMouse().Target
        	local plrteam = Target.Parent.Parent.Name
        	
        	if Target.Name == "Head" or Target.Name == "Torso" or Target.Name == "Left Leg" or Target.Name == "Right Leg" or Target.Name == "Left Arm" or Target.Name == "Right Arm" then
            	if (plrteam == "Ghosts" or plrteam == "Phantoms") and plrteam ~= player.Team.Name then
                    mouse1press()
            		wait()
            		mouse1release()
            	end
        	end
    	end
    end)

	--///////////////////////////////////////////////////////////////////////--
	--                                 Mods                                  --
	--///////////////////////////////////////////////////////////////////////--
	
    for i,v in next, getgc(true) do
        if type(v) == "table" and rawget(v,'bullethit') and rawget(v,'breakwindow') then
            effects = v;
        end
    end
	
    local Mods_Catagory = Window:Category("Mods")
    local Mods_Sector = Mods_Catagory:Sector("Mods")
    
	Mods_Sector:Cheat("Label", "Respawn for them to take effect!")

		--NoRecoil
	local Mods_NoRecoilToggle = Mods_Sector:Cheat("Checkbox", "No Recoil", function(bool)
	    Main_Settings.mods1.norecoil = bool
		if bool then
			for i,v in pairs(game.ReplicatedStorage.GunModules:GetChildren()) do
				local mod = require(v) 
				--No Recoil
				mod["hipfirespread"] = 0
				mod["camkickmin"] = Vector3.new()
				mod["camkickmax"] = Vector3.new()
				mod["aimcamkickmin"] = Vector3.new()
				mod["aimcamkickmax"] = Vector3.new()
				mod["aimtranskickmin"] = Vector3.new()
				mod["aimtranskickmax"] = Vector3.new()
				mod["transkickmin"] = Vector3.new()
				mod["transkickmax"] = Vector3.new()
				mod["rotkickmin"] = Vector3.new()
				mod["rotkickmax"] = Vector3.new()
				mod["aimrotkickmin"] = Vector3.new()
				mod["aimrotkickmax"] = Vector3.new()
			end
		elseif bool == false then
			for i,v in pairs(game.ReplicatedStorage.GunModules:GetChildren()) do
				local mod = require(v);
				local backupmod = require(backupModules[v.Name]);
				--No Recoil
				mod["hipfirespread"] = backupmod["hipfirespread"]
				mod["camkickmin"] = backupmod["camkickmin"]
				mod["camkickmax"] = backupmod["camkickmax"]
				mod["aimcamkickmin"] = backupmod["aimcamkickmin"]
				mod["aimcamkickmax"] = backupmod["aimcamkickmax"]
				mod["aimtranskickmin"] = backupmod["aimtranskickmin"]
				mod["aimtranskickmax"] = backupmod["aimtranskickmax"]
				mod["transkickmin"] = backupmod["transkickmin"]
				mod["transkickmax"] = backupmod["transkickmax"]
				mod["rotkickmin"] = backupmod["rotkickmin"]
				mod["rotkickmax"] = backupmod["rotkickmax"]
				mod["aimrotkickmin"] = backupmod["aimrotkickmin"]
				mod["aimrotkickmax"] = backupmod["aimrotkickmax"]
			end
		end
	end, { ["enabled"] = Main_Settings.mods1.norecoil })

		--Instant Reload
	local Mods_InstantReloadToggle = Mods_Sector:Cheat("Checkbox", "Instant Reload", function(bool)
	    Main_Settings.mods1.instantreload = bool
		if bool then
			for i2,v2 in pairs(game.ReplicatedStorage.GunModules:GetChildren()) do
				pcall(function()
					local gunmod = require(v2)
					--Instant Reload
					for i,v in pairs(gunmod["animations"]) do
					    if i:lower():find("reload") then
					        v.timescale = 0
					    end
					end
				end)
			end
		elseif bool == false then
			for i2,v2 in pairs(game.ReplicatedStorage.GunModules:GetChildren()) do
				pcall(function()
					local gunmod = require(v2)
					local backupmod = require(backupModules[v2.Name]);
					--Instant Reload
					for i,v in pairs(gunmod["animations"]) do
					    if i:lower():find("reload") then
					        local old
        					for i3,v3 in pairs(backupmod["animations"]) do
        					    if i3:lower():find("reload") then
        					        old = v3
        					    end
        					end
        					v.timescale = old.timescale
					    end
					end
				end)
			end
		end
	end, { ["enabled"] = Main_Settings.mods1.instantreload })
	
		--No Reload
	local Mods_NoReloadToggle = Mods_Sector:Cheat("Checkbox", "No Reload", function(bool)
	    Main_Settings.mods1.noreload = bool
		if bool then
			for i,v in pairs(game.ReplicatedStorage.GunModules:GetChildren()) do
			    pcall(function()
    				local gunmod = require(v)
    				--No Reload
    				
    				local sparerounds = tonumber(gunmod["sparerounds"])
    				local magsize = tonumber(gunmod["magsize"])
    
    				gunmod["sparerounds"] = 0
    				gunmod["magsize"] = magsize + sparerounds
		        end)
			end
		elseif bool == false then
			for i,v in pairs(game.ReplicatedStorage.GunModules:GetChildren()) do
			    pcall(function()
    				local gunmod = require(v)
    				local backupmod = require(backupModules[v.Name]);
    				--No Reload
    				gunmod["magsize"] = backupmod["magsize"]
    				gunmod["sparerounds"] = backupmod["sparerounds"]
				end)
			end
		end
	end, { ["enabled"] = Main_Settings.mods1.noreload })
	
		--NoFallDamage
	local Mods_NoFallDamageToggle = Mods_Sector:Cheat("Checkbox", "No Fall Damage", function(bool)
		Main_Settings.mods1.nofalldamage = bool
	end, { ["enabled"] = Main_Settings.mods1.nofalldamage })
	
		--NoSpread
	local Mods_NoSpreadToggle = Mods_Sector:Cheat("Checkbox", "No Spread", function(bool)
	    Main_Settings.mods1.nospread = bool
		if bool then
			for i,v in pairs(game.ReplicatedStorage.GunModules:GetChildren()) do
				local mod = require(v) 
				--No Spread
				mod["hipfirespread"] = 0
				mod["hipfirespreadrecover"] = math.huge
				mod["hipfirestability"] = 0
			end
		elseif bool == false then
			for i,v in pairs(game.ReplicatedStorage.GunModules:GetChildren()) do
				local mod = require(v);
				local backupmod = require(backupModules[v.Name]);
				--No Spread
				mod["hipfirespread"] = backupmod["hipfirespread"]
				mod["hipfirespreadrecover"] = backupmod["hipfirespreadrecover"]
				mod["hipfirestability"] = backupmod["hipfirestability"]
			end
		end
	end, { ["enabled"] = Main_Settings.mods1.nospread })
	
		--Rapid Fire
	local Mods_RapidFireToggle = Mods_Sector:Cheat("Checkbox", "Fast Bullets", function(bool)
	    Main_Settings.mods1.rapidfire = bool
		if bool then
			for i,v in pairs(game.ReplicatedStorage.GunModules:GetChildren()) do
				local mod = require(v) 
				--Rapid Fire
				mod["bulletspeed"] = 3000
				mod["range0"] = 99999999999999999999999999999999
				mod["range1"] = 99999999999999999999999999999999
			end
		elseif bool == false then
			for i,v in pairs(game.ReplicatedStorage.GunModules:GetChildren()) do
				local mod = require(v);
				local backupmod = require(backupModules[v.Name]);
				--Rapid Fire
				mod["bulletspeed"] = backupmod["bulletspeed"]
				mod["range0"] = backupmod["range0"]
				mod["range1"] = backupmod["range1"]
			end
		end
	end, { ["enabled"] = Main_Settings.mods1.rapidfire })

		--Instant Knife
	local Mods_InstantKnifeToggle = Mods_Sector:Cheat("Checkbox", "Instant Knife", function(bool)
	    Main_Settings.mods1.instantknife = bool
		if bool then
			for i,v in pairs(game.ReplicatedStorage.GunModules:GetChildren()) do
				local mod = require(v)
				if mod["animations"]["stab1"] then
					mod["animations"]["stab1"].timescale = 0.1
					mod["animations"]["stab1"].resettime = 0.1
					mod["animations"]["stab1"].stdtimescale = 0.1
				end
				if mod["animations"]["stab2"] then
					mod["animations"]["stab2"].timescale = 0.1
					mod["animations"]["stab2"].resettime = 0.1
					mod["animations"]["stab2"].stdtimescale = 0.1
				end
				if mod["animations"]["quickstab"] then
					mod["animations"]["quickstab"].timescale = 0.1
					mod["animations"]["quickstab"].resettime = 0.1
					mod["animations"]["quickstab"].stdtimescale = 0.1
				end
				if mod["animations"]["spot"] then
					mod["animations"]["spot"].timescale = 0.1
					mod["animations"]["spot"].resettime = 0.1
					mod["animations"]["spot"].stdtimescale = 0.1
				end
			end
		elseif bool == false then
			for i,v in pairs(game.ReplicatedStorage.GunModules:GetChildren()) do
				local mod = require(v)
				local backupmod = require(backupModules[v.Name]);
				if mod["animations"]["stab1"] then
					mod["animations"]["stab1"].timescale = backupmod["animations"]["stab1"].timescale
					mod["animations"]["stab1"].resettime = backupmod["animations"]["stab1"].resettime
					mod["animations"]["stab1"].stdtimescale = backupmod["animations"]["stab1"].stdtimescale
				end
				if mod["animations"]["stab2"] then
					mod["animations"]["stab2"].timescale = backupmod["animations"]["stab1"].timescale
					mod["animations"]["stab2"].resettime = backupmod["animations"]["stab1"].resettime
					mod["animations"]["stab2"].stdtimescale = backupmod["animations"]["stab1"].stdtimescale
				end
				if mod["animations"]["quickstab"] then
					mod["animations"]["quickstab"].timescale = backupmod["animations"]["stab1"].timescale
					mod["animations"]["quickstab"].resettime = backupmod["animations"]["stab1"].resettime
					mod["animations"]["quickstab"].stdtimescale = backupmod["animations"]["stab1"].stdtimescale
				end
				if mod["animations"]["spot"] then
					mod["animations"]["spot"].timescale = backupmod["animations"]["stab1"].timescale
					mod["animations"]["spot"].resettime = backupmod["animations"]["stab1"].resettime
					mod["animations"]["spot"].stdtimescale = backupmod["animations"]["stab1"].stdtimescale
				end
			end
		end
	end, { ["enabled"] = Main_Settings.mods1.instantknife })

		--Fast Equip
	local Mods_FastEquipToggle = Mods_Sector:Cheat("Checkbox", "Fast Equip", function(bool)
	    Main_Settings.mods1.fastequip = bool
		if bool then
			for i,v in pairs(game.ReplicatedStorage.GunModules:GetChildren()) do
				local mod = require(v)
				mod["equipspeed"] = 35
			end
		elseif bool == false then
			for i,v in pairs(game.ReplicatedStorage.GunModules:GetChildren()) do
				local mod = require(v)
				local backupmod = require(backupModules[v.Name])
				mod["equipspeed"] = backupmod["equipspeed"]
			end
		end
	end, { ["enabled"] = Main_Settings.mods1.fastequip })
	
		--Grenade TP
	local Mods_GrenadeTPToggle = Mods_Sector:Cheat("Checkbox", "Grenade TP", function(bool)
	    Main_Settings.mods1.grenadetp = bool
	end, { ["enabled"] = Main_Settings.mods1.grenadetp })
	
		--Knife Aura
	local Mods_KnifeAuraToggle = Mods_Sector:Cheat("Checkbox", "Knife Aura (Equip a knife!)", function(bool)
	    Main_Settings.mods1.knifeaura = bool
	end, { ["enabled"] = Main_Settings.mods1.knifeaura })
    
    		--All Auto
	local Mods2_AllAutoToggle = Mods_Sector:Cheat("Checkbox", "All Auto", function(bool)
	    Main_Settings.mods2.allauto = bool
		if bool then
			for i,v in pairs(game.ReplicatedStorage.GunModules:GetChildren()) do
				local mod = require(v) 
				--All Auto
				mod["firemodes"] = {true, 2, 1}
			end
		elseif bool == false then
			for i,v in pairs(game.ReplicatedStorage.GunModules:GetChildren()) do
				local mod = require(v);
				local backupmod = require(backupModules[v.Name]);
				--All Auto
				mod["firemodes"] = backupmod["firemodes"]
			end
		end
	end, { ["enabled"] = Main_Settings.mods2.allauto })
	
		--Hide From Radar
	local Mods2_hidefromradarToggle = Mods_Sector:Cheat("Checkbox", "Hide From Radar", function(bool)
	    Main_Settings.mods2.hidefromradar = bool
		if bool then
			for i,v in pairs(game.ReplicatedStorage.GunModules:GetChildren()) do
				local mod = require(v) 
				--Hide From Radar
				mod["hideflash"] = true
				mod["hideminimap"] = true
				mod["hiderange"] = 0
			end
		elseif bool == false then
			for i,v in pairs(game.ReplicatedStorage.GunModules:GetChildren()) do
				local mod = require(v);
				local backupmod = require(backupModules[v.Name]);
				--Hide From Radar
				mod["hideflash"] = backupmod["hideflash"]
				mod["hideminimap"] = backupmod["hideminimap"]
				mod["hiderange"] = backupmod["hiderange"]
			end
		end
	end, { ["enabled"] = Main_Settings.mods2.hidefromradar })
	
		--No Sway
	local Mods2_NoSwayToggle = Mods_Sector:Cheat("Checkbox", "No Sway", function(bool)
	    Main_Settings.mods2.nosway = bool
		if bool then
			for i,v in pairs(game.ReplicatedStorage.GunModules:GetChildren()) do
				local mod = require(v) 
				--No Sway
				mod["swayamp"] = 0
				mod["swayspeed"] = 0
				mod["steadyspeed"] = 100
				mod["breathspeed"] = 0
			end
		elseif bool == false then
			for i,v in pairs(game.ReplicatedStorage.GunModules:GetChildren()) do
				local mod = require(v);
				local backupmod = require(backupModules[v.Name]);
				--No Sway
				mod["swayamp"] = backupmod["swayamp"]
				mod["swayspeed"] = backupmod["swayspeed"]
				mod["steadyspeed"] = backupmod["steadyspeed"]
				mod["breathspeed"] = backupmod["breathspeed"]
			end
		end
	end, { ["enabled"] = Main_Settings.mods2.nosway })
	
		--FireRate
	local Mods_FireRateSlider = Mods_Sector:Cheat("Slider", "Fire Rate", function(x)
        if loaded then
            Main_Settings.mods1.firerate = x
		    for i,v in pairs(game.ReplicatedStorage.GunModules:GetChildren()) do
			    local mod = require(v) 
			    --FireRate
			    mod["firerate"] = x
	    	end
		end
	end, { 
        ["default"] = Main_Settings.mods1.firerate,
		["min"] = 0, 
		["max"] = 1000, 
		["suffix"] = "rpm",
	})
	
		--Rainbow Gun
	local Mods_RainbowGun = Mods_Sector:Cheat("Button", "Rainbow Gun", function(bool)
		game:GetService("RunService").Stepped:Connect(function()
			for a,b in pairs(game.Workspace.Camera:GetChildren()) do 
				for c,d in pairs(game:GetService("ReplicatedStorage").GunModels:GetChildren()) do 
					if b.Name == d.Name then 
						for e,f in pairs(b:GetChildren()) do 
							if f:IsA("BasePart") then 
								f.Color = Color3.fromHSV(tick()%5/5,1,1)
								f.Material = Enum.Material.Neon
							end
						end
					end
				end
			end
		end)
	end)

	local Mods2_Sector = Mods_Catagory:Sector("Mods")

	--FireRate
	local Mods_GrenadeFuzeTimeSlider = Mods2_Sector:Cheat("Slider", "Grenade Fuze Time", function(x)
        if loaded then
            Main_Settings.mods1.granadefuzetime = x
		end
	end, { 
        ["default"] = Main_Settings.mods1.granadefuzetime,
		["min"] = 0, 
		["max"] = 10, 
		["suffix"] = "s",
	})

	local heartbeatwaitheh

	local physics
	local particle
	local __oldparticle
	local camera
    for i,v in next, getgc(true) do
		if type(v) == "table" and rawget(v,'step') and rawget(v,'reset') and rawget(v,'new') then
			particle = v
			__oldparticle = v.new
		end
		if type(v) == "function" then
            for k, x in pairs(debug.getupvalues(v)) do
                if type(x) == "table" then
                    if rawget(x, "basecframe") then
                       camera = x
                    end
                end
            end
        end
    end

    spawn(function()
        while true do
            heartbeatwaitheh = game:GetService("RunService").Heartbeat:Wait()
        end
    end)

	local aimatpart5 = "Head"

	local old = network.send

	wait()
	
	function BulletTracer(p1, p2)
		local beam = Instance.new("Part", game.Workspace)
		beam.Anchored = true
		beam.CanCollide = false
		beam.Material = Enum.Material.ForceField
		beam.Color = Color3.fromHSV(Main_Settings.visuals.visualscolor[1], Main_Settings.visuals.visualscolor[2], Main_Settings.visuals.visualscolor[3])
		beam.Size = Vector3.new(0.1, 0.1, (p1 - p2).magnitude)
		beam.CFrame = CFrame.new(p1, p2) * CFrame.new(0, 0, -beam.Size.Z / 2)
		
		spawn(function()
			for i = 1, 60 * 1.5 do
				game:GetService("RunService").RenderStepped:Wait()
				beam.Transparency = i / (60 * 1.5)
			end
			beam:Destroy()
		end)
	end

	network.send = function(self, ...)
		local args = {...}
		if string.find(args[1]:lower(), "falldamage") and Main_Settings.mods1.nofalldamage then
			return
		elseif string.find(args[1]:lower(), "newgrenade") then
			if Main_Settings.mods1.grenadetp then
				local erferfergfwf, wuyefuwef = GetClosestPlayer2()
				if (erferfergfwf ~= nil) and game:GetService("Players").LocalPlayer ~= wuyefuwef then
					args[3]["blowuptime"] = 0.007
					for i,v in pairs(args[3]["frames"]) do
						v["p0"] = erferfergfwf:FindFirstChild("Head").Position
					end
				end
				return old(self, unpack(args))
			else
				args[3]["blowuptime"] = Main_Settings.mods1.granadefuzetime
				return old(self, unpack(args))
			end
		elseif string.find(args[1]:lower(), "bullethit") then
			if args[4] ~= nil then
				if not Main_Settings.aimbot.aimatrandom then
					if (Main_Settings.aimbot.aimatrandom and Main_Settings.aimbot.headshotchange == 100) or Main_Settings.aimbot.aimat == "Head" then
						args[4] = args[4].Parent:FindFirstChild("Head")
					elseif (Main_Settings.aimbot.aimatrandom and Main_Settings.aimbot.headshotchange == 0) or Main_Settings.aimbot.aimat == "Torso" then
						args[4] = args[4].Parent:FindFirstChild("Torso")
					end
				elseif Main_Settings.aimbot.aimatrandom then
					if tostring(aimatpart5) == "Head" then 
						args[4] = args[4].Parent:FindFirstChild("Head")
					else
						args[4] = args[4].Parent:FindFirstChild("Torso")
					end
				end
			end
			return old(self, unpack(args))
		elseif string.find(args[1]:lower(), "newbullets") and gamelogic.currentgun then
			local targetbody, target = GetClosestPlayer()
			if targetbody and target and Main_Settings.aimbot.silentaim then
				if Main_Settings.aimbot.aimatrandom then
					aimatpart5 = tostring(HeadshotOrNot())
				else
					aimatpart5 = Main_Settings.aimbot.aimat
				end
				
				args[2]["firepos"] = camera.basecframe.Position
				args[2]["camerapos"] = camera.basecframe.Position

				for i,v in pairs(args[2]["bullets"]) do
					local tra, tra2 = trajectory(camera.basecframe.Position, Vector3.new(0, game.Workspace.Gravity, 0), targetbody[aimatpart5].Position, gamelogic.currentgun.data.bulletspeed)
					if tra then
						v[1] = tra
					end
				end

				old(self, unpack(args))

				local totaltimewaited = 0
				repeat
					totaltimewaited = totaltimewaited + heartbeatwaitheh
				until totaltimewaited >= ((targetbody[aimatpart5].Position - camera.basecframe.Position).Magnitude / gamelogic.currentgun.data.bulletspeed)
				
				for i,v in pairs(args[2]["bullets"]) do
					if target and targetbody[aimatpart5].Position and targetbody[aimatpart5] and v[2] then
						network.send(self, unpack({"bullethit", target, targetbody[aimatpart5].Position, targetbody[aimatpart5], v[2]}))
					end
				end

				for i,v in pairs(args[2]["bullets"]) do
					if Main_Settings.visuals.bullettracers then
						BulletTracer(gamelogic.currentgun.barrel.Position, targetbody[aimatpart5].Position)
					end
				end

				return 
			elseif not Main_Settings.aimbot.silentaim then
				old(self, unpack(args))

				for i,v in pairs(args[2]["bullets"]) do
					if Main_Settings.visuals.bullettracers then
						BulletTracer(gamelogic.currentgun.barrel.Position, game:GetService("Players").LocalPlayer:GetMouse().Hit.Position)
					end
				end

				return
			end
		else
			return old(self, unpack(args))
		end
	end
	
	game:GetService("RunService").RenderStepped:connect(function()
        if game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and Main_Settings.mods1.knifeaura then
            if (gamelogic.currentgun) and gamelogic.currentgun.type == "KNIFE" then
                local pos = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position
                for i, player in next, game:GetService("Players"):GetPlayers() do
                    local playerchar = getbodyparts(player)
                    if player ~= game:GetService("Players").LocalPlayer and player.Team ~= game:GetService("Players").LocalPlayer.Team and playerchar and rawget(playerchar, "rootpart") then
                        local root = playerchar.rootpart;
                        if root then
                            local distance = math.floor((pos - root.Position).magnitude)
                            if distance <= 50 then
                                network.send(self, "knifehit", player, tick(), playerchar.rootpart.Parent.Head)
                            end
                        end
                    end
                end
            end
        end
    end)
	
	--///////////////////////////////////////////////////////////////////////--
	--                                Other                                  --
	--///////////////////////////////////////////////////////////////////////--
	
    local Other_Catagory = Window:Category("Other")
    local Other_Sector = Other_Catagory:Sector("Other")
	
		--Speed
	local Other_SpeedSlider = Other_Sector:Cheat("Slider", "Walk Speed", function(x)
	    if loaded then
    		Main_Settings.other.walkspeed = x
	    end
	end, {
        ["default"] = Main_Settings.other.walkspeed,
		["min"] = 0,
		["max"] = 100,
		["suffix"] = "",
	})
	
		--JumpPower
	local Other_JumpSlider = Other_Sector:Cheat("Slider", "Jump Power", function(x)
	    if loaded then
    		Main_Settings.other.jumppower = x
	    end
	end, { 
        ["default"] = Main_Settings.other.jumppower,
		["min"] = 0, 
		["max"] = 100, 
		["suffix"] = "",
	})
	
		--Infinite Jump
	local Other_InfJumpToggle = Other_Sector:Cheat("Checkbox", "Infinite Jump", function(bool)
		Main_Settings.other.infinitejump = bool
	end, { ["enabled"] = Main_Settings.other.infinitejump})

		--Fullbright
	local Other_FullBrightToggle = Other_Sector:Cheat("Checkbox", "Fullbright", function(bool)
	    Main_Settings.other.fullbright = bool
		if bool then
			game:GetService("Lighting").GlobalShadows = false
			game:GetService("Lighting").Brightness = 10
		elseif bool == false then
			game:GetService("Lighting").GlobalShadows = true
			game:GetService("Lighting").Brightness = 1
		end
	end, { ["enabled"] = Main_Settings.other.fullbright})

		--Break All Windows
	local Other_BreakAllWindowsButton = Other_Sector:Cheat("Button", "Break All Windows", function()
        for i,v in next, workspace:GetDescendants() do
            if v.Name:lower() == "window" then
                local window = v
                effects.breakwindow(window, window, nil, true, true, nil, nil, nil)
            end
        end
	end)
	
		--Save Settings
	local Other_SaveSettingsButton = Other_Sector:Cheat("Button", "Save Current Settings", function()
        saveSettings()
        WriteToConsole("Saved Settings")
        game.StarterGui:SetCore("SendNotification", {
            Title = "Avlon Hub",
            Text = "Saved Settings",
            Icon = "rbxassetid://4909973011",
            Duration = 5,
        })
	end)

	
	function getbasewalkspeed()
		for a,b in pairs(getgc(true)) do
			if typeof(b) == "table" and rawget(b,"setbasewalkspeed") then
				return b
			end
		end
	end
	local getbasewalkspeed2 = getbasewalkspeed()
	
	
	game:GetService("RunService").RenderStepped:Connect(function()
		getbasewalkspeed2:setbasewalkspeed(Main_Settings.other.walkspeed)
		if PLAYER.Character ~= nil then
			if PLAYER.Character.Humanoid.JumpPower ~= Main_Settings.other.jumppower * 2 then
				PLAYER.Character.Humanoid.JumpPower = Main_Settings.other.jumppower * 2
			end
		end
	end)
	
	game:GetService("UserInputService").InputBegan:Connect(function(i)
		if i.KeyCode == Enum.KeyCode.Space and Main_Settings.other.infinitejump then
			game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid"):ChangeState("Jumping")
			wait()
			game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid"):ChangeState("Seated")
		end
	end)

	loaded = true
	WriteToConsole("Loaded")
else
	game:GetService("Players").LocalPlayer:Kick("Your exploit does not support all the functions this script needs!")
end 
