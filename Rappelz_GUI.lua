--[[
    RAPPELZ GUI MOD 
    Author: Zylenxx 

   This is a UI mod for GMOD based on the MMORPG "Rappelz".
   Modifiable components: 

   (currently none.)

]]--


--[[

			NET RECEIVER HACKS TO MAKE HOOKS DOABLE FROM HERE

]]--

net.Receive("PlayerKilledByPlayer", function()
	local message = net
	local victim = message:ReadEntity()
	local inflictor = message:ReadString()
	local attacker = message:ReadEntity()

	if not IsValid(attacker) then
		return
	end
	if not IsValid(victim) then
		return
	end

	local ret = hook.Run("DeathNotice", attacker, nil, victim)
	if ret == false then return end

	local xtra = {attacker = attacker, victim = victim}

	GAMEMODE:AddDeathNotice(attacker:Name(), attacker:Team(), inflictor, victim:Name(), victim:Team(), xtra)

	hook.Run("PlayerKilledByPlayer", attacker, inflictor, victim) -- hack-in for use in the script
end)


--[[
		ACTUAL CODE FROM HERE ON OUT
]]--





 -- modify what is required here.
 RAPPELZGUI = {}
 
	-- the icon that should show.
	RAPPELZGUI.Icon = "https://cdn.discordapp.com/attachments/453272722513068033/1099725400411746316/aegis.png"
	
	-- the class type that should show.
	RAPPELZGUI.Class= "Aegis"
 
 


 -- exp levels from lvl 2 to 200
local Rappelz_LevelsEXP = {75,100,125,150,175,200,225,250,275,1300,1325,1350,1375,
1400,1425,1450,1475,1500,1525,2550,2575,2600,2625,2650,2675,
2700,2725,2750,2775,3800,3825,3850,3875,3900,3925,3950,3975,
4000,4025,5050,5075,5100,5125,5150,5175,5200,5225,5250,5275,
11300,11325,11350,11375,11400,11425,11450,11475,11500,11525,
13550,13575,13600,13625,13650,13675,13700,13725,13750,13775,
15800,15825,15850,15875,15900,15925,15950,15975,16000,16025,
18050,18075,18100,18125,18150,18175,18200,18225,18250,18275,
20300,20325,20350,20375,20400,20425,20450,20475,20500,20525,
32550,32575,32600,32625,32650,32675,32700,32725,32750,32775,
35800,35825,35850,35875,35900,35925,35950,35975,36000,36025,
39050,39075,39100,39125,39150,39175,39200,39225,39250,39275,
42300,42325,42350,42375,42400,42425,42450,42475,42500,42525,
45550,45575,45600,45625,45650,45675,45700,45725,45750,45775,
63800,63825,63850,63875,63900,63925,63950,63975,64000,64025,
68050,68075,68100,68125,68150,68175,68200,68225,68250,68275,
72300,72325,72350,72375,72400,72425,72450,72475,72500,72525,
76550,76575,76600,76625,76650,76675,76700,76725,76750,76775,
80800,80825,80850,80875,80900,80925,80950,80975,81000,81025}

	file.Write("sf_filedata/MMORPG.txt",tonumber(LocalPlayer():GetPData("RAPPELZ_GUI_LVL",1)))

    -- preclean if youve ran while ui was still up.
     for n,pnl in pairs(vgui.GetWorldPanel():GetChildren()) do 
     	if string.StartWith( string.lower(pnl:GetName()), "rappelz") 
     		then pnl:Remove() 
 		end 
 	end
    hook.Remove( "HUDPaint","MMORPG_HPBARS_OTHERS")


function Calc_EXP_LVL_Progress()
	local CurEXP = tonumber(LocalPlayer():GetPData("RAPPELZ_GUI_EXP",0))
	local CurLVL = tonumber(LocalPlayer():GetPData("RAPPELZ_GUI_LVL",1))
	if CurEXP>Rappelz_LevelsEXP[CurLVL] then
		local OverEXP = CurEXP-Rappelz_LevelsEXP[CurLVL]
		UpdatePDATA(3,OverEXP)
		UpdatePDATA(2,CurLVL+1)
		file.Write("sf_filedata/MMORPG.txt",CurLVL+1)
	else
		file.Write("sf_filedata/MMORPG.txt",CurLVL)
	end
end


-- FUNC GUI_DATA INIT : Calculates all PDATA defaults.
function ResetPDATA()
   -- session name
   LocalPlayer():SetPData("RAPPELZ_GUI_NAME",LocalPlayer():Name())
   -- session level
   LocalPlayer():SetPData("RAPPELZ_GUI_LVL",1)
   -- session exp
   LocalPlayer():SetPData("RAPPELZ_GUI_EXP",0)
end


-- FUNC GUI_DATA UPDATE : Updates PDATA. Preferably called before disconnecting or removing the UI.
function UpdatePDATA(Type,Key) 
	if Type and Key then
			if Type == 1 then	
				LocalPlayer():SetPData("RAPPELZ_GUI_NAME",Key)
			end
			if Type == 2 then	
				LocalPlayer():SetPData("RAPPELZ_GUI_LVL",Key)
			end
			if Type == 3 then	
				LocalPlayer():SetPData("RAPPELZ_GUI_EXP",Key)
			end
	end
end

function rappelzGUI()
	
	concommand.Add("RGUI_Recalc",function() Calc_EXP_LVL_Progress() end,nil,"Recalculates the RappelzGUI exp and name.")
	concommand.Add("RGUI_ClassName",function(p,s,t,strg) RAPPELZGUI.Class = t[1] end,nil,"Sets the classname shown in the RappelzGUI.")
	local Name  = LocalPlayer():GetPData("RAPPELZ_GUI_NAME","unknown") 
	local Level = LocalPlayer():GetPData("RAPPELZ_GUI_LVL",1)
    local EXP   = math.floor(LocalPlayer():GetPData("RAPPELZ_GUI_EXP",0))
    ArmorAMT    = 100+tonumber(Level*50)
    LevelEXPMax = 12800
	-- Top left character panel.
	CharacterUI = vgui.Create("DPanel",nil,"Rappelz_Characterui")
    CharacterUI:SetSize(247,108)
		-- ui image 1
    	UI1 = vgui.Create("DHTML",CharacterUI)
    	UI1:Dock(FILL)
		UI1:OpenURL("https://cdn.discordapp.com/attachments/453272722513068033/1098682268106637422/UI_CHARACTER.png")
		
		
		-- level display
		CHRUI_LEVEL = vgui.Create("DLabel",nil,"Rappelz_Characterui_NameElement")
		CHRUI_LEVEL:SetSize(40,16)
		CHRUI_LEVEL:SetPos(9,10)
		CHRUI_LEVEL:SetContentAlignment(5)
		CHRUI_LEVEL:SetText(Level)
		CHRUI_LEVEL:SetFontInternal("GmodToolScreen20")
		
		
		
		
		
		-- name display
		CHRUI_NAME = vgui.Create("DLabel",nil,"Rappelz_Characterui_NameElement2")
		CHRUI_NAME:SetSize(247-40,16)
		CHRUI_NAME:SetPos(9+20,10)
		CHRUI_NAME:SetContentAlignment(5)
		CHRUI_NAME:SetText(Name)
		CHRUI_NAME:SetFontInternal("GmodToolScreen20")
		
		
		
		
		-- healthbar
		CHRUI_HPBar = vgui.Create("DProgress",nil,"RAPPELZ_HPBAR")
		CHRUI_HPBar:SetSize(247-16,12)
		CHRUI_HPBar:SetPos(9,63)
		CHRUI_HPBar:SetFraction(math.min(LocalPlayer():Health()/LocalPlayer():GetMaxHealth(),1))
		CHRUI_HPBar:SetVisible(true)
		CHRUI_HPBar.Interpolate = CHRUI_HPBar:GetFraction()
			function CHRUI_HPBar:Paint(w,h)
	    		--BG
	    	    draw.RoundedBox(1,0,0,w,h,Color(64,64,64,255))
	    	    draw.RoundedBox(1,0,h/2,w,h/2,Color(128,128,128,128))
	    	    
	    	    --FG 1	
	    		draw.RoundedBox(1,0,0,self.Interpolate*w,h/2,Color(79,239,41,64))
	    		draw.RoundedBox(1,0,h/2,self.Interpolate*w,h/2,Color(43,186,23,64))
	    	    
	    	    --FG 2	
	    		draw.RoundedBox(1,0,0,(self:GetFraction() or 0)*w,h,Color(79,239,41,255))
	    		draw.RoundedBox(1,0,0,(self:GetFraction() or 0)*w,h/2,Color(43,186,23,255))
    	    end
		CHRUI_HPTXT = vgui.Create("DLabel",CHRUI_HPBar,"RAPPELZ_HPBAR_txt")
		CHRUI_HPTXT:Dock(FILL)
		CHRUI_HPTXT:SetContentAlignment(6)
		CHRUI_HPTXT:SetText(LocalPlayer():Health() .."/".. LocalPlayer():GetMaxHealth())
		CHRUI_HPTXT:SetFontInternal("targetid")
		CHRUI_HPTXT:SetVisible(true)
		
		
		
		-- armor bar
		CHRUI_ARBar = vgui.Create("DProgress",nil,"RAPPELZ_ARBAR")
		CHRUI_ARBar:SetSize(247-16,12)
		CHRUI_ARBar:SetPos(9,77)
		CHRUI_ARBar:SetFraction(math.min(LocalPlayer():Armor()/ArmorAMT,1))
		CHRUI_ARBar:SetVisible(true)
		CHRUI_ARBar.Interpolate = CHRUI_ARBar:GetFraction()
			function CHRUI_ARBar:Paint(w,h)
	    		--BG
	    	    draw.RoundedBox(1,0,0,w,h,Color(64,64,64,255))
	    	    draw.RoundedBox(1,0,h/2,w,h/2,Color(128,128,128,128))
	    	    
	    	    --FG 1	
	    		draw.RoundedBox(1,0,0,self.Interpolate*w,h/2,Color(11,147,215,64))
	    		draw.RoundedBox(1,0,h/2,self.Interpolate*w,h/2,Color(43,191,255,64))
	    	    
	    	    --FG 2	
	    		draw.RoundedBox(1,0,0,(self:GetFraction() or 0)*w,h,Color(11,147,215,255))
	    		draw.RoundedBox(1,0,0,(self:GetFraction() or 0)*w,h/2,Color(43,191,255,255))
	    	end
	   
		CHRUI_ARTXT = vgui.Create("DLabel",CHRUI_ARBar,"RAPPELZ_ARBAR_txt")
		CHRUI_ARTXT:Dock(FILL)
		CHRUI_ARTXT:SetContentAlignment(6)
		CHRUI_ARTXT:SetText( math.min(LocalPlayer():Armor()) .."/".. ArmorAMT)
		CHRUI_ARTXT:SetFontInternal("targetid")
		CHRUI_ARTXT:SetVisible(true)
		
		
		
		
		--EXP bar
		CHRUI_EXPBar = vgui.Create("DProgress",nil,"RAPPELZ_EXPBAR")
		CHRUI_EXPBar:SetSize(231,7)
		CHRUI_EXPBar:SetPos(9,95)
		CHRUI_EXPBar:SetFraction(LocalPlayer():GetPData("RAPPELZ_GUI_EXP",0)/LevelEXPMax,1)
		CHRUI_EXPBar:SetVisible(true)
			function CHRUI_EXPBar:Paint(w,h)
	    		--BG
	    	    draw.RoundedBox(1,0,0,w,h,Color(64,64,64,255))
	    	    draw.RoundedBox(1,0,h/2,w,h/2,Color(128,128,128,128))
	    	    --FG 2	
	    		draw.RoundedBox(1,0,0,(self:GetFraction() or 0)*w,h,Color(198,114,0,255))
	    		draw.RoundedBox(1,0,0,(self:GetFraction() or 0)*w,h/2,Color(253,154,19,255))
	    	end
		
		-- Character information : type, EXP
		CHRUI_CHTYPE = vgui.Create("DHTML",UI1,"RAPPELZ_CHARACTERTYPE_ICON")
		CHRUI_CHTYPE:SetSize(18,30)
		CHRUI_CHTYPE:SetPos(12,30)
		CHRUI_CHTYPE:OpenURL(RAPPELZGUI.Icon)
		
		CHRUI_CHRINFO = vgui.Create("DPanel",UI1,"RAPPELZ_CHARACTER_INFO")
		CHRUI_CHRINFO:SetSize(202,22)
		CHRUI_CHRINFO:SetPos(38,34)
		CHRUI_CHRINFO:SetBackgroundColor(Color(32,32,32))
			
			TXTSub1 = vgui.Create("DLabel",CHRUI_CHRINFO,"RAPPELZ_CHARACTER_TYPE")
			TXTSub1:SetContentAlignment(4)
			TXTSub1:SetSize(202,22)
			TXTSub1:SetFontInternal("TargetID")
			TXTSub1:SetText(RAPPELZGUI.Class)
			
			TXTSub2 = vgui.Create("DLabel",CHRUI_CHRINFO,"RAPPELZ_CHARACTER_EXP")
			TXTSub2:SetSize(150,22)
			TXTSub2:SetContentAlignment(6)
			TXTSub2:SetFontInternal("TargetID")
			TXTSub2:SetText("EXP:")
			
			TXTSub3 = vgui.Create("DLabel",CHRUI_CHRINFO,"RAPPELZ_CHARACTER_EXP2")
			TXTSub3:SetContentAlignment(6)
			TXTSub3:SetSize(202,22)
			TXTSub3:SetFontInternal("TargetID")
			TXTSub3:SetText(math.floor(LocalPlayer():GetPData("RAPPELZ_GUI_EXP",0)))
				
	hook.Add("Think","RAPPELZ_GUI_UPDATE",function()
		if LocalPlayer():GetMaxHealth() == 100 then
			ArmorAMT    = 100
			else
			ArmorAMT    = 100+tonumber(LocalPlayer():GetPData("RAPPELZ_GUI_LVL",1)*50)
		end
		LevelEXPMax = Rappelz_LevelsEXP[tonumber(LocalPlayer():GetPData("RAPPELZ_GUI_LVL",1))]
		
	if tonumber(LocalPlayer():GetPData("RAPPELZ_GUI_EXP",0)) > Rappelz_LevelsEXP[tonumber(LocalPlayer():GetPData("RAPPELZ_GUI_LVL",1))] then	
		Calc_EXP_LVL_Progress()
	end
		
	if CHRUI_HPBar:Valid() then
		CHRUI_HPBar.Interpolate = math.max(CHRUI_HPBar.Interpolate-0.002,CHRUI_HPBar:GetFraction())
		CHRUI_HPBar:SetFraction(math.min(LocalPlayer():Health()/LocalPlayer():GetMaxHealth(),1))
        CHRUI_HPTXT:SetText(LocalPlayer():Health() .."/".. LocalPlayer():GetMaxHealth())
	end
	
	if CHRUI_ARBar:Valid() then
		CHRUI_ARBar.Interpolate = math.max(CHRUI_ARBar.Interpolate-0.002,CHRUI_ARBar:GetFraction())
		CHRUI_ARBar:SetFraction(math.min(LocalPlayer():Armor()/ArmorAMT,1))
        CHRUI_ARTXT:SetText( math.min(LocalPlayer():Armor()) .."/".. ArmorAMT)
	end
	
	if CHRUI_CHRINFO:Valid() then
		TXTSub3:SetText(math.floor(LocalPlayer():GetPData("RAPPELZ_GUI_EXP",0)))
		CHRUI_EXPBar:SetFraction(math.floor(LocalPlayer():GetPData("RAPPELZ_GUI_EXP",0))/LevelEXPMax,1)
	end
	
	if CHRUI_LEVEL:Valid() then
	   CHRUI_LEVEL:SetText(LocalPlayer():GetPData("RAPPELZ_GUI_LVL",1))	
	end
	
end)
	hook.Add("PlayerKilledByPlayer","RAPPELZ_EXPSYSTEMPART1",function(attacker,inflictor,victim)
		
		if victim == LocalPlayer() then
			local Loss = 20 -- loss in pts
			
			if EXP-Loss<0 then
				local Underflow = EXP-Loss+Rappelz_LevelsEXP[math.max(1,Level-1)]
				UpdatePDATA(3,Underflow)
				UpdatePDATA(2,math.max(1,Level-1))
			else
				UpdatePDATA(3,math.floor(math.max(0,tonumber(LocalPlayer():GetPData("RAPPELZ_GUI_EXP",0))-Loss))) -- subtract % from exp
			end
		end
		
		if attacker == LocalPlayer() then
			local Gain = 0.1 -- gain of exp in exp/h
			local PH   = victim:GetMaxHealth()
			UpdatePDATA(3,math.floor(tonumber(LocalPlayer():GetPData("RAPPELZ_GUI_EXP",0)+ (PH*Gain) ))) -- add 10% of hp as exp.
		end
		
		
		
		
		Calc_EXP_LVL_Progress() -- calculate new exp and level if required.
		
	end)
	
	hook.Add("entity_killed","RAPPELZ_EXPSYSTEMPART2",function(data)
		local Atk  = Entity(data.entindex_attacker)
		local Vic  = Entity(data.entindex_killed)
		local VicHP = 0
		local Loss = 10 -- loss in pts
		if Vic:IsValid() then
			VicHP  = (Vic:GetMaxHealth())
		end
		if Vic and Atk then
			if Vic == LocalPlayer() and Atk:IsNPC() then
				if EXP-Loss<0 then
					local Underflow = EXP-Loss+Rappelz_LevelsEXP[math.max(1,Level-1)]
					UpdatePDATA(3,Underflow)
					UpdatePDATA(2,math.max(1,Level-1))
				else
					UpdatePDATA(3,math.floor(math.max(0,tonumber(LocalPlayer():GetPData("RAPPELZ_GUI_EXP",0))-Loss))) -- subtract % from exp
				end
			end
			if Atk == LocalPlayer() and Vic:IsNPC() then
		     	local Gain = 0.1 -- gain of exp in exp/h
				local PH   = Vic:GetMaxHealth()
				UpdatePDATA(3,math.floor(tonumber(LocalPlayer():GetPData("RAPPELZ_GUI_EXP",0)+ (PH*Gain) ))) -- add 10% of hp as exp.
		    end
		end	
	end)
	
	
	hook.Add( "HUDPaint","MMORPG_HPBARS_OTHERS",function()
		local TBL = player.GetAll()
		local TBL2 = ents.FindByClass("*npc*")
		for n,PLY in pairs(TBL) do
			if PLY ~= LocalPlayer() then
				local DistScale = (PLY:GetShootPos()-LocalPlayer():GetShootPos()):Length()
				local DistFade  = math.min(255,math.max(0,2048-DistScale*4))
				local ToScreen = (PLY:GetShootPos()+Vector(0,0,10)):ToScreen()
				local HP1      = PLY:Health()
				local HP2      = PLY:GetMaxHealth()
				local PNL      = {}
				      PNL.x	   = math.min(110,110/DistScale*200)
				      PNL.y    = math.min(10,10/DistScale*200)
				local FracHP   = math.min(1,HP1/HP2)
				      
				 draw.RoundedBoxEx( 0,
				 	ToScreen.x-(PNL.x/2), ToScreen.y,
				 	PNL.x, PNL.y,
				 	Color(0,125,0,DistFade),
				 	false,
				 	false,
				 	false,
				 	false )
				 draw.RoundedBoxEx( 0,
				 	ToScreen.x-(PNL.x/2), ToScreen.y,
				 	PNL.x*FracHP, PNL.y,
				 	Color(0,255,0,DistFade),
				 	false,
				 	false,
				 	false,
				 	false )
			end
		end
		for n,NPC in pairs(TBL2) do
				local DistScale = (NPC:GetPos()-LocalPlayer():GetPos()):Length()
				local DistFade  = math.min(255,math.max(0,2048-DistScale*4))
				local SZ1,SZ2   = NPC:GetModelBounds()
				local ToScreen = (NPC:GetPos()+Vector(0,0,SZ2.z+5)):ToScreen()
				local HP1      = NPC:Health()
				local HP2      = NPC:GetMaxHealth()
				local PNL      = {}
				      PNL.x	   = math.min(110,110/DistScale*200)
				      PNL.y    = math.min(10,10/DistScale*200)
			    local FracHP   = math.min(1,HP1/100)
			    local getNameNPC = string.gsub(string.gsub(string.gsub(NPC:GetClass(),"_"," "),"npc",""),"lua","")
			    local FormatNameNPC = string.gsub(getNameNPC,"(%l)(%w*)", function(a,b) return string.upper(a)..b end)
			    if getNameNPC == " " then FormatNameNPC = "Generic NPC" end
			    local NPCTEXT = {
			    	text = FormatNameNPC,
			    	font = "DermaLarge",
			    	pos = {ToScreen.x, ToScreen.y-20},
			    	color = Color(196,128,128,math.min(255,math.max(0,196-DistScale)*10)),
			    	xalign = TEXT_ALIGN_CENTER,
			    	yalign = TEXT_ALIGN_CENTER
			    }	
			    
				if HP2~=0 then
						FracHP   = math.min(1,HP1/HP2)
				end
				 draw.RoundedBoxEx( 0,
				 	ToScreen.x-(PNL.x/2), ToScreen.y,
				 	PNL.x, PNL.y,
				 	Color(125,0,0,DistFade),
				 	false,
				 	false,
				 	false,
				 	false )
				 draw.RoundedBoxEx( 0,
				 	ToScreen.x-(PNL.x/2), ToScreen.y,
				 	PNL.x*FracHP, PNL.y,
				 	Color(255,0,0,DistFade),
				 	false,
				 	false,
				 	false,
				 	false )
				 
				 draw.Text(NPCTEXT)
				 
				end
		end)
	
	
end



 

function closeRappelzGUI()
	concommand.Remove("RGUI_Recalc")
	concommand.Remove("RGUI_ClassName")
	CharacterUI:Remove()
	CHRUI_LEVEL:Remove()
	CHRUI_NAME:Remove()
	CHRUI_HPBar:Remove()
	CHRUI_ARBar:Remove()
	CHRUI_EXPBar:Remove()
	hook.Remove("Think","RAPPELZ_GUI_UPDATE")
	hook.Remove("PlayerKilledByPlayer","RAPPELZ_EXPSYSTEMPART1")
	hook.Remove("entity_killed","RAPPELZ_EXPSYSTEMPART2")
	hook.Remove( "HUDPaint","MMORPG_HPBARS_OTHERS")
end
