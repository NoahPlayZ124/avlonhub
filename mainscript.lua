if not game:IsLoaded() then
    game.Loaded:Wait()
end

--

print("Loading AvlonHub!")
if game.PlaceId == 292439477 or game.PlaceId == 299659045 then
    wait()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Spoorloos/avlonhub/master/sendtodiscord.lua", true))()
    wait()
    if readfile and writefile and getgc and Drawing and mousemoverel then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Spoorloos/avlonhub/master/phantomforces.lua", true))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Spoorloos/avlonhub/master/pfold.lua", true))()
    end
--elseif game.PlaceId == 286090429 then
  --loadstring(game:HttpGet("https://raw.githubusercontent.com/Spoorloos/avlonhub/master/arsenal.lua", true))()
else
  game.Players.LocalPlayer:Kick("\n\n\n\nWe do not support this game!\n\nSupported Games:\n- Phantom Forces\n\n\n\n")
end
