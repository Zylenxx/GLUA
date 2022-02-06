
--[[
#############################################################
#################  CONSTANTS AND VARIABLES  #################
#############################################################
]]--

-- Fonts.

	local _Localfont = "EuroStile Extended"
	-- NonStock Font. Obtained here:
	-- https://freefontsdownload.net/free-eurostile_extended-font-72055.htm
	
	
	-- Startmenu Font.
	surface.CreateFont( "Centronium" , {
	font = _Localfont, extended = false,
	size = 15, weight = 500,
	blursize = 0, scanlines =0,
    	antialias = true, underline = false,
    	italic = false, strikeout = false,
    	symbol = false, rotary = false,
    	shadow = false, additive = false,
    	outline = false
    	} )
    	------------------------------------------------

-- TaskBar Settings.
local _WinMenuH = 30
local _TabIcon  = "icon16/tab.png"
local _StartIcon = "icon16/layers.png"
local _VolIcon   = "icon16/sound.png"
-----------------------------------------------


-- For global removal via StartMenuCanvas and various other needs.

local Activepanels = {}
-----------------------------------------------
-- For DFrames
local ActiveTabs   = {}
-----------------------------------------------
local Extras       = {}
-----------------------------------------------
--[[
#############################################################
###################  CONTENTS: MAIN MENU  ###################
#############################################################
]]--

-- The taskbar.
local WinMenu = vgui.Create("DMenuBar")
	  WinMenu:Dock( BOTTOM )
	  WinMenu:SetHeight(_WinMenuH)
	  function WinMenu:Paint(w,h)
	  draw.RoundedBox(0,0,0,w,h,Color(24,24,32))
	  draw.RoundedBox(0,0,(h/2)-1,w,2,Color(64,64,96,12))
	  draw.RoundedBox(0,0,0,w,h/2,Color(64,64,96,12))
	  end
	  function WinMenu:OnRemove()
	  	
	  end
Activepanels.Menu = WinMenu

-----------------------------------------------

-- The start button.
local Start = WinMenu:Add("DButton",WinMenu)
	  Start:SetContentAlignment(4)
	  Start:SetText("Start")
	  Start:Dock( LEFT )
	  Start:SetWidth(75)
	  Start:SetHeight(_WinMenuH)
	  Start:SetIcon(_StartIcon)
	  function Start:Paint(w,h)
	  draw.RoundedBox(0,0,0,w,h,Color(24,24,32))
	  draw.RoundedBox(0,0,(h/2)-1,w,2,Color(64,64,96,12))
	  draw.RoundedBox(0,0,0,w,h/2,Color(64,64,96,12))
	  draw.RoundedBox(0,0,0,w,h,Color(64,64,96,25))
	  end
Activepanels.Startbut = Start
-----------------------------------------------

-- The time display.
local DateTable = string.Split(os.date()," ")
local TimeD = vgui.Create("DButton",WinMenu)
	  TimeD:Dock(RIGHT)
	  TimeD:SetWidth(100)
	  TimeD:SetContentAlignment(5)
	  TimeD:SetFont("Centronium")
	  TimeD:SetText(DateTable[5] .. "\n" .. DateTable[2] .. " " ..DateTable[4])
	  function TimeD:Paint()
	  end
-----------------------------------------------------


-- StartMenuCanvas Main panel & Popup.
local StartMenuCanvas = vgui.Create("DPanel")
	  StartMenuCanvas:SetPos(0,ScrH()-500-_WinMenuH)
      StartMenuCanvas:SetSize(400,500)
      StartMenuCanvas:Hide()
      function StartMenuCanvas:Paint(w,h)
      draw.RoundedBox(0,0,0,w,h,Color(24,24,32,224))	
      end
Activepanels.StartMen = StartMenuCanvas

-- Internal Panels.
local StartMenuInternal = vgui.Create("DPanel",StartMenuCanvas)
	  StartMenuInternal:Dock(LEFT)
	  StartMenuInternal:DockMargin(9,9,0,9)
	  StartMenuInternal:SetSize(245,482)
	  function StartMenuInternal:Paint(w,h)
	  draw.RoundedBox(0,0,0,w,h,Color(48,48,64,128))
	  end
local StartMenuInternal2 = vgui.Create("DPanel",StartMenuCanvas)
	  StartMenuInternal2:Dock(LEFT)
	  StartMenuInternal2:DockMargin(9,9,0,9)
	  StartMenuInternal2:SetSize(128,422)
	  
	  -- in the original reference menu, this part is not rendered.
	  function StartMenuInternal2:Paint()
	  end
----------------------------------------------------------------

-- Internal Icon.
local StartMenuIconFrame = vgui.Create("DPanel",StartMenuCanvas)
	  StartMenuIconFrame:SetSize(56,56)
	  StartMenuIconFrame:SetPos(330-(56/2),9)
--local StartMenuIcon = vgui.Create("DImage",StartMenuIconFrame)
--	  StartMenuIcon:Center()
--	  StartMenuIcon:SetSize(46,46)
--	  StartMenuIcon:SetImage("")
--------------------------------------------------------------------

--[[
#############################################################
###############  CONTENTS: START MENU PANEL  ################
#############################################################
]]--


-- E2 filebrowser button.
local E_2 = StartMenuInternal:Add("DButton",StartMenuInternal)
	  E_2:SetImage("icon16/application_osx_terminal.png")
	  E_2:SetContentAlignment(4)
	  E_2:Dock( BOTTOM )
	  E_2:SetText("Expression2 Files")
	  E_2:SetFont("Centronium")
	  E_2:SetSize(23,23)
	  function E_2:Paint(w,h)
	  	draw.RoundedBox(0,0,1,w,h-2,Color(24,24,32,224))
	  end
-----------------------------------------------


-- lua filebrowser button.
local L_ua = StartMenuInternal:Add("DButton",StartMenuInternal)
	  L_ua:SetImage("icon16/application_osx_terminal.png")
	  L_ua:SetContentAlignment(4)
	  L_ua:Dock( BOTTOM )
	  L_ua:DockMargin(0,0,0,0)
	  L_ua:SetText("Lua Files")
	  L_ua:SetFont("Centronium")
	  L_ua:SetSize(23,23)
	  function L_ua:Paint(w,h)
	  	draw.RoundedBox(0,0,1,w,h-2,Color(24,24,32,224))
	  end
-----------------------------------------------


-- starfall filebrowser button.
local Test = StartMenuInternal:Add("DButton",StartMenuInternal)
	  Test:SetImage("icon16/star.png")
	  Test:SetContentAlignment(4)
	  Test:Dock( BOTTOM )
	  Test:DockMargin(0,0,0,0)
	  Test:SetText("Starfall Files")
	  Test:SetFont("Centronium")
	  Test:SetSize(23,23)
	  function Test:Paint(w,h)
	  	draw.RoundedBox(0,0,1,w,h-2,Color(24,24,32,224))
	  end
-----------------------------------------------

-- starfall filebrowser button.
local Stonks = StartMenuInternal:Add("DButton",StartMenuInternal)
	  Stonks:SetImage("icon16/money_add.png")
	  Stonks:SetContentAlignment(4)
	  Stonks:Dock( BOTTOM )
	  Stonks:DockMargin(0,0,0,0)
	  Stonks:SetText("Stonks Display")
	  Stonks:SetFont("Centronium")
	  Stonks:SetSize(23,23)
	  function Stonks:Paint(w,h)
	  	draw.RoundedBox(0,0,1,w,h-2,Color(24,24,32,224))
	  end
-----------------------------------------------


-- "remove ui" button, as else there'd be 
-- no way to get rid of the StartMenuCanvas except vgui_cleanup, 
-- which breaks a fuck ton of panels.

local MainButton1 = StartMenuInternal2:Add("DButton",StartMenuInternal)
	MainButton1:Dock(BOTTOM)
	MainButton1:SetContentAlignment(4)
	MainButton1:SetImage("icon16/cancel.png")
	MainButton1:SetSize(150,23)
	MainButton1:SetText("Remove UI")
	MainButton1:SetFont("Centronium")
	function MainButton1:Paint(w,h)
	  	draw.RoundedBox(0,0,0,w,h,Color(24,24,32,128))
	end
	MainButton1.DoClick = function()
		for N,Panel in pairs(Activepanels) do
			Panel:Remove()
		end
	end
------------------------------------------------------------

--[[
#############################################################
###################  CONTENTS: TAB ENGINE  ##################
#############################################################
]]--

-- Call for each New Frame.
local function AddTab(Name,Frame,OrigSize,Icon)


-- AddTab works as follows:
-- It fetches the name of the frame title, and also fetches the pure DFrame.
-- Then, it Constructs an entry into the existing MenuBar, with a fixed width,
-- labelled as the Frame Title, and given a tab icon.

-- Its following function then allows the following on DoClick:
-- ToggleTab: toggle the visibility of a tab, just like in windows.


-- Tab constructor
local TabName = WinMenu:Add("DButton",WinMenu)
	  TabName:SetWidth(120)
	  TabName:Dock(LEFT)
	  TabName:DockMargin(2,0,0,0)
	  TabName:SetContentAlignment(4)
	  TabName:SetText(Name)
	  TabName:SetIcon(Icon)
	  function TabName:Paint(w,h)
	  draw.RoundedBox(0,0,2,w,h-4,Color(32,32,48,128))	
	  end
	  function Frame:OnClose()
		TabName:Remove()
	  end

-- Used later.
	-- the tab itself.
	ActiveTabs[Name] = {TabName}

	-- the associated frame.
	ActiveTabs[Name].FrName = {Frame}

	-- the associated size of the frame, so we can call it later.
	ActiveTabs[Name].FrName.SizeO = OrigSize

end

--[[
#############################################################
#################  CONTENTS: WINDOW CREATOR  ################
#############################################################
]]--



local function NewWindow(FrameName,Size,Pos,Icon)
-- Create a window with these arguments:
	-- FrameName : The title
	-- Size
	-- Pos : The position
	-- Icon : The frame Icon infront of the title name

-- This window will be minimizable!
local Frame = vgui.Create("DFrame")
	  Frame:SetTitle(FrameName)
	  Frame:SetPos(unpack(Pos))
	  Frame:SetSize(unpack(Size))
	  Frame:SetIcon(Icon)
	  Frame:SetDraggable(true)
	  Frame.btnMinim:SetDisabled(false)
	  
		function Frame:Paint(w,h)
			draw.RoundedBox(0,0,0,w,h,Color(24,24,32,196))	
			draw.RoundedBox(0,0,0,w,22,Color(32,32,48,128))	
		end
	  
	 		-- Call a tab associated with the frame.
			AddTab(FrameName,Frame,Size,Icon)

			-- Debugging and attatchments:
				-- the frame and frame name.
				Activepanels[FrameName] = Frame
				Activepanels[FrameName].Name = FrameName
				-- the frame state.
				Activepanels[FrameName].Minimized = false

				-- the initialized frame size, does not change.
				Activepanels[FrameName].Size = Size
		
-- We want to keep the Frame as a return value, so we can later on add to it.
return Frame
end

-- This is for debug purposes only. Fetches tabs and panels that run on startup.
print("ALL THE ACTIVE TABS:")
PrintTable(ActiveTabs)

print("ALL THE ACTIVE PANELS")
PrintTable(Activepanels)
--------------------------------------------------------------------------------
-- These are all hooks,
-- Mapped as follows:
	-- (Done!) Taskbar: 					"WINTASKBAR"	(Expected Usage: Low)
	-- Painter:						"WINPAINTUI"	(Expected Usage: Medium)
	-- (Almost Done!) WindowManagement:			"WINMGR"	(Expected Usage: High)
	-- (Almost Done!) FileBrowser:				(variable name)	(Expected Usage: Very High)
	-- Parralel Incorporator:				"INTEGRATE"	(Expected Usage: Very High)
	-- Tab Quick-switcher:					"WINTABSWITCH"	(Expected Usage: Medium)
	
	
--[[
#############################################################
#################   CONTENTS: FILEBROWSER    ################
#############################################################
]]--

local function addBrowser(filepath,browsername,hookname)
--[[
#############################################################
#################   PROTOTYPE:FILEBROWSER   #################
#############################################################
]]--

local CurDir = filepath
local FileDir = CurDir
--[[
#############################################################
#################          THE FRAME        #################
#############################################################
]]--
local Prototype = vgui.Create("DFrame")
	Prototype:SetSize(700,400)
	Prototype:SetTitle(browsername)
	Prototype:IsDraggable(true)
	function Prototype:Paint(w,h)
	draw.RoundedBox(0,0,0,w,h,Color(24,24,32,196))	
	draw.RoundedBox(0,0,0,w,22,Color(32,32,48,128))	
	end

local PrototypePathBar = vgui.Create("DPanel",Prototype)
	PrototypePathBar:Dock(TOP)
	PrototypePathBar:DockMargin(9,0,9,9)
	function PrototypePathBar:Paint(w,h)
	draw.RoundedBox(0,0,0,w,h,Color(96,96,96,196))	
	end

local PrototypeInternal = vgui.Create("DPanel",Prototype)
	PrototypeInternal:Dock(TOP)
	PrototypeInternal:DockMargin(9,9,9,9)
	PrototypeInternal:SetSize(700,230)
	function PrototypeInternal:Paint(w,h)
	draw.RoundedBox(0,0,0,w,h,Color(96,96,96,196))	
	end

local PrototypeInfo = vgui.Create("DPanel",Prototype)
	PrototypeInfo:Dock(TOP)
	PrototypeInfo:DockMargin(9,9,9,9)
	PrototypeInfo:SetSize(700,70)
	function PrototypeInfo:Paint(w,h)
	draw.RoundedBox(0,0,0,w,h,Color(96,96,96,196))	
	end
	local InfoText = vgui.Create("DLabel",PrototypeInfo)
		  InfoText:Dock(TOP)
		  InfoText:DockMargin(9,4,0,0)
		  InfoText:SetText("< No file selected >")
	local InfoText2 = vgui.Create("DLabel",PrototypeInfo)
		  InfoText2:Dock(TOP)
		  InfoText2:DockMargin(9,0,4,0)
		  InfoText2:SetText("< No fileinfo >")
	
local PrototypeSearch = vgui.Create("DLabel",PrototypePathBar)
	PrototypeSearch:Dock(BOTTOM)
	PrototypeSearch:DockMargin(9,0,0,3)
	PrototypeSearch:SetText(CurDir)
	PrototypeSearch:SetColor(Color(128,128,128))

local PrototypeScroll = vgui.Create("DScrollPanel",PrototypeInternal)
	PrototypeScroll:Dock( FILL )

--[[
#############################################################
#################    FILES AND DOCUMENTS    #################
#############################################################
]]--

local PrototypeContent = vgui.Create("DGrid",PrototypeScroll)
	PrototypeContent:SetPos(9,9)
	PrototypeContent:SetSize(100,321)
	PrototypeContent:SetCols(4)
	PrototypeContent:SetColWide(155)
	PrototypeContent:SetRowHeight(20)

local PrototypeF,PrototypeD = file.Find(CurDir.."*","DATA")
local Directories = {}
local Buttons	  = {}
local Buttons2	  = {}

local Back = vgui.Create("DButton")
	Back:SetSize(150,18)
	Back:SetContentAlignment(4)
	Back:SetMaterial("icon16/folder.png")
	Back:SetText("..")
	function Back:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,196))
		draw.RoundedBox(0,0,0,w,h/2,Color(128,128,128,12))
		end
		PrototypeContent:AddItem(Back)

	

for FID,FLE in pairs(PrototypeD) do
	local ni2 = vgui.Create("DButton")
		ni2:SetSize(150,18)
		ni2:SetContentAlignment(4)
		ni2:SetMaterial("icon16/folder.png")
		ni2:SetText(FLE)
		function ni2:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,196))
		draw.RoundedBox(0,0,0,w,h/2,Color(128,128,128,12))
		end
		
		function ni2:DoClick()
			CurDir = CurDir.. FLE.."/"
			-- print("[LUAFBROWSER]SENDNEWDIRECTORY:  ".. CurDir"!")
		end
	Directories[FID] = FLE
	Buttons[FID]	 = ni2

	PrototypeContent:AddItem(ni2)
end

for FID,FLE in pairs(PrototypeF) do
	local ni = vgui.Create("DButton")
		ni:SetSize(150,18)
		ni:SetContentAlignment(4)
		ni:SetMaterial("icon16/application_osx_terminal.png")
		ni:SetText(FLE)
		function ni:DoClick()
			FileDir = CurDir.. FLE	
			-- print("[LUAFBROWSER]SENDFILEINFO! ".. FileDir)
			InfoText:SetText("File:".. FileDir)
			InfoText2:SetText("Size:".. tostring(math.Round((file.Size(FileDir,"DATA")/1024),2)).. "KB")
		end
		function ni:Paint(w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0,196))
		draw.RoundedBox(0,0,0,w,h/2,Color(96,96,128,24))
		end
		Buttons2[FID]	 = ni
			PrototypeContent:AddItem(ni)
end

hook.Add("Think",hookname,function()
local function UpdateGrid()
	local PrototypeF,PrototypeD = file.Find(CurDir.."*","DATA")
			PrototypeSearch:SetText(CurDir)
			-- print("[LUAFBROWSER]NEWTABLE!")
			-- printTable(PrototypeF,PrototypeD)
			PrototypeContent:RemoveItem(Back)
			PrototypeSearch:SetText(CurDir)
			for B,But in pairs(PrototypeContent:GetChildren()) do
				PrototypeContent:RemoveItem(But)	
			end
		
			local Back = vgui.Create("DButton")
			Back:SetSize(150,18)
			Back:SetContentAlignment(4)
			Back:SetMaterial("icon16/folder.png")
			Back:SetText("..")
			function Back:Paint(w,h)
				draw.RoundedBox(0,0,0,w,h,Color(0,0,0,196))
				draw.RoundedBox(0,0,0,w,h/2,Color(128,128,128,12))
			end
				PrototypeContent:AddItem(Back)
			-- print("[LUAFBROWSER]BACKBUT_COMPLETE")
			
			
				if table.Count(PrototypeD) > 0 then 
					for FID,FLE in pairs(PrototypeD) do
						local ni2 = vgui.Create("DButton")
						ni2:SetSize(150,18)
						ni2:SetContentAlignment(4)
						ni2:SetMaterial("icon16/folder.png")
						ni2:SetText(FLE)
						function ni2:Paint(w,h)
							draw.RoundedBox(0,0,0,w,h,Color(0,0,0,196))
							draw.RoundedBox(0,0,0,w,h/2,Color(128,128,128,12))
						end
						-- print("DIRUPDATE:")
						Directories[FLE] = ni2
						-- print("[LUAFBROWSER]DIR ".. FLE..":SET TO ".. tostring(ni2))
						
							function ni2:DoClick()
								local NextDir = CurDir.. FLE.."/"
								-- print("[LUAFBROWSER]SENDNEWDIRECTORY:  ".. CurDir.."> "..NextDir.."!")
    							CurDir = NextDir
    							UpdateGrid()
							end
							PrototypeContent:AddItem(ni2)
					end
				end
			
			
				for FID,FLE in pairs(PrototypeF) do
					-- print("[LUAFBROWSER]FILEUPDATE!")
					local ni = vgui.Create("DButton")
					ni:SetSize(150,18)
					ni:SetContentAlignment(4)
					ni:SetMaterial("icon16/application_osx_terminal.png")
					ni:SetText(FLE)
					function ni:Paint(w,h)
						draw.RoundedBox(0,0,0,w,h,Color(0,0,0,196))
						draw.RoundedBox(0,0,0,w,h/2,Color(96,96,128,24))
					end
					function ni:DoClick()
						FileDir = CurDir.. FLE	
						-- print("[LUAFBROWSER]SENDFILEINFO! ".. FileDir)
						InfoText:SetText("File:".. FileDir)
						InfoText2:SetText("Size:".. tostring(math.Round((file.Size(FileDir,"DATA")/1024),2)).. "KB")
					end
					-- print("[LUAFBROWSER]NEWFILE:".. FLE..", as ".. tostring(ni))
						PrototypeContent:AddItem(ni)
				end
				-- printTable(Directories)
					function Back:DoClick()
					if CurDir == filepath then
					else
						local DirSplit = string.Split(CurDir,"/")
							table.remove(DirSplit,#DirSplit-1)
							CurDir = table.concat( DirSplit ,"/")
							-- print("[LUAFBROWSER]SENDNEWDIRECTORY:  ".. CurDir.." !")
							PrototypeSearch:SetText(CurDir)
							UpdateGrid()
						end
					end
				end


for D,Dir in pairs(Buttons) do
	if Dir:IsValid() and IsValid(Dir) then
		function Dir:DoClick()
			CurDir = CurDir.. Directories[D].."/"
			-- print("[LUAFBROWSER]SENDNEWDIRECTORY:  ".. CurDir.." !")
			-- print("[LUAFBROWSER]DIRCNTD")
			-- printTable(Directories)
			UpdateGrid()
			end	
		end
	end
end
)
return Prototype
end
--[[
#############################################################
#################       CONTENTS: HOOKS      ################
#############################################################
]]--

hook.Add("Think","FBROWSER",function()
	
-- function for the filebrowser tabs:
E_2.DoClick = function()
	local E2Fetcher = addBrowser("expression2/","E2 FileBrowser","E2MGR")
	Activepanels.E2MGR = E2Fetcher
	E2Fetcher.btnMinim:SetDisabled(false)
	AddTab("E2 FileBrowser",E2Fetcher,{700,400},"icon16/application_osx_terminal.png")
end

L_ua.DoClick = function()
	local LuaFetcher = addBrowser("lua_editor/","LUA FileBrowser","LUAMGR")
	Activepanels.LuaF = LuaFetcher
	LuaFetcher.btnMinim:SetDisabled(false)
	AddTab("Lua FileBrowser",LuaFetcher,{700,400},"icon16/application_osx_terminal.png")
end

Test.DoClick = function()
	local SF_Fetcher = addBrowser("starfall/","SF FileBrowser","SFMGR")
	Activepanels.SF = SF_Fetcher
	SF_Fetcher.btnMinim:SetDisabled(false)
	AddTab("SF FileBrowser",SF_Fetcher,{700,400},"icon16/star.png")
	
end

Stonks.DoClick = function()
			local Stonkers = NewWindow("Stonks Display",{400,100},{15,15},"icon16/money_add.png")	
			local Stonks_GoBrr = vgui.Create("DLabel",Stonkers)
				  Stonks_GoBrr:Dock(FILL)
				  Stonks_GoBrr:SetFont("Centronium")
end
-----------------------------------------------------------------------------------------------------------






end
)

hook.Add("Think","Stonks",function()
	if IsValid(Activepanels["Stonks Display"]) then
			local OreCashBrz = (ms.Ores.GetPlayerOre(LocalPlayer(),0)*100)
			local OreCashSlv = (ms.Ores.GetPlayerOre(LocalPlayer(),1)*300)
			local OreCashGold = (ms.Ores.GetPlayerOre(LocalPlayer(),2)*1200)
			local OreCashPlat = (ms.Ores.GetPlayerOre(LocalPlayer(),3)*2000)
			local CashTotal = (OreCashBrz+OreCashSlv+OreCashGold+OreCashPlat)*ms.Ores.GetPlayerMultiplier(LocalPlayer())
			Activepanels["Stonks Display"]:GetChildren()[6]:SetText("Current trade-in would result in:\n+" .. tostring(math.Round(CashTotal)) .." Points/Coins")
	end
end)

hook.Add("Think","WINTASKBAR",function()
	-- Start Button:
	if Start:IsValid() then
		Start.DoClick = function()
			StartMenuCanvas:ToggleVisible()
		end
	end
	------------------------------------------
end
)


hook.Add("Think","WINMGR",function()



		-- Tab Buttons:
		for T,FName in pairs(ActiveTabs) do
			local WIN = FName.FrName[1]
			function WIN:OnStartDragging()
				WIN:MoveToFront()
			end
			
			if IsValid(FName.FrName[1]) then
				FName[1].DoClick = function()
					FName.FrName[1]:ToggleVisible()
				end
			
			-- Windows Style minimizing behavior
			FName.FrName[1].btnMinim.DoClick = function()
				FName.FrName[1]:ToggleVisible()
			end
			----------------------------------------------
		end
		---------------------------------------------------------
	end

end
)
hook.Add("Think","TimeDisplay_Winmenu",function()
 local DateTable = string.Split(os.date()," ")
 TimeD:SetText(DateTable[5] .. "\n" .. DateTable[2] .. " " ..DateTable[4])
end)
