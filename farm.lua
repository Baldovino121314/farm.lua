-- PARTE 1/6
-- Candy Farm Isaias v69
local P=game:GetService("Players").LocalPlayer local PLS=game:GetService("Players")
local TS=game:GetService("TweenService") local VU=game:GetService("VirtualUser")
local UIS=game:GetService("UserInputService") local WS=game:GetService("Workspace")
local cam=WS.CurrentCamera local pg=P:WaitForChild("PlayerGui")
local farm,ug,afk,aimOn,esp,resetOn,aura,grabG=false,false,false,false,true,true,false,false
local speed,total,roundC,got=20,0,0,0
local auraR,fov=20,170
local t0,ugA,busy,mini=os.clock(),false,false,false
local rAt,cont,gdC,gdT,est=0,nil,nil,0,"-"
local skip,cL,cAt={},{},0 local ROT=CFrame.Angles(math.rad(90),0,0)
local sg,sbtn,main,lbl,body,hid={}
local AC=Color3.fromRGB(255,170,50) local GR=Color3.fromRGB(38,92,58) local BG=Color3.fromRGB(26,26,33)
local function cc()
  if cont and cont.Parent then return cont end
  cont=WS:FindFirstChild("CoinContainer",true) return cont
end
local function gd()
  if gdC and gdC.Parent then return gdC end
  if os.clock()-gdT<2 then return gdC end
  gdT=os.clock() gdC=WS:FindFirstChild("GunDrop",true) return gdC
end
local function av()
  local c=P.Character local h=c and c:FindFirstChildOfClass("Humanoid")
  return h~=nil and h.Health>0
end
local function dr()
  if not resetOn or os.clock()-rAt<3 then return end
  rAt=os.clock() local c=P.Character if not c then return end
  got=0 roundC=0 skip={} cL={} cAt=0 est="reiniciando"
  local h=c:FindFirstChildOfClass("Humanoid")
  if h then h.PlatformStand=false pcall(function() h.Health=0 end) end
  pcall(function() c:BreakJoints() end)
  local n=0
  while P.Character==c and n<6 do task.wait(0.1) n=n+0.1 end
  if P.Character then pcall(function() P.Character:WaitForChild("HumanoidRootPart",5) end) task.wait(0.4) end
  ugA=false est="esperando ronda"
end-- PARTE 2/6
local function cn()
  if os.clock()-cAt<0.25 then return cL end
  cAt=os.clock() local t,c={},cc()
  if c then
    for _,m in ipairs(c:GetChildren()) do
      local p
      if m:IsA("BasePart") then p=m
      elseif m:IsA("Model") then p=m:FindFirstChild("Coin_Server") or m.PrimaryPart or m:FindFirstChildWhichIsA("BasePart") end
      if p and m:GetAttribute("Collected")~=true then t[#t+1]=p end
    end
  end
  cL=t return t
end
local function nr()
  local c=P.Character local hrp=c and c:FindFirstChild("HumanoidRootPart")
  if not hrp then return end
  local b,bd
  for _,p in ipairs(cn()) do
    local s=skip[p]
    if not s or os.clock()-s>1.5 then
      local d=(p.Position-hrp.Position).Magnitude
      if not bd or d<bd then b,bd=p,d end
    end
  end
  return b,bd
end
local function ir()
  if not av() then return false end
  local _,d=nr() return d~=nil and d<150
end
local function tc(p)
  local c=P.Character if not c or not p.Parent then return end
  local hrp=c:FindFirstChild("HumanoidRootPart") local hd=c:FindFirstChild("Head")
  if not hrp then return end
  pcall(function()
    firetouchinterest(hrp,p,0) firetouchinterest(hrp,p,1)
    if hd then firetouchinterest(hd,p,0) firetouchinterest(hd,p,1) end
  end)
end
local function gb(p)
  for _=1,4 do
    tc(p) if p:GetAttribute("Collected")==true then break end
    task.wait(0.05)
  end
  if p:GetAttribute("Collected")==true or p.Parent==nil then got=got+1 end
  skip[p]=os.clock() if resetOn and got>=50 then dr() end
end
local function um(on)
  if on==ugA then return end
  ugA=on local c=P.Character if not c then return end
  local h=c:FindFirstChildOfClass("Humanoid") if h then h.PlatformStand=on end
  for _,v in ipairs(c:GetDescendants()) do
    if v:IsA("BasePart") then v.CanCollide=not on end
  end
end
local function gl(dest,rot,dur)
  local c=P.Character local hrp=c and c:FindFirstChild("HumanoidRootPart")
  if not hrp then return false end
  local d=(dest-hrp.Position).Magnitude if d<0.5 then return true end
  if not dur then dur=math.clamp(d/speed,0.12,2.5) end
  local ti=TS:Create(hrp,TweenInfo.new(dur,Enum.EasingStyle.Linear),{CFrame=CFrame.new(dest)*(rot or ROT)})
  ti:Play() ti.Completed:Wait()
  if hrp.Parent then hrp.AssemblyLinearVelocity=Vector3.zero hrp.AssemblyAngularVelocity=Vector3.zero end
  return true
end
local function gt(pos) gl(pos+Vector3.new(0,3,0),CFrame.new().Rotation) end
local function fl()
  while farm do
    if not ir() then est="esperando ronda" um(false) task.wait(0.4)
    else
      local p=nr()
      if not p then est="sin caramelos" cAt=0 skip={} task.wait(0.05)
      elseif ug then
        est="underground" um(true)
        gl(Vector3.new(p.Position.X,p.Position.Y-4,p.Position.Z)) gb(p)
      else est="moviendo" um(false) gt(p.Position) gb(p) end
    end
  end
  est="-" um(false)
end-- PARTE 3/6
local function mu()
  for _,pl in ipairs(PLS:GetPlayers()) do
    if pl~=P and pl.Character and kn(pl) then return pl end
  end
end
local function gu()
  local c=P.Character local b=P:FindFirstChild("Backpack")
  return (c and c:FindFirstChild("Gun")) or (b and b:FindFirstChild("Gun"))
end
local function eqp(g,h)
  local c=P.Character local hrp=c and c:FindFirstChild("HumanoidRootPart")
  if not hrp then return end
  if g.Parent~=c then pcall(function() h:EquipTool(g) end) end
  local t=0
  while g.Parent~=c and t<1.5 do task.wait(0.05) t=t+0.05 end
  if g.Parent~=c then print("NO EQUIPA") return end
  local t2=0
  while not hrp:FindFirstChild("GunRaycastAttachment") and t2<1 do task.wait(0.02) t2=t2+0.02 end
  return hrp:FindFirstChild("GunRaycastAttachment")
end
local function shoot()
  if busy then return end
  busy=true
  pcall(function()
    local m=mu() if not m then print("SIN MURDER") return end
    local g=gu() if not g then print("SIN PISTOLA") return end
    local c=P.Character local h=c and c:FindFirstChildOfClass("Humanoid")
    local mc=m.Character local tp=mc and (mc:FindFirstChild("HumanoidRootPart") or mc:FindFirstChild("Head"))
    if not h or not tp then print("SIN CUERPO") return end
    local at=eqp(g,h) if not at then return end
    local sh=g:FindFirstChild("Shoot") if not sh then print("SIN REMOTO") return end
    task.wait(0.1)
    for _=1,3 do
      local pos=tp.Position+Vector3.new(0,0.5,0)+tp.AssemblyLinearVelocity*0.12
      pcall(function() sh:FireServer(at.WorldCFrame,CFrame.new(pos)) end)
      task.wait(0.15)
    end
    task.wait(0.1) pcall(function() h:UnequipTools() end)
  end)
  busy=false
end
local function kn(pl)
  local c=pl.Character local b=pl:FindFirstChild("Backpack")
  return (c and c:FindFirstChild("Knife"))~=nil or (b and b:FindFirstChild("Knife"))~=nil
end
local function km()
  local c=P.Character local h=c and c:FindFirstChildOfClass("Humanoid")
  if not c or not h then return end
  local k=c:FindFirstChild("Knife") if k then return k end
  local b=P:FindFirstChild("Backpack") local kb=b and b:FindFirstChild("Knife")
  if kb then
    pcall(function() h:EquipTool(kb) end) task.wait(0.05)
    if kb.Parent==c then return kb end
  end
end
local function ka()
  if not av() then return end
  local k=km() if not k then return end
  local hd=k:FindFirstChild("Handle")
  local c=P.Character local hrp=c and c:FindFirstChild("HumanoidRootPart")
  if not hd or not hrp then return end
  for _,pl in ipairs(PLS:GetPlayers()) do
    if pl~=P and pl.Character then
      local th=pl.Character:FindFirstChild("HumanoidRootPart")
      local hh=pl.Character:FindFirstChildOfClass("Humanoid")
      if th and hh and hh.Health>0 and (th.Position-hrp.Position).Magnitude<=auraR then
        pcall(function() k:Activate() end)
        pcall(function() firetouchinterest(th,hd,0) firetouchinterest(th,hd,1) end)
      end
    end
  end
end
local function fv(pl)
  local c=pl.Character local hd=c and (c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart"))
  if not hd then return false end
  local sp,on=cam:WorldToViewportPoint(hd.Position) if not on then return false end
  local vp=cam.ViewportSize
  return (Vector2.new(sp.X,sp.Y)-Vector2.new(vp.X/2,vp.Y/2)).Magnitude<=fov
end
local function atg()
  local b,bd
  for _,pl in ipairs(PLS:GetPlayers()) do
    if pl~=P and pl.Character and kn(pl) and fv(pl) then
      local c=P.Character local hrp=c and c:FindFirstChild("HumanoidRootPart")
      local th=pl.Character:FindFirstChild("HumanoidRootPart")
      if hrp and th then
        local d=(th.Position-hrp.Position).Magnitude
        if not bd or d<bd then b,bd=pl,d end
      end
    end
  end
  return b
end
local function aimShot()
  if busy then return end
  busy=true
  pcall(function()
    local m=atg() if not m then print("FUERA DE FOV") return end
    local g=gu() if not g then print("SIN PISTOLA") return end
    local c=P.Character local h=c and c:FindFirstChildOfClass("Humanoid")
    local mc=m.Character local mh=mc and mc:FindFirstChild("Head")
    local mhp=mc and mc:FindFirstChild("HumanoidRootPart")
    if not h or not mh or not mhp then return end
    local at=eqp(g,h) if not at then return end
    local sh=g:FindFirstChild("Shoot") if not sh then print("SIN REMOTO") return end
    task.wait(0.08)
    local pos=mh.Position+mhp.AssemblyLinearVelocity*0.12
    if sh:IsA("RemoteFunction") then pcall(function() sh:InvokeServer(1,pos,"AH2") end)
    else pcall(function() sh:FireServer(at.WorldCFrame,CFrame.new(pos)) end) end
    task.wait(0.12) pcall(function() h:UnequipTools() end)
  end)
  busy=false
end
local function gg()
  if busy then return end
  local g=gd() if not g or not g:IsA("BasePart") then return end
  local c=P.Character local hrp=c and c:FindFirstChild("HumanoidRootPart")
  if not hrp or (g.Position-hrp.Position).Magnitude>130 then return end
  busy=true local keep=hrp.CFrame
  hrp.CFrame=CFrame.new(g.Position+Vector3.new(0,1.5,0)) hrp.AssemblyLinearVelocity=Vector3.zero
  task.wait(0.06) pcall(function() firetouchinterest(hrp,g,0) firetouchinterest(hrp,g,1) end)
  task.wait(0.18)
  if hrp.Parent then hrp.CFrame=keep hrp.AssemblyLinearVelocity=Vector3.zero end
  busy=false
end-- PARTE 4/6
sg=Instance.new("ScreenGui") sg.Name="CandyFarmIsaias" sg.ResetOnSpawn=false sg.IgnoreGuiInset=true sg.Parent=pg
local function co(o,r) local u=Instance.new("UICorner") u.CornerRadius=UDim.new(0,r) u.Parent=o end
main=Instance.new("Frame") main.Size=UDim2.fromOffset(236,430) main.Position=UDim2.fromOffset(10,60)
main.BackgroundColor3=Color3.fromRGB(16,16,21) main.BorderSizePixel=0 main.Parent=sg co(main,12)
local stk=Instance.new("UIStroke") stk.Color=AC stk.Thickness=1.2 stk.Transparency=0.4 stk.Parent=main
local head=Instance.new("Frame") head.Size=UDim2.new(1,0,0,38) head.BackgroundColor3=Color3.fromRGB(24,20,14)
head.BorderSizePixel=0 head.Parent=main co(head,12)
local hf=Instance.new("Frame") hf.Size=UDim2.new(1,0,0,12) hf.Position=UDim2.new(0,0,1,-12)
hf.BackgroundColor3=Color3.fromRGB(24,20,14) hf.BorderSizePixel=0 hf.Parent=head
local ttl=Instance.new("TextLabel") ttl.Size=UDim2.new(1,-70,0,38) ttl.Position=UDim2.fromOffset(12,0)
ttl.BackgroundTransparency=1 ttl.Font=Enum.Font.GothamBold ttl.TextSize=14 ttl.TextColor3=AC
ttl.TextXAlignment=Enum.TextXAlignment.Left ttl.Text="CANDY FARM ISAIAS" ttl.Parent=head
local dot=Instance.new("Frame") dot.Size=UDim2.fromOffset(8,8) dot.Position=UDim2.fromOffset(6,15)
dot.BackgroundColor3=AC dot.BorderSizePixel=0 dot.Parent=head co(dot,99)
local minb=Instance.new("TextButton") minb.Size=UDim2.fromOffset(18,18) minb.Position=UDim2.new(1,-26,0,10)
minb.BackgroundColor3=Color3.fromRGB(44,38,28) minb.TextColor3=AC minb.TextSize=12 minb.Text="-" minb.Parent=head co(minb,6)
lbl=Instance.new("TextLabel") lbl.Size=UDim2.new(1,-20,0,44) lbl.Position=UDim2.fromOffset(10,46)
lbl.BackgroundColor3=Color3.fromRGB(20,24,21) lbl.Font=Enum.Font.Gotham
lbl.TextSize=11 lbl.TextColor3=Color3.fromRGB(150,200,170) lbl.TextXAlignment=Enum.TextXAlignment.Left
lbl.TextYAlignment=Enum.TextYAlignment.Center lbl.Text="  00:00:00  |  Ronda 0  |  Total 0\n  estado: -" lbl.Parent=main co(lbl,8)
body=Instance.new("ScrollingFrame") body.Size=UDim2.new(1,-20,1,-140) body.Position=UDim2.fromOffset(10,96)
body.BackgroundTransparency=1 body.BorderSizePixel=0 body.ScrollBarThickness=3
body.ScrollBarImageColor3=AC body.AutomaticCanvasSize=Enum.AutomaticSize.Y body.Parent=main
local lay=Instance.new("UIListLayout") lay.Padding=UDim.new(0,4) lay.Parent=body
local function mk(k,txt,ord)
  local o
  if k=="s" then
    o=Instance.new("TextLabel") o.Size=UDim2.new(1,0,0,16) o.BackgroundTransparency=1
    o.Font=Enum.Font.GothamBold o.TextSize=10 o.TextColor3=AC o.TextXAlignment=Enum.TextXAlignment.Left o.Text="  "..txt
  elseif k=="r" then
    o=Instance.new("Frame") o.Size=UDim2.new(1,0,0,30) o.BackgroundColor3=BG co(o,7)
    local l=Instance.new("TextLabel") l.Size=UDim2.new(1,-52,1,0) l.Position=UDim2.fromOffset(10,0)
    l.BackgroundTransparency=1 l.Font=Enum.Font.GothamMedium l.TextSize=11
    l.TextColor3=Color3.fromRGB(215,215,225) l.TextXAlignment=Enum.TextXAlignment.Left l.Text=txt l.Parent=o
    local sw=Instance.new("Frame") sw.Size=UDim2.fromOffset(34,18) sw.Position=UDim2.new(1,-44,0.5,-9)
    sw.BackgroundColor3=Color3.fromRGB(48,48,58) sw.BorderSizePixel=0 sw.Parent=o co(sw,99)
    local kn=Instance.new("Frame") kn.Size=UDim2.fromOffset(14,14) kn.Position=UDim2.fromOffset(2,2)
    kn.BackgroundColor3=Color3.fromRGB(200,200,210) kn.BorderSizePixel=0 kn.Parent=sw co(kn,99)
    local hit=Instance.new("TextButton") hit.Size=UDim2.new(1,0,1,0) hit.BackgroundTransparency=1
    hit.Text="" hit.AutoButtonColor=false hit.Parent=o
    o.LayoutOrder=ord o.Parent=body
    return {sw=sw,kn=kn,hit=hit,o=o}
  else
    o=Instance.new("TextLabel") o.Size=UDim2.new(1,0,0,14) o.BackgroundTransparency=1
    o.Font=Enum.Font.Gotham o.TextSize=11 o.TextColor3=Color3.fromRGB(150,150,160) o.TextXAlignment=Enum.TextXAlignment.Left o.Text=txt
  end
  o.LayoutOrder=ord o.Parent=body
  return o
end-- PARTE 5/6
local function tog(t,txt,get,set)
  local function up()
    t.sw.BackgroundColor3=get() and GR or Color3.fromRGB(48,48,58)
    t.kn.Position=get() and UDim2.new(1,-16,0,2) or UDim2.fromOffset(2,2)
  end
  t.hit.MouseButton1Click:Connect(function() set(not get()) up() end) up()
end
local function sld(txt,val,mn,mx,set)
  local l=mk("l",txt..": "..val,0) hid[#hid+1]=l
  local bar=Instance.new("Frame") bar.Size=UDim2.new(1,0,0,12) bar.BackgroundColor3=BG bar.Parent=body co(bar,6) hid[#hid+1]=bar
  local fi=Instance.new("Frame") fi.Size=UDim2.new((val-mn)/(mx-mn),0,1,0) fi.BackgroundColor3=AC fi.BorderSizePixel=0 fi.Parent=bar co(fi,6)
  local hit=Instance.new("TextButton") hit.Size=UDim2.new(1,0,1,0) hit.BackgroundTransparency=1 hit.Text="" hit.Parent=bar
  local dr2=false
  local function mv(x)
    local a=math.clamp((x-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
    fi.Size=UDim2.new(a,0,1,0)
    local v=math.floor(mn+a*(mx-mn)) set(v) l.Text=txt..": "..v
  end
  hit.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then dr2=true mv(i.Position.X) end end)
  UIS.InputChanged:Connect(function(i) if dr2 and i.UserInputType==Enum.UserInputType.Touch then mv(i.Position.X) end end)
  UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then dr2=false end end)
end
mk("s","FARM",1)
local bF=mk("r","AUTO FARM",2) hid[#hid+1]=bF.o
tog(bF,"AUTO FARM",function() return farm end,function(v)
  farm=v bF.o.BackgroundColor3=v and GR or BG
  if v then task.spawn(fl) end
end)
local bU=mk("r","UNDERGROUND",3) hid[#hid+1]=bU.o
tog(bU,"UNDERGROUND",function() return ug end,function(v) ug=v bU.o.BackgroundColor3=v and GR or BG end)
mk("s","RECOGIDA",4)
sld("Velocidad",speed,5,60,function(v) speed=v end)
mk("s","BOLSA",5)
local bR=mk("r","AUTO RESET 50",6) hid[#hid+1]=bR.o
tog(bR,"AUTO RESET",function() return resetOn end,function(v) resetOn=v bR.o.BackgroundColor3=v and GR or BG end)
mk("s","COMBATE",7)
local bK=mk("r","KILL AURA",8) hid[#hid+1]=bK.o
tog(bK,"KILL AURA",function() return aura end,function(v) aura=v bK.o.BackgroundColor3=v and GR or BG end)
sld("Rango aura",auraR,10,40,function(v) auraR=v end)
local bA=mk("r","SILENT AIM",9) hid[#hid+1]=bA.o
tog(bA,"SILENT AIM",function() return aimOn end,function(v) aimOn=v bA.o.BackgroundColor3=v and GR or BG end)
sld("FOV aim",fov,40,400,function(v) fov=v end)
local bG=mk("r","AUTO PISTOLA",10) hid[#hid+1]=bG.o
tog(bG,"AUTO PISTOLA",function() return grabG end,function(v) grabG=v bG.o.BackgroundColor3=v and GR or BG end)
mk("s","VARIOS",11)
local bE=mk("r","ESP ROLES",12) hid[#hid+1]=bE.o
tog(bE,"ESP ROLES",function() return esp end,function(v) esp=v bE.o.BackgroundColor3=v and GR or BG end)
local bAf=mk("r","ANTI AFK",13) hid[#hid+1]=bAf.o
tog(bAf,"ANTI AFK",function() return afk end,function(v) afk=v bAf.o.BackgroundColor3=v and GR or BG end)
local dg,dsp,dp0=false,nil,nil
ttl.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then dg=true dsp=i.Position dp0=main.Position end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then dg=false end end)
UIS.InputChanged:Connect(function(i)
  if not dg or i.UserInputType~=Enum.UserInputType.Touch then return end
  local d=i.Position-dsp
  main.Position=UDim2.new(dp0.X.Scale,dp0.X.Offset+d.X,dp0.Y.Scale,dp0.Y.Offset+d.Y)
end)
minb.MouseButton1Click:Connect(function()
  mini=not mini minb.Text=mini and "+" or "-"
  lbl.Visible=not mini body.Visible=not mini
  main.Size=mini and UDim2.fromOffset(236,38) or UDim2.fromOffset(236,430)
end)-- PARTE 6/6
local s2=Instance.new("ScreenGui") s2.Name="CFShoot" s2.ResetOnSpawn=false s2.IgnoreGuiInset=true s2.DisplayOrder=1000 s2.Parent=pg
sbtn=Instance.new("TextButton") sbtn.Size=UDim2.fromOffset(78,78) sbtn.Position=UDim2.new(1,-98,1,-118)
sbtn.BackgroundColor3=Color3.fromRGB(176,52,52) sbtn.TextColor3=Color3.new(1,1,1)
sbtn.Font=Enum.Font.GothamBold sbtn.TextSize=12 sbtn.Text="SHOOT" sbtn.Parent=s2
Instance.new("UICorner",sbtn).CornerRadius=UDim.new(1,0)
local act,dsp2,sp0,drag=false,nil,nil,false
sbtn.InputBegan:Connect(function(i)
  if act or (i.UserInputType~=Enum.UserInputType.Touch and i.UserInputType~=Enum.UserInputType.MouseButton1) then return end
  act=i dsp2=i.Position sp0=sbtn.Position drag=false
end)
UIS.InputChanged:Connect(function(i)
  if i~=act then return end
  local d=i.Position-dsp2
  if math.abs(d.X)>8 or math.abs(d.Y)>8 then drag=true end
  if drag then sbtn.Position=UDim2.new(sp0.X.Scale,sp0.X.Offset+d.X,sp0.Y.Scale,sp0.Y.Offset+d.Y) end
end)
sbtn.InputEnded:Connect(function(i)
  if i~=act then return end
  act=nil
  if not drag then if aimOn then aimShot() else shoot() end end
end)
P.Idled:Connect(function() if not afk then return end VU:CaptureController() VU:ClickButton2(Vector2.new()) end)
P.CharacterAdded:Connect(function() roundC=0 got=0 cL={} skip={} ugA=false end)
task.spawn(function()
  while sg.Parent do
    if aura then pcall(ka) end
    if grabG then pcall(gg) end
    task.wait(0.15)
  end
end)
task.spawn(function()
  while sg.Parent do
    for _,pl in ipairs(PLS:GetPlayers()) do
      if pl~=P and pl.Character then
        local hd=pl.Character:FindFirstChild("Head")
        if hd then
          local bb=hd:FindFirstChild("CFEsp")
          if esp then
            if not bb then
              bb=Instance.new("BillboardGui") bb.Name="CFEsp" bb.Size=UDim2.new(0,60,0,16)
              bb.StudsOffset=Vector3.new(0,1.4,0) bb.AlwaysOnTop=true bb.MaxDistance=2500 bb.Parent=hd
              local tx=Instance.new("TextLabel") tx.Size=UDim2.new(1,0,1,0) tx.BackgroundTransparency=1 tx.TextScaled=true
              tx.Font=Enum.Font.GothamBold tx.Parent=bb
              if kn(pl) then tx.Text="MURDER" tx.TextColor3=Color3.fromRGB(255,80,80)
              elseif pl:FindFirstChild("Backpack") and pl.Backpack:FindFirstChild("Gun") then tx.Text="SHERIFF" tx.TextColor3=Color3.fromRGB(90,170,255)
              else tx.Text="INOCENTE" tx.TextColor3=Color3.fromRGB(120,255,140) end
            end
          elseif bb then bb:Destroy() end
        end
      end
    end
    local g=gd()
    if g and g:IsA("BasePart") and not g:FindFirstChild("CFTag") then
      local bb=Instance.new("BillboardGui") bb.Name="CFTag" bb.Size=UDim2.new(0,70,0,16)
      bb.StudsOffset=Vector3.new(0,1.5,0) bb.AlwaysOnTop=true bb.MaxDistance=2500 bb.Parent=g
      local tx=Instance.new("TextLabel") tx.Size=UDim2.new(1,0,1,0) tx.BackgroundTransparency=1 tx.TextScaled=true
      tx.Text="pistola" tx.TextColor3=Color3.fromRGB(180,220,255) tx.Font=Enum.Font.GothamBold tx.Parent=bb
    end
    task.wait(0.4)
  end
end)
task.spawn(function()
  while sg.Parent do
    local s=os.clock()-t0
    lbl.Text="  "..string.format("%02d:%02d:%02d",math.floor(s/3600),math.floor(s%3600/60),math.floor(s%60))
      .."  |  Ronda "..roundC.."  |  Total "..total.."\n  estado: "..est
    task.wait(0.3)
  end
end)
print("Candy Farm Isaias v69 listo")
