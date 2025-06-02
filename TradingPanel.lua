-- Trading Panel Mockup

local lookup = function(string)
	local mdl = ""
	if string.lower(string) == "melon" then mdl = "models/props_junk/watermelon01.mdl" end
	if string.lower(string) == "crate" then mdl = "models/props_crates/static_crate_40.mdl" end
	if string.lower(string) == "fish" then mdl = "models/props/de_inferno/goldfish.mdl" end
	if string.lower(string) == "pizza" then mdl = "models/props_arcade/pizza001a.mdl" end
	if string.lower(string) == "coffee" then mdl = "models/props_junk/garbage_coffeemug001a_forevergibs.mdl" end
	if string.lower(string) == "cookie" then mdl = "models/python1320/cookie5.mdl" end
	if string.lower(string) == "coke" then mdl = "models/props_junk/garbage_sodacan01a.mdl" end
	if string.lower(string) == "bar" then mdl = "models/props_mining/ingot001.mdl" end
	if string.lower(string) == "orange" then mdl = "models/props/cs_italy/orange.mdl" end
	return mdl
end
local lookupSZ = function(string)
	local SZ = Vector(0,0,0)
	if string.lower(string) == "melon" then SZ = Vector(15,15,0) end
	if string.lower(string) == "crate" then SZ = Vector(50,50,50) end
	if string.lower(string) == "fish" then SZ = Vector(13,13,5) end
	if string.lower(string) == "pizza" then SZ = Vector(13,13,13) end
	if string.lower(string) == "coffee" then SZ = Vector(7,7,2) end
	if string.lower(string) == "cookie" then SZ = Vector(3,3,0) end
	if string.lower(string) == "coke" then SZ = Vector(6,8,2) end
	if string.lower(string) == "bar" then SZ = Vector(25,25,25) end
	if string.lower(string) == "orange" then SZ = Vector(9,9,0) end
	return SZ
end

local MakePanel = function(From,To,ENTMDL,ITM,HT,C,SZ)
	
	local ColorBG1 = Color(64,64,64)
	local ColorBG2 = Color(32,32,32)
	
		            local II = vgui.Create("DPanel")
					II:SetSize(525/6,525/6)
					II:SetBackgroundColor(ColorBG2)
					local	IMI = vgui.Create("DModelPanel",II)
						IMI:SetPos(0,0)
						IMI:SetSize(525/6,525/6)
						IMI:SetModel(ENTMDL)
						IMI:SetFOV(25)
						IMI:SetCamPos(SZ*Vector(2,2,1))
						IMI:SetLookAt(SZ*Vector(0.5,0.5,0.5))
						IMI:SetTooltip(ITM.."\n\n".. HT .. " (tradeable) \n\n Count:" .. C)
						IMI:SetTooltipDelay(0)
					function IMI:LayoutEntity(ent)
						
					end
		return {Main=II,Internal=IMI}
end
local MakePanelRemovable = function(From,ENTMDL,ITM,HT,C,SZ)
	
	local ColorBG1 = Color(64,64,64)
	local ColorBG2 = Color(32,32,32)
		            local II = vgui.Create("DPanel")
					II:SetSize(525/6,525/6)
					II:SetBackgroundColor(ColorBG2)
					local	IMI = vgui.Create("DModelPanel",II)
						IMI:SetPos(0,0)
						IMI:SetSize(525/6,525/6)
						IMI:SetModel(ENTMDL)
						IMI:SetFOV(25)
						IMI:SetCamPos(SZ*Vector(2,2,1))
						IMI:SetLookAt(SZ*Vector(0.5,0.5,0.5))
						IMI:SetTooltip(ITM.."\n\n".. HT .. " (tradeable) \n\n Count:" .. C)
						IMI:SetTooltipDelay(0)
					function IMI:LayoutEntity(ent)
						
					end
					function IMI:DoClick()
						From:RemoveItem(II)	
					end
		return {Main=II,Internal=IMI}
end

local function ConfirmSendItem(Panel,Info)
	local A,B,C,D,E = unpack(Info)
	local Max = tonumber(D,10)
	local ConfPanel=vgui.Create("DFrame")
		ConfPanel:MoveToFront()
		ConfPanel:SetSize(256,128)
		ConfPanel:Center()
		ConfPanel:SetBackgroundBlur(true)
		ConfPanel:SetDraggable(false)
		ConfPanel:ShowCloseButton(false)
		ConfPanel:SetTitle("Amount to set")
		ConfPanel:MakePopup()
	local Amount = vgui.Create("DTextEntry",ConfPanel)
		Amount:SetNumeric(true)
		Amount:SetEnterAllowed(false)
		Amount:SetPos((256-196)/2,32)
		Amount:SetSize(196,32)
		Amount:SetContentAlignment(5)
		Amount:SetText(0)
		function Amount:OnChange()
			if Amount:GetInt() > Max then
			Amount:SetText(Max)	
			end
		end
	local SetAmount = vgui.Create("DButton",ConfPanel)
		SetAmount:Dock(BOTTOM)		
		SetAmount:SetSize(32,24)
		SetAmount:SetText("Ok")
		
	function SetAmount:DoClick()
			local Cn = Amount:GetInt()
			local SET2 = MakePanelRemovable(Panel,A,B,C,Cn,E)
			Panel:AddItem(SET2.Main)
		ConfPanel:Close()
	end

end

msitems.OpenTradePanel = function()
	
	local ColorBG1 = Color(64,64,64)
	local ColorBG2 = Color(32,32,32)
	
	local Main = vgui.Create("DFrame")
	Main:SetPos((ScrW()/2)-600,ScrH()-650)
	Main:SetSize(1200,600)
	Main:SetTitle("Trading Prototype")
	Main:MakePopup()
		
		local You = vgui.Create("DLabel",Main)
		You:SetPos(5,25)
		You:SetSize(300,20)
		You:SetText("You (".. LocalPlayer():Nick() ..")")
		
		local TradeWith = vgui.Create("DComboBox" , Main)
		TradeWith:SetPos(1200-300,25)
		TradeWith:SetSize(300,20)
		TradeWith:SetValue( "No Player" )
		for k,v in pairs(player.GetAll()) do
			TradeWith:AddChoice(v:Nick())
		end
		TradeWith.OnSelect = function( self, index, value )
			TradePartner = player.GetAll()[index]
		end
	
		local Inventory1 = vgui.Create("DPanel",Main)
		  Inventory1:SetSize(550,500/2)
		  Inventory1:SetPos(5,45)
		  Inventory1:SetBackgroundColor(ColorBG1)
		  
		local Inventory2 = vgui.Create("DPanel",Main)
		  Inventory2:SetSize(550,500/2)
		  Inventory2:SetPos(1200-550,45)
		  Inventory2:SetBackgroundColor(ColorBG1)
		  	
		local TradePanel1 = vgui.Create("DPanel",Main)
		  TradePanel1:SetSize(550,500/2)
		  TradePanel1:SetPos(5,300)  
		  TradePanel1:SetBackgroundColor(ColorBG1)
		 
		local TradePanel2 = vgui.Create("DPanel",Main)
		  TradePanel2:SetSize(550,500/2)
		  TradePanel2:SetPos(1200-550,300)  
		  TradePanel2:SetBackgroundColor(ColorBG1)
		  
		local Items1 = vgui.Create("DGrid",Inventory1)
		Items1:SetPos(5,5)
		Items1:SetCols(6)
		Items1:SetColWide(550/6)
		Items1:SetRowHeight(550/6)
		
		local Items1Send = vgui.Create("DGrid",TradePanel1)
		Items1Send:SetPos(5,5)
		Items1Send:SetCols(6)
		Items1Send:SetColWide(550/6)
		Items1Send:SetRowHeight(550/6)

	local 	INV = LocalPlayer():GetInventory()
		for k,v in pairs(INV) do 
			if v.untradable == false then
				local Item = v.data.inventory.name
				local HoverText = v.data.inventory.info
				local Count = v.count
				local ModelRef = string.split(Item," ")[#string.split(Item," ")]
				local ModelStr = lookup(ModelRef)
				local ModelSZ  = lookupSZ(ModelRef)
				local Packed   = {ModelStr,Item,HoverText,Count,ModelSZ}
				local SET=MakePanel(Items1,Items1Send,ModelStr,Item,HoverText,Count,ModelSZ)
				function SET.Internal:DoClick()
					    ConfirmSendItem(Items1Send,Packed)
				end	
				
				
				Items1:AddItem(SET.Main)
			end
	end
	
	local ConfirmClientside = vgui.Create("DButton",Main)
	ConfirmClientside:SetPos(5,600-45)
	ConfirmClientside:SetSize(240,40)
	ConfirmClientside:SetText("")
	function ConfirmClientside:Paint(BH,BW)
		
			surface.SetDrawColor(0,0,0,128)
			surface.DrawRect(0,0,BH,BW)
		if ConfirmClientside:IsHovered() then
			surface.SetDrawColor(0,255,0,64)	
			surface.DrawRect(0,0,BH,BW)
		end
			draw.DrawText("Confirm Trade",
				"hdrdemotext",
				BH/2, 
				BW/4, 
				Color( 255, 255, 255, 52 ), 
				TEXT_ALIGN_CENTER )
		
	end
	
	local AbortClientside = vgui.Create("DButton",Main)
	AbortClientside:SetPos(550-235,600-45)
	AbortClientside:SetSize(240,40)
	AbortClientside:SetText("")
	function AbortClientside:Paint(BH,BW)
		
			surface.SetDrawColor(0,0,0,128)
			surface.DrawRect(0,0,BH,BW)
		if AbortClientside:IsHovered() then
			surface.SetDrawColor(255,0,0,64)	
			surface.DrawRect(0,0,BH,BW)
		end
			draw.DrawText("Abort",
				"hdrdemotext",
				BH/2, 
				BW/4, 
				Color( 255, 255, 255, 52 ), 
				TEXT_ALIGN_CENTER )
		
	end
	
	
		  
end

msitems.OpenTradePanel()
