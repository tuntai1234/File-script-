local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "GUI Tổng hợp",
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
MainTab:CreateSection("Di chuyển")
 MainTab:CreateButton({
    Name = "Fly+speed",
 Info = "Đây là script kết hợp giữa fly và speed",
Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/Kvy3Oi1Z/raw"))()
    end
})
 
 MainTab:CreateButton({
    Name = "Teleport Menu",
    Callback = function()
loadstring(game:HttpGet("http s://pastefy.app/2JPFITBm/raw"))()
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
    Name = "click to tp",
 Callback = function()

loadstring(game:HttpGet("https://pastefy.app/lpQi8X5W/raw"))()
    end
})
MainTab:CreateButton({
    Name = "nocilp",
 Callback = function()
        loadstring(game:HttpGet("https://obj.wearedevs.net/197981/scripts/roblox%20noclip%20GUI.lua"))()
    end
})
    MainTab:CreateSection("-Giải trí-")   
MainTab:CreateButton({
    Name = "HÀNH ĐỘNG",
 Callback = function()
        loadstring(game:HttpGet("https://obj.wearedevs.net/s/69eb7c19da685847149709a5.lua"))()
    end
})
MainTab:CreateButton({
    Name = "F3X",
 Callback = function()
        loadstring(game:GetObjects("rbxassetid://6695644299")[1].Source)()
end
})
MainTab:CreateButton({
    Name = "Dev",
    Callback = function() 
        loadstring(game:HttpGet("https://obj.wearedevs.net/216234/scripts/NDex%20V1.lua"))() 
    end 
    })
MainTab:CreateButton({
    Name = "Infinite Jump",
    Callback = function()
        loadstring(game:HttpGet("https://obj.wearedevs.net/2/scripts/Infinite%20Jump.lua"))()
    end 
    })
MainTab:CreateButton({
    Name = "Spectator UI",
    Callback = function ()
loadstring(game:HttpGet("https://pastefy.app/NItddEld/raw"))()
end 
})
MainTab:CreateButton({
    Name = "AFEM Max",
    Callback = function ()
loadstring(game:HttpGet("https://pastefy.app/JsslxxA0/raw"))()
end 
})
MainTab:CreateSection("Troll player")
MainTab:CreateButton({
    Name = "The real drop kick",
    Callback = function ()
        --[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
loadstring(game:HttpGet("https://raw.githubusercontent.com/platinww/CrustyMain/refs/heads/main/universal/DropKick.lua"))()
end 
})



MainTab:CreateSection("Hỗ trợ")
MainTab:CreateButton({
    Name = "Hitbox",
 Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/ItfO0tdg/raw"))()
    end
})
MainTab:CreateButton({
    Name = "Esp",
 Callback = function()
        loadstring(game:HttpGet("https://obj.wearedevs.net/140060/scripts/Universal%20ESP.lua"))()
    end
})
local Main2Tab = Window:CreateTab("Build a ring farm", 4483362458)
Main2Tab:CreateButton({
    Name = "Lumin hub có key",
    Callback = function ()
loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/8da261b727dc63189ee28f426e37ffb2.lua"))()
end 
})
Main2Tab:CreateButton({
    Name = "Void Hub No key",
    Callback = function ()
loadstring(game:HttpGet("https://pastefy.app/SGy4snSo/raw"))()

end 
})
