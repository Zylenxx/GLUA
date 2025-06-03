
function PrintFrame(IN,depth,maxdepth)
	local Contents = vgui.Create("DFrame")
	Contents:Center()
	Contents:SetSize(1000,500)
	Contents:SetTitle("Contents")
	Contents:MakePopup()
	local Tree = vgui.Create("DTree",Contents)
	Tree:Dock(FILL)
	local Lenmax = maxdepth or 1
	local function DoNodePopulate(From,IN,depth,maxdepth)
		for k,v in pairs(IN) do
			if Lenmax > 0 then
				local Bulletin = From:AddNode(k  ..":" .. tostring(v))
				if istable(v) then Bulletin:SetIcon("icon16/application_view_list.png") end
				if type(v)=="string" then Bulletin:SetIcon("icon16/font.png") end
				if IsColor(v) then Bulletin:SetIcon("icon16/color_wheel.png") end
				if type(v)=="function" then Bulletin:SetIcon("icon16/cog_go.png") end
				if type(v)=="number" then Bulletin:SetIcon("icon16/calendar_view_day.png") end
				if type(v)=="userdata" then Bulletin:SetIcon("icon16/database_gear.png") end
				if type(v)=="boolean" then Bulletin:SetIcon("icon16/contrast_high.png") end
				if type(v)=="nil" then Bulletin:SetIcon("icon16/cross.png") end -- should not happen
				
				function Bulletin:OnNodeSelected(panel)
					
					
				end
				if type(v) == "table" then
					 depth=depth+1
					 Lenmax=Lenmax-1
					 DoNodePopulate(Bulletin,v,depth,maxdepth)
				end
			end
		end
	end
	DoNodePopulate(Tree,IN,depth,maxdepth)
end
