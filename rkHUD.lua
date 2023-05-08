local CurCoins = function()
local OreCashCoal = (ms.Ores.GetPlayerOre(LocalPlayer(),0)*5)
			local OreCashBrz = (ms.Ores.GetPlayerOre(LocalPlayer(),1)*25)
			local OreCashSlv = (ms.Ores.GetPlayerOre(LocalPlayer(),2)*75)
			local OreCashGold = (ms.Ores.GetPlayerOre(LocalPlayer(),3)*300)
			local OreCashPlat = (ms.Ores.GetPlayerOre(LocalPlayer(),4)*500)
			return (OreCashCoal+OreCashBrz+OreCashSlv+OreCashGold+OreCashPlat)*ms.Ores.GetPlayerMultiplier(LocalPlayer())	
end

local   miningStats = function()
	local ret = {}
	
	for k, v in pairs(ms.Ores.__PStats) do
		ret[v.VarName] = LocalPlayer():GetNWInt(ms.Ores._nwPickaxePrefix .. v.VarName, 0)
	end
	
	return ret
end
-- credits to Empy for scavenging serverside code that i cant really inspect to find out how to get this
local 	function getOreDetails(ent)
			local EntM = ent:GetModel()
			local EntR = ent:GetRarity()+1
			
			local N    = {5,25,75,300,500}
			local OType = {"Coal   +","Copper   +","Silver   +","Gold   +","Platinum   +"}
			
			local Mult    = ms.Ores.GetPlayerMultiplier(LocalPlayer())
			
			local Cashout = 0
			local MFC =	miningStats()["MagicFindChance"]/50
			local FCC =	miningStats()["FineCutChance"]/50
			local BCH =	miningStats()["BonusChance"]/50
			
			if not N[EntR] then N[EntR] = 0 else
				-- this is litterally the only way it can parse in time, haaugh
				if EntM == "models/props_wasteland/rockgranite02a.mdl"      then Cashout = N[EntR]*(7+(FCC*3)) elseif
				EntM == "models/props_wasteland/rockgranite02c.mdl" 		then Cashout = N[EntR]*(7+(FCC*3)) elseif
				EntM == "models/props_debris/concrete_spawnchunk001f.mdl"   then Cashout = N[EntR]*(3+(FCC)) elseif
				EntM == "models/props_debris/concrete_chunk07a.mdl" 		then Cashout = N[EntR]*(3+(FCC)) elseif
				EntM == "models/props_wasteland/rockgranite03a.mdl" 		then Cashout = N[EntR]*(3+(FCC)) elseif
				EntM == "models/props_wasteland/rockgranite03b.mdl"         then Cashout = N[EntR]*(3+(FCC)) elseif
				EntM == "models/props_debris/concrete_spawnchunk001i.mdl"   then Cashout = N[EntR]*1 elseif
				EntM == "models/props_debris/concrete_spawnchunk001j.mdl"   then Cashout = N[EntR]*1 elseif
				EntM == "models/props_debris/concrete_spawnchunk001k.mdl"   then Cashout = N[EntR]*1 elseif
				EntM == "models/props_debris/concrete_chunk03a.mdl" 		then Cashout = N[EntR]*1 elseif
				EntM == "models/props_junk/rock001a.mdl"					then Cashout = N[EntR]*1 else
				Cashout = 0 end
			end
				local CashoutEstimate = Cashout*(1+BCH) + (MFC*N[math.min(5,EntR+1)]*(1+BCH))
				
				if not OType[EntR] then return "??? - ???Pts (+???)" else
				return OType[EntR] .. math.Round(Cashout*Mult) .. "Pts (+" .. math.round(CashoutEstimate-Cashout) ..")" 
				end
      end

function rkHUD()
	
	surface.CreateFont("RKHUD_FONT",{font="Tahoma",size=25,weight=500,outline=true})
	local SetFont = "RKHUD_FONT"
	local FontName = "Tahoma"
	local FontSZ  = 25
	local MinDist = 1200
	if not hooks.HUDPaint.rkHUD_Displays then	
	chat.AddText("Hud started.")

	CreateClientConVar(
		"rkHUD_font",
		"Tahoma",
		true,
		true,
		"The font used by the rkHUD.",
		nil,
		nil
		)
	
	CreateClientConVar(
		"rkHUD_fontSize",
		20,
		true,
		true,
		"The fontsize used by the rkHUD.",
		1,
		30
	)
	cvars.AddChangeCallback("rkHUD_font",
		function(CVAR,OVAL,NVAL) 
				FontName=NVAL
				surface.CreateFont("RKHUD_FONT",{font=FontName,size=FontSZ,weight=500,outline=true})
				if NVAL then SetFont="RKHUD_FONT" end end,
			"nil")
	
	
	cvars.AddChangeCallback("rkHUD_fontSize",
		function(CVAR,OVAL,NVAL)
				FontSZ = tonumber(NVAL)
				surface.CreateFont("RKHUD_FONT",{font=FontName,size=FontSZ,weight=500,outline=true})
				if NVAL then SetFont="RKHUD_FONT" end end,
			"nil")


	
	hook.Add("HUDPaint","rkHUD_Displays",function()
		for _,rk in pairs(ents.FindInSphere(LocalPlayer():GetPos(),MinDist)) do
			if (rk:GetPos():Distance(LocalPlayer():GetShootPos())<MinDist) and rk:GetClass()=="mining_rock" then 
				local SZ     = rk:BoundingRadius()
				local TexPos = rk:GetPos():ToScreen()
				local DD     = (1-(rk:GetPos():Distance(LocalPlayer():GetShootPos())/MinDist))*2
				local MColors= {Color(64,64,64),Color(255,128,0),Color(255,255,255),Color(255,196,0),Color(196,196,255)}
				
				if not MColors[rk:GetRarity()+1] then MColors[rk:GetRarity()+1] = Color(255,255,255) end
				
				CantSee = util.TraceLine({
					start = LocalPlayer():GetShootPos(),
					endpos = rk:GetPos(),
					filter = {LocalPlayer(),rk},
					mask   = MASK_SOLID,
					collisiongroup = COLLISION_GROUP_NONE,
					ignoreworld = false,
					nil
				}).Hit
				
				
				if TexPos.visible and CantSee == false then
					TX = getOreDetails(rk)
					surface.SetFont(SetFont)
					local MX,MY = surface.GetTextSize( TX )
					surface.SetTextColor(ColorAlpha(MColors[rk:GetRarity()+1],math.min(1,DD)*255))
					surface.SetTextPos(TexPos.x-MX/2,TexPos.y-MY/2)
					surface.DrawText(TX)
				end
			end
			if (rk:GetPos():Distance(LocalPlayer():GetShootPos())<MinDist) and rk:GetClass()=="mining_xen_crystal" then
				local SZ     = rk:BoundingRadius()
				local TexPos = rk:GetPos():ToScreen()
				local DD     = (1-(rk:GetPos():Distance(LocalPlayer():GetShootPos())/MinDist))*2
				local MColor = Color(255,0,0)
				local ParseAddition = "+" .. math.round(CurCoins()*0.125) .."Pts"
				
				CantSee = util.TraceLine({
					start = LocalPlayer():GetShootPos(),
					endpos = rk:GetPos(),
					filter = {LocalPlayer(),rk},
					mask   = MASK_SOLID,
					collisiongroup = COLLISION_GROUP_NONE,
					ignoreworld = false,
					nil
				}).Hit
				
				
				if TexPos.visible and CantSee == false then
					surface.SetFont(SetFont)
					local MX,MY = surface.GetTextSize( ParseAddition )
					surface.SetTextColor(ColorAlpha(MColor,math.min(1,DD)*255))
					surface.SetTextPos(TexPos.x-MX/2,TexPos.y-MY/2)
					surface.DrawText( ParseAddition )
				end
			end	
		end
	end)
    else
		hook.Remove("HUDPaint","rkHUD_Displays")
		chat.AddText("Hud closed.")
		concommand.Remove("rkHUD_font")
		concommand.Remove("rkHUD_fontSize")
	end
end
