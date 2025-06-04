function PrintFrame(IN,depth,maxdepth,StartPathName)
	local SK = "dark_meta"
	local CPath = StartPathName .. "."
	local Contents = vgui.Create("DFrame")
	Contents:Center()
	Contents:SetSize(1000,500)
	Contents:SetTitle("Contents")
	Contents:MakePopup()
	Contents:SetSkin(SK)
	local Tree = vgui.Create("DTree",Contents)
	Tree:Dock(FILL)
	Tree:SetLineHeight(16)
	Tree:SetSkin(SK)
	local Lenmax = maxdepth or 1
	local function DoNodePopulate(From,IN,depth,maxdepth,StartPathName)
		for k,v in pairs(IN) do
			if Lenmax > 0 then
				local Bulletin = From:AddNode(k  ..":" .. tostring(v))
				Bulletin.BType  = type(v)
				Bulletin.PathN = StartPathName .. "." .. k 
				Bulletin:SetSkin(SK)
				if istable(v) then Bulletin:SetIcon("icon16/application_view_list.png") end
				if type(v)=="string" then Bulletin:SetIcon("icon16/font.png") end
				if IsColor(v) then Bulletin:SetIcon("icon16/color_wheel.png") end
				if type(v)=="function" then Bulletin:SetIcon("icon16/cog_go.png") end
				if type(v)=="number" then Bulletin:SetIcon("icon16/calendar_view_day.png") end
				if type(v)=="userdata" then Bulletin:SetIcon("icon16/database_gear.png") end
				if type(v)=="boolean" then Bulletin:SetIcon("icon16/contrast_high.png") end
				if type(v)=="nil" then Bulletin:SetIcon("icon16/cross.png") end -- should not happen
				
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

	local Interaction = vgui.Create("DPanel",Contents)
	Interaction:Dock(BOTTOM)
	Interaction:SetSize(1000,100)
	Interaction:SetSkin(SK)
	
	local InfoI=vgui.Create("DLabel",Interaction) 
	InfoI:SetPos(5,5)
	InfoI:SetSize(490,90)
	InfoI:SetText("Welcome to the contents manager. Select a node to start.")
	InfoI:SetContentAlignment(7)
	InfoI:SetSkin(SK)
	
	local ChangeValue = vgui.Create("DButton",Interaction)
	ChangeValue:SetPos(1000-200,0)
	ChangeValue:SetSize(200,50)
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
	end
	
	function Tree:OnNodeSelected(pnl)
		local TXT = Tree:GetSelectedItem():GetText()
		local NM  = Tree:GetSelectedItem().PathN
		local VL  = string.split(TXT,":")[2]
		if Tree:GetSelectedItem().BType == "boolean" or Tree:GetSelectedItem().BType == "number" or Tree:GetSelectedItem().BType == "string" then  
		   ChangeValue:SetText("Change Value:")
		   function ChangeValue:DoClick() end
		else
		   ChangeValue:SetText("<unsupported>")
		   function ChangeValue:DoClick() end
		end

		if Tree:GetSelectedItem().BType == "table" then
		   InfoI:SetText(NM.."\nType:".. Tree:GetSelectedItem().BType or "No item selected.")
		else
		   InfoI:SetText(NM.."\nType:".. Tree:GetSelectedItem().BType .."(".. VL ..")" or "No item selected.")
		end
		
	end
	DoNodePopulate(Tree,IN,depth,maxdepth,StartPathName)
end
