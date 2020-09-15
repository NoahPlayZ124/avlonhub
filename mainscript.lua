print("Loading AvlonHub!")
if game.PlaceId == 292439477 then
  if _G.UnstablePF == true then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Spoorloos/avlonhub/master/PFv2(unstable).lua", true))()
  else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Spoorloos/avlonhub/master/phantomforces.lua", true))()
  end
--elseif game.PlaceId == 286090429 then
  --loadstring(game:HttpGet("https://raw.githubusercontent.com/Spoorloos/avlonhub/master/arsenal.lua", true))()
else
  game.Players.LocalPlayer:Kick("\n\n\n\nWe do not support this game!\n\nSupported Games:\n- Phantom Forces\n\n\n\n")
end
