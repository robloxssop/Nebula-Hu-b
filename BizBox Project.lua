local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

if gameName == "BizBlox (Rework) The Sun, Hermit Purple" then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/robloxssop/Nebula-Hu-b/refs/heads/main/%E0%B8%8A.lua"))()
elseif mapName == "BizBlox (Rework) - Italy" then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/robloxssop/Nebula-HUB/refs/heads/main/Bizbox.lua"))()
else
    print("Map not recognized!")
end
