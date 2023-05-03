--@name MMORPG_SF
--@author Searah
--@model models/beer/wiremod/gate_e2.mdl
local HP = 100
local DontRechargeTime = 0
local LevelInput = 1

-- this is sf code yoinking protection, ill comment this out

--[[
if owner():getSteamID64()!= "76561198196422794" then 
  error("youre not the original author.",1)
end

]]--

timer.create("levelMGR_MMORPG",1,0,function()
    if CLIENT then
            if player() == owner() then
                --print("reading file.")
                if file.exists("MMORPG.txt") then                       -- works
                    LevelInput = file.read("MMORPG.txt")      -- works
                    net.start("rplz_sendvar")
                        net.writeString(LevelInput)
                        --print("WRITE 0x0001,"..LevelInput)
                    net.send(nil,false)
               end                                                         -- works
        end
    end       
end)

-- this reads from a clientside file on what my "level is"
 net.receive("rplz_sendvar",function()
    N = tonumber(net.readString())
    HP = 100+(N*50)
end)


timer.create("alivecheck",1,0,function()
   if SERVER and owner():getMaxHealth()!= HP and owner():isAlive() then    
      owner():setHealth(HP)
   end
   if SERVER and owner():isAlive() then
      owner():setMaxHealth(HP) 
   end
end)


timer.create("rechargeArmor",1,0,function()
    
    if DontRechargeTime==0 and owner():getHealth()<owner():getMaxHealth() then
        if SERVER and hasPermission("entities.setHealth",nil) then
        owner():setHealth(math.min(owner():getMaxHealth(),owner():getHealth()+3))
        end
    end
    if DontRechargeTime!=0 then    
        DontRechargeTime=DontRechargeTime-1    
    end
    DontRechargeTime=math.max(0,DontRechargeTime)
end)

if CLIENT then
    
    
   timer.create("ramdisplay",1,0,function()
    setName("MMORPG Starfall Chip \n(RAM:  " .. string.niceSize(math.floor(ramUsed())).."/"..string.niceSize(ramMax()) .. " )")    
end)

end


if SERVER then
  hook.add("EntityTakeDamage","Damagereduction",function(Targ,Attk,Inf,Dmg,Type,Pos,F)
    if Targ == owner() and hasPermission("entities.setHealth",nil) then
        DontRechargeTime=10
        owner():setHealth(math.min(owner():getMaxHealth(),owner():getHealth()+ ( Dmg * 0.5 )))    -- reduce damage taken by 50%
    end
  end)
  --hook.remove("EntityTakeDamage","Damagereduction")
end
