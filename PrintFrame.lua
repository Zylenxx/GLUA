function PrintFrame(IN,depth,maxdepth,StartPathName)
	local SK = ""
	local CPath = StartPathName .. "."
	local Contents = vgui.Create("DFrame")
	local Tabs = vgui.Create("DPropertySheet",Contents)
	Tabs:Dock(FILL)
	local Tab1 = vgui.Create("DPanel")
	Tabs:AddSheet("Print",Tab1,"icon16/application_view_list.png",false,false,"Your query.")
	Tab1:Dock(FILL)
	Contents:Center()
	Contents:SetSize(1000,500)
	Contents:SetTitle("Contents")
	Contents:MakePopup()
	Contents:SetSkin(SK)
	local Tree = vgui.Create("DTree",Tab1)
	Tree:Dock(FILL)
	Tree:SetLineHeight(16)
	Tree:SetDrawBackground(false)
	local Lenmax = maxdepth or 1
	local function DoNodePopulate(From,IN,depth,maxdepth,StartPathName)
		for k,v in pairs(IN) do
			if Lenmax > 0 then
				local Bulletin  = From:AddNode(k  ..":" .. tostring(v))
				Bulletin.BType  = type(v)
				Bulletin.PathN  = StartPathName .. "." .. k 
				Bulletin.PureN  = k
				Bulletin:SetSkin(SK)
				if istable(v) then Bulletin:SetIcon("icon16/application_view_list.png") end
				if type(v)=="string" then Bulletin:SetIcon("icon16/font.png") end
				if IsColor(v) then Bulletin:SetIcon("icon16/color_wheel.png") 
				Bulletin.BType = "color"
				end
				if type(v)=="function" then Bulletin:SetIcon("icon16/cog_go.png") end
				if type(v)=="number" then Bulletin:SetIcon("icon16/calendar_view_day.png") end
				if type(v)=="userdata" then Bulletin:SetIcon("icon16/database_gear.png") end
				if type(v)=="boolean" then Bulletin:SetIcon("icon16/contrast_high.png") end
				if type(v)=="nil" then Bulletin:SetIcon("icon16/cross.png") end -- should not happen
				if type(v)=="Vector" then Bulletin:SetIcon("icon16/arrow_out.png") end
				if type(v)=="Angle" then Bulletin:SetIcon("icon16/arrow_rotate_anticlockwise.png") end
				if type(v) == "table" then
					 depth=depth+1
					 Lenmax=Lenmax-1
					 DoNodePopulate(Bulletin,v,depth,maxdepth,Bulletin.PathN)
				end
				
				function Bulletin:Paint(w,h)
						
				end
			end
		end
	end

	local Interaction = vgui.Create("DPanel",Tab1)
	Interaction:Dock(BOTTOM)
	Interaction:SetSize(1000,100)
	Interaction:SetSkin(SK)
	
	local ColorPreview = vgui.Create("DPanel",Interaction)
	ColorPreview:SetSize(75,75)
	ColorPreview:SetPos(400,12)
	ColorPreview.Color=Color(0,0,0,0)
			function ColorPreview:Paint(w,h)
				local r,g,b,a = self.Color:Unpack()
				local MT = Material( "gui/alpha_grid.png", "noclamp smooth" )
				surface.SetDrawColor(255,255,255,255)
				surface.SetMaterial(MT)
				surface.DrawTexturedRectUV(0,0,w,h,-0.125,-0.125,0.125,0.125)
				
				surface.SetDrawColor(r or 0,g or 0,b or 0,a or 0)
				surface.DrawRect(0,0,w,h)
			end
	
	
	
	
	local InfoI=vgui.Create("DLabel",Interaction) 
	InfoI:SetPos(5,5)
	InfoI:SetSize(490,90)
	InfoI:SetText("Welcome to the contents manager. Select a node to start.")
	InfoI:SetContentAlignment(7)
	InfoI:SetSkin(SK)
	
	local ChangeValue = vgui.Create("DButton",Interaction)
	ChangeValue:SetPos(1000-200,5)
	ChangeValue:SetSize(190,40)
	ChangeValue:SetSkin(SK)
	ChangeValue:SetText("<unsupported>")
	function ChangeValue:DoClick() end
	
	local ChangeSkin = vgui.Create("DComboBox",Interaction)
	ChangeSkin:SetSkin(SK)
	ChangeSkin:SetPos(5,100-20)
	ChangeSkin:SetSize(95,20)
	ChangeSkin:SetValue("Set Skin:")
	for k,v in pairs(derma.SkinList) do
		ChangeSkin:AddChoice(k)	
	end
	function ChangeSkin:OnSelect(ID,Val)
		SK = Val
		Contents:SetSkin(SK)
		Tree:SetSkin(SK)
		ChangeSkin:SetSkin(SK)
		ChangeValue:SetSkin(SK)
		Tab1:SetSkin(SK)
	end
	
	function Tree:OnNodeSelected(pnl)
		local TXT = Tree:GetSelectedItem():GetText()
		local NM  = Tree:GetSelectedItem().PathN
		local VL  = string.split(TXT,":")[2]
		
		if Tree:GetSelectedItem().BType == "color" then
			ColorPreview:Show()
		else
			ColorPreview:Hide()
		end
	
		
		
		
		if Tree:GetSelectedItem().BType == "boolean" or Tree:GetSelectedItem().BType == "number" or Tree:GetSelectedItem().BType == "string" or Tree:GetSelectedItem().BType == "color" then  
		   ChangeValue:SetText("Change Value:")
		   function ChangeValue:DoClick() 
		   		local ChangValPopup = vgui.Create("DFrame")
		   			ChangValPopup:SetSize(200,100)
		   			ChangValPopup:Center()
		   			ChangValPopup:MakePopup()
		   			ChangValPopup:SetTitle("Change Value")
		   			ChangValPopup:SetSkin(SK)
	   			if Tree:GetSelectedItem().BType == "boolean" then
	   				
   					ChangValPopup:SetSize(200,100)
   					local CVPnl = vgui.Create("DCheckBoxLabel",ChangValPopup)
   					CVPnl:Center()
   					CVPnl:SetText(string.split(TXT,":")[1])
   					CVPnl:SetChecked(tobool(VL))
   					CVPnl:SetSkin(SK)
   					function CVPnl:OnChange(bool) 
   					
   					end -- actually make it do stuff when i can guarantee it does so reliably
   					
   				end
				if Tree:GetSelectedItem().BType == "number" then
   					ChangValPopup:SetSize(200,100)
   					local CVPnl = vgui.Create("DNumberWang",ChangValPopup)
   					CVPnl:Center()
   					CVPnl:SetValue(VL)
   					CVPnl:SetSkin(SK)
   					local OK = vgui.Create("DButton",ChangValPopup)
   					OK:Dock(BOTTOM)
   					OK:SetText("Ok")
   					function OK:DoClick()
   						ChangValPopup:Close()
   					end
   				end
				if Tree:GetSelectedItem().BType == "string" then
   					ChangValPopup:SetSize(200,100)
   					local CVPnl = vgui.Create("DTextEntry",ChangValPopup)
   					CVPnl:SetSkin(SK)
   					CVPnl:SetWide(ChangValPopup:GetWide()-5)
   					CVPnl:Center()
   					CVPnl:SetText(VL)
   					local OK = vgui.Create("DButton",ChangValPopup)
   					OK:Dock(BOTTOM)
   					OK:SetText("Ok")
   					function OK:DoClick()
   						ChangValPopup:Close()
   					end
   				end
				if Tree:GetSelectedItem().BType == "color" then
   					ChangValPopup:SetSize(300,300)
   					local CVPnl = vgui.Create("DColorMixer",ChangValPopup)
   					CVPnl:Dock(FILL)
   					CVPnl:SetColor(string.ToColor(VL))
   					CVPnl:SetSkin(SK)
   					local OK = vgui.Create("DButton",ChangValPopup)
   					OK:Dock(BOTTOM)
   					OK:SetText("Ok")
   					function OK:DoClick()
   						ChangValPopup:Close()
   					end
   				end
           end
		else
		   ChangeValue:SetText("<unsupported>")
		   function ChangeValue:DoClick() end
		end

		if Tree:GetSelectedItem().BType == "table" then
		   InfoI:SetText(NM.."\nType:".. Tree:GetSelectedItem().BType or "No item selected.")
		else
		   InfoI:SetText(NM.."\nType:".. Tree:GetSelectedItem().BType .."(".. VL ..")" or "No item selected.")
		   if Tree:GetSelectedItem().BType == "color" then
		   	  ColorPreview.Color = string.ToColor(VL)
		   end
		end

		function pnl:DoRightClick()
			local RCMenu=DermaMenu(false,Contents)
				RCMenu:SetPos(500,500-100)
				RCMenu:SetMaxHeight(90)
				RCMenu:AddOption("Copy Name (".. pnl.PureN ..")" ,function() SetClipboardText(pnl.PureN) end)
				RCMenu:AddOption("Copy Path (".. NM ..")" ,function() SetClipboardText(NM) end)
				RCMenu:AddOption("Copy Value (".. VL ..")" ,function() SetClipboardText(VL) end)
			if Tree:GetSelectedItem().BType == "function" then
				RCMenu:AddSpacer()
				RCMenu:AddOption("copy function call as print",function() SetClipboardText("print(".. NM .."())") end)
				RCMenu:AddOption("copy function call as printtable",function() SetClipboardText("PrintTable(".. NM .."())") end)
			end
		end
	end
	DoNodePopulate(Tree,IN,depth,maxdepth,StartPathName)
end
function TestPrintFrame()
	local TestTable = {}
	TestTable["Test Values"]={
		number=0,
		string="string",
		vec=Vector(0,0,0),
		col1=Color(0,255,0,127),
		ang=Angle(0,0,0),
		quat=Quaternion(0,0,0,0),
		func=function()end,
		bool=false,
		table={string2="The Fitnessgram pacer test is a multistage aerobic capacity test that progressively",
			string3="gets more difficult as it continues."
		}
	}
	PrintFrame(TestTable,0,250,"TestTable")
end
