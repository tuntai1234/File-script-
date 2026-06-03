local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "GUI của Tài",
    LoadingTitle = "Đang tải...",
    LoadingSubtitle = "By Tài",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "TaiGUI",
        FileName = "Config"
    }
})

local HomeTab = Window:CreateTab("Home", 4483362458)
local MainTab = Window:CreateTab("Main", 4483362458)

local BloxFruitsTab = Window:CreateTab("Blox Fruits", 4483362458)

 HomeTab:CreateParagraph({
    Title = "Description",
    Content = "Đây là script của Tai cũng sẽ là nơi chứa những script mới về nhiều tự game"
})
 MainTab:CreateButton({
    Name = "Fly+speed",
 Info = "Đây là script kết hợp giữa fly và speed",
Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/Kvy3Oi1Z/raw"))()
    end
})
 MainTab:CreateButton({
    Name = "Hitbox",
 Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/ItfO0tdg/raw"))()
    end
})
BloxFruitsTab:CreateButton({
    Name = "Quantum",
 Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))()
    end
})
BloxFruitsTab:CreateButton({
    Name = "RealKidhub",
 Callback = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/main.lua"))() 
    end
})
BloxFruitsTab:CreateButton({
    Name = "Ok Hub",
 Callback = function()
       getgenv().team = "Pirates" -- Marines
loadstring(game:HttpGet("https://raw.githubusercontent.com/fakekuri/Okhubhere/refs/heads/main/MainBloxFruit.lua"))()
    end
})
MainTab:CreateButton({
    Name = "Esp",
 Callback = function()
        loadstring(game:HttpGet("https://obj.wearedevs.net/140060/scripts/Universal%20ESP.lua"))()
    end
})
MainTab:CreateButton({
    Name = "Noclip",
 Callback = function()
        loadstring(game:HttpGet("https://obj.wearedevs.net/197981/scripts/roblox%20noclip%20GUI.lua"))()
    end
} 
    MainTab:CreateButton({
    Name = "click to Teleport",
 Callback = function()
        loadstring(game:HttpGet("https://obj.wearedevs.net/2/scripts/Click%20Teleport.lua"))()
})
MainTab:CreateButton({
    Name = "7yd7 emote",
 Callback = function()
        loadstring(game:HttpGet("https://obj.wearedevs.net/s/69eb7c19da685847149709a5.lua"))()
    end
})
