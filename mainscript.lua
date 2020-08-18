print("Loading AvlonHub!")
if game.PlaceId == 292439477 then
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Spoorloos/avlonhub/master/phantomforces.lua", true))()
else
  game.Players.LocalPlayer:Kick("We do not support this game!")
end
