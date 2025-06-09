function Opera(StartURL)
   local OPERA=vgui.Create("DFrame")
    OPERA.Tabs=1
    OPERA.TabTable={}
    OPERA:SetSize(1280,720)	
    OPERA:SetSizable(true)
    OPERA:SetTitle("")
    OPERA:SetSkin("dark_meta")
    OPERA:MakePopup()
       local ICO    =vgui.Create("RichText",OPERA)
       ICO:SetPos(2,2)
       ICO:SetSize(24,24)
       ICO:SetVerticalScrollbarEnabled(false)
       ICO:AppendText("O")
       function ICO:PerformLayout()
       	   if (self:GetFont() != "Trebuchet24") then self:SetFontInternal("Trebuchet24") end
       	   self:SetFGColor(Color(196,32,32))
       end
       
	   local MAIN_OP=vgui.Create("DPropertySheet",OPERA)
	   MAIN_OP:Dock(FILL)
	   MAIN_OP:DockMargin(0,0,0,0)
	   local ClTabBut = vgui.Create("DButton",MAIN_OP)
		       ClTabBut:SetPos(0,0)
		       ClTabBut:SetSize(15,15)
		       ClTabBut:SetText("x")
		       ClTabBut:SetZPos(290)
		       ClTabBut:SetDrawBackground(false)
		       
	  local ADTabBut = vgui.Create("DButton",OPERA)
		       ADTabBut:SetPos(OPERA:GetWide()-20,35)
		       ADTabBut:SetSize(15,15)
		       ADTabBut:SetText("+")
		       ADTabBut:SetZPos(291)
	   local function MakeTab(URL,Name)
		   local HTMLP    =vgui.Create("DPanel",MAIN_OP)
		   HTMLP:Dock(FILL)
		   HTMLP:SetDrawBackground(false)
			   local ReloadT=vgui.Create("DButton",HTMLP)
					ReloadT:SetContentAlignment(7)
				    ReloadT:SetIcon("icon16/arrow_rotate_anticlockwise.png")
				    ReloadT:SetText("")
				    ReloadT:SetSize(25,25)
			   local AdressB=vgui.Create("DTextEntry",HTMLP)
					AdressB:Dock(TOP)
					AdressB:DockMargin(25,0,0,0)
			   local StartPage=vgui.Create("DHTML",HTMLP)
			   StartPage:Dock(FILL)
			   StartPage:OpenURL(URL)
			   StartPage:SetScrollbars(false)
			   function StartPage:OnChildViewCreated(sourceURL,targetURL,isPopup )
			   	   local ParsedTabName = targetURL:gsub("^https?://", ""):match("^[^/:]+")
			   	   MakeTab(targetURL,ParsedTabName)
			   end
			   function StartPage:OnDocumentReady(DOC)
				StartPage.URL = DOC
			   end
			   function AdressB:OnEnter(Astr)
			   	   StartPage:OpenURL(Astr)
			   end
			   function ReloadT:DoClick()
			   	   StartPage:OpenURL(StartPage.URL)
			   end
			   
		   local TB = MAIN_OP:AddSheet(Name,HTMLP,"icon16/bullet_blue.png")
		   function TB.Tab:Paint(w,h)
		   	local RND = 4
			   	if MAIN_OP:GetActiveTab()==TB.Tab then
			   	   draw.RoundedBox(RND,0,0,w,h*0.75,Color(96,96,96))
			   	else
			   	   draw.RoundedBox(RND,0,0,w,h*0.75,Color(32,32,32))
			   	end
			end
			function TB.Tab:PaintOver(w,h)
			local MAT = Material("vgui/gradient-r","noclamp smooth")
		   	local RND = 4
			   	if MAIN_OP:GetActiveTab()==TB.Tab then
			   	   surface.SetMaterial(MAT)
			   	   surface.SetDrawColor(Color(96,96,96))
			   	   surface.DrawTexturedRect(w-45,0,40,h*0.75)
				   surface.DrawTexturedRect(w-45,0,40,h*0.75)
		   		else
		   		   surface.SetMaterial(MAT)
			   	   surface.SetDrawColor(Color(32,32,32))
			   	   surface.DrawTexturedRect(w-45,0,40,h*0.75)
				   surface.DrawTexturedRect(w-45,0,40,h*0.75)
			   	end
			end
			function TB.Tab:Think()
				local Px,Py = TB.Tab:GetPos()
				local Pxs,Pys = TB.Tab:GetSize()
				if (TB.Tab:IsHovered() or ClTabBut:IsHovered()) then
				   ClTabBut:SetPos(Px+Pxs-10,Py+2)
				   function ClTabBut:DoClick()
		         	MAIN_OP:CloseTab(TB.Tab,true)
		    	    end
				else
				   function ClTabBut:DoClick()
	    	       end
			       ClTabBut:SetPos(-9999,9999) -- easy offscreen hack
				end
			end
		   	   function StartPage:OnChangeTitle(SPT)
					TB.Tab:SetText(SPT)
					TB.Tab:InvalidateLayout( false )
		   end
	  end
	  if not StartURL then
	     MakeTab("https://start.pprmint.de/","start")
      else
  	     MakeTab(StartURL,"-------------------------")
  	  end
	  
  	function ADTabBut:DoClick()
		MakeTab("https://start.pprmint.de/","start")
	end

 return OPERA
end

 -- CONTEXT MENU STUFF
 if OperaCTX then OperaCTX:Remove() end
 OperaCTX = g_ContextMenu:GetChildren()[3]:Add("DButton")
 OperaCTX:SetSize(80,80)
 OperaCTX:SetDrawBackground(false)
 OperaCTX:SetText("")
 function OperaCTX:Paint(w,h)
 	local M = Material("icon16/world.png", "noclamp")
    surface.SetMaterial(M)
    surface.DrawTexturedRect(5,5,w-10,h-10)
    surface.SetFont("CloseCaption_Bold")
    local TSX,TSY = surface.GetTextSize("Opera")
    surface.SetTextPos(5,TSY)
    surface.SetTextColor(194,42,42)
    surface.DrawText("Opera")
 end
 function OperaCTX:DoClick()
 Opera()	
 end
