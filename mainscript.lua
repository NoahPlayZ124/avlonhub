print("Loading AvlonHub!")
if game.PlaceId == 292439477 then
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Spoorloos/avlonhub/master/phantomforces.lua", true))()
elseif game.PlaceId == 286090429 then
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Spoorloos/avlonhub/master/arsenal.lua", true))()
else
  game.Players.LocalPlayer:Kick("We do not support this game!")
end
