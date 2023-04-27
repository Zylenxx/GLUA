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

	hook.Run("PlayerKilledByPlayer", attacker, inflictor, victim)
end)


--[[
		ACTUAL CODE FROM HERE ON OUT
]]--

local Rappelz_LevelsEXP = {6, 15, 32, 72, 160, 320, 540, 885, 1332,
	1723, 2754, 3906, 5472, 7266, 9310, 11550,
	14335, 17664, 21000, 31042, 36784, 42465, 48925,
	56000, 64009, 72625, 81606, 91728, 102564, 138580,
	153825, 169818, 186559, 205238, 224536, 245700, 266664,
	289562, 314496, 411840, 444600, 479745, 514885, 552808,
	593640, 634125, 677603, 724200, 770408, 996660, 1061208,
	1125264, 1193998, 1266597, 1339182, 1416250, 1497390, 1578520,
	1664397, 2134826, 2249000, 2366617, 2486356, 2613240, 2742336,
	2875094, 3010800, 3153381, 3303038, 4219400, 4412826, 4610332,
	4817137, 5022888, 5244470, 5465048, 5695488, 5930400, 6169784,
	7872111, 8189110, 8519406, 8848395, 9190901, 9548496, 9903460,
	10273791, 10659909, 11043256, 14079872, 14585548, 15111621, 15646560,
	16191876, 16756980, 17320296, 17916443, 18509227, 19126008, 24386615,
	25181882, 26004100, 26842578, 27707050, 28573125, 29465570, 30388736,
	31311686, 32263932, 41166756, 42418640, 43692834, 44985232, 46316868,
	47671680, 49045340, 50440164, 51875940, 53333532, 67776081, 69333028,
	70896756, 72466905, 74076858, 75693010, 77317668, 78979644, 80647200,
	82319958, 104727456, 106905610, 109089760, 111322768, 113564322, 115810964,
	118068378, 120368200, 122675264, 124989165, 130562927, 137641588, 146560746,
	157467800, 172398688, 192204261, 224046837, 272398022, 358817408, 509063847,
	712689385, 1004892032, 1426946685, 2040533759, 2938368612, 4260634487, 6220526351,
	9144173735, 13533377127, 20164731919, 24197678302, 29279190745, 35720612708, 43936353630,
	54481078501, 68101348126, 85807698638, 108975777270, 139488994905, 179940803427, 251917124797,
	355203145963, 504388467267, 721275508191, 1038636731795, 1506023261102, 2198793961208, 3232227122975,
	4783696142003, 7127707251584, 8553248701900, 10349430929299, 12626305733744, 15530356052505, 19257641505106,
	24072051881382, 30330785370541, 38520097420587, 49305724698351, 63604384860872}

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
function ResetPDATA(Name)
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

function rappelz_gui_open()

	local Name  = LocalPlayer():GetPData("RAPPELZ_GUI_NAME","unknown") 
	local Level = LocalPlayer():GetPData("RAPPELZ_GUI_LVL",1)
    local EXP   = math.floor(LocalPlayer():GetPData("RAPPELZ_GUI_EXP",0))
    ArmorAMT    = 100+tonumber(Level*20)
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
		CHRUI_HPTXT:SetFontInternal("TargetID")
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
		CHRUI_ARTXT:SetFontInternal("TargetID")
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
		CHRUI_CHTYPE:OpenURL("https://cdn.discordapp.com/attachments/453272722513068033/1099725400411746316/aegis.png")
		
		CHRUI_CHRINFO = vgui.Create("DPanel",UI1,"RAPPELZ_CHARACTER_INFO")
		CHRUI_CHRINFO:SetSize(202,22)
		CHRUI_CHRINFO:SetPos(38,34)
		CHRUI_CHRINFO:SetBackgroundColor(Color(32,32,32))
			
			TXTSub1 = vgui.Create("DLabel",CHRUI_CHRINFO,"RAPPELZ_CHARACTER_TYPE")
			TXTSub1:SetContentAlignment(4)
			TXTSub1:SetSize(202,22)
			TXTSub1:SetFontInternal("TargetID")
			TXTSub1:SetText("Aegis")
			
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
		ArmorAMT    = 100+tonumber(LocalPlayer():GetPData("RAPPELZ_GUI_LVL",1)*20)
		LevelEXPMax = Rappelz_LevelsEXP[tonumber(LocalPlayer():GetPData("RAPPELZ_GUI_LVL",1))]
		
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
			local Loss = 0.05 -- loss in dec (1 = 100%)
			UpdatePDATA(3,math.floor(math.max(0,tonumber(LocalPlayer():GetPData("RAPPELZ_GUI_EXP",0))*(1-Loss)))) -- subtract % from exp
		end
		
		if attacker == LocalPlayer() then
			local Gain = 0.1 -- gain of exp in exp/h
			local PH   = victim:GetMaxHealth()
			UpdatePDATA(3,math.floor(tonumber(LocalPlayer():GetPData("RAPPELZ_GUI_EXP",0)+ (PH*Gain) ))) -- add 10% of hp as exp.
		end
		
		Calc_EXP_LVL_Progress() -- calculate new exp and level if required.
		
	end)
	hook.Add( "HUDPaint","MMORPG_HPBARS_OTHERS",function()
		local TBL = player.GetAll()
		local TBL2 = ents.FindByClass("*npc*")
		for n,PLY in pairs(TBL) do
			if PLY ~= LocalPlayer() then
				local DistScale = (PLY:GetShootPos()-LocalPlayer():GetShootPos()):Length()
				local DistFade  = math.min(255,math.max(0,2048-DistScale*4))
				local ToScreen = (PLY:GetShootPos()+Vector(0,0,12)):ToScreen()
				local HP1      = PLY:Health()
				local HP2      = PLY:GetMaxHealth()
				local PNL      = {}
				      PNL.x	   = 110/DistScale*200
				      PNL.y    = 10/DistScale*200
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
				      PNL.x	   = 110/DistScale*200
				      PNL.y    = 10/DistScale*200
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



 

function rappelz_gui_close()
	CharacterUI:Remove()
	CHRUI_LEVEL:Remove()
	CHRUI_NAME:Remove()
	CHRUI_HPBar:Remove()
	CHRUI_ARBar:Remove()
	CHRUI_EXPBar:Remove()
	hook.Remove("Think","RAPPELZ_GUI_UPDATE")
	hook.Remove("PlayerKilledByPlayer","RAPPELZ_EXPSYSTEMPART1")
	hook.Remove( "HUDPaint","MMORPG_HPBARS_OTHERS")
end
