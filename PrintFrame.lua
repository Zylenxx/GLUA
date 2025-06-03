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
				local Bulletin = From:AddNode(string.rep(" ",depth) .. k  ..":" .. tostring(v))	
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
