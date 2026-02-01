--[[
    Made by samet

    Assign different flags to each element to prevent from configs overriding eachother
    Example script is at the bottom

    Documentation:
    function Library:Window(Data: table
        Name/name: string,
        Size/size: UDim2
    )

    function Window:Page(Data: table
        Name/name: string,
        Columns/columns: number,
        SubTabs/subtabs: boolean
    )

    function Page:SubPage(Data: table
        Icon/icon: string,
        Columns/columns: number
    )

    function Page:Section(Data: table
        Name/name: string,
        Side/side: number,
    )

    function Page:MultiSection(Data: table
        Sections/sections: table,
        Side/side: number
    )

    function Page:ScrollableSection(Data: table
        Name/name: string,
        Side/side: number,
        Size/size: number
    )

    function Section:Divider()

    function Section:Label(Data: table
        Name/name: string,
        Alignment/alignment: string
    )

    function Section:Toggle(Data: table
        Name/name: string,
        Default/default: boolean,
        Flag/flag: string,
        Callback/callback: function
    )

    function Section:Button(Data: table
        Name/name: string,
        Callback/callback: function
    )

    function Section:Slider(Data: table
        Name/name: string,
        Min/min: number,
        Max/max: number,
        Decimals/decimals: number,
        Default/default: number,
        Suffix/suffix: string,
        Flag/flag: string,
        Callback/callback: function
    )

    function Section:Textbox(Data: table
        Name/name: string,
        Default/default: string,
        Placeholder/placeholder: string,
        Flag/flag: string,
        Callback/callback: function
    )

    function Section:Dropdown(Data: table
        Name/name: string,
        Items/items: table,
        Default/default: string,
        Flag/flag: string,
        Multi/multi: boolean,
        Callback/callback: function
    )

    function Section:Listbox(Data: table
        Size/size: number,
        Items/items: table,
        Default/default: string,
        Multi/multi: boolean,
        Flag/flag: string,
        Callback/callback: function
    )

    function Label:Keybind(Data: table
        Name/name: string,
        Mode/mode: string,
        Default/default: EnumItem,
        Flag/flag: string,
        Callback/callback: function
    )

    function Label:Colorpicker(Data: table
        Name/name: string,
        Default/default: Color3,
        Alpha/alpha: boolean,
        Flag/flag: string,
        Callback/callback: function
    )

    function Toggle:Colorpicker(Data: table
        Name/name: string,
        Default/default: Color3,
        Alpha/alpha: boolean,
        Flag/flag: string,
        Callback/callback: function
    )

    function Toggle:Keybind(Data: table
        Name/name: string,
        Mode/mode: string,
        Default/default: EnumItem,
        Flag/flag: string,
        Callback/callback: function
    )

    function Sections:Textbox(Data: table
        Name/name: string,
        Default/default: string,
        Placeholder/placeholder: string,
        Flag/flag: string,
        Callback/callback: function
    )

    function Library:Watermark(Name: string)
    function Library:Notification(Text: string, Duration: number, Color: Color3, Icon: table)
    function Library:KeybindList()
]]

local LoadingTick = os.clock()

if getgenv().Library then 
    getgenv().Library:Unload()
end

local Library do
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local HttpService = game:GetService("HttpService")
    local TweenService = game:GetService("TweenService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")

    gethui = gethui or function()
        return CoreGui
    end

    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex

    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new

    local NumSequence = NumberSequence.new
    local NumSequenceKeypoint = NumberSequenceKeypoint.new

    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local Vector2New = Vector2.new

    local InstanceNew = Instance.new

    local MathClamp = math.clamp
    local MathFloor = math.floor

    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableUnpack = table.unpack

    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub

    Library = {
        Flags = { },
        
        Themes = {
            ["Default"] = {
                ["Background"] = FromRGB(15, 15, 20),
                ["Inline"] = FromRGB(20, 20, 25),
                ["Page Background"] = FromRGB(30, 30, 35),
                ["Border"] = FromRGB(10, 10, 10),
                ["Outline"] = FromRGB(27, 27, 32),
                ["Accent"] = FromRGB(235, 157, 255),
                ["Element"] = FromRGB(33, 33, 36),
                ["Hovered Element"] = FromRGB(40, 40, 43),
                ["Text"] = FromRGB(215, 215, 215),
                ["Text Border"] = FromRGB(0, 0, 0)
            },
            ["Dark Red"] = {
                ["Background"] = FromRGB(20, 15, 15),
                ["Inline"] = FromRGB(25, 20, 20),
                ["Page Background"] = FromRGB(35, 25, 25),
                ["Border"] = FromRGB(15, 10, 10),
                ["Outline"] = FromRGB(32, 22, 22),
                ["Accent"] = FromRGB(255, 80, 80),
                ["Element"] = FromRGB(36, 28, 28),
                ["Hovered Element"] = FromRGB(43, 35, 35),
                ["Text"] = FromRGB(215, 215, 215),
                ["Text Border"] = FromRGB(0, 0, 0)
            },
            ["Ocean Blue"] = {
                ["Background"] = FromRGB(15, 20, 25),
                ["Inline"] = FromRGB(20, 25, 30),
                ["Page Background"] = FromRGB(25, 35, 45),
                ["Border"] = FromRGB(10, 15, 20),
                ["Outline"] = FromRGB(22, 32, 42),
                ["Accent"] = FromRGB(80, 180, 255),
                ["Element"] = FromRGB(28, 38, 48),
                ["Hovered Element"] = FromRGB(35, 45, 55),
                ["Text"] = FromRGB(215, 215, 215),
                ["Text Border"] = FromRGB(0, 0, 0)
            },
            ["Forest Green"] = {
                ["Background"] = FromRGB(15, 20, 15),
                ["Inline"] = FromRGB(20, 25, 20),
                ["Page Background"] = FromRGB(25, 35, 25),
                ["Border"] = FromRGB(10, 15, 10),
                ["Outline"] = FromRGB(22, 32, 22),
                ["Accent"] = FromRGB(80, 255, 120),
                ["Element"] = FromRGB(28, 38, 28),
                ["Hovered Element"] = FromRGB(35, 45, 35),
                ["Text"] = FromRGB(215, 215, 215),
                ["Text Border"] = FromRGB(0, 0, 0)
            },
            ["Sunset Orange"] = {
                ["Background"] = FromRGB(20, 17, 15),
                ["Inline"] = FromRGB(25, 22, 20),
                ["Page Background"] = FromRGB(35, 30, 25),
                ["Border"] = FromRGB(15, 12, 10),
                ["Outline"] = FromRGB(32, 27, 22),
                ["Accent"] = FromRGB(255, 150, 50),
                ["Element"] = FromRGB(36, 31, 26),
                ["Hovered Element"] = FromRGB(43, 38, 33),
                ["Text"] = FromRGB(215, 215, 215),
                ["Text Border"] = FromRGB(0, 0, 0)
            },
            ["Royal Purple"] = {
                ["Background"] = FromRGB(18, 15, 25),
                ["Inline"] = FromRGB(23, 20, 30),
                ["Page Background"] = FromRGB(33, 25, 45),
                ["Border"] = FromRGB(13, 10, 20),
                ["Outline"] = FromRGB(28, 22, 42),
                ["Accent"] = FromRGB(180, 100, 255),
                ["Element"] = FromRGB(31, 26, 46),
                ["Hovered Element"] = FromRGB(38, 33, 53),
                ["Text"] = FromRGB(215, 215, 215),
                ["Text Border"] = FromRGB(0, 0, 0)
            },
            ["Cherry Blossom"] = {
                ["Background"] = FromRGB(22, 15, 18),
                ["Inline"] = FromRGB(27, 20, 23),
                ["Page Background"] = FromRGB(37, 25, 33),
                ["Border"] = FromRGB(17, 10, 13),
                ["Outline"] = FromRGB(32, 22, 28),
                ["Accent"] = FromRGB(255, 120, 180),
                ["Element"] = FromRGB(34, 28, 31),
                ["Hovered Element"] = FromRGB(41, 35, 38),
                ["Text"] = FromRGB(215, 215, 215),
                ["Text Border"] = FromRGB(0, 0, 0)
            },
            ["Midnight"] = {
                ["Background"] = FromRGB(10, 10, 15),
                ["Inline"] = FromRGB(15, 15, 20),
                ["Page Background"] = FromRGB(20, 20, 30),
                ["Border"] = FromRGB(5, 5, 10),
                ["Outline"] = FromRGB(17, 17, 27),
                ["Accent"] = FromRGB(100, 150, 255),
                ["Element"] = FromRGB(23, 23, 33),
                ["Hovered Element"] = FromRGB(30, 30, 40),
                ["Text"] = FromRGB(215, 215, 215),
                ["Text Border"] = FromRGB(0, 0, 0)
            },
            ["Cyber Neon"] = {
                ["Background"] = FromRGB(12, 12, 18),
                ["Inline"] = FromRGB(17, 17, 23),
                ["Page Background"] = FromRGB(22, 22, 33),
                ["Border"] = FromRGB(7, 7, 13),
                ["Outline"] = FromRGB(19, 19, 29),
                ["Accent"] = FromRGB(0, 255, 200),
                ["Element"] = FromRGB(25, 25, 36),
                ["Hovered Element"] = FromRGB(32, 32, 43),
                ["Text"] = FromRGB(215, 215, 215),
                ["Text Border"] = FromRGB(0, 0, 0)
            },
            ["Crimson"] = {
                ["Background"] = FromRGB(18, 10, 12),
                ["Inline"] = FromRGB(23, 15, 17),
                ["Page Background"] = FromRGB(33, 20, 22),
                ["Border"] = FromRGB(13, 5, 7),
                ["Outline"] = FromRGB(28, 17, 19),
                ["Accent"] = FromRGB(220, 20, 60),
                ["Element"] = FromRGB(31, 23, 25),
                ["Hovered Element"] = FromRGB(38, 30, 32),
                ["Text"] = FromRGB(215, 215, 215),
                ["Text Border"] = FromRGB(0, 0, 0)
            }
        },

        CurrentTheme = "Default",
        
        Theme = {
            ["Background"] = FromRGB(15, 15, 20),
            ["Inline"] = FromRGB(20, 20, 25),
            ["Page Background"] = FromRGB(30, 30, 35),
            ["Border"] = FromRGB(10, 10, 10),
            ["Outline"] = FromRGB(27, 27, 32),
            ["Accent"] = FromRGB(0, 255, 255),
            ["Element"] = FromRGB(33, 33, 36),
            ["Hovered Element"] = FromRGB(40, 40, 43),
            ["Text"] = FromRGB(215, 215, 215),
            ["Text Border"] = FromRGB(0, 0, 0)
        },

        MenuKeybind = Enum.KeyCode.Z, 

        Tween = {
            Time = 0.3,
            Style = Enum.EasingStyle.Exponential,
            Direction = Enum.EasingDirection.Out
        },

        Folders = {
            Directory = "scriptname",
            Configs = "scriptname/Configs",
            Assets = "scriptname/Assets"
        },

        Images = { -- you're welcome to reupload the images and replace it with your own links
            ["Saturation"] = {"Saturation.png", "https://github.com/sametexe001/images/blob/main/saturation.png?raw=true" },
            ["Value"] = { "Value.png", "https://github.com/sametexe001/images/blob/main/value.png?raw=true" },
            ["Hue"] = { "Hue.png", "https://github.com/sametexe001/images/blob/main/hue.png?raw=true" },
            ["Scrollbar"] =  { "Scrollbar.png", "https://github.com/sametexe001/images/blob/main/scrollbar.png?raw=true" },
            ["Checkers"] = { "Checkers.png", "https://github.com/sametexe001/images/blob/main/checkers.png?raw=true" },
            ["Resize"] = { "Resize.png", "https://github.com/sametexe001/images/blob/main/resize.png?raw=true" },
        },

        -- Ignore below
        Pages = { },
        Sections = { },
        Connections = { },
        Threads = { },
        ThemeMap = { },
        ThemeItems = { },

        SetFlags = { },

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        Font = nil,
        KeyList = nil,

        CurrentColorpicker = nil
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = " )",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "`",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracked",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Delete",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RightShift",
        ["LeftShift"]         = "LeftShift",
        ["RightControl"]      = "RightControl",
        ["LeftControl"]       = "LeftControl",
        ["LeftAlt"]           = "LeftAlt",
        ["RightAlt"]          = "RightAlt"
    }

    -- Files 
    for _, FileName in Library.Folders do
        if not isfolder(FileName) then
            makefolder(FileName)
        end
    end

    for _, ImageData in Library.Images do
        local ImageName = ImageData[1]
        local ImageLink = ImageData[2]
        
        if not isfile(Library.Folders.Assets .. "/" .. ImageName) then
            writefile(Library.Folders.Assets .. "/" .. ImageName, game:HttpGet(ImageLink))
        end
    end

    local Tween = { } do
        Tween.__index = Tween

        Tween.Create = function(self, Item, Info, Goal, IsRawItem)
            Item = IsRawItem and Item or Item.Instance
            Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

            local NewTween = {
                Tween = TweenService:Create(Item, Info, Goal),
                Info = Info,
                Goal = Goal,
                Item = Item
            }

            NewTween.Tween:Play()

            setmetatable(NewTween, Tween)

            return NewTween
        end

        Tween.Get = function(self)
            if not self.Tween then 
                return
            end

            return self.Tween, self.Info, self.Goal
        end

        Tween.Pause = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Pause()
        end

        Tween.Play = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Play()
        end

        Tween.Clean = function(self)
            if not self.Tween then 
                return
            end

            Tween:Pause()
            self = nil
        end
    end

    local Instances = { } do
        Instances.__index = Instances

        Instances.Create = function(self, Class, Properties)
            local NewItem = {
                Instance = InstanceNew(Class),
                Properties = Properties,
                Class = Class
            }

            setmetatable(NewItem, Instances)

            for Property, Value in NewItem.Properties do
                NewItem.Instance[Property] = Value
            end

            return NewItem
        end

        Instances.Border = function(self)
            if not self.Instance then 
                return
            end

            local Item = self.Instance
            local UIStroke = Instances:Create("UIStroke", {
                Parent = Item,
                Color = Library.Theme.Border,
                Thickness = 1,
                LineJoinMode = Enum.LineJoinMode.Miter
            })

            UIStroke:AddToTheme({Color = "Border"})

            return UIStroke
        end

        Instances.AddToTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:AddToTheme(self, Properties)
        end

        Instances.ChangeItemTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:ChangeItemTheme(self, Properties)
        end

        Instances.Connect = function(self, Event, Callback, Name)
            if not self.Instance then 
                return
            end

            if not self.Instance[Event] then 
                return
            end

            return Library:Connect(self.Instance[Event], Callback, Name)
        end

        Instances.Tween = function(self, Info, Goal)
            if not self.Instance then 
                return
            end

            return Tween:Create(self, Info, Goal)
        end

        Instances.Disconnect = function(self, Name)
            if not self.Instance then 
                return
            end

            return Library:Disconnect(Name)
        end

        Instances.Clean = function(self)
            if not self.Instance then 
                return
            end

            self.Instance:Destroy()
            self = nil
        end

        Instances.MakeDraggable = function(self)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local Dragging = false 
            local DragStart
            local StartPosition 

            local Set = function(Input)
                local DragDelta = Input.Position - DragStart
                self:Tween(TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(StartPosition.X.Scale, StartPosition.X.Offset + DragDelta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + DragDelta.Y)})
            end

            self:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true

                    DragStart = Input.Position
                    StartPosition = Gui.Position
                end
            end)

            self:Connect("InputEnded", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dragging then
                        Set(Input)
                    end
                end
            end)

            return Dragging
        end

        Instances.MakeResizeable = function(self, Minimum, Maximum)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local Resizing = false 
            local Start = UDim2New()
            local Delta = UDim2New()
            local ResizeMax = Gui.Parent.AbsoluteSize - Gui.AbsoluteSize

            local ResizeButton = Instances:Create("TextButton", {
				Parent = Gui,
				AnchorPoint = Vector2New(1, 1),
				BorderColor3 = FromRGB(0, 0, 0),
				Size = UDim2New(0, 8, 0, 8),
				Position = UDim2New(1, 0, 1, 0),
                Name = "\0",
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				AutoButtonColor = false,
                Visible = true,
                Text = ""
			})

            ResizeButton:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Resizing = true

                    Start = Gui.Size - UDim2New(0, Input.Position.X, 0, Input.Position.Y)
                end
            end)

            ResizeButton:Connect("InputEnded", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Resizing = false
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement and Resizing then
					ResizeMax = Maximum or Gui.Parent.AbsoluteSize - Gui.AbsoluteSize

					Delta = Start + UDim2New(0, Input.Position.X, 0, Input.Position.Y)
					Delta = UDim2New(0, math.clamp(Delta.X.Offset, Minimum.X, ResizeMax.X), 0, math.clamp(Delta.Y.Offset, Minimum.Y, ResizeMax.Y))

					Tween:Create(Gui, TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = Delta}, true)
                end
            end)

            return Resizing
        end

        Instances.OnHover = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseEnter, Function)
        end

        Instances.OnHoverLeave = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseLeave, Function)
        end
    end

    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
                return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
            end

            if not isfile(Library.Folders.Assets .. "/" .. Name .. ".ttf") then 
                writefile(Library.Folders.Assets .. "/" .. Name .. ".ttf", game:HttpGet(Data.Url))
            end

            local FontData = {
                name = Name,
                faces = { {
                    name = "Regular",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".ttf")
                } }
            }

            writefile(Library.Folders.Assets .. "/" .. Name .. ".json", HttpService:JSONEncode(FontData))
            return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
        end

        function CustomFont:Get(Name)
            if isfile(Library.Folders.Assets .. "/" .. Name .. ".json") then
                return Font.new(getcustomasset(Library.Folders.Assets .. "/" .. Name .. ".json"))
            end
        end

        CustomFont:New("Windows-XP-Tahoma", 200, "Regular", {
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/windows-xp-tahoma.ttf"
        })

        Library.Font = CustomFont:Get("Windows-XP-Tahoma")
    end

    Library.Holder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ResetOnSpawn = false
    })

    -- Background Blur Effect
    Library.BlurEffect = Instances:Create("BlurEffect", {
        Parent = game:GetService("Lighting"),
        Name = "\0",
        Size = 0
    })

    Library.NotifHolder = Instances:Create("Frame", {
        Parent = Library.Holder.Instance,
        BorderColor3 = FromRGB(0, 0, 0),
        AnchorPoint = Vector2New(0.5, 0),
        BackgroundTransparency = 1,
        Position = UDim2New(0.5, 0, 0, 0),
        Name = "\0",
        Size = UDim2New(0.34, 0, 1, -14),
        BorderSizePixel = 0,
        BackgroundColor3 = FromRGB(255, 255, 255)
    }) 
    
    Instances:Create("UIListLayout", {
        Parent = Library.NotifHolder.Instance,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDimNew(0, 10)
    }) 

    Library.GetImage = function(self, Image)
        local ImageData = self.Images[Image]

        if not ImageData then 
            return
        end

        return getcustomasset(self.Folders.Assets .. "/" .. ImageData[1])
    end

    Library.Round = function(self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return MathFloor(Number * Multiplier) / Multiplier
    end

    Library.GetTransparencyPropertyFromItem = function(self, Item)
        if Item:IsA("Frame") then
            return { "BackgroundTransparency" }
        elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
            return { "BackgroundTransparency", "ImageTransparency" }
        elseif Item:IsA("ScrollingFrame") then
            return { "BackgroundTransparency", "ScrollBarImageTransparency" }
        elseif Item:IsA("TextBox") then
            return { "TextTransparency", "BackgroundTransparency" }
        elseif Item:IsA("UIStroke") then 
            return { "Transparency" }
        end
    end

    Library.FadeItem = function(self, Item, Property, Visibility, Speed)
        local OldTransparency = Item[Property]
        Item[Property] = Visibility and 1 or OldTransparency

        local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {
            [Property] = Visibility and OldTransparency or 1
        }, true)

        Library:Connect(NewTween.Tween.Completed, function()
            if not Visibility then 
                task.wait()
                Item[Property] = OldTransparency
            end
        end)

        return NewTween
    end

    Library.Unload = function(self)
        for Index, Value in self.Connections do 
            Value.Connection:Disconnect()
        end

        for Index, Value in self.Threads do 
            coroutine.close(Value)
        end

        if self.Holder then 
            self.Holder:Clean()
        end

        if self.BlurEffect then
            self.BlurEffect:Clean()
        end

        Library = nil 
        getgenv().Library = nil
    end

    Library.Thread = function(self, Function)
        local NewThread = coroutine.create(Function)
        
        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        TableInsert(self.Threads, NewThread)

        return NewThread
    end
    
    Library.SafeCall = function(self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, TableUnpack(Arguements))

        if not Success then
            Library:Notification("Error caught in function, report this to the devs:\n"..Result, 5, FromRGB(255, 0, 0))
            warn(Result)
            return false
        end

        return Success
    end

    Library.Connect = function(self, Event, Callback, Name)
        Name = Name or StringFormat("Connection_%s_%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))

        local NewConnection = {
            Event = Event,
            Callback = Callback,
            Name = Name,
            Connection = nil
        }

        Library:Thread(function()
            NewConnection.Connection = Event:Connect(Callback)
        end)

        TableInsert(self.Connections, NewConnection)
        return NewConnection
    end

    Library.Disconnect = function(self, Name)
        for _, Connection in self.Connections do 
            if Connection.Name == Name then
                Connection.Connection:Disconnect()
                break
            end
        end
    end

    Library.NextFlag = function(self)
        local FlagNumber = self.UnnamedFlags + 1
        return StringFormat("Flag Number %s %s", FlagNumber, HttpService:GenerateGUID(false))
    end

    Library.AddToTheme = function(self, Item, Properties)
        Item = Item.Instance or Item 

        local ThemeData = {
            Item = Item,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                Item[Property] = self.Theme[Value]
            end
        end

        TableInsert(self.ThemeItems, ThemeData)
        self.ThemeMap[Item] = ThemeData
    end

    Library.GetConfig = function(self)
        local Config = { } 

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do 
                if type(Value) == "table" and Value.Key then
                    Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
                else
                    Config[Index] = Value
                end
            end
        end)

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do 
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Key then 
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                else
                    SetFunction(Value)
                end
            end
        end)

        if Success then 
            Library:Notification("Successfully loaded config", 5, Color3.fromRGB(0, 255, 0))
        end
    end

    Library.DeleteConfig = function(self, Config)
        if isfile(Library.Folders.Configs .. "/" .. Config) then 
            delfile(Library.Folders.Configs .. "/" .. Config)
            Library:Notification("Deleted config " .. Config .. ".json", 5, Color3.fromRGB(0, 255, 0))
        end
    end

    Library.SaveConfig = function(self, Config)
        if isfile(Library.Folders.Directory .. "/" .. Library.Folders.Configs .. "/" .. Config .. ".json") then
            writefile(Library.Folders.Directory .. "/" .. Library.Folders.Configs .. "/" .. Config .. ".json", Library:GetConfig())
            Library:Notification("Saved config " .. Config .. ".json", 5, Color3.fromRGB(0, 255, 0))
        end
    end

    Library.RefreshConfigsList = function(self, Element)
        local CurrentList = { }
        local List = { }

        local ConfigFolderName = StringGSub(Library.Folders.Configs, Library.Folders.Directory .. "/", "")

        for Index, Value in listfiles(Library.Folders.Configs) do
            local FileName = StringGSub(Value, Library.Folders.Directory .. "\\" .. ConfigFolderName .. "\\", "")
            List[Index] = FileName
        end

        local IsNew = #List ~= CurrentList

        if not IsNew then
            for Index = 1, #List do
                if List[Index] ~= CurrentList[Index] then
                    IsNew = true
                    break
                end
            end
        else
            CurrentList = List
            Element:Refresh(CurrentList)
        end
    end

    Library.ChangeItemTheme = function(self, Item, Properties)
        Item = Item.Instance or Item

        if not self.ThemeMap[Item] then 
            return
        end

        self.ThemeMap[Item].Properties = Properties
        self.ThemeMap[Item] = self.ThemeMap[Item]
    end

    Library.ChangeTheme = function(self, Theme, Color)
        self.Theme[Theme] = Color

        for _, Item in self.ThemeItems do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                end
            end
        end
    end

    Library.ApplyTheme = function(self, ThemeName)
        if not self.Themes[ThemeName] then
            return
        end

        self.CurrentTheme = ThemeName
        local NewTheme = self.Themes[ThemeName]

        -- Apply all theme colors
        for ColorName, ColorValue in pairs(NewTheme) do
            self.Theme[ColorName] = ColorValue
            
            -- Update all themed items
            for _, Item in self.ThemeItems do
                for Property, Value in Item.Properties do
                    if type(Value) == "string" and Value == ColorName then
                        Item.Item[Property] = ColorValue
                    end
                end
            end
        end

        Library:Notification("Theme changed to " .. ThemeName, 3, NewTheme.Accent)
    end

    Library.IsMouseOverFrame = function(self, Frame)
        Frame = Frame.Instance

        local MousePosition = Vector2New(Mouse.X, Mouse.Y)

        return MousePosition.X >= Frame.AbsolutePosition.X and MousePosition.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X 
        and MousePosition.Y >= Frame.AbsolutePosition.Y and MousePosition.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
    end

    Library.Watermark = function(self, Name)
        local Watermark = { } 

        local Items = { } do 
            Items["Watermark"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                Size = UDim2New(0, 0, 0, 20),
                Name = "\0",
                Position = UDim2New(0, 15, 0, 15),
                BorderColor3 = FromRGB(10, 10, 10),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["Watermark"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Items["Watermark"]:MakeDraggable()
            
            Instances:Create("UIStroke", {
                Parent = Items["Watermark"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Watermark"].Instance,
                PaddingTop = UDimNew(0, 2),
                PaddingRight = UDimNew(0, 5),
                PaddingLeft = UDimNew(0, 5)
            }) 
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Watermark"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Name,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 1),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Title"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["Watermark"].Instance,
                Name = "\0",
                Position = UDim2New(0, -5, 0, -2),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 10, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(235, 157, 255)
            })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            })             
        end

        function Watermark:SetVisibility(Bool)
            Items["Watermark"].Instance.Visible = Bool
        end
        
        return Watermark
    end

    Library.Notification = function(self, Text, Duration, Color, Icon)
        local Items = { } do
            Items["Notification"] = Instances:Create("Frame", {
                Parent = Library.NotifHolder.Instance,
                Name = "\0",
                Size = UDim2New(0, 0, 0, 22),
                BorderColor3 = FromRGB(10, 10, 10),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["Notification"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Notification"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"}) 
            
            Instances:Create("UIPadding", {
                Parent = Items["Notification"].Instance,
                PaddingTop = UDimNew(0, 1),
                PaddingRight = UDimNew(0, 8),
                PaddingLeft = UDimNew(0, 5)
            }) 
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["Notification"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Text,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 15),
                BackgroundTransparency = 1,
                Position = UDim2New(0, 13, 0, 2),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Title"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["Notification"].Instance,
                Name = "\0",
                Position = UDim2New(0, -5, 0, -1),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 13, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = Color
            })  
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            })
            
            Items["Icon"] = Instances:Create("ImageLabel", {
                Parent = Items["Notification"].Instance,
                ImageColor3 = FromRGB(255, 255, 255),
                ScaleType = Enum.ScaleType.Fit,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                Image = "rbxassetid://94324346713012",
                BackgroundTransparency = 1,
                Position = UDim2New(0, -2, 0, 3),
                Size = UDim2New(0, 13, 0, 13),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            if not Icon then 
                Items["Icon"]:Clean()
                Items["Title"].Instance.Position = UDim2New(0, 1, 0, 2)
            else
                Items["Icon"].Instance.Image = Icon[1]
                Items["Icon"].Instance.ImageColor3 = Icon[2] or FromRGB(255, 255, 255)
            end
        end

        Items["Notification"].Instance.BackgroundTransparency = 1
        Items["Notification"].Instance.Size = UDim2New(0, 0, 0, 0)
        for Index, Value in Items["Notification"].Instance:GetDescendants() do
            if Value:IsA("UIStroke") then 
                Value.Transparency = 1
            elseif Value:IsA("TextLabel") then 
                Value.TextTransparency = 1
            elseif Value:IsA("ImageLabel") then 
                Value.ImageTransparency = 1
            elseif Value:IsA("Frame") then 
                Value.BackgroundTransparency = 1
            end
        end

        Library:Thread(function()
            Items["Notification"]:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(0, 0, 0, 22)})
            
            task.wait(0.06)

            for Index, Value in Items["Notification"].Instance:GetDescendants() do
                if Value:IsA("UIStroke") then
                    Tween:Create(Value, nil, {Transparency = 0}, true)
                elseif Value:IsA("TextLabel") then
                    Tween:Create(Value, nil, {TextTransparency = 0}, true)
                elseif Value:IsA("ImageLabel") then
                    Tween:Create(Value, nil, {ImageTransparency = 0}, true)
                elseif Value:IsA("Frame") then
                    Tween:Create(Value, nil, {BackgroundTransparency = 0}, true)
                end
            end

            task.delay(Duration + 0.1, function()
                for Index, Value in Items["Notification"].Instance:GetDescendants() do
                    if Value:IsA("UIStroke") then
                        Tween:Create(Value, nil, {Transparency = 1}, true)
                    elseif Value:IsA("TextLabel") then
                        Tween:Create(Value, nil, {TextTransparency = 1}, true)
                    elseif Value:IsA("ImageLabel") then
                        Tween:Create(Value, nil, {ImageTransparency = 1}, true)
                    elseif Value:IsA("Frame") then
                        Tween:Create(Value, nil, {BackgroundTransparency = 1}, true)
                    end
                end

                task.wait(0.06)

                Items["Notification"]:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 0, 0, 0)})

                task.wait(0.5)
                Items["Notification"]:Clean()
            end)
        end)
    end

    Library.KeybindList = function(self)
        local KeybindList = { }
        self.KeyList = KeybindList

        local Items = { } do
            Items["KeybindList"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                BorderColor3 = FromRGB(10, 10, 10),
                AnchorPoint = Vector2New(0, 0.5),
                Name = "\0",
                Position = UDim2New(0, 15, 0.5, 0),
                Size = UDim2New(0, 0, 0, 18),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["KeybindList"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Items["KeybindList"]:MakeDraggable()
            
            Instances:Create("UIStroke", {
                Parent = Items["KeybindList"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                Position = UDim2New(0, -5, 0, -5),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 10, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(235, 157, 255)
            })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            }) 
            
            Instances:Create("UIPadding", {
                Parent = Items["KeybindList"].Instance,
                PaddingTop = UDimNew(0, 5),
                PaddingBottom = UDimNew(0, 5),
                PaddingRight = UDimNew(0, 5),
                PaddingLeft = UDimNew(0, 5)
            }) 
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["KeybindList"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Keybinds",
                Name = "\0",
                Size = UDim2New(0, 100, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 0, 0, -1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Title"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["KeybindList"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 5, 0, 19),
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIListLayout", {
                Parent = Items["Content"].Instance,
                Padding = UDimNew(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 
        end

        function KeybindList:Add(Mode, Name, Key)
            local NewKey = Instances:Create("TextLabel", {
                Parent = Items["Content"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "(" .. Mode .. ") " .. Name .. " - " .. Key,
                Name = "\0",
                Size = UDim2New(0, 0, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  NewKey:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = NewKey.Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
        
            function NewKey:Set(Mode, Name, Key)
                NewKey.Instance.Text = "(" .. Mode .. ") " .. Name .. " - " .. Key
            end

            function NewKey:SetStatus(Status)
                if Status == "Active" then 
                    NewKey:Tween(nil, {TextColor3 = Library.Theme.Accent})
                    NewKey:ChangeItemTheme({TextColor3 = "Accent"})
                else 
                    NewKey:Tween(nil, {TextColor3 = Library.Theme.Text})
                    NewKey:ChangeItemTheme({TextColor3 = "Text"})
                end
            end

            return NewKey
        end

        function KeybindList:SetVisibility(Bool)
            Items["KeybindList"].Instance.Visible = Bool
        end

        return KeybindList
    end

    Library.PlayerList = function(self)
        local PlayerList = {}
        local PlayerStatuses = {}

        local Items = {} do
            Items["PlayerListFrame"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                BorderColor3 = FromRGB(10, 10, 10),
                AnchorPoint = Vector2New(1, 0.5),
                Name = "\0",
                Position = UDim2New(1, -15, 0.5, 0),
                Size = UDim2New(0, 250, 0, 400),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["PlayerListFrame"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Items["PlayerListFrame"]:MakeDraggable()
            
            Instances:Create("UIStroke", {
                Parent = Items["PlayerListFrame"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["PlayerListFrame"].Instance,
                Name = "\0",
                Position = UDim2New(0, -5, 0, -5),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 10, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(235, 157, 255)
            })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            }) 
            
            Instances:Create("UIPadding", {
                Parent = Items["PlayerListFrame"].Instance,
                PaddingTop = UDimNew(0, 5),
                PaddingBottom = UDimNew(0, 5),
                PaddingRight = UDimNew(0, 5),
                PaddingLeft = UDimNew(0, 5)
            }) 
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["PlayerListFrame"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Players",
                Name = "\0",
                Size = UDim2New(0, 100, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 0, 0, -1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Title"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["PlayerCount"] = Instances:Create("TextLabel", {
                Parent = Items["PlayerListFrame"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(180, 180, 180),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "0",
                Name = "\0",
                Size = UDim2New(0, 50, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right,
                Position = UDim2New(1, -50, 0, -1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["PlayerCount"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["PlayerCount"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            -- Search Bar
            Items["SearchBar"] = Instances:Create("Frame", {
                Parent = Items["PlayerListFrame"].Instance,
                Name = "\0",
                Position = UDim2New(0, 0, 0, 19),
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(1, 0, 0, 22),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(33, 33, 36)
            })  Items["SearchBar"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["SearchBar"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["SearchBox"] = Instances:Create("TextBox", {
                Parent = Items["SearchBar"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                Name = "\0",
                Size = UDim2New(1, -10, 1, 0),
                Position = UDim2New(0, 5, 0, 0),
                BorderSizePixel = 0,
                ClearTextOnFocus = false,
                BackgroundTransparency = 1,
                PlaceholderColor3 = FromRGB(150, 150, 150),
                TextXAlignment = Enum.TextXAlignment.Left,
                PlaceholderText = "Search players...",
                TextSize = 11,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["SearchBox"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["SearchBox"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["PlayerScroll"] = Instances:Create("ScrollingFrame", {
                Parent = Items["PlayerListFrame"].Instance,
                ScrollBarImageColor3 = FromRGB(235, 157, 255),
                Active = true,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 2,
                Size = UDim2New(1, 0, 1, -46),
                Name = "\0",
                Position = UDim2New(0, 0, 0, 45),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                CanvasSize = UDim2New(0, 0, 0, 0)
            })  Items["PlayerScroll"]:AddToTheme({ScrollBarImageColor3 = "Accent"})
            
            Instances:Create("UIListLayout", {
                Parent = Items["PlayerScroll"].Instance,
                Padding = UDimNew(0, 5),
                SortOrder = Enum.SortOrder.Name
            })
        end

        function PlayerList:CreatePlayerEntry(player)
            local IsExpanded = false
            
            local PlayerEntry = Instances:Create("Frame", {
                Parent = Items["PlayerScroll"].Instance,
                Name = player.Name,
                Size = UDim2New(1, -5, 0, 25),
                BorderColor3 = FromRGB(10, 10, 10),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(30, 30, 35)
            })  PlayerEntry:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = PlayerEntry.Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            -- Avatar Icon
            local AvatarIcon = Instances:Create("ImageLabel", {
                Parent = PlayerEntry.Instance,
                Name = "\0",
                Position = UDim2New(0, 3, 0, 3),
                Size = UDim2New(0, 18, 0, 18),
                BackgroundColor3 = FromRGB(40, 40, 45),
                BorderSizePixel = 0,
                Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=48&h=48"
            })  AvatarIcon:AddToTheme({BackgroundColor3 = "Border"})
            
            Instances:Create("UICorner", {
                Parent = AvatarIcon.Instance,
                CornerRadius = UDimNew(0, 4)
            })
            
            Instances:Create("UIStroke", {
                Parent = AvatarIcon.Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            -- Expand Arrow
            local ExpandArrow = Instances:Create("TextLabel", {
                Parent = PlayerEntry.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(180, 180, 180),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "▶",
                Name = "\0",
                Size = UDim2New(0, 10, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Center,
                Position = UDim2New(0, 24, 0, 3),
                BorderSizePixel = 0,
                TextSize = 8,
                Rotation = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  ExpandArrow:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = ExpandArrow.Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            local PlayerName = Instances:Create("TextLabel", {
                Parent = PlayerEntry.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = player.Name,
                Name = "\0",
                Size = UDim2New(1, -50, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Position = UDim2New(0, 38, 0, 3),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  PlayerName:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = PlayerName.Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            local StatusIndicator = Instances:Create("Frame", {
                Parent = PlayerEntry.Instance,
                Name = "\0",
                Position = UDim2New(1, -10, 0, 8),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 6, 0, 6),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(100, 100, 100)
            })
            
            Instances:Create("UICorner", {
                Parent = StatusIndicator.Instance,
                CornerRadius = UDimNew(1, 0)
            })
            
            local ButtonContainer = Instances:Create("Frame", {
                Parent = PlayerEntry.Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 5, 0, 25),
                Size = UDim2New(1, -10, 0, 40),
                BorderSizePixel = 0
            })
            
            Instances:Create("UIListLayout", {
                Parent = ButtonContainer.Instance,
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDimNew(0, 5),
                HorizontalAlignment = Enum.HorizontalAlignment.Left
            })
            
            -- Friend Button
            local FriendButton = Instances:Create("TextButton", {
                Parent = ButtonContainer.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(10, 10, 10),
                Text = "Friend",
                AutoButtonColor = false,
                Name = "\0",
                Size = UDim2New(0, 70, 0, 18),
                BorderSizePixel = 2,
                TextSize = 11,
                BackgroundColor3 = FromRGB(67, 181, 129)
            })  FriendButton:AddToTheme({BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = FriendButton.Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Instances:Create("UIStroke", {
                Parent = FriendButton.Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            FriendButton:OnHover(function()
                FriendButton:Tween(nil, {BackgroundColor3 = FromRGB(77, 201, 149)})
            end)
            
            FriendButton:OnHoverLeave(function()
                FriendButton:Tween(nil, {BackgroundColor3 = FromRGB(67, 181, 129)})
            end)
            
            FriendButton:Connect("MouseButton1Click", function()
                PlayerStatuses[player.Name] = "Friend"
                StatusIndicator:Tween(nil, {BackgroundColor3 = FromRGB(67, 181, 129)})
                Library:Notification("Marked " .. player.Name .. " as Friend", 3, FromRGB(67, 181, 129))
            end)
            
            -- Enemy Button
            local EnemyButton = Instances:Create("TextButton", {
                Parent = ButtonContainer.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(10, 10, 10),
                Text = "Enemy",
                AutoButtonColor = false,
                Name = "\0",
                Size = UDim2New(0, 70, 0, 18),
                BorderSizePixel = 2,
                TextSize = 11,
                BackgroundColor3 = FromRGB(240, 71, 71)
            })  EnemyButton:AddToTheme({BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = EnemyButton.Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Instances:Create("UIStroke", {
                Parent = EnemyButton.Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            EnemyButton:OnHover(function()
                EnemyButton:Tween(nil, {BackgroundColor3 = FromRGB(255, 91, 91)})
            end)
            
            EnemyButton:OnHoverLeave(function()
                EnemyButton:Tween(nil, {BackgroundColor3 = FromRGB(240, 71, 71)})
            end)
            
            EnemyButton:Connect("MouseButton1Click", function()
                PlayerStatuses[player.Name] = "Enemy"
                StatusIndicator:Tween(nil, {BackgroundColor3 = FromRGB(240, 71, 71)})
                Library:Notification("Marked " .. player.Name .. " as Enemy", 3, FromRGB(240, 71, 71))
            end)
            
            -- Teleport Button
            local TeleportButton = Instances:Create("TextButton", {
                Parent = ButtonContainer.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(10, 10, 10),
                Text = "Teleport",
                AutoButtonColor = false,
                Name = "\0",
                Size = UDim2New(0, 70, 0, 18),
                BorderSizePixel = 2,
                TextSize = 11,
                BackgroundColor3 = FromRGB(88, 101, 242)
            })  TeleportButton:AddToTheme({BackgroundColor3 = "Accent", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = TeleportButton.Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Instances:Create("UIStroke", {
                Parent = TeleportButton.Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            TeleportButton:OnHover(function()
                TeleportButton:Tween(nil, {BackgroundColor3 = FromRGB(108, 121, 255)})
            end)
            
            TeleportButton:OnHoverLeave(function()
                TeleportButton:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
            end)
            
            TeleportButton:Connect("MouseButton1Click", function()
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
                        Library:Notification("Teleported to " .. player.Name, 3, FromRGB(88, 101, 242))
                    end
                else
                    Library:Notification("Cannot teleport - " .. player.Name .. " character not found", 3, FromRGB(240, 71, 71))
                end
            end)
            
            -- Info Container (Health, Distance, etc)
            local InfoContainer = Instances:Create("Frame", {
                Parent = PlayerEntry.Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 5, 0, 70),
                Size = UDim2New(1, -10, 0, 40),
                BorderSizePixel = 0,
                Visible = false
            })
            
            local HealthLabel = Instances:Create("TextLabel", {
                Parent = InfoContainer.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(180, 180, 180),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Health: 100/100",
                Name = "\0",
                Size = UDim2New(1, 0, 0, 13),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 0, 0, 0),
                BorderSizePixel = 0,
                TextSize = 11,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  HealthLabel:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = HealthLabel.Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            local DistanceLabel = Instances:Create("TextLabel", {
                Parent = InfoContainer.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(180, 180, 180),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Distance: N/A",
                Name = "\0",
                Size = UDim2New(1, 0, 0, 13),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 0, 0, 15),
                BorderSizePixel = 0,
                TextSize = 11,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  DistanceLabel:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = DistanceLabel.Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            -- Make buttons initially hidden
            ButtonContainer.Instance.Visible = false
            
            -- Click to expand/collapse
            local ClickButton = Instances:Create("TextButton", {
                Parent = PlayerEntry.Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 25),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false
            })
            
            -- Hover effect
            ClickButton:OnHover(function()
                PlayerEntry:Tween(nil, {BackgroundColor3 = FromRGB(35, 35, 40)})
            end)
            
            ClickButton:OnHoverLeave(function()
                PlayerEntry:Tween(nil, {BackgroundColor3 = Library.Theme["Page Background"]})
            end)
            
            ClickButton:Connect("MouseButton1Click", function()
                IsExpanded = not IsExpanded
                
                if IsExpanded then
                    PlayerEntry:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2New(1, -5, 0, 115)})
                    ExpandArrow:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 90})
                    ButtonContainer.Instance.Visible = true
                    InfoContainer.Instance.Visible = true
                else
                    PlayerEntry:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2New(1, -5, 0, 25)})
                    ExpandArrow:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = 0})
                    ButtonContainer.Instance.Visible = false
                    InfoContainer.Instance.Visible = false
                end
            end)
            
            -- Update health and distance
            Library:Thread(function()
                while player and player.Parent do
                    if player.Character then
                        local humanoid = player.Character:FindFirstChild("Humanoid")
                        if humanoid then
                            local health = math.floor(humanoid.Health)
                            local maxHealth = math.floor(humanoid.MaxHealth)
                            HealthLabel.Instance.Text = StringFormat("Health: %d/%d", health, maxHealth)
                        end
                        
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            DistanceLabel.Instance.Text = StringFormat("Distance: %d studs", math.floor(distance))
                        end
                    end
                    task.wait(0.5)
                end
            end)
            
            return PlayerEntry
        end

        function PlayerList:UpdatePlayerList()
            for _, child in pairs(Items["PlayerScroll"].Instance:GetChildren()) do
                if child:IsA("Frame") then
                    child:Destroy()
                end
            end
            
            local searchText = Items["SearchBox"].Instance.Text:lower()
            local playerCount = 0
            
            for _, player in pairs(Players:GetPlayers()) do
                if searchText == "" or player.Name:lower():find(searchText, 1, true) then
                    PlayerList:CreatePlayerEntry(player)
                    playerCount = playerCount + 1
                end
            end
            
            Items["PlayerCount"].Instance.Text = tostring(playerCount)
        end

        function PlayerList:SetVisibility(Bool)
            Items["PlayerListFrame"].Instance.Visible = Bool
        end
        
        function PlayerList:GetPlayerStatus(playerName)
            return PlayerStatuses[playerName]
        end

        PlayerList:UpdatePlayerList()
        
        -- Search box functionality
        Items["SearchBox"].Instance:GetPropertyChangedSignal("Text"):Connect(function()
            PlayerList:UpdatePlayerList()
        end)
        
        Players.PlayerAdded:Connect(function(player)
            task.wait(0.1)
            PlayerList:UpdatePlayerList()
        end)
        
        Players.PlayerRemoving:Connect(function(player)
            PlayerStatuses[player.Name] = nil
            PlayerList:UpdatePlayerList()
        end)

        return PlayerList
    end

Library.ESPPreview = function(self)
    local ESPPreview = {}
    local DraggableElements = {}
    local isDraggingElement = false
    local isSpinning = true
    
    local Items = {} do
        -- Main Preview Frame
        Items["PreviewFrame"] = Instances:Create("Frame", {
            Parent = Library.Holder.Instance,
            BorderColor3 = FromRGB(10, 10, 10),
            Name = "\0",
            Position = UDim2New(0.5, -200, 0.5, -250),
            Size = UDim2New(0, 400, 0, 560),
            BorderSizePixel = 2,
            BackgroundColor3 = FromRGB(15, 15, 20),
            Visible = false,
        })  Items["PreviewFrame"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
        
        -- Manual dragging for frame
        local frameIsDragging = false
        local frameDragStart = nil
        local frameStartPos = nil
        
        Items["PreviewFrame"].Instance.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and not isDraggingElement then
                frameIsDragging = true
                frameDragStart = input.Position
                frameStartPos = Items["PreviewFrame"].Instance.Position
            end
        end)
        
        Items["PreviewFrame"].Instance.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                frameIsDragging = false
            end
        end)
        
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if frameIsDragging and input.UserInputType == Enum.UserInputType.MouseMovement and not isDraggingElement then
                local delta = input.Position - frameDragStart
                Items["PreviewFrame"].Instance.Position = UDim2New(
                    frameStartPos.X.Scale,
                    frameStartPos.X.Offset + delta.X,
                    frameStartPos.Y.Scale,
                    frameStartPos.Y.Offset + delta.Y
                )
            end
        end)
        
        Instances:Create("UIStroke", {
            Parent = Items["PreviewFrame"].Instance,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Name = "\0",
            Color = FromRGB(27, 27, 32)
        }):AddToTheme({Color = "Outline"})
        
        -- Accent Line
        Items["AccentLine"] = Instances:Create("Frame", {
            Parent = Items["PreviewFrame"].Instance,
            Name = "\0",
            Position = UDim2New(0, -2, 0, -2),
            BorderColor3 = FromRGB(0, 0, 0),
            Size = UDim2New(1, 4, 0, 2),
            BorderSizePixel = 0,
            BackgroundColor3 = FromRGB(235, 157, 255)
        })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
        
        Instances:Create("UIGradient", {
            Parent = Items["AccentLine"].Instance,
            Rotation = 90,
            Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
        })
        
        -- Title
        Items["Title"] = Instances:Create("TextLabel", {
            Parent = Items["PreviewFrame"].Instance,
            FontFace = Library.Font,
            TextColor3 = FromRGB(215, 215, 215),
            BorderColor3 = FromRGB(0, 0, 0),
            Text = "ESP Preview",
            Name = "\0",
            Size = UDim2New(1, -10, 0, 15),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2New(0, 5, 0, 2),
            BorderSizePixel = 0,
            TextSize = 11,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
        
        Instances:Create("UIStroke", {
            Parent = Items["Title"].Instance,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Name = "\0"
        }):AddToTheme({Color = "Text Border"})
        
        -- Close Button
        Items["CloseButton"] = Instances:Create("TextButton", {
            Parent = Items["PreviewFrame"].Instance,
            FontFace = Library.Font,
            TextColor3 = FromRGB(215, 215, 215),
            BorderColor3 = FromRGB(0, 0, 0),
            Text = "X",
            AutoButtonColor = false,
            Name = "\0",
            Size = UDim2New(0, 20, 0, 15),
            Position = UDim2New(1, -25, 0, 2),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            TextSize = 12,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })  Items["CloseButton"]:AddToTheme({TextColor3 = "Text"})
        
        Items["CloseButton"]:OnHover(function()
            Items["CloseButton"]:Tween(nil, {TextColor3 = FromRGB(255, 85, 85)})
        end)
        
        Items["CloseButton"]:OnHoverLeave(function()
            Items["CloseButton"]:Tween(nil, {TextColor3 = Library.Theme.Text})
        end)
        
        -- Preview Container
        Items["PreviewContainer"] = Instances:Create("Frame", {
            Parent = Items["PreviewFrame"].Instance,
            Name = "\0",
            Position = UDim2New(0, 5, 0, 22),
            Size = UDim2New(1, -10, 1, -122),
            BackgroundColor3 = FromRGB(25, 25, 30),
            BorderColor3 = FromRGB(10, 10, 10),
            BorderSizePixel = 2
        })  Items["PreviewContainer"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Border"})
        
        Instances:Create("UIStroke", {
            Parent = Items["PreviewContainer"].Instance,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Name = "\0",
            Color = FromRGB(27, 27, 32)
        }):AddToTheme({Color = "Outline"})
        
        -- ViewportFrame for 3D Character
        Items["Viewport"] = Instances:Create("ViewportFrame", {
            Parent = Items["PreviewContainer"].Instance,
            Name = "\0",
            AnchorPoint = Vector2New(0.5, 0.5),
            Position = UDim2New(0.5, 0, 0.5, 0),
            Size = UDim2New(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ImageTransparency = 0,
            Ambient = Color3.fromRGB(100, 100, 100),
            LightColor = Color3.fromRGB(200, 200, 200),
            LightDirection = Vector3.new(0, -1, -2),
        })
        
        -- Create WorldModel
        local WorldModel = Instance.new("WorldModel")
        WorldModel.Parent = Items["Viewport"].Instance
        
        -- Create Camera - ADJUSTED TO CENTER CHARACTER BETTER
        local Camera = Instance.new("Camera")
        Camera.Parent = Items["Viewport"].Instance
        Items["Viewport"].Instance.CurrentCamera = Camera
        Camera.CFrame = CFrame.new(0, 0, 8) -- Moved camera closer and centered
        Camera.FieldOfView = 50
        
        -- Load character from user ID
        local DummyCharacter = nil
        local Humanoid = nil
        local AnimationController = nil
        local CurrentAnimation = nil
        
-- Find this part in the LoadCharacter function (around line 170):

local function LoadCharacter(userId)
    pcall(function()
        if DummyCharacter then
            DummyCharacter:Destroy()
        end
        
        -- Load character
        local success, result = pcall(function()
            return game:GetService("Players"):CreateHumanoidModelFromUserId(userId)
        end)
        
        if success and result then
            DummyCharacter = result
            DummyCharacter.Parent = WorldModel
            
            -- Position character - MOVED UP EVEN MORE
            local hrp = DummyCharacter:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Anchored = true
                hrp.CFrame = CFrame.new(0, 1, 0) -- Changed from -2 to 1 (moved up 3 units)
            end
            
            -- Get humanoid
            Humanoid = DummyCharacter:FindFirstChildOfClass("Humanoid")
            
            -- Create AnimationController if needed
            if not DummyCharacter:FindFirstChildOfClass("AnimationController") then
                AnimationController = Instance.new("AnimationController")
                AnimationController.Parent = DummyCharacter
            else
                AnimationController = DummyCharacter:FindFirstChildOfClass("AnimationController")
            end
            
            -- Add lights to all parts
            for _, part in pairs(DummyCharacter:GetDescendants()) do
                if part:IsA("BasePart") then
                    local light = Instance.new("SurfaceLight")
                    light.Brightness = 0.2
                    light.Range = 8
                    light.Parent = part
                end
            end
            
            ESPPreview.DummyCharacter = DummyCharacter
            ESPPreview.AnimationController = AnimationController
            
            Library:Notification("Loaded character: " .. userId, 2, Library.Theme.Accent)
        else
            Library:Notification("Failed to load character", 2, FromRGB(255, 85, 85))
        end
    end)
end
        
        -- Load the default character
        LoadCharacter(1620039146)
        
        -- ESP Overlay Canvas (MUST NOT CLIP)
        Items["ESPCanvas"] = Instances:Create("Frame", {
            Parent = Items["PreviewContainer"].Instance,
            Name = "\0",
            Size = UDim2New(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ZIndex = 5,
            ClipsDescendants = false,
        })
        
        -- ESP Box Container
        Items["ESPBox"] = Instances:Create("Frame", {
            Parent = Items["ESPCanvas"].Instance,
            Name = "\0",
            AnchorPoint = Vector2New(0.5, 0.5),
            Position = UDim2New(0.5, 0, 0.5, 0),
            Size = UDim2New(0, 140, 0, 250),
            BackgroundTransparency = 1,
            ZIndex = 5,
            ClipsDescendants = false,
        })
        
        -- Create skeleton lines
        local SkeletonLines = {}
        
        local skeletonConnections = {
            {"Head", "UpperTorso"},
            {"UpperTorso", "LowerTorso"},
            {"UpperTorso", "LeftUpperArm"},
            {"LeftUpperArm", "LeftLowerArm"},
            {"LeftLowerArm", "LeftHand"},
            {"UpperTorso", "RightUpperArm"},
            {"RightUpperArm", "RightLowerArm"},
            {"RightLowerArm", "RightHand"},
            {"LowerTorso", "LeftUpperLeg"},
            {"LeftUpperLeg", "LeftLowerLeg"},
            {"LeftLowerLeg", "LeftFoot"},
            {"LowerTorso", "RightUpperLeg"},
            {"RightUpperLeg", "RightLowerLeg"},
            {"RightLowerLeg", "RightFoot"}
        }
        
        for i, connection in ipairs(skeletonConnections) do
            local line = Instance.new("Frame")
            line.Name = "SkeletonLine_" .. i
            line.AnchorPoint = Vector2.new(0.5, 0.5)
            line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            line.BorderSizePixel = 0
            line.ZIndex = 4
            line.Visible = false
            line.Parent = Items["ESPCanvas"].Instance
            
            local lineStroke = Instance.new("UIStroke")
            lineStroke.Color = Color3.fromRGB(0, 0, 0)
            lineStroke.Thickness = 1
            lineStroke.Parent = line
            
            table.insert(SkeletonLines, {
                Frame = line,
                StartName = connection[1],
                EndName = connection[2]
            })
        end
        
        -- Function to update skeleton
        local function UpdateSkeletonLines()
            if not DummyCharacter then return end
            
            local shouldShow = Settings and Settings.Skeleton and Settings.Skeleton.Enabled
            
            if not shouldShow then
                for _, lineData in pairs(SkeletonLines) do
                    lineData.Frame.Visible = false
                end
                return
            end
            
            local camera = Items["Viewport"].Instance.CurrentCamera
            if not camera then return end
            
            local canvasPos = Items["ESPCanvas"].Instance.AbsolutePosition
            
            for _, lineData in pairs(SkeletonLines) do
                local startPart = DummyCharacter:FindFirstChild(lineData.StartName)
                local endPart = DummyCharacter:FindFirstChild(lineData.EndName)
                
                if startPart and endPart then
                    local startPos3D, startVisible = camera:WorldToViewportPoint(startPart.Position)
                    local endPos3D, endVisible = camera:WorldToViewportPoint(endPart.Position)
                    
                    if startVisible and endVisible then
                        local startX = startPos3D.X - canvasPos.X
                        local startY = startPos3D.Y - canvasPos.Y
                        local endX = endPos3D.X - canvasPos.X
                        local endY = endPos3D.Y - canvasPos.Y
                        
                        local midX = (startX + endX) / 2
                        local midY = (startY + endY) / 2
                        local dx = endX - startX
                        local dy = endY - startY
                        local length = math.sqrt(dx * dx + dy * dy)
                        local angle = math.deg(math.atan2(dy, dx))
                        
                        lineData.Frame.Position = UDim2.new(0, midX, 0, midY)
                        lineData.Frame.Size = UDim2.new(0, length, 0, Settings.Skeleton.Thickness or 1)
                        lineData.Frame.Rotation = angle
                        lineData.Frame.Visible = true
                        
                        local skeletonColor = Settings.Skeleton.Color or Color3.fromRGB(255, 255, 255)
                        lineData.Frame.BackgroundColor3 = skeletonColor
                        lineData.Frame.BackgroundTransparency = Settings.Skeleton.Transparency or 0
                    else
                        lineData.Frame.Visible = false
                    end
                else
                    lineData.Frame.Visible = false
                end
            end
        end
        
-- Rotate character and update skeleton every frame
local rotation = 0
game:GetService("RunService").RenderStepped:Connect(function()
    if Items["PreviewFrame"].Instance.Visible and DummyCharacter then
        local hrp = DummyCharacter:FindFirstChild("HumanoidRootPart")
        if hrp and isSpinning then
            rotation = rotation + 0.3
            hrp.CFrame = CFrame.new(0, 1, 0) * CFrame.Angles(0, math.rad(rotation), 0)
        end
        
        UpdateSkeletonLines()
    end
end)
        
        -- Corner Box System
        local CornerFrames = {}
        
        local function UpdateBoxType()
            for _, frame in pairs(CornerFrames) do
                if frame then frame:Destroy() end
            end
            
            CornerFrames = {}
            
            if Settings and Settings.BoundingBox and Settings.BoundingBox.BoxType == 'corner' then
                local cornerLength = 20
                local cornerThickness = 2
                local boxColor = Settings.BoundingBox.Color and Settings.BoundingBox.Color[1] or Color3.fromRGB(100, 120, 180)
                
                -- Top Left
                local TL1 = Instance.new("Frame")
                TL1.Size = UDim2.new(0, cornerLength, 0, cornerThickness)
                TL1.Position = UDim2.new(0, 0, 0, 0)
                TL1.BackgroundColor3 = boxColor
                TL1.BorderSizePixel = 0
                TL1.ZIndex = 6
                TL1.Parent = Items["ESPBox"].Instance
                table.insert(CornerFrames, TL1)
                
                local TL2 = Instance.new("Frame")
                TL2.Size = UDim2.new(0, cornerThickness, 0, cornerLength)
                TL2.Position = UDim2.new(0, 0, 0, 0)
                TL2.BackgroundColor3 = boxColor
                TL2.BorderSizePixel = 0
                TL2.ZIndex = 6
                TL2.Parent = Items["ESPBox"].Instance
                table.insert(CornerFrames, TL2)
                
                -- Top Right
                local TR1 = Instance.new("Frame")
                TR1.Size = UDim2.new(0, cornerLength, 0, cornerThickness)
                TR1.Position = UDim2.new(1, -cornerLength, 0, 0)
                TR1.BackgroundColor3 = boxColor
                TR1.BorderSizePixel = 0
                TR1.ZIndex = 6
                TR1.Parent = Items["ESPBox"].Instance
                table.insert(CornerFrames, TR1)
                
                local TR2 = Instance.new("Frame")
                TR2.Size = UDim2.new(0, cornerThickness, 0, cornerLength)
                TR2.Position = UDim2.new(1, -cornerThickness, 0, 0)
                TR2.BackgroundColor3 = boxColor
                TR2.BorderSizePixel = 0
                TR2.ZIndex = 6
                TR2.Parent = Items["ESPBox"].Instance
                table.insert(CornerFrames, TR2)
                
                -- Bottom Left
                local BL1 = Instance.new("Frame")
                BL1.Size = UDim2.new(0, cornerLength, 0, cornerThickness)
                BL1.Position = UDim2.new(0, 0, 1, -cornerThickness)
                BL1.BackgroundColor3 = boxColor
                BL1.BorderSizePixel = 0
                BL1.ZIndex = 6
                BL1.Parent = Items["ESPBox"].Instance
                table.insert(CornerFrames, BL1)
                
                local BL2 = Instance.new("Frame")
                BL2.Size = UDim2.new(0, cornerThickness, 0, cornerLength)
                BL2.Position = UDim2.new(0, 0, 1, -cornerLength)
                BL2.BackgroundColor3 = boxColor
                BL2.BorderSizePixel = 0
                BL2.ZIndex = 6
                BL2.Parent = Items["ESPBox"].Instance
                table.insert(CornerFrames, BL2)
                
                -- Bottom Right
                local BR1 = Instance.new("Frame")
                BR1.Size = UDim2.new(0, cornerLength, 0, cornerThickness)
                BR1.Position = UDim2.new(1, -cornerLength, 1, -cornerThickness)
                BR1.BackgroundColor3 = boxColor
                BR1.BorderSizePixel = 0
                BR1.ZIndex = 6
                BR1.Parent = Items["ESPBox"].Instance
                table.insert(CornerFrames, BR1)
                
                local BR2 = Instance.new("Frame")
                BR2.Size = UDim2.new(0, cornerThickness, 0, cornerLength)
                BR2.Position = UDim2.new(1, -cornerThickness, 1, -cornerLength)
                BR2.BackgroundColor3 = boxColor
                BR2.BorderSizePixel = 0
                BR2.ZIndex = 6
                BR2.Parent = Items["ESPBox"].Instance
                table.insert(CornerFrames, BR2)
            end
        end
        
        UpdateBoxType()
        
        task.spawn(function()
            while true do
                task.wait(0.5)
                if Items["PreviewFrame"].Instance.Visible then
                    UpdateBoxType()
                end
            end
        end)
        
        -- Health Bar (Left Side)
        Items["HealthBarBG"] = Instances:Create("Frame", {
            Parent = Items["ESPBox"].Instance,
            Name = "\0",
            Position = UDim2New(0, -8, 0, 0),
            Size = UDim2New(0, 3, 1, 0),
            BackgroundColor3 = FromRGB(20, 20, 25),
            BorderSizePixel = 0,
            ZIndex = 6,
        })
        
        Items["HealthBarFill"] = Instances:Create("Frame", {
            Parent = Items["HealthBarBG"].Instance,
            Name = "\0",
            Size = UDim2New(1, 0, 0.61, 0),
            AnchorPoint = Vector2New(0, 1),
            Position = UDim2New(0, 0, 1, 0),
            BackgroundColor3 = FromRGB(131, 245, 78),
            BorderSizePixel = 0,
            ZIndex = 7,
        })
        
        Instances:Create("UIGradient", {
            Parent = Items["HealthBarFill"].Instance,
            Rotation = -90,
            Color = RGBSequence{
                RGBSequenceKeypoint(0, FromRGB(131, 245, 78)),
                RGBSequenceKeypoint(0.5, FromRGB(255, 255, 0)),
                RGBSequenceKeypoint(1, FromRGB(252, 71, 77))
            }
        })
        
        -- Health Text
        Items["HealthText"] = Instances:Create("TextLabel", {
            Parent = Items["ESPBox"].Instance,
            FontFace = Library.Font,
            TextColor3 = FromRGB(255, 255, 255),
            BorderColor3 = FromRGB(0, 0, 0),
            Text = "61%\n61HP",
            Name = "\0",
            Size = UDim2New(0, 40, 0, 30),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Right,
            Position = UDim2New(0, -45, 0.5, -15),
            BorderSizePixel = 0,
            TextSize = 9,
            ZIndex = 10,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })
        
        Instances:Create("UIStroke", {
            Parent = Items["HealthText"].Instance,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Thickness = 1.5,
            Color = FromRGB(0, 0, 0),
            Name = "\0"
        })
        
        -- Position cycles
        local PositionCycles = {
            Name = {'Top', 'Bottom'},
            Distance = {'Bottom'},
            Weapon = {'Bottom'},
            Flags = {'Right'},
        }
        
        local PositionPresets = {
            Name = {
                Top = UDim2.new(0.5, -50, 0, -25),
                Bottom = UDim2.new(0.5, -50, 1, 10),
            },
            Distance = {
                Bottom = UDim2.new(0.5, -50, 1, 30),
            },
            Weapon = {
                Bottom = UDim2.new(0.5, -50, 1, 50),
            },
            Flags = {
                Right = UDim2.new(1, 20, 0, 15),
            },
        }
        
        -- Create text-only elements (NO BACKGROUNDS)
        function ESPPreview:CreateClickableElement(name, defaultPos, text, color)
            local currentPositionIndex = 1
            local currentPosition = PositionCycles[name][1]
            
            -- Container frame to hold everything
            local ElementContainer = Instance.new("Frame")
            ElementContainer.Name = name
            ElementContainer.Size = UDim2.new(0, 100, 0, 14)
            ElementContainer.Position = defaultPos
            ElementContainer.BackgroundTransparency = 1
            ElementContainer.ZIndex = 10
            ElementContainer.Parent = Items["ESPBox"].Instance
            
            -- Text Label
            local ElementText = Instance.new("TextLabel")
            ElementText.FontFace = Library.Font
            ElementText.TextColor3 = color or Color3.fromRGB(255, 255, 255)
            ElementText.Text = text
            ElementText.Size = UDim2.new(1, 0, 1, 0)
            ElementText.BackgroundTransparency = 1
            ElementText.TextXAlignment = Enum.TextXAlignment.Center
            ElementText.TextYAlignment = Enum.TextYAlignment.Center
            ElementText.TextSize = 11
            ElementText.ZIndex = 10
            ElementText.Parent = ElementContainer
            
            local TextStroke = Instance.new("UIStroke")
            TextStroke.LineJoinMode = Enum.LineJoinMode.Miter
            TextStroke.Thickness = 1.5
            TextStroke.Color = Color3.fromRGB(0, 0, 0)
            TextStroke.Parent = ElementText
            
            -- Position indicator (small tag)
            local PositionIndicator = Instance.new("TextLabel")
            PositionIndicator.FontFace = Library.Font
            PositionIndicator.TextColor3 = Library.Theme.Accent
            PositionIndicator.Text = "[" .. currentPosition .. "]"
            PositionIndicator.Size = UDim2.new(0, 50, 0, 8)
            PositionIndicator.BackgroundTransparency = 1
            PositionIndicator.TextXAlignment = Enum.TextXAlignment.Center
            PositionIndicator.Position = UDim2.new(0.5, -25, 0, -10)
            PositionIndicator.TextSize = 8
            PositionIndicator.ZIndex = 11
            PositionIndicator.Parent = ElementContainer
            
            local IndicatorStroke = Instance.new("UIStroke")
            IndicatorStroke.LineJoinMode = Enum.LineJoinMode.Miter
            IndicatorStroke.Color = Color3.fromRGB(0, 0, 0)
            IndicatorStroke.Parent = PositionIndicator
            
            -- Clickable button that covers everything
            local ClickButton = Instance.new("TextButton")
            ClickButton.Size = UDim2.new(1, 0, 1, 20)
            ClickButton.Position = UDim2.new(0, 0, 0, -10)
            ClickButton.BackgroundTransparency = 1
            ClickButton.Text = ""
            ClickButton.ZIndex = 12
            ClickButton.AutoButtonColor = false
            ClickButton.Parent = ElementContainer
            
            ClickButton.MouseButton1Click:Connect(function()
                currentPositionIndex = currentPositionIndex % #PositionCycles[name] + 1
                currentPosition = PositionCycles[name][currentPositionIndex]
                local newPos = PositionPresets[name][currentPosition]
                
                game:GetService("TweenService"):Create(
                    ElementContainer,
                    TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Position = newPos}
                ):Play()
                
                PositionIndicator.Text = "[" .. currentPosition .. "]"
                
                -- Brief flash
                game:GetService("TweenService"):Create(
                    ElementText,
                    TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {TextColor3 = Library.Theme.Accent}
                ):Play()
                
                task.wait(0.1)
                
                game:GetService("TweenService"):Create(
                    ElementText,
                    TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {TextColor3 = color or Color3.fromRGB(255, 255, 255)}
                ):Play()
                
                Library:Notification(name .. " → " .. currentPosition, 1, Library.Theme.Accent)
            end)
            
            -- Hover effect (subtle glow)
            ClickButton.MouseEnter:Connect(function()
                game:GetService("TweenService"):Create(
                    TextStroke,
                    TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Color = Library.Theme.Accent, Thickness = 2}
                ):Play()
            end)
            
            ClickButton.MouseLeave:Connect(function()
                game:GetService("TweenService"):Create(
                    TextStroke,
                    TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                    {Color = Color3.fromRGB(0, 0, 0), Thickness = 1.5}
                ):Play()
            end)
            
            DraggableElements[name] = {
                Element = ElementContainer,
                GetPosition = function()
                    return currentPosition
                end,
            }
            
            return ElementContainer
        end
        
        ESPPreview:CreateClickableElement("Name", UDim2.new(0.5, -50, 0, -25), "username", Color3.fromRGB(255, 255, 255))
        ESPPreview:CreateClickableElement("Distance", UDim2.new(0.5, -50, 1, 30), "10m", Color3.fromRGB(180, 180, 180))
        ESPPreview:CreateClickableElement("Weapon", UDim2.new(0.5, -50, 1, 50), "none", Color3.fromRGB(255, 200, 100))
        ESPPreview:CreateClickableElement("Flags", UDim2.new(1, 20, 0, 15), "MOV", Color3.fromRGB(100, 255, 150))
        
        -- Bottom Control Panel
        Items["ControlPanel"] = Instances:Create("Frame", {
            Parent = Items["PreviewFrame"].Instance,
            Name = "\0",
            Position = UDim2New(0, 5, 1, -95),
            Size = UDim2New(1, -10, 0, 90),
            BackgroundColor3 = FromRGB(20, 20, 25),
            BorderColor3 = FromRGB(10, 10, 10),
            BorderSizePixel = 2,
        })  Items["ControlPanel"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Border"})
        
        Instances:Create("UIStroke", {
            Parent = Items["ControlPanel"].Instance,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Name = "\0",
            Color = FromRGB(27, 27, 32)
        }):AddToTheme({Color = "Outline"})
        
        Instances:Create("UIPadding", {
            Parent = Items["ControlPanel"].Instance,
            PaddingTop = UDimNew(0, 5),
            PaddingBottom = UDimNew(0, 5),
            PaddingLeft = UDimNew(0, 5),
            PaddingRight = UDimNew(0, 5)
        })
        
        -- User ID Input
        Items["UserIDLabel"] = Instances:Create("TextLabel", {
            Parent = Items["ControlPanel"].Instance,
            FontFace = Library.Font,
            TextColor3 = FromRGB(215, 215, 215),
            BorderColor3 = FromRGB(0, 0, 0),
            Text = "User ID:",
            Name = "\0",
            Size = UDim2New(0, 55, 0, 15),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2New(0, 0, 0, 0),
            BorderSizePixel = 0,
            TextSize = 11,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })  Items["UserIDLabel"]:AddToTheme({TextColor3 = "Text"})
        
        Instances:Create("UIStroke", {
            Parent = Items["UserIDLabel"].Instance,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Name = "\0"
        }):AddToTheme({Color = "Text Border"})
        
        Items["UserIDBox"] = Instances:Create("TextBox", {
            Parent = Items["ControlPanel"].Instance,
            FontFace = Library.Font,
            TextColor3 = FromRGB(215, 215, 215),
            BorderColor3 = FromRGB(10, 10, 10),
            Text = "1620039146",
            Name = "\0",
            Size = UDim2New(1, -65, 0, 15),
            Position = UDim2New(0, 60, 0, 0),
            BorderSizePixel = 2,
            ClearTextOnFocus = false,
            BackgroundColor3 = FromRGB(33, 33, 36),
            PlaceholderColor3 = FromRGB(178, 178, 178),
            TextXAlignment = Enum.TextXAlignment.Left,
            PlaceholderText = "Enter User ID",
            TextSize = 11,
        })  Items["UserIDBox"]:AddToTheme({TextColor3 = "Text", BackgroundColor3 = "Element", BorderColor3 = "Border"})
        
        Instances:Create("UIPadding", {
            Parent = Items["UserIDBox"].Instance,
            PaddingLeft = UDimNew(0, 5)
        })
        
        Instances:Create("UIStroke", {
            Parent = Items["UserIDBox"].Instance,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Name = "\0",
            Color = FromRGB(27, 27, 32)
        }):AddToTheme({Color = "Outline"})
        
        Items["UserIDBox"]:Connect("Focused", function()
            Items["UserIDBox"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
        end)
        
        Items["UserIDBox"]:Connect("FocusLost", function(enterPressed)
            Items["UserIDBox"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
            if enterPressed then
                local userId = tonumber(Items["UserIDBox"].Instance.Text)
                if userId then
                    LoadCharacter(userId)
                else
                    Library:Notification("Invalid User ID", 2, FromRGB(255, 85, 85))
                end
            end
        end)
        
        -- Animation ID Input
        Items["AnimIDLabel"] = Instances:Create("TextLabel", {
            Parent = Items["ControlPanel"].Instance,
            FontFace = Library.Font,
            TextColor3 = FromRGB(215, 215, 215),
            BorderColor3 = FromRGB(0, 0, 0),
            Text = "Animation ID:",
            Name = "\0",
            Size = UDim2New(0, 80, 0, 15),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2New(0, 0, 0, 22),
            BorderSizePixel = 0,
            TextSize = 11,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })  Items["AnimIDLabel"]:AddToTheme({TextColor3 = "Text"})
        
        Instances:Create("UIStroke", {
            Parent = Items["AnimIDLabel"].Instance,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Name = "\0"
        }):AddToTheme({Color = "Text Border"})
        
        Items["AnimIDBox"] = Instances:Create("TextBox", {
            Parent = Items["ControlPanel"].Instance,
            FontFace = Library.Font,
            TextColor3 = FromRGB(215, 215, 215),
            BorderColor3 = FromRGB(10, 10, 10),
            Text = "",
            Name = "\0",
            Size = UDim2New(1, -160, 0, 15),
            Position = UDim2New(0, 85, 0, 22),
            BorderSizePixel = 2,
            ClearTextOnFocus = false,
            BackgroundColor3 = FromRGB(33, 33, 36),
            PlaceholderColor3 = FromRGB(178, 178, 178),
            TextXAlignment = Enum.TextXAlignment.Left,
            PlaceholderText = "Animation ID",
            TextSize = 11,
        })  Items["AnimIDBox"]:AddToTheme({TextColor3 = "Text", BackgroundColor3 = "Element", BorderColor3 = "Border"})
        
        Instances:Create("UIPadding", {
            Parent = Items["AnimIDBox"].Instance,
            PaddingLeft = UDimNew(0, 5)
        })
        
        Instances:Create("UIStroke", {
            Parent = Items["AnimIDBox"].Instance,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Name = "\0",
            Color = FromRGB(27, 27, 32)
        }):AddToTheme({Color = "Outline"})
        
        Items["AnimIDBox"]:Connect("Focused", function()
            Items["AnimIDBox"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
        end)
        
        Items["AnimIDBox"]:Connect("FocusLost", function()
            Items["AnimIDBox"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
        end)
        
        -- Play Animation Button
        Items["PlayAnimButton"] = Instances:Create("TextButton", {
            Parent = Items["ControlPanel"].Instance,
            FontFace = Library.Font,
            TextColor3 = FromRGB(215, 215, 215),
            BorderColor3 = FromRGB(10, 10, 10),
            Text = "Play",
            AutoButtonColor = false,
            Name = "\0",
            Size = UDim2New(0, 65, 0, 15),
            Position = UDim2New(1, -70, 0, 22),
            BorderSizePixel = 2,
            TextSize = 11,
            BackgroundColor3 = FromRGB(33, 33, 36)
        })  Items["PlayAnimButton"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border", TextColor3 = "Text"})
        
        Instances:Create("UIStroke", {
            Parent = Items["PlayAnimButton"].Instance,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Name = "\0",
            Color = FromRGB(27, 27, 32)
        }):AddToTheme({Color = "Outline"})
        
        Items["PlayAnimButton"]:OnHover(function()
            Items["PlayAnimButton"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
        end)
        
        Items["PlayAnimButton"]:OnHoverLeave(function()
            Items["PlayAnimButton"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
        end)
        
        Items["PlayAnimButton"]:Connect("MouseButton1Click", function()
            local animId = tonumber(Items["AnimIDBox"].Instance.Text)
            if animId then
                ESPPreview:PlayAnimation(animId)
            else
                Library:Notification("Invalid Animation ID", 2, FromRGB(255, 85, 85))
            end
        end)
        
        -- Spin Toggle
        Items["SpinToggle"] = Instances:Create("TextButton", {
            Parent = Items["ControlPanel"].Instance,
            FontFace = Library.Font,
            TextColor3 = FromRGB(0, 0, 0),
            BorderColor3 = FromRGB(0, 0, 0),
            Text = "",
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Name = "\0",
            Size = UDim2New(1, 0, 0, 11),
            Position = UDim2New(0, 0, 0, 44),
            BorderSizePixel = 0,
            TextSize = 14,
            BackgroundColor3 = FromRGB(255, 255, 255)
        }) 
        
        Items["SpinIndicator"] = Instances:Create("Frame", {
            Parent = Items["SpinToggle"].Instance,
            Name = "\0",
            BorderColor3 = FromRGB(10, 10, 10),
            Size = UDim2New(0, 10, 0, 10),
            BorderSizePixel = 2,
            BackgroundColor3 = FromRGB(235, 157, 255)
        })  Items["SpinIndicator"]:AddToTheme({BackgroundColor3 = "Accent", BorderColor3 = "Border"})
        
        Instances:Create("UIStroke", {
            Parent = Items["SpinIndicator"].Instance,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Name = "\0",
            Color = FromRGB(27, 27, 32)
        }):AddToTheme({Color = "Outline"})
        
        Instances:Create("UIGradient", {
            Parent = Items["SpinIndicator"].Instance,
            Rotation = 90,
            Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
        }) 
        
        Items["SpinText"] = Instances:Create("TextLabel", {
            Parent = Items["SpinToggle"].Instance,
            FontFace = Library.Font,
            TextColor3 = FromRGB(215, 215, 215),
            TextTransparency = 0,
            Text = "Spin Character",
            Name = "\0",
            Size = UDim2New(1, 0, 1, 0),
            Position = UDim2New(0, 18, 0, -1),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            BorderColor3 = FromRGB(0, 0, 0),
            TextSize = 12,
            BackgroundColor3 = FromRGB(255, 255, 255)
        })  Items["SpinText"]:AddToTheme({TextColor3 = "Text"})
        
        Instances:Create("UIStroke", {
            Parent = Items["SpinText"].Instance,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Name = "\0"
        }):AddToTheme({Color = "Text Border"})
        
        Items["SpinToggle"]:OnHover(function()
            if not isSpinning then
                Items["SpinIndicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["SpinIndicator"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
            end
        end)
        
        Items["SpinToggle"]:OnHoverLeave(function()
            if not isSpinning then
                Items["SpinIndicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
                Items["SpinIndicator"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            end
        end)
        
        Items["SpinToggle"]:Connect("MouseButton1Down", function()
            isSpinning = not isSpinning
            
            if isSpinning then 
                Items["SpinIndicator"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                Items["SpinIndicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
                Items["SpinText"]:Tween(nil, {TextTransparency = 0})
            else
                Items["SpinIndicator"]:ChangeItemTheme({BackgroundColor3 = "Element"})
                Items["SpinIndicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                Items["SpinText"]:Tween(nil, {TextTransparency = 0.48})
            end
        end)
        
        -- Apply Button (NORMAL COLOR - NOT ACCENT)
        Items["ApplyButton"] = Instances:Create("TextButton", {
            Parent = Items["ControlPanel"].Instance,
            FontFace = Library.Font,
            TextColor3 = FromRGB(215, 215, 215),
            BorderColor3 = FromRGB(10, 10, 10),
            Text = "Apply Positions",
            AutoButtonColor = false,
            Name = "\0",
            Size = UDim2New(1, 0, 0, 20),
            Position = UDim2New(0, 0, 0, 60),
            BorderSizePixel = 2,
            TextSize = 11,
            BackgroundColor3 = FromRGB(33, 33, 36)
        })  Items["ApplyButton"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border", TextColor3 = "Text"})
        
        Instances:Create("UIStroke", {
            Parent = Items["ApplyButton"].Instance,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Name = "\0",
            Color = FromRGB(27, 27, 32)
        }):AddToTheme({Color = "Outline"})
        
        Instances:Create("UIGradient", {
            Parent = Items["ApplyButton"].Instance,
            Rotation = 90,
            Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
        })
        
        Items["ApplyButton"]:OnHover(function()
            Items["ApplyButton"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
        end)
        
        Items["ApplyButton"]:OnHoverLeave(function()
            Items["ApplyButton"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
        end)
        
        -- Store references
        ESPPreview.DummyCharacter = DummyCharacter
        ESPPreview.AnimationController = AnimationController
        ESPPreview.CurrentAnimation = CurrentAnimation
        ESPPreview.LoadCharacter = LoadCharacter
    end
    
    -- Functions
    function ESPPreview:SetVisibility(Bool)
        Items["PreviewFrame"].Instance.Visible = Bool
    end
    
    function ESPPreview:PlayAnimation(animId)
        pcall(function()
            if not ESPPreview.AnimationController then return end
            
            -- Stop current animation
            if ESPPreview.CurrentAnimation then
                ESPPreview.CurrentAnimation:Stop()
            end
            
            -- Create and play new animation
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. tostring(animId)
            
            local animTrack = ESPPreview.AnimationController:LoadAnimation(anim)
            animTrack:Play()
            
            ESPPreview.CurrentAnimation = animTrack
            
            Library:Notification("Playing animation: " .. animId, 2, Library.Theme.Accent)
        end)
    end
    
    function ESPPreview:GetElementPositions()
        local positions = {}
        for name, data in pairs(DraggableElements) do
            positions[name] = data.GetPosition()
        end
        return positions
    end
    
    function ESPPreview:ApplyToESP()
        local positions = ESPPreview:GetElementPositions()
        
        if not Settings then
            Library:Notification("Error: Settings table not found!", 3, Color3.fromRGB(255, 85, 85))
            return
        end
        
        for name, position in pairs(positions) do
            if name == "Name" and Settings.Name then
                Settings.Name.Position = position
            elseif name == "Distance" and Settings.Distance then
                Settings.Distance.Position = position
            elseif name == "Weapon" and Settings.Weapon then
                Settings.Weapon.Position = position
            elseif name == "Flags" and Settings.Flags then
                Settings.Flags.Position = position
            end
        end
        
        Library:Notification("ESP positions applied!", 3, Color3.fromRGB(85, 255, 127))
    end
    
    -- Button Events
    Items["CloseButton"]:Connect("MouseButton1Click", function()
        ESPPreview:SetVisibility(false)
    end)
    
    Items["ApplyButton"]:Connect("MouseButton1Click", function()
        ESPPreview:ApplyToESP()
    end)
    
    return ESPPreview
end
    Library.CreateColorpicker = function(self, Data)
        local Colorpicker = {
            Hue = 0,
            Saturation = 0,
            Value = 0,

            Alpha = 0,

            HexValue = "",
            
            IsOpen = false,

            Color = FromRGB(0, 0, 0),

            Class = "Colorpicker"
        }

        Library.Flags[Data.Flag] = { }

        local Items = { } do
            Items["ColorpickerButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0.5),
                Name = "\0",
                Position = UDim2New(1, 0, 0.5, 0),
                Size = UDim2New(0, 20, 0, 10),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 0, 0)
            }) 


            Colorpicker.CalculateCount = function(self, Index, YScale, YOffset)
                local MaxButtonsAdded = 5

                local Column = Index % MaxButtonsAdded
            
                local ButtonSize = Items["ColorpickerButton"].Instance.AbsoluteSize
                local Spacing = 4
            
                local XPosition = (ButtonSize.X + Spacing) * Column - Spacing - 21
            
                Items["ColorpickerButton"].Instance.Position = UDim2New(1, -XPosition, YScale or 0.5, YOffset or 0)
            end

            Colorpicker:CalculateCount(Data.Count)
            
            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerButton"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Instances:Create("UIGradient", {
                Parent = Items["ColorpickerButton"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            })             

            Items["ColorpickerWindow"] = Instances:Create("TextButton", {
                Parent = Library.Holder.Instance,
                AutoButtonColor = false,
                Text = "",
                Name = "\0",
                Position = UDim2New(0, Data.Parent.Instance.AbsolutePosition.X, 0, Data.Parent.Instance.AbsolutePosition.Y + 15),
                BorderColor3 = FromRGB(10, 10, 10),
                Visible = false,
                Size = UDim2New(0, 238, 0, 224),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["ColorpickerWindow"]:AddToTheme({BackgroundColor3 = "Background"})
            
            Items["ColorpickerWindow"]:MakeDraggable()
            Items["ColorpickerWindow"]:MakeResizeable(Vector2New(200, 180), Vector2New(9999, 9999))

            Instances:Create("UIStroke", {
                Parent = Items["ColorpickerWindow"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["ColorpickerWindow"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Data.Name,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, -2, 0, -3),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Title"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["ColorpickerWindow"].Instance,
                Name = "\0",
                Position = UDim2New(0, -6, 0, -6),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 12, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(235, 157, 255)
            })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            }) 
            
            Instances:Create("UIPadding", {
                Parent = Items["ColorpickerWindow"].Instance,
                PaddingTop = UDimNew(0, 6),
                PaddingBottom = UDimNew(0, 6),
                PaddingRight = UDimNew(0, 6),
                PaddingLeft = UDimNew(0, 6)
            }) 
            
            Items["Palette"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                Position = UDim2New(0, 0, 0, 15),
                Size = UDim2New(1, -26, 1, -40),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 0, 0)
            }) 
            
            Items["Saturation"] = Instances:Create("ImageLabel", {
                Parent = Items["Palette"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Saturation"),
                BackgroundTransparency = 1,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Value"] = Instances:Create("ImageLabel", {
                Parent = Items["Palette"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Value"),
                BackgroundTransparency = 1,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["Palette"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["PaletteDragger"] = Instances:Create("Frame", {
                Parent = Items["Palette"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 2, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["PaletteDragger"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Hue"] = Instances:Create("ImageButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0),
                Image = Library:GetImage("Hue"),
                Name = "\0",
                Position = UDim2New(1, 0, 0, 15),
                Size = UDim2New(0, 18, 1, -15),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["HueDragger"] = Instances:Create("Frame", {
                Parent = Items["Hue"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 1),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["HueDragger"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Hue"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Alpha"] = Instances:Create("TextButton", {
                Parent = Items["ColorpickerWindow"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, -26, 0, 18),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 0, 0)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["Alpha"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Checkers"] = Instances:Create("ImageLabel", {
                Parent = Items["Alpha"].Instance,
                ScaleType = Enum.ScaleType.Tile,
                BorderColor3 = FromRGB(0, 0, 0),
                Image = Library:GetImage("Checkers"),
                TileSize = UDim2New(0, 6, 0, 6),
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIGradient", {
                Parent = Items["Checkers"].Instance,
                Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
            }) 
            
            Instances:Create("UIGradient", {
                Parent = Items["Alpha"].Instance,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(0, 0, 0))}
            }) 
            
            Items["AlphaDragger"] = Instances:Create("Frame", {
                Parent = Items["Alpha"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0, 1, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["AlphaDragger"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
        end

        local SlidingPalette = false
        local SlidingHue = false
        local SlidingAlpha = false

        local Debounce = false

        function Colorpicker:SetOpen(Bool)
            if Debounce then 
                return 
            end

            Colorpicker.IsOpen = Bool

            Debounce = true 

            if Bool then 
                Items["ColorpickerWindow"].Instance.Visible = true
                Items["ColorpickerWindow"].Instance.Position = UDim2New(0, Data.Parent.Instance.AbsolutePosition.X, 0, Data.Parent.Instance.AbsolutePosition.Y + 15)

                if Library.CurrentColorpicker then
                    Library.CurrentColorpicker:SetOpen(false)
                    Library.CurrentColorpicker = nil 
                end

                if not Library.CurrentColorpicker then 
                    Library.CurrentColorpicker = Colorpicker
                end
            else
                Library.CurrentColorpicker = nil
            end

            local Descendants = Items["ColorpickerWindow"].Instance:GetDescendants()
            TableInsert(Descendants, Items["ColorpickerWindow"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if not StringFind(Value.ClassName, "UI") then 
                    Value.ZIndex = Bool and 10001 or 1
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, Data.FadeSpeed)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, Data.FadeSpeed)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["ColorpickerWindow"].Instance.Visible = Bool
            end)
        end

        function Colorpicker:Get()
            return Colorpicker.Value
        end

        function Colorpicker:SetVisibility(Bool)
           Data.Parent.Instance.Visible = Bool 
        end

        function Colorpicker:Set(Color, Alpha)
            if type(Color) == "table" then 
                Color = FromRGB(Color[1], Color[2], Color[3])
                Alpha = Color[4]
            elseif type(Color) == "string" then 
                Color = FromHex(Color)
            end

            self.Hue, self.Saturation, self.Value = Color:ToHSV()
            self.Alpha = Alpha or 0

            self.Color = FromHSV(self.Hue, self.Saturation, self.Value)
            self.HexValue = self.Color:ToHex()

            Library.Flags[Data.Flag] = {
                Color = self.Color,
                HexValue =  self.HexValue,
                Alpha = self.Alpha
            }

            local ColorPositionX = MathClamp(1 - self.Saturation, 0, 0.989)
            local ColorPositionY = MathClamp(1 - self.Value, 0, 0.989)

            Items["PaletteDragger"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(ColorPositionX, 0, ColorPositionY, 0)})

            local HuePositionY = MathClamp(self.Hue, 0, 0.994)

            Items["HueDragger"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, HuePositionY, 0)})

            local AlphaPositionX = MathClamp(self.Alpha, 0, 0.994)

            Items["AlphaDragger"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(AlphaPositionX, 0, 0, 0)})

            self:Update()
        end

        function Colorpicker:Update(IsFromAlpha)
            self.Color = FromHSV(self.Hue, self.Saturation, self.Value)
            self.HexValue = self.Color:ToHex()

            Library.Flags[Data.Flag] = {
                Color = self.Color,
                HexValue =  self.HexValue,
                Alpha = self.Alpha
            }

            Items["ColorpickerButton"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = self.Color})
            Items["Palette"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = FromHSV(self.Hue, 1, 1)})

            if not IsFromAlpha then 
                Items["Alpha"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = self.Color})
            end

            if Data.Callback then 
                Library:SafeCall(Data.Callback, self.Color, self.Alpha)
            end
        end

        function Colorpicker:SlidePalette(Input)
            if not Input or not SlidingPalette then 
                return
            end

            local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
            local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

            self.Saturation = ValueX
            self.Value = ValueY

            local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.989)
            local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.989)

            Items["PaletteDragger"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, SlideY, 0)})
            self:Update()            
        end

        function Colorpicker:SlideHue(Input)
            if not Input or not SlidingHue then 
                return
            end

            local ValueY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)

            self.Hue = ValueY

            local PositionY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.994)

            Items["HueDragger"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, PositionY, 0)})
            self:Update()
        end

        function Colorpicker:SlideAlpha(Input)
            if not Input or not SlidingAlpha then 
                return
            end

            local ValueX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 1)
            
            self.Alpha = ValueX

            local PositionX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 0.994)

            Items["AlphaDragger"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(PositionX, 0, 0, 0)})
            self:Update(true)
        end

        Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
            Colorpicker:SetOpen(not Colorpicker.IsOpen)
        end)

        Items["Palette"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingPalette = true
                Colorpicker:SlidePalette(Input)
            end
        end)

        Items["Palette"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingPalette = false
            end
        end)

        Items["Hue"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingHue = true
                Colorpicker:SlideHue(Input)
            end
        end)

        Items["Hue"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingHue = false
            end
        end)

        Items["Alpha"]:Connect("InputBegan", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingAlpha = true
                Colorpicker:SlideAlpha(Input)
            end
        end)

        Items["Alpha"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                SlidingAlpha = false
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement then
                if SlidingPalette then
                    Colorpicker:SlidePalette(Input)
                end

                if SlidingHue then
                    Colorpicker:SlideHue(Input)
                end

                if SlidingAlpha then
                    Colorpicker:SlideAlpha(Input)
                end
            end
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if Library:IsMouseOverFrame(Items["ColorpickerWindow"]) then
                    return
                end

                Colorpicker:SetOpen(false)
            end
        end)

        if Data.Default then 
            Colorpicker:Set(Data.Default, Data.Alpha)
        end

        Library.SetFlags[Data.Flag] = function(Color, Alpha)
            Colorpicker:Set(Color, Alpha)
        end

        return Colorpicker
    end

    Library.CreateKeybind = function(self, Data)
        local Keybind = {
            Key = nil,
            Value = "",
            Mode = "",

            Toggled = false,
            IsOpen = false,

            Picking = false,

            Class = "Keybind"
        }

        Library.Flags[Data.Flag] = { }

        local KeyListItem

        local Items = { } do 
            Items["KeyButton"] = Instances:Create("TextButton", {
                Parent = Data.Parent.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(27, 27, 32),
                Text = "",
                AutoButtonColor = false,
                AnchorPoint = Vector2New(1, 0),
                Size = UDim2New(0, 0, 1, 1),
                Name = "\0",
                Position = UDim2New(1, 0, 0, 0),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.X,
                TextSize = 14,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["KeyButton"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Outline"})

            if Library.KeyList then 
                KeyListItem = Library.KeyList:Add(Keybind.Mode, Data.Name, Keybind.Value)
            end
            
            Instances:Create("UIStroke", {
                Parent = Items["KeyButton"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(10, 10, 10)
            }):AddToTheme({Color = "Border"})
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["KeyButton"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "MB2",
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, 0),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Instances:Create("UIPadding", {
                Parent = Items["KeyButton"].Instance,
                PaddingRight = UDimNew(0, 3),
                PaddingLeft = UDimNew(0, 3),
                PaddingBottom = UDimNew(0, 2)
            })             

            Items["Window"] = Instances:Create("Frame", {
                Parent = Data.Parent.Instance,
                BorderColor3 = FromRGB(10, 10, 10),
                AnchorPoint = Vector2New(1, 0),
                Name = "\0",
                Position = UDim2New(1, 0, 1, 5),
                Size = UDim2New(0, 50, 0, 48),
                BorderSizePixel = 2,
                Visible = false,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["Window"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Window"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Toggle"] = Instances:Create("TextButton", {
                Parent = Items["Window"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(235, 157, 255),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Toggle",
                AutoButtonColor = false,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, 0),
                Size = UDim2New(1, 0, 0, 15),
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Toggle"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Toggle"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Hold"] = Instances:Create("TextButton", {
                Parent = Items["Window"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Hold",
                AutoButtonColor = false,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, 15),
                Size = UDim2New(1, 0, 0, 15),
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Hold"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Hold"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Always"] = Instances:Create("TextButton", {
                Parent = Items["Window"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "Always",
                AutoButtonColor = false,
                Name = "\0",
                BorderSizePixel = 0,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 1, 0, 30),
                Size = UDim2New(1, 0, 0, 15),
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Always"]:AddToTheme({TextColor3 = "Text"})
             
            Instances:Create("UIStroke", {
                Parent = Items["Always"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
        end

        local Modes = {
            ["Toggle"] = Items["Toggle"],
            ["Hold"] = Items["Hold"],
            ["Always"] = Items["Always"]
        }

        local Update = function()
            if KeyListItem then
                KeyListItem:Set(Keybind.Mode, Data.Name, Keybind.Value)
                KeyListItem:SetStatus(Keybind.Toggled and "Active" or "Inactive")
            end
        end

        function Keybind:Get()
           return Keybind.Toggled, Keybind.Key, Keybind.Mode 
        end

        function Keybind:SetVisibility(Bool)
            Data.Parent.Instance.Visible = Bool
        end

        local Debounce = false

        function Keybind:SetOpen(Bool)
            Keybind.IsOpen = Bool

            if Bool then 
                Debounce = true
                Items["Window"].Instance.Visible = true
                Items["Window"].Instance.ZIndex = 16
                Items["Window"]:Tween(nil, {BackgroundTransparency = 0})

                task.wait(0.1)

                for Index, Value in Items["Window"].Instance:GetDescendants() do 
                    if Value:IsA("UIStroke") then
                        Tween:Create(Value, nil, {Transparency = 0}, true)
                    elseif Value:IsA("TextButton") then
                        Tween:Create(Value, nil, {TextTransparency = 0}, true)
                        Value.ZIndex = 16
                    end
                end
            else 
                for Index, Value in Items["Window"].Instance:GetDescendants() do 
                    if Value:IsA("UIStroke") then
                        Tween:Create(Value, nil, {Transparency = 1}, true)
                    elseif Value:IsA("TextButton") then
                        Tween:Create(Value, nil, {TextTransparency = 1}, true)
                        Value.ZIndex = 1
                    end
                end

                task.wait(0.1)

                Items["Window"]:Tween(nil, {BackgroundTransparency = 1})
                Items["Window"].Instance.ZIndex = 1
                task.wait(0.1)
                Items["Window"].Instance.Visible = false
            end

            Debounce = false
        end

        function Keybind:Set(Key)
            if StringFind(tostring(Key), "Enum") then 
                Keybind.Key = tostring(Key)

                Key = Key.Name == "Backspace" and "None" or Key.Name

                local KeyString = Keys[Keybind.Key] or StringGSub(Key, "Enum.", "") or "None"
                local TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                Keybind.Value = TextToDisplay
                Items["Text"].Instance.Text = TextToDisplay
    
                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
           elseif TableFind({"Toggle", "Hold", "Always"}, Key) then 
                Keybind.Mode = Key
                
                Keybind:SetMode(Key)

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            elseif type(Key) == "table" then 
                local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                Keybind.Key = tostring(Key.Key)

                if Key.Mode then
                    Keybind.Mode = Key.Mode
                    Keybind:SetMode(Key.Mode)
                else
                    Keybind.Mode = "Toggle"
                    Keybind:SetMode("Toggle")
                end

                local KeyString = Keys[Keybind.Key] or StringGSub(tostring(RealKey), "Enum.", "") or RealKey
                local TextToDisplay = KeyString and StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")

                Keybind.Value = TextToDisplay
                Items["Text"].Instance.Text = TextToDisplay

                if Keybind.Callback then 
                    Library:SafeCall(Keybind.Callback, Keybind.Toggled)
                end
            end

            Keybind.Picking = false
            Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text})
            Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
            Items["Text"].Instance.Size = UDim2New(0, Items["Text"].Instance.TextBounds.X, 1, 1)
            Update()
        end

        function Keybind:SetMode(Mode)
            for Index, Value in Modes do 
                if Index == Mode then 
                    Value:Tween(nil, {TextColor3 = Library.Theme.Accent})
                    Value:ChangeItemTheme({TextColor3 = "Accent"})
                else
                    Value:Tween(nil, {TextColor3 = Library.Theme.Text})
                    Value:ChangeItemTheme({TextColor3 = "Text"})
                end
            end

            if Keybind.Mode == "Always" then 
                Keybind.Toggled = true
            else
                Keybind.Toggled = false
            end

            Library.Flags[Data.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled
            }

            if Data.Callback then 
                Library:SafeCall(Data.Callback, Keybind.Toggled)
            end

            Update()
        end

        function Keybind:Press(Bool)
            if Keybind.Mode == "Toggle" then
                Keybind.Toggled = not Keybind.Toggled
            elseif Keybind.Mode == "Hold" then
                Keybind.Toggled = Bool
            elseif Keybind.Mode == "Always" then
                Keybind.Toggled = true
            end

            Library.Flags[Data.Flag] = {
                Mode = Keybind.Mode,
                Key = Keybind.Key,
                Toggled = Keybind.Toggled
            }

            if Data.Callback then 
                Library:SafeCall(Data.Callback, Keybind.Toggled)
            end

            Update()
        end

        Items["KeyButton"]:Connect("MouseButton1Click", function()
            if Keybind.Picking then 
                return
            end

            Keybind.Picking = true

            Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Accent})
            Items["Text"]:ChangeItemTheme({TextColor3 = "Accent"})

            local InputBegan 
            InputBegan = UserInputService.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.Keyboard then 
                    Keybind:Set(Input.KeyCode)
                else
                    Keybind:Set(Input.UserInputType)
                end

                InputBegan:Disconnect()
                InputBegan = nil
            end)
        end)

        Items["KeyButton"]:Connect("MouseButton2Down", function()
            Keybind:SetOpen(not Keybind.IsOpen)
        end)

        Library:Connect(UserInputService.InputBegan, function(Input)
            if tostring(Input.KeyCode) == Keybind.Key or tostring(Input.UserInputType) == Keybind.Key then
                if Keybind.Mode == "Toggle" then 
                    Keybind:Press()
                elseif Keybind.Mode == "Hold" then 
                    Keybind:Press(true)
                end
            end

            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if Library:IsMouseOverFrame(Items["Window"]) then
                    return
                end

                if Debounce then 
                    return
                end

                Keybind:SetOpen(false)
            end
        end)

        Library:Connect(UserInputService.InputEnded, function(Input)
            if tostring(Input.KeyCode) == Keybind.Key or tostring(Input.UserInputType) == Keybind.Key then
                if Keybind.Mode == "Hold" then 
                    Keybind:Press(false)
                end
            end
        end)

        Items["Toggle"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Toggle"
            Keybind:SetMode("Toggle")
        end)

        Items["Always"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Always"
            Keybind:SetMode("Always")
        end)

        Items["Hold"]:Connect("MouseButton1Down", function()
            Keybind.Mode = "Hold"
            Keybind:SetMode("Hold")
        end)

        if Data.Default then 
            Keybind:Set({
                Key = Data.Default,
                Mode = Data.Mode or "Toggle"
            })
        end

        Library.SetFlags[Data.Flag] = function(Value)
            Keybind:Set(Value)
        end

        return Keybind
    end

    Library.Window = function(self, Data)
        Data = Data or { }

        local Window = {
            Name = Data.Name or Data.name or "Window",
            Size = Data.Size or Data.size or UDim2New(0, 650, 0, 700),

            FadeSpeed = Data.FadeSpeed or Data.fadespeed or 0.25,

            Pages = { },
            SubPages = { },
            Elements = { },

            IsOpen = true
        }

        local Items = { } do 
            Items["MainFrame"] = Instances:Create("Frame", {
                Parent = Library.Holder.Instance,
                AnchorPoint = Vector2New(0, 0),
                Name = "\0",
                Position = UDim2New(0, 0, 0, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Size = Window.Size,
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["MainFrame"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Items["MainFrame"].Instance.Position = UDim2New(0, Camera.ViewportSize.X / 4, 0, Camera.ViewportSize.Y / 4)

            Items["MainFrame"]:MakeDraggable()
            Items["MainFrame"]:MakeResizeable(Vector2New(Window.Size.X.Offset, Window.Size.Y.Offset), Vector2New(9999, 9999))
            
            Items["AccentBorder"] = Instances:Create("UIStroke", {
                Parent = Items["MainFrame"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(0, 255, 255)
            })  Items["AccentBorder"]:AddToTheme({Color = "Accent"})
            
            Items["Title"] = Instances:Create("TextLabel", {
                Parent = Items["MainFrame"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Window.Name,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 6, 0, 1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Title"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = Items["Title"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            -- Search Bar
            Items["SearchBar"] = Instances:Create("TextBox", {
                Parent = Items["MainFrame"].Instance,
                Name = "\0",
                Position = UDim2New(1, -160, 0, 1),
                Size = UDim2New(0, 150, 0, 15),
                BackgroundColor3 = FromRGB(20, 20, 25),
                BorderColor3 = FromRGB(10, 10, 10),
                BorderSizePixel = 1,
                TextColor3 = FromRGB(215, 215, 215),
                PlaceholderText = "Search...",
                PlaceholderColor3 = FromRGB(100, 100, 100),
                Text = "",
                TextSize = 11,
                FontFace = Library.Font,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false
            })  Items["SearchBar"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Border", TextColor3 = "Text"})

            Instances:Create("UIPadding", {
                Parent = Items["SearchBar"].Instance,
                PaddingLeft = UDimNew(0, 5),
                PaddingRight = UDimNew(0, 5)
            })

            -- Search Results Dropdown
            Items["SearchResults"] = Instances:Create("Frame", {
                Parent = Items["MainFrame"].Instance,
                Name = "\0",
                Position = UDim2New(1, -160, 0, 17),
                Size = UDim2New(0, 150, 0, 0),
                BackgroundColor3 = FromRGB(20, 20, 25),
                BorderColor3 = FromRGB(10, 10, 10),
                BorderSizePixel = 1,
                Visible = false,
                ZIndex = 10,
                AutomaticSize = Enum.AutomaticSize.Y
            })  Items["SearchResults"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Border"})

            Instances:Create("UIListLayout", {
                Parent = Items["SearchResults"].Instance,
                Padding = UDimNew(0, 2),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            Instances:Create("UIPadding", {
                Parent = Items["SearchResults"].Instance,
                PaddingTop = UDimNew(0, 3),
                PaddingBottom = UDimNew(0, 3),
                PaddingLeft = UDimNew(0, 3),
                PaddingRight = UDimNew(0, 3)
            })

            Items["Inline"] = Instances:Create("Frame", {
                Parent = Items["MainFrame"].Instance,
                Name = "\0",
                Position = UDim2New(0, 7, 0, 20),
                BorderColor3 = FromRGB(27, 27, 32),
                Size = UDim2New(1, -14, 1, -27),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(20, 20, 25)
            })  Items["Inline"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Outline"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Inline"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Library.Theme.Border,
                Name = "\0"
            }):AddToTheme({Color = "Border"})
            
            Items["Pages"] = Instances:Create("Frame", {
                Parent = Items["Inline"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 7, 0, 3),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -14, 0, 25),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["Pages"].Instance,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                Padding = UDimNew(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })

            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["Inline"].Instance,
                Name = "\0",
                Position = UDim2New(0, 7, 0, 26),
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(1, -14, 1, -33),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["Content"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
        
            Instances:Create("UIStroke", {
                Parent = Items["Content"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Library.Theme.Outline,
                Name = "\0"
            }):AddToTheme({Color = "Outline"})
        end

        local Debounce = false

        function Window:SetOpen(Bool)
            if Debounce then 
                return 
            end

            Window.IsOpen = Bool

            Debounce = true 

            if Bool then 
                Items["MainFrame"].Instance.Visible = true
            end

            local Descendants = Items["MainFrame"].Instance:GetDescendants()
            TableInsert(Descendants, Items["MainFrame"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, Window.FadeSpeed)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, Window.FadeSpeed)
                end
            end

            -- Animate blur effect
            if Library.BlurEffect then
                Tween:Create(Library.BlurEffect.Instance, TweenInfo.new(Window.FadeSpeed, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = Bool and 15 or 0
                }, true)
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["MainFrame"].Instance.Visible = Bool
            end)
            
            -- Also toggle PlayerList visibility if it exists
            if _G.PlayerList then
                _G.PlayerList:SetVisibility(Bool)
            end
        end

        Library:Connect(UserInputService.InputBegan, function(Input)
            if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                Window:SetOpen(not Window.IsOpen)
            end
        end)

        -- Search Functionality
        function Window:SearchElements(SearchText)
            -- Clear previous results
            for _, child in pairs(Items["SearchResults"].Instance:GetChildren()) do
                if child:IsA("Frame") then
                    child:Destroy()
                end
            end

            if SearchText == "" or #SearchText < 2 then
                Items["SearchResults"].Instance.Visible = false
                return
            end

            SearchText = string.lower(SearchText)
            local Results = {}

            -- Search through all GUI elements recursively
            local function SearchInContainer(Container, PageRef)
                for _, Item in pairs(Container) do
                    if type(Item) == "table" then
                        -- Check if this item has a Name property
                        if Item.Name and type(Item.Name) == "string" then
                            local ItemName = string.lower(Item.Name)
                            if StringFind(ItemName, SearchText, 1, true) then
                                TableInsert(Results, {
                                    Name = Item.Name,
                                    Page = PageRef,
                                    Item = Item
                                })
                            end
                        end
                        
                        -- Recursively search nested tables
                        if Item.Elements then
                            SearchInContainer(Item.Elements, PageRef)
                        end
                    end
                end
            end

            -- Search through all pages
            for _, Page in pairs(Window.Pages) do
                SearchInContainer(Page, Page)
            end

            -- Show results
            if #Results > 0 then
                Items["SearchResults"].Instance.Visible = true
                
                for i, Result in pairs(Results) do
                    if i > 10 then break end -- Limit to 10 results
                    
                    local ResultButton = Instances:Create("Frame", {
                        Parent = Items["SearchResults"].Instance,
                        Name = "\0",
                        Size = UDim2New(1, -6, 0, 20),
                        BackgroundColor3 = FromRGB(30, 30, 35),
                        BorderSizePixel = 0
                    })  ResultButton:AddToTheme({BackgroundColor3 = "Element"})
                    
                    local ResultText = Instances:Create("TextLabel", {
                        Parent = ResultButton.Instance,
                        Name = "\0",
                        Size = UDim2New(1, -10, 1, 0),
                        Position = UDim2New(0, 5, 0, 0),
                        BackgroundTransparency = 1,
                        Text = Result.Name,
                        TextColor3 = FromRGB(215, 215, 215),
                        TextSize = 11,
                        FontFace = Library.Font,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextYAlignment = Enum.TextYAlignment.Center
                    })  ResultText:AddToTheme({TextColor3 = "Text"})
                    
                    local ClickButton = Instances:Create("TextButton", {
                        Parent = ResultButton.Instance,
                        Name = "\0",
                        Size = UDim2New(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text = "",
                        AutoButtonColor = false
                    })

                    Instances:Create("UIPadding", {
                        Parent = ResultButton.Instance,
                        PaddingLeft = UDimNew(0, 5)
                    })

                    ResultButton:OnHover(function()
                        ResultButton:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                    end)

                    ResultButton:OnHoverLeave(function()
                        ResultButton:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                    end)

                    ClickButton:Connect("MouseButton1Click", function()
                        pcall(function()
                            if Result.Page and Result.Page.Turn then
                                -- Turn off all other pages first
                                for _, OtherPage in pairs(Window.Pages) do
                                    if OtherPage ~= Result.Page and OtherPage.Active then
                                        OtherPage:Turn(false)
                                    end
                                end
                                -- Turn on the target page
                                if not Result.Page.Active then
                                    Result.Page:Turn(true)
                                end
                            end
                        end)
                        
                        -- Clear search
                        Items["SearchBar"].Instance.Text = ""
                        Items["SearchResults"].Instance.Visible = false
                    end)
                end
            else
                Items["SearchResults"].Instance.Visible = false
            end
        end

        Items["SearchBar"]:Connect("Changed", function(Property)
            if Property == "Text" then
                Window:SearchElements(Items["SearchBar"].Instance.Text)
            end
        end)

        -- Close search results when clicking outside
        Library:Connect(UserInputService.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                if not Library:IsMouseOverFrame(Items["SearchBar"]) and not Library:IsMouseOverFrame(Items["SearchResults"]) then
                    Items["SearchResults"].Instance.Visible = false
                end
            end
        end)

        Window.Elements = Items

        return setmetatable(Window, Library)
    end

    Library.Page = function(self, Data)
        Data = Data or { }

        local Page = {
            Window = self,

            Name = Data.Name or Data.name or "Page",
            Columns = Data.Columns or Data.columns or 2,

            HasSubtabs = Data.Subtabs or Data.subtabs or false,

            Active = false,
            ColumnsData = { },
            Elements = { }
        }

        local Items = { } do 
            Items["Inactive"] = Instances:Create("TextButton", {
                Parent = Page.Window.Elements["Pages"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(30, 30, 35)
            })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Border"})

            Instances:Create("UIStroke", {
                Parent = Items["Inactive"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = Library.Theme.Outline,
                Name = "\0"
            }):AddToTheme({Color = "Outline"})
            
            -- Add icon if provided
            if Data.Icon or Data.icon then
                local IconSize = Data.IconSize or Data.iconsize or 32
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    Size = UDim2New(0, IconSize, 0, IconSize),
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Image = Data.Icon or Data.icon,
                    ImageColor3 = Library.Theme.Accent,
                    ImageTransparency = 0.6
                })  Items["Icon"]:AddToTheme({ImageColor3 = "Accent"})
                
                -- Hide text if icon is present
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Inactive"].Instance,
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(215, 215, 215),
                    TextTransparency = 1,
                    Text = Page.Name,
                    Name = "\0",
                    Size = UDim2New(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, -1),
                    BorderSizePixel = 0,
                    BorderColor3 = FromRGB(0, 0, 0),
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    Visible = false
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            else
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Inactive"].Instance,
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(215, 215, 215),
                    TextTransparency = 0.47999998927116394,
                    Text = Page.Name,
                    Name = "\0",
                    Size = UDim2New(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, -1),
                    BorderSizePixel = 0,
                    BorderColor3 = FromRGB(0, 0, 0),
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
                
                Instances:Create("UIStroke", {
                    Parent = Items["Text"].Instance,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Name = "\0"
                }):AddToTheme({Color = "Text Border"})
            end
            
            Items["Hide"] = Instances:Create("Frame", {
                Parent = Items["Inactive"].Instance,
                Visible = false,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 3),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["Hide"]:AddToTheme({BackgroundColor3 = "Background"})
            
            Items["MiscPixel1"] = Instances:Create("Frame", {
                Parent = Items["Hide"].Instance,
                Size = UDim2New(0, 1, 0, 1),
                Name = "\0",
                Position = UDim2New(0, -1, 0, 1),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(27, 27, 32)
            })  Items["MiscPixel1"]:AddToTheme({BackgroundColor3 = "Outline"})
            
            Items["MiscPixel2"] = Instances:Create("Frame", {
                Parent = Items["Hide"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(1, 0),
                Name = "\0",
                Position = UDim2New(1, 1, 0, 1),
                Size = UDim2New(0, 1, 0, 1),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(27, 27, 32)
            })  Items["MiscPixel2"]:AddToTheme({BackgroundColor3 = "Outline"})
            
            Items["UIGradient"] = Instances:Create("UIGradient", {
                Parent = Items["Inactive"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(108, 108, 108))}
            })
            
            Items["Page"] = Instances:Create("Frame", {
                Parent = Page.Window.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255),
                Visible = false
            })
            
            if not Page.HasSubtabs then 
                Instances:Create("UIListLayout", {
                    Parent = Items["Page"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                })
                
                for Index = 1, Page.Columns do
                    local NewColumn = Instances:Create("ScrollingFrame", {
                        Parent = Items["Page"].Instance,
                        ScrollBarImageColor3 = FromRGB(235, 157, 255),
                        Active = true,
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        ScrollBarThickness = 1,
                        Name = "\0",
                        BackgroundTransparency = 1,
                        Size = UDim2New(0, 100, 0, 100),
                        BackgroundColor3 = FromRGB(255, 255, 255),
                        BorderColor3 = FromRGB(0, 0, 0),
                        BorderSizePixel = 0,
                        BottomImage = Library:GetImage("Scrollbar"),
                        MidImage = Library:GetImage("Scrollbar"),
                        TopImage = Library:GetImage("Scrollbar"),
                        CanvasSize = UDim2New(0, 0, 0, 0)
                    })  NewColumn:AddToTheme({ScrollBarImageColor3 = "Accent"})
                    
                    Instances:Create("UIPadding", {
                        Parent = NewColumn.Instance,
                        PaddingTop = UDimNew(0, 6),
                        PaddingBottom = UDimNew(0, 6),
                        PaddingRight = UDimNew(0, 6),
                        PaddingLeft = UDimNew(0, 6)
                    })
                    
                    Instances:Create("UIListLayout", {
                        Parent = NewColumn.Instance,
                        Padding = UDimNew(0, 8),
                        SortOrder = Enum.SortOrder.LayoutOrder
                    }) 

                    Page.ColumnsData[Index] = NewColumn
                end
            else
                Items["Columns"] = Instances:Create("Frame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 7, 0, 45),
                    BorderColor3 = FromRGB(10, 10, 10),
                    Size = UDim2New(1, -14, 1, -52),
                    BorderSizePixel = 2,
                    BackgroundColor3 = FromRGB(15, 15, 20)
                })  Items["Columns"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

                Items["SubTabs"] = Instances:Create("Frame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 7, 0, 7),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -14, 0, 35),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                }) 

                Instances:Create("UIListLayout", {
                    Parent = Items["SubTabs"].Instance,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }) 
            end
        end

        local Debounce = false

        function Page:Turn(Bool)
            if Debounce then 
                return 
            end

            Page.Active = Bool

            Debounce = true 

            if Bool then 
                Items["Page"].Instance.Visible = true

                Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Accent, TextTransparency = 0})
                Items["Hide"].Instance.Visible = true
                Items["Text"]:ChangeItemTheme({TextColor3 = "Accent"})
                
                -- Also update icon if it exists
                if Items["Icon"] then
                    Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Accent, ImageTransparency = 0})
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})
                end
            else
                Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text, TextTransparency = 0.5})
                Items["Hide"].Instance.Visible = false
                Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                
                -- Also update icon if it exists
                if Items["Icon"] then
                    Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Accent, ImageTransparency = 0.6})
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})
                end
            end

            local Descendants = Items["Page"].Instance:GetDescendants()
            TableInsert(Descendants, Items["Page"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, Page.Window.FadeSpeed or 0.5)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, Page.Window.FadeSpeed or 0.5)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["Page"].Instance.Visible = Bool
            end)
        end

        Items["Inactive"]:Connect("MouseButton1Down", function()
            for Index, Value in Page.Window.Pages do
                Value:Turn(Value == Page)
            end
        end)

        if #Page.Window.Pages == 0 then 
            Page:Turn(true)
        end

        Page.Elements = Items

        TableInsert(Page.Window.Pages, Page)
        return setmetatable(Page, Library.Pages)
    end

    Library.Pages.SubPage = function(self, Data)
        Data = Data or { }

        local SubPage = {
            Window = self.Window,
            Page = self,

            Icon = Data.Icon or Data.icon or "9080568477801",
            Columns = Data.Columns or Data.columns or 2,

            Active = false,
            ColumnsData = { },
            Elements = { }
        }

        local Items = { } do
            Items["Inactive"] = Instances:Create("TextButton", {
                Parent = SubPage.Page.Elements["SubTabs"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                Size = UDim2New(1, 0, 1, -2),
                BorderSizePixel = 2,
                TextSize = 14,
                BackgroundColor3 = FromRGB(30, 30, 35)
            })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Border"})

            Instances:Create("UIStroke", {
                Parent = Items["Inactive"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})

            Items["Hide"] = Instances:Create("Frame", {
                Parent = Items["Inactive"].Instance,
                Visible = false,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 2),
                Size = UDim2New(1, 0, 0, 2),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(20, 20, 25)
            })  Items["Hide"]:AddToTheme({BackgroundColor3 = "Background"})

            Items["MiscPixel1"] = Instances:Create("Frame", {
                Parent = Items["Hide"].Instance,
                Size = UDim2New(0, 1, 0, 1),
                Name = "\0",
                Position = UDim2New(0, -1, 0, 1),
                BorderColor3 = FromRGB(0, 0, 0),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(27, 27, 32)
            }) 

            Items["MiscPixel2"] = Instances:Create("Frame", {
                Parent = Items["Hide"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                AnchorPoint = Vector2New(1, 0),
                Name = "\0",
                Position = UDim2New(1, 1, 0, 1),
                Size = UDim2New(0, 1, 0, 1),
                ZIndex = 5,
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(27, 27, 32)
            }) 

            Items["Icon"] = Instances:Create("ImageLabel", {
                Parent = Items["Inactive"].Instance,
                ScaleType = Enum.ScaleType.Fit,
                ImageTransparency = 0.35,
                BorderColor3 = FromRGB(0, 0, 0),
                Name = "\0",
                AnchorPoint = Vector2New(0.5, 0.5),
                Image = "rbxassetid://"..SubPage.Icon,
                BackgroundTransparency = 1,
                Position = UDim2New(0.5, 0, 0.5, 0),
                Size = UDim2New(0, 30, 0, 30),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Icon"]:AddToTheme({ImageColor3 = "Text"})

            Instances:Create("UIGradient", {
                Parent = Items["Inactive"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(138, 138, 138))}
            }) 

            Items["Subtab"] = Instances:Create("Frame", {
                Parent = SubPage.Page.Elements["Columns"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Instances:Create("UIPadding", {
                Parent = Items["Subtab"].Instance,
                PaddingTop = UDimNew(0, 6),
                PaddingRight = UDimNew(0, 6),
                PaddingLeft = UDimNew(0, 6)
            }) 

            Instances:Create("UIListLayout", {
                Parent = Items["Subtab"].Instance,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalFlex = Enum.UIFlexAlignment.Fill
            }) 

            Instances:Create("UIStroke", {
                Parent = Items["Subtab"].Instance,
                Color = FromRGB(27, 27, 32),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Outline"})

            for Index = 1, SubPage.Columns do
                local NewColumn = Instances:Create("ScrollingFrame", {
                    Parent = Items["Subtab"].Instance,
                    ScrollBarImageColor3 = FromRGB(235, 157, 255),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 1,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 100, 0, 100),
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2New(0, 0, 0, 0)
                })  NewColumn:AddToTheme({ScrollBarImageColor3 = "Accent"})

                Instances:Create("UIPadding", {
                    Parent = NewColumn.Instance,
                    PaddingTop = UDimNew(0, 6),
                    PaddingBottom = UDimNew(0, 6),
                    PaddingRight = UDimNew(0, 6),
                    PaddingLeft = UDimNew(0, 6)
                }) 

                Instances:Create("UIListLayout", {
                    Parent = NewColumn.Instance,
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }) 

                SubPage.ColumnsData[Index] = NewColumn
            end
        end

        local Debounce = false

        function SubPage:Turn(Bool)
            if Debounce then 
                return 
            end

            SubPage.Active = Bool

            Debounce = true 

            if Bool then 
                Items["Subtab"].Instance.Visible = true

                Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Accent, ImageTransparency = 0})
                Items["Hide"].Instance.Visible = true

                Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})

                Items["Inactive"].Instance.Size = UDim2New(1, 0, 1, 1)
            else
                Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Text, ImageTransparency = 0.35})
                Items["Hide"].Instance.Visible = false

                Items["Icon"]:ChangeItemTheme({ImageColor3 = "Text"})
                Items["Inactive"].Instance.Size = UDim2New(1, 0, 1, -2)
            end

            local Descendants = Items["Subtab"].Instance:GetDescendants()
            TableInsert(Descendants, Items["Subtab"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, SubPage.Window.FadeSpeed or 0.5)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, SubPage.Window.FadeSpeed or 0.5)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["Subtab"].Instance.Visible = Bool
            end)
        end

        Items["Inactive"]:Connect("MouseButton1Down", function()
            for Index, Value in SubPage.Window.SubPages do
                Value:Turn(Value == SubPage)
            end
        end)

        if #SubPage.Window.SubPages == 0 then 
            SubPage:Turn(true)
        end

        SubPage.Elements = Items

        TableInsert(SubPage.Window.SubPages, SubPage)
        return setmetatable(SubPage, Library.Pages)
    end

    Library.Pages.Section = function(self, Data)
        Data = Data or { }

        local Section = {
            Window = self.Window,
            Page = self,

            Name = Data.Name or Data.name or "Section",
            Side = Data.Side or Data.side or 1,

            Elements = { }
        }

        local Items = { } do 
            Items["Section"] = Instances:Create("Frame", {
                Parent = Section.Page.ColumnsData[Section.Side].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 25),
                BorderColor3 = FromRGB(27, 27, 32),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(20, 20, 25)
            })  Items["Section"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Outline"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Section"].Instance,
                Color = FromRGB(10, 10, 10),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Section"].Instance,
                PaddingBottom = UDimNew(0, 6)
            })
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(235, 157, 255)
            })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Section"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Section.Name,
                Name = "\0",
                Size = UDim2New(1, -12, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 4, 0, 2),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 7, 0, 21),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -14, 1, -20),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["Content"].Instance,
                Padding = UDimNew(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        end

        Section.Elements = Items

        return setmetatable(Section, Library.Sections)
    end

    Library.Pages.MultiSection = function(self, Data)
        local MultiSection = {
            Window = self.Window,
            Page = self,
            
            Sections = Data.Sections or Data.sections or { "Section 1", "Section 2", "Section 3" }, 
            Side = Data.Side or Data.side or 1,

            SectionContents = { },

            Elements = { }
        }

        local Items = { } do
            Items["MultiSection"] = Instances:Create("Frame", {
                Parent = MultiSection.Page.ColumnsData[MultiSection.Side].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 25),
                BorderColor3 = FromRGB(27, 27, 32),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(20, 20, 25)
            })  Items["MultiSection"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Outline"})
            
            Instances:Create("UIStroke", {
                Parent = Items["MultiSection"].Instance,
                Color = FromRGB(10, 10, 10),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Instances:Create("UIPadding", {
                Parent = Items["MultiSection"].Instance,
                PaddingBottom = UDimNew(0, 6)
            }) 
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["MultiSection"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(235, 157, 255)
            })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            }) 
            
            Items["Sections"] = Instances:Create("Frame", {
                Parent = Items["MultiSection"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 7, 0, 9),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -14, 0, 19),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Instances:Create("UIListLayout", {
                Parent = Items["Sections"].Instance,
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalFlex = Enum.UIFlexAlignment.Fill,
                Padding = UDimNew(0, 5),
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 

            Items["Content"] = Instances:Create("Frame", {
                Parent = Items["MultiSection"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 7, 0, 35),
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(1, -14, 1, -33),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(15, 15, 20)
            }) 
        end

        for Index, Value in MultiSection.Sections do 
            local NewSection = {
                Window = MultiSection.Window,
                Page = MultiSection.Page,
                MultiSection = MultiSection,

                Name = Value,

                Elements = { },

                Active = false,
            }

            local SubItems = { } do 
                SubItems["Inactive"] = Instances:Create("TextButton", {
                    Parent = Items["Sections"].Instance,
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(10, 10, 10),
                    Text = "",
                    AutoButtonColor = false,
                    Name = "\0",
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 2,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(30, 30, 35)
                })  SubItems["Inactive"]:AddToTheme({BackgroundColor3 = "Page Background", BorderColor3 = "Border"})

                SubItems["Text"] = Instances:Create("TextLabel", {
                    Parent = SubItems["Inactive"].Instance,
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(215, 215, 215),
                    TextTransparency = 0.48,
                    Text = NewSection.Name,
                    Name = "\0",
                    Size = UDim2New(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, -1),
                    BorderSizePixel = 0,
                    BorderColor3 = FromRGB(0, 0, 0),
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  SubItems["Text"]:AddToTheme({TextColor3 = "Text"})

                Instances:Create("UIStroke", {
                    Parent = SubItems["Text"].Instance,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Name = "\0"
                }):AddToTheme({Color = "Text Border"})

                SubItems["Hide"] = Instances:Create("Frame", {
                    Parent = SubItems["Inactive"].Instance,
                    Visible = false,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 1),
                    Name = "\0",
                    Position = UDim2New(0, 0, 1, 0),
                    Size = UDim2New(1, 0, 0, 3),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(15, 15, 20)
                })  SubItems["Hide"]:AddToTheme({BackgroundColor3 = "Background"})

                SubItems["MiscPixel1"] = Instances:Create("Frame", {
                    Parent = SubItems["Hide"].Instance,
                    Size = UDim2New(0, 1, 0, 1),
                    Name = "\0",
                    Position = UDim2New(0, -1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(27, 27, 32)
                })  SubItems["MiscPixel1"]:AddToTheme({BackgroundColor3 = "Outline"})

                SubItems["MiscPixel2"] = Instances:Create("Frame", {
                    Parent = SubItems["Hide"].Instance,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    Name = "\0",
                    Position = UDim2New(1, 1, 0, 1),
                    Size = UDim2New(0, 1, 0, 1),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(27, 27, 32)
                })  SubItems["MiscPixel2"]:AddToTheme({BackgroundColor3 = "Outline"})

                Instances:Create("UIStroke", {
                    Parent = SubItems["Inactive"].Instance,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    Name = "\0",
                    Color = FromRGB(27, 27, 32)
                }):AddToTheme({Color = "Outline"})

                Instances:Create("UIGradient", {
                    Parent = SubItems["Inactive"].Instance,
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(108, 108, 108))}
                }) 

                SubItems["Content"] = Instances:Create("Frame", {
                    Parent = Items["Content"].Instance,
                    BackgroundTransparency = 1,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    Visible = false,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                }) 
                
                Instances:Create("UIListLayout", {
                    Parent = SubItems["Content"].Instance,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }) 
            end

            local Debounce = false

            function NewSection:Turn(Bool)
                if Debounce then 
                    return 
                end

                NewSection.Active = Bool

                Debounce = true 

                if Bool then 
                    SubItems["Content"].Instance.Visible = true

                    SubItems["Text"]:Tween(nil, {TextColor3 = Library.Theme.Accent, TextTransparency = 0})

                    SubItems["Text"]:ChangeItemTheme({TextColor3 = "Accent"})
                else
                    SubItems["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text, TextTransparency = 0.5})

                    SubItems["Text"]:ChangeItemTheme({TextColor3 = "Text"})
                end

                local Descendants = SubItems["Content"].Instance:GetDescendants()
                TableInsert(Descendants, SubItems["Content"].Instance)

                local NewTween
                for Index, Value in Descendants do 
                    local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                    if not ValueIndex then 
                        continue
                    end

                    if type(ValueIndex) == "table" then
                        for _, Property in ValueIndex do 
                            NewTween = Library:FadeItem(Value, Property, Bool, MultiSection.Window.FadeSpeed or 0.5)
                        end
                    else
                        NewTween = Library:FadeItem(Value, ValueIndex, Bool, MultiSection.Window.FadeSpeed or 0.5)
                    end
                end

                Library:Connect(NewTween.Tween.Completed, function()
                    Debounce = false
                    SubItems["Content"].Instance.Visible = Bool
                end)
            end

            SubItems["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in MultiSection.SectionContents do
                    Value:Turn(Value == NewSection)
                end
            end)

            if #MultiSection.SectionContents == 0 then 
                NewSection:Turn(true)
            end

            NewSection.Elements = SubItems

            MultiSection.SectionContents[#MultiSection.SectionContents+1] = setmetatable(NewSection, Library.Sections)
        end

        MultiSection.SectionContents[1]:Turn(true)
        MultiSection.Window.Sections[#MultiSection.Window.Sections+1] = MultiSection
        return TableUnpack(MultiSection.SectionContents)
    end

    Library.Pages.ScrollableSection = function(self, Data)
        Data = Data or { }

        local Section = {
            Window = self.Window,
            Page = self,

            Name = Data.Name or Data.name or "Section",
            Side = Data.Side or Data.side or 1,
            Size = Data.Size or Data.size or 175,

            Elements = { }
        }

        local Items = { } do 
            Items["Section"] = Instances:Create("Frame", {
                Parent = Section.Page.ColumnsData[Section.Side].Instance,
                Name = "\0",
                Size = UDim2New(1, 0, 0, Section.Size),
                BorderColor3 = FromRGB(27, 27, 32),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(20, 20, 25)
            })  Items["Section"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Outline"})

            Items["Fade"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 20),
                AnchorPoint = Vector2New(0, 1),
                Position = UDim2New(0, 0, 1, 2),
                BorderSizePixel = 0,
                ZIndex = 15,
                BackgroundColor3 = FromRGB(27, 27, 32)
            })  Items["Fade"]:AddToTheme({BackgroundColor3 = "Inline"})

            Instances:Create("UIGradient", {
                Parent = Items["Fade"].Instance,
                Rotation = -90,
                Transparency = NumSequence{NumSequenceKeypoint(0, 0), NumSequenceKeypoint(0.718, 0.768750011920929), NumSequenceKeypoint(1, 1)}
            })
            
            Instances:Create("UIStroke", {
                Parent = Items["Section"].Instance,
                Color = FromRGB(10, 10, 10),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Border"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Section"].Instance,
                PaddingBottom = UDimNew(0, 6)
            })
            
            Items["AccentLine"] = Instances:Create("Frame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 2),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(235, 157, 255)
            })  Items["AccentLine"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["AccentLine"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(65, 65, 65))}
            })
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Section"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Section.Name,
                Name = "\0",
                Size = UDim2New(1, -12, 0, 15),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2New(0, 4, 0, 2),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Content"] = Instances:Create("ScrollingFrame", {
                Parent = Items["Section"].Instance,
                Name = "\0",
                ScrollBarThickness = 3,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                CanvasSize = UDim2New(0, 0, 0, 0),
                ScrollBarImageColor3 = FromRGB(235, 157, 255),
                MidImage = Library:GetImage("Scrollbar"),
                TopImage = Library:GetImage("Scrollbar"),
                BottomImage = Library:GetImage("Scrollbar"),
                Active = true,
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, 21),
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -5, 1, -20),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Content"]:AddToTheme({ScrollBarImageColor3 = "Accent"})

            Instances:Create("UIPadding", {
                Parent = Items["Content"].Instance,
                PaddingTop = UDimNew(0, 0),
                PaddingBottom = UDimNew(0, 8),
                PaddingRight = UDimNew(0, 11),
                PaddingLeft = UDimNew(0, 8)
            })
            
            Instances:Create("UIListLayout", {
                Parent = Items["Content"].Instance,
                Padding = UDimNew(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        end

        Section.Elements = Items

        return setmetatable(Section, Library.Sections)
    end

    Library.Sections.Divider = function(self)
        local Divider = {
            Window = self.Window,
            Page = self.Page,
            Section = self,
        }

        local Items = { } do
            Items["Divider"] = Instances:Create("Frame", {
                Parent = Divider.Section.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 10),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 

            Items["RealDivider"] = Instances:Create("Frame", {
                Parent = Items["Divider"].Instance,
                AnchorPoint = Vector2New(0, 0.5),
                Name = "\0",
                Position = UDim2New(0, 0, 0.5, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(1, 0, 0, 3),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(15, 15, 20)
            })  Items["RealDivider"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})

            Instances:Create("UIStroke", {
                Parent = Items["RealDivider"].Instance,
                Color = FromRGB(27, 27, 32),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Outline"})
        end
        
        function Divider:SetVisibility(Bool)
            Items["Divider"].Instance.Visible = Bool
        end

        return Divider
    end

    Library.Sections.Toggle = function(self, Data)
        Data = Data or { }

        local Toggle = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Toggle",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Default = Data.Default or Data.default or false,
            Callback = Data.Callback or Data.callback or function() end,

            Value = false,
            Class = "Toggle",

            Count = 0
        }

        local Items = { } do 
            Items["Toggle"] = Instances:Create("TextButton", {
                Parent = Toggle.Section.Elements["Content"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Name = "\0",
                Size = UDim2New(1, 0, 0, 11),
                BorderSizePixel = 0,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Indicator"] = Instances:Create("Frame", {
                Parent = Items["Toggle"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(0, 10, 0, 10),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(33, 33, 36)
            })  Items["Indicator"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Indicator"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Indicator"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Toggle"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                TextTransparency = 0.48,
                Text = Toggle.Name,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                Position = UDim2New(0, 18, 0, -1),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                BorderColor3 = FromRGB(0, 0, 0),
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            Items["Toggle"]:OnHover(function()
                if Toggle.Value then 
                    return 
                end

                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
            end)

            Items["Toggle"]:OnHoverLeave(function()
                if Toggle.Value then 
                    return 
                end

                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            end)
        end
        
        function Toggle:Get()
            return Toggle.Value
        end

        function Toggle:Set(Bool)
            Toggle.Value = Bool or not Toggle.Value

            Library.Flags[Toggle.Flag] = Toggle.Value

            if Toggle.Value then 
                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Accent"})

                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
                Items["Text"]:Tween(nil, {TextTransparency = 0})
            else
                Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Element"})

                Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
                Items["Text"]:Tween(nil, {TextTransparency = 0.48})
            end

            if Toggle.Callback then 
                Library:SafeCall(Toggle.Callback, Toggle.Value)
            end
        end

        function Toggle:SetVisiblity(Bool)
            Items["Toggle"].Instance.Visible = Bool
        end

        function Toggle:Colorpicker(Data)
            Data = Data or { }

            local Colorpicker = {
                Window = self.Window,
                Tab = self.Tab,
                Section = self.Section,

                Parent = Items["Toggle"],
                Name = Data.Name or Data.name or "Colorpicker",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                Callback = Data.Callback or Data.callback or function() end,
                Alpha = Data.Alpha or Data.alpha or false,
                Count = Toggle.Count,

                FadeSpeed = self.Window.FadeSpeed
            }

            Toggle.Count += 1
            Colorpicker.Count = Toggle.Count

            local Extension = Library:CreateColorpicker(Colorpicker)
            Library.Flags[Colorpicker.Flag] = Extension

            return Colorpicker
        end

        function Toggle:Keybind(Data)
            Data = Data or { }

            local Keybind = {
                Window = self.Window,
                Tab = self.Tab,
                Section = self.Section,

                Parent = Items["Toggle"],
                Name = Data.Name or Data.name or "Keybind",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or "MB2",
                Mode = Data.Mode or Data.mode or "Toggle",
                Callback = Data.Callback or Data.callback or function() end,
            }

            local Extension = Library:CreateKeybind(Keybind)
            Library.Flags[Keybind.Flag] = Extension

            return Keybind, Extension
        end

        Items["Toggle"]:Connect("MouseButton1Down", function()
            Toggle:Set()
        end)

        if Toggle.Default then 
            Toggle:Set(Toggle.Default)
        end

        Library.SetFlags[Toggle.Flag] = function(Value)
            Toggle:Set(Value)
        end

        return Toggle
    end

    Library.Sections.Button = function(self, Data)
        Data = Data or { }

        local Button = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name,
            Callback = Data.Callback or Data.callback or function() end,
        }

        local Items = { } do 
            Items["Button"] = Instances:Create("TextButton", {
                Parent = Button.Section.Elements["Content"].Instance,
                BorderColor3 = FromRGB(10, 10, 10),
                AutoButtonColor = false,
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                Size = UDim2New(1, 0, 0, 17),
                Selectable = false,
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(33, 33, 36)
            })  Items["Button"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})

            Instances:Create("UIGradient", {
                Parent = Items["Button"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["Button"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"}) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Button"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Button.Name,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BackgroundTransparency = 1,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Position = UDim2New(0, 0, 0, -1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Items["TextBorder"] = Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            Items["Button"]:OnHover(function()
                Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
            end)

            Items["Button"]:OnHoverLeave(function()
                Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
                Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            end)
        end

        function Button:Press()
            Library:SafeCall(Button.Callback)

            Items["Text"]:ChangeItemTheme({TextColor3 = "Accent"})
            Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Accent"})

            Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Accent})
            Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})

            task.wait(0.1)

            Items["Text"]:ChangeItemTheme({TextColor3 = "Text"})
            Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Element"})

            Items["Text"]:Tween(nil, {TextColor3 = Library.Theme.Text})
            Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element})
        end

        function Button:SetVisiblity(Bool)
            Items["Button"].Instance.Visible = Bool
        end

        Items["Button"]:Connect("MouseButton1Down", function()
            Button:Press()
        end)

        return Button
    end

    Library.Sections.Slider = function(self, Data)
        Data = Data or { }

        local Slider = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Slider",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Min = Data.Min or Data.min or 0,
            Default = Data.Default or Data.default or 0,
            Max = Data.Max or Data.max or 100,
            Suffix = Data.Suffix or Data.suffix or "",
            Decimals = Data.Decimals or Data.decimals or 1,
            Callback = Data.Callback or Data.callback or function() end,
            Compact = Data.Compact or Data.compact or false,

            Value = 0,
            Sliding = false,
            Class = "Slider",
        }

        local Items = { } do 
            Items["Slider"] = Instances:Create("Frame", {
                Parent = Slider.Section.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 27),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Slider"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Slider.Name,
                Name = "\0",
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 13),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["RealSlider"] = Instances:Create("TextButton", {
                Parent = Items["Slider"].Instance,
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Text = "",
                AutoButtonColor = false,
                Size = UDim2New(1, 0, 0, 10),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(33, 33, 36)
            })  Items["RealSlider"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["RealSlider"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Instances:Create("UIGradient", {
                Parent = Items["RealSlider"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Items["Indicator"] = Instances:Create("Frame", {
                Parent = Items["RealSlider"].Instance,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(0.5, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(235, 157, 255)
            })  Items["Indicator"]:AddToTheme({BackgroundColor3 = "Accent"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Indicator"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Items["Value"] = Instances:Create("TextLabel", {
                Parent = Items["RealSlider"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "50/100s",
                Name = "\0",
                BackgroundTransparency = 1,
                Position = UDim2New(0, 0, 0, -1),
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Value"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = Items["Value"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            if Slider.Compact then 
                Items["Value"]:Clean()
                Items["Value"] = nil

                Items["Slider"].Instance.Size = UDim2New(1,0,0,10)
                Items["Text"].Instance.Parent = Items["RealSlider"].Instance
                Items["Text"].Instance.Position = UDim2New(0,0,0,-2)
                Items["Text"].Instance.TextXAlignment = Enum.TextXAlignment.Center
            end

            Items["RealSlider"]:OnHover(function()
                Items["RealSlider"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["RealSlider"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
            end)

            Items["RealSlider"]:OnHoverLeave(function()
                Items["RealSlider"]:Tween(nil, {BackgroundColor3 = Library.Theme["Background"]})
                Items["RealSlider"]:ChangeItemTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            end)
        end

        function Slider:Set(Value)
            Slider.Value = MathClamp(Library:Round(Value, Slider.Decimals), Slider.Min, Slider.Max)

            Library.Flags[Slider.Flag] = Slider.Value
            
            if Slider.Compact then
                Items["Text"].Instance.Text = `{Slider.Name}: {Slider.Value}{Slider.Suffix}`
            else
                Items["Value"].Instance.Text = `{Slider.Value}{Slider.Suffix}`
            end

            Items["Indicator"]:Tween(TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)})

            if Slider.Callback then 
                Library:SafeCall(Slider.Callback, Slider.Value)
            end
        end

        function Slider:Get()
            return Slider.Value
        end

        function Slider:SetVisibility(Bool)
            Items["Slider"].Instance.Visible = Bool
        end

        Items["RealSlider"]:Connect("MouseButton1Down", function()
            Slider.Sliding = true

            local MousePos = UserInputService:GetMouseLocation()

            local SizeX = (MousePos.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
            local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

            Slider:Set(Value)
        end)

        Items["RealSlider"]:Connect("InputEnded", function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Slider.Sliding = false
            end
        end)

        Library:Connect(UserInputService.InputChanged, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement and Slider.Sliding then
                local MousePos = UserInputService:GetMouseLocation()

                local SizeX = (MousePos.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                Slider:Set(Value)
            end
        end)

        if Slider.Default then
            Slider:Set(Slider.Default)
        end

        Library.SetFlags[Slider.Flag] = function(Value)
            Slider:Set(Value)
        end

        return Slider
    end

    Library.Sections.Dropdown = function(self, Data)
        Data = Data or { }

        local Dropdown = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name or "Dropdown",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Items = Data.Items or Data.items or { "One", "Two", "Three" },
            Default = Data.Default or Data.default or nil,
            Callback = Data.Callback or Data.callback or function() end,
            Multi = Data.Multi or Data.multi or false,

            Value = { },
            IsOpen = false,
            Options = { },
            Class = "Dropdown",
        }

        local Items = { } do
            Items["Dropdown"] = Instances:Create("Frame", {
                Parent = Dropdown.Section.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 34),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Dropdown"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Dropdown.Name,
                Name = "\0",
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 13),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["RealDropdown"] = Instances:Create("Frame", {
                Parent = Items["Dropdown"].Instance,
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(1, 0, 0, 17),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(33, 33, 36)
            })  Items["RealDropdown"]:AddToTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            
            Instances:Create("UIGradient", {
                Parent = Items["RealDropdown"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["RealDropdown"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Open"] = Instances:Create("TextButton", {
                Parent = Items["RealDropdown"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "+",
                AutoButtonColor = false,
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Right,
                Position = UDim2New(0, -4, 0, -1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Open"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = Items["Open"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"}) 
            
            Items["Value"] = Instances:Create("TextLabel", {
                Parent = Items["RealDropdown"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "--",
                Name = "\0",
                Size = UDim2New(1, -25, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Position = UDim2New(0, 5, 0, -1),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Value"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Value"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["OptionHolder"] = Instances:Create("Frame", {
                Parent = Items["Dropdown"].Instance,
                Visible = false,
                BorderColor3 = FromRGB(10, 10, 10),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 5),
                Size = UDim2New(1, 0, 0, 0),
                BorderSizePixel = 2,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(20, 20, 25)
            })  Items["OptionHolder"]:AddToTheme({BackgroundColor3 = "Inline", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["OptionHolder"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})

            Instances:Create("UIListLayout", {
                Parent = Items["OptionHolder"].Instance,
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 
            
            Instances:Create("UIPadding", {
                Parent = Items["OptionHolder"].Instance,
                PaddingBottom = UDimNew(0, 2)
            })

            Items["RealDropdown"]:OnHover(function()
                Items["RealDropdown"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["RealDropdown"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
            end)

            Items["RealDropdown"]:OnHoverLeave(function()
                Items["RealDropdown"]:Tween(nil, {BackgroundColor3 = Library.Theme["Background"]})
                Items["RealDropdown"]:ChangeItemTheme({BackgroundColor3 = "Background", BorderColor3 = "Border"})
            end)
        end

        function Dropdown:Set(Option)
            if Dropdown.Multi then 
                if type(Option) ~= "table" then 
                    return
                end

                Dropdown.Value = Option

                for Index, Value in Option do 
                    local OptionData = Dropdown.Options[Value]
                    
                    if not OptionData then 
                        return
                    end

                    OptionData.Selected = true
                    OptionData:Toggle("Active")
                end

                Library.Flags[Dropdown.Flag] = Dropdown.Value

                Items["Value"].Instance.Text = TableConcat(Option, ", ")
            else
                if not Dropdown.Options[Option] then 
                    return
                end

                local OptionData = Dropdown.Options[Option]

                Dropdown.Value = OptionData.Name

                OptionData.Selected = true
                OptionData:Toggle("Active")

                for Index, Value in Dropdown.Options do 
                    if Value ~= OptionData then 
                        Value.Selected = false
                        Value:Toggle("Inactive")
                    end
                end

                Library.Flags[Dropdown.Flag] = Dropdown.Value

                Items["Value"].Instance.Text = Option
            end

            if Dropdown.Callback then 
                Library:SafeCall(Dropdown.Callback, Option)
            end
        end

        function Dropdown:Get()
            return Dropdown.Value
        end

        function Dropdown:SetVisibility(Bool)
            Items["Dropdown"].Instance.Visible = Bool
        end

        function Dropdown:Add(Option)
            local OptionButton = Instances:Create("TextButton", {
                Parent = Items["OptionHolder"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            local OptionText = Instances:Create("TextLabel", {
                Parent = OptionButton.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                TextTransparency = 0.48,
                Text = Option,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -5, 1, 0),
                Position = UDim2New(0, 5, 0, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = 5,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            OptionText:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = OptionText.Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            local OptionData = {
                Selected = false,
                Name = Option,
                Text = OptionText,
                Button = OptionButton
            }

            function OptionData:Toggle(State)
                if State == "Active" then 
                    OptionData.Text:ChangeItemTheme({TextColor3 = "Accent"})
                    OptionData.Text:Tween(nil, {TextColor3 = Library.Theme.Accent, TextTransparency = 0})
                else
                    OptionData.Text:ChangeItemTheme({TextColor3 = "Text"})
                    OptionData.Text:Tween(nil, {TextColor3 = Library.Theme.Text, TextTransparency = 0.48})
                end
            end

            function OptionData:Set()
                OptionData.Selected = not OptionData.Selected

                if Dropdown.Multi then
                    local Index = TableFind(Dropdown.Value, OptionData.Name)

                    if Index then 
                        TableRemove(Dropdown.Value, Index)
                    else
                        TableInsert(Dropdown.Value, OptionData.Name)
                    end

                    Library.Flags[Dropdown.Flag] = Dropdown.Value

                    OptionData:Toggle(Index and "Inactive" or "Active")

                    local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "--"

                    Items["Value"].Instance.Text = TextFormat
                else
                    if OptionData.Selected then
                        Dropdown.Value = OptionData.Name

                        Library.Flags[Dropdown.Flag] = Dropdown.Value

                        OptionData:Toggle("Active")
                        Items["Value"].Instance.Text = OptionData.Name

                        for Index, Value in Dropdown.Options do 
                            if Value ~= OptionData then 
                                Value.Selected = false
                                Value:Toggle("Inactive")
                            end
                        end
                    else
                        Dropdown.Value = nil

                        OptionData:Toggle("Inactive")
                        Items["Value"].Instance.Text = "--"
                    end
                end

                if Dropdown.Callback then 
                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end
            end

            OptionButton:Connect("MouseButton1Down", function()
                OptionData:Set()
            end)

            Dropdown.Options[Option] = OptionData
            return OptionData
        end

        function Dropdown:Remove(Option)
            if Dropdown.Options[Option] then 
                Dropdown.Options[Option].Button:Clean()
            end
        end

        function Dropdown:Refresh(List)
            for Index, Value in Dropdown.Options do 
                Dropdown:Remove(Value.Name)
            end

            for Index, Value in List do 
                Dropdown:Add(Value)
            end
        end

        local Debounce = false

        function Dropdown:SetOpen(Bool)
            if Debounce then 
                return 
            end

            Dropdown.IsOpen = Bool

            Debounce = true 

            if Bool then 
                Items["OptionHolder"].Instance.Visible = true
                Items["OptionHolder"].Instance.ZIndex = 15
                Items["Open"].Instance.Text = "-"
                Items["Open"].Instance.Position = UDim2New(0, -5, 0, -1)
            else
                Items["Open"].Instance.Text = "+"
                Items["Open"].Instance.Position = UDim2New(0, -4, 0, -1)
            end

            local Descendants = Items["OptionHolder"].Instance:GetDescendants()
            TableInsert(Descendants, Items["OptionHolder"].Instance)

            local NewTween
            for Index, Value in Descendants do 
                local ValueIndex = Library:GetTransparencyPropertyFromItem(Value)

                if not ValueIndex then 
                    continue
                end

                if not StringFind(Value.ClassName, "UI") then 
                    Value.ZIndex = Bool and 15 or 1
                end

                if type(ValueIndex) == "table" then
                    for _, Property in ValueIndex do 
                        NewTween = Library:FadeItem(Value, Property, Bool, Dropdown.Window.FadeSpeed)
                    end
                else
                    NewTween = Library:FadeItem(Value, ValueIndex, Bool, Dropdown.Window.FadeSpeed)
                end
            end

            Library:Connect(NewTween.Tween.Completed, function()
                Debounce = false
                Items["OptionHolder"].Instance.Visible = Bool
                Items["OptionHolder"].Instance.ZIndex = Bool and 15 or 1
            end)
        end

        for Index, Value in Dropdown.Items do 
            Dropdown:Add(Value)
        end

        Items["Open"]:Connect("MouseButton1Down", function()
            Dropdown:SetOpen(not Dropdown.IsOpen)
        end)

        if Dropdown.Default then 
            Dropdown:Set(Dropdown.Default)
        end

        Library.SetFlags[Dropdown.Flag] = function(Value)
            Dropdown:Set(Value)            
        end

        return Dropdown
    end

    Library.Sections.Label = function(self, Data)
        Data = Data or { }

        local Label = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Name = Data.Name or Data.name,
            Alignment = Data.Alignment or Data.alignment or "Left",

            Count = 0
        }

        local Items = { } do 
            Items["Label"] = Instances:Create("Frame", {
                Parent = Label.Section.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 15),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Label"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Label.Name,
                Name = "\0",
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment[Label.Alignment],
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
            }):AddToTheme({Color = "Text Border"})
        end

        function Label:Colorpicker(Data)
            Data = Data or { }

            local Colorpicker = {
                Window = self.Window,
                Tab = self.Tab,
                Section = self.Section,

                Parent = Items["Label"],
                Name = Data.Name or Data.name or "Colorpicker",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                Callback = Data.Callback or Data.callback or function() end,
                Alpha = Data.Alpha or Data.alpha or false,
                Count = Label.Count,
                FadeSpeed = self.Window.FadeSpeed
            }

            Label.Count += 1
            Colorpicker.Count = Label.Count

            local Extension = Library:CreateColorpicker(Colorpicker)
            
            return Colorpicker, Extension
        end

        function Label:Keybind(Data)
            Data = Data or { }

            local Keybind = {
                Window = self.Window,
                Tab = self.Tab,
                Section = self.Section,

                Parent = Items["Label"],
                Name = Data.Name or Data.name or "Keybind",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or "MB2",
                Mode = Data.Mode or Data.mode or "Toggle",
                Callback = Data.Callback or Data.callback or function() end,
            }

            local Extension = Library:CreateKeybind(Keybind)

            return Keybind, Extension
        end

        return Label
    end

    Library.Sections.Textbox = function(self, Data)
        Data = Data or { }

        local Textbox = {
            Window = self.Window,
            Tab = self.Tab,
            Section = self,

            Name = Data.Name or Data.name or "Textbox",
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Placeholder = Data.Placeholder or Data.placeholder or "...",
            Default = Data.Default or Data.default or "",
            Callback = Data.Callback or Data.callback or function() end,

            Value = "",
            Class = "Textbox"
        }

        local Items = { } do 
            Items["Textbox"] = Instances:Create("Frame", {
                Parent = Textbox.Section.Elements["Content"].Instance,
                BackgroundTransparency = 1,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, 0, 0, 34),
                BorderSizePixel = 0,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["Text"] = Instances:Create("TextLabel", {
                Parent = Items["Textbox"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = Textbox.Name,
                Name = "\0",
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2New(1, 0, 0, 13),
                BorderSizePixel = 0,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Text"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIStroke", {
                Parent = Items["Text"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})
            
            Items["Background"] = Instances:Create("Frame", {
                Parent = Items["Textbox"].Instance,
                AnchorPoint = Vector2New(0, 1),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                BorderColor3 = FromRGB(10, 10, 10),
                Size = UDim2New(1, 0, 0, 17),
                BorderSizePixel = 2,
                BackgroundColor3 = FromRGB(33, 33, 36)
            })  Items["Background"]:AddToTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            
            Instances:Create("UIGradient", {
                Parent = Items["Background"].Instance,
                Rotation = 90,
                Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(100, 100, 100))}
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["Background"].Instance,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0",
                Color = FromRGB(27, 27, 32)
            }):AddToTheme({Color = "Outline"})
            
            Items["Inline"] = Instances:Create("TextBox", {
                Parent = Items["Background"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                Name = "\0",
                Size = UDim2New(1, 0, 1, 0),
                BorderSizePixel = 0,
                ClearTextOnFocus = false,
                BackgroundTransparency = 1,
                PlaceholderColor3 = FromRGB(178, 178, 178),
                TextXAlignment = Enum.TextXAlignment.Left,
                PlaceholderText = Textbox.Placeholder,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            })  Items["Inline"]:AddToTheme({TextColor3 = "Text"})
            
            Instances:Create("UIPadding", {
                Parent = Items["Inline"].Instance,
                PaddingBottom = UDimNew(0, 3),
                PaddingLeft = UDimNew(0, 5)
            }) 
            
            Instances:Create("UIStroke", {
                Parent = Items["Inline"].Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            Items["Background"]:OnHover(function()
                Items["Background"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                Items["Background"]:ChangeItemTheme({BackgroundColor3 = "Hovered Element", BorderColor3 = "Border"})
            end)

            Items["Background"]:OnHoverLeave(function()
                Items["Background"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
                Items["Background"]:ChangeItemTheme({BackgroundColor3 = "Element", BorderColor3 = "Border"})
            end)
        end

        function Textbox:Get()
            return Textbox.Value
        end

        function Textbox:SetVisibility(Bool)
            Items["Textbox"].Instance.Visible = Bool
        end

        function Textbox:Set(Value)
            Textbox.Value = Value
            
            Items["Inline"].Instance.Text = Textbox.Value
            Items["Inline"]:Tween(nil, {TextColor3 = Library.Theme.Text})
            Items["Inline"]:ChangeItemTheme({TextColor3 = "Text"})

            Library.Flags[Textbox.Flag] = Textbox.Value

            if Textbox.Callback then
                Library:SafeCall(Textbox.Callback, Textbox.Value)
            end
        end

        Items["Inline"]:Connect("Focused", function()
            Items["Inline"]:ChangeItemTheme({TextColor3 = "Accent"})
            Items["Inline"]:Tween(nil, {TextColor3 = Library.Theme.Accent})
        end)

        Items["Inline"]:Connect("FocusLost", function()
            Items["Inline"]:ChangeItemTheme({TextColor3 = "Text"})
            Items["Inline"]:Tween(nil, {TextColor3 = Library.Theme.Text})

            Textbox:Set(Items["Inline"].Instance.Text)
        end)

        if Textbox.Default then
            Textbox:Set(Textbox.Default)
        end

        Library.SetFlags[Textbox.Flag] = function(Value)
            Textbox:Set(Value)
        end

        return Textbox
    end
    
    Library.Sections.Listbox = function(self, Data)
        Data = Data or {}

        local Listbox = {
            Window = self.Window,
            Page = self.Page,
            Section = self,

            Items = Data.Items or Data.items or { },
            Multi = Data.Multi or Data.multi or false,
            Default = Data.Default or Data.default or 1,
            Flag = Data.Flag or Data.flag or Library:NextFlag(),
            Callback = Data.Callback or Data.callback or function() end,
            Size = Data.Size or Data.size or 175,

            Value = { },
            Options = { },
            Class = "Listbox",
        }

        local Items = { } do 
            Items["Listbox"] = Instances:Create("Frame", {
                Parent = Listbox.Section.Elements["Content"].Instance,
                Name = "\0",
                BackgroundTransparency = 1,
                Size = UDim2New(1, 0, 0, Listbox.Size),
                BorderColor3 = FromRGB(0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            Items["RealListbox"] = Instances:Create("ScrollingFrame", {
                Parent = Items["Listbox"].Instance,
                ScrollBarImageColor3 = FromRGB(235, 157, 255),
                Active = true,
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 1,
                AnchorPoint = Vector2New(0, 1),
                Size = UDim2New(1, 0, 1, 0),
                Name = "\0",
                Position = UDim2New(0, 0, 1, 0),
                BackgroundColor3 = FromRGB(15, 15, 20),
                BorderColor3 = FromRGB(10, 10, 10),
                BorderSizePixel = 2,
                CanvasSize = UDim2New(0, 0, 0, 0)
            })  Items["RealListbox"]:AddToTheme({ScrollBarImageColor3 = "Accent", BackgroundColor3 = "Background", BorderColor3 = "Border"})
            
            Instances:Create("UIStroke", {
                Parent = Items["RealListbox"].Instance,
                Color = FromRGB(27, 27, 32),
                Name = "\0",
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            }):AddToTheme({Color = "Outline"}) 
            
            Instances:Create("UIListLayout", {
                Parent = Items["RealListbox"].Instance,
                SortOrder = Enum.SortOrder.LayoutOrder
            }) 

            Instances:Create("UIPadding", {
                Parent = Items["RealListbox"].Instance,
                PaddingBottom = UDimNew(0, 5),
                PaddingTop = UDimNew(0, 2)
            }) 
        end

        function Listbox:Set(Option)
            if Listbox.Multi then 
                if type(Option) ~= "table" then 
                    return
                end

                Listbox.Value = Option

                Library.Flags[Listbox.Flag] = Listbox.Value

                for Index, Value in Option do 
                    local OptionData = Listbox.Options[Value]
                    
                    if not OptionData then 
                        return
                    end

                    OptionData.Selected = true
                    OptionData:Toggle("Active")
                end
            else
                if not Listbox.Options[Option] then 
                    return
                end

                local OptionData = Listbox.Options[Option]

                Listbox.Value = OptionData.Name
                
                Library.Flags[Listbox.Flag] = Listbox.Value

                OptionData.Selected = true
                OptionData:Toggle("Active")

                for Index, Value in Listbox.Options do 
                    if Value ~= OptionData then 
                        Value.Selected = false
                        Value:Toggle("Inactive")
                    end
                end
            end

            if Listbox.Callback then 
                Library:SafeCall(Listbox.Callback, Option)
            end
        end

        function Listbox:Get()
            return Listbox.Value
        end

        function Listbox:SetVisibility(Bool)
            Items["Listbox"].Instance.Visible = Bool
        end

        function Listbox:Remove(Option)
            if Listbox.Options[Option] then 
                Listbox.Options[Option].Button:Clean()
            end
        end

        function Listbox:Refresh(List)
            for Index, Value in Listbox.Options do 
                Listbox:Remove(Value.Name)
            end

            for Index, Value in List do 
                Listbox:Add(Value)
            end
        end

        function Listbox:Add(Option)
            local OptionButton = Instances:Create("TextButton", {
                Parent = Items["RealListbox"].Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(0, 0, 0),
                BorderColor3 = FromRGB(0, 0, 0),
                Text = "",
                AutoButtonColor = false,
                Name = "\0",
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2New(1, 0, 0, 15),
                ZIndex = 5,
                TextSize = 14,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            local OptionText = Instances:Create("TextLabel", {
                Parent = OptionButton.Instance,
                FontFace = Library.Font,
                TextColor3 = FromRGB(215, 215, 215),
                TextTransparency = 0.48,
                Text = Option,
                Name = "\0",
                BorderColor3 = FromRGB(0, 0, 0),
                Size = UDim2New(1, -5, 1, 0),
                Position = UDim2New(0, 5, 0, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Center,
                BorderSizePixel = 0,
                ZIndex = 5,
                TextSize = 12,
                BackgroundColor3 = FromRGB(255, 255, 255)
            }) 
            
            OptionText:AddToTheme({TextColor3 = "Text"})

            Instances:Create("UIStroke", {
                Parent = OptionText.Instance,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Name = "\0"
            }):AddToTheme({Color = "Text Border"})

            local OptionData = {
                Selected = false,
                Name = Option,
                Text = OptionText,
                Button = OptionButton
            }

            function OptionData:Toggle(State)
                if State == "Active" then 
                    OptionData.Text:ChangeItemTheme({TextColor3 = "Accent"})
                    OptionData.Text:Tween(nil, {TextColor3 = Library.Theme.Accent, TextTransparency = 0})
                else
                    OptionData.Text:ChangeItemTheme({TextColor3 = "Text"})
                    OptionData.Text:Tween(nil, {TextColor3 = Library.Theme.Text, TextTransparency = 0.48})
                end
            end

            function OptionData:Set()
                OptionData.Selected = not OptionData.Selected

                if Listbox.Multi then
                    local Index = TableFind(Listbox.Value, OptionData.Name)

                    if Index then 
                        TableRemove(Listbox.Value, Index)
                    else
                        TableInsert(Listbox.Value, OptionData.Name)
                    end

                    OptionData:Toggle(Index and "Inactive" or "Active")

                    local TextFormat = #Listbox.Value > 0 and TableConcat(Listbox.Value, ", ") or "--"
                else
                    if OptionData.Selected then
                        Listbox.Value = OptionData.Name

                        OptionData:Toggle("Active")

                        for Index, Value in Listbox.Options do 
                            if Value ~= OptionData then 
                                Value.Selected = false
                                Value:Toggle("Inactive")
                            end
                        end
                    else
                        Listbox.Value = nil

                        OptionData:Toggle("Inactive")
                    end
                end

                if Listbox.Callback then 
                    Library:SafeCall(Listbox.Callback, Listbox.Value)
                end
            end

            OptionButton:Connect("MouseButton1Down", function()
                OptionData:Set()
            end)

            Listbox.Options[Option] = OptionData
            return OptionData
        end

        for Index, Value in Listbox.Items do 
            Listbox:Add(Value)
        end

        if Listbox.Default then 
            Listbox:Set(Listbox.Default)
        end

        Library.SetFlags[Listbox.Flag] = function(Value)
            Listbox:Set(Value)
        end

        return Listbox
    end
end
--

getgenv().Library = Library
return Library
