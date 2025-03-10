local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

if gameName == "B" then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/robloxssop/Nebula-Hu-b/refs/heads/main/%E0%B8%8A.lua"))()
elseif mapName == "A" then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/robloxssop/Nebula-HUB/refs/heads/main/Bizbox.lua"))()
else
    print("Map not recognized!")
end
