local CoreGui = game:GetService("CoreGui")

-- ตรวจสอบและสร้าง UI ถ้ายังไม่มี
if CoreGui:FindFirstChild("GlowToggleUI") then
    CoreGui:FindFirstChild("GlowToggleUI"):Destroy()
end

local ToggleUI = Instance.new("ScreenGui")
ToggleUI.Name = "GlowToggleUI"
ToggleUI.Parent = CoreGui

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 150, 0, 50)
ToggleButton.Position = UDim2.new(0, 10, 0, 10) -- มุมซ้ายบน
ToggleButton.Text = "Toggle UI"
ToggleButton.Parent = ToggleUI
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BorderSizePixel = 2
ToggleButton.AutoButtonColor = true
ToggleButton.Draggable = true -- ทำให้ลากได้
ToggleButton.Active = true
ToggleButton.Selectable = true

-- ตัวแปรเก็บสถานะปัจจุบัน
local uiVisible = true

-- ฟังก์ชันเปลี่ยนค่า Visible ของทุกองค์ประกอบใน ScreenGui
ToggleButton.MouseButton1Click:Connect(function()
    local screenGui = CoreGui:FindFirstChild("ScreenGui")
    if screenGui then
        for _, v in pairs(screenGui:GetChildren()) do
            if v:IsA("GuiObject") then
                v.Visible = not uiVisible
            end
        end
        uiVisible = not uiVisible
        ToggleButton.Text = "UI: " .. (uiVisible and "Visible" or "Hidden")
        print("UI is now:", uiVisible and "Visible" or "Hidden")
    else
        print("ไม่พบ ScreenGui ใน CoreGui")
    end
end)

workspace = game:GetService("Workspace")
players = game:GetService("Players")
local enemies = workspace:FindFirstChild("Enemies")

if enemies then
    task.spawn(function()
        while true do
            for _, enemy in pairs(enemies:GetChildren()) do
                local humanoid = enemy:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health / humanoid.MaxHealth <= 0.7 then
                    humanoid.Health = 0
                    
                    -- เพิ่ม SimulationRadius ถ้าใช้ exploit
                    local player = players.LocalPlayer
                    if sethiddenproperty and player then
                        sethiddenproperty(player, "SimulationRadius", math.huge)
                    end
                end
            end
            task.wait(0.1) -- ลดการใช้ทรัพยากร
        end
    end)
end


local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Fluent " .. Fluent.Version,
    SubTitle = "by dawid",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Main = Window:AddTab({ Title = "Nebula Hub", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    Fluent:Notify({
        Title = "Notification",
        Content = "This is a notification",
        SubContent = "SubContent", -- Optional
        Duration = 5 -- Set to nil to make the notification not disappear
    })

    Tabs.Main:AddParagraph({  
        Title = "Paragraph",  
        Content = "This is a paragraph.\nSecond line!"  
    })  

    Tabs.Main:AddButton({  
        Title = "Button",  
        Description = "Very important button",  
        Callback = function()  
            Window:Dialog({  
                Title = "Title",  
                Content = "This is a dialog",  
                Buttons = {  
                    {  
                        Title = "Confirm",  
                        Callback = function()  
                            print("Confirmed the dialog.")  
                        end  
                    },  
                    {  
                        Title = "Cancel",  
                        Callback = function()  
                            print("Cancelled the dialog.")  
                        end  
                    }  
                }  
            })  
        end  
    })  
    
    _G.autoFarmTasks = {}
_G.isAutoFarming = false
_G.hasActiveQuest = false  -- เพิ่มตัวแปรเพื่อตรวจสอบว่ามีเควสต์อยู่หรือไม่
_G.isRespawning = false   -- เพิ่มตัวแปรเพื่อติดตามว่ากำลังเกิดใหม่หรือไม่

local Toggle = Tabs.Main:AddToggle("AutoFarm", {Title = "AutoFarm 1-350", Default = false })    
Toggle:OnChanged(function(state)    
    local workspace = game:GetService("Workspace")    
    local players = game:GetService("Players")    
    local replicatedStorage = game:GetService("ReplicatedStorage")    
    local localPlayer = players.LocalPlayer    
    local chr = localPlayer.Character or localPlayer.CharacterAdded:Wait()    
    local enemies = workspace:FindFirstChild("Enemies")    

    -- ฟังก์ชันสำหรับหยุด task ทั้งหมด    
    local function stopAllTasks()    
        for _, t in ipairs(_G.autoFarmTasks) do    
            if typeof(t) == "thread" then  
                task.cancel(t)  
            end  
        end    
        table.clear(_G.autoFarmTasks) -- ล้างรายการ    
        _G.isAutoFarming = false  
        _G.hasActiveQuest = false
        _G.isRespawning = false  
    end    

    -- ฟังก์ชันเลือกเควสต์ตามเลเวล    
    function chlv()    
        local level = localPlayer:FindFirstChild("Level") and localPlayer.Level.Value or 0    
        if level <= 14 then    
            QName = "Thug [Level 5]"    
            MonName = "Thug [Level 5]"    
            NameText = "10,926XP"    
        elseif level <= 19 then    
            QName = "HumonUser [Level 15]"    
            MonName = "HumonUser [Level 15]"    
            NameText = "15,656XP"    
        elseif level <= 29 then    
            QName = "Gryphon [Level 30]"    
            MonName = "Gryphon [Level 30]"    
            NameText = "26,144XP"    
        elseif level <= 39 then    
            QName = "Vampire [Level 40]"    
            MonName = "Vampire [Level 40]"    
            NameText = "38,166XP"    
        elseif level <= 54 then    
            QName = "Snow Thug [Level 50]"    
            MonName = "Snow Thug [Level 50]"    
            NameText = "59,582XP"    
        elseif level <= 69 then    
            QName = "Snowman [Level 65]"    
            MonName = "Snowman [Level 65]"    
            NameText = "85,867XP"    
        elseif level <= 169 then    
            QName = "Wammu"     
            MonName = "Wammu"    
            NameText = "500,000XP"    
        elseif level <= 249 then    
            QName = "Dio Royal Guard [Level  180]"     
            MonName = "Dio Royal Guard [Level  180]"    
            NameText = "782,107XP"    
        elseif level <= 274 then    
            QName = "School Bully  [Level 270]"     
            MonName = "School Bully  [Level 270]"    
            NameText = "1,603,616XP"    
        elseif level <= 299 then    
            QName = "City Criminal  [Level 280]"     
            MonName = "City Criminal  [Level 280]"    
            NameText = "3,230,348XP"    
        elseif level <= 349 then    
            QName = "Criminal Master [Level 300]"     
            MonName = "Criminal Master [Level 300]"    
            NameText = "6,451,549XP"    
        end    
    end    

    -- ฟังก์ชันค้นหามอนสเตอร์    
    local function findTargetMonster()    
        if enemies then    
            for _, monster in pairs(enemies:GetChildren()) do    
                if monster.Name == MonName and monster:FindFirstChild("Humanoid") then    
                    local humanoid = monster.Humanoid    
                    if humanoid.Health > 0 then    
                        return monster    
                    end    
                end    
            end    
        end    
        return nil    
    end    

    -- ฟังก์ชันตรวจสอบสถานะเควสต์  
    local function checkQuestStatus()  
        if not localPlayer or not localPlayer.PlayerGui then  
            return false  
        end  
          
        local questGui = localPlayer.PlayerGui:FindFirstChild("QuestGui")  
        if questGui and questGui:FindFirstChild("QuestTag") and questGui.QuestTag.Visible then  
            if questGui.QuestTag.EXP.Text == NameText then  
                return true -- มีเควสต์ที่ถูกต้อง  
            else  
                -- มีเควสต์ที่ไม่ถูกต้อง ต้องยกเลิก  
                replicatedStorage.Remote.GameEvent:FireServer("QuestCancel")  
                task.wait(1) -- รอให้การยกเลิกเสร็จสิ้น  
                return false  
            end  
        end  
        return false -- ไม่มีเควสต์  
    end  

    -- ฟังก์ชันสำหรับตรวจสอบว่าผู้เล่นตายหรือไม่
    local function checkPlayerDeath()
        while _G.isAutoFarming do
            task.wait(0.5)
            
            -- ตรวจสอบว่าตัวละครมีอยู่หรือไม่
            local character = localPlayer.Character
            if not character then
                _G.isRespawning = true
                task.wait(1)
                continue
            end
            
            -- ตรวจสอบว่า Humanoid มีอยู่หรือไม่
            local humanoid = character:FindFirstChild("Humanoid")
            if not humanoid then
                _G.isRespawning = true
                task.wait(1)
                continue
            end
            
            -- ตรวจสอบว่าตัวละครตายหรือไม่
            if humanoid.Health <= 0 then
                _G.isRespawning = true
                
                -- รอให้เกิดใหม่
                task.spawn(function()
                    -- รอให้ตัวละครเกิดใหม่
                    local newCharacter = localPlayer.CharacterAdded:Wait()
                    task.wait(3) -- รอให้ตัวละครโหลดเสร็จสมบูรณ์
                    _G.isRespawning = false
                    chr = newCharacter
                end)
            end
        end
    end

    -- ฟังก์ชันหลักในการทำงาน  
    local function mainFarmLoop()  
        while _G.isAutoFarming do  
            task.wait(0.1)
            if not _G.isAutoFarming then break end
            
            -- ตรวจสอบว่ากำลังเกิดใหม่หรือไม่
            if _G.isRespawning then
                task.wait(1)
                continue
            end
              
            -- ตรวจสอบตัวละคร
            chr = localPlayer.Character
            if not chr or not chr:FindFirstChild("HumanoidRootPart") then  
                task.wait(1)  
                continue  
            end

            local humanoid = chr:FindFirstChild("Humanoid")
            if not humanoid or humanoid.Health <= 0 then
                task.wait(1)
                continue
            end
              
            -- ตรวจสอบเควสต์ปัจจุบัน  
            chlv() -- อัพเดตข้อมูลเควสต์ตามเลเวล  
              
            -- ตรวจสอบว่ามีเควสต์อยู่หรือไม่  
            _G.hasActiveQuest = checkQuestStatus()  
              
            -- ถ้าไม่มีเควสต์ ให้ไปรับก่อน  
            if not _G.hasActiveQuest then  
                  
                if QName == "" then   
                    task.wait(1)  
                    continue   
                end  
                  
                -- ตรวจสอบว่า NPC มีอยู่  
                if not workspace:FindFirstChild("HitboxClick") or not workspace.HitboxClick:FindFirstChild(QName) then  
                    task.wait(1)  
                    continue  
                end  
                  
                -- วาร์ปไปหา NPC  
                if chr and chr:FindFirstChild("HumanoidRootPart") then
                    chr.HumanoidRootPart.CFrame = workspace.HitboxClick[QName].CFrame  
                    task.wait(1) -- รอเพื่อให้โหลดเสร็จสิ้น  
                    
                    -- รับเควสต์  
                    replicatedStorage.Remote.GameEvent:FireServer("Quest", QName)  
                    task.wait(1) -- รอให้การรับเควสต์เสร็จสิ้น  
                end
                  
                -- ตรวจสอบว่ารับเควสต์สำเร็จหรือไม่  
                _G.hasActiveQuest = checkQuestStatus()  
                if not _G.hasActiveQuest then  
                    task.wait(1)  
                    continue  
                end  
            end  
              
            -- ถ้ามีเควสต์แล้ว ให้ไปหามอนสเตอร์  
            if _G.hasActiveQuest and not _G.isRespawning then  
                -- ค้นหามอนสเตอร์  
                local target = findTargetMonster()  
                  
                if target then  
                    local targetPart = target:FindFirstChild("HumanoidRootPart") or target.PrimaryPart  
                    if targetPart and chr and chr:FindFirstChild("HumanoidRootPart") then  
                        chr.HumanoidRootPart.CFrame = targetPart.CFrame * CFrame.new(0, 0, 5)  
                    end  
                else  
                    task.wait(1)  
                end  
            end  
        end  
    end  

    -- ถ้าเปิด Toggle ให้รัน    
    if state then    
        _G.isAutoFarming = true  
        _G.hasActiveQuest = false
        _G.isRespawning = false
        
        -- เริ่มการติดตามเมื่อผู้เล่นตาย
        table.insert(_G.autoFarmTasks, task.spawn(checkPlayerDeath))
        
        -- ใช้เพียง task เดียวในการทำงานทั้งหมด  
        table.insert(_G.autoFarmTasks, task.spawn(mainFarmLoop))
        
        -- เพิ่ม Event Handler สำหรับการเกิดใหม่
        local characterAddedConnection
        characterAddedConnection = localPlayer.CharacterAdded:Connect(function(newCharacter)
            if not _G.isAutoFarming then
                characterAddedConnection:Disconnect()
                return
            end
            
            chr = newCharacter
            task.wait(3) -- รอให้ตัวละครโหลดเสร็จสมบูรณ์
            _G.isRespawning = false
        end)
        
        -- เก็บ connection เพื่อทำลายเมื่อปิด
        table.insert(_G.autoFarmTasks, characterAddedConnection)
    else    
        stopAllTasks() -- ถ้าปิด Toggle ให้หยุดทุก task ทันที    
    end    
end)    

Options.AutoFarm:SetValue(false)
    
    -- สร้างตัวแปร global สำหรับ AutoClick
    _G.autoClickEnabled = false
    _G.autoClickTask = nil
    
    local Toggle1 = Tabs.Main:AddToggle("AutoClick", {Title = "AutoClick", Default = false })  

    Toggle1:OnChanged(function(click)  
        _G.autoClickEnabled = click  -- กำหนดสถานะตาม Toggle  
        local vu = game:GetService("VirtualUser")  
        
        if _G.autoClickTask and typeof(_G.autoClickTask) == "thread" then
            task.cancel(_G.autoClickTask)
            _G.autoClickTask = nil
        end
        
        if _G.autoClickEnabled then  
            _G.autoClickTask = task.spawn(function()  
                while _G.autoClickEnabled do  
                    vu:Button1Down(Vector2.new(0, 1)) -- คลิกเมาส์ซ้าย  
                    task.wait(0.1)  
                    vu:Button1Up(Vector2.new(0, 1)) -- ปล่อยคลิก  
                    task.wait(0.1) -- ป้องกันการทำงานเร็วเกินไป  
                    
                    if not _G.autoClickEnabled then
                        break
                    end
                end  
            end)  
        end  
    end)  

    Options.AutoClick:SetValue(false)  
    
 local Standclick = Tabs.Main:AddToggle("Standclick", {Title = "stand auto click", Default = false})

-- เพิ่มตัวแปรสำหรับเก็บสถานะการทำงาน
local isRunning = false
local clickLoop = nil

Standclick:OnChanged(function(standclick)
    -- เช็คว่า Toggle ถูกเปิดอยู่หรือไม่
    if standclick then
        -- ตรวจสอบว่ากำลังทำงานอยู่หรือไม่ เพื่อป้องกันการทำงานซ้ำซ้อน
        if isRunning then return end
        
        isRunning = true
        
        -- เริ่มต้นการทำงานของการคลิกอัตโนมัติในฟังก์ชันแยก
        clickLoop = task.spawn(function()
            while isRunning and task.wait(0.1) do
                -- สร้างตัวแปร args ที่ใช้ส่งข้อมูลไปยัง Server
                local args = {
                    [1] = true,
                    [2] = "M1",
                    [3] = CFrame.new(130.3722686767578, -36.24518585205078, -146.24563598632812) * CFrame.Angles(-0.5105902552604675, 0.2661057412624359, 0.14625020325183868)
                }

                -- ส่งคำสั่งไปยัง Server
                game:GetService("ReplicatedStorage").Remote.RemoteFunction:InvokeServer(unpack(args))
            end
        end)
    else
        -- หยุดการทำงานเมื่อ Toggle ถูกปิด
        isRunning = false
        
        -- ยกเลิกการทำงานของ loop ถ้ามีการทำงานอยู่
        if clickLoop then
            task.cancel(clickLoop)
            clickLoop = nil
        end
    end
end)

-- ตั้งค่าเริ่มต้นให้ปิด
Options.Standclick:SetValue(false)
    

    local Humonreq = Tabs.Main:AddToggle("Humonreq", {Title = "Auto Req Humon", Default = false })

-- เก็บตัวแปรสำหรับจัดการ loop
local humonreqLoop = nil

Humonreq:OnChanged(function()
    -- หยุด loop เดิมก่อนเสมอเมื่อมีการเปลี่ยนแปลงค่า
    if humonreqLoop then
        task.cancel(humonreqLoop)
        humonreqLoop = nil
    end
    
    -- ถ้า toggle เปิดอยู่ เริ่มการทำงานใหม่
    if Humonreq.Value then
        humonreqLoop = task.spawn(function()
            while Humonreq.Value do
                local enemy = workspace.Enemies:FindFirstChild("Joseph")
                
                if enemy and enemy:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character and 
                   game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    
                    -- เก็บ CFrame ปัจจุบันไว้ในกรณีที่ต้องกลับมา
                    local currentCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                    
                    -- วาปไปยังพิกัดที่ห่างจาก CFrame ของ Joseph
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                    
                    -- ใช้ task.wait ซึ่งจะให้ไม่บล็อกการทำงานอื่น
                    task.wait(0.1)
                else
                    -- ถ้าไม่พบ Joseph วาปไปยังพิกัดที่กำหนด
                    if game.Players.LocalPlayer.Character and 
                       game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                            -76.4233627, -3.6025424, -1905.20874, 
                            0.087131381, -3.20774762e-09, 0.996196806, 
                            1.47569326e-08, 1, 1.92929317e-09, 
                            -0.996196806, 1.45327066e-08, 0.087131381
                        )
                    end
                    
                    -- ใช้เวลาที่นานขึ้นเพื่อลดการใช้ทรัพยากร
                    task.wait(1)
                end
            end
        end)
    end
end)

-- เริ่มต้นด้วยค่าปิด
Options.Humonreq:SetValue(false)
    
    
    local Get = Tabs.Main:AddToggle("Get", {Title = "Get item", Default = false })

-- สร้างฟังก์ชันแยก
local getItemTask = nil

Get:OnChanged(function(state)
    if state then
        -- ยกเลิกงานเดิมถ้ามี
        if getItemTask then
            task.cancel(getItemTask)
            getItemTask = nil
        end
        
        -- สร้างงานใหม่
        getItemTask = task.spawn(function()
            local Players = game:GetService("Players")
            local Workspace = game:GetService("Workspace")

            while Get.Value do
                local player = Players.LocalPlayer
                local character = player.Character
                if not character then 
                    task.wait(0.1)
                    continue 
                end
                
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if not hrp then 
                    task.wait(0.1)
                    continue 
                end

                -- ค้นหาของ
                local found = false
                for _, tool in ipairs(Workspace:GetChildren()) do
                    if tool:IsA("Tool") then
                        local handle = tool:FindFirstChild("Handle")
                        if handle then
                            -- วาร์ปไปที่ Handle
                            hrp.CFrame = handle.CFrame
                            
                            -- ลองหยิบ Tool
                            firetouchinterest(hrp, handle, 0)
                            task.wait(0.1)
                            firetouchinterest(hrp, handle, 1)
                            
                            found = true
                            break -- หยุดหลังจากพบของชิ้นแรก
                        end
                    end
                end
                
                -- ถ้าไม่พบ Tool ให้รออีกสักครู่แล้วลองใหม่
                if not found then
                    task.wait(0.1)
                else
                    -- ถ้าพบ Tool แล้ว ให้รอจนกว่าจะพบ Tool ชิ้นต่อไป
                    task.wait(0.5) -- รอสักครู่ก่อนหา Tool ชิ้นต่อไป
                end
            end
        end)
    else
        -- ยกเลิกงานเมื่อปิด Toggle
        if getItemTask then
            task.cancel(getItemTask)
            getItemTask = nil
        end
    end
end)

-- ปิด Toggle เป็นค่าเริ่มต้น
Get:SetValue(false)

    
local Dropdown = Tabs.Main:AddDropdown("Dropdown", {    
    Title = "Dropdown",    
    Values = {"Strength", "Health", "Stamina"},    
    Multi = false,    
    Default = "Strength",    
})    

Dropdown:OnChanged(function(Value)    
    print("Dropdown changed:", Value)    
    _G.SelectedStat = Value  -- เก็บค่า dropdown ไว้ใช้งาน
end)    

local Toggle2 = Tabs.Main:AddToggle("AutoStatus", {Title = "AutoStatus", Default = false })  

Toggle2:OnChanged(function(Status)  
    _G.Status = Status  

    if _G.Status then  
        while _G.Status do  
            if _G.SelectedStat then
                local args = {  
                    [1] = _G.SelectedStat,  
                    [2] = "up",  
                    [3] = 1  
                }

                game:GetService("Players").LocalPlayer.PlayerGui.UiService.StatsFrame.upstats:InvokeServer(unpack(args))
            end
            task.wait(0.1) -- เพิ่มหน่วงเวลาเพื่อไม่ให้สคริปต์ทำงานเร็วเกินไป
        end  
    end  
end)  

Options.AutoStatus:SetValue(false)
    
    local Colorpicker = Tabs.Main:AddColorpicker("Colorpicker", {  
        Title = "Colorpicker",  
        Default = Color3.fromRGB(96, 205, 255)  
    })  

    Colorpicker:OnChanged(function()  
        print("Colorpicker changed:", Colorpicker.Value)  
    end)  
      
    Colorpicker:SetValueRGB(Color3.fromRGB(0, 255, 140))  

    local TColorpicker = Tabs.Main:AddColorpicker("TransparencyColorpicker", {  
        Title = "Colorpicker",  
        Description = "but you can change the transparency.",  
        Transparency = 0,  
        Default = Color3.fromRGB(96, 205, 255)  
    })  

    TColorpicker:OnChanged(function()  
        print(  
            "TColorpicker changed:", TColorpicker.Value,  
            "Transparency:", TColorpicker.Transparency  
        )  
    end)  

    local Keybind = Tabs.Main:AddKeybind("Keybind", {  
        Title = "KeyBind",  
        Mode = "Toggle", -- Always, Toggle, Hold  
        Default = "LeftControl", -- String as the name of the keybind (MB1, MB2 for mouse buttons)  

        -- Occurs when the keybind is clicked, Value is `true`/`false`  
        Callback = function(Value)  
            print("Keybind clicked!", Value)  
        end,  

        -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum  
        ChangedCallback = function(New)  
            print("Keybind changed!", New)  
        end  
    })  

    -- OnClick is only fired when you press the keybind and the mode is Toggle  
    -- Otherwise, you will have to use Keybind:GetState()  
    Keybind:OnClick(function()  
        print("Keybind clicked:", Keybind:GetState())  
    end)  

    Keybind:OnChanged(function()  
        print("Keybind changed:", Keybind.Value)  
    end)  

    task.spawn(function()  
        while true do  
            wait(1)  

            -- example for checking if a keybind is being pressed  
            local state = Keybind:GetState()  
            if state then  
                print("Keybind is being held down")  
            end  

            if Fluent.Unloaded then break end  
        end  
    end)  

    Keybind:SetValue("MB2", "Toggle") -- Sets keybind to MB2, mode to Hold  

    local Input = Tabs.Main:AddInput("Input", {  
        Title = "Input",  
        Default = "Default",  
        Placeholder = "Placeholder",  
        Numeric = false, -- Only allows numbers  
        Finished = false, -- Only calls callback when you press enter  
        Callback = function(Value)  
            print("Input changed:", Value)  
        end  
    })  

    Input:OnChanged(function()  
        print("Input updated:", Input.Value)  
    end)
end

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8
})

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()

