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
        loadstring(game:HttpGet("https://pastebin.com/raw/AnsfEGXy"))()
    end
})