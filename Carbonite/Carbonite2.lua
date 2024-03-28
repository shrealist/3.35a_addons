function Nx.Map.Gui.OP__4()
  local self = Nx.Map.Gui
  if UnitPlayerControlled("target") or not UnitName("target") then
      return
  end
  if #self.PlT > 5 then
      tremove(self.PlT)
  end
  local tag = GameTooltipTextLeft2:GetText() or ""
  local lvl = GameTooltipTextLeft3:GetText() or ""
  local fac1 = GameTooltipTextLeft4:GetText() or ""
  if strfind(tag, "^" .. NXlLEVELSPC) then
      tag = ""
      fac1 = lvl
  end
  local str = format("%s~%s~%s", tag, GameTooltipTextLeft1:GetText() or "", fac1)
  tinsert(self.PlT, 1, str)
end
function Nx.Opt:OLE(evN, sel, va2)
  local pag = Nx.OpD[self.PaS]
  local ite = pag[sel]
  if evN == "select" or evN == "back" then
      if ite then
          if type(ite) == "table" then
              if ite.F then
                  local var = self:GeV(ite.V)
                  Nx.Opt[ite.F](self, ite, var)
              end
              if ite.V then
                  self:EdI(ite)
              end
          end
      end
  elseif evN == "button" then
      if ite then
          if type(ite) == "table" then
              if ite.V then
                  self:SeV(ite.V, va2)
              end
              if ite.VF then
                  local var = self:GeV(ite.V)
                  Nx.Opt[ite.VF](self, ite, var)
              end
          end
      end
  elseif evN == "color" then
      if ite then
          if type(ite) == "table" then
              if ite.VF then
                  Nx.Opt[ite.VF](self, ite)
              end
          end
      end
  end
  self:Upd()
end
function Nx.Win:SBS(w, h)
  self.BoW = w
  self.BoH = h
  self.ToH = self.TiH + h
end
function Nx:RCL()
  local ch = self.CuC
  ch["LTime"] = time()
  ch["LvlTime"] = time()
  ch["LLevel"] = UnitLevel("player")
  ch["Class"] = Nx:GUC()
  ch["LMoney"] = GetMoney()
  ch["LXP"] = UnitXP("player")
  ch["LXPMax"] = UnitXPMax("player")
  ch["LXPRest"] = GetXPExhaustion() or 0
  ch["LArenaPts"] = GetArenaCurrency()
  ch["LHonor"] = GetHonorCurrency()
  Nx.War:GuR()
  Nx:ReC()
end
function Nx.Map.Gui:CNPC(dat)
  local opt = Nx:GGO()
  if not opt["CaptureEnable"] then
      return
  end
  local cap = Nx:GeC()
  local npc1 = Nx:CaF(cap, "NPC")
  local len = 0
  for _, str in pairs(npc1) do
      len = len + 4 + #str + 1
  end
  if len > 5 * 1024 then
      return
  end
  local nam = self.PNPCT
  local faI = UnitFactionGroup("player") == "Horde" and 1 or 0
  npc1[nam] = format("%s^%d^%s", self.PNPCTP, faI, dat)
end
function Nx.Map:STXY(mid, zx, zy, nam, kee)
  Nx.Que.Wat:CAT()
  local wx, wy = self:GWP(mid, zx, zy)
  return self:SeT3("Goto", wx, wy, wx, wy, nil, nil, nam or "", kee, mid)
end
function Nx.Que:OQ__()
  local qc = GetQuestsCompleted()
  local cnt = 0
  for id in pairs(qc) do
      local qSt = Nx:GeQ(id)
      if qSt ~= "C" then
          cnt = cnt + 1
          Nx:SeQ(id, "C", time())
      end
  end
  if cnt > 0 then
      Nx.prt("Set %d quests as done", cnt)
      Nx.Que.Lis:Upd()
  end
end
function Nx.Que:M_OSQ()
  ShowUIPanel(QuestLogFrame)
  self.Lis.Bar:Sel1(1)
  local cur = self.IMC
  self.Lis:Sel1(cur.QId, cur.QI)
end
function Nx.Tra:TCT(des2)
  local tm = 0
  local num = NumTaxiNodes()
  if num > 0 then
      TaxiNodeSetCurrent(des2)
      local rCn = GetNumRoutes(des2)
      for n = 1, rCn do
          local x = TaxiGetSrcX(des2, n)
          local y = TaxiGetSrcY(des2, n)
          local srN1 = self:TFNFRXY(x, y)
          local x = TaxiGetDestX(des2, n)
          local y = TaxiGetDestY(des2, n)
          local deN = self:TFNFRXY(x, y)
          if srN1 and deN then
              local srN = strsplit(",", TaxiNodeName(srN1))
              local deN1 = strsplit(",", TaxiNodeName(deN))
              local t = self:TFCT(srN, deN1)
              local roN = srN .. "#" .. deN1
              if t == 0 then
                  local tt = NxData.NXTravel["TaxiTime"]
                  t = tt[roN]
                  if not t then
                      if NxData.DebugMap then
                          Nx.prt(" No taxi data %s to %s", srN, deN1)
                      end
                      if rCn == 1 then
                          self.TSN = roN
                      end
                      return 0
                  end
              end
              tm = tm + t
              if NxData.DebugMap then
                  Nx.prt(" #%s %s to %s, %s secs", n, srN, deN1, t)
              end
          end
      end
  end
  return tm
end
function Nx.Win:STS(wid, hei, skC)
  self.Frm:SetWidth(wid)
  self.Frm:SetHeight(hei)
  self:Adj(skC)
  self:RLD()
end
function Nx.Que:ULPR(str, loc)
  local cnt
  local ox, oy = Nx.Que:ULPO(str, loc)
  ox = ox - 50
  oy = oy - 50
  for n = 1, GetNumBattlefieldVehicles() do
      local x, y, unN, pos2, typ, dir, pla = GetBattlefieldVehicleInfo(n)
      if x and not pla then
          if typ == Nx.AiT then
              cnt = 1
              dir = dir / PI * 180
              oy = oy / 1.5
              ox, oy = ox * cos(dir) + oy * sin(dir), (ox * -sin(dir) + oy * cos(dir)) * 1.5
              ox = x * 100 + ox
              oy = y * 100 + oy
              break
          end
      end
  end
  if not cnt then
      ox = ox + 62
      oy = oy + 42
  end
  return ox, oy
end
function Nx.Win:AdA()
  if self.Win2 then
      for win in pairs(self.Win2) do
          win:Adj()
      end
  end
end
function Nx.Map:RoQ(poi2)
  local rou = self:Rou(poi2)
  if rou then
      self:RTT(rou, false)
  end
end
function Nx.Com:Enc(msg)
  local s = {}
  s[1] = strsub(msg, 1, 2)
  for n = 3, #msg do
      s[n - 1] = strchar(strbyte(msg, n) - 1)
  end
  return table.concat(s)
end
function Nx:ADE(nam, time, maI, x, y)
  self:AdE("Death", nam, time, maI, x, y)
end
function Nx.Map:GWZS(maI)
  return self.MWI[maI][1]
end
function Nx.Map.Gui:UTI(hiF)
  local Map = Nx.Map
  local map = self.Map
  local maI = map.MaI
  local fol = self:FiF("Travel")
  for shT, fol in ipairs(fol) do
      if fol.MaI == maI and fol.Fac1 ~= hiF then
          local coS2 = Nx.ZoC[fol.CoI1]
          local fla, coT, mI1, x1, y1, mI2, x2, y2, na11, na21 = Nx.Map:CoU(coS2)
          if fol.Co2 then
              mI1, x1, y1, na11 = mI2, x2, y2, na21
          end
          local wx, wy = Map:GWP(mI1, x1, y1)
          local ico = map:AIP("!POI", wx, wy, nil, "Interface\\Icons\\" .. fol.Tx)
          map:SIT(ico, format("%s\n%s %.1f %.1f", na11, Nx.MITN[mI1], x1, y1))
      end
  end
  local win1 = Map.MWI[maI]
  if win1 then
      if win1.Con1 then
          for id, zco1 in pairs(win1.Con1) do
              for n, con in ipairs(zco1) do
                  local wx, wy = con.StX, con.StY
                  local ico = map:AIP("!POI", wx, wy, nil, "Interface\\Icons\\Spell_Nature_FarSight")
                  map:SIT(ico, "Connection to " .. Nx.MITN[con.EMI1])
                  local wx, wy = con.EnX, con.EnY
                  local ico = map:AIP("!POI", wx, wy, nil, "Interface\\Icons\\Spell_Nature_FarSight")
              end
          end
      end
  end
end
function Nx.Que:OpR()
  local qop = Nx:GQO()
  qop.NXShowHeaders = true
  qop.NXSortWatchMode = 1
  qop.NXWAutoMax = nil
  qop.NXWVisMax = 8
  qop.NXWShowOnMap = true
  qop.NXWWatchParty = true
  qop.NXWHideUnfinished = false
  qop.NXWHideGroup = false
  qop.NXWHideNotInZone = false
  qop.NXWHideNotInCont = false
  qop.NXWHideDist = 20000
  qop.NXWPriDist = 1
  qop.NXWPriComplete = 50
  qop.NXWPriLevel = 20
  qop.NXWPriGroup = -100
end
function Nx.AuA:Cre()
end
function Nx.Inf:M_OD1(ite)
  local function fun()
      Nx.Inf:Del1(Nx.Inf.CMI.Ind)
  end
  Nx:ShM("Delete Info Window #" .. self.CMI.Ind .. "?", "Delete", fun, "Cancel")
end
function Nx.Que.Wat:UpL1()
  local Nx = Nx
  local Que = Nx.Que
  local Map = Nx.Map
  local qop = Nx:GQO()
  local hiU = qop["NXWHideUnfinished"]
  local hiG = qop["NXWHideGroup"]
  local hNIZ = qop["NXWHideNotInZone"]
  local hNIC = qop["NXWHideNotInCont"]
  local hiD = qop["NXWHideDist"] >= 19900 and 99999 or qop["NXWHideDist"]
  local hiD = hiD / 4.575
  local prD1 = qop.NXWPriDist
  local gop = self.GOp
  local fiS2 = gop["QWFixedSize"]
  local shD = gop["QWShowDist"]
  local sPC = gop["QWShowPerColor"]
  local hDO = gop["QWHideDoneObj"]
  local coC1 = Nx.U_25(gop["QWCompleteColor"])
  local inC2 = Nx.U_25(gop["QWIncompleteColor"])
  local oCC = Nx.U_25(gop["QWOCompleteColor"])
  local oIC = Nx.U_25(gop["QWOIncompleteColor"])
  local lis = self.Lis
  local old1, old2 = lis:GeS2()
  lis:SBGC(Nx.U_23(gop["QWBGColor"]))
  lis:Emp()
  local wat = wipe(self.Wat1)
  local cur1 = Que.CuQ
  if cur1 then
      for n, cur in ipairs(cur1) do
          local qId = cur.QId
          local id = qId > 0 and qId or cur.Tit
          local qSt = Nx:GeQ(id)
          local qWa = qSt == "W" or cur.PaD1
          if qWa and (cur.Dis1 < hiD or cur.Dis1 > 999999) then
              if (not hiU or cur.CoM) and (not hiG or cur.PaS1 < 5) and (not hNIZ or cur.InZ) and
                  (not hNIC or cur.InC3) then
                  local d = max(cur.Dis1 * prD1 * cur.Pri * 10 + cur.Pri * 100, 0)
                  d = cur.HiP1 and 0 or d
                  d = floor(d) * 256 + n
                  tinsert(wat, d)
              end
          end
      end
      sort(wat)
      local dis1 = wat[1]
      if self.BAT1:GeP() then
          if dis1 then
              local cur = cur1[bit.band(dis1, 0xff)]
              Que:CAT1(cur)
          end
      end
      self.ClC2 = dis1 and cur1[bit.band(dis1, 0xff)]
      if not self.Win1:ISM1() and self.Win1:IsVisible() then
          lis:SIFSA(gop["QWItemScale"], Nx.U_24(gop["QWItemAlpha"]))
          if gop["QWAchTrack"] then
              WatchFrame:Hide()
              local ach = {GetTrackedAchievements()}
              for _, id in ipairs(ach) do
                  local aId, aNa, aPo, aCo, aMo, aDa1, aYe, aDe = GetAchievementInfo(id)
                  if aNa then
                      lis:ItA(0)
                      lis:ItS(2, format("|cffdf9fff%s", aNa))
                      local nuC1 = GetAchievementNumCriteria(id)
                      local prC1 = 0
                      local tip = aDe
                      for n = 1, nuC1 do
                          local cNa, cTy, cCo, cQu, cRQ = GetAchievementCriteriaInfo(id, n)
                          local col = cCo and "|cff80ff80" or "|cffa0a0a0"
                          if not cCo and cRQ > 1 and cQu > 0 then
                              prC1 = prC1 + 1
                              tip = tip .. format("\n%s%s: %s / %s", col, cNa, cQu, cRQ)
                          else
                              tip = tip .. format("\n%s%s", col, cNa)
                          end
                      end
                      lis:ISB("QuestWatchTip", false)
                      lis:ISBT(tip)
                      local shC1 = 0
                      for n = 1, nuC1 do
                          local cNa, cTy, cCo, cQu, cRQ = GetAchievementCriteriaInfo(id, n)
                          if not cCo and (prC1 <= 3 or cQu > 0) then
                              lis:ItA(0)
                              local s = "  |cffcfafcf"
                              if nuC1 == 1 then
                                  if cRQ > 1 then
                                      s = s .. format("%s/%s", cQu, cRQ)
                                  else
                                      s = s .. cNa
                                  end
                              else
                                  s = s .. cNa
                                  if cRQ > 1 then
                                      s = s .. format(": %s/%s", cQu, cRQ)
                                  end
                              end
                              shC1 = shC1 + 1
                              if shC1 >= 3 then
                                  s = s .. "..."
                              end
                              lis:ItS(2, s)
                              if shC1 >= 3 then
                                  break
                              end
                          end
                      end
                  end
              end
          end
          local s = gop["QWAchZoneShow"] and Nx.Que:GZA()
          if s then
              lis:ItA(0)
              lis:ItS(2, s)
          end
          local waN = 1
          for _, dis2 in ipairs(wat) do
              local n = bit.band(dis2, 0xff)
              local cur = cur1[n]
              local qId = cur.QId
              if 1 then
                  local lev, isC1 = cur.Lev, cur.CoM
                  local que = cur.Q
                  local qi = cur.QI
                  local lbN = cur.LBC
                  lis:ItA(qId * 0x10000 + qi)
                  local trM = Que.Tra1[qId] or 0
                  local obj = que and (que[3] or que[2])
                  if qId == 0 then
                      lis:ISB("QuestWatchErr", false)
                  elseif not obj then
                      lis:ISB("QuestWatchErr", false)
                  elseif isC1 or lbN == 0 then
                      local buT = "QuestWatch"
                      local pre1 = false
                      if bit.band(trM, 1) > 0 then
                          pre1 = true
                      end
                      if Que:IsT(qId, 0) then
                          buT = "QuestWatchTarget"
                      end
                      local nam, zon = Que:GOP(que, obj)
                      if not zon or not Map.NTMI[zon] then
                          buT = "QuestWatchErr"
                      end
                      lis:ISB(buT, pre1)
                  else
                      lis:ISB("QuestWatchTip", false)
                  end
                  if not isC1 and cur.ItL2 and gop["QWItemScale"] >= 1 then
                      lis:ISF("WatchItem~" .. cur.QI .. "~" .. cur.ItI1 .. "~" .. cur.ItC1)
                  end
                  lis:ISBT(cur.ObT .. (cur.PaD1 or ""))
                  local col = isC1 and coC1 or inC2
                  local lvS = ""
                  if lev > 0 then
                      local col2 = Que:GetDifficultyColor(lev)
                      lvS = format("|cff%02x%02x%02x%2d%s ", col2.r * 255, col2.g * 255, col2.b * 255, lev, cur.TaS)
                  end
                  local naS = format("%s%s%s", lvS, col, cur.Tit)
                  if isC1 then
                      local obj = que and (que[3] or que[2])
                      if lbN > 0 or not obj then
                          naS = naS .. (isC1 == 1 and "|cff80ff80 (Complete)" or "|cfff04040 - " .. FAILED)
                      else
                          local des1 = Que:UnO(obj)
                          naS = format("%s |cffffffff(%s)", naS, des1)
                      end
                  end
                  if shD then
                      local d = cur.Dis1 * 4.575
                      if d < 1000 then
                          naS = format("%s |cff808080%d yds", naS, d)
                      elseif cur.Dis1 < 99999 then
                          naS = format("%s |cff808080%.1fK yds", naS, d / 1000)
                      end
                  end
                  if cur.PaC1 then
                      naS = format("%s |cffb0b0f0(+%s)", naS, cur.PaC1)
                  end
                  if cur.Par then
                      naS = naS .. " |cffb0b0f0" .. cur.Par
                  end
                  lis:ItS(2, naS)
                  if cur.TiE then
                      lis:ItA(0)
                      lis:ItS(2, format("  |cfff06060%s %s", TIME_REMAINING, SecondsToTime(cur.TiE - time())))
                  end
                  if qi > 0 or cur.Par then
                      local des1, don
                      local zon, loc
                      local lnO = -1
                      for ln = 1, 31 do
                          local obj = que and que[ln + 3]
                          if not obj and ln > lbN then
                              break
                          end
                          zon = nil
                          don = isC1
                          if obj then
                              des1, zon, loc = Que:UnO(obj)
                          end
                          if ln <= lbN then
                              des1 = cur[ln]
                              don = cur[ln + 300]
                          end
                          if not (hDO and don) then
                              if sPC then
                                  if don then
                                      col = Que.PeC[9]
                                  else
                                      local s1, _, i, tot = strfind(des1, ": (%d+)/(%d+)")
                                      if s1 then
                                          i = floor(tonumber(i) / tonumber(tot) * 8.99) + 1
                                      else
                                          i = 1
                                      end
                                      col = Que.PeC[i]
                                  end
                              else
                                  col = don and oCC or oIC
                              end
                              if gop["QWOCntFirst"] then
                                  local s1, s2 = strmatch(des1, "(.+): (.+)")
                                  if s2 then
                                      des1 = format("%s: %s", s2, s1)
                                  end
                              end
                              local str = col .. des1
                              if not don then
                                  local d = cur["OD" .. ln]
                                  if d and d < .5 then
                                      str = "*" .. str
                                  end
                              end
                              lis:ItA(qId * 0x10000 + ln * 0x100 + qi)
                              lis:ISO(16, lnO)
                              local buT = "QuestWatchErr"
                              if zon then
                                  if zon == 220 then
                                      buT = nil
                                  elseif Map.NTMI[zon] then
                                      buT = "QuestWatch"
                                      if Que:IsT(qId, ln) then
                                          buT = "QuestWatchTarget"
                                      end
                                  end
                              end
                              if not don and buT then
                                  if bit.band(trM, bit.lshift(1, ln)) > 0 then
                                      lis:ISB(buT, true)
                                  else
                                      lis:ISB(buT, nil)
                                  end
                              end
                              if not fiS2 then
                                  local mCO = gop["QWOMaxLen"] + 10
                                  local maC2 = mCO
                                  while #str > maC2 do
                                      for cn = maC2, 12, -1 do
                                          if strbyte(str, cn) == 32 then
                                              maC2 = cn - 1
                                              break
                                          end
                                      end
                                      local s = strsub(str, 1, maC2)
                                      lis:ItS(2, s)
                                      str = col .. strsub(str, maC2 + 1)
                                      lis:ItA(qId * 0x10000 + ln * 0x100 + qi)
                                      lis:ISO(16, lnO)
                                      maC2 = mCO
                                  end
                              end
                              lis:ItS(2, str)
                              lnO = lnO - 1
                          end
                      end
                  end
                  if not fiS2 and waN >= qop.NXWVisMax then
                      lis:ItA(0)
                      lis:ItS(2, " ...")
                      break
                  end
                  waN = waN + 1
              end
          end
      end
  end
  if fiS2 then
      lis:FuU()
  else
      lis:Upd()
  end
  if self.Win1:ISM1() then
      self.FiU = true
      self.Win1:SeT("")
  else
      local w, h = lis:GeS2()
      if gop["QWGrowUp"] and not self.FiU then
          h = h - old2
          self.Win1:OfP(0, h)
      end
      if w < 127 then
          self.Win1:SeT("")
      else
          local _, i = GetNumQuestLogEntries()
          self.Win1:SeT(format("|cff40af40%d/25", i))
      end
      self.FiU = nil
  end
  return wat
end
function Nx.Sli:Cre(paF, typ, siz, tlO)
  local ins = {}
  setmetatable(ins, self)
  self.__index = self
  local w = siz
  local h = siz
  ins.TyH = typ == "H"
  if ins.TyH then
      w = 10
  else
      h = 10
  end
  local frm = CreateFrame("Frame", nil, paF)
  ins.Frm = frm
  frm.NxI = ins
  frm:SetScript("OnUpdate", self.OnU)
  frm:SetScript("OnMouseDown", self.OMD)
  frm:SetScript("OnMouseUp", self.OMU)
  frm:EnableMouse(true)
  frm:SetWidth(w)
  frm:SetHeight(h)
  frm.tex = frm:CreateTexture()
  frm.tex:SetAllPoints(frm)
  frm.tex:SetTexture(.3, .3, .4, .6)
  frm:SetPoint("TOPRIGHT", paF, "TOPRIGHT", 0, -tlO)
  frm:SetPoint("BOTTOMRIGHT", paF, "BOTTOMRIGHT", 0, 0)
  frm:Show()
  local tfr = CreateFrame("Frame", nil, frm)
  ins.ThF = tfr
  tfr:SetWidth(w)
  tfr:SetHeight(h)
  tfr.tex = tfr:CreateTexture()
  tfr.tex:SetAllPoints(tfr)
  tfr.tex:SetTexture(.3, .3, .7, .9)
  tfr:SetPoint("TOPLEFT", 1, 1)
  tfr:Show()
  ins:Set(0, 0, 9, 1)
  ins:Upd()
  return ins
end
function Nx:UnitIsPlusMob(tar)
  local c = UnitClassification(tar)
  return c == "elite" or c == "rareelite" or c == "worldboss"
end
function Nx.UEv:UpA(upG)
  self:Sor1()
  self:UpM(upG)
  self.Lis:Upd()
end
function Nx.Map.Gui:UMGI(con1, shT, hiF, tx, nam, icT, sMI1)
  if con1 >= 9 then
      return
  end
  local Que = Nx.Que
  local Map = Nx.Map
  local map = self.Map
  if not Nx.GuD[shT] then
      Nx.prt("guide showType %s", shT)
      return
  end
  local daS = Nx.GuD[shT][con1]
  if not daS then
      return
  end
  local mod1 = strbyte(daS)
  if mod1 == 32 then
      for n = 2, #daS, 6 do
          local fac2 = strbyte(daS, n) - 35
          if fac2 ~= hiF then
              local zon = strbyte(daS, n + 1) - 35
              local maI = Map.NTMI[zon]
              if not sMI1 or maI == sMI1 then
                  local loc = strsub(daS, n + 2, n + 5)
                  local x, y = Que:UnL(loc, true)
                  local wx, wy = map:GWP(maI, x, y)
                  local ico = map:AIP(icT, wx, wy, nil, tx)
                  local str = format("%s\n%s %.1f %.1f", nam, Nx.MITN[maI], x, y)
                  map:SIT(ico, str)
              end
          end
      end
  elseif mod1 == 33 then
  else
      for n = 1, #daS, 2 do
          local npI = (strbyte(daS, n) - 35) * 221 + (strbyte(daS, n + 1) - 35)
          local npS = Nx.NPCD[npI]
          local fac2 = strbyte(npS, 1) - 35
          if fac2 ~= hiF then
              local oSt = strsub(npS, 2)
              local des1, zon, loc = Que:UnO(oSt)
              des1 = gsub(des1, "!", ", ")
              local maI = Map.NTMI[zon]
              if not maI then
                  local nam, miL, maL1, fac1, con1 = strsplit("!", Nx.Zon1[zon])
                  if tonumber(fac1) ~= 3 then
                      Nx.prt("Guide icon err %s %d", des1, zon)
                      assert(maI)
                  end
              elseif not sMI1 or maI == sMI1 then
                  local maN = Nx.MITN[maI]
                  if strbyte(oSt, loc) == 32 then
                      loc = loc + 1
                      local cnt = floor((#oSt - loc + 1) / 4)
                      for loN1 = loc, loc + cnt * 4 - 1, 4 do
                          local lo1 = strsub(oSt, loN1, loN1 + 3)
                          local x, y = Que:UnL(lo1, true)
                          local wx, wy = map:GWP(maI, x, y)
                          local ico = map:AIP(icT, wx, wy, nil, tx)
                          local str = format("%s\n%s\n%s %.1f %.1f", nam, des1, maN, x, y)
                          map:SIT(ico, str)
                      end
                  else
                      local _, zon, x, y = Que:GOP(nil, oSt)
                      local wx, wy = map:GWP(maI, x, y)
                      local ico = map:AIP(icT, wx, wy, nil, tx)
                      local str = format("%s\n%s\n%s %.1f %.1f", nam, des1, maN, x, y)
                      map:SIT(ico, str)
                  end
              end
          end
      end
  end
end
function Nx.Inf:OnT()
  local var1 = self.Var
  self.NeD = false
  local h = UnitHealth("player")
  local m = UnitMana("player")
  if UnitIsDeadOrGhost("player") then
      h = 0
      m = 0
  end
  var1["Health"] = h
  var1["Mana"] = m
  var1["HealthMax"] = UnitHealthMax("player")
  var1["ManaMax"] = UnitManaMax("player")
  var1["Health%"] = h / var1["HealthMax"]
  var1["Mana%"] = m / var1["ManaMax"]
  local h = 0
  local m = -1
  local taN1 = UnitName("target")
  var1["TName"] = taN1
  if taN1 then
      m = UnitManaMax("target") > 0 and 0 or -1
      if not UnitIsDeadOrGhost("target") then
          h = UnitHealth("target")
          m = UnitManaMax("target") > 0 and UnitMana("target") or -1
      end
      var1["THealthMax"] = max(UnitHealthMax("target"), 1)
      var1["TManaMax"] = max(UnitManaMax("target"), 1)
  end
  var1["THealth"] = h
  var1["TMana"] = m
  var1["InBG"] = Nx.IBG
  for i, inf in pairs(self.Inf1) do
      if inf.Dat then
          inf:Upd(n)
      end
  end
  return .1
end
function Nx.Soc.Lis:M_OMPF1()
  local pal = Nx:GeS("Pal")
  for _, fri1 in pairs(pal) do
      for fNa, v in pairs(fri1) do
          if not self:FFI(fNa) then
              AddFriend(fNa)
          end
      end
  end
end

function Nx.Que:Ini()
  local opt = Nx:GGO()
  self.GOp = opt
  if opt["QWBlizzModify"] then
      SetCVar("questFadingDisable", 1)
      SetCVar("autoQuestProgress", 0)
      SetCVar("autoQuestWatch", 0)
  end
  GetUIPanelWidth(QuestLogFrame)
  QuestLogFrame:SetAttribute("UIPanelLayout-enabled", false)
  if QuestLogDetailFrame then
      GetUIPanelWidth(QuestLogDetailFrame)
      QuestLogDetailFrame:SetAttribute("UIPanelLayout-enabled", false)
  end
  local Map = Nx.Map
  self.ITQ = {}
  self.QId1 = {}
  self.Tra1 = {}
  self.Sor = {}
  self.CuQ = {}
  self.ReQ = {}
  self.RQE = 0
  self.PaQ = {}
  self.ITCQ = {}
  self.HeE = {}
  self.HeH = {}
  self.RPL = "None"
  self.RcC = 0
  self.RcT = 0
  self.FrQ = {}
  self.IcT = {}
  self:CWC()
  self.TaN2 = {
      ["Group"] = "+",
      ["Gruppe"] = "+",
      ["Dungeon"] = "D",
      ["Heroic"] = "H",
      ["Heroisch"] = "H",
      ["Raid"] = "R"
  }
  self.PeC = {"|cffc00000", "|cffc03000", "|cffc06000", "|cffc09000", "|cffc0c000", "|cff90c000", "|cff60c000",
              "|cff30c000", "|cff00c000"}
  local qop = Nx:GQO()
  if qop.NXBroadcastQChanges ~= nil then
      opt["QBroadcastQChanges"] = qop.NXBroadcastQChanges
      qop.NXBroadcastQChanges = nil
  end
  self.CPD = {}
  self.CFA = {
      ["Argent Crusade"] = 1,
      ["Argent Dawn"] = 2,
      ["Ashtongue Deathsworn"] = 3,
      ["Bloodsail Buccaneers"] = 4,
      ["Booty Bay"] = 5,
      ["Brood of Nozdormu"] = 6,
      ["Cenarion Circle"] = 7,
      ["Cenarion Expedition"] = 8,
      ["Darkmoon Faire"] = 9,
      ["Darkspear Trolls"] = 10,
      ["Darnassus"] = 11,
      ["Everlook"] = 12,
      ["Exodar"] = 13,
      ["Explorers' League"] = 14,
      ["Frenzyheart Tribe"] = 15,
      ["Frostwolf Clan"] = 16,
      ["Gadgetzan"] = 17,
      ["Gelkis Clan Centaur"] = 18,
      ["Gnomeregan Exiles"] = 19,
      ["Honor Hold"] = 20,
      ["Hydraxian Waterlords"] = 21,
      ["Ironforge"] = 22,
      ["Keepers of Time"] = 23,
      ["Kirin Tor"] = 24,
      ["Knights of the Ebon Blade"] = 25,
      ["Kurenai"] = 26,
      ["Lower City"] = 27,
      ["Magram Clan Centaur"] = 28,
      ["Netherwing"] = 29,
      ["Ogri'la"] = 30,
      ["Orgrimmar"] = 31,
      ["Ratchet"] = 32,
      ["Ravenholdt"] = 33,
      ["Sha'tari Skyguard"] = 34,
      ["Shattered Sun Offensive"] = 35,
      ["Shen'dralar"] = 36,
      ["Silvermoon City"] = 37,
      ["Silverwing Sentinels"] = 38,
      ["Sporeggar"] = 39,
      ["Stormpike Guard"] = 40,
      ["Stormwind"] = 41,
      ["Syndicate"] = 42,
      ["The Aldor"] = 43,
      ["The Consortium"] = 44,
      ["The Defilers"] = 45,
      ["The Frostborn"] = 46,
      ["The Hand of Vengeance"] = 47,
      ["The Kalu'ak"] = 48,
      ["The League of Arathor"] = 49,
      ["The Mag'har"] = 50,
      ["The Oracles"] = 51,
      ["The Scale of the Sands"] = 52,
      ["The Scryers"] = 53,
      ["The Sha'tar"] = 54,
      ["The Silver Covenant"] = 55,
      ["The Sons of Hodir"] = 56,
      ["The Taunka"] = 57,
      ["The Violet Eye"] = 58,
      ["The Wyrmrest Accord"] = 59,
      ["Thorium Brotherhood"] = 60,
      ["Thrallmar"] = 61,
      ["Thunder Bluff"] = 62,
      ["Timbermaw Hold"] = 63,
      ["Tranquillien"] = 64,
      ["Undercity"] = 65,
      ["Valiance Expedition"] = 66,
      ["Warsong Offensive"] = 67,
      ["Warsong Outriders"] = 68,
      ["Wildhammer Clan"] = 69,
      ["Wintersaber Trainers"] = 70,
      ["Zandalar Tribe"] = 71
  }
  local qda = {
      [3444] = "4^97^626^386",
      [10447] = "5^96^738^357"
  }
  for id, s in pairs(qda) do
      id = id <= 100000 and id or id - 100000
      local que = Nx.Que1[(id + 7) * 2 - 3]
      local obI, zon, x, y = strsplit("^", s)
      obI = tonumber(obI)
      if not zon then
          que[obI] = nil
      else
          local obj = que[obI]
          if obj then
              zon = tonumber(zon)
              if x then
                  x = tonumber(x) * 10
                  y = tonumber(y) * 10
                  local oDe = self:UnO(obj)
                  que[obI] = format("%c%s%c %c%c%c%c", #oDe + 35, oDe, zon + 35, floor(x / 221) + 35, x % 221 + 35,
                      floor(y / 221) + 35, y % 221 + 35)
              else
                  local oDe, oZo, oLo = self:UnO(obj)
                  que[obI] = format("%c%s%c%s", #oDe + 35, oDe, zon + 35, strsub(obj, oLo))
              end
          end
      end
  end
  self.DaT = {
      ["1"] = "Daily",
      ["2"] = "Daily Dungeon",
      ["3"] = "Daily Heroic"
  }
  self.Rep = {
      ["A"] = "Aldor",
      ["S"] = "Scryer",
      ["c"] = "Consortium",
      ["e"] = "Cenarion Expedition",
      ["g"] = "Sha'tari Skyguard",
      ["k"] = "Keepers of Time",
      ["l"] = "Lower City",
      ["n"] = "Netherwing",
      ["o"] = "Ogri'la",
      ["s"] = "Shattered Sun Offensive",
      ["t"] = "Sha'tar",
      ["z"] = "Honor Hold/Thrallmar",
      ["C"] = "Argent Crusade",
      ["E"] = "Explorers' League",
      ["F"] = "Frenzyheart Tribe",
      ["f"] = "The Frostborn",
      ["H"] = "Horde Expedition",
      ["K"] = "The Kalu'ak",
      ["i"] = "Kirin Tor",
      ["N"] = "Knights of the Ebon Blade",
      ["O"] = "The Oracles",
      ["h"] = "The Sons of Hodir",
      ["a"] = "Alliance Vanguard",
      ["V"] = "Valiance Expedition",
      ["W"] = "Warsong Offensive",
      ["w"] = "The Wyrmrest Accord",
      ["I"] = "The Silver Covenant",
      ["R"] = "The Sunreavers"
  }
  self.Req = {
      ["oH"] = "Ogri'la Honored",
      ["H350"] = "Herbalism 350",
      ["M350"] = "Mining 350",
      ["S350"] = "Skining 350",
      ["G"] = "Gathering Skill",
      ["nF"] = "Netherwing Friendly",
      ["nH"] = "Netherwing Honored",
      ["nRA"] = "Netherwing Revered (Aldor)",
      ["nRS"] = "Netherwing Revered (Scryer)",
      ["hH"] = "The Sons of Hodir Honored",
      ["hR"] = "The Sons of Hodir Revered",
      ["J375"] = "Jewelcrafting 375",
      ["C"] = "Cooking",
      ["F"] = "Fishing"
  }
  self.DaI = {
      [10106] = "1^70^z150",
      [10110] = "1^70^z150",
      [11023] = "1^1199^o500g500",
      [11066] = "1^1199^o350g350",
      [11080] = "1^910^o350",
      [11051] = "1^1199^o350^oH",
      [11020] = "1^1199^n250",
      [11035] = "1^1199^n250",
      [11049] = "1^1828^n350",
      [11015] = "1^1199^n250",
      [11017] = "1^1199^n250^H350",
      [11018] = "1^1199^n250^M350",
      [11016] = "1^1199^n250^S350",
      [11055] = "1^1199^n350^nF",
      [11076] = "1^1828^n350^nF",
      [11086] = "1^1199^n500^nH",
      [11101] = "1^1828^n500^nRA",
      [11097] = "1^1828^n500^nRS",
      [11514] = "1^1010^s250",
      [11515] = "1^1199^s250",
      [11516] = "1^1010^s250",
      [11521] = "1^1388^s350",
      [11523] = "1^910^s150",
      [11525] = "1^910^s150",
      [11533] = "1^910^s150",
      [11536] = "1^1199^s250",
      [11537] = "1^1010^s250",
      [11540] = "1^1199^s250",
      [11541] = "1^1199^s250",
      [11543] = "1^759^s250",
      [11544] = "1^1828^s350",
      [11546] = "1^1199^s250",
      [11547] = "1^1199^s250",
      [11548] = "1^-1000^s150",
      [11877] = "1^1010^s250",
      [11880] = "1^910^s250",
      [11875] = "1^1639^s250^G",
      [11008] = "1^1199^g350",
      [11085] = "1^910^g150",
      [11940] = "1^470^w250",
      [11945] = "1^500^K500",
      [13414] = "1^740^w250",
      [11153] = "1^470^a 38V250^1",
      [11391] = "1^470^E250^1",
      [11472] = "1^470^K500",
      [11960] = "1^500^K500",
      [12372] = "1^560^w250",
      [12437] = "1^560^^1",
      [12444] = "1^560^a 38V250^1",
      [12316] = "1^560^^1",
      [12289] = "1^560^a 38V250^1",
      [12296] = "1^560^a 38V250^1",
      [12268] = "1^560^^1",
      [12244] = "1^560^^1",
      [12323] = "1^560^^1",
      [12314] = "1^560^^1",
      [12038] = "1^986",
      [12433] = "1^560",
      [12170] = "1^560^H250^2",
      [12284] = "1^560^W250^2",
      [12280] = "1^560^W250^2",
      [12288] = "1^560^W250^2",
      [12270] = "1^560^W250^2",
      [12315] = "1^560^^2",
      [12324] = "1^560^^2",
      [12317] = "1^560^^2",
      [12432] = "1^560^^2",
      [12501] = "1^620^C250",
      [12541] = "1^158^C 75",
      [12502] = "1^158^C 75",
      [12564] = "1^158^C 75",
      [12588] = "1^158^C 75",
      [12568] = "1^158^C 75",
      [12509] = "1^158^C250",
      [12591] = "1^158^C 75",
      [12585] = "1^158^C 75",
      [12519] = "1^158^C 25",
      [12594] = "1^158^C 75",
      [12604] = "1^1860^C350",
      [12704] = "1^650^O250",
      [12761] = "1^1360^O350",
      [12762] = "1^1360^O350",
      [12705] = "1^1360^O350",
      [12735] = "1^740^O500",
      [12737] = "1^740^O250",
      [12736] = "1^740^O250",
      [12726] = "1^740^O500",
      [12689] = "1^330^O***",
      [12582] = "1^330^F***",
      [12702] = "1^650^F500",
      [12703] = "1^1360^F350",
      [12760] = "1^1360^F350",
      [12759] = "1^1360^F350",
      [12734] = "1^740^F500",
      [12758] = "1^740^F500",
      [12741] = "1^740^F500",
      [12732] = "1^740^F500",
      [13309] = "1^740^V250^1",
      [13284] = "1^740^V250^1",
      [13336] = "1^740^V250^1",
      [13323] = "1^740^^1",
      [13344] = "1^740^^1",
      [13322] = "1^740^^1",
      [13404] = "1^740^^1",
      [13300] = "1^740^C250^1",
      [13289] = "1^740^^1",
      [13292] = "1^740^^1",
      [13333] = "1^740^^1",
      [13297] = "1^2220^^1",
      [13350] = "1^2220^^1",
      [13280] = "1^740^V250^1",
      [13233] = "1^740^^1",
      [13310] = "1^740^W250^2",
      [13301] = "1^740^W250^2",
      [13330] = "1^740^W250^2",
      [13353] = "1^740^^2",
      [13365] = "1^740^^2",
      [13357] = "1^740^^2",
      [13406] = "1^740^^2",
      [13302] = "1^740^C250^2",
      [13376] = "1^740^^2",
      [13276] = "1^740^^2",
      [13331] = "1^740^W250^2",
      [13261] = "1^740^^2",
      [13281] = "1^2220^^2",
      [13368] = "1^2220^^2",
      [13283] = "1^740^W250^2",
      [13234] = "1^740^^2",
      [12813] = "1^740^N250",
      [12838] = "1^740^N250",
      [12995] = "1^740^N250",
      [12815] = "1^740^N250",
      [13069] = "1^740^N250",
      [13071] = "1^370^N250",
      [13625] = "1^580^I250",
      [13677] = "1^580^R250",
      [13671] = "1^580^I250",
      [13676] = "1^580^R250",
      [13666] = "1^580^I250",
      [13603] = "1^740^I250",
      [13741] = "1^740^I250",
      [13746] = "1^740^I250",
      [13752] = "1^740^I250",
      [13757] = "1^740^I250",
      [13673] = "1^580^R250",
      [13762] = "1^740^R250",
      [13768] = "1^740^R250",
      [13783] = "1^740^R250",
      [13773] = "1^740^R250",
      [13778] = "1^740^R250",
      [12994] = "1^740^h350^hH",
      [12833] = "1^680",
      [13424] = "1^740",
      [12977] = "1^740^h250",
      [13423] = "1^740",
      [13046] = "1^740^h250^hR",
      [12981] = "1^740^h250",
      [13422] = "1^550",
      [13006] = "1^740^h250",
      [12869] = "1^680^f250",
      [13425] = "1^740",
      [13003] = "1^1480^h500^hH",
      [13156] = "1^740",
      [13195] = "1^740",
      [13154] = "1^740",
      [13193] = "1^740",
      [13196] = "1^740",
      [13199] = "1^740",
      [13222] = "1^740",
      [13223] = "1^740",
      [13191] = "1^740",
      [13197] = "1^740",
      [13200] = "1^740",
      [13194] = "1^740",
      [13201] = "1^740",
      [13202] = "1^740",
      [13177] = "1^740",
      [13179] = "1^740",
      [13178] = "1^740",
      [13180] = "1^740",
      [13538] = "1^740",
      [13185] = "1^740",
      [13186] = "1^740",
      [13539] = "1^740",
      [13181] = "1^740",
      [13183] = "1^740",
      [13192] = "1^740",
      [13153] = "1^740",
      [13198] = "1^740",
      [13101] = "1^580^i150^C",
      [13113] = "1^580^i150^C",
      [13100] = "1^580^i150^C",
      [13112] = "1^580^i150^C",
      [13107] = "1^580^i150^C",
      [13116] = "1^580^i150^C",
      [13102] = "1^580^i150^C",
      [13114] = "1^580^i150^C",
      [12958] = "1^740^i 25^J375",
      [12962] = "1^740^i 25^J375",
      [12959] = "1^740^i 25^J375",
      [12961] = "1^740^i 25^J375",
      [12963] = "1^740^i 25^J375",
      [12960] = "1^740^i 25^J375",
      [13833] = "1^0^i250^F",
      [13834] = "1^0^i250^F",
      [13832] = "1^0^i250^F",
      [13836] = "1^0^i250^F",
      [13830] = "1^0^i250^F"
  }
  self.DDI = {
      [11389] = "2^1639^c250t250",
      [11371] = "2^1639^c250e250",
      [11376] = "2^1639^c250l250",
      [11383] = "2^1639^c250k250",
      [11364] = "2^1639^c250z250",
      [11500] = "2^1639^c250s250",
      [11385] = "2^1639^c250t250",
      [11387] = "2^1639^c250t250",
      [11369] = "3^2460^c250e250",
      [11384] = "3^2460^c350t350",
      [11382] = "3^2460^c350k350",
      [11363] = "3^2460^c350z350",
      [11362] = "3^2460^c350z350",
      [11375] = "3^2460^c350l350",
      [11354] = "3^2460^c350z350",
      [11386] = "3^2460^c350t350",
      [11373] = "3^2460^c500",
      [11378] = "3^2460^c350k350",
      [11374] = "3^2460^c350l350",
      [11372] = "3^2460^c350l350",
      [11368] = "3^2460^c350e350",
      [11388] = "3^2460^c350t350",
      [11499] = "3^2460^c350s350",
      [11370] = "3^2460^c350e350",
      [13240] = "2^3466^i 75",
      [13243] = "2^3466^i 75",
      [13244] = "2^3466^i 75",
      [13241] = "2^3466^i 75",
      [13190] = "2^4200",
      [13254] = "2^4866^i 75",
      [13256] = "2^4866^i 75",
      [13250] = "2^4866^i 75",
      [13255] = "2^4866^i 75",
      [13245] = "2^4866^i 75",
      [13246] = "2^4866^i 75",
      [13248] = "2^4866^i 75",
      [13247] = "2^4866^i 75",
      [13253] = "2^4866^i 75",
      [13251] = "2^4866^i 75",
      [13252] = "2^4866^i 75",
      [14199] = "2^4866^i 75",
      [13249] = "2^4866^i 75"
  }
  self.DPVPI = {
      [11335] = "1",
      [11336] = "1",
      [11337] = "1",
      [11338] = "1",
      [11339] = "1",
      [11340] = "1",
      [11341] = "1",
      [11342] = "1",
      [13405] = "1",
      [13407] = "1",
      [14163] = "1",
      [14164] = "1"
  }
  Nx.Que1 = Nx["Quests"] or Nx.Que1
  self.Map = Map:GeM(1)
  local enF = Nx.PFN == 1 and 1 or 2
  local qLL = UnitLevel("player") - opt["QLevelsToLoad"]
  local qML = Nx.V30 and 999 or 70
  local qCn = 0
  local max2 = 0
  local saC = 0
  for muI, q in pairs(Nx.Que1) do
      local id = (muI + 3) / 2 - 7
      qCn = qCn + 1
      max2 = max(id, max2)
      local nam, sid, lev = self:Unp(q[1])
      if sid == enF or lev > 0 and lev < qLL or lev > qML then
          Nx.Que1[muI] = nil
      else
          self.ITQ[id] = q
          if q[3] and q[3] == q[2] then
              q[3] = nil
              saC = saC + 1
          end
          self:ChQ(q, 3)
          for n = 4, 99 do
              if not q[n] then
                  break
              end
              self:ChQ(q, n)
          end
      end
  end
  for muI, q in pairs(Nx.Que1) do
      local nam, sid, lvl, min5, next = self:Unp(q[1])
      if not q.CNu and next > 0 then
          local clv = lvl
          local qc = q
          local cnu = 0
          while qc do
              cnu = cnu + 1
              qc.CNu = cnu
              nam, sid, lvl, min5, next = self:Unp(qc[1])
              clv = max(clv, lvl)
              if next == 0 then
                  break
              end
              qc = self.ITQ[next]
          end
          q.CLM = clv
      end
  end
  for lvl = 0, 80 do
      local grp = {}
      for id, q in pairs(Nx.Que1) do
          id = (id + 3) / 2 - 7
          local nam, sid, lev = self:Unp(q[1])
          if lev == lvl then
              if sid ~= enF then
                  if not q.CNu then
                      tinsert(grp, format("%s^%d", nam, id))
                  elseif q.CNu == 1 then
                      local qc = q
                      while qc do
                          local pna, sid, _, _, next = self:Unp(qc[1])
                          tinsert(grp, format("%s%2d^%d", nam, qc.CNu, id))
                          qc = self.ITQ[next]
                          id = next
                      end
                  end
              end
          end
      end
      for _, v in ipairs(grp) do
          local nam, id = strsplit("^", v)
          tinsert(self.Sor, tonumber(id))
      end
  end
  local usI1 = {}
  local sta5 = {}
  self.QGi = sta5
  for qsI, qId in ipairs(self.Sor) do
      if not usI1[qId] then
          local que = self.ITQ[qId]
          if que then
              local sNa, zon, x, y = self:GOP(que, que[2])
              if zon and x ~= 0 and y ~= 0 then
                  usI1[qId] = true
                  sNa = format("%s=%d%d", sNa, x, y)
                  local stm = sta5[zon] or {}
                  sta5[zon] = stm
                  local s = stm[sNa] or ""
                  stm[sNa] = s .. format("%4x", qId)
              end
          end
      end
  end
  self.Lis:Ope()
  self.Wat:Ope()
  local men = Nx.Men:Cre(self.Map.Frm)
  self.IcM = men
  men:AdI1(0, "Track", self.M_OT1, self)
  men:AdI1(0, "Show Quest Log", self.M_OSQ, self)
  self.IMIW = men:AdI1(0, "Watch", self.M_OW1, self)
  men:AdI1(0, "Add Note", self.Map.M_OAN, self.Map)
  self.BAQ = AcceptQuest
  AcceptQuest = self.AcceptQuest
  self.BGQR = GetQuestReward
  GetQuestReward = self.GetQuestReward
  local function fun()
      if QuestGetAutoAccept() then
          Nx.Que:RQAOF()
      end
      QuestFrameDetailPanel_OnShow()
  end
  QuestFrameDetailPanel:SetScript("OnShow", fun);
  local ttH = {"SetAction", "SetAuctionItem", "SetBagItem", "SetCraftItem", "SetCraftSpell", "SetGuildBankItem",
               "SetHyperlink", "SetInboxItem", "SetInventoryItem", "SetLootItem", "SetLootRollItem",
               "SetMerchantItem", "SetQuestItem", "SetQuestLogItem", "SetTradeSkillItem", "SetTradeTargetItem"}
  for k, nam in ipairs(ttH) do
      if not Nx.V30 or nam ~= "SetCraftItem" and nam ~= "SetCraftSpell" then
          hooksecurefunc(GameTooltip, nam, Nx.Que.ToH1)
      end
  end
  local unN1 = {"Hunter", "Paladin", "Priest", "Shaman", "Warlock", "Warrior", "Deathknight"}
  self.TTI = {
      ["Attack"] = true,
      ["Lumber Mill"] = true,
      ["Stables"] = true,
      ["Blacksmith"] = true,
      ["Gold Mine"] = true
  }
  self.TTI[UnitName("player")] = true
  for _, v in pairs(unN1) do
      self.TTI[v] = true
  end
  self.TTC = {
      ["Bloodberry Bush"] = "Bloodberries",
      ["Erratic Sentry"] = "Erratic Sentries"
  }
end
function Nx.Que.Lis:M_OWC(ite)
  local cur1 = Nx.Que.CuQ
  if cur1 then
      for i, cur in ipairs(cur1) do
          if cur.Com2 and cur.Com2 == 1 then
              Nx.Que.Wat:Add(i)
          end
      end
      self:Upd()
  end
end
function Nx.Fon:Upd()
  local opt = Nx:GGO()
  for nam, v in pairs(self.Fon1) do
      local fon = v.Fon
      local fna, siz, fla = fon:GetFont()
      local fil = self:GeF1(opt[nam])
      local siz = opt[nam .. "Size"]
      fon:SetFont(fil, siz, fla)
      v.H = max(siz + (opt[nam .. "H"] or 0), 6)
  end
  Nx.Lis:NUF()
  Nx.Win:AdA()
end
function Nx.Que:SeB1(qi)
  if qi > 0 then
      SelectQuestLogEntry(qi)
  end
end
function Nx.Que.Wat:Add(cur2)
  local Que = Nx.Que
  local cur = Que.CuQ[cur2]
  local qId = cur.QId > 0 and cur.QId or cur.Tit
  local qSt = Nx:GeQ(qId)
  if not qSt or qSt ~= "W" then
      Nx:SeQ(qId, "W")
      Que:PSS()
  end
end
function Nx.Soc:DCRP(fiN1, inf, puS)
  local puT = {strsplit("!", puS)}
  for n, v in ipairs(puT) do
      local lvl = tonumber(strsub(v, 1, 2), 16)
      if not lvl then
          break
      end
      local nam = strsub(v, 3)
      if lvl >= 0xff then
          nam = strsub(v, 9)
          lvl = 0
      end
      local pun1 = self:GeP1(nam, nil, inf.MId, inf.X, inf.Y)
      pun1.FiN1 = fiN1
      pun1.Lvl = max(lvl, pun1.Lvl or 0)
      pun1.Tim1 = inf.T
  end
  if not Nx.Tim:IsA("SocialUpdate") then
      Nx.Tim:Sta("SocialUpdate", 2, self, self.OUT)
  end
end
function Nx.Win:FNC(nam)
  if self.Win2 and nam then
      nam = strlower(nam)
      for win in pairs(self.Win2) do
          if strlower(win.Nam) == nam then
              return win
          end
      end
  end
end

function Nx.Win:UpC()
  local com = UnitAffectingCombat("player")
  if self.Win2 then
      for win in pairs(self.Win2) do
          if win.SaD["HideC"] then
              if com then
                  win.Frm:Hide()
              else
                  if not win.SaD["Hide"] and not win.RaH then
                      win.Frm:Show()
                  end
              end
          end
      end
  end
end
function Nx.Tra:TFNFRXY(x, y)
  for n = 1, NumTaxiNodes() do
      local x2, y2 = TaxiNodePosition(n)
      local dis = (x - x2) ^ 2 + (y - y2) ^ 2
      if dis < .000001 then
          return n
      end
  end
end
function Nx.ToB:Upd()
  local dat = Nx:GDTB()
  local svd = dat[self.Nam]
  local f = self.Frm
  f:ClearAllPoints()
  local ali = "TOPRIGHT"
  if not svd["AlignR"] then
      ali = "TOPLEFT"
      if svd["AlignB"] then
          ali = "BOTTOMLEFT"
      end
  else
      if svd["AlignB"] then
          ali = "BOTTOMRIGHT"
      end
  end
  f:SetPoint(ali, 0, 0)
  local sca = svd["Size"] / self.Siz2
  local spa = (svd["Space"] or 0) / sca
  local ste = self.Siz2 + spa
  local xst = ste
  local yst = 0
  if svd["Vert"] then
      xst = 0
      yst = ste
  end
  local xof = 0
  local yof = 0
  for n, too in ipairs(self.Too) do
      local but1 = too.But2
      if but1 then
          but1:SeP1("TOPLEFT", xof, -yof)
      end
      xof = xof + xst
      yof = yof + yst
  end
  if not svd["Vert"] then
      xof = xof - spa
  else
      yof = yof - spa
  end
  f:SetWidth(max(xof, self.Siz2))
  f:SetHeight(max(yof, self.Siz2))
  f:SetScale(sca)
end
function Nx.Que.Lis:Up_()
  if not self.Win1:IsShown() then
      return
  end
  local Nx = Nx
  local Que = Nx.Que
  local Map = Nx.Map
  local qLC = Que.QLC1
  local opt = Nx:GGO()
  local sQI = opt["QShowId"]
  local _, i = GetNumQuestLogEntries()
  local daS1 = ""
  local daD1 = GetDailyQuestsCompleted()
  if daD1 > 0 then
      daS1 = format(QUEST_LOG_DAILY_COUNT_TEMPLATE, daD1, GetMaxDailyQuests())
  end
  if opt["QShowDailyReset"] then
      daS1 = daS1 .. "|r  Daily reset: |cffffffff" .. Nx.U_GTES(GetQuestResetTime())
  end
  self.Win1:SeT(format("Quests: |cffffffff%d/%d|r  %s", i, MAX_QUESTS, daS1))
  local lis = self.Lis
  lis:Emp()
  if self.TaS1 == 1 then
      local olS = GetQuestLogSelection()
      local hea
      local cur1 = Que.CuQ
      for n = 1, cur1 and #cur1 or 0 do
          local cur = cur1[n]
          local que = cur.Q
          local qId = cur.QId
          local tit, lev, tag, isC1 = cur.Tit, cur.Lev, cur.Tag, cur.Com2
          local qn = cur.QI
          if qn > 0 then
              SelectQuestLogEntry(qn)
          end
          local onQ = 0
          local oQS = ""
          if qn > 0 then
              for n = 1, 4 do
                  if IsUnitOnQuest(qn, "party" .. n) then
                      if onQ > 0 then
                          oQS = oQS .. "," .. UnitName("party" .. n)
                      else
                          oQS = oQS .. UnitName("party" .. n)
                      end
                      onQ = onQ + 1
                  end
              end
          end
          if not self.ShP or onQ > 0 then
              local lvS = "  "
              if lev > 0 then
                  lvS = format("|cffd0d0d0%2d", lev)
              end
              local col = Que:GetDifficultyColor(lev)
              col = format("|cff%02x%02x%02x", col.r * 255, col.g * 255, col.b * 255)
              local naS = format("%s %s%s", lvS, col, tit)
              if que and que.CNu then
                  naS = naS .. format(" (Part %d of %d)", que.CNu, cur.CNM)
              end
              if onQ > 0 then
                  naS = format("(%d) %s (%s)", onQ, naS, oQS)
              end
              if isC1 then
                  naS = naS .. (isC1 == 1 and "|cff80ff80 - Complete" or "|cfff04040 - " .. FAILED)
              end
              if tag and cur.GCn > 0 then
                  tag = tag .. " " .. cur.GCn
              end
              if cur.Dai then
                  if tag then
                      tag = format(DAILY_QUEST_TAG_TEMPLATE, tag)
                  else
                      tag = DAILY
                  end
              end
              local show = true
              if self.Fil[self.TaS1] ~= "" then
                  local str = strlower(format("%s %s", naS, tag or ""))
                  local fiS1 = strlower(self.Fil[self.TaS1])
                  show = strfind(str, fiS1, 1, true)
              end
              if self.QOp.NXShowHeaders and cur.Hea1 ~= hea then
                  hea = cur.Hea1
                  if show then
                      lis:ItA(0)
                      lis:ItS(2, format("|cff8f8fff---- %s ----", hea))
                      lis:ISDE(lis:IGN(), cur, 1)
                      lis:ISB("QuestHdr", Que.HeH[cur.Hea1])
                  end
              end
              if show and not Que.HeH[cur.Hea1] then
                  local id = qId > 0 and qId or cur.Tit
                  local qSt = Nx:GeQ(id)
                  local qWa = qSt == "W"
                  lis:ItA(qId * 0x10000 + qn)
                  local trM = Que.Tra1[qId] or 0
                  local buT = "QuestWatch"
                  local buO
                  local trS = " "
                  if bit.band(trM, 1) > 0 then
                      trS = "*"
                      buO = true
                  end
                  if qWa then
                      buT = "QuestWatching"
                      buO = true
                  end
                  lis:ISB(buT, buO)
                  if que and sQI then
                      naS = naS .. format(" [%s]", qId)
                  end
                  if cur.HiP1 then
                      naS = "> " .. naS
                  end
                  lis:ItS(2, naS)
                  lis:ItS(4, tag)
                  if self.QOp.NXShowObj then
                      local num = GetNumQuestLeaderBoards(qn)
                      local str = ""
                      local des1, typ, don
                      local zon, loc
                      for ln = 1, 15 do
                          zon = nil
                          local obj = que and que[ln + 3]
                          if obj then
                              des1, zon, loc = Que:UnO(obj)
                          end
                          if ln <= num then
                              des1, typ, don = GetQuestLogLeaderBoard(ln, qn)
                          else
                              if not obj then
                                  break
                              end
                              don = false
                          end
                          col = don and "|cff5f5f6f" or "|cff9f9faf"
                          str = format("     %s%s", col, des1)
                          lis:ItA(qId * 0x10000 + ln * 0x100 + qn)
                          local trS = ""
                          if zon then
                              lis:ISB("QuestWatch", false)
                          end
                          if bit.band(trM, bit.lshift(1, ln)) > 0 then
                              lis:ISB(qLC[ln][5], true)
                          end
                          lis:ItS(1, trS)
                          lis:ItS(2, str)
                      end
                  end
              end
          end
      end
      SelectQuestLogEntry(olS)
  end
  if Nx.Que1 and self.TaS1 == 2 then
      local qId1 = Que.QId1
      local soT = {}
      local sAZ = self.SAZ or self.SAQ
      local sLL = self.SLL or self.SAQ
      local sHL = self.SHL or self.SAQ
      local shF = self.ShF1 or self.SAQ
      local sOD = self.SOD and not self.SAQ
      local maI = Map:GCMI()
      local miL1 = UnitLevel("player") - GetQuestGreenRange()
      local maL2 = sHL and MAX_PLAYER_LEVEL or UnitLevel("player") + 6
      lis:ItA(0)
      lis:ItA(0)
      local dTI = lis:IGN()
      local dTN = 0
      lis:ItA(0)
      for qId in pairs(Nx.CuC.Q) do
          local que = Que.ITQ[qId]
          local sta, qTi = Nx:GeQ(qId)
          local qCo = sta == "C"
          local show = qCo
          if show and not sAZ then
              show = Que:ChS(maI, qId)
          end
          if show then
              local qna, si_, lvl
              if que then
                  qna, si_, lvl = Que:Unp(que[1])
              else
                  qna = format("%s?", qId)
                  lvl = 0
              end
              local lvS = format("|cffd0d0d0%2d", lvl)
              local tit = qna
              if que and que.CNu then
                  tit = tit .. format(" (Part %d)", que.CNu)
              end
              if sQI then
                  tit = tit .. format(" [%s]", qId)
              end
              local daN = ""
              local daS1 = Que.DaI[qId] or Que.DDI[qId] or Que.DPVPI[qId]
              if daS1 then
                  local typ = strsplit("^", daS1)
                  daN = format(" |cffd060d0(%s)", Que.DaT[typ])
                  local age = time() - qTi
                  local daC = 86400 - GetQuestResetTime()
                  if age < daC then
                      daN = daN .. " |cffff8080today"
                  end
              end
              local show = true
              if self.Fil[self.TaS1] ~= "" then
                  local str = strlower(format("%2d %s %s%s", lvl, tit, date("%m/%d %H:%M:%S", qTi), daN))
                  local fiS1 = strlower(self.Fil[self.TaS1])
                  show = strfind(str, fiS1, 1, true)
              end
              if show then
                  local t = {}
                  tinsert(soT, t)
                  t.T = qTi
                  t.QId = qId
                  dTN = dTN + 1
                  local haS = ""
                  if qId1[qId] then
                      haS = "|cffe0e0e0+ "
                  end
                  local col = Que:GetDifficultyColor(lvl)
                  col = format("|cff%02x%02x%02x", col.r * 255, col.g * 255, col.b * 255)
                  t.Des = format("%s %s%s%s", lvS, haS, col, tit)
                  t.Co41 = format("%s %s", date("|cff9f9fcf%m/%d %H:%M:%S", qTi), daN)
              end
          end
      end
      sort(soT, function(a, b)
          return a.T > b.T
      end)
      for _, qEn in ipairs(soT) do
          lis:ItA(qEn.QId * 0x10000)
          lis:ItS(2, qEn.Des)
          lis:ItS(4, qEn.Co41)
      end
      local str = (sAZ and "All" or Map:ITN(maI)) .. " Completed"
      lis:ItS(2, format("|cffc0c0c0--- %s (%d) ---", str, dTN), dTI)
  end
  if Nx.Que1 and self.TaS1 == 3 then
      local qId1 = Que.QId1
      local soT = {}
      local sAZ = self.SAZ or self.SAQ
      local sLL = self.SLL or self.SAQ
      local sHL = self.SHL or self.SAQ
      local shF = self.ShF1 or self.SAQ
      local sOD = self.SOD and not self.SAQ
      local maI = Map:GCMI()
      local miL1 = UnitLevel("player") - GetQuestGreenRange()
      local maL2 = sHL and MAX_PLAYER_LEVEL or UnitLevel("player") + 6
      lis:ItA(0)
      lis:ItA(0)
      local dTI = lis:IGN()
      local dTN = 0
      lis:ItA(0)
      local adB
      local inc
      local sho3
      for qsI, qId in ipairs(Que.Sor) do
          local que = Que.ITQ[qId]
          if not que then
              Nx.prt("nil quest %s", qId)
          end
          local qna, sid, lvl, min5, next = Que:Unp(que[1])
          local sta, qTi = Nx:GeQ(qId)
          local qCo = sta == "C"
          if not que.CNu or que.CNu == 1 then
              adB = true
          end
          local show = sho3
          if not inc then
              show = true
              if que.CLM then
                  inc = true
              end
              if not sLL then
                  if que.CLM then
                      show = show and que.CLM >= miL1
                  else
                      show = show and ((lvl == 0) or (lvl >= miL1))
                  end
              end
              show = show and lvl <= maL2
              if show and not sAZ then
                  show = self:ChS(maI, qsI)
              end
              sho3 = show
          end
          if not Que.DaI[qId] then
              if (not shF and qCo) or sOD then
                  show = false
              end
          end
          if show then
              local lvS = format("|cffd0d0d0%2d", lvl)
              local tit = qna
              if que.CNu then
                  tit = tit .. format(" (Part %d)", que.CNu)
              end
              local tag = qCo and "(History) " or ""
              local daS1 = Que.DaI[qId] or Que.DDI[qId]
              if daS1 then
                  local typ, mon, rep, req = strsplit("^", daS1)
                  tag = format("|cffd060d0(%s %.2fg", Que.DaT[typ], mon / 100)
                  for n = 0, 1 do
                      local i = n * 4 + 1
                      local reC = strsub(rep or "", i, i)
                      if reC == "" then
                          break
                      end
                      tag = format("%s, %s %s", tag, strsub(rep, i + 1, i + 3), Que.Rep[reC])
                  end
                  if req and Que.Req[req] then
                      tag = tag .. ", |cffe0c020Need " .. Que.Req[req]
                  end
                  tag = tag .. ")"
              end
              local fiN = ""
              local sMN
              local sNa, sMI3 = Que:UnO(que[2])
              if sMI3 then
                  sMN = Map:ITN(Map.NTMI[sMI3])
                  fiN = format("%s(%s)", sNa, sMN)
              end
              local eMN
              local eNa, eMI1 = Que:UnO(que[3])
              if eMI1 then
                  eMN = Map:ITN(Map.NTMI[eMI1])
                  if sNa ~= eNa then
                      fiN = format("%s%s(%s)", fiN, eNa, eMN)
                  end
              end
              local show = true
              if self.Fil[self.TaS1] ~= "" then
                  for n = 1, 15 do
                      local obj = que[n + 3]
                      if not obj then
                          break
                      end
                      local nam, zon = Que:UnO(obj)
                      if zon then
                          fiN = fiN .. Map:ITN(Map.NTMI[zon])
                      end
                  end
                  local str = strlower(format("%2d %s %s %s", lvl, tit, fiN, tag))
                  local fiS1 = strlower(self.Fil[self.TaS1])
                  show = strfind(str, fiS1, 1, true)
              end
              if show then
                  if adB then
                      adB = false
                      lis:ItA(0)
                  end
                  dTN = dTN + 1
                  local trM = Que.Tra1[qId] or 0
                  lis:ItA(qId * 0x10000)
                  local haS = ""
                  if qId1[qId] then
                      haS = "|cffe0e0e0+ "
                  end
                  local col = Que:GetDifficultyColor(lvl)
                  col = format("|cff%02x%02x%02x", col.r * 255, col.g * 255, col.b * 255)
                  local str = format("%s %s%s%s", lvS, haS, col, tit)
                  if sQI then
                      str = str .. format(" [%s]", qId)
                  end
                  local quT1 = "@" .. qId
                  lis:ItS(2, str)
                  lis:ItS(4, tag)
                  if sNa then
                      lis:ItA(qId * 0x10000)
                      if not eNa then
                          lis:ItS(2, "     |cff6060ffStart/End: " .. sNa)
                      else
                          lis:ItS(2, "     |cff6060ffStart: " .. sNa)
                      end
                      lis:ItS(4, sMN)
                      lis:ISB("QuestWatch", false)
                      if bit.band(trM, 1) > 0 then
                          lis:ISB("QuestWatch", true)
                      end
                      lis:ISBT(quT1)
                  end
                  if eNa then
                      lis:ItA(qId * 0x10000 + 16 * 0x100)
                      lis:ItS(2, "     |cff6060ffEnd: " .. eNa)
                      lis:ItS(4, eMN)
                      lis:ISB("QuestWatch", false)
                      if bit.band(trM, 0x10000) > 0 then
                          lis:ISB("QuestWatch", true)
                      end
                      lis:ISBT(quT1)
                  end
                  for n = 1, 15 do
                      local obj = que[n + 3]
                      if not obj then
                          break
                      end
                      lis:ItA(qId * 0x10000 + n * 0x100)
                      local nam, zon, loc = Que:UnO(obj)
                      if zon then
                          lis:ISB("QuestWatch", false)
                          lis:ISBT(quT1)
                          lis:ItS(4, Map:ITN(Map.NTMI[zon]))
                      end
                      if bit.band(trM, bit.lshift(1, n)) > 0 then
                          lis:ISB(qLC[n][5], true)
                      end
                      lis:ItS(2, format("     |cff9f9faf%s", nam))
                  end
              end
          end
          if next == 0 then
              inc = false
          end
      end
      local str = (sAZ and "Full" or Map:ITN(maI)) .. " Database"
      lis:ItS(2, format("|cffc0c0c0--- %s (%d) ---", str, dTN), dTI)
      local low = max(1, sLL and 1 or miL1)
      local hig = min(MAX_PLAYER_LEVEL, maL2)
      lis:ItS(2, format("|cffc0c0c0--- Levels %d to %d ---", low, hig), dTI + 1)
  end
  if self.TaS1 == 4 then
      local qId1 = Que.QId1
      lis:ItA(0)
      lis:ItS(2, format("|cffc0c0c0--- %s %s/%s ---", Que.RPL, Que.RcC, Que.RcT))
      for n = 1, #Que.FrQ do
          local dat = Que.FrQ[n]
          local mod1 = strsub(dat, 1, 1)
          lis:ItA(0)
          if mod1 == " " then
              lis:ItS(2, strsub(dat, 3))
          elseif mod1 == "H" then
              lis:ItS(2, format("|cff8f8fff---- %s ----", strsub(dat, 3)))
          elseif mod1 == "T" then
              local _, qId, wat, don, lvl, nam = strsplit("^", dat)
              if qId and nam then
                  qId = tonumber(qId)
                  if qId >= 0 then
                      if wat ~= "0" then
                          lis:ItS(1, "|cffcfcfcfw")
                      end
                      local haS = ""
                      if qId1[qId] then
                          haS = "|cffe0e0e0+ "
                      end
                      don = don == "0" and "" or "|cff80ff80 - Complete"
                      lis:ItS(2, format("%s %s%s%s", lvl, haS, nam, don))
                  end
              end
          elseif mod1 == "O" then
              local _, qId, nam = strsplit("^", dat)
              if nam then
                  local col = don and "|cff5f5f6f" or "|cff9f9faf"
                  local str = format("     %s%s", col, nam)
                  lis:ItS(2, str)
              end
          end
      end
  end
  lis:Upd()
  Que.Wat:Upd()
  if self.TaS1 == 1 then
      local i = lis:GeS4()
      local dat = lis:IGD(i) or 0
      if dat > 0 then
          Nx.Que:SeB1(bit.band(dat, 0xff))
          NxQuestD:Show()
          Que:UQD()
      else
          NxQuestD:Hide()
      end
  end
end
function Nx.Win:Fin(nam)
  if self.Win2 then
      for win in pairs(self.Win2) do
          if win.Nam == nam then
              return win
          end
      end
  end
end
function Nx.Win:Show(show)
  local svd = self.SaD
  if show ~= false then
      self.Frm:Show()
      self.Frm:Raise()
      self.Frm:Raise()
      svd["Hide"] = nil
  else
      if self.Frm:IsShown() then
          self.Frm:Hide()
      end
      svd["Hide"] = true
  end
end
function Nx:NXMapKeyScaleRestore()
  local map = self.Map:GeM(1)
  map:M_OSR()
end
function Nx.Inf:CaS(val)
  return "|cffa0a0a0", format("%s", Nx.InS[val] or "?")
end
function Nx:GaM(id, maI, x, y)
  self:Gat("NXMine", id, maI, x, y)
end
function Nx.Map:ToS1(szm)
  if not self.Map1 then
      return
  end
  local map = self:GeM(1)
  local win = map.Win1
  if not win:IsShown() then
      win:Show()
      if szm == 0 then
          map:ReS1()
      elseif szm == 1 then
          map:MaS1()
      elseif self.GOp["MapMaxCenter"] then
          map:MaS1()
      end
  elseif szm then
      win:Show(false)
  elseif not win:ISM() then
      map:MaS1()
  else
      map:ReS1()
  end
  if Nx.ToO == win.Frm then
      GameTooltip:Hide()
      Nx.ToO = nil
  end
end
function Nx.Que.Lis:ODSS(w, h)
  local sca = Nx:GGO()["QDetailScale"]
  NXQuestLogDetailScrollChildFrame:SetScale(sca)
  local upH = NxQuestDScrollBarScrollUpButton:GetHeight()
  local bar = NxQuestDScrollBar
  local baW = bar:GetWidth()
  local det = NxQuestD
  bar:SetPoint("TOPLEFT", det, "TOPRIGHT", 1, -upH)
  det:SetWidth(w - baW - 1)
  local dw = (w - baW - 8) / sca
  Nx.Que.Lis:DSW(dw)
  if not Nx.V33 then
      NxQuestDSCObjectivesText:SetWidth(dw)
      NxQuestDSCQuestDescription:SetWidth(dw)
  end
end
function Nx.MapSetIconTip(ico, tip)
  local map = Nx.Map:GeM(1)
  map:SIT(ico, tip)
end
function Nx.Inf:ToS()
  for n = 1, 2 do
      local inf = self.Inf1[n]
      if not inf or not inf.Dat then
          self:Cre(n)
      else
          inf.Win1:Show(not inf.Win1:IsShown())
      end
  end
end
function Nx:DOE()
  local e = Nx.CuC.E
  self:DOE1(e["Info"], 100)
  self:DOE1(e["Death"], 50)
  self:DOE1(e["Kill"], 50)
  self:DOE1(e["Herb"], 20)
  self:DOE1(e["Mine"], 20)
end
function Nx.War.OT__1()
  local self = Nx.War
  if self.Ena then
      Nx.Tim:Sta("WarehouseRecProf", 0, self, self.ReP)
  end
end
function Nx.Map:AWM()
  if not self.GOp["MapWOwn"] then
      return
  end
  local f = getglobal("WorldMapButton")
  if f then
      self.WMF = f
      self.WMFP = f:GetParent()
      self.WMFS = f:GetScale()
      f:SetParent(self.TeF)
      f:Show()
      f:EnableMouse(false)
      self:SWMI(.001)
      local tip1 = getglobal("WorldMapTooltip")
      if tip1 then
          tip1:SetParent(self.Frm)
      end
      local af = getglobal("WorldMapFrameAreaFrame")
      if af then
          af:Hide()
      end
      for n = 1, NUM_WORLDMAP_POIS do
          local f = getglobal("WorldMapFramePOI" .. n)
          f:Hide()
      end
      self.WMFMI = 0
  end
end
function Nx.Inf:Upd()
end
function Nx.Tra:FiC2(maI, poX, poY)
  local Que = Nx.Que
  local Map = Nx.Map
  local con1 = Map:ITCZ(maI)
  local tr = self.Tra[con1]
  if not tr then
      return
  end
  local taT = NxCData["Taxi"]
  local clN
  local clD = 9000111222333444
  for n, nod in ipairs(tr) do
      if taT[nod.LoN] then
          local dis
          if maI == nod.MaI then
              dis = (nod.WX - poX) ^ 2 + (nod.WY - poY) ^ 2
          else
              dis = self:FiC5(maI, poX, poY, nod.MaI, nod.WX, nod.WY)
              if not dis then
                  dis = 9900111222333444
              else
                  dis = dis ^ 2
              end
          end
          if dis < clD then
              clD = dis
              clN = nod
          end
      end
  end
  if clN then
      local tex2 = "Interface\\Icons\\Ability_Mount_Wyvern_01"
      return clD ^ .5, clN, tex2
  end
end
function Nx.ToB:M_OU(ite)
end
function Nx.ToB:OnB(but1, id, cli, x, y)
  if cli == "RightButton" then
      Nx.ToB:OpM(self)
  else
      local fun = id
      if fun then
          fun(self.Use, but1, cli, x, y)
      end
  end
end
function Nx.Map:OnW(typ)
  if typ == "SizeNorm" then
      self:ReS1()
  elseif typ == "SizeMax" then
      if WorldMapFrame:IsShown() then
          HideUIPanel(WorldMapFrame)
      end
      tinsert(UISpecialFrames, self:GWN())
      self:AWM()
  elseif typ == "Close" then
  end
end
function Nx.Fav:M_OC1()
  local ite = self.CFOF
  if ite then
      self.CoB = Nx.U_TCR(ite)
  end
end
function Nx.Opt:Cre()
  local win = Nx.Win:Cre("NxOpts", nil, nil, nil, 1)
  self.Win1 = win
  local frm = win.Frm
  win:CrB(true, true)
  win:ILD(nil, -.25, -.1, -.5, -.7)
  tinsert(UISpecialFrames, frm:GetName())
  frm:SetToplevel(true)
  win:SeT(Nx.TXTBLUE .. "CARBONITE " .. Nx.VERSION .. "|cffffffff Options")
  local liW = 115
  local lis = Nx.Lis:Cre(false, 0, 0, 1, 1, frm)
  self.PaL = lis
  lis:SeU(self, self.OPLE)
  win:Att(lis.Frm, 0, liW, 0, 1)
  lis:SLH(8)
  lis:CoA("Page", 1, liW)
  for k, t in ipairs(Nx.OpD) do
      lis:ItA(k)
      lis:ItS(1, t.N)
  end
  self.PaS = 1
  Nx.Lis:SCF1("FontM", 24)
  local lis = Nx.Lis:Cre(false, 0, 0, 1, 1, win.Frm)
  self.Lis = lis
  lis:SeU(self, self.OLE)
  lis:SLH(12, 3)
  lis:CoA("", 1, 40)
  lis:CoA("", 2, 900)
  win:Att(lis.Frm, liW, 1, 0, 1)
  self:Upd()
end
function Nx.U_2R(t)
  local str = ""
  if t then
      str = "{"
      for k, v in pairs(t) do
          local kSt = k
          if type(k) == "string" then
              kSt = format("\"%s\"", k)
          end
          if type(v) == "table" then
              str = str .. format("[%s]=%s,", kSt, Nx.U_2R(v))
          elseif type(v) == "string" then
              str = str .. format("[%s]=\"%s\",", kSt, v)
          else
              str = str .. format("[%s]=%s,", kSt, v)
          end
      end
      str = str .. "}"
  end
  return str
end
function Nx.Lis:SUS()
  if self.UsF then
      self.UsF(self.Use, "select", self.Sel, 0)
  end
end
function Nx.Lis:IGDE(ind, num)
  ind = ind or self.Sel
  return ind and self.Dat[ind + num * 10000000]
end
function Nx.Que:CQSPD()
  local cnt = 0
  for cur2, cur in ipairs(self.CuQ) do
      if cur.QI > 0 then
          cnt = cnt + self:CPD1(cur.QId)
      end
  end
  if cnt > 0 then
      Nx.prt("Set %d chain quests as done", cnt)
  end
end
function Nx:NXOnUpdate(ela)
  local Nx = Nx
  if not Nx.Loa then
      return
  end
  Nx.Tic = Nx.Tic + 1
  if Nx.LoO then
      Nx:LoI1()
  end
  Nx.Tim:OnU(ela)
  Nx.Pro:OnU(ela)
  if not GameTooltip:IsVisible() then
      Nx.TLDT = nil
  end
  local s = GameTooltipTextLeft1:GetText()
  if s then
      if Nx.Tic % 4 == 1 and GameTooltipTextLeft1:IsVisible() and #s > 5 then
          if Nx.TLDT ~= s or Nx.TLDNL ~= GameTooltip:NumLines() then
              Nx.Que:ToP()
          end
      end
      Nx.TLT = s
  end
  if Nx.ToO then
      if not Nx.ToO:IsVisible() then
          if GameTooltip:IsOwned(Nx.ToO) then
              GameTooltip:Hide()
          end
          Nx.ToO = nil
      end
  end
  if self.NSP then
      local t = GetTime()
      if t > self.NPST then
          local plX, plY = GetPlayerMapPosition("player")
          if plX > 0 or plY > 0 then
              local s = format("Map~%d~%d~%d", plX * 100000000, plY * 100000000, Nx.Map:GCMI())
              Nx.prt("NetSend %s", s)
              Nx.Com:Sen("Z", s)
              self.NPST = t + 1.5
          end
      end
  end
  local com = UnitAffectingCombat("player")
  if Nx.InC ~= com then
      Nx.InC = com
      if not com and Nx.Inf and Nx.Inf.NeD then
          Nx.War:CID()
      end
  end
  Nx.Com:OnU(ela)
  Nx.Map:MOU(ela)
  Nx.Que:OnU(ela)
  if Nx.Tic % 11 == 0 then
      Nx:ReC()
  end
  Nx.Soc.PHUD:Upd()
  Nx.Soc.THUD:Upd()
  Nx.Soc:OnU()
end
function Nx.Tra.OT_1()
  local self = Nx.Tra
  self:CaT4()
end
function Nx.Que:CGC()
  local cap = Nx:GeC()
  local que1 = Nx:CaF(cap, "Q")
  local cnt = 0
  for id, str in pairs(que1) do
      cnt = cnt + 1
  end
  return cnt
end
function Nx.Com:OJCZT(nam, tim)
  self.Lis:AdI("", "OnJoinChanZTimer " .. nam)
  if self:GCC() >= 10 then
      return 5
  end
  tim.UTC = tim.UTC + 1
  local nam = format("%sZ%dI%d", self.Nam, tim.UMI, tim.UTC)
  if self:InC2(nam) then
      return
  end
  JoinChannelByName(nam)
  return 3
end
function Nx:OU__2(eve, ...)
  if arg1 == "player" then
      if arg2 == NXlOpening or arg2 == NXlOpeningNoText then
          if Nx.GaT then
              Nx.War.LoT = format("O^%s", Nx.GaT)
              Nx.GaT = nil
          end
      end
  end
end
function Nx.Men:OnU(ela)
  local self = this.NxM
  self.Alp = Nx.U_SV(self.Alp, self.AlT, ela * 4)
  this:SetAlpha(self.Alp)
  if self.Clo1 then
      if self.Alp <= 0 then
          self.Clo1 = nil
          this:Hide()
      end
      return
  end
  local x, y = GetCursorPosition()
  x = x / this:GetEffectiveScale()
  y = y / this:GetEffectiveScale()
  if x < this:GetLeft() - 1 or x > this:GetRight() or y < this:GetBottom() or y > this:GetTop() + 1 then
      if not Nx.Men.SlM then
          self.ClT = self.ClT - ela
          if self.ClT <= 0 then
              self:Clo2()
          end
      end
  else
      self.ClT = .5
  end
end
function Nx.Map:MDF1()
  local mm = self.MMF
  local mmc = getglobal("MinimapCluster")
  local win2 = self.Win1.Frm
  local doc = Nx.Map.Doc
  if doc.InP then
      return
  end
  self.MMCD = self.MMCD - 1
  if self.MMCD < 1 then
      self.MMCD = 40
      local mmN = self.AMN
      local ch = {mm:GetChildren()}
      for n = 1, #ch do
          local c = ch[n]
          if c ~= mmc then
              if c:IsShown() and not self.MMOF[c] then
                  if c:IsObjectType("Model") then
                      if self.MMO1 then
                          c:SetParent(win2)
                          self.MMOF[c] = 0
                          tinsert(self.MMM, c)
                      end
                  elseif c:IsObjectType("Frame") then
                      local nam = gsub(c:GetName() or "", "%d", "")
                      if mmN[nam] then
                          if self.MMO1 then
                              self.MMOF[c] = 0
                              self.MMAF[c] = 1
                          end
                      elseif doc.MMF1 then
                          self.MMOF[c] = 0
                          tinsert(doc.MMF1, c)
                          if c:GetNumChildren() > 0 then
                              local ch = {c:GetChildren()}
                              for k, c in ipairs(ch) do
                                  if c:IsShown() then
                                      if c:IsObjectType("Frame") then
                                          local pt, reT = c:GetPoint()
                                          if reT == mm then
                                              tinsert(doc.MMF1, c)
                                          end
                                      end
                                  end
                              end
                          end
                      end
                  end
              end
          end
      end
  end
  doc:MDF1()
end
function Nx.Lis:SeS(wid, hei)
  if wid == self.SSW and hei == self.SSH then
      return
  end
  self.SSW = wid
  self.SSH = hei
  if not self.ShA then
      self:Res1(wid, hei)
  end
  self:Upd()
end
function Nx:pSCF()
  Nx.pCF = DEFAULT_CHAT_FRAME
  local nam = Nx:GGO()["ChatMsgFrm"]
  for n = 1, 10 do
      local cfr = _G["ChatFrame" .. n]
      if cfr then
          if cfr["name"] == nam then
              Nx.pCF = cfr
          end
      end
  end
end
function Nx.Opt:SeV(vaN, val)
  local dat = Nx.OpV[vaN]
  local sco1, typ, vde, vmi, vma = strsplit("~", dat)
  local opt = sco1 == "-" and self.COp or self.Opt
  if typ == "B" then
      opt[vaN] = val
  elseif typ == "CH" then
      opt[vaN] = val
  elseif typ == "F" or typ == "I" then
      vmi = tonumber(vmi)
      if vmi then
          val = max(val, vmi)
      end
      vma = tonumber(vma)
      if vma then
          val = min(val, vma)
      end
      opt[vaN] = val
  elseif typ == "S" then
      opt[vaN] = gsub(val, "~", "?")
  elseif typ == "W" then
      local wiN, atN = strsplit("^", vde)
      Nx.Win:SetAttribute(wiN, atN, val)
  else
      return
  end
end
function Nx.Soc:PCH()
  if self.Win1 then
      if GetNumRaidMembers() > 0 then
          local ff = FriendsFrame
          self:HideUIPanel(ff)
      end
  end
end
function Nx.Map:OMU(but)
  local map = this.NxM1
  map.Scr2 = false
end
function Nx.Que:GOT1(obj)
  local loc = strbyte(obj) - 35 + 3
  local typ = strbyte(obj, loc) or 0
  if typ <= 33 then
      return 0
  end
  return 1
end
function Nx.Soc.Lis:M_OMPF()
  if self.MSN1 then
      AddFriend(self.MSN1)
  end
end
function Nx.Opt:Ope(paN)
  local win = self.Win1
  if not win then
      self:Cre()
      win = self.Win1
  end
  win:Show()
  if paN then
      for n, t in ipairs(Nx.OpD) do
          if t.N == paN then
              self.PaL:Sel1(n)
              self.PaS = n
              self.PaL:Upd()
              break
          end
      end
  end
  self:Upd()
end
function Nx.MeI:Show(show)
  self.ShS = false
  if show ~= false then
      self.ShS = (type(show) == "number") and show or 1
  end
end
function Nx.Com:ICOK(msg)
  if #msg >= 4 then
      local ck = (strbyte(msg, 3) - 65) * 16 + (strbyte(msg, 4) - 65)
      local v = 0
      local xor = bit.bxor
      for n = 5, #msg do
          v = xor(v, strbyte(msg, n))
      end
      return ck == v
  end
end
function Nx.But:SeT1(typ)
  self.Frm.NxT = self.Tip or (typ and self.TyD[typ].Tip)
  self.Typ = self.TyD[typ]
end
function Nx:GeC()
  return NxData.NXCap
end
function Nx.Tim:Sta(nam, time, use, fun)
  if not self.Dat[nam] then
      self.Dat[nam] = {}
  end
  local tm = self.Dat[nam]
  tm.T = time
  tm.U = use
  tm.F = fun
  return tm
end
function Nx.Que.Wat:SSM(mod1)
  Nx.Tim:Sta("QuestWatchUpdate", .01, self, self.OUT)
end
function Nx.Que:CPD1(qId)
  local cnt = 0
  for muI, q in pairs(Nx.Que1) do
      if q.CNu == 1 then
          local id = (muI + 3) / 2 - 7
          local qc = q
          while qc do
              if id == qId then
                  local id = (muI + 3) / 2 - 7
                  local qc = q
                  while id ~= qId do
                      local qSt = Nx:GeQ(id)
                      if qSt ~= "C" then
                          cnt = cnt + 1
                          Nx:SeQ(id, "C", time())
                      end
                      id = self:UnN(qc[1])
                      qc = self.ITQ[id]
                  end
                  break
              end
              id = self:UnN(qc[1])
              qc = self.ITQ[id]
          end
      end
  end
  return cnt
end
function Nx.TaB:OnB(but1, id, cli)
  if not but1:GeP() then
      but1:SeP2(true)
      return
  end
  self:Sel1(id, true)
end
function Nx.Map:GEON()
  for i = 1, 999 do
      local txN = GetMapOverlayInfo(i)
      if not txN then
          return i
      end
  end
end
function Nx.Que.Lis:M_OSHL(ite)
  self.SHL = ite:GetChecked()
  self:Upd()
end
function Nx.Map:M_OSR()
  local s = self.CuO.NXScaleSave
  if s then
      self.Sca = s
      self.StT = 10
  else
      Nx.prt("Scale not set")
  end
end
function Nx.Map:ReS1()
  self:MoE(true)
  if self.Win1:ISM() then
      self.Win1:ToS1()
      self:ReV("")
      self:DWM()
      if self.GOp["MapMaxRestoreHide"] then
          self.Win1:Show(false)
      end
  end
  local wna = self:GWN()
  for n, nam in pairs(UISpecialFrames) do
      if nam == wna then
          tremove(UISpecialFrames, n)
          break
      end
  end
end
function Nx:NXMapKeyTogMiniFull()
  if Nx.Fre then
      return
  end
  local map = Nx.Map:GeM(1)
  map.LOp.NXMMFull = not map.LOp.NXMMFull
  map.MMZC = true
  map.MMMIF:SetChecked(map.LOp.NXMMFull)
  Nx.Men:ChU(map.MMMIF)
end

function Nx.Map:CTO(srI, dsI)
  srI = srI >= 0 and srI or #self.Tar
  local t = tremove(self.Tar, srI)
  tinsert(self.Tar, dsI, t)
  self.Tra1 = {}
end
function Nx.Map:M_OBAF(ite)
  self.BAF1 = ite:GeS1()
end
function Nx.Win:SeU(use, fun)
  self.Use = use
  self.UsF = fun
end
function Nx.Map:MUE()
  if not self.MMO1 then
      return
  end
  local mm = self.MMF
  local mmf = self.LOp.NXMMFull
  if self.Win1:ISM() and self.GOp["MapMMHideOnMax"] or self.MMFS < .02 then
      mm:SetPoint("TOPLEFT", 1, 0)
      mm:SetScale(.02)
      mm:SetFrameLevel(1)
      for n, f in ipairs(self.MMM) do
          f:SetScale(.001)
      end
      return
  end
  if self.MMZT == 0 then
      self:MUM("MapMMDockSquare")
      local icS1 = self.GOp["MapMMDockIScale"]
      self:MSS(self.MMFS, icS1)
      local x = 0
      local y = 0
      local sz = 140 * self.MMFS
      if self.GOp["MapMMDockRight"] then
          x = (self.MaW - sz + 1)
      end
      if self.GOp["MapMMDockBottom"] then
          y = (self.MaH - sz + 1)
      end
      mm:ClearAllPoints()
      mm:SetPoint("TOPLEFT", (x + self.GOp["MapMMDXO"]) / icS1, (-y - self.GOp["MapMMDYO"]) / icS1)
      mm:Show()
      mm:SetFrameLevel(self.Lev)
      self:MUDF(self.Lev + 1)
      self.Lev = self.Lev + 2
  end
  if self.MMZC then
      self.MMZC = false
      local zoo = max(self.MMZT - 1, 0)
      if self.MMZT == 0 then
          zoo = self.GOp["MapMMDockZoom"]
      end
      local z = zoo - 1
      if z < 0 then
          z = 1
      end
      mm:SetZoom(z)
      mm:SetZoom(zoo)
      if self.MMZT == 0 then
          mm:SetAlpha(1)
      end
  end
  MinimapPing:SetScale(self.Win1.Frm:GetScale() * mm:GetScale())
end
function Nx.Que.Wat:WUF(fad2, for1)
  if self.GOp["QWFadeAll"] or for1 then
      self.Win1:STC(1, 1, 1, fad2)
      self.Lis.Frm:SetAlpha(fad2)
      self.BuM2.Frm:SetAlpha(fad2)
      self.BuP.Frm:SetAlpha(fad2)
      self.BSOM.Frm:SetAlpha(fad2)
      self.BAT1.Frm:SetAlpha(fad2)
  end
end
function Nx.Opt:NXCmdSkin(ite)
  Nx.Ski:Set(ite.Dat)
end
function Nx.Map:MiZ(val1)
  if val1 then
      self:SSOT(val1)
  end
  local f = getglobal("MinimapZoomIn")
  if f then
      f:Enable()
  end
  local f = getglobal("MinimapZoomOut")
  if f then
      f:Enable()
  end
end
function Nx.Map:M_ODRS(ite)
  self.DRS = ite:GeS1()
end
function Nx.Lis:ISBT(tip, ind, frm)
  if self.BuD then
      ind = ind or self.Num
      self.BuD[ind + 2000000] = tip
      if frm then
          self.BuD[ind + 3000000] = frm
      end
  end
end
function Nx.But:GeT1()
  return self.Typ
end
function Nx.Que.Lis:SQI(qi)
  if qi > 0 then
      self.SQIQI = qi
      self.SQIM = -1
      self.SQT = nil
      local box = Nx.FACFEB()
      if box then
          local typ = box:GetAttribute("chatType")
          if typ == "WHISPER" then
              self.SQT = box:GetAttribute("tellTarget")
              self.SQL = box["language"]
              ChatEdit_OnEscapePressed(box)
          end
      end
      Nx.Tim:Sta("QSendInfo", 0, self, self.OSQIT)
  end
end
function Nx.Inf:M_OEI()
  local inf = self.CMI
  local function fun(str, self)
      str = gsub(str, "||", "|")
      self.Dat["Items"][self.SII] = str
  end
  if inf.SII then
      local s = inf.Dat["Items"][inf.SII] or ""
      s = gsub(s, "|", "||")
      Nx:SEB("Change Text", s, inf, fun)
  end
end
function Nx.Soc:GeP1(nam, plN1, mId, x, y)
  local pun1 = self.PuA[nam]
  if not pun1 then
      pun1 = {}
      self.PuA[nam] = pun1
      pun1.DrD1 = self.PND
      self.PND = self.PND + 3.14159 / 4.25
      pun1.CiT = GetTime()
  end
  if not Nx.IBG or not pun1.PlN2 or plN1 and plN1 ~= pun1.PlN2 then
      pun1.PlN2 = plN1
      pun1.MId = mId
      pun1.X = x
      pun1.Y = y
  end
  if not pun1.Ale and self.Pun[nam] then
      self.PHUD:Add(nam)
      if self.GOp["PunkMAlertText"] then
          local tm, lvl, cla, not2 = strsplit("~", self.Pun[nam])
          if not2 then
              UIErrorsFrame:AddMessage(format("Note: %s", not2), 1, 0, 1, 1)
          end
          local map = Nx.Map:GeM(1)
          local wx, wy = map:GWP(mId, x, y)
          local dis = ((map.PlX - wx) ^ 2 + (map.PlY - wy) ^ 2) ^ .5 * 4.575
          local s = dis < 100 and "|cffff4000near you" or format("at %d yards", dis)
          UIErrorsFrame:AddMessage(format("|cffff4000%s|r detected %s!", nam, s), 1, 1, 0, 1)
      end
      if self.GOp["PunkMAlertSnd"] then
          Nx:PlaySoundFile("sound\\spells\\antiholy.wav")
      end
      pun1.Ale = true
  end
  if GetTime() - pun1.CiT > 4 then
      pun1.CiT = GetTime()
  end
  return pun1
end
function Nx.Map.Gui:ItF1()
  local fol = self:FiF("Items")
  self:IFC(fol)
  collectgarbage("collect")
end
function Nx.Que.Wat:Set(dat, on, tra3)
  local Que = Nx.Que
  local qIn = bit.band(dat, 0xff)
  local qId = bit.rshift(dat, 16)
  if qId > 0 then
      local i, cur = Que:FiC3(qId, qIn)
      if not (cur and cur.Q) then
          Que:MNIDB()
          return
      end
      local q = cur.Q
      if not q[2] and not q[3] then
          Que:MNIDB()
          return
      end
      self:CAT(true)
      local qOb = bit.band(bit.rshift(dat, 8), 0xff)
      local tbi = Que.Tra1[qId] or 0
      if tra3 then
          Que.Tra1 = {}
          tbi = 0
          if not Que:IsT(qId, qOb) then
              on = true
          end
      end
      if IsControlKeyDown() then
          on = false
      end
      if qOb == 0 then
          if on == false then
              Que.Tra1[qId] = nil
          else
              Que.Tra1[qId] = cur.TrM2
          end
      else
          if on == false then
              Que.Tra1[qId] = bit.band(tbi, bit.bnot(bit.lshift(1, qOb)))
          else
              Que.Tra1[qId] = bit.bor(tbi, bit.lshift(1, qOb))
          end
      end
      if tra3 then
          self:ClC1(qId)
      end
      Que:TOM(qId, qOb, qIn > 0, tra3)
      self:Upd()
      Que.Lis:Upd()
  else
      Que:MNIDB()
  end
end
function Nx.Win:Cre(nam, mRW, mRH, sec2, tiL, boT, hid, noB)
  local c2r = Nx.U_22
  local wd = Nx:GeD("Win")
  local svd = nam and wd[nam]
  if not svd then
      svd = {}
      if nam then
          wd[nam] = svd
      end
      svd["Hide"] = hid
      svd["FI"] = self.CFI or 1
      svd["FO"] = self.CFO or .75
  end
  local win = {}
  setmetatable(win, self)
  self.__index = self
  win.SaD = svd
  if nam then
      assert(self.Win2[win] == nil)
      self.Win2[win] = true
      win.Nam = nam
  end
  win.Sec1 = sec2
  win.BoW = self.BORDERW
  win.BoH = self.BORDERH
  win.TLH = 10
  win.TiL = tiL or 1
  win.TiH = win.TiL * win.TLH + 2
  win.ToH = win.TiH + win.BoH
  win.BuW = 0
  win.Siz = true
  win.Bor1 = true
  if boT == false then
      win.Siz = false
      win.Bor1 = false
  elseif boT == 1 then
      win.Siz = false
  end
  win.MoS = false
  win.BAM = .65
  win.BAD = .35
  win.BaF = .01
  win.BFT = 0
  win.BFI = svd["FI"]
  win.BFO = svd["FO"]
  win.ChF = {}
  local f = CreateFrame("Frame", nam, UIParent)
  win.Frm = f
  f.NxW = win
  f:SetMinResize(mRW or 100, mRH or 40)
  f:SetWidth(10)
  f:SetHeight(win.TiH + 50)
  f:SetPoint("TOPLEFT", 100, -100)
  f:SetMovable(true)
  f:SetResizable(true)
  f:SetScript("OnEvent", self.OnE)
  f:RegisterEvent("PLAYER_LOGIN")
  f:SetScript("OnMouseDown", self.OMD)
  f:SetScript("OnMouseUp", self.OMU)
  f:SetScript("OnMouseWheel", self.OMW)
  f:SetScript("OnUpdate", self.OnU)
  if not win.Bor1 then
      local t = f:CreateTexture()
      t:SetTexture(c2r("202020d8"))
      t:SetAllPoints(f)
      f.tex = t
  end
  win.TFS = {}
  for n = 1, win.TiL do
      local fst = f:CreateFontString()
      win.TFS[n] = fst
      fst:SetFontObject("NxFontS")
      fst:SetJustifyH("LEFT")
      fst:SetJustifyV("MIDDLE")
      fst:SetHeight(win.TLH)
  end
  win:STXO(0)
  if win.Bor1 then
      win:CrB1()
  end
  if not noB then
      local y = win.Siz and -win.BoH or -3
      local but1 = Nx.But:Cre(win.Frm, "Close", nil, nil, -win.BoW, y, "TOPRIGHT", 12, 12, win.OCB, win)
      win.BuC = but1
      but1.Frm:Hide()
      win.BuW = 15
  else
      win.NoB = true
  end
  win.LaM = false
  win:Loc1(svd["Lk"])
  win:Show(not svd["Hide"])
  self:SCF()
  return win
end
function Nx.Map:M_OI()
  for _, nam in pairs(Nx.Map.PlN1) do
      InviteUnit(nam)
      break
  end
end
function Nx.Gra:UpL(pos1)
  local c2r1 = Nx.U_21
  assert(pos1 ~= 0)
  local time = self.Val[-pos1]
  local x = time * self.ScX1
  if x >= 0 and x < self.Wid - 1 then
      local val1 = self.Val[pos1]
      local h = val1 / self.Pea
      if h > 1 or h < 0 then
          h = 1
      end
      h = h * self.Hei
      if h >= .1 then
          h = max(h, 4)
          local f = self:GeF3()
          f.NGP = pos1
          f:SetHeight(h)
          f:SetWidth(self.ScX1 * .25)
          f:SetPoint("BOTTOMLEFT", x, 1)
          local coS = self.Val[pos1 + 0x1000000]
          f.tex:SetTexture(c2r1(coS))
          f:Show()
      end
  end
end
function Nx.Com:SCMF(msg, typ, num)
  local s1 = strfind(msg, "|")
  if s1 then
      if strbyte(msg, s1 + 1) ~= 99 then
          msg = gsub(msg, "|", "\1")
      end
  end
  local ok = pcall(SendChatMessage, msg, typ, nil, num)
  if not ok then
      Nx.pSH(typ .. " SendChat failed", msg)
  end
end
function Nx.Com:PPS(nam, inf, msg)
  local fla = strbyte(msg, 2) - 35
  inf.F = fla
  inf.Que = nil
  local maI = tonumber(strsub(msg, 3, 6), 16)
  local win1 = Nx.Map.MWI[maI]
  if not win1 then
      inf.T = 0
      return
  end
  inf.T = GetTime()
  inf.MId = maI
  inf.EMI = maI
  if win1.EMI then
      inf.EMI = win1.EMI
  end
  inf.X = tonumber(strsub(msg, 7, 9), 16) / 0xfff * 100
  inf.Y = (tonumber(strsub(msg, 10, 13), 16) or 0) / 0xfff * 100
  inf.Hea = (strbyte(msg, 14) - 48) / 20 * 100
  inf.Lvl = strbyte(msg, 15) - 35
  inf.Cls = self.ClN[strbyte(msg, 16) - 35] or "?"
  inf.Tip = format("%s %s%%\n  %s %s", nam, inf.Hea, inf.Lvl, inf.Cls)
  local off1 = 17
  if bit.band(fla, 2) > 0 then
      inf.TTy = strbyte(msg, 17) - 35
      local col2 = self.TyC[inf.TTy] or ""
      inf.TLv = strbyte(msg, 18) - 35
      inf.TCl = self.ClN[strbyte(msg, 19) - 35] or "?"
      inf.TH = (strbyte(msg, 20) - 35) / 20 * 100
      local len = strbyte(msg, 21) - 35
      inf.TNa = strsub(msg, 22, 22 + len - 1)
      local lvl = inf.TLv
      if lvl < 0 then
          lvl = "??"
      end
      inf.TSt = format("\n%s%s %s %s %d%%", col2, inf.TNa, lvl, inf.TCl, inf.TH)
      off1 = 22 + len
  else
      inf.TTy = nil
      inf.TSt = nil
  end
  if bit.band(fla, 4) > 0 then
      local len = Nx.Que:DCR(inf, strsub(msg, off1))
      if not len then
          return
      end
      off1 = off1 + len
  else
      inf.QSt = nil
  end
  if bit.band(fla, 8) > 0 then
      Nx.Soc:DCRP(nam, inf, strsub(msg, off1 + 1))
  end
end
function Nx.Win:ILD(mod1, x, y, w, h, lay, sca)
  local dat = self.SaD
  if w > 0 then
      w = w + self.BoW
  end
  if h > 0 then
      h = h + self.BoH + self.TiH
  end
  local att
  if sca then
      if x >= 300000 then
      elseif x >= 200000 then
          att = "TOPRIGHT"
      end
  end
  if not mod1 then
      mod1 = ""
      self:SLD("_", x, y, w, h, lay, att, sca)
  end
  if not dat[mod1 .. "X"] then
      self:SLD(mod1, x, y, w, h, lay, att, sca)
  end
  if self.LoD then
      self:SetLayoutMode(1)
  end
end
function Nx.But:Ini()
  local f = CreateFrame("Frame", nil, UIParent)
  self.OvF = f
  f:SetFrameStrata("MEDIUM")
  f:Hide()
  local t = f:CreateTexture()
  t:SetTexture(Nx.U_22("101040ff"))
  t:SetAllPoints(f)
  t:SetBlendMode("ADD")
  f.tex = t
end
function Nx.War:prt1(...)
  if self.Debug then
      Nx.prt(...)
  end
end
function Nx.Soc.Lis:SeL1()
  local win = Nx.Soc.Win1
  local wf = win.Frm
  local ff = self.FriendsFrame
  ff:SetToplevel(false)
  wf:Raise()
  local f = getglobal("FriendsFrameCloseButton")
  local lev1 = f:GetFrameLevel()
  ff:SetFrameLevel(lev1 - 1)
  wf:SetFrameLevel(lev1 - 2)
end
function Nx.Lis:FrF(lis)
  local frm1 = self.Frm1
  for n, f in ipairs(lis.UsF1) do
      f:Hide()
      tinsert(frm1[f.NXListFType], n, f)
  end
  lis.UsF1 = wipe(lis.UsF1 or {})
end
function Nx.DrD:Add(nam, select)
  local lis = self.Lis
  lis:ItA(nam)
  lis:ItS(1, nam)
  if select then
      lis:Sel1(lis:IGN())
  end
end
function Nx.Soc.Lis.PSN1(tex1, lis)
  local pun = Nx:GeS("Pk")
  local pun1 = pun[lis.MPN]
  local tm, lvl, cla, not2 = strsplit("~", pun1)
  pun[lis.MPN] = format("%s~%s~%s~%s", tm, lvl, cla, tex1)
  lis:Upd()
end
function Nx.But:Upd()
  local typ = self.Typ
  if not typ then
      return
  end
  local Ski = Nx.Ski
  local f = self.Frm
  local tx = f.tex
  if self.Sta2 then
      local stT = typ[self.Sta2] or typ[1]
      local txN = self.Tx or stT.Tx or typ.Tx
      if typ.Ski then
          txN = Ski:GeT(txN)
      else
          if txN then
              if type(txN) == "string" then
                  txN = gsub(txN, "%$", "Interface\\Icons\\")
              else
                  tx:SetTexture(Nx.U_23(txN))
                  txN = nil
              end
          end
      end
      if txN then
          tx:SetTexture(txN)
      else
          local rgb = stT.RGB
          if rgb then
              tx:SetTexture(Nx.U_21(rgb))
          end
      end
      if stT.Alp then
          tx:SetVertexColor(1, 1, 1, stT.Alp)
      elseif stT.VRGBA then
          tx:SetVertexColor(Nx.U_22(stT.VRGBA))
      end
      local sz = stT.Siz2
      if sz then
          f:SetWidth(sz)
          f:SetHeight(sz)
      end
  else
      if self.Pre then
          local txN = self.Tx or typ.Dn
          if typ.Ski then
              txN = Ski:GeT(txN)
          else
              if txN then
                  if type(txN) == "string" then
                      txN = gsub(txN, "%$", "Interface\\Icons\\")
                  else
                      tx:SetTexture(Nx.U_23(txN))
                      txN = nil
                  end
              end
          end
          if txN then
              tx:SetTexture(txN)
          else
              local rgb = typ.RGBD
              if rgb then
                  tx:SetTexture(Nx.U_21(rgb))
              end
          end
          if typ.AlD then
              tx:SetVertexColor(1, 1, 1, typ.AlD)
          elseif typ.VRGBAD then
              tx:SetVertexColor(Nx.U_22(typ.VRGBAD))
          end
          local sz = typ.SiD
          if sz then
              f:SetWidth(sz)
              f:SetHeight(sz)
          end
      else
          local txN = self.Tx or typ.Up
          if typ.Ski then
              txN = Ski:GeT(txN)
          else
              if txN then
                  if type(txN) == "string" then
                      txN = gsub(txN, "%$", "Interface\\Icons\\")
                  else
                      tx:SetTexture(Nx.U_23(txN))
                      txN = nil
                  end
              end
          end
          if txN then
              tx:SetTexture(txN)
              if typ.UUV then
                  local uv = typ.UUV
                  tx:SetTexCoord(uv[1], uv[2], uv[3], uv[4])
              end
          else
              local rgb = typ.RGBU
              if rgb then
                  tx:SetTexture(Nx.U_21(rgb))
              end
          end
          if typ.AlU then
              tx:SetVertexColor(1, 1, 1, typ.AlU)
          elseif typ.VRGBAU then
              tx:SetVertexColor(Nx.U_22(typ.VRGBAU))
          end
          local sz = typ.SiU
          if sz then
              f:SetWidth(sz)
              f:SetHeight(sz)
          end
      end
  end
  local of = Nx.But.OvF
  if self.Ove then
      of:SetPoint("TOPLEFT", f, -1, 1)
      of:SetWidth(f:GetWidth() + 2)
      of:SetHeight(f:GetHeight() + 2)
      if self.Pre then
          of.tex:SetTexture(Nx.U_22("303080ff"))
      else
          of.tex:SetTexture(Nx.U_22("101040ff"))
      end
      of:SetParent(f)
      of:Show()
      Nx.But.OFO = f
  else
      if Nx.But.OFO == f then
          of:Hide()
      end
  end
  if typ.Dim then
      SetDesaturation(tx, not self.Pre)
  end
end
function Nx.Map:SLWH()
end
function Nx.Win:CLC(swd, dwd)
  if dwd.Version and (not swd.Version or swd.Version < dwd.Version) then
      Nx.prt("Window version mismatch!")
      return
  end
  self.SaD1 = true
  return true
end
function Nx.Map:MOMD(but)
  local map = Nx.Map.Map1[1]
  if (map.MMZT == 0 and but == "LeftButton") or (IsShiftKeyDown() and not IsControlKeyDown()) then
      this.NXPing = true
  else
      this.NXPing = nil
      this.NxM1 = map
      map:OMD(but)
  end
end
function Nx.Fav:B_OR(but1)
  self:SeR1(but1:GeP())
end
function Nx.Map:MoW(val1)
  local map = self
  local this = map.Frm
  if map.MMZT == 0 and Nx.U_IMO(map.MMF) then
      map.MMZC = true
      local i = map.GOp["MapMMDockZoom"]
      if val1 < 0 then
          i = max(i - 1, 0)
      else
          i = min(i + 1, 5)
      end
      map.GOp["MapMMDockZoom"] = i
      return
  end
  local x, y = GetCursorPosition()
  x = x / this:GetEffectiveScale()
  y = y / this:GetEffectiveScale()
  local lef = this:GetLeft()
  local rgt = this:GetRight()
  local top = this:GetTop()
  local bot1 = this:GetBottom()
  local ox = map.MPX + (x - lef - map.PaX - map.MaW / 2) / map.Sca
  local oy = map.MPY + (top - y - map.TiH - map.MaH / 2) / map.Sca
  map.Sca = map:ScS(val1)
  map.StT = 10
  map.MaS = map.Sca / 10.02
  local nx = map.MPX + (x - lef - map.PaX - map.MaW / 2) / map.Sca
  local ny = map.MPY + (top - y - map.TiH - map.MaH / 2) / map.Sca
  map.MPX = map.MPX + ox - nx
  map.MPY = map.MPY + oy - ny
end
function Nx.War:OLE(evN, sel, va2, cli)
  local dat = self.Lis:IGD(sel) or 0
  local id = dat % 1000
  local pro2 = self.Lis:IGDE(sel, 1)
  self.SeG = false
  self.SeP5 = false
  if (id >= 1 and id <= #Nx.ReC1) or id == 99 then
      self.SeC2 = id
  end
  if evN == "select" or evN == "mid" or evN == "menu" then
      if id == 100 then
          self.SeG = pro2
      else
          self.SeP5 = pro2
      end
      self.IOI = nil
      if evN == "menu" then
          self.Men:Ope()
      end
      self:Upd()
  elseif evN == "button" then
      self.Lis:Sel1(sel)
      self.SeP5 = pro2
      if pro2 then
          local ch = NxData.Characters[Nx.ReC1[id]]
          local prT2 = ch["Profs"][pro2]
          local frm = DEFAULT_CHAT_FRAME
          local eb = frm["editBox"]
          if eb:IsVisible() and prT2["Link"] then
              eb:SetText(eb:GetText() .. prT2["Link"])
          else
              Nx.prt("No edit box open!")
          end
      elseif id >= 1 and id <= #Nx.ReC1 then
          local ch = NxData.Characters[Nx.ReC1[id]]
          if ch then
              ch["WHHide"] = va2
          end
      elseif id == 99 then
          for cnu, rc in ipairs(Nx.ReC1) do
              local ch = NxData.Characters[rc]
              if ch then
                  ch["WHHide"] = true
              end
          end
      end
      self:Upd()
  end
end
function Nx.Map:OBTC(but1)
  Nx.Com1:Ope()
end
function Nx.Inf:CBGS1()
  if Nx.IBG then
      local cb = Nx.Com1
      return "|cffa0a0a0", format("%d %d %d +%d", cb.KBs, cb.Dea, cb.HKs, cb.Hon)
  end
end
function Nx.Win:SLD(mod1, x, y, w, h, lay, atP1, sca)
  if not Nx.Win.SaD1 then
      local dat = self.SaD
      dat[mod1 .. "A"] = atP1
      dat[mod1 .. "X"] = x
      dat[mod1 .. "Y"] = y
      dat[mod1 .. "W"] = w
      dat[mod1 .. "H"] = h < 0 and h or max(h, 40)
      if lay ~= false then
          dat[mod1 .. "L"] = lay
      end
      dat[mod1 .. "S"] = sca
  end
end

function Nx.Hel:SetText(pag)
local str
str={[[
|cffffffffWelcome to CARBONITE!|r

Open the |cff7fff7fCarboniteReadMe.txt|r file in your Carbonite AddOns directory for additional help and the user guide.

|cffefefefVisit |cff8f8fffcarboniteaddon.com |rto get the latest version or more info.|r


To the left is the page selection list. Click it to see help pages or changes in recent versions.


|cffcfcfcfOverview:|r

 UI: All windows are sizeable (select any border, click and drag) and moveable (select the top of the window, click and drag)

 CARBONITE Minimap button: Left click the (C) button to toggle the map. Right clicking will bring up the menu.

 Map: The CARBONITE map replaces the Blizzard map; if you wish to see the Blizzard map or another map press ALT + m.  Left click and drag to scroll the map around.  Use the mouse wheel to zoom in/out.  Pressing 'm' toggles between the maximized and normal size map.

 Quest Log: The CARBONITE quest log replaces the Blizzard one.  Some features are available from the menu.  Shift + click will toggle watching the quest like it did before.  Shift + click a header to watch all quests under the header.

 Quest Watch:  The quest watch window has buttons to the left of the quests and objective names.  Left clicking this will activate the tracking feature.  Shift + left click will toggle the location on/off without tracking and right click will bring up a menu.  New quests are automatically added to your watch list.

 Guide:  Left click any guide icon will display icons for the selection and track to the closest one.  Shift + left click will turn the icons on/off without tracking.  Many categories have subcategories that are selected by left clicking on the name of the item.  Click the back button at the top of the list to go back.

 Warehouse:  Log each of your characters and open the bank to capture the items in the bank.  Select "All characters" to make the item list show all items.
]],[[
There are dozens of settings you can configure and lots of ways to use Carbonite, but you really can ignore most of that stuff initially.

I would:

1 Read the help window that opens when you first sign in. Right click the Carbonite minimap button and select "Help" to see it again.

2 Drag the Carbonite map window (using the title bar) to the top right of the screen leaving a little room on the right edge.

3 Size the map window by dragging the edges.

4 Drag the Quest Watch List (title bar) to a nice spot under the map.

5 Drag the little window under (around) the Carbonite minimap button icon, so the icons start at the very top right of the screen.

6 Right click the Carbonite minimap button and select "Show Info 1 2" to get the HUD for you and your target. Select again if you don't like it to hide them.

When you start questing, you would click the purple "Auto Track" button at the top of the Quest Watch List or click a grey button on a specific quest objective to get the HUD arrow to start tracking it. Follow the arrow.
]],[[
|cffffffffWotLK Expansion:|r

When you head over to Northrend you have a choice of two starting zones - Borean Tundra & Howling Fjord.  If you take a look on the map you'll see Borean Tundra is on the southwest and Howling Fjord is on the southeast.  Both zones have quests in the 68-72 range and if you're like us you'll want to clear both zones before moving on.

Zoom in the map to the point where the POI icons turn on and you'll see we have all the flight masters.  This is a great way of ensuring you don't miss any flight paths and to locate major quest hubs.  You can also turn on quest givers in the guide to locate the various quest hubs.

Both starting areas are populated with the various profession trainers and these are also in the guide.

If you wish to travel between Borean Tundra and Howling Fjord there are two boats (turtles actually) that shuttle back and forth between neutral camps in each zone and Dragonblight.  These can easily be located by zooming in to turn on the POI icons and looking for the icons with water & bubbles.

There is a neutral city called Dalaran that will eventually become your home base.  It has portals to all the major cities and Shatrath.  You can't actually get into Dalaran (that we are aware of) until you reach level 74, upon which you pick up a quest that teleports you there.  It may be possible for mages/warlocks to port you there at a lower level but until then, when you need to go back to the "old world" to train you're stuck using the boat/zeppelin.

For Alliance there is a boat to Borean Tundra from Stormwind and a boat to Howling Fjord from Menethil Harbor.

For Horde there is a zeppelin to Borean Tundra outside of Orgrimmar and a zeppelin to Howling Fjord outside of Undercity.

Happy adventuring!
]],[[
|cffffffffKeyboard modifiers|r

Map:

Shift down - Makes player arrow small. Draws BG objectives on top
Shift left click - Pings Minimap if near player
Ctrl left click - Sets goto
Shift Ctrl left click - Adds goto
Alt down - Shows player icon names and makes icons draw on top
Alt right click - Map shows current zone

Minimap (in Carbonite map):

Shift click - Pings
Ctrl down - Makes integrated Minimap draw on top or bottom if already on top
Alt down - Makes docked transparency 50%

List:

Shift down - Makes mouse wheel scroll 5 times faster
Shift + ctrl down - Makes mouse wheel scroll 100 times faster

Quest Watch:

Alt left click button - Send quest status to party or whisper

Key Bindings you can set:

Toggle Original Map
Toggle Normal or Max Map
Toggle None or Max Map
Toggle None or Normal Map
Restore Saved Map Scale
Toggle Full Size Minimap
Toggle Favorites
Toggle Guide
Toggle Warehouse
Toggle Watch List Minimize
]],[[
|cffffffffMap Icons|r

Round solid icons are players:

Yellow - friend
Green - guild
Blue - party
Grey - non of the above

Top Horizontal Bar - player health
Mid Horizontal Bar - friendly target health
Left Vertical Bar - enemy health (red glow if a player)
x in center - in combat
red in center - health low
black in center - dead

Round icons with black centers are for quests:

White - quest ender if quest is simply to get to the end location

By default there are 12 quest colors. Each quest starting at the top of the quest log has a different color. Once the 12 colors are used it repeats.

Red - first quest in quest log
Green - second quest in quest log
Blue - third quest in quest log
Yellow - forth quest and so on

If "Use one color per quest" is off then
 Red - objective 1 or 4
 Green - objective 2 or 5
 Blue - objective 3 or 6

Yellow ! - quest starter when you add a goto quest giver
Yellow ? - quest ender

Square icons with 4 black arrows are the closest point to reach a quest area:

White color - is being tracked
Non white colors match the same quest colors as described above.
]],[[
|cffffffffChanges: 3.34|r

Fixed errors from game changes to chat edit box.
Fixed error using "Send Quest Status To Party" while typing a whisper.
Fixed Warehouse character time played not being updated by login.
]],[[
|cffffffffChanges: 3.33|r

Fixed a random error when Watch List auto tracking in on.
Fixed setting minimap tracking dots to default on login, which can interfere with other addons.
Fixed error when Accountant Classic is closed.
Fixed Northrend minimap detail graphics.
Fixed error if HealBot toggles map on load.
Fixed error from drawing a player icon without a position.
Fixed error if player status has invalid y.
Fixed error if tracked achievement is missing the name.
]],[[
|cffffffffChanges: 3.32|r

Added CarboniteItems addon. Contains information on 25000 game items.
Added CarboniteItems section to the CarboniteReadMe.txt file.
Added item categories to Guide. Click "Items >>" to view the CarboniteItems data.
Added Guide menu command "Add Goto Quest" for items that come from a quest.
Added sorting by column to Guide list headers when left clicked.
Changed list headers so you must hold shift key when left or right clicking a column to change width.
Increased the Guide right side width and size of default window layout.
Moved Guide Visted Vendor item level to column 3.
Moved Guide Zone level to column 3 and fixed default zone sorting.
Added 37 mailboxes to Guide.

Added use of Blizzard quest data for quests which are missing from the Carbonite database.

Added instance maps for Trial of the Champion, Trial of the Crusader, The Forge of Souls, Pit of Saron, Halls of Reflection and Icecrown Citadel.
Added required skill level to map tooltip for herb and mine nodes.
Added "Minimap herb/ore dot glow delay (0 is off)" minimap option. Default is .4. 0 uses Blizzard's dot graphics.
Added "Reverse Targets" to map route menu.

Changed BG xp gained message to not show if zero.
Added "Toggle High Watch Priority" to quest list popup menu. Forces quest to top of Watch List.
Added Time Remaining line to quests in Watch List that have a timer. Timed quests set to high watch priority.
Added item level after equipped items names in Warehouse.

Improved TomTom emulation. Tested with GatherMate, HandyNotes, LightHeaded, Routes, Tour Guide.
Improved Cartographer Waypoint emulation, but may not work for some addons, so use TomTom emulation if possible.

Fixed error leaving arena if a score update never happened.
Fixed Watch List quest item keybinding being set repeatedly if key not assigned.
Fixed Watch List not auto watching low level quests which were auto accepted.
Fixed rare error adding a goto quest.
]],[[
|cffffffffChanges: 3.31|r

Added "Remove All" and "Get Completed From Server" commands to quest history popup menu.
Added one time message for each character to get quest history. Removed auto fetching.
Added "Details background color" and "Details text color" Quest options.
Added "Details scale" Quest option. Default is .95. Previouly it was always 1.
Reduced send rate of status data when in combat in an instance.
Added Threat% info window command and <Threat%;player> to info 1 defaults after health value.
Added IfLTOrCombat info window command and changed info 1 defaults to use it and show health/mana percents.
Added "Show tracked achievements. Hide Blizzard's watch list" Quest Watch option. On by default.

Fixed the new minimap LFG button not showing in minimap button window.
Fixed item retrieval so it only asks server for an item once. Visited vendor deletes item if still missing after 10 minutes.
Fixed game world map in small mode having parts of it scaled full size.
Fixed map detail graphics in sections of Northrend.
Fixed info windows health and mana bars being shifted.
]],[[
|cffffffffChanges: 3.3|r

Added fetching of completed quests from server on login and adding them to quest history.
Added "Update completed quest history on login" Quest option.
Added Quest Watch List option "Objective text length to wrap lines". Default is 60. Not used by the fixed sized mode.

Fixed errors from Blizzard quest log changes.
Fixed rare map error calling SetMapZoom.
]],[[
|cffffffffChanges: 3.23|r

Added battleground total +xp and xp per hour event message.
Changed "Gather Icons At Scale" minimum to .01.

Fixed error using quest item key binding if no items.
Fixed slider being shown when fixed size Watch List is minimized.
Fixed battleground xp and honor event messages not showing generic gains.
Fixed French name of Hrothgar's Landing.
Fixed routing calculation for normal fying mount speed, which is now faster.
Fixed routing to check for Cold Weather Flying instead of level 77.
Fixed map ping problems of wrong location, scale, disappearing too quickly or not visible.
Fixed QuestQuru zoning problems. Error message and some zoning false quest completes (hacked to check for -1 level quests).
]],[[
|cffffffffChanges: 3.22|r

Added and updated dozens of quests.

Added the number of nodes remaining to route names.
Added "Lock punk target button window" to "Social & Punks" options page.
Added Map Menu section to readme file.
Removed 2 old quests from dailies.
Added the 6 Jewelcrafting, 4 Cooking and 5 Fishing Dalaran quests to dailies data.
Added 18 WotLK dungeon dailies to dailies data.
Made quest givers for dungeon dailies use ! icon on map.
Made quest givers tooltip show quest levels in light gray.

Fixed German names of Dalaran map sub zones for sewer.
Fixed HUD arrow not updating if map is hidden from combat.
Fixed LightHeaded alignment with Blizzard quest log.
Fixed Watch List items not working or showing errors when Blizzard Quest Log has collapsed headers, by always expanding headers.
]],[[
|cffffffffChanges: 3.21|r

Added "Add Note" item to the popup menus for general and quest map icons.
Added red pulse to Punk Button List background on activity of each punk.
Added right click of Punk Button to remove from button list.
Added shift right click of Punk Button to add to your Punks List.
Added 30 second removal of active punks when in BGs.
Added "Show questing achievement for zone" Quest Watch option.
Added "Quest Giver Higher Levels To Show" to Watch List Priorities menu.
Added "Sort," before three names in Watch List Priorities menu.
Added "Carbonite private server error" message if on an old WoW build.

Fixed taint error caused by setting "Hide In Combat" on the Punks Button Window.
Fixed Quest Watch "Hide when in a raid group" being shown by "Hide In Combat".
Fixed error if a player status message has an unknown class.
Fixed header collapse/expand problems with Blizzard Quest Log.
Fixed wrong quest details showing if quests collapsed in Blizzard Quest Log.
Fixed Watch List Share and Abandon failing if quests collapsed in Blizzard Quest Log.

Changes for patch 3.2:

Fixed map detail graphics of Northrend.
Fixed "Abandon" in Quest Window not showing the dialog box.
Fixed Social Window sometimes not closing with Esc key and reopening randomly.
Fixed missing translations for Hrothgar's Landing and Isle of Conquest
]],[[
|cffffffffChanges: 3.201|r

Added German Argent Tournament Grounds flight master.
Enabled routing using Dalaran flight master.

Fixed non instance notes drawing off the top of the world.
Fixed error if a quest has no header or quest header has no title.
Fixed error if GuildProfiler loaded.
Fixed error if a player status message has an unknown target class.

|cffffffffChanges: 3.20|r

Added support for WotLK instance map art drawn on Carb map at instance entry.
  Multi level instances tile vertically and use extended Y coordinates.
  Favorites can be set in instances.
  Atlas maps now tile the same, support favorites and have virtual coordinates.

Improved player status communication:
  Player level and class sent and shown in icon tooltips.
  Instance position shared and displayed.
  Code optimized and legacy code removed.
  Players need Carbonite 3.2+ to see each other on map.

Added winshow console command to show, hide or toggle windows.
Reduced general garbage accumulation by 90%.

Fixed map zone selection staying disabled when Esc key used to close a menu.
Fixed collapsed quest headers in Blizzard log being expanded.
Fixed Watch List quest item keybinding being set and frames being swapped on each update.
Fixed an error from quest tracking that could happen on login.

Changes for patch 3.2:

Added support for Hrothgar's Landing zone.
Added support for Isle of Conquest zone.

Fixed error from rename of GetDifficultyColor.
Fixed error from missing function UnitIsPlusMob.
Fixed Blizzard quest log detail frame sometimes showing.
Fixed Info window BG cancel time always showing 0.
]],[[
|cffffffffChanges: 3.13|r

Updated a few quests.

Added check on login of current quests to mark previous quests in their quest chain as complete.
Made checking a quest in the "Quest Completion..." menu also set previous quests in their chain as complete.
Changed color of "Quest Completion..." menu items from blue to green for a quest you have.
Made map "Quest Completion..." menu update as items are checked.
Changed map "Quest Info..." menu to "Quest Info (shift click - goto)...". Holding shift key makes a goto quest.

Added "Link Quest (shift right click)" to Watch List tracking button menu.
Disabled routing while on a taxi.
Added "Gather Icons At Scale" to map Scale menu.
Added "Item button scale (0 hides)" and "Item button transparency" to Quest Watch options page.
Added "Put objective counts before objective names" to Quest Watch options page.

Fixed error if bad player status message received.
Fixed group and heroic quest tags not found on German clients.
]],[[
|cffffffffChanges: 3.12|r

Updated over 100 quests.
Added 2 first aid trainers to Guide.
Added 1138 herb and 1275 ore locations to CarboniteNodes.
Added remapping of titanium, rich saronite, gold and silver to their base ore type.
Added remapping of icethorn to lichbloom herb.
Added fadeout animation to nodes within 80 yards.

Added "Play target reached sound" setting to Tracking HUD options page.
Made docked minimap zoom a saved setting.
Changed "Show punk detections in Shattrath or Dalaran" option to "Show punk detections in safe areas".
Changed HUD arrow target button graphic to a solid circle.
Moved Watch List quest item buttons left and up. Made buttons 40% bigger and semi transparent.

Fixed taint errors in combat from setting Watch List item keybinding.
Fixed Watch List item error that could happen when turning in a quest.
Fixed disabled punk detections still showing in Dalaran Underbelly.
Fixed Wintergrasp zone graphic on French and Spanish clients.
]],[[
|cffffffffChanges: 3.11|r

Added over 200 quests.
Added Argent Tournament Flight Master, Innkeeper and Mailbox.
Added Icecrown map overlay for Argent Tournament.

Change a few map default settings. A one time reset to map defaults will happen on login.
  Defaults: Minimap Transparency .1, Details At Scale 2

Changed map background color to a mostly transparent black.
Changed when Alt key down to make minimap transparency 1 and force update.
Added "Minimap icon/dots scale" and "Minimap dock icon/dots scale" to Map Minimap options page.
Changed default map arrow size back to 32 and removed arrow shift.
Added map support for Dalaran Underbelly.

Changed Watch "Hide when in a raid group" to only do the hide/show when your "in raid" status changes.
Added alt left click of Carbonite minimap button to toggle the Watch List visibility.
Added mouse wheel support to menu sliders. Holding shift key moves x10.
Improved /carb winpos and winsize commands to accept any Carbonite window name. Case insensitive.
Added quest item buttons on Watch List.
Added "Use Top Quest Watch Item" key binding.
Remove hiding of Blizzard watch list.
Added "Modify game objective settings: Instant, no auto watch" to Quest Watch options page.
Added Northrend and Outland quest achievement info in Watch List for selected zone and in maximized map title.

Fixed minimap icons changing size as minimap scaled.
Fixed docked minimap icons being too small.
Fixed erratic speed display.
Fixed Northrend minimap detail graphics.
Fixed minimap zoom in/out key bindings not zooming Carbonite map.
Fixed stray Icecrown blimps in selected zone, when player in Icecrown.
Fixed minimap ping location.
Fixed Wintergrasp zone graphic on German client.
Fixed restore map scale happening when "Auto Scale" is off.
Fixed Warehouse info not showning in item tooltip if item has quest info.
]],[[
|cffffffffChanges: 3.10|r

Changed interface versions so addons will not show as "Out of date".
Changed Watch List "Quest Giver Lower Levels To Show" default to 80.
Added info on using the Info Windows to the CarboniteReadMe.txt file.
Added Ulduar instance location.
Increased default map arrow size and slightly shifted the position.
Added Wintergrasp wait time to Info #4 defaults.
Added Nx.HUDGetTracking() for addons to get Carbonite TrackDir, TrackDistYd and TrackName.

Fixed error when enabling Show Auction Buyout Per Item.
Fixed error if quest objective type is wrong.
Fixed error comparing quest objectives if objective was missing.
Fixed Carbonite map arrow not following player facing in patch 3.1.
Fixed map error when a zone has battlefield vehicles in 3.1.
Fixed Blizzard watch list being shown in 3.1.
Fixed Naxxramas, Halls of Stone and Halls of Lightning instance locations.
Fixed map showing middle of ocean on login when not in BGs.
]],[[
|cffffffffChanges: 3.001|r

Fixed lockups from old security code.

|cffffffffChanges: 3.00|r

Changed default to not have minimap put inside Carbonite map.
Added one time login message that asks to put minimap inside Carb map.
Added warning message if Cartographer 3 detected.
Replaced expiration with nag if version is old.
]],}
self.FSt:SetText(str[pag])
end
function Nx.Map.Gui:B_OB()
self:Bac()
end
function Nx.Inf:CLT()
local ch=Nx.CuC
local lvl=tonumber(ch["Level"] or 0)
if lvl<MAX_PLAYER_LEVEL then
local lvH=difftime(time(),ch["LvlTime"])/3600
local xp=max(1,ch["XP"]-ch["LXP"])
local lvT=(ch["XPMax"]-ch["XP"])/(xp/lvH)
if lvT<100 then
return "",format("%.1f",lvT)
end
return "|cff808080","?"
end
end
function Nx.Hel.Lic:SetText()
local str=
[[
Copyright 2007-2010 Carbon Based Creations, LLC

LICENSE AGREEMENT

PLEASE READ THIS END USER LICENSE AGREEMENT ("AGREEMENT") CAREFULLY AND MAKE SURE YOU UNDERSTAND IT. 
The accompanying executable code version of CARBONITE and related documentation ("Software") is made available under the terms and conditions of this Agreement. IF YOU CLICK "ACCEPT" OR YOU INSTALL OR USE THE PRODUCT, YOU CONSENT TO BE BOUND BY THIS AGREEMENT. IF YOU DO NOT AGREE TO THE TERMS HEREIN, DO NOT CLICK "ACCEPT" AND DO NOT INSTALL OR USE THIS PRODUCT.

LICENSE.  The Software is protected by copyright laws, trade secret, and international copyright treaties, and is being licensed to You according to the terms of this Agreement.  Carbon Based Creations, LLC ("Company") grants to You a non-exclusive and non-transferable right to install and use a copy of the Software for Your personal, non-commercial home entertainment use on one personal computer.  The Software made available under this Agreement is licensed, not sold, to You by Company.  Company reserves all rights not expressly granted under this Agreement.

Except to the extent that Company otherwise authorizes You in writing, the following restrictions shall apply:

(1) You may not use the Software for any commercial purposes, including resale, rental, lease, display, or offering on a pay-per-play or other for-charge basis.  You may not sub-license the rights provided to You.  

(2) The Software (in both object and source code forms) constitutes valuable trade secret information of Company, and You may not reverse-engineer, decompile or disassemble the Software or otherwise attempt to gain access to the source code for the Software.  

(3) You may make a single archival copy of the Software to the extent permitted by law.  You may not otherwise reproduce the Software, or modify or distribute all or any portion of the Software. You shall not provide copies of the Software to any other party.  You may not create derivative works from the Software. 

(4) No right, title or interest in or to any trademark, service mark, logo or trade name of Company or of any third parties is granted under this Agreement.  You may not remove or alter any trademark, logo, copyright, or other proprietary notice(s) on the Software.  

TERMINATION:  This Agreement is effective until terminated. If You breach this Agreement, the license and Your right to use the Software will terminate immediately and without notice, but all other terms of this Agreement will survive termination and continue in effect.  Upon termination, You will immediately cease using the Software and You must destroy all copies of the Software in Your possession or control.    

EXPORT.  You agree that You will not export the Software or any part thereof, except in accordance with all applicable U.S. export restrictions.

U.S. GOVERNMENT RESTRICTED RIGHTS.  The Software is commercial computer software and documentation developed by Company and belonging solely to Company.  If the Software is acquired by or on behalf of the U.S. Government or by a U.S. government prime contractor or a subcontractor, then the Government's rights in the Software will be only as set forth in this Agreement; this is in accordance with 48 C.F.R. 227.7202-4 or successor regulation (for Department of Defense (DOD) acquisitions) and with 48 C.F.R. 2.101 and 12.212 or successor regulation (for non-DOD acquisitions).  

GOVERNING LAW AND VENUE.  This Agreement is governed by the laws of the State of Illinois, excluding its choice of law rules.  The United Nations Convention on Contracts for the International Sale of Goods shall not apply.  In any action or suit to enforce any right or remedy under this Agreement or to interpret any of its provisions, the state or federal courts located in the State of Illinois shall have exclusive jurisdiction over any such suit or action, and You hereby agree to submit to the jurisdiction of such courts.

NO WARRANTY.  YOU ACKNOWLEDGE AND AGREE THAT THE SOFTWARE IS PROVIDED "AS IS", "AT YOUR OWN RISK", AND WITHOUT WARRANTY OF ANY KIND.   TO THE FULLEST EXTENT PERMITTED BY LAW, COMPANY HEREBY DISCLAIMS ALL EXPRESS AND IMPLIED CONDITIONS, REPRESENTATIONS AND WARRANTIES, INCLUDING BUT NOT LIMITED TO ANY IMPLIED WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE OR NON-INFRINGEMENT OF ANY THIRD PARTY RIGHTS WITH RESPECT TO THE SOFTWARE.  COMPANY DOES NOT WARRANT THAT THE SOFTWARE IS ERROR-FREE OR THAT ACCESS TO THE SOFTWARE WILL BE UNINTERRUPTED AND WITHOUT COMPROMISE TO SECURITY SYSTEMS.   

LIMITATION OF LIABILITY.  YOU ACKNOWLEDGE AND AGREE THAT TO THE FULLEST EXTENT PERMITTED BY LAW, COMPANY WILL NOT BE LIABLE FOR ANY LOST REVENUE, LOST PROFIT, BUSINESS INTERRUPTION, LOSS OF BUSINESS OR CONFIDENTIAL INFORMATION OR LOSS OF DATA, COMPUTER MALFUNCTION, OR FOR ANY DIRECT, SPECIAL, INDIRECT, CONSEQUENTIAL, INCIDENTAL OR PUNITIVE DAMAGES, HOWEVER CAUSED AND REGARDLESS OF THE THEORY OF LIABILITY, ARISING OUT OF OR RELATED TO THE USE OF OR INABILITY TO USE OR IN CONNECTION WITH THE SOFTWARE, EVEN IF COMPANY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES AND WHETHER OR NOT SUCH DAMAGES ARE FORESEEABLE.  IN NO EVENT WILL COMPANY'S LIABILITY TO YOU, WHETHER IN CONTRACT, TORT (INCLUDING NEGLIGENCE), OR OTHERWISE, EXCEED THE AMOUNT, IF ANY, PAID BY YOU FOR THE SOFTWARE UNDER THIS AGREEMENT.  THE FOREGOING LIMITATIONS WILL APPLY EVEN IF THE ABOVE STATED WARRANTY FAILS OF ITS ESSENTIAL PURPOSE.  BECAUSE SOME STATES AND/OR JURISDICTIONS DO NOT ALLOW THE EXCLUSION OR LIMITATION OF LIABILITY FOR CONSEQUENTIAL OR INCIDENTAL DAMAGES, THE ABOVE LIMITATION MAY NOT APPLY TO YOU, AND YOU MAY ALSO HAVE OTHER LEGAL RIGHTS THAT VARY FROM STATE TO STATE.

SEVERABILITY/NO WAIVER.  If any provision of this Agreement is held to be unenforceable, this Agreement will remain in effect with the provision omitted, unless omission would frustrate the intent of the parties, in which case this Agreement will immediately terminate.  Failure to enforce any provision of this Agreement is not a waiver of future enforcement of that or any other provision.

Click a button below to "Accept" or "Decline".
]]
self.FSt:SetText(str)
end
function Nx.Map.Gui.OM_1()
  local self = Nx.Map.Gui
  if not Nx.Fre and self.CaC4 then
      Nx.Tim:Sta("Vendor", .3, self, self.CaT3)
  end
end
function Nx.War:UpP()
  local lis = self.ItL
  lis:Emp()
  local cn1 = self.SeC2
  local rc = Nx.ReC1[cn1]
  local ch = NxData.Characters[rc]
  local rna, cna = strsplit(".", rc)
  local pna = self.SeP5
  lis:CSN(3, format("%s's %s Skills", cna, pna))
  local prT3 = ch["Profs"]
  local prT2 = prT3[pna]
  if prT2 then
      local ite1 = {}
      for id, itI in pairs(prT2) do
          if type(id) == "number" then
              local nam = GetSpellInfo(id)
              local iNa, iLi, iRa, iLv, iML, iTy, iST1, iSC, iEL = GetItemInfo(itI)
              nam = iNa or nam or "?"
              local cat1 = ""
              if self.SIC then
                  cat1 = iTy or ""
              end
              local soS = ""
              if self.SBS2 and iTy == ARMOR and iEL then
                  local loc = getglobal(iEL) or ""
                  nam = format("%s - %s", loc, nam)
                  soS = format("%s%s", loc, soS)
              end
              tinsert(ite1, format("%s^%s%02d^%s^%s", cat1, soS, iML or 0, nam, id))
          end
      end
      sort(ite1)
      local fiS = strlower(self.EdB:GetText())
      local cuC = ""
      for _, str in ipairs(ite1) do
          local cat1, _, nam, id = strsplit("^", str)
          local id = tonumber(id)
          local lin = GetSpellLink(id)
          local iNa, iLi, iRa, iLv, iML, iTy, iST1, iSC, iEL, iTx
          local col2 = ""
          local itI = -id
          if prT2[id] > 0 then
              itI = prT2[id]
              Nx.Ite:Loa1(itI)
              iNa, iLi, iRa, iLv, iML, iTy, iST1, iSC, iEL, iTx = GetItemInfo(itI)
              if iRa then
                  iRa = min(iRa, 6)
                  col2 = iRa == 1 and "|cffe7e7e7" or ITEM_QUALITY_COLORS[iRa]["hex"]
              end
          end
          local iSt = col2 .. nam
          if iML and iML > 0 then
              if iML > UnitLevel("player") then
                  iSt = format("%s |cffff4040[%s]", iSt, iML)
              else
                  iSt = format("%s |cff40ff40[%s]", iSt, iML)
              end
          end
          local show = true
          if fiS ~= "" then
              local lst = strlower(iSt)
              show = strfind(lst, fiS, 1, true)
          end
          if show then
              if cat1 ~= cuC then
                  cuC = cat1
                  lis:ItA(0)
                  lis:ItS(3, format("---- %s ----", cat1))
              end
              lis:ItA(itI)
              lis:ItS(3, iSt)
              if lin then
                  lis:ISB("WarehouseItem", false, iTx, "#" .. lin)
              end
          end
      end
  else
      lis:ItA(0)
      lis:ItS(3, format("|cffff1010No data - open %s window", pna))
  end
  lis:Upd()
end
function Nx.Win:IMOS()
  return self.MoS
end
function Nx.Opt:NXCmdInfoWinUpdate()
  if Nx.Inf then
      Nx.Inf:OpU()
  end
end

function Nx.Map:CTB()
  local bar = Nx.ToB:Cre(self:GWN() .. "TB", self.Frm, 22, true, true)
  self.ToB = bar
  bar:SeU(self)
  local dat = {{"MapZIn", "Zoom In", self.OBZI, false}, {"MapZOut", "Zoom Out", self.OBZO, false},
               {"MapFav", "-Favorites-", self.OBTF, false}, {"MapGuide", "-Guide-", self.OBTG, false},
               {"MapWarehouse", "-Warehouse-", self.OBTW, false}, {"MapCombat", "-Combat-", self.OBTC, false},
               {"MapEvents", "-Events-", self.OBTE, false}}
  for i, b in ipairs(dat) do
      if Nx.Fre and i > 3 then
          break
      end
      bar:AdB(b[1], b[2], nil, b[3], b[4])
  end
  bar:Upd()
  self:UTB()
end
function Nx.UEv:AdH(nam)
  local maI, x, y = self:GPP()
  local id = Nx:HNTI(nam)
  if id then
      Nx:AHE(nam, Nx:Tim1(), maI, x, y)
      Nx:GaH(id, maI, x, y)
  end
  self:UpA(true)
end
function Nx.NXMiniMapBut:M_OO()
  Nx.Opt:Ope()
end
function Nx.Soc.Lis.PAA(nam, lis)
  lis:PuA1(nam)
  lis:Upd()
end
function Nx.Fon:GeO(nam)
  return self.Fon1[nam].Fon
end
function Nx.AuA:OLE(evN, sel, va2, cli)
  local nam = self.Lis:IGD(sel)
  Nx.prt("%s", nam)
  BrowseName:SetText(nam)
  AuctionFrameBrowse_Search()
end
function Nx.Inf:CIT1(vaN)
  if self.Var[vaN] then
      return "", ""
  end
end
function Nx.Win:CrB1()
  local c2r = Nx.U_22
  local Ski = Nx.Ski
  local bk = Nx.Ski:GetBackdrop()
  self.Frm:SetBackdrop(bk)
end
function Nx.But:SetText(tex1, x, y)
  local fst = self.FSt
  if strbyte(tex1) ~= 124 then
      tex1 = "|cffffbfaf" .. tex1
  end
  fst:SetText(tex1)
  if x then
      fst:SetPoint("CENTER", x, y + 1)
  end
end
function Nx.Com:SVT()
  if UnitAffectingCombat("player") or UnitIsAFK("player") then
      return 5
  end
  local las1 = NxData.NXVerT
  local tm = time()
  if not las1 or difftime(tm, las1) > 4 * 3600 then
      local map = Nx.Map:GeM(1)
      if map.InI then
          return 60
      end
      NxData.NXVerT = tm
      self:SVM()
  end
  return 60
end
function Nx.Inf:CaH()
  return "|cffc0c0c0", format("%d", self.Var["Health"])
end

function Nx.Map:TOU()
  local maI = self:GCMI()
  self:ClT1()
  local wzo = self:GWZ(maI)
  if wzo and wzo.Cit then
      return
  end
  local ove1 = self.CuO1
  if not ove1 then
      return
  end
  for txN, whS in pairs(ove1) do
      local oX, oY, txW, txH = strsplit(",", whS)
      oX = tonumber(oX)
      oY = tonumber(oY)
      if oX >= 0 then
          txW = tonumber(txW)
          txH = tonumber(txH)
          if txW == 512 then
              txW = txW * .75
          end
          if txH == 512 then
              txH = txH * .75
          end
          local x, y = (oX + txW / 2) / 1002 * 100, (oY + txH / 2) / 668 * 100
          self:STXY(maI, x, y, "Explore", true)
      end
  end
end

function Nx.Lis:Sel1(ind)
  assert(ind >= 0 and ind <= self.Num)
  self.Sel = ind
  if ind < self.Top then
      self.Top = max(ind, 1)
  elseif ind >= self.Top + self.Vis then
      self.Top = max(ind - self.Vis + 1, 1)
  end
end

function Nx.Gra:Cre(wid,hei,paF)
  local c2r=Nx.U_22
  local g={}
  g.Clear=self.Clear
  g.SeL=self.SeL
  g.UpL=self.UpL
  g.SeP=self.SeP
  g.UpF=self.UpF
  g.ReF=self.ReF
  g.GeF3=self.GeF3
  local f=CreateFrame("Frame",nil,paF)
  g.MaF=f
  f.NxG=g
  f.NSS=self.OSS
  f:EnableMouse(true)
  f:SetFrameStrata("MEDIUM")
  f:SetWidth(wid+2)
  f:SetHeight(hei+2)
  f:SetPoint("TOPLEFT",0,0)
  local t=f:CreateTexture()
  t:SetTexture(c2r("202020a0"))
  t:SetAllPoints(f)
  f.tex=t
  f:Show()
  g.Wid=wid
  g.Hei=hei
  g.ScX1=8
  g.Frm1={}
  g:Clear()
  local sf=CreateFrame("Slider",nil,f,"NxSliderFrame")
  g.SlF=sf
  sf.NxG=g
  local bd={
    ["bgFile"]="Interface\Buttons\UI-SliderBar-Background",
    ["edgeFile"]="Interface\Buttons\UI-SliderBar-Border",
    ["tile"]=true,
    ["tileSize"]=8,
    ["edgeSize"]=8,
    ["insets"]={["left"]=3,["right"]=3,["top"]=6,["bottom"]=6}
  }
  sf:SetBackdrop(bd)
  sf:SetOrientation("HORIZONTAL")
  sf:SetFrameStrata("MEDIUM")
  sf:SetWidth(100)
  sf:SetHeight(10)
  sf:ClearAllPoints()
  sf:SetPoint("BOTTOMLEFT",0,-11)
  sf:SetMinMaxValues(1,25)
  sf:SetValueStep(.5)
  sf:SetValue(g.ScX1)
  sf:SetScript("OnValueChanged",Nx.Gra.SS_OVC)
  sf:Show()
  return g
end
function Nx.Map:M_OTP(ite)
  for _, nam in pairs(Nx.Map.PlN1) do
      self.TrP[nam] = true
  end
end

function Nx.Fav:GetParent(ite, fol)
  fol = fol or self.Fol
  for _, it in ipairs(fol) do
      if it == ite then
          return fol
      end
      local typ = it["T"]
      if typ == "F" then
          local v = self:GetParent(ite, it)
          if v then
              return v
          end
      end
  end
end

function Nx.Pro:Ini()
  self.Pro1 = {}
  self.TiL1 = 0
end


function Nx.War.ImD()
  local self = Nx.War
  local dna = UnitName("player")
  if Nx:CCD(self.ImC, dna) then
      ReloadUI()
  end
end
function Nx.Ut_1(t)
  local n = 0
  if t then
      for k, v in pairs(t) do
          n = n + 1
          if type(v) == "table" then
              n = n + Nx.Ut_1(v)
          end
      end
  end
  return n
end
function Nx.Map:IIT(icT, drM, tex, w, h)
  local d = self.Dat
  local t = wipe(d[icT] or {})
  d[icT] = t
  t.Num = 0
  t.Ena = true
  t.DrM = drM or "ZP"
  t.Tex1 = tex
  t.W = w
  t.H = h
  t.Sca = 1
  t.ClF1 = self.CFW
end
function Nx.Com:Dec(msg)
  local s = {}
  s[1] = strsub(msg, 1, 2)
  for n = 3, #msg do
      s[n - 1] = strchar(strbyte(msg, n) + 1)
  end
  return table.concat(s)
end
function Nx.NXWatchKeyToggleMini()
  local self = Nx.Que.Wat
  self.Win1:ToM()
  self:Upd()
end
function Nx.War:GuR(ope)
  local gNa1 = GetGuildInfo("player")
  if gNa1 then
      local war = NxData.NXWare
      local rn = GetRealmName()
      local rnG = war[rn] or {}
      war[rn] = rnG
      local gui2 = rnG[gNa1] or {}
      rnG[gNa1] = gui2
      if ope then
          gui2["Money"] = GetGuildBankMoney()
      end
  end
end
function Nx.EdB.OEFG()
  Nx.SMT()
  local self = this.NxI
  if self.FiS ~= "" then
      this:SetText(self.FiS)
  else
      this:SetText("")
  end
end
function Nx.Opt:NXCmdDeleteHerb()
  local function fun()
      Nx:GDH()
  end
  Nx:ShM("Delete Herb Locations?", "Delete", fun, "Cancel")
end
function Nx.War.OG_2()
  local self = Nx.War
  if self.Ena then
      self:GuR(true)
  end
end
function Nx.Lis:SLH(hei, hdH)
  self.LHP = hei
  self.HdH = hdH or 12
  if self.Sli then
      self.Sli:STLO(self.HdH)
  end
  self:Upd()
end
function Nx.Map:M_OIS(ite)
  self.IcS = ite:GeS1()
end
function Nx.Soc:Ini()
  self.Lis.Sor = {}
  local opt = Nx:GGO()
  self.GOp = opt
  if opt["SocialEnable"] then
      local ff = FriendsFrame
      GetUIPanelWidth(ff)
      ff:SetAttribute("UIPanelLayout-enabled", false)
      hooksecurefunc("PanelTemplates_SetTab", Nx.Soc.PanelTemplates_SetTab)
  end
  self.Pun = Nx:GeS("Pk")
  self.PuA = Nx:GeS("PkAct")
  for k, v in pairs(self.PuA) do
      if not (v.MId and v.X and v.Y and v.Tim1) then
          Nx:ClS("PkAct")
          self.PuA = Nx:GeS("PkAct")
          break
      end
  end
  self.PND = 0
  self.PHUD:Cre()
  self.THUD:Cre()
end
function Nx.Tit:TiW(pro)
  Nx.Map:StZ()
  Nx.Pro:SeF(pro, self.TW2)
  return 30
end
function Nx.Com:GUVT()
  for n = 1, GetNumDisplayChannels() do
      local chn, hea, col4, chN, plC, act1, cat, voE, voA = GetChannelDisplayInfo(n)
      if not hea then
          if chn == "General" then
              SSDC(n)
          end
          local s1 = strfind(strlower(chn), "^crbb")
          if s1 then
              SSDC(n)
              self.GeV1 = true
              return
          end
      end
  end
  local s = "crbb1"
  Nx.prt("Joining %s", s)
  JoinChannelByName(s)
  return 2
end
function Nx.Men:I_OMD(but)
  local ite = this.NMI
  if but == "LeftButton" then
      if ite.Che1 then
          ite:SetChecked(not ite.Che)
          Nx.Men:ChU(ite)
          if ite.Fun then
              ite.Fun(ite.Use, ite, ite.Use)
          end
      elseif ite.Sli then
          Nx.Men.SlM = ite
          Nx.Men:I_HS(ite)
      elseif ite.SuM then
          ite.SuM:Ope()
      else
          if ite.ShS and ite.ShS >= 0 then
              if ite.Fun then
                  ite.Fun(ite.Use, ite, ite.Use)
              end
          end
          ite.Men:Clo2()
      end
  end
end
function Nx.Map.Gui:ToS()
  Nx.Sec:VaM()
end
function Nx.Map:OBTG(but1)
  self.Gui:ToS()
end
function Nx:CGDTP(zx, zy, maN)
  local map = Nx.Map:GeM(1)
  local maI = Nx.MNTI1[maN]
  if not maI then
      return 1000
  end
  local wx, wy = map:GWP(maI, zx * 100, zy * 100)
  local x = wx - map.PlX
  local y = wy - map.PlY
  local diY = (x * x + y * y) ^ .5 * 4.575
  return diY
end
function Nx.EdB:SeU(use, fun)
  self.Use = use
  self.UsF = fun
end
function Nx.Que.Lis:AtF()
  local gop = Nx:GGO()
  local win = self.Win1
  local lis = self.Lis
  local tbH = Nx.TaB:GetHeight()
  if gop["QSideBySide"] then
      local r = .55
      if self.TaS1 ~= 1 then
          r = 1
      end
      win:Att(lis.Frm, 0, r, 18, -tbH)
      win:Att(self.DeF, .55, 1, 18, -tbH)
  else
      local bot1 = .6
      if self.TaS1 ~= 1 then
          bot1 = -tbH
      end
      win:Att(lis.Frm, 0, 1, 18, bot1)
      win:Att(self.DeF, 0, 1, .6, -tbH)
  end
end

function Nx.ToB:Cre(nam, paF, siz, alR, alB)
  local c2r = Nx.U_22
  paF = paF or UIParent
  local dat = Nx:GDTB()
  local svd = dat[nam]
  if not svd then
      svd = {}
      dat[nam] = svd
      svd["Size"] = siz
      svd["Space"] = 1
      svd["AlignR"] = alR
      svd["AlignB"] = alB
  end
  local bar = {}
  setmetatable(bar, self)
  self.__index = self
  assert(self.TBs[bar] == nil)
  self.TBs[bar] = true
  bar.Nam = nam
  bar.Too = {}
  bar.Siz2 = siz
  local f = CreateFrame("Frame", nam, paF)
  bar.Frm = f
  f.NxI = bar
  f:SetWidth(siz)
  f:SetHeight(10)
  f:SetPoint("TOPRIGHT", 0, 0)
  f:Show()
  return bar
end

function Nx.Inf:CHC()
  local i = self.Var["Health"] - self.HeL
  self.HeL = self.Var["Health"]
  if i == 0 then
      i = self.HLV
      if i > 0 then
          return "|cff205f20", format("+%d", i)
      end
      return "|cff5f2020", format("%d", i)
  else
      self.HLV = i
      if i > 0 then
          return "|cff20ff20", format("+%d", i)
      end
      return "|cffff2020", format("%d", i)
  end
end
function Nx.NXMiniMapBut:NXOnClick(but, dow)
  if but == "LeftButton" then
      if IsShiftKeyDown() then
          local opt = Nx:GGO()
          opt["MMButWinMinimize"] = not opt["MMButWinMinimize"]
          Nx.Map.Doc:UpO()
      elseif IsAltKeyDown() then
          local w = Nx.Que.Wat.Win1
          w:Show(not w:IsShown())
      else
          Nx.Map:ToS1(0)
      end
  elseif but == "MiddleButton" then
      Nx.Map:GeM(1).Gui:ToS()
  else
      self:OpM()
  end
end
function Nx:GeQ(qId)
  local que = Nx.CuC.Q[qId]
  if not que then
      return
  end
  local s1, s2, sta, time = strfind(que, "(%a)(%d+)")
  return sta, time
end
function Nx.Lis:ISB(typ, pre1, tex2, tip)
  if not self.BuD then
      self.BuD = {}
  end
  local ind = self.Num
  self.BuD[ind] = typ
  self.BuD[-ind] = pre1
  if tex2 then
      self.BuD[ind + 1000000] = tex2
  end
  if tip then
      self.BuD[ind + 2000000] = tip
  end
end
function Nx.Com:SSW1(pre, msg, plN)
  local cs = self:Chk(msg)
  local str = self:Enc(format("%s%c%c%s", pre, floor(cs / 16) + 65, bit.band(cs, 15) + 65, msg))
  self.SeB = self.SeB + #str + 54 + 20
  SendAddonMessage(self.Nam, str, "WHISPER", plN)
end
function Nx.Map:GWN()
  return "NxMap" .. self.MaI3
end
function Nx.Com1:OnE(eve, ...)
  local Com1 = Nx.Com1
  local UEv = Nx.UEv
  local prD = Nx.prD
  if eve == "COMBAT_LOG_EVENT_UNFILTERED" then
      local OBJ_AFFILIATION_MINE = 1
      local OBJ_TYPE_PET = 0x00001000
      local OBJ_TYPE_GUARDIAN = 0x00002000
      local time, cEv, sId, sNa, sFl, dId, dNa, dFl, a1, a2, a3, a4 = select(1, ...)
      local pre, mid, pos = strsplit("_", cEv)
      if not pos then
          pos = mid
      end
      if bit.band(sFl, OBJ_AFFILIATION_MINE) > 0 then
          local spI, spN, spS
          local i = 9
          if pre ~= "SWING" then
              spI, spN, spS = select(9, ...)
              i = 12
          end
          local amo, sch1, res, blo, abs1, cri = select(i, ...)
          if pos == "DAMAGE" then
              local v = amo
              local hiS = cri and "|cffff00ffcrit" or "hit"
              if spN then
                  hiS = spN
                  if mid == "PERIODIC" then
                      hiS = spN .. " dot"
                  end
                  if cri then
                      hiS = hiS .. " |cffff00ffcrit"
                  end
              end
              local s = format("|cff00ff00%s|r %s |cffff0000'%s'|r %d", sNa, hiS, dNa, amo)
              if bit.band(sFl, OBJ_TYPE_PET + OBJ_TYPE_GUARDIAN) > 0 then
                  if pre == "SPELL" then
                      if cri then
                          Com1:SeL(v, "e0a000", s)
                      else
                          Com1:SeL(v, "906000", s)
                      end
                  else
                      if cri then
                          Com1:SeL(v, "e0a0a0", s)
                      else
                          Com1:SeL(v, "806060", s)
                      end
                  end
              else
                  if pre == "SPELL" then
                      if cri then
                          Com1:SeL(v, "e0e000", s)
                      else
                          Com1:SeL(v, "909000", s)
                      end
                  else
                      if cri then
                          Com1:SeL(v, "e0e0e0", s)
                      else
                          Com1:SeL(v, "808080", s)
                      end
                  end
              end
          elseif cEv == "PARTY_KILL" then
              Com1:SeL(-1, "e02020", "Killed " .. dNa)
              UEv:AdK(dNa)
          end
      elseif bit.band(dFl, OBJ_AFFILIATION_MINE) > 0 then
          if pos == "DAMAGE" and sNa then
              Com1.AtN = sNa
          end
      end
  elseif eve == "CHAT_MSG_COMBAT_XP_GAIN" then
      local s1, s2, nam = strfind(arg1, "gain (%d+) ex")
      if s1 then
          Com1:SeL(-1, "20e020", arg1)
          UEv:AdI("+" .. nam .. " xp")
      end
  elseif eve == "CHAT_MSG_COMBAT_HONOR_GAIN" then
      local s1, s2, nam = strfind(arg1, "Points: (%d+)")
      if s1 then
          UEv:AdH1("+" .. nam .. " honor")
      else
          local s1, s2, nam = strfind(arg1, "(%d+) %aonor")
          if s1 then
              UEv:AdH1("+" .. nam .. " honor")
          end
      end
  elseif eve == "PLAYER_REGEN_DISABLED" then
      Com1:EnC()
  elseif eve == "PLAYER_REGEN_ENABLED" then
      Com1.InC = false
  elseif eve == "PLAYER_DEAD" then
      UEv:AdD(Com1.AtN)
  else
      if Com1.EvT[eve] then
          Com1.EvT[eve](Com1, arg1)
      end
  end
end
function Nx.Que:CAT1(cur)
  local Nx = Nx
  local Que = Nx.Que
  local cur1 = Que.CuQ
  local qop = Nx:GQO()
  Que.Tra1 = {}
  local clo2 = false
  local dis = 99999999
  if cur.Q then
      local clI = cur.COI
      if clI and clI >= 0 then
          Que.Tra1[cur.QId] = cur.TrM2
          Que:TOM(cur.QId, clI, cur.QI > 0 or cur.Par, true, true)
      end
      for obj3 = 1, 15 do
          local obj = cur.Q[obj3 + 3]
          if not obj then
              break
          end
          local obi = bit.lshift(1, obj3)
          if bit.band(cur.TrM2, obi) > 0 then
              if Que:GOT1(obj) == 1 then
                  local d = cur["OD" .. obj3]
                  if d and d < dis then
                      dis = d
                      clo2 = cur
                  end
              end
          end
      end
  end
end
function Nx.Soc.Lis:M_OSP1()
  if self.MSN1 then
      local per1 = self:FFP(self.MSN1) or ""
      Nx:SEB("Set person who owns character", per1, self.MSN1, self.SPA)
  end
end
function Nx:OC____2(eve)
  if Nx.Inf then
      local s1, s2, sec
      if strfind(arg1, "One minute until the Arena") then
          sec = 60
      end
      if strfind(arg1, "Thirty seconds until the Arena") then
          sec = 30
      end
      if strfind(arg1, "Fifteen seconds until the Arena") then
          sec = 15
      end
      if not sec then
          s1, s2, sec = strfind(arg1, " begins? in (%d+) ")
          if not sec then
              s1, s2, sec = strfind(arg1, "(%d+) minutes? until the battle")
          end
      end
      if sec then
          sec = tonumber(sec)
          if sec then
              if sec <= 3 then
                  sec = sec * 60
              end
              Nx.Inf:SBGST(sec)
          end
      end
  end
end
function Nx.Win:ReL()
  for win, v in pairs(self.Win2) do
      win:ReL1()
  end
end
function Nx.Com1:Ope()
  local win = self.Win1
  if win then
      if win:IsShown() then
          win:Show(false)
      else
          win:Show()
      end
      return
  end
  self.EvT = {}
  local win = Nx.Win:Cre("NxCombat", nil, nil, nil, nil, nil, true)
  self.Win1 = win
  win:ILD(nil, -.7, -.7, -.3, -.06)
  win:CrB(true)
  local f = CreateFrame("Frame", nil, UIParent)
  self.Frm = f
  f.NxC = self
  win:Att(f, 0, 1, 0, 1)
  f:SetScript("OnEvent", self.OnE)
  f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  f:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN")
  f:RegisterEvent("CHAT_MSG_COMBAT_HONOR_GAIN")
  f:RegisterEvent("PLAYER_REGEN_DISABLED")
  f:RegisterEvent("PLAYER_REGEN_ENABLED")
  for k, v in pairs(self.EvT) do
      f:RegisterEvent(k)
  end
  f:RegisterEvent("PLAYER_DEAD")
  f:SetScript("OnUpdate", self.OnU)
  f:SetScript("OnEnter", self.OnE1)
  f:SetScript("OnLeave", self.OnE1)
  f:EnableMouse(true)
  f:SetFrameStrata("MEDIUM")
  local t = f:CreateTexture()
  t:SetTexture(.2, .2, .2, .5)
  t:SetAllPoints(f)
  f.tex = t
  f:Show()
  self:OpG()
end
function Nx:OU__1(eve, ...)
  if arg1 == "player" then
      local Nx = Nx
      if arg2 == NXlHERBGATHERING then
          Nx.GaT = Nx.TLT
          if NxData.NXDBGather then
              Nx.prt("Gather: %s %s", arg2, Nx.GaT or "nil")
          end
          if Nx.GaT then
              Nx.UEv:AdH(Nx.GaT)
              Nx.GaT = nil
          end
      elseif arg2 == NXlMINING then
          Nx.GaT = Nx.TLT
          if NxData.NXDBGather then
              Nx.prt("Gather: %s %s", arg2, Nx.GaT)
          end
          if Nx.GaT then
              Nx.UEv:AdM(Nx.GaT)
              Nx.GaT = nil
          end
      elseif arg2 == NXlEXTRACTGAS then
          Nx.UEv:AdO("Gas", NXlEXTRACTGAS)
      elseif arg2 == NXlOpening or arg2 == NXlOpeningNoText then
          Nx.GaT = Nx.TLT
          if arg4 == NXlGLOWCAP then
              Nx.UEv:AdH(arg4)
          elseif arg4 == NXlEverfrost then
              Nx.UEv:AdO("Everfrost", arg4)
          end
      end
  end
end
function Nx.Que:GetDifficultyColor(lev)
  if Nx.V32 then
      return GetQuestDifficultyColor(lev)
  end
  return GetDifficultyColor(lev)
end
function Nx.Que.Lis:M_OSF(ite)
  self.ShF1 = ite:GetChecked()
  self:Upd()
end
function Nx.Map.Minimap_ZoomInClick()
  local map = Nx.Map:GeM(1)
  map:MiZ(2)
end
function Nx.War:M_OSIC(ite)
  self.SIC = ite:GetChecked()
  self:Upd()
end
function Nx.Map:IOUT()
  local f = self.NXIconFrm
  if f and f.NxT then
      local map = f.NxM1
      map:BPL()
      local str = strsplit("~", f.NxT)
      Nx:STT(str .. Nx.Map.PNTS)
      Nx.Que:ToP()
  end
end
function Nx.NXMiniMapBut:M_OP()
  Nx:ShM("Toggle profiling? Reloads UI", "Reload", self.ToP1, "Cancel")
end
function Nx.Que.Wat:M_OLQ()
  Nx.Que:LiC(self.MQI)
end
function Nx.Map:MOE(mot)
  local map = Nx.Map.Map1[1]
  if map.MMZT ~= 0 then
      this.NxM1 = map
      map:IOE(mot)
  end
end
function Nx.Win:STLH(hei)
  self.TLH = hei
  self.TiH = self.TiL * self.TLH + 2
  self.ToH = self.TiH + self.BoH
  local fna = hei <= 10 and "NxFontS" or "NxFontM"
  for n = 1, self.TiL do
      local fst = self.TFS[n]
      fst:SetFontObject(fna)
      fst:SetHeight(hei)
  end
end
function Nx.Que:GLIL(ind)
  if ind > 0 then
      local qli = GetQuestLink(ind)
      if qli then
          local s1, _, id, lev = strfind(qli, "Hquest:(%d+):(.%d*)")
          if s1 then
              return tonumber(id), tonumber(lev)
          end
      end
  end
end
function Nx.Soc.THUD:Upd()
  if not self.Win1 or not self.Win1.Frm:IsVisible() then
      return
  end
  local tm = GetTime()
  local upd = tm - self.UpT2 > 1
  if upd then
      self.UpT2 = tm
  end
  local cw, ch = self.Win1:GeS2()
  local Soc = Nx.Soc
  local loD = InCombatLockdown() ~= nil
  local lch = self.LoD1 ~= loD
  self.LoD1 = loD
  if upd and not loD then
      local Map = Nx.Map
      local map = Map:GeM(1)
      local maI, plX, plY = map.RMI, map.PRZX, map.PRZY
      local plX, plY = Map:GWP(maI, plX, plY)
      local inA = Nx.InA
      local mem = MAX_PARTY_MEMBERS
      local unN = "party"
      local maD = 999999990
      if GetNumRaidMembers() > 0 then
          mem = MAX_RAID_MEMBERS
          unN = "raid"
          maD = 250
      end
      for n = 1, mem do
          local pla = self.Pla[n]
          local uni = unN .. n
          local nam = UnitName(uni)
          pla.Nam = nam or "zzz"
          pla.Dis = 999999999
          if nam and not UnitIsUnit(uni, "player") then
              pla.Uni = uni
              local pX, pY = GetPlayerMapPosition(uni)
              if pX == 0 then
                  pla.Dis = 999999
              else
                  pX = pX * 100
                  pY = pY * 100
                  local wx, wy = Map:GWP(map.MaI, pX, pY)
                  local dis = (plX - wx) ^ 2 + (plY - wy) ^ 2
                  pla.Dis = dis ^ .5 * 4.575
              end
          end
      end
      if not loD then
          if inA then
              sort(self.Pla, function(a, b)
                  return a.Nam < b.Nam
              end)
          else
              local fun = function(a, b)
                  if a.Dis < 100 then
                      if b.Dis < 100 then
                          return a.Nam < b.Nam
                      end
                      return true
                  else
                      if b.Dis < 100 then
                          return false
                      end
                      return a.Dis < b.Dis
                  end
                  return a.Nam < b.Nam
              end
              sort(self.Pla, fun)
          end
          local but1 = self.But1[1]
          but1:SetWidth(cw)
          local n = 2
          for ind, pla in ipairs(self.Pla) do
              pla.But2 = nil
              if pla.Dis < maD or pla.Dis == 999999 then
                  local nam = pla.Nam
                  local but1 = self.But1[n]
                  pla.But2 = but1
                  pla.FrI = n
                  but1:SetAttribute("macrotext1", "/targetexact " .. nam)
                  but1:SetAttribute("macrotext2", "/target " .. nam .. "-target")
                  but1:SetWidth(cw)
                  but1:Show()
                  local f = self.HeF[n]
                  pla.HeF1 = f
                  n = n + 1
                  if n > self.NuB then
                      break
                  end
              end
          end
          for i = n, self.NuB do
              local but1 = self.But1[i]
              but1:Hide()
          end
          self.Win1:SeS(cw, n * 14 - 14)
      end
  end
  local fst = self.FSt1[1]
  local h = UnitIsDeadOrGhost("player") and 0 or UnitHealth("player")
  local per = min(h / UnitHealthMax("player"), 1)
  local f = self.HeF[1]
  f:SetWidth(per * cw + 1)
  f.tex:SetTexture(1 - per, per, 0, .5)
  local plT = UnitName("target")
  for ind, pla in ipairs(self.Pla) do
      local but1 = pla.But2
      if but1 then
          local uni = pla.Uni
          local h = UnitIsDeadOrGhost(uni) and 0 or UnitHealth(uni)
          local per = min(h / UnitHealthMax(uni), 1)
          local f = pla.HeF1
          f:SetWidth(per * cw + 1)
          f.tex:SetTexture(.6 - per * .6, per * .6, 0, .7)
          local nam = pla.Nam
          local taS = plT == nam and "|cff8080ff>" or ""
          local coS3 = UnitAffectingCombat(uni) and "|cffff4040*" or ""
          local coS4 = pla.Dis < 41 and "|cffc0ffc0" or "|cff808080"
          local diS = pla.Dis ~= 999999 and format("%d yds", pla.Dis) or ""
          local s = format("%s%s%s%s %s", taS, coS3, coS4, nam, diS)
          self.FSt1[pla.FrI]:SetText(s)
      end
  end
  if lch then
      local win = self.Win1
      if loD then
          win:SeT("|cffff2020Team:")
      else
          win:SeT("Team:")
      end
  end
end
function Nx.Lis:SMS(wid, hei)
  self.MiW = wid or 2
  self.MiH = hei or 1
end
function Nx.Win:GetAttribute(wiN, atN)
  local win = self:Fin(wiN)
  if win then
      if atN == "L" then
          return "B", win:IsL()
      elseif atN == "H" then
          return "B", not win:IsShown()
      end
  end
end
function Nx.Tim:PGLT(nam)
  local pro4 = self.Pro2[nam]
  return pro4 and pro4.TiL2 or 0
end
function Nx.Lis:Cre(saN, xpo, ypo, wid, hei, paF, shA, noH)
  if not self.CFo then
      self:SCF1("FontS")
  end
  local ins = {}
  setmetatable(ins, self)
  self.__index = self
  if saN then
      local sav = self.SaD[saN] or {}
      self.SaD[saN] = sav
      ins.Save = sav
      if sav["ColW"] then
          ins.SCW = {strsplit("^", sav["ColW"])}
      end
  end
  ins.Col = {}
  ins.Str = {}
  ins.But1 = {}
  ins.Fon = self.CFo
  ins.FoO = Nx.Fon:GeO(ins.Fon)
  ins.LHP = 0
  ins.BLH = self.CBLH
  ins.Top = 1
  ins.Vis = 1
  ins.Sel = 1
  ins.ShA = shA
  ins:SMS()
  self.Lis1[ins] = true
  ins.UsF1 = {}
  local frm = CreateFrame("Frame", nil, paF)
  ins.Frm = frm
  frm.NxI = ins
  frm:SetScript("OnMouseDown", self.OMD)
  frm:EnableMouse(true)
  frm:SetScript("OnMouseWheel", self.OMW)
  frm:EnableMouseWheel(true)
  frm.tex = frm:CreateTexture()
  frm.tex:SetAllPoints(frm)
  frm.tex:SetTexture(0, 0, 0, .3)
  frm:SetPoint("TOPLEFT", xpo, ypo)
  frm:Show()
  ins.HdH = 0
  if not noH then
      ins.HdH = 12
      local hfr = CreateFrame("Frame", nil, frm)
      ins.HdF = hfr
      hfr.NxI = ins
      hfr:SetScript("OnMouseDown", self.OHMD)
      hfr:EnableMouse(true)
      hfr.tex = hfr:CreateTexture()
      hfr.tex:SetAllPoints(hfr)
      hfr.tex:SetTexture(.2, .2, .3, 1)
      hfr:SetPoint("TOPLEFT", 0, 0)
      hfr:Show()
  end
  local sfr = CreateFrame("Frame", nil, frm)
  ins.SeF2 = sfr
  sfr.NxI = ins
  sfr.tex = sfr:CreateTexture()
  sfr.tex:SetAllPoints(sfr)
  sfr.tex:SetTexture(.4, .4, .5, .4)
  sfr.tex:SetBlendMode("Add")
  sfr:Hide()
  if not shA then
      ins.Sli = Nx.Sli:Cre(frm, "V", 10, ins.HdH)
      ins.Sli:SeU(ins, self.OnS)
  end
  ins:Emp()
  ins:SeS(wid, hei)
  self.CFo = nil
  return ins
end
function Nx.Que:DCR(inf, msg)
  if #msg < 7 then
      return
  end
  local qId = tonumber(strsub(msg, 1, 4), 16) or 0
  local que = self.ITQ[qId]
  if not que then
      inf.QSt = format("\nQuest %s", qId)
      return
  end
  local nam, sid, lvl = self:Unp(que[1])
  local obj4 = strbyte(msg, 5) - 35
  local flg = strbyte(msg, 6) - 35
  local lbc = strbyte(msg, 7) - 35
  local taS = ""
  if bit.band(flg, 2) == 0 then
      taS = "*"
  end
  local str = format("\n|r%s%d |cffcfcf0f%s", taS, lvl, nam)
  if bit.band(flg, 1) > 0 then
      str = str .. " (Complete)"
  end
  if #msg >= 7 + lbc * 2 then
      for n = 1, lbc do
          local off1 = (n - 1) * 2
          local cnt = strbyte(msg, 8 + off1) - 35
          local tot = strbyte(msg, 9 + off1) - 35
          local obj = que[n + 3]
          if obj then
              local ona = self:UnO(obj)
              if obj4 == n then
                  ona = "|cffcfcfff" .. ona
              else
                  ona = "|cffafafaf" .. ona
              end
              if cnt == 0 then
                  str = str .. format("\n  %s", ona)
              elseif cnt == 1 then
                  str = str .. format("\n  %s (done)", ona)
              else
                  str = str .. format("\n  %s %d/%d", ona, cnt - 2, tot)
              end
          end
      end
  end
  inf.QSt = str
  return 7 + lbc * 2
end
function Nx.Map:RoL(rou)
  local len = 0
  for n = 1, #rou - 1 do
      local r1 = rou[n]
      local r2 = rou[n + 1]
      r1.Dis = ((r1.X - r2.X) ^ 2 + (r1.Y - r2.Y) ^ 2) ^ .5
      len = len + r1.Dis
  end
  return len
end
function Nx.Map:MaS1()
  if not self.Win1:ISM() then
      if NxData.NXDBMapMax then
          Nx.prt("MapMax %s", debugstack(2, 4, 0))
      end
      self.Win1:ToS1()
      self:SaveView("")
      self:MoE(false)
      if self.GOp["MapMaxCenter"] then
          self:CeM()
      end
      self.StT = min(self.StT, 1)
  end
end
function Nx.Opt:NXCmdQuestSidebySide()
  Nx.Que.Lis:AtF()
end
function Nx.Map:CWHT(wx, wy, qua1)
  for n, spo in ipairs(qua1) do
      if wx >= spo.WX1 and wx <= spo.WX2 and wy >= spo.WY1 and wy <= spo.WY2 then
          local cuI = self:GCMI()
          cuI = self.MWI[cuI].L1I or cuI
          if spo.MaI ~= cuI then
              self:SCM1(spo.MaI)
          end
          self.WHTS = spo.NTB .. "\n"
          return true
      end
  end
end
function Nx:GQO()
  return NxData.NXQOpts
end
function Nx:NXFavKeyToggleShow()
  Nx.Fav:ToS()
end
function Nx:LoI1()
  local b = getglobal("GossipTitleButton1")
  if b:IsVisible() then
      b:Click()
  end
end
function ToggleFrame(fra)
  if fra ~= WorldMapFrame then
      if fra:IsShown() then
          HideUIPanel(fra)
      else
          ShowUIPanel(fra)
      end
      return
  end
  local opt = Nx:GGO()
  if Nx.Map.BlT or WorldMapFrame:IsShown() or IsAltKeyDown() or not opt["MapMaxOverride"] then
      Nx.Map:BTWM()
  else
      Nx.Map:ToS1()
  end
end
function Nx.Fon:GetName(ind)
  local t = self.Fac[ind]
  return t and t[1]
end
function Nx.Fav:PIN(dat)
  local icI = strbyte(dat, 1) - 35
  local zon = tonumber(strsub(dat, 2, 3), 16)
  local id = Nx.NTMI[zon]
  local x = tonumber(strsub(dat, 4, 6), 16) / 4090 * 100
  local y = tonumber(strsub(dat, 7, 9), 16) / 4090 * 100
  local dLv = (strbyte(dat, 10) or 35) - 35
  return icI, id, x, y + dLv * 100
end
function Nx.Fav:SeR1(on)
  local but1 = self.ReB1
  if on then
      if self.CuF then
          self.Rec = self.CuF
          self.RAA = 1000
          Nx.Tim:Sta("FavRec", 0, self, self.RAT)
          but1:SeP2(true)
      else
          Nx.prt("Select a favorite before recording")
          but1:SeP2(false)
      end
  else
      self.Rec = nil
      but1:SetAlpha(1)
      but1:SeP2(false)
  end
end
function Nx.Win:Loc1(loc1, fuL)
  self.Loc2 = loc1
  self.Frm:EnableMouse(not loc1)
  self.Frm:EnableMouseWheel(not loc1)
  local svd = self.SaD
  svd["Lk"] = loc1 or nil
  self:SBF(loc1 and 0 or 1)
  if self.BuC then
      if loc1 then
          if self.Clo then
              self.BuC:SeT1("CloseLock")
          else
              self.BuC.Frm:Show()
              self.BuC:SeT1("Lock")
          end
      else
          if self.Clo then
              self.BuC:SeT1("Close")
          else
              self.BuC.Frm:Hide()
          end
      end
      self.BuC:Upd()
  end
  if fuL then
      self.FuL = loc1
  end
end
function Nx.Fav:UpI()
  local Que = Nx.Que
  local Map = Nx.Map
  local map = Map:GeM(1)
  if self.CuF and self.CII then
      map:IIT("!Fav2", "WP", "", 21, 21)
      local str = self.CuF[self.CII]
      local typ, fla, nam, dat = self:PaI1(str)
      if typ == "N" then
          local ico, maI, x, y = self:PIN(dat)
          ico = self:GIF(ico)
          local wx, wy = Map:GWP(maI, x, y)
          local ico = map:AIP("!Fav2", wx, wy, nil, ico)
          map:SIT(ico, "Note: " .. nam)
          map:SIFD(ico, self.CuF, self.CII)
          map:SITA("!Fav2", abs((GetTime() * 100 % 100 - 50) / 50))
      end
  else
      map:CIT("!Fav2")
  end
  local maI = map.MaI
  local dra = map.ScD > .3 and map.GOp["MapShowNotes"]
  if maI == self.DMI and dra == self.Dra1 then
      return
  end
  self.DMI = maI
  self.Dra1 = dra
  map:IIT("!Fav", "WP", "", 17, 17)
  if not dra then
      return
  end
  local con1 = map:ITCZ(maI)
  if con1 > 0 and con1 < 9 then
      local not1 = self:FiF("Notes")
      if not1 then
          local fav = self:FiF1(maI, "ID", not1)
          if fav then
              for n, str in ipairs(fav) do
                  local typ, fla, nam, dat = self:PaI1(str)
                  if typ == "N" then
                      local ico, _, x, y = self:PIN(dat)
                      ico = self:GIF(ico)
                      local wx, wy = Map:GWP(maI, x, y)
                      local ico = map:AIP("!Fav", wx, wy, nil, ico)
                      map:SIT(ico, "Note: " .. nam)
                      map:SIFD(ico, fav, n)
                  end
              end
          end
      end
  end
end
function Nx.Com1:OnU(...)
end
function Nx.Men:I_OU(ela)
  local ite = this.NMI
  ite.Alp = Nx.U_SV(ite.Alp, ite.AlT, ela * 4)
  this.tex:SetVertexColor(.2, .2, .5, ite.Alp)
  if ite.Sli and ite == Nx.Men.SlM then
      Nx.Men:I_HS(ite)
  end
end
function Nx.Com.Lis:Sor1()
  local rcv = Nx.Com.Dat.Rcv
  self.Sor = {}
  local t = self.Sor
  local i = 1
  for k, v in pairs(rcv) do
      t[i] = v
      i = i + 1
  end
  sort(self.Sor, self.SoC)
end
function Nx.Que.Lis:M_OSQI(ite)
  local i = self.Lis:IGD()
  if i then
      local qi = bit.band(i, 0xff)
      self:SQI(qi)
  end
end
function Nx:GUC()
  local _, cls = UnitClass("player")
  cls = gsub(Nx.U_CS(cls), "Deathknight", "Death Knight")
  return cls
end
function Nx:NXMapKeyTogNoneMax()
  Nx.Map:ToS1(1)
end
function Nx.Com:SSPM(mas)
  self.SPM = mas
end
function Nx.Win:SFS(lay)
  local svd = self.SaD
  svd[self.LaM .. "L"] = lay
  self.Frm:SetFrameStrata(self.StN[lay] or "MEDIUM")
end
function Nx.Map:BGIST()
  local str = format("Inc %s", self.BGIN)
  self:BGM_S(str)
  self.BGIN = 0
end
function Nx:SeQ(qId, qSt, qTi)
  qTi = qTi or 0
  Nx.CuC.Q[qId] = qSt .. qTi
end
function Nx.U_GMCXY(frm)
  local x, y = GetCursorPosition()
  x = x / frm:GetEffectiveScale()
  local lef = frm:GetLeft()
  local rig = frm:GetRight()
  x = max(x, lef)
  x = min(x, rig)
  y = y / frm:GetEffectiveScale()
  local top = frm:GetTop()
  local bot = frm:GetBottom()
  y = max(y, bot)
  y = min(y, top)
  return x - lef, y - bot
end
function Nx.War:ToS()
  Nx.Sec:VaM()
end
function Nx.Map.Gui:ClA()
  self.Map:ClT1("Guide")
  self:CSF()
  self:Upd()
end
function Nx.Hel:OSS(w, h)
  Nx.Hel.FSt:SetWidth(w)
end
function Nx.Sli:Set(pos1, min, max, viS)
  if min then
      self.Min1 = math.min(min, max)
      self.Max1 = math.max(min, max)
  end
  if viS then
      self.ViS = math.max(viS, 1)
  end
  pos1 = math.max(pos1, self.Min1)
  pos1 = math.min(pos1, self.Max1 - self.ViS + 1)
  self.Pos = pos1
end
function Nx.pFC(msg, frm, lvl)
  local prt = Nx.prt
  lvl = lvl or 1
  if msg then
      prt(format("FrameChildren (%s)", msg))
  end
  local pad = ""
  for n = 1, lvl do
      pad = pad .. " "
  end
  local ch = {frm:GetChildren()}
  for n = 1, #ch do
      local c = ch[n]
      if c:IsObjectType("Frame") then
          prt("%s#%d %s ID%s (%s) show%d l%d x%d y%d", pad, n, c:GetName() or "nil", c:GetID() or "nil",
              c:GetObjectType(), c:IsShown() or 0, frm:GetFrameLevel(), c:GetLeft() or -99999, c:GetTop() or -99999)
          Nx.pFC(nil, c, lvl + 1)
      end
  end
end
function Nx:OU__4(eve)
  local plN = UnitName("player")
  local sco = GetNumBattlefieldScores()
  local cb = Nx.Com1
  local show
  for n = 1, sco do
      local nam, kbs, hks, dea, hon, fac1, ran, rac, cla, clC, daD, heD = GetBattlefieldScore(n)
      if nam == plN then
          local any = kbs + dea + hks + hon
          if any > 0 and (cb.KBs ~= kbs or cb.Dea ~= dea or cb.HKs ~= hks or cb.Hon ~= hon) then
              cb.KBs = kbs
              cb.Dea = dea
              cb.HKs = hks
              cb.Hon = hon
              show = true
          end
          cb.DaD = daD
          cb.HeD = heD
          break
      end
  end
  local opt = Nx:GGO()
  if show and opt["BGShowStats"] then
      local kbr = 1
      for n = 1, sco do
          local nam, kbs, hks, dea, hon, fac1, ran, rac, cla = GetBattlefieldScore(n)
          if nam ~= plN then
              if kbs > cb.KBs then
                  kbr = kbr + 1
              end
          end
      end
      Nx.prt("%s KB (#%d), %s Deaths, %s HK, %s Bonus", cb.KBs, kbr, cb.Dea, cb.HKs, cb.Hon)
  end
end
function Nx.Men:I_HS(ite)
  local frm = ite.SlF
  local x = Nx.U_GMCXY(frm)
  if x then
      x = (x - 1) / (frm:GetWidth() - 2) * (ite.SlM2 - ite.SlM1) + ite.SlM1
      if IsShiftKeyDown() then
          x = floor(x * 10) / 10
      end
      if IsAltKeyDown() then
          x = 1
      end
      Nx.Men:I_SUS(ite, x)
  end
end
function Nx.Map:StZ()
end
function Nx.Que:ChS(maI, qId)
  local nxi = Nx.MITN1[maI]
  local que = self.ITQ[qId]
  if not que then
      return
  end
  local qna, sid, lvl, min5, next = self:Unp(que[1])
  local _, sMI2 = self:UnO(que[2])
  if sMI2 then
      if sMI2 == nxi then
          return true
      end
  end
  if que[3] then
      local _, eMI = self:UnO(que[3])
      if eMI then
          if eMI == nxi then
              return true
          end
      end
  end
  for n = 1, 15 do
      local obj = que[n + 3]
      if not obj then
          break
      end
      local _, oMI = self:UnO(obj)
      if oMI then
          if oMI == nxi then
              return true
          end
      end
  end
end
function Nx.Sec:VaT()
  local dt = self:Dat1()
  local x = 101006
  if dt >= x then
      Nx.Tim:Sta(-1, 0, self, self.OlM)
  end
  Nx.Tim:Sta(0, 0, self, self.Val1)
  return .1
end
function Nx.Win:GBS()
  return self.BoW, self.BoH
end
function Nx.Com:ReC2(msg)
  local s1 = strfind(msg, "\1")
  if s1 then
      return gsub(msg, "\1", "|")
  end
  return msg
end
function Nx.Que:CaD2(que, obI, cnt, tot)
  local des1 = ""
  local obj = que and que[obI + 3]
  if obj then
      des1 = self:UnO(obj)
  end
  if tot == 0 then
      return des1, cnt == 1
  else
      return format("%s : %d/%d", des1, cnt, tot), cnt >= tot
  end
end
function Nx.Com.Lis:Ope()
end
function Nx.War:Cap(lin)
end
function Nx.Opt:Upd()
  local opt = self.Opt
  local lis = self.Lis
  if not lis then
      return
  end
  lis:Emp()
  local pag = Nx.OpD[self.PaS]
  for k, ite in ipairs(pag) do
      lis:ItA(k)
      if type(ite) == "table" then
          if ite.N then
              local col2 = "|cff9f9f9f"
              if ite.F then
                  col2 = "|cff8fdf8f"
              elseif ite.V then
                  col2 = "|cffdfdfdf"
              end
              local ist = format("%s%s", col2, ite.N)
              if ite.V then
                  local typ, pre1, tx = self:PaV(ite.V)
                  if typ == "B" then
                      if pre1 ~= nil then
                          local tip
                          lis:ISB("Opts", pre1, tx, tip)
                      end
                  elseif typ == "C" then
                      lis:ISCB(opt, ite.V, true)
                  elseif typ == "RGB" then
                      lis:ISCB(opt, ite.V, false)
                  elseif typ == "CH" then
                      local i = self:GeV(ite.V)
                      ist = format("%s  |cffffff80%s", ist, i)
                  elseif typ == "F" then
                      local i = self:GeV(ite.V)
                      ist = format("%s  |cffffff80%s", ist, i)
                  elseif typ == "I" then
                      local i = self:GeV(ite.V)
                      ist = format("%s  |cffffff80%s", ist, i)
                  elseif typ == "S" then
                      local s = self:GeV(ite.V)
                      ist = format("%s  |cffffff80%s", ist, s)
                  elseif typ == "Frm" then
                  end
              end
              lis:ItS(2, ist)
          end
      elseif type(ite) == "string" then
          local col2 = "|cff9f9f9f"
          lis:ItS(2, format("%s%s", col2, ite))
      end
  end
  lis:FuU()
  self:UpC1()
end
function Nx.Que:LHA(frm, att, onL)
  local lh = getglobal("LightHeaded")
  local lhf = getglobal("LightHeadedFrame")
  if not (lh and lhf) then
      return
  end
  local db = lh["db"]
  if not db then
      return
  end
  local pro1 = db["profile"]
  if not pro1 then
      return
  end
  lhf:SetParent(frm)
  local lvl = frm:GetFrameLevel()
  local ope = pro1["open"]
  if not att then
      lvl = lvl - 1
      local x = ope and -15 or -328
      lhf:ClearAllPoints()
      lhf:SetPoint("LEFT", frm, "RIGHT", x, 0)
  else
      self.LHA1 = pro1
      self.LHO = ope
      lvl = ope and lvl or 1
      local x = ope and -4 or -326
      lhf:ClearAllPoints()
      lhf:SetPoint("TOPLEFT", frm, "TOPRIGHT", x, -19)
  end
  lhf:SetFrameLevel(lvl)
  Nx.U_SCL(lhf, lvl + 1)
  if not onL then
      lhf:Show()
      if not pro1["attached"] then
          lh["LockUnlockFrame"](lh)
      end
  end
end
function Nx.War:M_OSA1()
  Nx:ICD()
  Nx:ECD()
  Nx:CRC()
  self:Upd()
end
function Nx.Que:Aba(qIn, qId)
  if qIn > 0 then
      self:ExQ()
      local tit, lev, tag, grC, isH = GetQuestLogTitle(qIn)
      if not isH then
          SelectQuestLogEntry(qIn)
          SetAbandonQuest()
          local ite1 = GetAbandonQuestItems()
          if ite1 then
              StaticPopup_Hide("ABANDON_QUEST")
              StaticPopup_Show("ABANDON_QUEST_WITH_ITEMS", GetAbandonQuestName(), ite1)
          else
              StaticPopup_Hide("ABANDON_QUEST_WITH_ITEMS")
              StaticPopup_Show("ABANDON_QUEST", GetAbandonQuestName())
          end
      end
      self:REQ()
      if qId > 0 then
          Nx:SeQ(qId, "c")
      end
  else
      if qId > 0 then
          self.Wat:ReW(qId, qIn)
          local i = self:FiC3(qId)
          if i then
              local cur1 = self.CuQ
              tremove(cur1, i)
          end
      end
  end
end
function Nx.Win:OpM(noL)
  if not self.MeD then
      local w = Nx.Win
      w.MeW = self
      w.MIHIC:SetChecked(self.SaD["HideC"])
      w.MIL:SetChecked(self.Loc2)
      w.MIL:Show(not noL)
      w.MIFI:SeS2(self.BFI, .25, 1)
      w.MIFO:SeS2(self.BFO, 0, 1)
      local svd = self.SaD
      w.MIL1:SeS2(svd[self.LaM .. "L"] or 2, 1, 3, 1)
      w.MIS:SeS2(svd[self.LaM .. "S"] or 1, .5, 2)
      w.MIT:SeS2(svd[self.LaM .. "T"] or 1, .01, 1)
      local m = Nx.Win.Men
      m:Ope()
  end
end
function Nx.Map:IOL(mot)
  local t = this.NXType or -1
  if t >= 9000 then
      Nx.Que:IOL(this)
  end
  if GameTooltip:IsOwned(this) or GameTooltip:IsOwned(this.NxM1.Win1.Frm) then
      GameTooltip:Hide()
  end
end
function Nx.Map:ClT1(maT)
  if maT then
      local tar1 = self.Tar[1]
      if tar1 then
          if tar1.TaT ~= maT then
              return
          end
      end
  end
  self.Tar = {}
  self.Tra1 = {}
  if self.LOp.NXAutoScaleOn and self.SBT1 then
      self:GoP()
      self:Mov(self.PlX, self.PlY, self.SBT1, 60)
  end
  self.SBT1 = false
end
function Nx.Ite.ADVV()
  local function fun()
      NxData.NXVendorV = nil
      Nx.Map.Gui:UVV()
  end
  Nx:ShM(Nx.TXTBLUE ..
             "Carbonite:\n|cffffff60Delete visited vendor data?\nThis will stop the attempted retrieval of items on login.",
      "Delete", fun, "Cancel")
end
function Nx.U_TMI1(t, ite, low)
  for i, v in ipairs(t) do
      if v == ite then
          if low then
              if i > 1 then
                  t[i - 1], t[i] = t[i], t[i - 1]
                  return i - 1
              end
          else
              if i < #t then
                  t[i + 1], t[i] = t[i], t[i + 1]
                  return i + 1
              end
          end
          return
      end
  end
end
function Nx.Map:MOI()
  self.MMS = {}
  for n = 1, 6 do
      self.MMS[n] = (8 - n) * 66.6666666666666 / 5.0
  end
  self.MMSC = {300, 240, 180, 120, 80, 50}
  for n = 1, 6 do
      self.MMSC[n] = self.MMSC[n] / 5.0
  end
  local mm = self.MMF
  local mmc = getglobal("MinimapCluster")
  mm:SetMaskTexture("textures\\MinimapMask")
  self:MNGI()
  self.MMCD = 5
  self.MMOF = {}
  if not self.MMO1 then
      self.Win1:Show(self.StS)
      Nx.Map:MBSU()
      return
  end
  Nx.Map:MBSU(true)
  mm:SetClampedToScreen(true)
  mm:SetWidth(140)
  mm:SetHeight(140)
  self.MMAD = 100
  mm:SetParent(self.Frm)
  mm:SetScript("OnMouseDown", self.MOMD)
  mm:SetScript("OnMouseUp", self.MOMU)
  mm:SetScript("OnEnter", self.MOE)
  mm:SetScript("OnLeave", self.MOL)
  local pin = MinimapPing
  pin:SetParent(UIParent)
  self.MMOF[pin] = 0
  self.MMM = {}
  self.MMAF = {}
  local f = getglobal("MinimapBackdrop")
  if f then
      f:Hide()
      f:SetParent(mmc)
  end
  hooksecurefunc("Minimap_ZoomIn", Nx.Map.Minimap_ZoomInClick)
  hooksecurefunc("Minimap_ZoomOut", Nx.Map.Minimap_ZoomOutClick)
end
function Nx.Inf:CBGD()
  if Nx.IBG then
      local i = GetBattlefieldInstanceRunTime() / 1000
      if i > 0 then
          return "", format("%d:%02d", i / 60 % 60, i % 60)
      end
  end
end
function Nx.Com:IZM(maI)
  local i = self.ZMo[maI]
  return i and i >= 0
end
function Nx.U_GMS(mon)
  if not mon then
      return "|cffff4040?"
  end
  if mon == 0 then
      return "0"
  end
  local pre = mon > 0 and "" or "-"
  mon = abs(mon)
  local str = ""
  local g = floor(mon / 10000)
  if g > 0 then
      str = format("|cffffff00%dg", g)
  end
  local s = mod(floor(mon / 100), 100)
  if s > 0 then
      str = format("%s |cffbfbfbf%ds", str, s)
  end
  local c = mod(mon, 100)
  if c > 0 then
      str = format("%s |cff7f7f00%dc", str, c)
  end
  return pre .. strtrim(str)
end
function Nx.Com:JoC(chI)
  local opt = Nx:GGO()
  if chI == "A" then
      if not opt["ComNoGlobal"] then
          self.CAN = nil
          self.TrA = 0
          Nx.Tim:Sta("ComA", 0, self, self.OJCAT)
      end
  elseif chI == "Z" then
      if not opt["ComNoZone"] then
          local maI = Nx.Map:GRMI()
          if Nx.Map:INM(maI) then
              local tim = Nx.Tim:Sta("ComZ", 0, self, self.OJCZT)
              tim.UMI = maI
              tim.UTC = 0
          end
      end
  else
      Nx.prt("JoinChan Err %s", chI)
  end
end
function Nx.Que.Lis:M_OWA()
  Nx.Que:WaA()
  self:Upd()
end
function Nx:CSPAW(zx, zy)
  Nx:TTSTCZXY(nil, nil, zx * 100, zy * 100, "Waypoint")
end
function Nx.Fon:FoS(ace, liN)
  local sm
  if ace["HasInstance"](ace, liN) then
      sm = ace(liN)
  end
  if sm then
      local fou
      local fon1 = sm["List"](sm, "font")
      for k, nam in ipairs(fon1) do
          if not self.AdF[nam] then
              fou = true
              self.AdF[nam] = sm["Fetch"](sm, "font", nam)
              tinsert(self.Fac, {nam, self.AdF[nam]})
          end
      end
      return fou
  end
end
function Nx.Map:M_OG(ite)
  self:STAC()
end
function Nx.Men:Clo2()
  self.Clo1 = true
  self.AlT = 0
  if Nx.Men.Cur == self then
      Nx.Men.Cur = false
  end
end
function Nx.Map:ReV(nam)
  local str = format("%s%s", Nx.IBG or "", nam)
  local v = self.VSD[str]
  if v then
      self.Sca = v.Sca
      self.MPX = v.X
      self.MPY = v.Y
      self.StT = 5
  end
end
function Nx.DrD:Sta(use, fun)
  self.Use = use
  self.Fun = fun
  local lis = self.Lis
  lis:Emp()
end
function Nx.U_23(col1)
  local rshift = bit.rshift
  local band = bit.band
  local r = rshift(col1, 24) / 255
  local g = band(rshift(col1, 16), 0xff) / 255
  local b = band(rshift(col1, 8), 0xff) / 255
  local a = band(col1, 0xff) / 255
  return r, g, b, a
end
function Nx:TTSCW(con1, zon, zx, zy, caT, min3, wor1, sil)
  return Nx:TTSTCZXY(con1, zon, zx, zy, "", false, min3, wor1, caT)
end
function Nx.Inf:UpI1()
  local fun1 = self.ItF
  local lis = self.Lis
  local ch = Nx.CuC
  local ite1 = self.Dat["Items"]
  for ind, val in ipairs(ite1) do
      local dat = strsplit("^", val)
      local str = ""
      local pos1 = 1
      local col, tex1
      while true do
          local s1, s2, cap = strfind(dat, "<([^>]+)>", pos1)
          if s1 then
              if s1 > pos1 then
                  str = str .. strsub(dat, pos1, s1 - 1)
              end
              if #cap == 1 then
                  if cap == "c" and col then
                      str = str .. col
                  elseif cap == "t" and tex1 then
                      str = str .. tex1
                  end
              else
                  local cmd, v1, v2, v3, v4 = strsplit(";", cap)
                  local fun = self.ItF[cmd]
                  if fun then
                      col, tex1 = fun(self, v1, v2, v3, v4)
                      if not tex1 then
                          break
                      end
                  end
              end
              pos1 = s2 + 1
          else
              str = str .. strsub(dat, pos1)
              break
          end
      end
      if self.Edi then
          str = format("#%d %s = ", ind, gsub(dat, "|", "||")) .. str
      end
      if #str > 0 then
          lis:ItA(ind)
          local str, ext = strsplit("~", str)
          if ext then
              lis:ISF("Info~" .. ext)
          end
          lis:ItS(1, str)
      end
  end
end
function Nx.U_SV(val1, tar, ste)
  if val1 < tar then
      val1 = val1 + ste
      if val1 > tar then
          val1 = tar
      end
  elseif val1 > tar then
      val1 = val1 - ste
      if val1 < tar then
          val1 = tar
      end
  end
  return val1
end
function Nx.Men:Ini()
  self.Men1 = {}
  self.I_ALPHAFADE = 0
  self.NaN = 0
  self.__index = self
  Nx.MeI.__index = Nx.MeI
end
function Nx.Que.OP__3()
  local self = Nx.Que
  self.Wat:ShU1()
  local pq = self.PaQ
  for nam in pairs(pq) do
      local fou
      for n = 1, GetNumPartyMembers() do
          local pna = UnitName("party" .. n)
          if nam == pna then
              fou = true
              break
          end
      end
      if not fou then
          pq[nam] = nil
          Nx.Tim:Sta("QPartyUpdate", 1, self, self.PUT)
      end
  end
  if GetNumRaidMembers() > 0 then
      return
  end
  if GetNumPartyMembers() == 0 then
      return
  end
  local doS
  for n = 1, GetNumPartyMembers() do
      local uni = "party" .. n
      local nam = UnitName(uni)
      if not pq[nam] then
          doS = true
          pq[nam] = {}
      end
  end
  if doS then
      self:PSS()
  end
end
function Nx.Opt:NXCmdImportCharSettings()
  local function fun(self, nam)
      local function fun()
          if Nx:CCD(nam, UnitName("player")) then
              ReloadUI()
          end
      end
      Nx:ShM(format("Import %s character data and reload?", nam), "Import", fun, "Cancel")
  end
  local t = {}
  for rc in pairs(NxData.Characters) do
      tinsert(t, rc)
  end
  sort(t)
  Nx.DrD:Sta(self, fun)
  Nx.DrD:AdT(t, 1)
  Nx.DrD:Show(self.Lis.Frm)
end
function Nx.Inf:OLE(evN, sel, va2, cli)
  if evN == "update" then
      local liF = self.Lis.Frm
      local lvl = liF:GetFrameLevel() - 1
      local dat = sel
      local y = va2
      local t = {strsplit("&", dat)}
      for _, str in ipairs(t) do
          local v1, v2, v3 = strsplit("^", str)
          local f = Nx.Lis:GeF3(self.Lis, "Info")
          f:ClearAllPoints()
          f:SetPoint("TOPLEFT", liF, "TOPLEFT", 0, y)
          f:SetFrameLevel(lvl)
          f.tex:SetTexture(v1)
          f:SetWidth(tonumber(v2) or 0)
          f:SetHeight(tonumber(v3) or 0)
          f:SetAlpha(.8)
          f:Show()
      end
      return
  end
  local dat = self.Lis:IGD(sel)
  if evN == "select" or evN == "mid" or evN == "menu" then
      if evN == "menu" then
          self.SII = dat
          Nx.Inf:OpM(self)
      end
      self:Upd()
  end
end
function Nx.Que.Wat:CAT(keT)
  if not keT then
      Nx.Que.Tra1 = {}
  end
  self.BAT1:SeP2(false)
  self:Upd()
end
function Nx.Que.Lis:OTB(ind, cli)
  self.FiF2:ClearFocus()
  self.TaS1 = ind
  if ind == 1 then
      self.DeF:Show()
      self:AtF()
  else
      self.DeF:Hide()
      self:AtF()
  end
  local s = self.Fil[self.TaS1]
  s = s ~= "" and s or self.FiD
  self.FiF2:SetText(s)
  self:Upd()
end
function Nx.Map:UpZ()
  local maI = self.MaI
  local win1 = self.MWI[maI]
  local s = self.LOp.NXDetailScale
  local fOS = self.ScD <= s
  if fOS or win1.Cit or self:IBGM(maI) then
      for n, id in ipairs(self.MDO) do
          self:UpO1(id, .8, true)
      end
      if win1.Cit then
          self:UMF()
          self:MCZT()
      else
          self:MCZT()
          self:UpO1(maI, 1)
          self:UMF()
      end
  else
      self:MCZT(true)
      self:UMF()
  end
end
function Nx.Fav:RAT()
  if self.Rec then
      local a = (self.RAA - 35) % 1000
      self.RAA = a
      self.ReB1:SetAlpha(abs(a - 500) / 1000 + .5)
      return .05
  end
end
function Nx.UEv:Ini()
  self.Sor = {}
end
function Nx.MeI:SetChecked(che, vaN)
  self.Che1 = true
  if type(che) == "table" then
      assert(vaN)
      self.Tab = che
      self.VaN = vaN
      che = self.Tab[vaN]
  end
  self.Che = che
  if self.Tab then
      self.Tab[self.VaN] = che
  end
end
function Nx.Map:M_OMDFC(ite)
  self.DFC = ite:GetChecked()
end
function Nx.Men:ChU(ite)
  local f = ite.ChF1
  if f then
      local t = f.tex
      local txN
      if ite.Tab then
          ite.Che = ite.Tab[ite.VaN]
      end
      if ite.Che then
          txN = Nx.Ski:GeT("ButChk")
      else
          txN = Nx.Ski:GeT("But")
      end
      t:SetTexture(txN)
  end
end
function Nx.Que:ReQ1()
  local qcn = GetNumQuestLogEntries()
  for qn = 1, qcn do
      local tit, lev = GetQuestLogTitle(qn)
      if lev < 0 then
          return
      end
  end
  self:SBQDZ()
  self:SBQD()
  self:RQL()
end
function Nx.Que.Lis:M_OSAZ(ite)
  self.SAZ = ite:GetChecked()
  self:Upd()
end
function Nx.Fav:PaI1(ite)
  if ite then
      return strsplit("~", ite)
  end
end
function Nx.Lis:Res1(wid, hei)
  local f = self.Frm
  local hdH = self.HdH
  local liH = self:GLH()
  local paW = 1
  local paH = 0
  if self.ShA then
      hei = self.Num * liH + hdH + paH * 2
      local las = self.Top + self.Vis - 1
      las = min(las, self.Num)
      local stN = 1
      local cNu = 1
      wid = paW * 2
      local ofX = 0
      for k, col3 in ipairs(self.Col) do
          local mCW = col3.Wid
          for lin1 = self.Top, las do
              if self.Off then
                  ofX = self.Off[lin1] or 0
              end
              mCW = max(mCW, self.Str[stN]:GetWidth() + ofX)
              stN = stN + 1
          end
          stN = stN + (self.Vis * cNu - stN + 1)
          wid = wid + mCW
          cNu = cNu + 1
          self.SSW = wid
          self.SSH = hei
      end
  end
  wid = max(self.MiW, wid)
  hei = max(self.MiH, hei)
  f:SetWidth(wid)
  f:SetHeight(hei)
  local sfr = self.SeF2
  sfr:SetWidth(wid - 10)
  hei = max(hei - hdH, 1)
  self.Vis = floor((hei - paH * 2) / liH)
  self.Vis = max(self.Vis, 0)
  local hf = self.HdF
  if hf then
      hf:SetWidth(wid)
      hf:SetHeight(hdH)
  end
  local x = 0
  local clW = wid - paW * 2
  for k, col3 in ipairs(self.Col) do
      local coW = min(col3.Wid, clW)
      col3.ClW = coW
      local hfs = col3.FSt
      if hfs then
          hfs:SetPoint("TOPLEFT", paW + x, 0)
          hfs:SetWidth(coW)
      end
      x = x + col3.Wid
      clW = clW - col3.Wid
  end
  self:CrS()
  self:CrB()
end
function Nx.Map:IOMD(but)
  local map = this.NxM1
  map:CaC3()
  map.ClF = this
  map.ClT2 = this.NXType
  map.ClI = this.NXData
  local shi = IsShiftKeyDown()
  if but == "LeftButton" then
      local cat1 = floor((this.NXType or 0) / 1000)
      if cat1 == 2 and shi then
          if map.BGIN > 0 then
              local _, _, _, str = strsplit("~", map.BGM)
              local _, _, _, st2 = strsplit("~", this.NXData)
              if str ~= st2 then
                  Nx.Tim:Fir("BGInc")
              end
          end
          map.BGM = this.NXData
          map.BGIN = map.BGIN + 1
          UIErrorsFrame:AddMessage("Inc " .. map.BGIN, 1, 1, 1, 1)
          Nx.Tim:Sta("BGInc", 1.5, map, map.BGIST)
      else
          if map:IDC() then
              if cat1 == 3 then
                  map:GM_OG()
              end
          else
              this = map.Frm
              map:OMD(but)
          end
      end
  else
      if but == "RightButton" then
          local typ = this.NXType
          if typ then
              local i = floor(typ / 1000)
              if i == 1 then
                  map:BPL()
                  map.PIM:Ope()
              elseif i == 2 then
                  Nx.Tim:Fir("BGInc")
                  map.BGM = this.NXData
                  map.BGIM:Ope()
              elseif i == 3 then
                  map:GMO(this.NXData, typ)
              elseif i == 9 then
                  Nx.Que:IOMD(this)
              end
          end
      else
          this = map.Frm
          map:OMD(but)
      end
  end
end
function Nx.But:GeS3()
  return self.Sta2
end
function Nx.Map.Gui:UZPOII()
  local Que = Nx.Que
  local Map = Nx.Map
  local map = self.Map
  local maI = map.MaI
  local atS = map.LOp.NXPOIAtScale
  local alR1 = atS * .25
  local s = atS - alR1
  local dra = map.ScD > s and map.GOp["MapShowPOI"]
  local alp = min((map.ScD - s) / alR1, 1) * map.GOp["MapIconPOIAlpha"]
  map:SITA("!POI", alp)
  map:SITA("!POIIn", alp)
  if maI == self.POIMI and dra == self.POID then
      return
  end
  self.POIMI = maI
  self.POID = dra
  map:IIT("!POI", "WP", "", 17, 17)
  map:IIT("!POIIn", "WP", "", 21, 21)
  if not dra then
      return
  end
  map:SITC("!POI", true)
  map:SITA("!POI", alp)
  map:SITC("!POIIn", true)
  map:SITA("!POIIn", alp)
  local hiF = UnitFactionGroup("player") == "Horde" and 1 or 2
  local con1 = map:ITCZ(maI)
  if con1 > 0 and con1 < 9 then
      for k, nam in ipairs(Nx.GPOI) do
          local shT, tx = strsplit("~", nam)
          tx = "Interface\\Icons\\" .. tx
          self:UMGI(con1, shT, hiF, tx, shT, "!POI", maI)
      end
      self:UII1(con1)
      self:UTI(hiF)
  end
end
function Nx.Map:OnE(eve, ...)
  if eve == "WORLD_MAP_UPDATE" then
      Nx.Que:MaC()
      if this:IsVisible() then
          this.NxM1:UpA()
      end
  end
end
function Nx.Map:OMD(but)
  local map = this.NxM1
  local this = map.Frm
  local x, y = GetCursorPosition()
  x = x / this:GetEffectiveScale()
  y = y / this:GetEffectiveScale()
  map:CaC3()
  ResetCursor()
  if but == "LeftButton" then
      if IsControlKeyDown() and map:CaF1("MapButLCtrl") then
      elseif IsAltKeyDown() and map:CaF1("MapButLAlt") then
      elseif IsShiftKeyDown() then
          map:Pin()
      else
          if map:IDC() then
              map:CeM()
              map.DMI1 = map.MaI
          else
              map.LCT = GetTime()
              map.Scr2 = true
              map.ScX = x
              map.ScY = y
              map.ScF1 = map.ClF
          end
      end
  elseif but == "MiddleButton" then
      if IsControlKeyDown() then
          map:CaF1("MapButMCtrl")
      elseif IsAltKeyDown() then
          map:CaF1("MapButMAlt")
      else
          map:CaF1("MapButM")
      end
  elseif but == "RightButton" then
      if IsControlKeyDown() and map:CaF1("MapButRCtrl") then
      elseif IsAltKeyDown() and map:CaF1("MapButRAlt") then
      else
          map:CaF1("MapButR")
      end
  elseif but == "Button4" then
      if IsControlKeyDown() then
          map:CaF1("MapBut4Ctrl")
      elseif IsAltKeyDown() then
          map:CaF1("MapBut4Alt")
      else
          map:CaF1("MapBut4")
      end
  end
end
function Nx.U_CS(str)
  return strupper(strsub(str, 1, 1)) .. strlower(strsub(str, 2))
end
function Nx.Ski:GetBackdrop()
  return self.Dat["Backdrop"]
end
function Nx.War:AdI1(ite1, typ, nam, dat)
  local toB = 0
  local toB1 = 0
  local toM1 = 0
  if ite1[nam] then
      toB, toB1, toM1 = strsplit("^", ite1[nam])
  end
  local cou, iLi = strsplit("^", dat)
  if typ == 2 then
      toB = toB + cou
  elseif typ == 3 then
      toB1 = toB1 + cou
  elseif typ == 4 then
      toM1 = toM1 + cou
  end
  ite1[nam] = format("%d^%d^%d^%s", toB, toB1, toM1, iLi)
end
function Nx.Lis:OHMD(cli)
  local x = Nx.U_IMO(this)
  if x then
      local self = this.NxI
      local id, col3 = self:CHT(x)
      if id then
          if IsShiftKeyDown() then
              local add = cli == "LeftButton" and 10 or -10
              col3.Wid = max(col3.Wid + add, 10)
              self:SaC()
              self:FuU()
          else
              if cli == "LeftButton" then
                  if id and self.UsF then
                      self.UsF(self.Use, "sort", 0, id)
                  end
              else
                  Nx.prt("shift left/right click to change size")
              end
          end
      end
  end
end
function Nx.Tit:Tic()
  local this = self.Frm
  local opt = Nx:GGO()
  if opt["TitleOff"] then
      this:Hide()
  end
  self.X = self.X + self.XV
  self.Y = self.Y + self.YV
  self.Sca = Nx.U_SV(self.Sca, self.ScT, .8 / 60)
  this:SetPoint("CENTER", self.X / self.Sca, self.Y / self.Sca)
  this:SetScale(self.Sca)
  self.Alp = Nx.U_SV(self.Alp, self.AlT, .8 / 60)
  this:SetAlpha(self.Alp)
  if self.Alp == 1 then
      local sw = GetScreenWidth() / 2
      local sh = GetScreenHeight() / 2
      self.XV = (sw * .95 - self.X) / 80
      self.YV = (sh * .95 - self.Y) / 80
      self.ScT = .03
      self.AlT = 0
      return 1 * 60
  end
  if self.Alp == 0 then
      this:Hide()
      collectgarbage("collect")
      return -1
  end
end
function Nx.Que.Lis:M_OSW1(ite)
  local on = ite:GetChecked()
  Nx.Que:SWSM(on and 1 or 0)
end
function Nx.Map:MNGI(res1)
  local mm = self.MMF
  Nx.Tim:Sto("MapNodeGlow")
  if res1 then
      mm:SetBlipTexture("Interface\\Minimap\\objecticons")
  end
  local del = self.GOp["MapMMNodeGD"]
  if del > 0 then
      if not self.MMGI then
          self.MMGI = true
          local t = mm:CreateTexture(nil, "BACKGROUND")
          t:SetAllPoints()
          t:SetTexture("Interface\\AddOns\\Carbonite\\Gfx\\Map\\MMOIcons")
          t:Hide()
          local t = mm:CreateTexture(nil, "BACKGROUND")
          t:SetAllPoints()
          t:SetTexture("Interface\\AddOns\\Carbonite\\Gfx\\Map\\MMOIconsG")
          t:Hide()
      end
      Nx.Tim:Sta("MapNodeGlow", .1, self, self.OMNGT)
  end
end
function Nx.Map.Gui:OLE(evN, sel, va2, cli)
  self:OLED(self.Lis, evN, sel, va2, cli)
end
function Nx.Map:FPTWP(x, y)
  x = self.MPX + (x - self.PaX - self.MaW / 2) / 10.02 / self.MaS
  y = self.MPY + (y - self.TiH - self.MaH / 2) / 10.02 / self.MaS
  return x, y
end
function Nx.Lis:Loc1(loc1)
  self.Frm:EnableMouse(not loc1)
  self.Frm:EnableMouseWheel(not loc1)
end
function Nx.U_TMI(t, i, low)
  if low then
      if i > 1 then
          t[i - 1], t[i] = t[i], t[i - 1]
          return i - 1
      end
  else
      if i < #t then
          t[i + 1], t[i] = t[i], t[i + 1]
          return i + 1
      end
  end
end
function Nx.Fav:SIF(ind, mas, orF)
  local fav = self.CuF
  if fav then
      local typ, fla, nam, dat = strsplit("~", fav[ind])
      fla = bit.bor(bit.band(strbyte(fla) - 35, mas), orF) + 35
      if dat then
          fav[ind] = format("%s~%c~%s~%s", typ, fla, nam, dat)
      else
          fav[ind] = format("%s~%c~%s", typ, fla, nam)
      end
  end
end
function Nx.Map:IOM(maI)
  return maI >= 3000 and maI <= 3999
end
function Nx.War:RCS()
  local ch = Nx.CuC
  for _, v in pairs(ch["Profs"]) do
      v.Old = true
  end
  self.SkR = 0
  for n = 1, GetNumSkillLines() do
      local nam, hdr1, exp1 = GetSkillLineInfo(n)
      if not nam then
          break
      end
      if hdr1 and (nam == self.LPr or nam == self.LSS) then
          local ope
          if not exp1 then
              ExpandSkillHeader(n)
              ope = n
          end
          for n2 = n + 1, GetNumSkillLines() do
              local nam, hdr1, exp1, ran, teP, mod4 = GetSkillLineInfo(n2)
              if hdr1 then
                  break
              end
              if nam == NXlRiding then
                  self.SkR = ran
              else
                  local t = ch["Profs"]
                  local p = t[nam] or {}
                  t[nam] = p
                  p["Rank"] = ran
                  p.Old = nil
              end
          end
          if ope then
              CollapseSkillHeader(ope)
          end
      end
  end
  for nam, v in pairs(ch["Profs"]) do
      if v.Old then
          ch["Profs"][nam] = nil
          Nx.prt("%s deleted", nam)
      end
  end
end
function Nx.Map.Gui:IUF(fol)
  if fol[1] then
      return
  end
  self:ItL1()
  local roo = CarboniteItems
  if not roo then
      fol[1] = {
          Nam = "CarboniteItems addon missing"
      }
      return
  end
  if fol.Ite == -8 then
      if not fol[1] then
          self:IICF(fol)
      end
      return
  end
  local typ2 = {strsplit("^", fol.T)}
  for _, typ in ipairs(typ2) do
      local ite1 = fol.ItD or roo[fol.Ite < 0 and typ or typ .. fol.Ite]
      assert(ite1)
      for n = 1, #ite1, 3 do
          local id = (strbyte(ite1, n) - 35) * 48841 + (strbyte(ite1, n + 1) - 35) * 221 + strbyte(ite1, n + 2) - 35
          self:IAI(fol, id)
      end
      sort(fol, function(a, b)
          return a.Sor1 < b.Sor1
      end)
  end
end
function Nx.Hel.Lic:OMW(val1)
  val1 = val1 * 30
  if IsShiftKeyDown() then
      val1 = val1 * 5
  end
  local self = this.NxI
  self.Top = max(self.Top - val1, 0)
  self.Frm:SetPoint("TOPLEFT", 0, self.Top)
  self.Sli:Set(self.Top)
  self.Sli:Upd()
end
function ToggleWorldMap()
  local opt = Nx:GGO()
  if Nx.Map.BlT or WorldMapFrame:IsShown() or IsAltKeyDown() or not opt["MapMaxOverride"] then
      Nx.Map:BTWM()
  else
      Nx.Map:ToS1()
  end
end
function Nx.Lis:SCF1(fon, bLH)
  self.CFo = fon
  self.CBLH = bLH
end
function Nx.MapAddIconRect(icT, maN, x, y, x2, y2, col)
  local map = Nx.Map:GeM(1)
  local maI = Nx.MNTI1[maN]
  if maI then
      map:AIR(icT, maI, x, y, x2, y2, col)
  end
end
function Nx.Que.Wat:OnT(ite)
  local cur1 = Nx.Que.CuQ
  if not cur1 then
      return
  end
  local i = self.CDI
  local cnt = self.CDC
  Nx.Que:CaD3(i, i + cnt - 1)
  i = i + cnt
  if i <= #cur1 then
      self.CDI = i
      return .02
  end
  local wat = self:UpL1()
end
function Nx.War:ReP()
  local lin3 = IsTradeSkillLinked()
  if lin3 then
      return
  end
  local cnt = GetNumTradeSkills()
  if cnt == 0 then
      return
  end
  local ch = Nx.CuC
  local tit = GetTradeSkillLine()
  local prT2 = ch["Profs"][tit]
  if not prT2 then
      return
  end
  local lin = GetTradeSkillListLink()
  if lin then
      prT2["Link"] = lin
  end
  for n = 1, cnt do
      local nam, typ, ava, isE = GetTradeSkillInfo(n)
      if typ ~= "header" then
          local lin = GetTradeSkillRecipeLink(n)
          local rId = lin and strmatch(lin, "enchant:(%d+)")
          local lin = GetTradeSkillItemLink(n)
          local itI = lin and strmatch(lin, "item:(%d+)") or 0
          if rId then
              prT2[tonumber(rId)] = tonumber(itI)
          end
      end
  end
end
function Nx:GeG(typ, id)
  local v = Nx.GaI1[typ][id]
  if v then
      return v[self.GLI], v[2], v[1]
  end
end
function Nx.Win:IsL()
  return self.Loc2
end
function Nx.Lis:ISD(ind, dat)
  self.Dat[ind] = dat
end
function Nx.HUD:SeF1(fad2)
end
function Nx.Opt:NXCmdFontChange()
  Nx.Fon:Upd()
end
function Nx.Map:RoT()
  local poi2 = {}
  for n, tar1 in ipairs(self.Tar) do
      local wx = tar1.TMX
      local wy = tar1.TMY
      local x, y = self:GZP(self.MaI, wx, wy)
      local pt = {}
      tinsert(poi2, pt)
      pt.Nam = tar1.TaN1
      pt.X = x
      pt.Y = y
  end
  local rou = self:Rou(poi2)
  if rou then
      self:RTT(rou)
  end
end
function Nx.Map.Gui:ItL1()
  if CarboniteItems then
      return
  end
  if not LoadAddOn("CarboniteItems") then
      Nx.prt("CarboniteItems addon could not be loaded!")
      return
  end
  if not CarboniteItems then
      Nx.prt("CarboniteItems addon error!")
      return
  end
  Nx.prt("CarboniteItems loaded")
end
function Nx.Fav:GIF(ind)
  return "Interface\\TargetingFrame\\UI-RaidTargetingIcon_" .. ind
end
function Nx.Map:ScC1()
  Nx.Map.SCM = 500
  local olC = GetCurrentMapContinent()
  if olC < 0 then
      return
  end
  local olZ = GetCurrentMapZone()
  local hiT = {}
  hiT[0] = true
  hiT[6] = not self.GOp["MapShowCCity"]
  hiT[41] = not self.GOp["MapShowCExtra"]
  hiT[5] = not self.GOp["MapShowCTown"]
  for con1 = 1, self.CoC do
      local poT = {}
      self.CPOI[con1] = poT
      SetMapZoom(con1)
      local maI = con1 * 1000
      local nam, des, txI, pX, pY
      local tX11, tX21, tY11, tY21
      local poN = GetNumMapLandmarks()
      for n = 1, poN do
          nam, des1, txI, pX, pY = GetMapLandmarkInfo(n)
          if nam and not hiT[txI] then
              local poi1 = {}
              tinsert(poT, poi1)
              poi1.Nam = nam
              poi1.Des = des1
              poi1.TxI = txI
              local x, y = self:GWP(maI, pX * 100, pY * 100)
              poi1.WX = x
              poi1.WY = y
          end
      end
  end
  SetMapZoom(olC, olZ)
end
function Nx.Soc.Lis.SPA(per1, fri)
  per1 = Nx.U_CN(per1)
  local lis = Nx.Soc.Lis
  lis:SPF(per1, fri)
  lis:Upd()
end
function Nx.War:M_OE1(ite)
  local s = format("Overwrite all character settings and reload?", sna)
  Nx:ShM(s, "Export", Nx.War.ExD, "Cancel")
end
function Nx.Que:UnN1(inf)
  local i = strbyte(inf, 1) - 35 + 1
  return strsub(inf, 2, i)
end
function Nx.Inf:ReF()
  local frm1 = self.Frm1
  frm1.Use1 = frm1.Nex - 1
  frm1.Nex = 1
end
function Nx.prS(str)
  local s = debugstack(3, 3, 0)
  s = gsub(s, "Interface\\AddOns\\", "")
  Nx.prt("%s: %s", str, s)
end
function Nx.Map.Gui:UMI1()
  local Nx = Nx
  local Que = Nx.Que
  local Map = Nx.Map
  local map = self.Map
  assert(map)
  local hiF = self:GHF()
  map:IIT("!G", "WP", "", 16, 16)
  map:SITC("!G", true)
  map:IIT("!GIn", "WP", "", 20, 20)
  map:SITC("!GIn", true)
  map:IIT("!Ga", "WP", "", 12, 12)
  local a = map.GOp["MapIconGatherA"]
  map:SITA("!Ga", a, a < 1 and a * .5)
  map:SITC("!Ga", true)
  map:SITAS("!Ga", map.GOp["MapIconGatherAtScale"])
  map:IIT("!GQ", "WP", "", 16, 16)
  map:SITC("!GQ", true)
  map:SITL("!GQ", 1)
  map:IIT("!GQC", "WP", "", 10, 10)
  map:SITC("!GQC", true)
  local co1 = 1
  local co2 = Map.CoC
  local maI = map:GCMI()
  if not self.SAC then
      co1 = map:ITCZ(maI)
      co2 = co1
  end
  for shT, fol in pairs(self.ShF) do
      local mod1 = strbyte(shT)
      local tx = "Interface\\Icons\\" .. fol.Tx
      if mod1 == 36 then
          local type = strsub(shT, 2, 2)
          local loT = type == "H" and "Herb" or type == "M" and "Mine"
          local fid = fol.Id
          local dat = loT and Nx:GeD(loT) or NxData.NXGather["Misc"]
          local zoT = dat[maI]
          if zoT then
              local noT = zoT[fid]
              if noT then
                  for k, nod in ipairs(noT) do
                      local x, y = Nx:GaU(nod)
                      local nam, tex2, ski1 = Nx:GeG(type, fid)
                      assert(nam)
                      local wx, wy = Map:GWP(maI, x, y)
                      ico = map:AIP("!Ga", wx, wy, nil, "Interface\\Icons\\" .. tex2)
                      if ski1 > 0 then
                          nam = nam .. " " .. ski1
                      end
                      map:SIT(ico, nam)
                  end
              end
          end
      elseif mod1 == 35 then
      elseif mod1 == 37 then
          local maI = fol.IMI
          local win1 = Map.MWI[maI]
          local wx = win1[2]
          local wy = win1[3]
          local ico = map:AIP("!GIn", wx, wy, nil, tx)
          map:SIT(ico, fol.InT2)
          map:SIUD(ico, fol.IMI)
      elseif mod1 == 38 then
          if Que.QGi then
              local maI = map:GCMI()
              local zon = Nx.MITN1[maI]
              local stz = Que.QGi[zon]
              if stz then
                  local opt = Nx:GGO()
                  local miL = Nx.CuC["Level"] - opt["QMapQuestGiversLowLevel"]
                  local maL1 = Nx.CuC["Level"] + opt["QMapQuestGiversHighLevel"]
                  local sta1 = Nx.ChO[fol.Per]
                  local deM = NxData.DebugMap
                  local shC = self.SQGC
                  local qId1 = Que.QId1
                  for nam2, qda in pairs(stz) do
                      local nam = strsplit("=", nam2)
                      local anD
                      local show
                      local s = nam
                      for n = 1, #qda, 4 do
                          local qId = tonumber(strsub(qda, n, n + 3), 16)
                          local que = Que.ITQ[qId]
                          local qna, _, lvl, min5 = Que:Unp(que[1])
                          if lvl < 1 then
                              lvl = Nx.CuC["Level"]
                          end
                          if lvl >= miL and lvl <= maL1 then
                              local col2 = "|r"
                              local dai = Que.DaI[qId] or Que.DDI[qId]
                              anD = anD or dai
                              local sta, qTi = Nx:GeQ(qId)
                              if dai then
                                  col2 = "|cffa0a0ff"
                                  show = true
                              elseif sta == "C" then
                                  col2 = "|cff808080"
                              else
                                  if qId1[qId] then
                                      col2 = "|cff80f080"
                                  end
                                  show = true
                              end
                              s = format("%s\n|cffbfbfbf%d%s %s", s, lvl, col2, qna)
                              if que.CNu then
                                  s = s .. format(" (Part %d)", que.CNu)
                              end
                              if dai then
                                  s = s .. (Que.DDI[qId] and " (Dungeon Daily" or " (Daily")
                                  local typ, mon, rep, req = strsplit("^", dai)
                                  if rep and #rep > 0 then
                                      s = s .. ", "
                                      for n = 0, 1 do
                                          local i = n * 4 + 1
                                          local reC = strsub(rep or "", i, i)
                                          if reC == "" then
                                              break
                                          end
                                          s = s .. " " .. Que.Rep[reC]
                                      end
                                  end
                                  s = s .. ")"
                              end
                              if deM then
                                  s = s .. format(" [%d]", qId)
                              end
                          end
                      end
                      if sta1 == 3 and not anD then
                          show = false
                          shC = false
                      end
                      if show or shC then
                          local qId = tonumber(strsub(qda, 1, 4), 16)
                          local que = Que.ITQ[qId]
                          local stN1, zon, x, y = Que:GOP(que, que[2])
                          local wx, wy = Map:GWP(maI, x, y)
                          local tx = anD and "Interface\\AddOns\\Carbonite\\Gfx\\Map\\IconExclaimB" or tx
                          local ico = map:AIP(show and "!GQ" or "!GQC", wx, wy, nil, tx)
                          map:SIT(ico, s)
                          ico.UDQGD = qda
                      end
                  end
              end
          end
      elseif mod1 == 40 then
          local maI, x, y = strsplit("^", fol.VeP1)
          maI = tonumber(maI)
          x = tonumber(x)
          y = tonumber(y)
          local wx, wy = Map:GWP(maI, x, y)
          local ico = map:AIP("!G", wx, wy, nil, tx)
          map:SIT(ico, fol.Nam)
      elseif mod1 == 41 then
          local vv = NxData.NXVendorV
          local t = {strsplit("^", fol.ItS1)}
          for _, npN in pairs(t) do
              local npc = vv[npN]
              if npc then
                  local lin2 = npc["POS"]
                  local maI, x, y = strsplit("^", lin2)
                  maI = tonumber(maI)
                  x = tonumber(x)
                  y = tonumber(y)
                  local wx, wy = Map:GWP(maI, x, y)
                  local ico = map:AIP("!G", wx, wy, nil, tx)
                  local tag, nam = strsplit("~", npN)
                  local ina1 = strsplit("\n", fol.Nam)
                  map:SIT(ico, format("%s\n%s\n%s", nam, tag, ina1))
              end
          end
      elseif mod1 == 42 then
          local coS2 = Nx.ZoC[fol.CoI1]
          local fla, coT, mI1, x1, y1, mI2, x2, y2, na11, na21 = Nx.Map:CoU(coS2)
          if fol.Co2 then
              mI1, x1, y1, na11 = mI2, x2, y2, na21
          end
          local wx, wy = Map:GWP(mI1, x1, y1)
          local ico = map:AIP("!G", wx, wy, nil, tx)
          map:SIT(ico, format("%s\n%s %.1f %.1f", na11, Nx.MITN[mI1], x1, y1))
      else
          for con1 = co1, co2 do
              self:UMGI(con1, shT, hiF, tx, fol.Nam, "!G")
          end
      end
  end
end
function Nx.Com:ICT(tyN)
  for n = 1, 10 do
      local _, nam = GetChannelName(n)
      if nam then
          local na3 = strsub(nam, 1, 3)
          if na3 == self.Nam then
              local typ = strsub(nam, 4, 4)
              if typ == tyN then
                  return true
              end
          end
      end
  end
end
function Nx.But:SeS(w, h)
  self.Frm:SetWidth(w)
  self.Frm:SetHeight(h)
end
function Nx.Que:ShowUIPanel(fra)
  if self.ISUIP then
      return
  end
  self.ISUIP = true
  fra:Hide()
  local deF = QuestLogDetailFrame
  if deF then
      deF:Hide()
  end
  local ori1 = IsAltKeyDown() and not self.IgA
  local opt = self.GOp
  if opt["QUseAltLKey"] then
      ori1 = not ori1
  end
  if ori1 then
      fra:SetScale(1)
      QuestLogFrame:SetAttribute("UIPanelLayout-enabled", true)
      ShowUIPanel(fra)
      if deF then
          deF:SetScale(1)
      end
      self:LHA(fra)
  else
      local win = self.Lis.Win1
      if win and not GameMenuFrame:IsShown() then
          self:ExQ()
          local wf = win.Frm
          win:Show()
          self.Lis:Upd()
          wf:Raise()
          fra:Show()
          fra:SetScale(.1)
          fra:SetPoint("TOPLEFT", -999, 999)
          if deF then
              deF:SetScale(.1)
              deF:SetPoint("TOPLEFT", -999, 999)
          end
          self:LHA(wf, true)
      end
  end
  self.ISUIP = false
end
function Nx.Tim:Tim1(nam)
  if self.Dat[nam] then
      return self.Dat[nam].T
  end
end
function Nx:GaH(id, maI, x, y)
  self:Gat("NXHerb", id, maI, x, y)
end
function Nx.Map:GoP()
  self:CaT1()
  SetMapToCurrentZone()
  self.MLX = -1
  self.MLY = -1
end
function Nx.Opt:NXCmdMapToolBarUpdate()
  local map = Nx.Map:GeM(1)
  map:UTB()
end
function Nx.War.OL__()
  local self = Nx.War
  if not self.LoT then
      self:prt1("no LootTarget")
      return
  end
  if self.LoI3[arg1] then
      local nam, iLi, iRa, lvl, miL, iTy = GetItemInfo(self.LoI3[arg1])
      if iTy == "Quest" then
          self:prt1("LOOT_SLOT_CLEARED #%s %s (quest)", arg1, self.LoI3[arg1])
          self:Cap(iLi)
      end
  end
end
function Nx.Fav:AdF1(nam, par, ind)
  local fol = {}
  fol["Name"] = nam
  fol["T"] = "F"
  par = par or self.Fol
  if par then
      ind = ind or #par + 1
      tinsert(par, ind, fol)
  end
  return fol
end
function Nx.Map.Gui:IICF(fol)
  local cSr = CarboniteItems["CSrc"]
  for arN, arD in pairs(cSr) do
      local arT = {}
      tinsert(fol, arT)
      arT.Nam = strsub(arN, 4)
      local aMi = strbyte(arN) - 35
      local aMa = strbyte(arN, 2) - 35
      local aGr = strbyte(arN, 3) - 35
      if aMi == aMa then
          arT.Co21 = format("%2d", aMi)
      else
          arT.Co21 = format("%2d-%d", aMi, aMa)
      end
      arT.Co3 = format("%2d-Man", aGr)
      for cNa, cDa in pairs(arD) do
          local cT = {}
          tinsert(arT, cT)
          local dif = strbyte(cNa)
          cNa = strsub(cNa, 2)
          if dif - 35 > 1 then
              cNa = cNa .. " (Heroic)"
          end
          cT.Nam = cNa
          cT.T = ""
          cT.Ite = -9
          cT.ItD = cDa
      end
      sort(arT, function(a, b)
          return a.Nam < b.Nam
      end)
  end
  sort(fol, function(a, b)
      return a.Nam < b.Nam
  end)
end
function Nx.NXMiniMapBut:M_OSA(ite)
  Nx.ASBOP = ite:GetChecked()
  if AuctionFrame and AuctionFrame:IsShown() then
      AuctionFrameBrowse_Update()
  end
end
function Nx.Que:IOMD(frm)
  local cur = self.IHC
  if cur then
      self.IMC = cur
      self.IMOI = self.IHOI
      local qSt = Nx:GeQ(cur.QId)
      self.IMIW:SetChecked(qSt == "W")
      self.IcM:Ope()
  end
end
function Nx.Map:ITCZ(maI)
  if maI >= 10000 then
      return floor(maI / 1000) - 10, 0
  end
  local inf = self.MWI[maI]
  return inf.Con or 9, inf.Zon or 0
end
function Nx.Soc.Lis:M_OPA()
  local nam = UnitName("target")
  if nam and UnitIsPlayer("target") and UnitIsEnemy("player", "target") then
      self:PuA1(nam, UnitLevel("target"), UnitClass("target"))
      self:Upd()
  else
      Nx:SEB("Add punk name", self.MSN1 or Nx.Soc.LLP or "", self, self.PAA)
  end
end
function Nx.UEv:AdH1(nam)
  local maI = self:AdI(nam)
  if Nx.Map:IBGM(maI) then
      RequestBattlefieldScoreData()
  end
end
function Nx.War:ToP()
  if not self.Ena or not Nx:GGO()["WarehouseAddTooltip"] then
      return
  end
  local tip = GameTooltip
  local nam, lin = tip:GetItem()
  if nam then
      local tiS1 = format("|cffffffffW%sarehouse:", Nx.TXTBLUE)
      local teN = "GameTooltipTextLeft"
      for n = 2, tip:NumLines() do
          local s1 = strfind(getglobal(teN .. n):GetText() or "", tiS1)
          if s1 then
              return
          end
      end
      local str, cou, tot = self:FCWI(lin)
      if tot > 1 then
          str = gsub(str, "\n", "\n ")
          tip:AddLine(format("%s |cffe0e020%s\n |cffb0b0b0%s", tiS1, tot, str))
          return true
      end
  end
end
function Nx:FiC(nam)
  for cnu, rc in ipairs(Nx.ReC1) do
      local ch = NxData.Characters[rc]
      if ch then
          local rna, cna = strsplit(".", rc)
          if cna == nam then
              return ch
          end
      end
  end
  return NxData.Characters[nam]
end
function Nx.Map:Rou(poi2)
  if #poi2 == 0 then
      return
  end
  local tm = GetTime()
  local rou = {}
  for n, pt in ipairs(poi2) do
      pt.Y = pt.Y / 1.5
  end
  if #poi2 > 1 then
      local x = poi2[1].X
      local y = poi2[1].Y
      if x == poi2[#poi2].X and y == poi2[#poi2].Y then
          tremove(poi2)
      end
  end
  local x, y = self:GZP(self.MaI, self.PlX, self.PlY)
  y = y / 1.5
  while #poi2 > 0 do
      local clD = 999999999
      local clI
      for n, pt in ipairs(poi2) do
          local dis = (x - pt.X) ^ 2 + (y - pt.Y) ^ 2
          if dis < clD then
              clD = dis
              clI = n
          end
      end
      local pt = tremove(poi2, clI)
      local r = {}
      tinsert(rou, r)
      r.Nam = pt.Nam
      r.X = pt.X
      r.Y = pt.Y
      r.Wei = pt.Wei or 1
      x = pt.X
      y = pt.Y
  end
  local x = rou[1].X
  local y = rou[1].Y
  if x ~= rou[#rou].X or y ~= rou[#rou].Y then
      local r = {}
      r.X = x
      r.Y = y
      tinsert(rou, r)
  end
  local len = self:RoL(rou)
  for n = 1, 5 do
      local swa = self:RoO(rou)
      if not swa then
          break
      end
  end
  local sca = self:GWZS(self.MaI)
  local len = self:RoL(rou)
  Nx.prt("Routed %s nodes, %d yards in %.1f secs", #rou, len * sca * 4.575, GetTime() - tm)
  return rou
end
function Nx.Map:WUF(fad2)
  self.ToB:SeF1(fad2)
  self.BASO.Frm:SetAlpha(fad2)
end
function Nx:AKE(nam, time, maI, x, y)
  self:AdE("Kill", nam, time, maI, x, y)
  local ev = Nx.CuC.E["Kill"]
  local ite = ev[#ev]
  ite.NXKills = 0
  for k, v in pairs(ev) do
      if v.NXName == nam then
          ite.NXKills = ite.NXKills + 1
      end
  end
end
function Nx.War:CaI()
  Nx.Tim:PrS("WH CaptureItems")
  local ch = Nx.CuC
  local inv = {}
  ch["WareInv"] = inv
  for _, nam in ipairs(self.InN) do
      local id = GetInventorySlotInfo(nam)
      local lin = GetInventoryItemLink("player", id)
      if lin then
          tinsert(inv, format("%s^%s", nam, lin))
      end
  end
  local inv = {}
  ch["WareBags"] = inv
  self:AdB1(KEYRING_CONTAINER, false, inv)
  self:AdB1(BACKPACK_CONTAINER, false, inv)
  for bag1 = 1, NUM_BAG_SLOTS do
      self:AdB1(bag1, false, inv)
  end
  if self.BaO then
      local inv = {}
      self:AdB1(BANK_CONTAINER, true, inv)
      for bag1 = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
          self:AdB1(bag1, true, inv)
      end
      if next(inv) then
          ch["WareBank"] = inv
      end
  else
      if self.LoB and self.LoB1 and not self.Loc2 then
          self:AdL1(self.LoL, self.LoC, ch["WareBank"])
      end
  end
  Nx.Tim:PrE("WH CaptureItems")
  self:prt1("WH CapItems %s", Nx.Tim:PGLT("WH CaptureItems"))
end
function Nx.Map:CM1T1(maI)
  self.MPX, self.MPY = self:GWP(maI, 50, 50)
  self.Sca = 1002 / 100 / self:GWZS(maI) * GetScreenWidth() / 1680 * 2
  self.ScD = self.Sca
  self.StT = 10
end
function Nx.Que:FNQ()
  local aQN = self.AQN
  if not aQN then
      return
  end
  local cnt = GetNumQuestLogEntries()
  for qn = 1, cnt do
      local tit, lev, tag, grC, isH, isC, isC1 = GetQuestLogTitle(qn)
      if not isH then
          tit = self:ExT(tit)
          if tit == aQN then
              if not self.ReQ[tit] then
                  self.AQN = nil
                  return qn
              end
          end
      end
  end
end
function Nx.Map:GWP(maI, maX, maY)
  local win1 = self.MWI[maI]
  if win1 then
      local sca = win1[1]
      return win1[4] + maX * sca, win1[5] + maY * sca / 1.5
  end
  return 0, 0
end
function Nx.U_24(col1)
  return bit.band(col1, 0xff) / 255
end
function Nx.Que:M_OT1()
  local cur = self.IMC
  local v = cur.QId * 0x10000 + self.IMOI * 0x100 + cur.QI
  self.Wat:Set(v, true, true)
end
function Nx.Gra:SS_OVC()
  self.NxG.ScX1 = self:GetValue()
  self.NxG:UpF()
end
function Nx:GDM()
  NxData.NXGather.NXMine = {}
end
function Nx.Hel.Lic:ShO()
  Nx.Sec:Sta()
end
function Nx.Win:STC(r, g, b, a)
  for n = 1, self.TiL do
      local fst = self.TFS[n]
      fst:SetTextColor(r, g, b, a)
  end
end
function Nx.Map:M_OSW(ite)
  self.CuO.NXWorldShow = ite:GetChecked()
end
function Nx.Win:STXO(x, yo)
  yo = yo or 0
  for n = 1, self.TiL do
      local fst = self.TFS[n]
      local y = -self.BoH - (n - 1) * self.TLH - .4
      fst:SetPoint("TOPLEFT", self.BoW + x, y - yo)
      fst:SetPoint("TOPRIGHT", self.Frm, "TOPRIGHT", -self.BoW, y)
  end
end
function Nx.NXWatchKeyUseItem()
  if NLF1 then
      NLF1:Click()
  end
end
function Nx:OZ___(eve)
  Nx.UEv:AdI("Entered")
  Nx.Com:OnE(eve)
end
function Nx.Soc.PHUD:Upd()
  if not self.Win1 then
      return
  end
  local Soc = Nx.Soc
  if self.Cha then
      local loD = InCombatLockdown() ~= nil
      local lch = self.LoD1 ~= loD
      self.LoD1 = loD
      if not loD then
          self.Cha = false
          local pun = Soc.Pun
          local puA = Soc.PuA
          local n = 1
          for ind, nam in ipairs(self.Pun) do
              local pun1 = self.Pun[nam]
              local but1 = self.But1[n]
              local function fun(self)
                  Nx.prt("hey")
              end
              but1:SetAttribute("macrotext1", "/targetexact " .. nam)
              but1.NXName = nam
              local s = nam
              if pun[nam] then
                  s = "|cffff80ff*" .. nam
              end
              local cla = puA[nam] and puA[nam].Cla
              if cla then
                  s = s .. ", |cffa0a0a0" .. cla
              end
              but1.NXFStr:SetText(s)
              but1:Show()
              n = n + 1
              if n > self.NuB then
                  break
              end
          end
          self.NBU = n - 1
          for i = n, self.NuB do
              local but1 = self.But1[i]
              but1:Hide()
          end
          self.Win1:SeS(120, n * 13 - 15)
      end
      if lch then
          local win = self.Win1
          if loD then
              win:SeT("|cffff2020" .. self.Opt["PunkTWinTitle"])
          else
              win:SeT(self.Opt["PunkTWinTitle"])
          end
      end
  end
  local puA = Soc.PuA
  local tm = GetTime()
  for n = 1, self.NBU do
      local but1 = self.But1[n]
      local pun1 = puA[but1.NXName]
      if pun1 then
          local dur = tm - pun1.Tim1
          dur = dur < .3 and dur or dur * .05 + .285
          local r = min(max(1 - dur, .1), 1)
          but1.tex:SetVertexColor(r, 0, 0, .5)
      end
  end
end
function Nx.Com:OnE(eve)
  local self = Nx.Com
  if eve == "PLAYER_LOGIN" then
      self.PlN = UnitName("player")
      self.PMI = Nx.Map:GRMI()
      self.PlX = 0
      self.PlY = 0
      local _, tCl = UnitClass("player")
      self.PCI = self.ClN[tCl] or 0
      self.Lis:AdI("", "PLAYER_LOGIN")
      self.SeT2 = GetTime()
      self.SPT = GetTime()
      self.SCT1 = GetTime()
      self:LeC("A")
      self:LeC("Z")
      Nx.Tim:Sta("ComLogin", 3 + random() * 1, self, self.OLT)
      if IsInGuild() then
          GuildRoster()
      end
      ShowFriends()
  elseif eve == "ZONE_CHANGED_NEW_AREA" then
      self.Lis:AdI("", "ZONE_CHANGED_NEW_AREA")
      if not Nx.Tim:IsA("ComLogin") then
          self:UpC2()
      end
  elseif eve == "PLAYER_LEAVINGWORLD" then
      self:LeC("A")
      self:LeC("Z")
  end
  self.Lis:Upd()
end
function Nx.Com:GUV()
  self.VeP = {}
  Nx.Tim:Sta("ComGetUserVer", 0, self, self.GUVT)
end
function Nx.Map.Doc:UpO()
  local win = self.Win1
  if win then
      local loc1 = win:IsL()
      win:SBGA(0, loc1 and 0 or 1)
      self.UpM1 = 1
  end
end
function Nx.Que:RQAOF()
  local giv = UnitName("npc") or "?"
  local gui = UnitGUID("npc")
  if gui then
      local typ = tonumber(strsub(gui, 3, 5), 16)
      if typ == 0 then
          giv = "p"
      elseif bit.band(typ, 0xf) == 1 then
          local id = tonumber(strsub(gui, 6, 12), 16)
          giv = format("%s#o%x", giv, id)
      elseif bit.band(typ, 0xf) == 3 then
          local id = tonumber(strsub(gui, 9, 12), 16)
          giv = format("%s#%x", giv, id)
      end
  end
  self.AcG = giv
  local qna = GetTitleText()
  self.AQN = qna
  local id = Nx.Map:GRMI()
  self.AcN = Nx.MITN1[id] or 0
  local map = Nx.Map:GeM(1)
  self.AcX = map.PRZX
  self.AcY = map.PRZY
end
function Nx.ToB:M_OAR(ite)
  self:MDU("AlignR", ite:GetChecked())
end
function Nx:TTAW(zx, zy, nam)
  local map = Nx.Map:GeM(1)
  local mid = map:GCMI()
  local tar1 = map:STXY(mid, zx, zy, nam, true)
  map:CTO(-1, 1)
  return tar1.UnI
end
function Nx.Win:RegisterEvent(eve, han)
  self.Frm:RegisterEvent(eve)
  if not self.Eve then
      self.Eve = {}
  end
  self.Eve[eve] = han
end
function Nx.Que:Got(qId)
  if qId == 0 then
      return
  end
  local i = self:FiC3(qId)
  if i then
      Nx.prt("Already going to quest")
      return
  end
  local cur1 = self.CuQ
  local que = self.ITQ[qId]
  if not que[2] then
      Nx.prt("No quest starter")
      return
  end
  local nam, sid, lvl = self:Unp(que[1])
  local cur = {}
  cur.Got = true
  cur.Q = que
  cur.QI = 0
  cur.QId = qId
  cur.Hea1 = "Goto"
  cur.Tit = "Goto: " .. nam
  cur.ObT = ""
  cur.Lev = lvl
  cur.PaS1 = 1
  cur.LBC = 0
  cur.TrM2 = 1
  cur.TaS = ""
  cur.Pri = 1
  cur.Dis1 = 999999999
  cur.HiP1 = true
  self:CCNM(cur, que)
  tinsert(cur1, cur)
  cur.Ind = #cur1
  self.Wat:Add(#cur1)
  self:ReQ1()
  self.Lis:Upd()
end
function Nx.Map:GWZ(maI)
  return self.MWI[maI]
end
function Nx.Lis:SBGC(r, g, b, a, noF)
  if self.Frm.tex then
      self.Frm.tex:SetTexture(r, g, b, a or 1)
  end
  self.NBGF = noF
end
function Nx.Que:FI_U(quS1)
  NxQuestDSCRewardTitleText:SetPoint("TOPLEFT", "NxQuestDSC", "TOPLEFT", 0, -10)
  local quS1 = "NxQuestDSC"
  local qIN = "NxQuestDSCItem"
  local nQR
  local nQC
  local mon = GetQuestLogRewardMoney()
  local spF = NxQuestDSCSpacerFrame
  nQR = GetNumQuestLogRewards()
  nQC = GetNumQuestLogChoices()
  local nQSR = 0
  if GetQuestLogRewardSpell() then
      nQSR = 1
  end
  local toR = nQR + nQC + nQSR
  local mat = QuestFrame_GetMaterial()
  local qIRT = getglobal(quS1 .. "ItemReceiveText")
  if toR == 0 and mon == 0 then
      getglobal(quS1 .. "RewardTitleText"):Hide()
  else
      getglobal(quS1 .. "RewardTitleText"):Show()
      QuestFrame_SetTitleTextColor(getglobal(quS1 .. "RewardTitleText"), mat)
      QuestFrame_SetAsLastShown(getglobal(quS1 .. "RewardTitleText"), spF)
  end
  if mon == 0 then
      getglobal(quS1 .. "MoneyFrame"):Hide()
  else
      getglobal(quS1 .. "MoneyFrame"):Show()
      QuestFrame_SetAsLastShown(getglobal(quS1 .. "MoneyFrame"), spF)
      MoneyFrame_Update(quS1 .. "MoneyFrame", mon)
  end
  for n = toR + 1, MAX_NUM_ITEMS do
      getglobal(qIN .. n):Hide()
  end
  local quI, nam, tex, iTS, iSL, qua, isU, nuI = 1
  local reC1 = 0
  if nQC > 0 then
      local iCT = getglobal(quS1 .. "ItemChooseText")
      iCT:Show()
      QuestFrame_SetTextColor(iCT, mat)
      QuestFrame_SetAsLastShown(iCT, spF)
      local ind
      local baI = reC1
      for i = 1, nQC do
          ind = i + baI
          quI = getglobal(qIN .. ind)
          quI.type = "choice"
          nuI = 1
          nam, tex, nuI, qua, isU = GetQuestLogChoiceInfo(i)
          quI:SetID(i)
          quI:Show()
          quI.rewardType = "item"
          getglobal(qIN .. ind .. "Name"):SetText(nam)
          SetItemButtonCount(quI, nuI)
          SetItemButtonTexture(quI, tex)
          if isU then
              SetItemButtonTextureVertexColor(quI, 1.0, 1.0, 1.0)
              SetItemButtonNameFrameVertexColor(quI, 1.0, 1.0, 1.0)
          else
              SetItemButtonTextureVertexColor(quI, 0.9, 0, 0)
              SetItemButtonNameFrameVertexColor(quI, 0.9, 0, 0)
          end
          if i > 1 then
              if mod(i, 2) == 1 then
                  quI:SetPoint("TOPLEFT", qIN .. (ind - 2), "BOTTOMLEFT", 0, -2)
                  QuestFrame_SetAsLastShown(quI, spF)
              else
                  quI:SetPoint("TOPLEFT", qIN .. (ind - 1), "TOPRIGHT", 1, 0)
              end
          else
              quI:SetPoint("TOPLEFT", iCT, "BOTTOMLEFT", 0, -5)
              QuestFrame_SetAsLastShown(quI, spF)
          end
          reC1 = reC1 + 1
      end
  else
      getglobal(quS1 .. "ItemChooseText"):Hide()
  end
  local lST = getglobal(quS1 .. "SpellLearnText")
  if nQSR > 0 then
      lST:Show()
      QuestFrame_SetTextColor(lST, mat)
      QuestFrame_SetAsLastShown(lST, spF)
      if reC1 > 0 then
          lST:SetPoint("TOPLEFT", qIN .. reC1, "BOTTOMLEFT", 3, -5)
      else
          lST:SetPoint("TOPLEFT", quS1 .. "RewardTitleText", "BOTTOMLEFT", 0, -5)
      end
      tex, nam, iTS, iSL = GetQuestLogRewardSpell()
      if iTS then
          lST:SetText(REWARD_TRADESKILL_SPELL)
      elseif not iSL then
          lST:SetText(REWARD_AURA)
      else
          lST:SetText(REWARD_SPELL)
      end
      reC1 = reC1 + 1
      quI = getglobal(qIN .. reC1)
      quI:Show()
      quI.rewardType = "spell"
      SetItemButtonCount(quI, 0)
      SetItemButtonTexture(quI, tex)
      getglobal(qIN .. reC1 .. "Name"):SetText(nam)
      QuestFrame_SetAsLastShown(quI, spF)
      quI:SetPoint("TOPLEFT", lST, "BOTTOMLEFT", 0, -5)
  else
      lST:Hide()
  end
  if nQR > 0 or mon > 0 then
      QuestFrame_SetTextColor(qIRT, mat)
      if nQSR > 0 then
          qIRT:SetText(REWARD_ITEMS)
          qIRT:SetPoint("TOPLEFT", qIN .. reC1, "BOTTOMLEFT", 3, -5)
      elseif nQC > 0 then
          qIRT:SetText(REWARD_ITEMS)
          local ind = nQC
          if mod(ind, 2) == 0 then
              ind = ind - 1
          end
          qIRT:SetPoint("TOPLEFT", qIN .. ind, "BOTTOMLEFT", 3, -5)
      else
          qIRT:SetText(REWARD_ITEMS_ONLY)
          qIRT:SetPoint("TOPLEFT", quS1 .. "RewardTitleText", "BOTTOMLEFT", 3, -5)
      end
      qIRT:Show()
      QuestFrame_SetAsLastShown(qIRT, spF)
      local ind
      local baI = reC1
      for i = 1, nQR do
          ind = i + baI
          quI = getglobal(qIN .. ind)
          quI.type = "reward"
          nuI = 1
          nam, tex, nuI, qua, isU = GetQuestLogRewardInfo(i)
          quI:SetID(i)
          quI:Show()
          quI.rewardType = "item"
          getglobal(qIN .. ind .. "Name"):SetText(nam)
          SetItemButtonCount(quI, nuI)
          SetItemButtonTexture(quI, tex)
          if isU then
              SetItemButtonTextureVertexColor(quI, 1.0, 1.0, 1.0)
              SetItemButtonNameFrameVertexColor(quI, 1.0, 1.0, 1.0)
          else
              SetItemButtonTextureVertexColor(quI, 0.5, 0, 0)
              SetItemButtonNameFrameVertexColor(quI, 1.0, 0, 0)
          end
          if i > 1 then
              if mod(i, 2) == 1 then
                  quI:SetPoint("TOPLEFT", qIN .. (ind - 2), "BOTTOMLEFT", 0, -2)
                  QuestFrame_SetAsLastShown(quI, spF)
              else
                  quI:SetPoint("TOPLEFT", qIN .. (ind - 1), "TOPRIGHT", 1, 0)
              end
          else
              quI:SetPoint("TOPLEFT", quS1 .. "ItemReceiveText", "BOTTOMLEFT", 0, -5)
              QuestFrame_SetAsLastShown(quI, spF)
          end
          reC1 = reC1 + 1
      end
  else
      qIRT:Hide()
  end
end
function Nx.Ite.DLFS()
  local self = Nx.Ite
  self.Nee = {}
  self.Loa1 = function()
  end
  Nx.Tim:Sta("AskDeleteVV", 0, self, self.ADVV)
end
function Nx.Inf:CIBG()
  if Nx.IBG then
      return "", ""
  end
end
function Nx.Map:InH()
  local qua1 = {}
  self.WoH = qua1
  local quC = {}
  self.WHC = quC
  for coN = 1, Nx.Map.CoC do
      cna = self:GWCI(coN)
      if not cna then
          break
      end
      local zoN1 = 1
      while true do
          zna, zx, zy, zw, zh = self:GWZI(coN, zoN1)
          if not zx then
              break
          end
          local maI = self:CZ2MI(coN, zoN1)
          local nxz = Nx.MITN1[maI] or 0
          local col, inS = self:GMND(maI)
          local tiS = format("%s, %s%s (%s)", cna, col, zna, inS)
          local loc = Nx.MWH[nxz]
          local loS = 4
          if not loc then
              loc = Nx.MWH2[maI]
              if loc then
                  loS = 12
              else
                  loc = format("%c%c%c%c", 85, 85, 135, 135)
              end
          end
          for n = 0, 100 do
              local loN1 = n * loS + 1
              local lo1 = strsub(loc, loN1, loN1 + loS - 1)
              if lo1 == "" then
                  break
              end
              local zx, zy, zw, zh
              if loS == 4 then
                  zx, zy, zw, zh = Nx.Que:ULR(lo1)
              else
                  zx = tonumber(strsub(lo1, 1, 3), 16) * 100 / 4095
                  zy = tonumber(strsub(lo1, 4, 6), 16) * 100 / 4095
                  zw = tonumber(strsub(lo1, 7, 9), 16) * 1002 / 4095
                  zh = tonumber(strsub(lo1, 10, 12), 16) * 668 / 4095
              end
              local spo = {}
              if self:GWZ(maI).Cit then
                  tinsert(quC, spo)
              else
                  tinsert(qua1, spo)
              end
              spo.MaI = maI
              local wx, wy = self:GWP(maI, zx, zy)
              spo.WX1 = wx
              spo.WY1 = wy
              zw = zw / 1002 * 100
              zh = zh / 668 * 100
              local wx, wy = self:GWP(maI, zx + zw, zy + zh)
              spo.WX2 = wx
              spo.WY2 = wy
              spo.NTB = tiS
          end
          zoN1 = zoN1 + 1
      end
  end
end
function Nx.War:Ini()
  self.Ena = not Nx.Fre and Nx:GGO()["WarehouseEnable"]
  self.SkR = 0
  self.ClI1 = {
      ["Druid"] = "Ability_Druid_Maul",
      ["Hunter"] = "INV_Weapon_Bow_07",
      ["Mage"] = "INV_Staff_13",
      ["Paladin"] = "INV_Hammer_01",
      ["Priest"] = "INV_Staff_30",
      ["Rogue"] = "INV_ThrowingKnife_04",
      ["Shaman"] = "Spell_Nature_BloodLust",
      ["Warlock"] = "Spell_Nature_FaerieFire",
      ["Warrior"] = "INV_Sword_27",
      ["Death Knight"] = "Spell_Deathknight_ClassIcon"
  }
  self.InN = {"HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot", "WristSlot",
              "HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot",
              "Trinket1Slot", "MainHandSlot", "SecondaryHandSlot", "RangedSlot", "AmmoSlot", "Bag0Slot", "Bag1Slot",
              "Bag2Slot", "Bag3Slot"}
  self.LPr = TRADE_SKILLS
  self.LSS = gsub(SECONDARY_SKILLS, ":", "")
  self.ItT = NXlItemTypes
  self.DIN = {"HeadSlot", "ShoulderSlot", "ChestSlot", "WristSlot", "HandsSlot", "WaistSlot", "LegsSlot", "FeetSlot",
              "MainHandSlot", "SecondaryHandSlot", "RangedSlot"}
  self.DTF = CreateFrame("GameTooltip", "NxTooltipD", UIParent, "GameTooltipTemplate")
  self.DTF:SetOwner(UIParent, "ANCHOR_NONE")
end
function Nx.Soc.PanelTemplates_SetTab(fra, ind)
  local self = Nx.Soc
  local ff = FriendsFrame
  if fra == ff and self.Bar and not self.IOTB then
      ind = ind + self.OTI - 1
      self.Bar:Sel1(ind)
  end
end
function Nx.Win:SCF(fad, fad1)
  self.CFI = fad
  self.CFO = fad1
end
function Nx.Que:ULPO(loS1, off1)
  local x1, x2, y1, y2 = strbyte(loS1, off1, 3 + off1)
  return ((x1 - 35) * 221 + (x2 - 35)) / 100, ((y1 - 35) * 221 + (y2 - 35)) / 100
end
function Nx.UEv:GPP()
  local maI = Nx.Map:GRMI()
  local map = Nx.Map:GeM(1)
  return maI, map.PRZX, map.PRZY
end
function Nx.Que:ChQ(q, n)
  local oNa = self:UnO(q[n])
  local _, zon, x, y = self:GOP(q, q[n])
  local maI = Nx.Map.NTMI[zon]
  if (x == 0 or y == 0) and maI and not Nx.Map:IIM(maI) then
      q[n] = format("%c%s# ####", #oNa + 35, oNa)
  end
end
function Nx.Map:PTS(str)
  local str = gsub(strlower(str), ",", " ")
  local zon
  local zx, zy
  for s in gmatch(str, "%S+") do
      local i = tonumber(s)
      if i then
          if zx then
              zy = zy or i
          else
              zx = i
          end
      else
          if zon then
              zon = zon .. " " .. s
          else
              zon = s
          end
      end
  end
  local mid = self.RMI
  if zon then
      mid = nil
      for nam, id in pairs(Nx.MNTI1) do
          if strfind(strlower(nam), zon, 1, true) then
              mid = id
              break
          end
      end
      if not mid then
          Nx.prt("zone %s not found", zon)
          return
      end
  end
  if not zx or not zy then
      Nx.prt("zone coordinate error")
      return
  end
  return mid, zx, zy
end
function Nx.Com:OnU(ela)
  local Nx = Nx
  local bgm = Nx.IBG
  local taN = UnitName("target")
  if UnitIsPlayer("target") and UnitIsEnemy("player", "target") then
      local lvl = UnitLevel("target") or 0
      if not bgm then
          self.Pun[taN] = lvl
      end
      Nx.Soc:ALP(taN, nil, lvl, UnitClass("target"))
  end
  if UnitIsPlayer("mouseover") and UnitIsEnemy("player", "mouseover") then
      local moN = UnitName("mouseover")
      if moN ~= taN then
          local lvl = UnitLevel("mouseover") or 0
          if not bgm then
              self.Pun[moN] = lvl
          end
          Nx.Soc:ALP(moN, nil, lvl, UnitClass("mouseover"))
      end
  end
  local tm = GetTime()
  local tdi = tm - self.SeT2
  if tdi < .2 then
      return
  end
  if UnitIsAFK("player") then
      if not self.AFK then
          self:UpC2()
      end
      self.AFK = true
  else
      if self.AFK then
          self:UpC2()
      end
      self.AFK = nil
  end
  local map = Nx.Map:GeM(1)
  local del = 10
  if self.PlC then
      if not UnitOnTaxi("player") then
          del = 3.1
      end
  end
  if Nx.InC then
      del = map.InI and 4.5 or 2.2
  end
  del = del * self.SeR
  if bgm then
      del = 25
  end
  if self.AFK then
      del = 120
  end
  if next(self.Pun) then
      del = min(6, del)
  end
  if tm - self.SPT >= del then
      self.SPT = tm
      self.PlC = false
      local flg = 0
      if Nx.InC then
          flg = 1
      end
      local x, y = GetPlayerMapPosition("player")
      if x ~= 0 or y ~= 0 then
          self.PMI = map:GCMI()
          self.PlX = x
          self.PlY = y + max(GetCurrentMapDungeonLevel(), 1) - 1
      else
          if map.InI then
              self.PMI = map.InI
              if not Nx.Map.InI1[self.PMI] then
                  self.PlX = 0
                  self.PlY = 0
              end
          end
      end
      x = max(min(self.PlX, .999), 0) * 0xfff
      y = max(min(self.PlY, 9.999), 0) * 0xfff
      local h = UnitHealth("player")
      if UnitIsDeadOrGhost("player") then
          h = 0
      end
      local hm = UnitHealthMax("player")
      local hpe = h / hm * 20
      if hpe > 0 then
          hpe = max(hpe, 1)
      end
      hpe = floor(hpe + .5)
      local plL = min(UnitLevel("player"), 90)
      local tSt = ""
      if taN then
          flg = flg + 2
          local tTy = 5
          if UnitIsFriend("player", "target") then
              tTy = 1
          else
              if UnitIsPlayer("target") then
                  tTy = 2
              elseif UnitIsEnemy("player", "target") then
                  tTy = 3
                  if Nx:UnitIsPlusMob("target") then
                      tTy = 4
                  end
              end
          end
          local tLv = min(UnitLevel("target"), 90)
          local _, tCl = UnitClass("target")
          tCl = self.ClN[tCl] or 0
          local h = UnitHealth("target")
          if UnitIsDeadOrGhost("target") then
              h = 0
          end
          local hm = max(UnitHealthMax("target"), 1)
          local hpe = h / hm * 20
          if hpe > 0 then
              hpe = max(hpe, 1)
          end
          hpe = min(floor(hpe + .5), 20)
          tSt = format("%c%c%c%c%c%s", tTy + 35, tLv + 35, tCl + 35, hpe + 35, #taN + 35, taN)
      end
      local qSt1, qFl = Nx.Que:BCS()
      flg = flg + qFl
      local enS = ""
      if next(self.Pun) then
          for nam, lvl in pairs(self.Pun) do
              enS = enS .. format("%2x%s!", lvl >= 0 and lvl or 0, nam)
              if #enS > 50 then
                  break
              end
          end
          self.Pun = {}
          self.SZS = 1
          flg = flg + 8
          enS = strchar(#enS - 1 + 35) .. strsub(enS, 1, -2)
      end
      self:SeP3(format("S%c%4x%3x%4x%c%c%c%s%s%s", flg + 35, self.PMI, x, y, hpe + 48, plL + 35, self.PCI + 35, tSt,
          qSt1, enS))
  end
  if not self.PSM then
      if #self.PSQ > 0 then
          self.PSM = self.PSQ[1]
          self.PSQ[1] = nil
          for n = 2, #self.PSQ do
              self.PSM = self.PSM .. "\t" .. self.PSQ[n]
              self.PSQ[n] = nil
          end
          self.PSN = -2
      end
  end
  if tdi >= .25 then
      local msg = self.PSM
      if msg then
          self.PSN = self.PSN + 1
          if self.PSN > #self.Fri then
              self.PSN = -2
              self.PSM = nil
          else
              if self.PSN == -1 then
                  if bit.band(self.SPM, 2) > 0 then
                      self:Sen("g", msg)
                  end
              elseif self.PSN == 0 then
                  if self.SCQ[1] == nil and not bgm and not Nx:FACFEB() then
                      if bit.band(self.SPM, 4) > 0 then
                          local sk = self.SZS - 1
                          if sk < 1 then
                              sk = 4
                              self:Sen("Z", msg)
                              Nx.Que.QLC = nil
                          end
                          self.SZS = sk
                      end
                  end
              else
                  if bit.band(self.SPM, 1) > 0 then
                      self:Sen("W", msg, self.Fri[self.PSN])
                  end
              end
              self.SeT2 = tm
          end
      end
  end
  if Nx:FACFEB() then
      Nx.Com.SCT1 = tm
  else
      if tm - self.SCT1 >= .5 then
          if self.SCQ[1] then
              local dat = self.SCQ[1]
              tremove(self.SCQ, 1)
              self.SeB = self.SeB + #dat.Msg + 54 + 20
              self:SCMF(dat.Msg, "CHANNEL", dat.ChN1)
              self.SCT1 = tm
          end
      end
  end
end
function Nx.U_SCL(frm, lvl)
  if frm:GetNumChildren() > 0 then
      local ch = {frm:GetChildren()}
      for n, chf in pairs(ch) do
          chf:SetFrameLevel(lvl)
          if chf:GetNumChildren() > 0 then
              Nx.U_SCL(chf, lvl + 1)
          end
      end
  end
end
function Nx.Que.Wat:M_OSM(ite)
  self:Set(self.MID1, true)
end
function Nx.ToB:M_OD(ite)
end
function Nx.Opt:NXCmdUIChange()
  Nx:pSCF()
end
function Nx.DrD:Show(par, x, y)
  local uip = UIParent
  if not x then
      x, y = GetCursorPosition()
      x = x / uip:GetEffectiveScale() - 80
      y = y / uip:GetEffectiveScale() - GetScreenHeight() + 10
  end
  local win = self.Win1
  local f = win.Frm
  local lis = self.Lis
  win:SFS(4)
  f:SetParent(par)
  f:SetPoint("TOPLEFT", uip, "TOPLEFT", x, y)
  win:Show()
  lis:FuU()
end
function Nx.Map:AOM(nMI)
  if self.MaI == 0 then
      return
  end
  local off1 = 1
  local dup
  for n = 1, #self.MDO do
      if self.MDO[off1] == nMI then
          tremove(self.MDO, off1)
          dup = true
      else
          off1 = off1 + 1
      end
  end
  local drC = self.GOp["MapZoneDrawCnt"]
  if not dup then
      local ext = #self.MDO - drC + 2
      for n = 1, ext do
          tremove(self.MDO, 1)
      end
  end
  if drC > 1 then
      self.MDF[self.MaI] = -1
      tinsert(self.MDO, self.MaI)
  end
end
function Nx.TaB:Sel1(ind, for1)
  local seT = self.Tab1[ind]
  if not seT then
      return
  end
  local but1 = seT.But2
  if not for1 and but1:GeP() then
      return
  end
  local x = 1
  for i, tab in pairs(self.Tab1) do
      if i ~= ind then
          tab.But2:SeP2(false)
          tab.But2:SetText(tab.Nam, 0, 0)
      end
      tab.But2:SeP1("TOPLEFT", x, -1)
      tab.But2:SeS(tab.W, 20)
      x = x + tab.W + 2
  end
  but1:SeP2(true)
  local txt = "|cffffffff" .. seT.Nam
  but1:SetText(txt, 0, 2)
  if self.UsF then
      self.UsF(self.Use, ind)
  end
end
function Nx.Win:IOWUI(x, y)
  local f = self.Frm
  local top = f:GetTop()
  local bot1 = f:GetBottom()
  if self.Siz then
      local lef = f:GetLeft()
      local rgt = f:GetRight()
      local bw = self.BoW
      local bh = self.BoH
      if x >= rgt - bw then
          if y >= top - bh then
              return 6
          elseif y <= bot1 + bh then
              return 10
          end
          return 2
      elseif x < lef + bw then
          if y >= top - bh then
              return 5
          elseif y <= bot1 + bh then
              return 9
          end
          return 1
      elseif y <= bot1 + bh then
          return 8
      elseif y >= top - bh then
          return 4
      end
  else
      if y <= bot1 + self.BoH then
          return 0
      end
  end
  if y >= top - self.ToH then
      return 0
  end
  return -1
end
function Nx.Soc.PHUD:Click()
  local but1 = self
  if IsShiftKeyDown() then
      Nx.Soc.Lis:PuA1(but1.NXName)
      Nx.prt("Punk %s added", but1.NXName or "")
  else
      Nx.Soc.PHUD:Rem(but1.NXName)
  end
end
function Nx.Sec:Val1()
  self:Unl()
  self.Val1 = nil
end
function Nx.Map:IOMU(but)
  local t = this
  this = this.NxM1.Frm
  t.NxM1:OMU(but)
end
function Nx.War:CIDT()
  local tip = self.DTF
  local teN = "NxTooltipDTextLeft"
  self.DTF:SetOwner(UIParent, "ANCHOR_NONE")
  local duP = NXlDurPattern
  local duA = 0
  local dAM = 0
  local duL = 1
  for _, inN in ipairs(self.DIN) do
      local id = GetInventorySlotInfo(inN)
      if tip:SetInventoryItem("player", id) then
          for n = 4, tip:NumLines() do
              local _, _, dur, duM = strfind(getglobal(teN .. n):GetText() or "", duP)
              if dur and duM then
                  duA = duA + tonumber(dur)
                  dAM = dAM + tonumber(duM)
                  duL = min(duL, tonumber(dur) / tonumber(duM))
                  break
              end
          end
      end
  end
  local ch = Nx.CuC
  ch["DurPercent"] = duA / dAM * 100
  ch["DurLowPercent"] = duL * 100
end
function Nx.Map:GetText(tex1, leA)
  local dat = self.TFS2
  local pos1 = dat.Nex
  if pos1 > 100 then
      pos1 = 1
  end
  local fst = dat[pos1]
  if not fst then
      fst = self.TeF:CreateFontString()
      dat[pos1] = fst
      fst:SetFontObject("NxFontMap")
      fst:SetJustifyH("LEFT")
      fst:SetJustifyV("TOP")
      fst:SetHeight(100)
      fst:SetTextColor(1, 1, 1, 1)
  end
  fst:SetText(tex1)
  dat.Nex = pos1 + 1
  return fst
end
function Nx.Map:CLT1()
  local f = CreateFrame("Frame", "NxMapTip", self.Frm)
  self.LTF = f
  f:SetClampedToScreen()
  local t = f:CreateTexture()
  f.tex = t
  t:SetAllPoints(f)
  t:SetTexture(0, 0, 0, .85)
  local fst1 = {}
  self.LTFS = fst1
  local h = Nx.Fon:GeH("FontMapLoc")
  for n = 1, 4 do
      local fst = f:CreateFontString()
      tinsert(fst1, fst)
      fst:SetFontObject("NxFontMapLoc")
      fst:SetJustifyH("LEFT")
  end
end
function Nx.Sli:Upd()
  self.NeU = true
end
function Nx.Soc:GoP1(nam)
  local pun1 = self.PuA[nam]
  if pun1 then
      local map = Nx.Map:GeM(1)
      local wx, wy = map:GWP(pun1.MId, pun1.X, pun1.Y)
      local x = wx + math.sin(pun1.DrD1) * 2
      local y = wy + math.cos(pun1.DrD1) * 2
      map:SeT3("Goto", x, y, x, y, false, 0, nam)
  end
end
function Nx.Hel:Ope()
  local win = self.Win1
  if not win then
      self:Cre()
      win = self.Win1
  end
  win:Show()
end
function Nx.Hel.Dem:Tic()
  local f = self.NXFrm
  local ret = Nx.Scr:Tic(self.Scr)
  if ret or not f:IsShown() then
      f:Hide()
      return -1
  end
  self.X = self.X + self.NXXV
  self.Y = self.Y + self.NXYV
  self.Sca = Nx.U_SV(self.Sca, self.ScT, .8 / 60)
  f:SetPoint("CENTER", self.X / self.Sca, self.Y / self.Sca)
  f:SetScale(self.Sca)
  self.Alp = Nx.U_SV(self.Alp, self.NXAlphaTarget, .8 / 120)
  f:SetAlpha(self.Alp)
end
function Nx.Que.AcceptQuest(...)
  Nx.Que:RQAOF()
  Nx.Que.BAQ(...)
end
function Nx.Que.Wat:Up_()
  self.CDI = 1
  self.CDC = 20
  Nx.Tim:Sta("QuestWatchDist", 0, self, self.OnT)
end
function Nx.NXMiniMapBut:M_OHW(ite)
  local hid = ite:GetChecked()
  Nx.Que.Wat.Win1:Show(not hid)
end
function Nx.Fav:UpF1(fol, lev)
  local lis = self.Lis
  local hid = fol["Hide"]
  if lev > 1 then
      lis:ItA(fol)
      local spa = strrep("  ", lev - 1)
      lis:ItS(2, format("%s%s", spa, fol["Name"]))
      lis:ISB("QuestHdr", hid)
  end
  if not hid then
      local spa = strrep("  ", lev)
      for ind, ite in ipairs(fol) do
          local typ = ite["T"]
          local nam = ite["Name"]
          if typ == "F" then
              self:UpF1(ite, lev + 1)
          else
              self.FaC = self.FaC + 1
              lis:ItA(ite)
              lis:ItS(2, format("%s|cffdfdfdf%s", spa, nam))
              if self.FTS == ite then
                  self.FTS = nil
                  lis:Sel1(lis:IGN())
              end
          end
      end
  end
end
function Nx.Lis:Upd(shL)
  if self.SCI and not self.Sor then
      self:Sor1()
  end
  local liH = self:GLH()
  local hdH = self.HdH
  if shL then
      self:ShL()
  end
  if self.ShA then
      self:Res1(0, 0)
  end
  self.Top = min(self.Top, self.Num - self.Vis + 1)
  self.Top = max(self.Top, 1)
  self.Sel = min(self.Sel, self.Num)
  local las = self.Top + self.Vis - 1
  las = min(las, self.Num)
  if self.Off or #self.Str < self.Vis then
      self:CrS()
  end
  local stN = 1
  local cNu = 1
  for k, col3 in ipairs(self.Col) do
      for lin1 = self.Top, las do
          local txt = col3.Dat[lin1]
          self.Str[stN]:SetText(txt)
          stN = stN + 1
      end
      for n = stN, self.Vis * cNu do
          self.Str[n]:SetText("")
          stN = stN + 1
      end
      cNu = cNu + 1
  end
  if self.ShA then
      self:Res1(0, 0)
      local f = self.Frm
      local win = f:GetParent().NxW
      if win then
          win:SeS(f:GetWidth(), -7, true)
      end
  end
  if not self.ShA then
      self.Sli:Set(self.Top, 1, self.Num, self.Vis)
      self.Sli:Upd()
  end
  if self.BuD then
      if not self.But1 or #self.But1 < self.Vis then
          self:CrB()
      end
      local paW = 1
      local paH = 0
      local buN1 = 1
      local f = self.Frm
      local ofX = 0
      local ofY = 0
      local adY = hdH + paH + liH / 2 + .5
      for n = 1, self.Vis do
          local lin1 = self.Top + n - 1
          local but1 = self.But1[buN1]
          local buT = self.BuD[lin1]
          if buT then
              if not but1 then
                  Nx.prt("!BUT %s", #self.But1)
              end
              assert(but1)
              but1:SeT1(buT)
              but1:SeI(lin1)
              local buT1 = self.BuD[lin1 + 1000000]
              if buT == "Color" then
                  local t = self.BuD[lin1 + 8000000]
                  buT1 = t[self.BuD[lin1 + 9000000]]
              end
              but1:SetTexture(buT1)
              local buT2 = self.BuD[lin1 + 2000000]
              but1.Frm.NxT = buT2
              but1.Frm.NXTipFrm = self.BuD[lin1 + 3000000]
              but1:SeP2(self.BuD[-lin1])
              if self.Off then
                  ofX = self.Off[lin1] or 0
                  ofY = self.Off[-lin1] or 0
              end
              local sca = self:GLH() / self.BLH
              local y = (-(n - 1) * liH - adY - ofY) / sca
              but1.Frm:SetPoint("CENTER", f, "TOPLEFT", (paW + liH / 2 + ofX) / sca, y)
              but1.Frm:Show()
          elseif but1 then
              but1.Frm:Hide()
          end
          buN1 = buN1 + 1
      end
  elseif self.But1 then
      self:CrB()
  end
  if self.FrD then
      Nx.Lis:FrF(self)
      local lfr = self.Frm
      local ofX = 3
      local ofY = 3
      local adY = hdH + .5
      local doB = true
      for n = 1, self.Vis do
          local lin1 = self.Top + n - 1
          local dat = self.FrD[lin1]
          if dat then
              local typ, v1, v2, v3 = strsplit("~", dat)
              if typ == "Info" then
                  if self.UsF then
                      self.UsF(self.Use, "update", v1, -(n - 1) * liH - adY)
                  end
              elseif typ == "WatchItem" then
                  local f = Nx.Lis:GeF3(self, typ)
                  f:ClearAllPoints()
                  local sca = self.IFS * .07 * liH / 13
                  f:SetPoint("TOPRIGHT", lfr, "TOPLEFT", ofX, -(n - 1) * liH / sca - adY - ofY)
                  f["rangeTimer"] = -1
                  f:SetScale(sca)
                  f:SetWidth(29)
                  f:SetHeight(30)
                  f:SetAlpha(self.IFA)
                  local id = tonumber(v1)
                  f:SetID(id)
                  SetItemButtonTexture(f, v2);
                  SetItemButtonCount(f, tonumber(v3));
                  local _, dur = GetQuestLogSpecialItemCooldown(id)
                  if dur then
                      WatchFrameItem_UpdateCooldown(f)
                  end
                  if doB then
                      doB = false
                      local opt = Nx:GGO()
                      local key = GetBindingKey("NxWATCHUSEITEM")
                      if key then
                          opt["QWKeyUseItem"] = key
                          Nx.prt("Key %s transfered to Watch List Item", key)
                      end
                      if #opt["QWKeyUseItem"] > 0 and not InCombatLockdown() then
                          local s = GetBindingAction(opt["QWKeyUseItem"])
                          s = strmatch(s, "CLICK (.+):")
                          if s ~= f:GetName() then
                              local ok = SetBindingClick(opt["QWKeyUseItem"], f:GetName())
                              Nx.prt("Key %s %s #%s %s", opt["QWKeyUseItem"], f:GetName(), lin1, ok or "nil")
                              opt["QWKeyUseItem"] = ""
                          end
                      end
                  end
                  f:Show()
              end
          end
      end
  end
  local sfr = self.SeF2
  local seY = self.Sel - self.Top
  if seY < 0 or seY >= self.Vis then
      sfr:Hide()
  else
      sfr:SetHeight(liH + 1)
      sfr:SetPoint("TOPLEFT", 0, -seY * liH - self.HdH)
      sfr:Show()
  end
end
function Nx.Map:CeM(maI, sca)
  maI = maI or self.MaI
  if self:GWZ(maI).Cit then
      sca = 1
  end
  self.MaW = self.Frm:GetWidth() - self.PaX * 2
  self.MaH = self.Frm:GetHeight() - self.TiH
  local x, y = self:GWP(maI, 50, 50)
  local siz = min(self.MaW / 1002, self.MaH / 668)
  if self.MaW < GetScreenWidth() / 2 then
      siz = siz * (sca or 1.5)
  end
  local sca = siz / self:GWZS(maI) * 10.02
  self:Mov(x, y, sca, 30)
end
function Nx.Que:Cap(cur2, obN)
  local opt = self.GOp
  if not opt["CaptureEnable"] then
      return
  end
  local cur = self.CuQ[cur2]
  local id = cur.QId
  if NxData.DebugMap and (not obN or obN < 0) then
      Nx.prt("Quest Capture %s", id or "nil")
  end
  if not id then
      return
  end
  local cap = Nx:GeC()
  local faI = UnitFactionGroup("player") == "Horde" and 1 or 0
  local que1 = Nx:CaF(cap, "Q")
  local saI = id * 2 + faI
  local len = 0
  for id, str in pairs(que1) do
      len = len + 4 + #str + 1
  end
  if len > 100 * 1024 then
      return
  end
  local q = que1[saI]
  if not q then
      q = strrep("~", cur.LBC + 1)
  end
  local qda = {strsplit("~", q)}
  if not obN then
      local plL1 = UnitLevel("player")
      local s = Nx:CMXY(self.AcX, self.AcY)
      qda[1] = format("0%s^%02x%02x%s", self.AcG, plL1, self.AcN, s)
  elseif obN < 0 then
      local s = Nx:CMXY(self.AcX, self.AcY)
      qda[2] = format("%s^%02x%s", self.AcG, self.AcN, s)
      self.CQET = GetTime()
      self.CQEI = saI
  else
      local map = self.Map
      local nxz1 = Nx.MITN1[map.RMI]
      if nxz1 then
          local ind = obN + 2
          local obj = qda[ind]
          if not obj then
              Nx.prt("Capture err %s, %s", cur.Tit, obN)
              return
          end
          if #obj >= 2 then
              local z = tonumber(strsub(obj, 1, 2), 16)
              if nxz1 ~= z then
                  return
              end
          else
              obj = format("%02x", nxz1)
          end
          local cnt = (#obj - 2) / 6
          if cnt >= 15 then
              return
          end
          qda[ind] = obj .. Nx:CMXY(map.PRZX, map.PRZY)
      end
  end
  que1[saI] = table.concat(qda, "~")
end
function Nx.Inf:CIM(val)
  if self.MaI1 then
      if self.Var["Mana%"] > 1 - (tonumber(val) or 1) then
          return "", ""
      end
  else
      if self.Var["Mana%"] < (tonumber(val) or 1) then
          return "", ""
      end
  end
end
function Nx.Com:OP__2(eve)
  if arg1 >= 1 then
      self:SeP3(format("L%s", strchar(35 + arg1)))
  end
end
function Nx.Lis:CrB()
  local buN1 = 1
  if self.BuD then
      local sca = self:GLH() / self.BLH
      local f = self.Frm
      local ofX = 0
      local ofY = 0
      for n = 1, self.Vis do
          local but1 = self.But1[buN1]
          if not but1 then
              but1 = Nx.But:Cre(f, nil, nil, nil, 0, 0, "CENTER", 14, 14, self.OnB, self)
              self.But1[buN1] = but1
              but1.Frm:SetFrameLevel(f:GetFrameLevel() + 1)
          end
          but1.Frm:SetScale(sca)
          buN1 = buN1 + 1
      end
  end
  if self.But1 then
      for n = buN1, table.maxn(self.But1) do
          if self.But1[n] then
              self.But1[n].Frm:Hide()
          end
      end
  end
end
function Nx.Com.OC__2()
  local self = Nx.Com
  if not self.GeV1 then
      return
  end
  local n = arg1
  local chn, hea, col4, chN, plC, act1, cat, voE, voA = GetChannelDisplayInfo(n)
  if not hea then
      Nx.prt("Chan %s (%s) Cnt %s", chn or "nil", n, plC or "nil")
      local s1 = strfind(strlower(chn), "^crbb")
      if s1 then
          if plC then
              self.GeV1 = false
              Nx.prt("Found %s %s (%s)", chn, plC, n)
              local nam1 = {}
              for n2 = 1, plC do
                  local plN, own, mod2, mut, act1, ena1 = GetChannelRosterInfo(n, n2)
                  if plN ~= UnitName("player") then
                      tinsert(nam1, plN)
                  end
              end
              self.GUVN = nam1
              self.GUVI = 1
              Nx.Tim:Sta("GetUserVer", 0, self, self.OGUVT)
          end
      end
  end
end
function Nx.Lis:ISF(typ)
  if not self.FrD then
      self.FrD = {}
  end
  self.FrD[self.Num] = typ
end
function Nx.Que:FCFO(olC2)
  for n, cur in ipairs(self.CuQ) do
      if cur.Tit == olC2.Tit and cur.ObT == olC2.ObT then
          return cur
      end
  end
end
function Nx.Men:ReS()
  if self.Men1 then
      for men, v in pairs(self.Men1) do
          men:SeS4()
      end
  end
end
function Nx.EdB:Cre(paF, use, fun, maL)
  local box = {}
  setmetatable(box, self)
  self.__index = self
  box:SeU(use, fun)
  local f = CreateFrame("EditBox", nil, paF)
  box.Frm = f
  f.NxI = box
  f:SetScript("OnEditFocusGained", self.OEFG)
  f:SetScript("OnEditFocusLost", self.OEFL)
  f:SetScript("OnTextChanged", self.OTC)
  f:SetScript("OnEnterPressed", self.OEP)
  f:SetScript("OnEscapePressed", self.OEP1)
  f:SetFontObject("NxFontS")
  local t = f:CreateTexture()
  t:SetTexture(.1, .2, .3, 1)
  t:SetAllPoints(f)
  f.tex = t
  f:SetAutoFocus(false)
  f:ClearFocus()
  box.FiD = "Search: [click]"
  box.FDE = "Search: %[click%]"
  box.FiS = ""
  f:SetText(box.FiD)
  f:SetMaxLetters(maL)
  return box
end
function Nx.War.OM__()
  local self = Nx.War
  if not self.Ena then
      return
  end
  local ch = Nx.CuC
  local inv = {}
  ch["WareMail"] = inv
  for n = 1, GetInboxNumItems() do
      local _, _, sen, sub1, mon, COD, daL, haI, waR = GetInboxHeaderInfo(n)
      if haI then
          for i = 1, ATTACHMENTS_MAX_RECEIVE do
              local nam, _, cou = GetInboxItem(n, i)
              if nam then
                  local lin = GetInboxItemLink(n, i)
                  if lin then
                      self:AdL1(lin, cou, inv)
                  end
              end
          end
      end
  end
  self:Upd()
end
function Nx.ToB:M_OS2(ite)
  self:MDU("Space", ite:GeS1())
end
function Nx.Que.Lis:OLE(evN, sel, va2, cli)
  local Que = Nx.Que
  local Map = Nx.Map
  local itD1 = self.Lis:IGD(sel) or 0
  local hdC = self.Lis:IGDE(sel, 1)
  local qIn = bit.band(itD1, 0xff)
  local qId = bit.rshift(itD1, 16)
  local shi = IsShiftKeyDown() or evN == "mid"
  if evN == "select" or evN == "mid" or evN == "back" then
      local coI = va2
      if shi then
          if hdC then
              local seS1
              for n = sel + 1, sel + 99 do
                  local itD1 = self.Lis:IGD(n)
                  if not itD1 or itD1 == 0 then
                      break
                  end
                  local qIn = bit.band(itD1, 0xff)
                  local qId = bit.rshift(itD1, 16)
                  local i, cur, id = Que:FiC3(qId, qIn)
                  if not seS1 then
                      local qSt = Nx:GeQ(id)
                      seS1 = qSt == "W" and "c" or "W"
                  end
                  Nx:SeQ(id, seS1)
              end
              Que:PSS()
          else
              local i, cur, id = Que:FiC3(qId, qIn)
              local box = Nx:FACFEB()
              if box then
                  local s = self:MDL(cur, id or qId, IsControlKeyDown())
                  if s then
                      box:Insert(s)
                  end
              else
                  if cur then
                      local qSt = Nx:GeQ(id)
                      if qSt == "W" then
                          Nx:SeQ(id, "c")
                      else
                          Nx:SeQ(id, "W")
                      end
                      Que:PSS()
                  end
              end
          end
      end
      Nx.Que:SeB1(qIn)
      self:Upd()
      if qId > 0 then
          local qOb = bit.band(bit.rshift(itD1, 8), 0xff)
          local maI = Map:GCMI()
          Que:TOM(qId, qOb, qIn > 0, shi)
          Map:SCM1(maI)
          if self.TaS1 == 3 then
              local lh = getglobal("LightHeaded")
              if lh then
                  lh["UpdateFrame"](lh, qId)
              end
          end
      end
  elseif evN == "button" then
      if hdC then
          local v
          if not Que.HeH[hdC.Hea1] then
              v = true
          end
          Que.HeH[hdC.Hea1] = v
          self:Upd()
      else
          local qOb = bit.band(bit.rshift(itD1, 8), 0xff)
          if self.TaS1 == 1 then
              self:ToW(qId, qIn, qOb, shi)
          elseif self.TaS1 == 3 then
              local tbi = Que.Tra1[qId] or 0
              if qOb == 0 then
                  Que.Tra1[qId] = bit.bxor(tbi, 1)
              else
                  Que.Tra1[qId] = bit.bxor(tbi, bit.lshift(1, qOb))
              end
              self:Upd()
          end
      end
  elseif evN == "menu" then
      if qIn > 0 then
          Que:SeB1(qIn)
          self:Upd()
      end
      if self.TaS1 ~= 4 then
          self:UpM2()
          self.Men:Ope()
      end
  end
end
function Nx.Inf:CTM()
  if self.Var["TMana"] >= 0 then
      return "|cffc0c0c0", format("%d", self.Var["TMana"])
  end
end
function Nx.Soc.Lis:Up_()
  local soc = Nx.Soc
  local win = soc.Win1
  local lis = self.Lis
  if not (win and lis) then
      return
  end
  self.SeN = nil
  local pal = Nx:GeS("Pal")
  local taI1 = soc.TaS1
  win:SeT("")
  lis:Emp()
  if taI1 == 1 then
      lis:CSN(1, "Person")
      local dat = {}
      local f2p = {}
      local fCo = {}
      for pNa, fri1 in pairs(pal) do
          for fNa, _ in pairs(fri1) do
              tinsert(dat, format("%s~%s", pNa, fNa))
              f2p[fNa] = pNa
          end
      end
      local fI = {}
      local cnt = GetNumFriends()
      for n = 1, cnt do
          local nam, lev, cla, are, con3, sta, not2 = GetFriendInfo(n)
          if nam then
              fI[nam] = n
              fCo[nam] = con3
              local pNa = f2p[nam]
              local pDa = pal[pNa or ""]
              if con3 then
                  pDa[nam] = format("%s~%s", lev, cla)
              else
                  pDa[nam] = pDa[nam] or ""
              end
              if not pNa then
                  tinsert(dat, format("~%s", nam))
              end
          end
      end
      local function fun(a, b)
          local pN1, fN1 = strsplit("~", a)
          local pN2, fN2 = strsplit("~", b)
          if fCo[fN1] and not fCo[fN2] then
              return true
          end
          if not fCo[fN1] and fCo[fN2] then
              return false
          end
          if pN1 == pN2 then
              return fN1 < fN2
          end
          if pN1 == "" then
              return false
          end
          if pN2 == "" then
              return true
          end
          return pN1 < pN2
      end
      sort(dat, fun)
      win:SeT(format("Pals: |cffffffff%d/%d", cnt, 50))
      for _, ply in ipairs(dat) do
          local pNa, fNa = strsplit("~", ply)
          local i = fI[fNa]
          lis:ItA(fNa)
          local coC2 = fCo[fNa] and "|cff80f080" or "|cff808080"
          if #pNa > 0 then
              lis:ItS(1, coC2 .. pNa)
          end
          if not i then
              coC2 = "|cfff04040"
          end
          lis:ItS(2, coC2 .. fNa)
          local nam, lev, cla, are, con3, sta, not2
          if i then
              nam, lev, cla, are, con3, sta, not2 = GetFriendInfo(i)
          end
          if con3 then
              lis:ItS(5, are)
          else
              local pDa = pal[pNa]
              lev, cla = strsplit("~", pDa[fNa])
          end
          if lev ~= "" then
              lis:ItS(3, format("%s", lev))
              local col = Nx.CCS[NXlClassLocToCap[cla]] or ""
              lis:ItS(4, col .. cla)
          end
          local s = sta or ""
          if not2 then
              s = s .. " " .. not2
          end
          lis:ItS(6, s)
      end
  elseif taI1 == 2 then
      lis:CSN(1, "Status")
      local pun = soc.Pun
      local puA = soc.PuA
      local tm = GetTime()
      local myC = 0
      local acC = 0
      local dat = {}
      for pNa, str in pairs(pun) do
          tinsert(dat, pNa)
      end
      sort(dat)
      for _, pNa in ipairs(dat) do
          myC = myC + 1
          local tm, lvl, cla, not2 = strsplit("~", pun[pNa])
          lis:ItA(pNa)
          if puA[pNa] then
              lis:ItS(1, "|cffff6060Found")
          end
          lis:ItS(2, pNa)
          if lvl and lvl ~= 0 then
              lis:ItS(3, tostring(lvl))
          end
          if cla then
              local col = Nx.CCS[NXlClassLocToCap[cla]] or ""
              lis:ItS(4, col .. cla)
          end
          if not2 and #not2 > 0 then
              lis:ItS(6, not2)
          end
      end
      lis:ItA()
      lis:ItA()
      lis:ItS(2, "|cff8080ff-- Active --")
      local dat = {}
      for pNa in pairs(puA) do
          tinsert(dat, pNa)
      end
      sort(dat)
      for _, pNa in ipairs(dat) do
          acC = acC + 1
          local pun1 = puA[pNa]
          lis:ItA(pNa)
          local sec1 = tm - pun1.Tim1
          lis:ItS(1, format("%d:%02d", sec1 / 60 % 60, sec1 % 60))
          local nam = pun[pNa] and pNa or ("|cffafafaf" .. pNa)
          lis:ItS(2, nam)
          if pun1.Lvl ~= 0 then
              lis:ItS(3, tostring(pun1.Lvl))
          end
          if pun1.Cla then
              lis:ItS(4, pun1.Cla)
          end
          local maN = Nx.MITN[pun1.MId] or "?"
          lis:ItS(5, format("%s %d %d", maN, pun1.X, pun1.Y))
          lis:ItS(6, format("Near %s", pun1.FiN1))
      end
      win:SeT(format("Punks: %s  Active: %s", myC, acC))
  elseif NxData.NXVerDebug and taI1 == 3 then
      local dat = Nx.Com:SUQ()
      local cnt = 0
      local qcn = 0
      for n, msg in ipairs(dat) do
          local nam, ver, r, c, dt, ve1, qCn, lvl, mId = strsplit("^", msg)
          ver = tonumber(ver)
          cnt = cnt + 1
          qcn = qcn + (qCn or 0)
          lis:ItA()
          lis:ItS(2, nam)
          if lvl then
              lis:ItS(3, tostring(tonumber(lvl, 16)))
          end
          if mId then
              local nam = Nx.MITN[tonumber(mId, 16)] or "?"
              lis:ItS(5, nam)
          end
          local i = strfind(msg, "%^")
          if i then
              msg = strsub(msg, i + 1)
          end
          lis:ItS(6, msg)
      end
      win:SeT(format("Total: %s Q%s", cnt, qcn))
  end
  lis:Upd()
end
function Nx.Fav:B_OU()
  self:MoC(true)
end
function Nx.Map:UWM()
  local f = self.WMF
  if f then
      if self.StT ~= 0 or self.Scr2 or IsShiftKeyDown() then
          f:Hide()
      else
          local tip1 = getglobal("WorldMapTooltip")
          if tip1 then
              tip1:SetFrameStrata("TOOLTIP")
          end
          local af = getglobal("WorldMapFrameAreaFrame")
          if af then
              af:SetFrameStrata("HIGH")
          end
          f:Show()
          self:CZF(self.Con, self.Zon, f, 1)
          f:SetFrameLevel(self.Lev)
          if self.WMFMI ~= self.MaI then
              self.WMFMI = self.MaI
              self:SCL(f, self.Lev + 1)
              self.Lev = self.Lev + 4
          end
      end
      for k, f in ipairs(_G["MAP_VEHICLES"]) do
          f:SetScale(.001)
      end
  end
end
function Nx.Inf:CreateFrame(par)
  local f = CreateFrame("Frame", nil, par)
  local t = f:CreateTexture()
  f.tex = t
  t:SetAllPoints(f)
  return f
end
function Nx.Inf:CCP()
  if self.DeK then
      if self.Var["TName"] then
          local s = ""
          for _, dat in ipairs(self.DKR) do
              local n = dat[1]
              s = s .. (GetRuneType(n) ~= 4 and dat[2] or "|cff606060")
              local sta2, dur1, rea = GetRuneCooldown(n)
              s = s .. (rea and "+" or "-")
              if dat[3] then
                  s = s .. " "
              end
          end
          return "|cffff8080", s
      end
  else
      local i = GetComboPoints("player")
      if i > 0 then
          return "|cffff8080", string.rep("*", i)
      end
  end
end
function Nx.Gra:SeL(time, val1, coS, inS)
  local pos1 = self.Val.Nex
  assert(pos1 ~= 0)
  self.Val[-pos1] = time
  self.Val[pos1] = val1
  self.Val[pos1 + 0x1000000] = coS
  self.Val[pos1 + 0x2000000] = inS
  self.Val.Nex = pos1 + 1
  self:UpL(pos1)
end
function Nx.Que.Wat:OUT(ite)
  if not Nx.Tim:IsA("QuestWatchDist") then
      self:Upd()
      self.CDC = 3
  end
  return 1.5
end
function Nx.Com:Chk(msg)
  local v = 0
  local xor = bit.bxor
  for n = 1, #msg do
      v = xor(v, strbyte(msg, n))
  end
  return v
end
function Nx.Map:GeO1(ind, nam)
  local map = Nx.Map.Map1[ind]
  local opt = NxMapOpts.NXMaps[ind]
  local id = map.RMI
  id = opt[id] and id or 0
  return opt[id][nam]
end
function Nx.Que.Wat:ShU1()
  self.Win1.RaH = nil
  if self.GOp["QWHideRaid"] then
      local inR1 = GetNumRaidMembers() > 0
      if inR1 then
          self.Win1.Frm:Hide()
          self.Win1.RaH = true
      else
          self.Win1.Frm:Show()
      end
  end
end
function Nx.Com:LeC(chI)
  if chI == "A" then
      self.CAN = nil
      self:LeC1(self.CAL)
  elseif chI == "Z" then
      self:LeC1(chI)
  end
end
function Nx.Map:BGM_OC(ite)
  self:BGM_S("Clear")
end
function Nx.But:OnL(mot)
  local but1 = this.NxB
  but1.Ove = nil
  but1:Upd()
  if not this:IsVisible() then
      return
  end
  local own = this.NXTipFrm or this
  if GameTooltip:IsOwned(own) then
      GameTooltip:Hide()
  end
end
function Nx.Map:AdN(nam, id, x, y)
  Nx.Fav:Rec1("Note", nam, id, x, y)
end
function Nx.Map:RoM(poi2)
  local rad1 = self.GOp["RouteMergeRadius"]
  if #poi2 < 2 or rad1 < 1 then
      return
  end
  local tm = GetTime()
  sort(poi2, function(a, b)
      return a.X < b.X
  end)
  rad1 = rad1 / Nx.Map:GWZS(self.MaI) / 4.575
  local raS = rad1 ^ 2
  local stC1 = #poi2
  local mer = true
  while mer do
      mer = false
      local clo1 = 999999999
      local cI1
      local cI2
      for n1, pt1 in ipairs(poi2) do
          for n2 = n1 + 1, #poi2 do
              local pt2 = poi2[n2]
              if pt2.X - pt1.X > rad1 then
                  break
              end
              local d = (pt1.X - pt2.X) ^ 2 + ((pt1.Y - pt2.Y) / 1.5) ^ 2
              if d < clo1 then
                  clo1 = d
                  cI1 = n1
                  cI2 = n2
              end
          end
      end
      if clo1 ^ .5 < rad1 then
          local pt1 = poi2[cI1]
          local pt2 = poi2[cI2]
          pt1.X = (pt1.X + pt2.X) * .5
          pt1.Y = (pt1.Y + pt2.Y) * .5
          tremove(poi2, cI2)
          mer = true
          sort(poi2, function(a, b)
              return a.X < b.X
          end)
      end
  end
  Nx.prt("Merged %s in %.1f secs", stC1 - #poi2, GetTime() - tm)
end
function Nx.Tim:PrS(nam)
  local pro4 = self.Pro2[nam]
  if not pro4 then
      pro4 = {}
      self.Pro2[nam] = pro4
      tinsert(self.Pro2, pro4)
      pro4.Nam = nam
      pro4.Tim1 = 0
      pro4.TiL2 = 0
      pro4.Cnt = 0
  end
  pro4.Sta = GetTime()
  pro4.Cnt = pro4.Cnt + 1
end
function Nx.Que.Lis:Sel1(qId, qI)
  local lis = self.Lis
  for n = 1, lis:IGN() do
      local i = lis:IGD(n)
      if i then
          local qi = bit.band(i, 0xff)
          local qid = bit.rshift(i, 16)
          if qi == qI and qid == qId then
              Nx.Que:SeB1(qi)
              lis:Sel1(n)
              self:Upd()
              break
          end
      end
  end
end
function Nx.Sli:DoU()
  local frm = self.Frm
  local tfr = self.ThF
  local ran1 = self.Max1 - self.Min1 + 1
  local per = (self.Pos - self.Min1) / (max(ran1 - self.ViS, 1))
  if self.TyH then
      local w = (frm:GetRight() or 0) - (frm:GetLeft() or 0)
      tfr:SetPoint("TOPLEFT", per * w, 0)
  else
      local h = (frm:GetTop() or 0) - (frm:GetBottom() or 0)
      local tpe = min(self.ViS / ran1, 1)
      if tpe >= 1 or h < 6 then
          self.TPt = 0
          frm:SetAlpha(.3)
          tfr:Hide()
      else
          frm:SetAlpha(1)
          tfr:Show()
          local cli1 = 0
          local th = tpe * h
          if th < 5 then
              cli1 = 5 - th
              th = 5
          end
          tfr:SetHeight(th)
          h = h - tpe * h
          self.TPt = -per * h
          tfr:SetPoint("TOPLEFT", 0, self.TPt)
      end
  end
end
function Nx.Map:ReI1()
  local frm1 = self.IcF
  frm1.Use1 = frm1.Nex - 1
  frm1.Nex = 1
  local frm1 = self.INIF
  frm1.Use1 = frm1.Nex - 1
  frm1.Nex = 1
  local frm1 = self.ISF1
  frm1.Use1 = frm1.Nex - 1
  frm1.Nex = 1
  local dat = self.TFS2
  dat.Use1 = dat.Nex - 1
  dat.Nex = 1
end
function Nx.Map:MoE(on)
  if self.GOp["MapMaxMouseIgnore"] then
      self.Win1.Frm:EnableMouse(on)
      self.Win1.Frm:EnableMouseWheel(on)
      self.Frm:EnableMouse(on)
      self.Frm:EnableMouseWheel(on)
      for n, f in ipairs(self.IcF) do
          f:EnableMouse(on)
      end
      for n, f in ipairs(self.ISF1) do
          f:EnableMouse(on)
      end
  end
end
function Nx.Map:GM_OFN()
  Nx.Fav:SIN1(self.ClI)
end
function Nx.Map:MBSU(juN)
  local opt = Nx:GGO()
  local t = {"MinimapCluster", "MapMMShowOldNameplate", "NXMiniMapBut", "MapMMButShowCarb", "GameTimeFrame",
             "MapMMButShowCalendar", "MiniMapWorldMapButton", "MapMMButShowWorldMap"}
  for n = 1, #t, 2 do
      local ski
      if Nx.Fre then
          if t[n] == "MinimapCluster" then
              ski = true
          end
      end
      if not ski then
          local f = getglobal(t[n])
          if opt[t[n + 1]] then
              f:Show()
          else
              f:Hide()
          end
      end
      if juN then
          break
      end
  end
end
function Nx.Map.Gui:Upd()
  local pat = ""
  for n = 2, #self.PaH do
      local fol = self.PaH[n]
      local nam = fol.Nam
      if strbyte(nam) == 64 then
          nam = Nx.GuA[strsub(nam, 2)]
      end
      if n == 2 then
          pat = nam
      else
          pat = pat .. "." .. nam
      end
  end
  self.Win1:SeT(pat)
  local i = max(#self.PaH - 1, 1)
  self:UpL1(self.Lis, i, 1)
  local i = #self.PaH
  if i <= 1 then
      i = 0
  end
  self:UpL1(self.Li2, i, 2)
  self:UMI1()
end
function Nx.Men:I_OMW(val1)
  local ite = this.NMI
  val1 = (val1 > 0 and 1 or -1) * (ite.Ste or .01)
  if IsShiftKeyDown() then
      val1 = val1 * 10
  end
  local x = ite:GeS1() + val1
  if IsAltKeyDown() then
      x = 1
  end
  Nx.Men:I_SUS(ite, x)
end
function Nx:GDTB()
  return Nx.CuC["TBar"]
end
function Nx.Map.Gui:UVV()
  local vv = NxData.NXVendorV
  if not vv or (NxData.NXVendorVVersion or 0) < Nx.VERSIONVENDORV then
      vv = {}
      NxData.NXVendorV = vv
      NxData.NXVendorVVersion = Nx.VERSIONVENDORV
  end
  local fol = self:FiF("Visited Vendor")
  assert(fol)
  if fol then
      local alF = fol[1]
      for n = 1, #alF do
          alF[n] = nil
      end
      for n = 2, #fol do
          fol[n] = nil
      end
      local uni1 = {}
      for npN, lin2 in pairs(vv) do
          local tag = strsplit("~", npN)
          uni1[tag] = true
      end
      local unT1
      local taF
      local unI1 = {}
      local vso = {}
      for npN, lin2 in pairs(vv) do
          tinsert(vso, npN)
      end
      sort(vso)
      for _, npN in ipairs(vso) do
          local tag, nam = strsplit("~", npN)
          if unT1 ~= tag then
              unT1 = tag
              taF = {}
              taF.Nam = format("%s", tag)
              tinsert(fol, taF)
          end
          local lin2 = vv[npN]
          local npF = {}
          local maI = strsplit("^", lin2["POS"])
          maI = tonumber(maI)
          npF.T = "(" .. npN
          npF.Tx = "INV_Misc_Coin_05"
          local rep1 = lin2["R"] and " (Repair)" or ""
          npF.Nam = format("%s  |cff8080c0%s\n|cffc0c0c0%s%s", tag, Nx.Map:ITN(maI), nam, rep1)
          npF.VeP1 = lin2["POS"]
          npF.NSC = true
          tinsert(taF, npF)
          local n = 1
          while n <= #lin2 do
              local id = strsplit("^", lin2[n])
              local nam = GetItemInfo(id)
              if not nam then
                  if Nx.Ite:Loa1(id) then
                      tremove(lin2, n)
                      Nx.prt("Removed old vendor item %s", id)
                      n = n - 1
                  end
              end
              n = n + 1
          end
          for _, ite in ipairs(lin2) do
              local id, pri = strsplit("^", ite)
              local nam, iLi, iRa, lvl, miL, type, suT, stC, eqL, tx = GetItemInfo(id)
              nam = nam or format("%d?", id)
              local itF = unI1[nam]
              if itF then
                  itF.ItS1 = itF.ItS1 .. "^" .. npN
              else
                  itF = {}
                  itF.ItS1 = npN
                  itF.SoN = nam
                  unI1[nam] = itF
                  itF.T = ")" .. id
                  if iLi then
                      local col2 = strsub(iLi, 1, 10)
                      itF.Nam = format("%s%s\n   %s", col2, nam, pri)
                      itF.Lin = iLi
                      itF.Tx = gsub(tx, "Interface\\Icons\\", "")
                      if miL > 1 then
                          itF.Co21 = format("L%2d", miL)
                      end
                  else
                      itF.Nam = nam
                      itF.Tx = "INV_Misc_QuestionMark"
                  end
              end
              tinsert(npF, itF)
          end
          sort(npF, function(a, b)
              return a.SoN < b.SoN
          end)
      end
      for nam, itF in pairs(unI1) do
          tinsert(alF, itF)
      end
      sort(alF, function(a, b)
          return a.SoN < b.SoN
      end)
  end
  Nx.Tim:PrS("Guide CapTimer gc")
  collectgarbage("collect")
  Nx.Tim:PrE("Guide CapTimer gc")
end
function Nx.Map:SITC(icT, on)
  local d = self.Dat
  assert(d[icT])
  d[icT].ClF1 = on and self.CFWC or self.CFW
end
function Nx.Win:GTTW()
  local w = 40
  for n = 1, self.TiL do
      local fst = self.TFS[n]
      fst:SetWidth(0)
      w = max(self.TFS[n]:GetStringWidth(), w)
  end
  return w
end
function Nx.Fav:IM_OC1()
  local fav = self.CuF
  if fav then
      self.CoB = fav[self.CII]
  end
end
function Nx.Map.Gui:CaT2(fol)
  local typ = type(fol) == "table" and fol.T
  if typ then
      local s1, s2 = strsplit("^", typ)
      if s2 then
          local s21 = strsub(s2, 1, 1)
          if s2 == "C" then
              local _, cls = UnitClass("player")
              cls = Nx.U_CS(cls)
              cls = gsub(cls, "Deathknight", "Death Knight")
              return cls .. " Trainer", true
          elseif s21 == "F" then
              local s22 = strsub(s2, 2, 2)
              local fac2 = self:GHF()
              if s22 == "A" and fac2 == 1 then
                  return
              end
              if s22 == "H" and fac2 == 2 then
                  return
              end
              return s1
          elseif s21 == "P" then
              local nam = strsub(s2, 2)
              if nam == "" then
                  nam = fol.Pre1
              end
              local t = self:GPT(nam)
              t = fol.Pre1 .. t
              return t, true
          elseif s21 == "S" then
              local nam = strsub(s2, 2)
              if nam == "" then
                  nam = fol.Pre1
              end
              local t = self:GST(nam)
              t = fol.Pre1 .. t
              return t, true
          elseif s21 == "G" then
              return
          end
      end
      return s1
  end
end
function Nx.Map:SeT3(typ, x1, y1, x2, y2, tex2, id, nam, kee, maI)
  self.UTD1 = 0
  local sbt = self.SBT1
  self.SBT1 = false
  if not kee then
      self:ClT1()
  end
  self.SBT1 = sbt or not next(self.Tar) and self.GOp["MapRestoreScaleAfterTrack"] and self.Sca
  local tar1 = {}
  tinsert(self.Tar, tar1)
  assert(x1)
  tar1.TaT = typ
  tar1.TX1 = x1
  tar1.TY1 = y1
  tar1.TX2 = x2
  tar1.TY2 = y2
  tar1.TMX = (x1 + x2) * .5
  tar1.TMY = (y1 + y2) * .5
  tar1.TaT1 = tex2
  tar1.TaI = id
  tar1.TaN1 = nam
  maI = maI or self.MaI
  tar1.MaI = maI
  local i = self.TNUI
  tar1.UnI = i
  self.TNUI = i + 1
  local typ = kee and "Target" or "TargetS"
  local zx, zy = self:GZP(maI, tar1.TMX, tar1.TMY)
  Nx.Fav:Rec1(typ, nam, maI, zx, zy)
  return tar1
end
function Nx.Men:I_OMU(but)
  local ite = this.NMI
  if but == "LeftButton" then
      Nx.Men.SlM = nil
  end
end
function Nx.Fav:SeC1()
  self.Lis:SUS()
  self:SeI1(1)
end
function Nx.Com:OGUVT()
  local i = self.GUVI
  if i <= #self.GUVN then
      local plN = self.GUVN[i]
      self:SSW1("V?", "", plN)
      self.GUVI = i + 1
      return .1
  end
end
function Nx.Com:OCE(eve)
  local self = Nx.Com
  if strsub(arg9, 1, 3) == self.Nam then
      if eve == "CHAT_MSG_CHANNEL_JOIN" then
          self.Lis:AdI("CJ:" .. arg9, format("%s", arg2))
      elseif eve == "CHAT_MSG_CHANNEL_NOTICE" then
          self.Lis:AdI("CN:" .. arg9, format("%s", arg1))
          local naR = strsplit("I", arg9)
          if arg1 == "YOU_JOINED" then
              local typ = strupper(strsub(arg9, 4, 4))
              if typ == self.CAL then
                  self.CAN = arg9
                  Nx.Tim:Sto("ComA")
                  Nx.Tim:Sta("ComVerSend", 3, self, self.OVT)
              elseif typ == "Z" then
                  local maI = tonumber(strsub(naR, 5))
                  if maI then
                      local zs = self.ZSt[maI] or {}
                      zs.ChN = arg9
                      self.ZSt[maI] = zs
                      Nx.Tim:Sto("ComZ" .. maI)
                      self:UpC2()
                  end
              end
          elseif arg1 == "YOU_LEFT" then
              local typ = strupper(strsub(arg9, 4, 4))
              if typ == "Z" then
                  local maI = tonumber(strsub(naR, 5))
                  if maI then
                      local zs = self.ZSt[maI] or {}
                      zs.ChN = nil
                      self.ZSt[maI] = zs
                  end
              end
          end
      elseif eve == "CHAT_MSG_CHANNEL_LEAVE" then
          self.Lis:AdI("CL:" .. arg9, format("%s", arg2))
      end
      self.Lis:Upd()
  end
end
function Nx.Soc:ShowUIPanel(fra)
  if not GameMenuFrame:IsShown() and not self.NoS then
      if self.IOTB then
          return
      end
      if InCombatLockdown() and (GetNumRaidMembers() > 0 or _G["RaidGroupFrame_Update"]) then
          return
      end
      self.NoS = true
      self:Cre()
      local win = self.Win1
      local wf = win.Frm
      wf:Raise()
      if not win:IsShown() then
          win:Show()
          self:SBT2(false)
          self.Bar:Sel1(self.TaS1, true)
      end
      local gTI = self.OTI + 2
      self.Bar:Enable(gTI, IsInGuild() ~= nil)
      if self.TaS1 == gTI then
          local function fun()
              GuildFrame:Show()
          end
          Nx.Tim:Sta("SocialFFUpdate", 0, self, fun)
      end
      self.NoS = false
  end
end
function Nx.MeI:GeS1()
  return self.SlP
end
function Nx.Opt:NXCmdImportCarbHerb()
  local function fun()
      Nx:GICH()
  end
  Nx:ShM("Import Herbs?", "Import", fun, "Cancel")
end
function Nx.Map:M_OGCB(ite)
  self.BGGB = ite:GetChecked()
end
function Nx:PlaySoundFile(fil)
  if GetCVar("Sound_EnableSFX") ~= "0" then
      PlaySoundFile(fil)
  end
end
function Nx.Opt:EdI(ite)
  local var = self:GeV(ite.V)
  local typ, r1 = self:PaV(ite.V)
  if typ == "CH" then
      self.CuI = ite
      local dat = self:CaC(r1, "Get")
      if not dat then
          Nx.prt("EditItem error (%s)", r1)
      end
      Nx.DrD:Sta(self, self.ECHA)
      for k, nam in ipairs(dat) do
          Nx.DrD:Add(nam, nam == var)
      end
      Nx.DrD:Show(self.Lis.Frm)
  elseif typ == "F" then
      Nx:SEB(ite.N, var, ite, self.EFA)
  elseif typ == "I" then
      Nx:SEB(ite.N, var, ite, self.EIA)
  elseif typ == "S" then
      Nx:SEB(ite.N, var, ite, self.ESA)
  end
end
function Nx.Lis:OnB(but1, id, cli)
  if self.BuD[id] == "Color" then
      self:OCD(id)
      return
  end
  self.BuD[-id] = but1:GeP()
  if self.UsF then
      self.UsF(self.Use, "button", id, self.BuD[-id], cli, but1)
  end
end
function Nx.Lis:ItA(usD)
  self.Num = self.Num + 1
  self.Dat[self.Num] = usD
end
function Nx.Map:MZT(con1, zon, frm1, alp, lev)
  local zna, zx, zy, zw, zh = self:GWZI(con1, zon)
  if not zx then
      return
  end
  local sca = self.ScD
  local clW = self.MaW
  local clH = self.MaH
  local x = (zx - self.MPXD) * sca + clW / 2
  local y = (zy - self.MPYD) * sca + clH / 2
  local bx = 0
  local by = 0
  local bw = zw * 1024 / 1002 / 4 * sca
  local bh = zh * 768 / 668 / 3 * sca
  local w, h
  local tX1, tX2
  local tY1, tY2
  for i = 1, NUM_WORLDMAP_DETAIL_TILES do
      local frm = frm1[i]
      if frm then
          tX1 = 0
          tX2 = 1
          tY1 = 0
          tY2 = 1
          local vx0 = bx * bw + x
          local vx1 = vx0
          local vx2 = vx0 + bw
          if vx1 < 0 then
              vx1 = 0
              tX1 = (vx1 - vx0) / bw
          end
          if vx2 > clW then
              vx2 = clW
              tX2 = (vx2 - vx0) / bw
          end
          local vy0 = by * bh + y
          local vy1 = vy0
          local vy2 = vy0 + bh
          if vy1 < 0 then
              vy1 = 0
              tY1 = (vy1 - vy0) / bh
          end
          if vy2 > clH then
              vy2 = clH
              tY2 = (vy2 - vy0) / bh
          end
          w = vx2 - vx1
          h = vy2 - vy1
          if w <= 0 or h <= 0 then
              frm:Hide()
          else
              frm:SetPoint("TOPLEFT", vx1, -vy1 - self.TiH)
              frm:SetWidth(w)
              frm:SetHeight(h)
              frm:SetFrameLevel(lev)
              frm.tex:SetTexCoord(tX1, tX2, tY1, tY2)
              frm.tex:SetVertexColor(1, 1, 1, alp)
              frm:Show()
          end
      end
      bx = bx + 1
      if bx >= 4 then
          bx = 0
          by = by + 1
      end
  end
end
function Nx.Sec:Unl()
  local Nx = Nx
  local function fun()
      Nx.Fav.ToS = function(self)
          Nx.Fav.TS_(self)
      end
      if Nx.Inf then
          Nx.Inf.Upd = function(self)
              Nx.Inf.Up_(self)
          end
      end
      Nx.Map.Gui.ToS = function(self)
          Nx.Map.Gui.TS_(self)
      end
      Nx.Que.Lis.Upd = function(self)
          Nx.Que.Lis.Up_(self)
      end
      Nx.Que.Wat.Upd = function(self)
          Nx.Que.Wat.Up_(self)
      end
      Nx.Soc.Lis.Upd = function(self)
          self:Up_()
      end
      Nx.War.ToS = function(self)
          Nx.War.TS_(self)
      end
  end
  fun()
  Nx.Hel.Dem:StO()
  self.Unl = nil
end
function Nx.Map:SITL(icT, lev)
  local d = self.Dat
  assert(d[icT])
  d[icT].Lvl = lev
end
function Nx.Win:RLD()
  if self.LaM then
      local f = self.Frm
      local atP, reT, reP, x, y = f:GetPoint()
      local sca = f:GetScale()
      assert(atP == reP)
      if x < 0 and x >= -1 then
          x = 0
      end
      y = -y
      if y < 0 and y >= -1 then
          y = 0
      end
      local w = f:GetWidth()
      local dat = self.SaD
      if self.LaM == "" then
          if self.Nam == "NxMap1" and dat["MaxW"] and w >= dat["MaxW"] then
              return
          end
      elseif self.LaM == "Max" then
          if self.Nam == "NxMap1" and dat["W"] and w <= dat["W"] then
              return
          end
      end
      self:SLD(self.LaM, x, y, f:GetWidth(), f:GetHeight(), false, atP, sca)
  end
end
function Nx.Map:IBGM(maI)
  return maI >= 9001 and maI <= 9099
end
function Nx:GVUT(tNa)
  local olT = NxData.NXGather[tNa]
  local neT = {}
  NxData.NXGather[tNa] = neT
  for maI, olZ in pairs(olT) do
      local zoT = {}
      neT[maI] = zoT
      for _, nod in ipairs(olZ) do
          local x, y = Nx.Map:GZP(maI, nod.NXX, nod.NXY)
          if (x > 0 or y > 0) and x <= 100 and y <= 100 then
              local noT = zoT[nod.NXId] or {}
              zoT[nod.NXId] = noT
              local s = format("%s^%d", Nx:CMXY(x, y), nod.NXCnt)
              tinsert(noT, s)
          end
      end
  end
end
function Nx.EdB.OEP1()
  local self = this.NxI
  self.FiS = ""
  this:ClearFocus()
end
function Nx.Com:OTT(nam)
  self:SeP3("!" .. nam)
  if random() < .5 then
      arg1 = random(1, 80)
  end
  return .1 + random() * 5
end
function Nx.Map:CZF(con1, zon, frm, alp)
  local zna, zx, zy, zw, zh
  zna, zx, zy, zw, zh = self:GWZI(con1, zon)
  if not zx then
      return
  end
  local sca = self.ScD
  local clW = self.MaW
  local clH = self.MaH
  local x = (zx - self.MPXD) * sca + clW / 2
  local y = (zy - self.MPYD) * sca + clH / 2
  local bx = 0
  local by = 0
  local bw = zw * sca
  local bh = zh * sca
  local w, h
  local lev = self.Lev
  if frm then
      local vx0 = bx * bw + x
      local vx1 = vx0
      local vx2 = vx0 + bw
      local vy0 = by * bh + y
      local vy1 = vy0
      local vy2 = vy0 + bh
      w = vx2 - vx1
      h = vy2 - vy1
      if w <= 0 or h <= 0 then
          frm:Hide()
      else
          local sc = w / 1002
          vx1 = vx1 / sc
          vy1 = vy1 / sc
          frm:SetPoint("TOPLEFT", vx1, -vy1 - self.TiH)
          frm:SetScale(sc)
          frm:SetFrameLevel(lev)
          frm:Show()
      end
  end
end
function Nx.Map:OnU(ela)
  local Nx = Nx
  Nx.Tim:PrS("Map OnUpdate")
  local prT1 = GetTime()
  local map = this.NxM1
  local gop = map.GOp
  local Que = Nx.Que
  map.Tic = map.Tic + 1
  map.EfS = this:GetEffectiveScale()
  map.Si1 = gop["MapLineThick"] * .75 / map.EfS
  Nx.Map:UpO(map.MaI3)
  local win3, win4 = Nx.U_IMO(this)
  if not this:IsVisible() then
      win3 = nil
      map.Scr2 = false
  end
  if map.MMZT == 0 and Nx.U_IMO(map.MMF) then
      win3 = nil
  end
  map.MouseIsOver = win3
  if map.Scr2 then
      local cx, cy = GetCursorPosition()
      cx = cx / map.EfS
      cy = cy / map.EfS
      local x = cx - map.ScX
      local y = cy - map.ScY
      if x ~= 0 or y ~= 0 then
          map.LCT = 0
      end
      map.ScX = cx
      map.ScY = cy
      local lef = this:GetLeft()
      local top = this:GetTop()
      local mx = x / map.ScD
      local my = y / map.ScD
      map.MPXD = map.MPXD - mx
      map.MPYD = map.MPYD + my
      map.MPX = map.MPXD
      map.MPY = map.MPYD
      map.Sca = map.ScD
  end
  map:Upd(ela)
  local tit = ""
  if gop["MapShowTitleName"] then
      tit = map:ITN(map.RMI)
      for n = 1, MAX_BATTLEFIELD_QUEUES do
          local sta, _, inI = GetBattlefieldStatus(n)
          if sta == "active" then
              tit = tit .. format(" #%s", inI)
              break
          end
      end
  end
  if gop["MapShowTitleXY"] then
      if map.DFC then
          tit = tit .. format(" %4.2f, %4.2f", map.PRZX, map.PRZY)
      else
          tit = tit .. format(" %4.1f, %4.1f", map.PRZX, map.PRZY)
      end
  end
  if map.PlS > 0 and gop["MapShowTitleSpeed"] then
      local spe1 = map.PlS
      local sa = Nx.Map.MWI[map.MaI].ScA
      if sa then
          spe1 = spe1 * sa
      end
      spe1 = spe1 / 6.4 * 100 - 100
      if abs(spe1) < .5 then
          spe1 = 0
      end
      tit = tit .. format(" |cffa0a0a0Speed %+.0f%%", spe1)
  end
  local cLS = ""
  local cLXY = ""
  local meO = Nx.Men:IAO()
  if win3 then
      map.BAT = map.BAF1
      win4 = this:GetHeight() - win4
      if win4 >= map.TiH then
          local wx, wy = map:FPTWP(win3, win4)
          if not meO then
              map:CWH(wx, wy)
          end
          local x, y = map:GZP(map.MaI, wx, wy)
          x = floor(x * 10) / 10
          y = floor(y * 10) / 10
          local dis = ((wx - map.PlX) ^ 2 + (wy - map.PlY) ^ 2) ^ .5 * 4.575
          cLXY = format("|cff80b080%.1f %.1f %.0f yds", x, y, dis)
          cLS = cLXY
          local nam = UpdateMapHighlight(x / 100, y / 100)
          if nam then
              cLS = format("%s\n|cffafafaf%s", cLS, nam)
          end
      end
  else
      if not map.Scr2 and not meO then
          map.BAT = map.BAF
          local rid = map:GRMI()
          if rid ~= 9000 and not WorldMapFrame:IsShown() then
              if map:IIM(rid) and not Nx.Map.InI1[rid] then
                  rid = Nx.Map.MWI[rid].EMI
              end
              local maI = map:GCMI()
              if maI ~= rid then
                  if map:IBGM(rid) then
                      SetMapToCurrentZone()
                  else
                      map:SCM1(rid)
                  end
              end
          end
      end
  end
  if map.Gui.Win1.Frm:IsVisible() or Que.Lis.Win1 and Que.Lis.Win1.Frm:IsVisible() then
      map.BAT = map.BAF1
  end
  if map.DeT then
      prT1 = GetTime() - prT1
      local t = map.DPT or .01
      t = t * .95 + prT1 * .05
      map.DPT = t
      UpdateAddOnMemoryUsage()
      local mem1 = GetAddOnMemoryUsage("Carbonite")
      local mem2 = mem1 - (map.DMU1 or 0)
      map.DMU1 = mem1
      tit = tit .. format(" Time %.4f Mem %d %.4f", t, mem1, mem2)
  end
  if GetCVar("scriptProfile") == "1" then
      UpdateAddOnCPUUsage()
      tit = tit .. format(" |cffffffffCPU %6.3f %6.3f", GetAddOnCPUUsage("CARBONITE"), GetScriptCPUUsage())
      ResetCPUUsage()
  end
  if Nx.Tic % 3 == 0 then
      local tip = format(" %s", cLS)
      if map.Debug and win3 then
          local x, y = map:FPTWP(win3, win4)
          tip = tip .. format("\n|cffc080a0%.2f WXY %6.2f %6.2f PXY %6.2f %6.2f", map.Sca, x, y, map.PlX, map.PlY)
          map.DWX = x
          map.DWY = y
      end
      local ove = win3 and not Nx.U_IMO(map.ToB.Frm)
      map:SLT(ove and not meO and map.WHTS and (map.WHTS .. tip))
  end
  if map.Win1:ISM() then
      local s = Nx.Que:GZA(true)
      if s then
          tit = tit .. "  " .. s
      end
  end
  map.Win1:SeT(tit, 1)
  if map.GOp["MapShowTitle2"] then
      local s = GetSubZoneText()
      local pvT = GetZonePVPInfo()
      if pvT then
          s = s .. " (" .. pvT .. ")"
      end
      map.Win1:SeT(format("%s %s", s, cLXY), 2)
  end
  Nx.Tim:PrE("Map OnUpdate")
end
function Nx.MeI:SeS2(pos1, min, max, ste, vaN)
  if type(pos1) == "table" then
      assert(vaN)
      self.Tab = pos1
      self.VaN = vaN
      pos1 = self.Tab[vaN]
  end
  self.Sli = true
  if min then
      self.SlM1 = math.min(min, max)
      self.SlM2 = math.max(min, max)
  end
  if ste then
      self.Ste = ste
  end
  if self.Ste then
      pos1 = floor(pos1 / self.Ste + .5) * self.Ste
  end
  pos1 = math.max(pos1, self.SlM1)
  pos1 = math.min(pos1, self.SlM2)
  self.SlP = pos1
  if self.Tab then
      self.Tab[self.VaN] = pos1
  end
end
function Nx.Soc:Cre()
  local opt = Nx:GGO()
  if not opt["SocialEnable"] then
      return
  end
  if self.Win1 then
      return
  end
  local tbH = Nx.TaB:GetHeight()
  local win = Nx.Win:Cre("NxSocial")
  self.Win1 = win
  local frm = win.Frm
  win:CrB(true, true)
  win:ILD(nil, -.25, -.18, -.5, -.64)
  frm:SetToplevel(true)
  frm:Hide()
  tinsert(UISpecialFrames, frm:GetName())
  win:SeU(self, self.OnW)
  win:RegisterEvent("FRIENDLIST_SHOW", self.OFLU)
  win:RegisterEvent("FRIENDLIST_UPDATE", self.OFLU)
  win:RegisterEvent("GUILD_ROSTER_UPDATE", self.OFLU)
  local ffH = CreateFrame("Frame", "NxSocFFH", UIParent)
  self.FFH = ffH
  ffH:SetWidth(384)
  ffH:SetHeight(512)
  local ff = FriendsFrame
  ff:SetParent(ffH)
  ff:SetPoint("TOPLEFT", ffH, "TOPLEFT", 0, 0)
  win:Att(ffH, 0, 1, 0, -tbH, 384 - 20, 512 - 40)
  local bar = Nx.TaB:Cre(nil, frm, 1, 1)
  self.Bar = bar
  win:Att(bar.Frm, 0, 1, -tbH, 1)
  bar:SeU(self, self.OTB)
  local pal2 = 0
  local sel1 = 2
  pal2 = 40
  sel1 = 1
  local ori1 = 3
  bar:AdT1("Pals", 1, pal2)
  bar:AdT1("Punks", 2, 46)
  if NxData.NXVerDebug then
      bar:AdT1("Com", 3, 38)
      ori1 = 4
  end
  self.OTI = ori1
  bar:AdT1("Friends", ori1, 60, false, "FriendsFrameTabTemplate", 1)
  bar:AdT1("Who", ori1 + 1, 45, false, "FriendsFrameTabTemplate", 2)
  bar:AdT1("Guild", ori1 + 2, 45, false, "FriendsFrameTabTemplate", 3)
  bar:AdT1("Chat", ori1 + 3, 45, false, "FriendsFrameTabTemplate", 4)
  bar:AdT1("Raid", ori1 + 4, 45, false, "FriendsFrameTabTemplate", 5)
  self.Lis:Cre()
  self.TaS1 = sel1
  bar:Sel1(sel1)
end
function Nx.Opt:NXCmdImportCartMine()
  local function fun()
      Nx:GICM1()
  end
  Nx:ShM("Import Mining?", "Import", fun, "Cancel")
end
function Nx.Map:GIFD(ico)
  return ico.FD1, ico.FD2
end
function Nx.TaB:Enable(ind, ena)
  local tab = self.Tab1[ind]
  tab.But2.Frm:EnableMouse(ena ~= false)
end
function Nx.Inf:M_OE()
  local inf = self.CMI
  local edi1 = not inf.Edi
  inf.Edi = edi1
end
function Nx.Map:RTT(rou, taI)
  Nx.Que.Wat:CAT()
  local maI = self.MaI
  for n, r in ipairs(rou) do
      local wx, wy = self:GWP(maI, r.X, r.Y * 1.5)
      local s = format("Route%s (%s) %s", n, #rou - n + 1, r.Nam or "")
      local tar1 = self:SeT3("Route", wx, wy, wx, wy, taI, nil, s, n ~= 1)
      tar1.Rad = self.GOp["RouteGatherRadius"]
  end
end
function Nx.Map:CIT(icT)
  local d = self.Dat
  d[icT] = nil
end
function Nx.Map:ClearTarget(unI)
  self.Tra1 = {}
  local tar1, i = self:FiT(unI)
  if tar1 then
      tremove(self.Tar, i)
  end
end
function Nx.War:GuD1(guN)
  local war = NxData.NXWare
  local rn = GetRealmName()
  for nam, gui1 in pairs(war) do
      if nam == rn then
          gui1[guN] = nil
          return
      end
  end
end
function Nx.Map.Gui:IAI(fol, id)
  local roo = CarboniteItems
  local inf, sta4, stE, src = strsplit("\t", roo["Items"][id])
  if not inf then
      Nx.prt("bad %s", id)
  end
  local fla = strbyte(inf, 2) - 35
  local uni1 = bit.band(fla, 4) > 0
  local bin = bit.band(bit.rshift(fla, 3), 3) + 1
  local iMi = strbyte(inf, 3) - 35
  local iLv = (strbyte(inf, 4) - 35) * 221 + strbyte(inf, 5) - 35
  local qua = strbyte(inf, 6) - 35
  local nam = ""
  for n = 7, #inf - 1, 2 do
      local h, l = strbyte(inf, n, n + 1)
      nam = nam .. roo.Words[(h - 35) * 221 + l - 35] .. " "
  end
  ite = {}
  tinsert(fol, ite)
  ite.Nam = Nx.QuC[qua] .. nam
  ite.Sor1 = nam
  sta4 = self:IUS(sta4)
  stE = self:IUSE(stE, id)
  local srS = self:IUS1(src, ite)
  local im = max(iMi, 0)
  ite.Co21 = format("L%2d i%3d", im, iLv)
  ite.Co3 = format("%s", srS)
  local _, iLi, iRa, lvl, miL, iTy, suT, stC, eqL, tx = GetItemInfo(id)
  ite.Lin = iLi
  ite.Tx = tx and gsub(tx, "Interface\\Icons\\", "") or "INV_Misc_QuestionMark"
  local typ, slo = strsplit("^", self.ITN1[strbyte(inf) - 35])
  local i = tonumber(slo)
  if i then
      slo = self.ISN1[i]
  elseif not slo then
      local i = bit.band(fla, 3)
      if i > 0 then
          slo = self.IHT[i]
      else
          slo = typ
          typ = ""
      end
  end
  local s = ite.Nam .. "\n" .. self.IBT[bin]
  if uni1 then
      s = s .. "Unique\n"
  end
  if iMi > 0 then
      if bit.band(fla, 0x20) == 0 then
          sta4 = sta4 .. format("Requires Level %d\n", iMi)
      else
          sta4 = sta4 .. format("Quest Level %d\n", iMi)
      end
  end
  ite.Tip = format("%s%s\n%s%s%s", s, slo .. "\t" .. typ, sta4, stE, srS)
  ite.FiT1 = ite.Tip
end
function Nx.Win:Det(chF)
  Nx.prt("Detach %s", #self.ChF)
  for i, ch in ipairs(self.ChF) do
      if ch.Frm == chF then
          tremove(self.ChF, i)
          Nx.prt("Detach found %s", #self.ChF)
          break
      end
  end
end
function Nx.Win:M_OHIC(ite)
  self.MeW.SaD["HideC"] = ite:GetChecked()
end
function Nx.Fon:GeH(nam)
  return self.Fon1[nam].H
end
function Nx.Que:SoQ()
  local cur1 = self.CuQ
  repeat
      local don = true
      for n = 1, #cur1 - 1 do
          if cur1[n].Lev > cur1[n + 1].Lev then
              cur1[n], cur1[n + 1] = cur1[n + 1], cur1[n]
              don = false
          end
      end
  until don
  if self.Lis.QOp.NXShowHeaders then
      local hdN = {}
      for n = 1, #cur1 do
          hdN[cur1[n].Hea1] = 1
      end
      local hdr = {}
      for nam in pairs(hdN) do
          tinsert(hdr, nam)
      end
      sort(hdr)
      local cu2 = cur1
      cur1 = {}
      for _, nam in ipairs(hdr) do
          for n = 1, #cu2 do
              if cu2[n].Hea1 == nam then
                  tinsert(cur1, cu2[n])
              end
          end
      end
      self.CuQ = cur1
  end
  local t = {}
  self.ITCQ = t
  for k, cur in ipairs(cur1) do
      if cur.Q then
          local id = cur.QId
          t[id] = cur
      end
  end
end
function Nx.Win:IsShown()
  local svd = self.SaD
  local vis = self.Frm:IsShown()
  if vis == nil then
      vis = false
  end
  return vis, not svd["Hide"]
end
function Nx.Que:HideUIPanel(fra)
  QuestLogFrame:SetAttribute("UIPanelLayout-enabled", false)
  local deF = QuestLogDetailFrame
  if deF then
      deF:Hide()
  end
  self.Lis:DSW(285)
  self.Lis.Win1:Show(false)
  if self.Lis.Lis:IGN() > 0 then
      self.Lis.Lis:Emp()
      collectgarbage("collect")
  end
  self:REQ()
  self.LHA1 = nil
end
function Nx.Map.Gui:UGF()
  self:CSF()
  self:Upd()
end
function Nx.Fav:CIN()
  local not1 = Cartographer_Notes
  local poi
  if not1 then
      local db = not1["db"]
      if db then
          local acc = db["account"]
          if acc then
              poi = acc["pois"]
          end
      end
  end
  if not poi then
      Nx.prt("Cartographer notes missing")
      return
  end
  local gXY = not1["getXY"]
  if not gXY then
      Nx.prt("Cartographer getXY missing")
      return
  end
  local imC = 0
  for zNa, zDa in pairs(poi) do
      if type(zDa) == "table" then
          for id, dat in pairs(zDa) do
              local mId = Nx.MNTI1[zNa]
              if not mId then
                  Nx.prt("Unknown zone %s", zNa)
              else
                  imC = imC + 1
                  local x, y = gXY(id)
                  local icS = dat["icon"]
                  local nam = dat["title"] or icS or ""
                  local ico = 1
                  for i, iNa in ipairs(self.NoI) do
                      if iNa == icS then
                          ico = i
                      end
                  end
                  local fav = self:GNF(mId)
                  local s = self:CrI("N", 0, nam, ico, mId, x * 100, y * 100)
                  self:AdI1(fav, nil, s)
                  Nx.prt("Import %s %s %s %s %s", nam, zNa, mId, x, y)
              end
          end
      end
  end
  Nx.prt("Imported %s notes", imC)
  self:Upd()
end
function Nx.MapInitIconType(icT, drM)
  local map = Nx.Map:GeM(1)
  map:IIT(icT, drM)
end
function Nx.Map:SwO(id, sta3)
  local opt = NxMapOpts.NXMaps[self.MaI3]
  local cop = opt[id] or opt[0]
  if cop ~= self.CuO then
      self.CuO = cop
      if cop.NXPlyrFollow then
          self:GoP()
      end
      if (not cop.NXPlyrFollow or sta3) and cop.NXMapPosX then
          self.MPX = cop.NXMapPosX
          self.MPY = cop.NXMapPosY
          self.Sca = cop.NXScale
          self.StT = 1
      elseif cop.NXPlyrFollow or Nx.IBG then
          self:GCZ()
      end
      local mod1 = opt[id] and tostring(id) or ""
      self.Win1:SLM(mod1)
  end
end
function Nx.Men:Cre(paF, wid)
  local c2r = Nx.U_22
  local men = {}
  self.Men1[men] = true
  setmetatable(men, self)
  men.Ite1 = {}
  men.Alp = 1
  men.ClT = 0
  men.Wid = wid or 210
  self.NaN = self.NaN + 1
  local nam = format("NxMenu%d", self.NaN)
  local f = CreateFrame("Frame", nam, UIParent)
  men.MaF = f
  tinsert(UISpecialFrames, nam)
  f.NxM = men
  f:Hide()
  f:SetScript("OnUpdate", self.OnU)
  f:EnableMouse(true)
  men:SeS4()
  return men
end
function Nx.Sli:OMD(but)
  local self = this.NxI
  if but == "LeftButton" then
      local frm = self.Frm
      local x, y = Nx.U_IMO(frm)
      if x and x >= 0 then
          local tfr = self.ThF
          local tx, ty = Nx.U_IMO(tfr)
          if self.TyH then
              local w = (frm:GetRight() or 0) - (frm:GetLeft() or 0)
              x = (x - 1) / (frm:GetWidth() - 2) * (self.Max1 - self.Min1) + self.Min1
              self:Set(x)
          else
              if tx then
                  self.DrX = x
                  self.DrY = y
                  self.DrP = self.Pos
              else
                  local h = (frm:GetTop() or 0) - (frm:GetBottom() or 0)
                  y = h - y
                  local pos1 = self.Pos
                  if y < -self.TPt then
                      pos1 = pos1 - self.ViS
                  else
                      pos1 = pos1 + self.ViS
                  end
                  self:Set(pos1)
              end
          end
          self:Upd()
          if self.UsF then
              self.UsF(self.Use, self, self.Pos)
          end
      end
  end
end
function Nx.ToB:Ini()
  local dat = Nx:GDTB()
  if not dat.Version or dat.Version < Nx.VERSIONTOOLBAR then
      if dat.Version then
          Nx.prt("Reset old tool bar data")
      end
      dat.Version = Nx.VERSIONTOOLBAR
      for k, bar in pairs(dat) do
          if type(bar) == "table" then
              dat[k] = nil
          end
      end
  end
  self.TBs = {}
  self.BORDERW = 5
  self.BORDERH = 5
  self.Bor = {"TOPLEFT", "TOPRIGHT", 1, self.BORDERH, "WinBrH", "BOTTOMLEFT", "BOTTOMRIGHT", 1, self.BORDERH,
              "WinBrH", "TOPLEFT", "BOTTOMLEFT", self.BORDERW, 1, "WinBrV", "TOPRIGHT", "BOTTOMRIGHT", self.BORDERW,
              1, "WinBrV"}
  local men = Nx.Men:Cre(UIParent)
  self.Men = men
  self.MIS1 = men:AdI1(0, "Size", self.M_OS1, self)
  self.MIS1:SeS2(8, 8, 32)
  self.MIS2 = men:AdI1(0, "Spacing", self.M_OS2, self)
  self.MIS2:SeS2(0, 0, 15)
  self.MIAR = men:AdI1(0, "Align Right", self.M_OAR, self)
  self.MIAR:SetChecked(true)
  self.MIAB = men:AdI1(0, "Align Bottom", self.M_OAB, self)
  self.MIAB:SetChecked(true)
  self.MIV = men:AdI1(0, "Vertical", self.M_OV, self)
  self.MIV:SetChecked(true)
end
function Nx.prF(msg, frm)
  local prt = Nx.prt
  local par = frm:GetParent()
  prt(msg .. " Frame: %s Shown%d Vis%d P>%s", frm:GetName() or "nil", frm:IsShown() or 0, frm:IsVisible() or 0,
      par and par:GetName() or "nil")
  prt(" EScale %f, Lvl %f", frm:GetEffectiveScale(), frm:GetFrameLevel())
  prt(" LR %f, %f", frm:GetLeft() or -999, frm:GetRight() or -999)
  prt(" BT %f, %f", frm:GetBottom() or -999, frm:GetTop() or -999)
  local reg = {frm:GetRegions()}
  for n, o in ipairs(reg) do
      local str = ""
      if o:IsObjectType("Texture") then
          str = o:GetTexture()
      end
      prt("  %d %s: %s", n, o:GetObjectType(), str)
  end
end
function Nx.Lis:CoA(nam, coI, wid, juH, fon)
  local coI1 = coI or 1
  local w = wid or 9999
  if self.SCW then
      w = tonumber(self.SCW[coI1]) or w
  end
  local col3 = {}
  col3.Nam = nam
  col3.Wid = w
  col3.FoO = Nx.Fon:GeO(fon or self.Fon)
  col3.JuH = juH or "LEFT"
  col3.Dat = {}
  if self.HdF then
      local fst = self.HdF:CreateFontString()
      col3.FSt = fst
      fst:SetFontObject(self.FoO)
      fst:SetJustifyH(col3.JuH)
      fst:SetPoint("TOPLEFT", 0, 0)
      if w >= 0 then
          fst:SetWidth(w)
      end
      fst:SetHeight(self.HdH)
      fst:SetText(nam)
      fst:SetTextColor(.8, .8, 1, 1)
      fst:Show()
  end
  self.Col[coI1] = col3
  self.SSW = nil
end
function Nx.Opt:OSS(w, h)
  Nx.Opt.FSt:SetWidth(w)
end
function Nx.Map:M_OSK(ite)
  self.KiS = ite:GetChecked()
end
function Nx.War:UpI1()
  local lis = self.ItL
  lis:Emp()
  local ite1 = {}
  local cn1 = 1
  local cn2 = 1
  cn2 = #Nx.ReC1
  if self.SeC2 ~= 99 then
      cn1 = self.SeC2
      cn2 = self.SeC2
      local rc = Nx.ReC1[cn1]
      local rna, cna = strsplit(".", rc)
      lis:CSN(3, format("%s's Items", cna))
      local ch = NxData.Characters[rc]
      local ban = ch["WareBank"]
      if not ban then
          lis:ItA(0)
          lis:ItS(3, "|cffff1010No bank data - visit your bank")
      end
      local inv = ch["WareInv"]
      if inv then
          lis:ItA(0)
          lis:ItS(3, "---- Equipped ----")
          for _, dat in ipairs(inv) do
              local slo, lin = strsplit("^", dat)
              Nx.Ite:Loa1(lin)
              slo = gsub(slo, "Slot", "")
              slo = gsub(slo, "%d", "")
              local nam = GetItemInfo(lin)
              self:UpI2(format("  %s - ", slo), nam, 1, 0, 0, lin, true)
          end
      end
  else
      lis:CSN(3, "All Items")
  end
  for cn = cn1, cn2 do
      local rc = Nx.ReC1[cn]
      local ch = NxData.Characters[rc]
      local bag = ch["WareBags"]
      if bag then
          for nam, dat in pairs(bag) do
              self:AdI1(ite1, 2, nam, dat)
          end
      end
      local ban = ch["WareBank"]
      if ban then
          for nam, dat in pairs(ban) do
              self:AdI1(ite1, 3, nam, dat)
          end
      end
      local mai = ch["WareMail"]
      if mai then
          for nam, dat in pairs(mai) do
              self:AdI1(ite1, 4, nam, dat)
          end
      end
  end
  local soR = true
  local iso = {}
  for nam, dat in pairs(ite1) do
      local baC, baC1, maC3, lin = strsplit("^", dat)
      Nx.Ite:Loa1(lin)
      if self.SBR or self.SBS2 then
          local _, iLi, iRa, lvl, miL, ity, _, _, eqL = GetItemInfo(lin)
          local soS = ""
          if self.SBR then
              soS = 9 - (iRa or 0)
          end
          if self.SBS2 and ity == ARMOR and eqL then
              local loc = getglobal(eqL) or ""
              nam = format("%s - %s", loc, nam)
              soS = format("%s%s", loc, soS)
          end
          tinsert(iso, format("%s^%s^%s", soS, nam, dat))
      else
          tinsert(iso, format("^%s^%s", nam, dat))
      end
  end
  sort(iso)
  if not self.SIC then
      for _, v in ipairs(iso) do
          local _, nam, baC, baC1, maC3, lin = strsplit("^", v)
          local _, iLi, iRa = GetItemInfo(lin)
          iRa = iRa or 0
          if iRa >= self.NXRarityMin then
              self:UpI2("", nam, baC, baC1, maC3, lin)
          end
      end
  else
      for _, typ in ipairs(self.ItT) do
          for n = 1, #iso do
              local _, nam, baC, baC1, maC3, lin = strsplit("^", iso[n])
              local _, iLi, iRa, lvl, miL, ity = GetItemInfo(lin)
              if ity == typ then
                  lis:ItA(0)
                  lis:ItS(3, "---- " .. typ .. " ----")
                  for n2 = n, #iso do
                      local _, nam, baC, baC1, maC3, lin = strsplit("^", iso[n2])
                      local _, iLi, iRa, lvl, miL, ity = GetItemInfo(lin)
                      if ity == typ then
                          if iRa >= self.NXRarityMin then
                              self:UpI2("  ", nam, baC, baC1, maC3, lin)
                          end
                      end
                  end
                  break
              end
          end
      end
  end
  lis:Upd()
end
function Nx.Ite:ShT(id, com1)
  local id = tostring(id)
  id = strsplit("^", id)
  if not strfind(id, "item:") then
      if strfind(id, "quest:") then
      else
          id = "item:" .. id .. ":0:0:0:0:0:0:0"
      end
  end
  GameTooltip:SetHyperlink(id)
  if com1 then
      GameTooltip_ShowCompareItem()
  end
end
function Nx.Win:OCB(but1, id, cli)
  if cli == "LeftButton" and self.Clo then
      self:Show(false)
      self:RLD()
      GameTooltip:Hide()
      self:Not("Close")
  else
      if self.Loc2 then
          self:Loc1(false)
      else
          self:OpM()
      end
  end
end
function Nx.Opt:NXCmdReload()
  local function fun()
      ReloadUI()
  end
  Nx:ShM("Reload UI?", "Reload", fun, "Cancel")
end
function Nx.AuA.OA__()
  if IsAddOnLoaded("Blizzard_AuctionUI") then
      hooksecurefunc("AuctionFrameBrowse_Update", Nx.AuA.AuctionFrameBrowse_Update)
      Nx.AuA:Cre()
  end
end
function Nx.Map:SRM(id)
  if self:IIM(id) then
      self:SIM(id)
  else
      self:SIM()
  end
  if self.GOp["MapMMInstanceTogFullSize"] then
      self.LOp.NXMMFull = false
      if self:IIM(id) then
          self.LOp.NXMMFull = true
      end
  end
end
function Nx.But:SeI(id)
  self.Id = id
end
function Nx.Inf:CBGH()
  return "|cffa0a0ff", format("%d", GetHonorCurrency())
end
function Nx:CaF(t, key)
  assert(type(t) == "table" and key)
  local d = t[key] or {}
  t[key] = d
  return d
end
function Nx.MeI:GetChecked()
  return self.Che
end
function Nx.Tra:FiC5(sMI, srX, srY, dMI, dsX, dsY, skI)
  if self.FlM then
      return ((srX - dsX) ^ 2 + (srY - dsY) ^ 2) ^ .5
  end
  local win1 = Nx.Map.MWI
  local srT = win1[sMI]
  if not srT or not srT.Con1 then
      return
  end
  local zco1 = srT.Con1[dMI]
  if zco1 and not self.VMI[dMI] then
      if #zco1 == 0 then
          return ((srX - dsX) ^ 2 + (srY - dsY) ^ 2) ^ .5
      end
      local clC1
      local clD = 9000111222333444
      for n, con in ipairs(zco1) do
          local di1 = ((con.StX - srX) ^ 2 + (con.StY - srY) ^ 2) ^ .5
          local di2 = ((con.EnX - dsX) ^ 2 + (con.EnY - dsY) ^ 2) ^ .5
          local d = di1 + con.Dis + di2
          if d < clD then
              clC1 = con
              clD = d
          end
      end
      return clD, clC1
  elseif not skI then
      local clC1
      local clD = 9000111222333444
      for maI, zco1 in pairs(srT.Con1) do
          if not self.VMI[maI] then
              if #zco1 == 0 then
                  local d, con = self:FiC5(maI, srX, srY, dMI, dsX, dsY, true)
                  if d and d < clD then
                      clD = d
                      clC1 = con
                  end
              else
                  for n, con in ipairs(zco1) do
                      local di1 = ((con.StX - srX) ^ 2 + (con.StY - srY) ^ 2) ^ .5
                      local di2 = ((con.EnX - dsX) ^ 2 + (con.EnY - dsY) ^ 2) ^ .5
                      local pen = win1[maI].Con1[dMI] and 1 or 2
                      local d = di1 + con.Dis + di2 * pen
                      if d < clD then
                          clD = d
                          clC1 = con
                      end
                  end
              end
          end
      end
      return clD, clC1
  end
end
function Nx.Que.Wat:OnW(typ)
  self:Upd()
end
function Nx.Que.Wat:Ope()
  local opt = Nx:GGO()
  self.GOp = opt
  local qop = Nx:GQO()
  self.Wat1 = {}
  self.Ope1 = true
  local fiS2 = opt["QWFixedSize"]
  Nx.Win:SCF(1, .15)
  local bor1 = fiS2 and true or 1
  local win = Nx.Win:Cre("NxQuestWatch", nil, nil, nil, 1, bor1)
  self.Win1 = win
  win:ILD(nil, -.80, -.35, -.2, -.1)
  win:CrB(opt["QWShowClose"], nil, true)
  win:SeU(self, self.OnW)
  win:SBGA(0, 1)
  win.Frm:SetClampedToScreen(true)
  local xo = 0
  local yo = 0
  if not fiS2 then
      xo = 7
      yo = 3
      win:SBS(0, 7)
  end
  win:STXO(84 + xo, -1 - yo)
  win.UUF = self.WUF
  local function upd(self)
      self:Upd()
  end
  local function fun(self)
      self.Men:Ope()
  end
  self.BuM2 = Nx.But:Cre(win.Frm, "QuestWatchMenu", nil, nil, 4, -5 + yo, "TOPLEFT", 1, 1, fun, self)
  local function fun(self)
      self.MeP:Ope()
  end
  self.BuP = Nx.But:Cre(win.Frm, "QuestWatchPri", nil, nil, 19, -5 + yo, "TOPLEFT", 1, 1, fun, self)
  local function fun(self, but1)
      local qop = Nx:GQO()
      qop.NXWShowOnMap = but1:GeP()
  end
  self.BSOM = Nx.But:Cre(self.BuM2.Frm, "QuestWatchShowOnMap", nil, nil, 29, 0, "CENTER", 1, 1, fun, self)
  self.BSOM:SeP2(qop.NXWShowOnMap)
  local function fun(self, but1)
      if not but1:GeP() and not IsShiftKeyDown() then
          Nx.Que.Tra1 = {}
      end
      self:Upd()
  end
  self.BAT1 = Nx.But:Cre(self.BuM2.Frm, "QuestWatchATrack", nil, nil, 43, 0, "CENTER", 1, 1, fun, self)
  local function fun(self, but1)
      Nx.ChO["QMapShowQuestGivers3"] = but1:GeS3()
      local map = Nx.Map:GeM(1)
      map.Gui:UGF()
  end
  self.BQG = Nx.But:Cre(self.BuM2.Frm, "QuestWatchGivers", nil, nil, 57, 0, "CENTER", 1, 1, fun, self)
  self.BQG:SeS3(Nx.ChO["QMapShowQuestGivers3"])
  local function fun(self, but1)
      qop.NXWWatchParty = but1:GeP()
      Nx.Que:PUT()
  end
  self.BSP = Nx.But:Cre(self.BuM2.Frm, "QuestWatchParty", nil, nil, 71, 0, "CENTER", 1, 1, fun, self)
  self.BSP:SeP2(qop.NXWWatchParty == nil or qop.NXWWatchParty)
  Nx.Lis:SCF1("FontWatch", 12)
  local lis = Nx.Lis:Cre(false, 2, -2, 100, 12 * 3, win.Frm, not fiS2, true)
  self.Lis = lis
  lis:SeU(self, self.OLE)
  if not fiS2 then
      lis:SMS(124, 1)
      lis.Frm:EnableMouse(false)
  end
  lis:CoA("", 1, 14)
  lis:CoA("Name", 2, fiS2 and 900 or 20)
  win:Att(lis.Frm, 0, 1, 0, 1)
  local qli1 = Nx.Que.Lis
  local men = Nx.Men:Cre(lis.Frm)
  self.Men = men
  men:AdI1(0, "Watch All Quests", qli1.M_OWA, qli1)
  men:AdI1(0, "Remove All Watches", self.M_ORAW, self)
  men:AdI1(0, "Track None", qli1.M_OTN, qli1)
  local i = 25
  local ite = men:AdI1(0, "Max Visible In List", upd, self)
  ite:SeS2(qop, 1, i, 1, "NXWVisMax")
  local function fun()
      Nx.Opt:Ope("Quest Watch")
  end
  men:AdI1(0, "Options...", fun)
  local men = Nx.Men:Cre(lis.Frm, 260)
  self.MeP = men
  local ite = men:AdI1(0, "Hide Unfinished Quests", upd, self)
  ite:SetChecked(qop, "NXWHideUnfinished")
  local ite = men:AdI1(0, "Hide 5+ Group Quests", upd, self)
  ite:SetChecked(qop, "NXWHideGroup")
  local ite = men:AdI1(0, "Hide Quests Not In Zone", upd, self)
  ite:SetChecked(qop, "NXWHideNotInZone")
  local ite = men:AdI1(0, "Hide Quests Farther Than", upd, self)
  ite:SeS2(qop, 200, 20000, 1, "NXWHideDist")
  local ite = men:AdI1(0, "Sort, Distance", upd, self)
  ite:SeS2(qop, 0, 1, nil, "NXWPriDist")
  local ite = men:AdI1(0, "Sort, Complete", upd, self)
  ite:SeS2(qop, -200, 200, 1, "NXWPriComplete")
  local ite = men:AdI1(0, "Sort, Low Level", upd, self)
  ite:SeS2(qop, -200, 200, 1, "NXWPriLevel")
  local function fun()
      Nx.Map:GeM(1).Gui:UGF()
  end
  local ite = men:AdI1(0, "Quest Giver Lower Levels To Show", fun, self)
  ite:SeS2(opt, 0, 80, 1, "QMapQuestGiversLowLevel")
  local ite = men:AdI1(0, "Quest Giver Higher Levels To Show", fun, self)
  ite:SeS2(opt, 0, 80, 1, "QMapQuestGiversHighLevel")
  local men = Nx.Men:Cre(lis.Frm)
  self.WaM = men
  men:AdI1(0, "Remove Watch", self.M_ORW, self)
  men:AdI1(0, "Link Quest (shift right click)", self.M_OLQ, self)
  men:AdI1(0, "Show Quest Log (alt right click)", self.M_OSQ, self)
  men:AdI1(0, "Show On Map (shift left click)", self.M_OSM, self)
  men:AdI1(0, "Share", self.M_OS3, self)
  men:AdI1(0, "")
  men:AdI1(0, "Abandon", self.M_OA, self)
  self.FiU = true
  self:SSM(1)
end
function Nx.Inf:Ini()
  local opt = Nx:GGO()
  if not opt["IWinEnable"] then
      Nx.Inf = nil
      return
  end
  local cls = Nx:GUC()
  if cls == "Death Knight" or cls == "Warrior" then
      self.MaI1 = true
  end
  if cls == "Death Knight" then
      self.DeK = true
  end
  self.DKR = {{1, "|cffff8080"}, {2, "|cffff8080", true}, {5, "|cff8080ff"}, {6, "|cff8080ff", true},
              {3, "|cff80ff80"}, {4, "|cff80ff80"}}
  self.Var = {}
  self.Inf1 = {}
  local din = NxData.NXInfo
  for n = 1, 10 do
      local inf = din[n]
      if inf then
          self:Cre(n)
      end
  end
  self:CrM()
  self.ItF = {
      ["BarH%"] = self.CBHP,
      ["Cast"] = self.CaC1,
      ["Combo"] = self.CCP,
      ["Cooldown"] = self.CaC2,
      ["Dur"] = self.CaD1,
      ["FPS"] = self.CFPS,
      ["Health"] = self.CaH,
      ["Health%"] = self.CHP,
      ["HealthChange"] = self.CHC,
      ["IfBG"] = self.CIBG,
      ["IfCombat"] = self.CIC,
      ["IfF"] = self.CIF,
      ["IfLT"] = self.CILT,
      ["IfLTOrCombat"] = self.CILTOC,
      ["IfMana"] = self.CIM,
      ["IfT"] = self.CIT1,
      ["LvlTime"] = self.CLT,
      ["Mana"] = self.CaM,
      ["Mana%"] = self.CMP,
      ["ManaChange"] = self.CMC,
      ["BGQueue"] = self.CBGQ,
      ["BGStart"] = self.CBGS,
      ["BGDuration"] = self.CBGD,
      ["BGHonor"] = self.CBGH,
      ["BGStats"] = self.CBGS1,
      ["BGWingWait"] = self.CBGWW,
      ["Stat"] = self.CaS,
      ["THealth"] = self.CTH,
      ["THealth%"] = self.CTHP,
      ["Threat%"] = self.CTP,
      ["TMana"] = self.CTM,
      ["TMana%"] = self.CTMP,
      ["Time"] = self.CaT
  }
  self:OpU()
  Nx.Tim:Sta("Info", 2, self, self.OnT)
end
function Nx.Map:GeM(maI1)
  return self.Map1[maI1]
end
function Nx.Gra:GeF3()
  local pos1 = self.Frm1.Nex
  if pos1 > 1000 then
      pos1 = 1
  end
  local f = self.Frm1[pos1]
  if not f then
      f = CreateFrame("Frame", nil, self.MaF)
      self.Frm1[pos1] = f
      f.NxG = self
      f:SetFrameStrata("MEDIUM")
      local t = f:CreateTexture()
      t:SetAllPoints(f)
      f.tex = t
      f:SetScript("OnEnter", Nx.Gra.OnE1)
      f:SetScript("OnLeave", Nx.Gra.OnL)
      f:EnableMouse(true)
  end
  self.Frm1.Nex = pos1 + 1
  return f
end
function Nx.Inf:CBHP(col, peN, w, h)
  w = tonumber(w) or 50
  h = tonumber(h) or 10
  local baW = (self.Var[peN] or 0) * w
  local xo = w
  if baW >= 1 then
      return "|cffc0c0c0", format(
          "~Interface\\Addons\\Carbonite\\Gfx\\Skin\\InfoBarBG^%d^%d^0&Interface\\Addons\\Carbonite\\Gfx\\Skin\\InfoBar%s^%d^%d^%d",
          w, h, col, baW, h, xo)
  end
  return "|cffc0c0c0", format("~Interface\\Addons\\Carbonite\\Gfx\\Skin\\InfoBarBG^%d^%d^0", w, h)
end
function Nx.Fav:SeI1(ind)
  if self.CuF then
      if self.Rec ~= self.CuF then
          self:SeR1(false)
      end
      self.CII = min(ind, #self.CuF)
      self:UpI1(self.CII)
      self:UpT()
  end
end
function Nx.Que.Lis.FOTC()
  local self = this.NxI
  self.Fil[self.TaS1] = gsub(this:GetText(), self.FDE, "")
  self:Upd()
end
function Nx.Inf:CILT(val, vaN)
  if (self.Var[vaN] or 0) < (tonumber(val) or 1) then
      return "", ""
  end
end
function Nx.Com:OJCAT()
  self.Lis:AdI("", "OnJoinChanATimer")
  if self:GCC() >= 10 then
      return 10
  end
  self.TrA = self.TrA + 1
  JoinChannelByName(self.Nam .. self.CAL .. self.TrA)
  return 3
end
function Nx.Map:GMI(maI)
  local win1 = self.MWI[maI]
  local id = win1.MId
  if not id then
      id = floor(maI / 1000)
      if id == 9 then
          return
      end
      local inf = self.MaI2[id]
      if not inf then
          return
      end
  end
  local t = self.MMB[id]
  if not t then
      return
  end
  return t, t[3], t[4], t[5] or 1
end
function Nx.Lis:GeF3(lis, typ)
  local frm1 = self.Frm1[typ]
  local f = tremove(frm1, 1)
  if not f then
      self.FUI = self.FUI + 1
      if typ == "Color" then
          f = CreateFrame("ColorSelect", nil, lis.Frm)
      elseif typ == "WatchItem" then
          f = CreateFrame("Button", "NxListFrms" .. self.FUI, lis.Frm, "WatchFrameItemButtonTemplate")
      elseif typ == "Info" then
          f = Nx.Inf:CreateFrame(lis.Frm)
      end
      f.NXListFType = typ
  end
  f:Show()
  f:SetParent(lis.Frm)
  tinsert(lis.UsF1, f)
  return f
end
function Nx.HUD:Cre()
  local ins = self
  local gop = Nx.GGO()
  ins.GOp = gop
  ins.ETAD = 0
  Nx.Win:SCF(1, .15)
  local win = Nx.Win:Cre("NxHUD", nil, nil, nil, 2, 1, nil, true)
  ins.Win1 = win
  win:STJ("CENTER", 1)
  win:STJ("CENTER", 2)
  win:SBGA(0, 1)
  win:ILD(nil, 999999, -.17, 1, 1)
  win.Frm:SetToplevel(true)
  local f = CreateFrame("Frame", nil, win.Frm)
  ins.Frm = f
  f.NxI = ins
  f:EnableMouse(false)
  local t = f:CreateTexture()
  t:SetAllPoints(f)
  f.tex = t
  local but1 = CreateFrame("Button", nil, UIParent, "SecureUnitButtonTemplate")
  ins.But2 = but1
  but1:SetAttribute("type", "target")
  but1:SetAttribute("unit", "player")
  but1:RegisterForClicks("LeftButtonDown", "RightButtonDown")
  local t = but1:CreateTexture()
  t:SetAllPoints(but1)
  t:SetTexture("Interface\\AddOns\\Carbonite\\Gfx\\Map\\IconCircle")
  but1.tex = t
  but1:SetWidth(10)
  but1:SetHeight(10)
  self:UpO()
end
function Nx.Soc.Lis:Cre()
  local win = Nx.Soc.Win1
  local tbH = Nx.TaB:GetHeight()
  Nx.Lis:SCF1("FontM")
  local lis = Nx.Lis:Cre("Social", 2, -2, 100, 12 * 3, win.Frm)
  self.Lis = lis
  lis:SeU(self, self.OLE)
  lis:CoA("", 1, 80)
  lis:CoA("Character", 2, 110)
  lis:CoA("Lvl", 3, 20)
  lis:CoA("Class", 4, 65)
  lis:CoA("Zone", 5, 150)
  lis:CoA("Note", 6, 500)
  win:Att(lis.Frm, 0, 1, 0, -tbH)
  local ff = FriendsFrame
  self.FriendsFrame = ff
  self:SeL1()
  local function fOO()
      Nx.Opt:Ope("Social & Punks")
  end
  local men = Nx.Men:Cre(lis.Frm, 230)
  self.PaM = men
  local function fun(self)
      if self.MSN1 then
          local frm = DEFAULT_CHAT_FRAME
          local eb = frm["editBox"]
          if not eb:IsVisible() then
              ChatFrame_OpenChat("/w " .. self.MSN1, frm)
          else
              eb:SetText("/w " .. self.MSN1 .. " " .. eb:GetText())
          end
      end
  end
  men:AdI1(0, "Whisper", fun, self)
  local function fun(self)
      if self.MSN1 then
          InviteUnit(self.MSN1)
      end
  end
  men:AdI1(0, "Invite", fun, self)
  men:AdI1(0, "")
  local function fun(self)
      if UnitIsPlayer("target") and UnitCanCooperate("player", "target") then
          AddFriend("target")
      else
          StaticPopup_Show("ADD_FRIEND")
      end
  end
  men:AdI1(0, "Add Pal And Friend", fun, self)
  local function fun(self)
      if self.MSN1 then
          self:ClF2(self.MSN1)
          local i = self:FFI(self.MSN1)
          if i then
              RemoveFriend(self.MSN1)
          else
              self:Upd()
          end
      end
  end
  men:AdI1(0, "Remove Pal And Friend", fun, self)
  men:AdI1(0, "")
  local function fun(self)
      if self.MSN1 then
          local i = self:FFI(self.MSN1)
          if i then
              self.FriendsFrame["NotesID"] = i
              StaticPopup_Show("SET_FRIENDNOTE", GetFriendInfo(i))
          end
      end
  end
  self.PMIN = men:AdI1(0, "Set Note", fun, self)
  men:AdI1(0, "Set Person", self.M_OSP1, self)
  men:AdI1(0, "")
  men:AdI1(0, "Make Pal (Red) Into Friend", self.M_OMPF, self)
  men:AdI1(0, "Make All Pals Into Friends", self.M_OMPF1, self)
  men:AdI1(0, "")
  men:AdI1(0, "Options...", fOO, self)
  local men = Nx.Men:Cre(lis.Frm)
  self.PuM = men
  local function fun(self)
      self:GoP1(self.Lis.MSN1)
  end
  men:AdI1(0, "Goto", fun, Nx.Soc)
  men:AdI1(0, "Add Character", self.M_OPA, self)
  men:AdI1(0, "Remove Character", self.M_OPR, self)
  men:AdI1(0, "Set Note", self.M_OPSN, self)
  local function fun(self)
      Nx:ClS("PkAct")
      self.PuA = Nx:GeS("PkAct")
  end
  men:AdI1(0, "Clear Actives", fun, Nx.Soc)
  men:AdI1(0, "")
  men:AdI1(0, "Options...", fOO, self)
end
function Nx.Soc.PHUD:Cre()
  local opt = Nx:GGO()
  self.Opt = opt
  self.Pun = {}
  self.But1 = {}
  self.NuB = opt["PunkTWinMaxButs"]
  self.NBU = 0
  self.Cha = true
  Nx.Win:SCF(.5, 0)
  local win = Nx.Win:Cre("NxPunkHUD", nil, nil, true, 1, 1, nil, true)
  self.Win1 = win
  win:ILD(nil, -.6, -.1, 128, 68)
  win:SBGA(0, .5)
  win.Frm:SetToplevel(true)
  local ox, oy = win:GCO()
  local x = ox - 2
  local y = -oy
  for n = 1, self.NuB do
      local but1 = CreateFrame("Button", nil, win.Frm, "SecureUnitButtonTemplate")
      self.But1[n] = but1
      but1:SetPoint("TOPLEFT", x, y)
      y = y - 13
      but1:SetAttribute("type1", "macro")
      but1:SetAttribute("*type2", "click")
      but1:SetAttribute("*clickbutton2", but1)
      but1["Click"] = Nx.Soc.PHUD.Click
      but1:RegisterForClicks("LeftButtonDown", "RightButtonDown")
      local t = but1:CreateTexture()
      t:SetTexture(1, 1, 1, 1)
      t:SetAllPoints(but1)
      but1.tex = t
      but1:SetWidth(125)
      but1:SetHeight(12)
      but1:Hide()
      local fst = but1:CreateFontString()
      but1.NXFStr = fst
      fst:SetFontObject("GameFontNormalSmall")
      fst:SetJustifyH("LEFT")
      fst:SetPoint("TOPLEFT", 0, 1)
      fst:SetWidth(125)
      fst:SetHeight(12)
  end
end
function Nx:GICM()
  Nx:GIC("NXMine")
end
function Nx:InE()
  local Com = Nx.Com
  local Gui = Nx.Map.Gui
  local eve1 = {"PLAYER_LOGIN", Nx.OP_, "TIME_PLAYED_MSG", Nx.OT__, "UPDATE_MOUSEOVER_UNIT", Nx.OU__,
                "PLAYER_REGEN_DISABLED", Nx.OP__, "PLAYER_REGEN_ENABLED", Nx.OP__1, "UNIT_SPELLCAST_SENT", Nx.OU__1,
                "UNIT_SPELLCAST_SUCCEEDED", Nx.OU__2, "UNIT_SPELLCAST_FAILED", Nx.OU__3, "UNIT_SPELLCAST_INTERRUPTED",
                Nx.OU__3, "ZONE_CHANGED_NEW_AREA", Nx.OZ___, "PLAYER_LEVEL_UP", Nx.OP__2, "PARTY_MEMBERS_CHANGED",
                Nx.OP__3, "UPDATE_BATTLEFIELD_SCORE", Nx.OU__4, "UPDATE_WORLD_STATES", Nx.OU__4,
                "PLAYER_LEAVING_WORLD", Com.OnE, "COMBAT_LOG_EVENT_UNFILTERED", Com.OC___, "FRIENDLIST_UPDATE",
                Com.OF_, "GUILD_ROSTER_UPDATE", Com.OF_, "CHAT_MSG_CHANNEL_JOIN", Com.OCE, "CHAT_MSG_CHANNEL_NOTICE",
                Com.OCE, "CHAT_MSG_CHANNEL_LEAVE", Com.OCE, "CHAT_MSG_CHANNEL", Com.OC__, "CHAT_MSG_ADDON", Com.OC__1,
                "CHANNEL_ROSTER_UPDATE", Com.OC__2, "CHAT_MSG_COMBAT_FACTION_CHANGE", Nx.Que.OC____,
                "CHAT_MSG_RAID_BOSS_WHISPER", Nx.Que.OC____1, "CHAT_MSG_BG_SYSTEM_NEUTRAL", Nx.OC____2,
                "AUCTION_HOUSE_SHOW", Nx.AuA.OA__, "AUCTION_HOUSE_CLOSED", Nx.AuA.OA__1, "AUCTION_ITEM_LIST_UPDATE",
                Nx.AuA.OA___, "PLAYER_TARGET_CHANGED", Gui.OP__4, "MERCHANT_SHOW", Gui.OM_, "MERCHANT_UPDATE",
                Gui.OM_1, "GOSSIP_SHOW", Gui.OG_, "TRAINER_SHOW", Gui.OT_, "TAXIMAP_OPENED", Nx.Tra.OT_1,
                "BAG_UPDATE", Nx.War.OB_, "PLAYERBANKSLOTS_CHANGED", Nx.War.OB_, "PLAYERBANKBAGSLOTS_CHANGED",
                Nx.War.OB_, "BANKFRAME_OPENED", Nx.War.OB_1, "BANKFRAME_CLOSED", Nx.War.OB_2, "GUILDBANKFRAME_OPENED",
                Nx.War.OG_1, "GUILDBANKFRAME_CLOSED", Nx.War.OG_2, "ITEM_LOCK_CHANGED", Nx.War.OI__,
                "MAIL_INBOX_UPDATE", Nx.War.OM__, "UNIT_INVENTORY_CHANGED", Nx.War.OU__5, "MERCHANT_CLOSED",
                Nx.War.OM_2, "LOOT_OPENED", Nx.War.OL_, "LOOT_SLOT_CLEARED", Nx.War.OL__, "LOOT_CLOSED", Nx.War.OL_1,
                "CHAT_MSG_SKILL", Nx.War.OC__3, "SKILL_LINES_CHANGED", Nx.War.OC__3, "TRADE_SKILL_UPDATE",
                Nx.War.OT__1, "QUEST_QUERY_COMPLETE", Nx.Que.OQ__}
  local n = 1
  while eve1[n] do
      Nx:RegisterEvent(eve1[n], eve1[n + 1])
      n = n + 2
  end
end
function Nx.Map:GM_OG()
  Nx.Que.Wat:CAT()
  if self.ClT2 == 3001 then
      Nx.Soc:GoP1(self.ClI)
  else
      local ico = self.ClI
      local x = ico.X
      local y = ico.Y
      local nam = ico.Tip and strsplit("\n", ico.Tip) or ""
      self:SeT3("Goto", x, y, x, y, false, 0, nam)
  end
end
function Nx.Com1:EnC(val1)
  if not self.InC then
      self.InC = true
      self.HiP = 10
      self.HiT = 0
      self.TiS = GetTime()
      self.GrH:Clear()
      self.GrH:SeP(self.HiP)
  end
end
function Nx.Map.UQMPOIH()
  local self = Nx.Map:GeM(1)
  local f = self.WMF
  if f then
      for n = 1, QuestMapUpdateAllQuests() do
          local f = QUEST_MAP_POI[n]
          if f then
              f:Hide()
          end
      end
      for n = 1, #QUEST_MAP_ADDITIONAL_POI do
          QUEST_MAP_ADDITIONAL_POI[n]:Hide()
      end
  end
end
function Nx:ECD()
  local tDa = CarboniteTransferData
  if not tDa then
      Nx.prE("Carbonite Transfer addon is not loaded")
      return
  end
  local acN = GetCVar("accountName")
  if acN == "" then
      Nx.prE("'Remember Account Name' must be checked on Login screen")
      return
  end
  Nx.prt("Exporting account %s data", acN)
  local reN = GetRealmName()
  local act = tDa[acN]
  if not act or act.Version < Nx.VERSIONTD then
      act = {}
      act.Version = Nx.VERSIONTD
  end
  tDa[acN] = act
  local dat = {}
  act[reN] = dat
  for cnu, rc in ipairs(Nx.ReC1) do
      local rna, cna = strsplit(".", rc)
      local ch = NxData.Characters[rc]
      if ch then
          if not ch["Account"] then
              Nx.prt(" Exporting %s", cna)
              local t = Nx.U_TCR(ch)
              dat[cna] = t
              t["E"] = nil
              t["L"] = nil
              t["Q"] = nil
              t["W"] = nil
              t["TBar"] = nil
          end
      end
  end
end
function Nx.prT(msg, s)
  Nx.prt(msg .. " Table: " .. type(s))
  if type(s) == "table" then
      for k, v in pairs(s) do
          if type(v) ~= "table" then
              Nx.prV(" " .. k, v)
          else
              Nx.prt(" " .. k .. " table")
          end
      end
  end
end
function Nx.Ski:GFSBGC()
  return self.FBC
end
function Nx.Map:INM(maI)
  return maI > 1000 and maI % 1000 > 0 and maI < 5000
end
function Nx:NXMapKeyTogNoneNormal()
  Nx.Map:ToS1(0)
end
function Nx.Map.Gui:FiF(nam, fol)
  fol = fol or Nx.GuI
  for n, chi in ipairs(fol) do
      local cna = gsub(chi.Nam or chi.T, "   >>", "")
      if cna == nam then
          return chi, n
      end
  end
end
function Nx.Com:Sen(chI, msg, plN)
  assert(msg)
  if chI == "Z" then
      local maI = Nx.Map:GRMI()
      local chN1 = self.ZSt[maI] and self.ZSt[maI].ChN
      if chN1 then
          local num = GetChannelName(chN1)
          if num ~= 0 then
              self:SeC(num, msg)
          end
      end
  else
      self.SeB = self.SeB + #msg + 54 + 20
      if chI == "g" then
          if IsInGuild() then
              SendAddonMessage(self.Nam, msg, "GUILD")
          end
      elseif chI == "p" then
          SendAddonMessage(self.Nam, msg, "PARTY")
      elseif chI == "W" then
          SendAddonMessage(self.Nam, msg, "WHISPER", plN)
      elseif chI == "P" then
          if GetNumPartyMembers() > 0 then
              self:SCMF(msg, "PARTY")
          end
      else
          assert(false)
      end
  end
end
function Nx.prV(msg, v)
  local prt = Nx.prt
  if v == nil then
      prt(msg .. " nil")
  elseif type(v) == "boolean" then
      prt(msg .. " " .. tostring(v))
  elseif type(v) == "number" then
      prt(format("%s #%d (0x%x)", msg, v, v))
  elseif type(v) == "string" then
      local s = gsub(v, "%%", "%%%%")
      prt(msg .. " '" .. s .. "'")
  elseif type(v) == "table" then
      Nx.prT(msg, v)
  else
      prt(msg .. " ? " .. tostring(v))
  end
end
function Nx.Map:UpO(ind)
  local src = Nx.Map.Map1[ind]
  local dst = NxMapOpts.NXMaps[ind]
  assert(src)
  assert(dst)
  dst.NXShowUnexplored = src.ShU
  dst.NXKillShow = src.KiS
  dst.NXBackgndAlphaFade = src.BAF
  dst.NXBackgndAlphaFull = src.BAF1
  dst.NXDotZoneScale = src.DZS
  dst.NXDotPalScale = src.DPS
  dst.NXDotPartyScale = src.DPS1
  dst.NXDotRaidScale = src.DRS
  dst.NXIconNavScale = src.INS
  dst.NXIconScale = src.IcS
  local opt = src.CuO
  if opt then
      opt.NXMapPosX = src.MPX
      opt.NXMapPosY = src.MPY
      opt.NXScale = src.Sca
  end
end
function Nx.Soc:OUT()
  self:CaP()
  if self.TaS1 == 2 and self.Win1:IsShown() then
      self.Lis:Upd()
      return 3
  end
end
function Nx.Lis:OMD(cli)
  local ins = this.NxI
  local x, y = Nx.U_IMO(this)
  if x then
      y = this:GetHeight() - y
      if y >= ins.HdH then
          y = floor((y - ins.HdH) / ins:GLH())
          ins.Sel = min(y + ins.Top, ins.Num)
          local id = ins:CHT(x)
          if id and ins.UsF then
              ins.UsF(ins.Use, Nx.Lis.CTN[cli], ins.Sel, id)
          end
          ins:Upd()
      end
  end
end
function Nx.U_GTES(sec1)
  local sec = sec1
  local min1 = sec / 60 % 60
  local hou = sec / 3600
  if hou > 24 then
      return format("%.1f days", hou / 24)
  elseif hou >= 1 then
      return format("%.1f hours", hou)
  end
  return format("%d mins", min1)
end
function Nx.Map:M_ORPAFK(ite)
  local n = 0
  for k, v in pairs(Nx.Map.AFK1) do
      ReportPlayerIsPVPAFK(v)
      n = n + 1
  end
  Nx.prt("%d reported", n)
end
function Nx.Que:ClC()
  Nx:GeC()["Q"] = {}
end
function Nx:NXMapKeyTogMine()
  local map = Nx.Map:GeM(1)
  Nx.ChO["MapShowGatherM"] = not Nx.ChO["MapShowGatherM"]
  map.MISM:SetChecked(Nx.ChO, "MapShowGatherM")
  map.Gui:UGF()
end
function Nx.Que.Lis:ChS(maI, ind)
  local NTMI = Nx.Map.NTMI
  local Que = Nx.Que
  while true do
      local qId = Que.Sor[ind]
      if Que:ChS(maI, qId) then
          return true
      end
      local que = Que.ITQ[qId]
      local next = Que:UnN(que[1])
      if next == 0 then
          return
      end
      ind = ind + 1
  end
end
function Nx.AuA.OA__1()
  local self = Nx.AuA
  if self.Win1 then
      self.Win1:Show(false)
      self.ItL:Emp()
  end
end
function Nx.Map:MOMU(but)
  local map = Nx.Map.Map1[1]
  if this.NXPing then
      if map.MMZT == 0 then
          Minimap_OnClick(this)
      else
          map:Pin()
      end
  else
      this.NxM1 = map
      map:OMU(but)
  end
end
function Nx.Tim:PrI()
  self.Pro2 = {}
  self.RuT = GetTime()
end
function Nx.Que:GPT1(que, cur)
  local s = ""
  if que and que.CNu then
      if cur then
          s = s .. format("(Part %d of %d)", que.CNu, cur.CNM)
      else
          s = s .. format("(Part %d)", que.CNu)
      end
  end
  return s
end
function Nx.Map:GIC2(icT)
  return #self.Dat[icT]
end
function Nx.Fav:Cre()
  self.Sid = 1
  local win = Nx.Win:Cre("NxFav", 240, nil, nil, 1)
  self.Win1 = win
  win.Frm.NxI = self
  win:CrB(true, true)
  win:STLH(18)
  win:STXO(220)
  win:ILD(nil, -.23, -.25, -.54, -.5)
  win.Frm:SetToplevel(true)
  win:Show(false)
  tinsert(UISpecialFrames, win.Frm:GetName())
  local bw, bh = win:GBS()
  local but1 = Nx.But:Cre(win.Frm, "Txt64B", "Record", nil, bw + 1, -bh, "TOPLEFT", 44, 20, self.B_OR, self)
  self.ReB1 = but1
  local but1 = Nx.But:Cre(win.Frm, "Txt64", "Up", nil, bw + 48, -bh, "TOPLEFT", 40, 20, self.B_OU, self)
  local but1 = Nx.But:Cre(but1.Frm, "Txt64", "Down", nil, 42, 0, "TOPLEFT", 40, 20, self.B_OD, self)
  Nx.But:Cre(but1.Frm, "Txt64", "Delete Item", nil, 54, 0, "TOPLEFT", 72, 20, self.B_OID, self)
  Nx.Lis:SCF1("FontM", 16)
  local lis = Nx.Lis:Cre("FavF", 0, 0, 1, 1, win.Frm)
  self.Lis = lis
  lis:SeU(self, self.OLE)
  lis:SLH(4)
  lis:CoA("", 1, 20)
  lis:CoA("Name", 2, 900)
  win:Att(lis.Frm, 0, .3, 0, 1)
  Nx.Lis:SCF1("FontM", 16)
  local lis = Nx.Lis:Cre("FavI", 0, 0, 1, 1, win.Frm)
  self.ItL = lis
  lis:SeU(self, self.OILE)
  lis:SLH(2)
  lis:CoA("", 1, 17)
  lis:CoA("Type", 2, 90)
  lis:CoA("Value", 3, 250)
  lis:CoA("Location", 4, 900)
  win:Att(lis.Frm, .3, 1, 0, 1)
  self:CrM()
  self:Upd()
  self.Lis:FuU()
end
function Nx.Que.Lis:OQU(eve)
  local Que = Nx.Que
  local opt = Nx:GGO()
  if eve == "PLAYER_LOGIN" then
      self.LoI2 = true
  elseif eve == "QUEST_PROGRESS" then
      local aut = opt["QAutoTurnIn"]
      if IsShiftKeyDown() and IsControlKeyDown() then
          aut = not aut
      end
      if aut then
          CompleteQuest()
      end
      return
  elseif eve == "QUEST_COMPLETE" then
      local aut = opt["QAutoTurnIn"]
      if IsShiftKeyDown() and IsControlKeyDown() then
          aut = not aut
      end
      if aut then
          if GetNumQuestChoices() == 0 then
              QuestRewardCompleteButton_OnClick()
          end
      end
      return
  elseif eve == "QUEST_LOG_UPDATE" then
      local qn
      Que:ExQ()
      if not self.LoI2 then
          qn = Que:FNQ()
          if not qn then
              Que:TPOC()
          end
      end
      Que:ReQ1()
      if self.LoI2 then
          Nx.Tim:Sta("QWatchLogin", .7, Que, Que.WAL)
          Nx.Tim:Sta("QSetPDLogin", 2, Que, Que.CQSPD)
          if Nx.V33 and opt["QHCheckCompleted"] then
              Nx.Tim:Sta("QHistLogin", 60, Que, Que.GHT)
          end
      end
      if qn then
          local cur2, cur = Que:FCBI(qn)
          if opt["QWAddNew"] and not Que.DPVPI[cur.QId] then
              Que.Wat:Add(cur2)
          end
          Que:Cap(cur2)
      end
      Que:REQ()
      self.LoI2 = nil
  end
  Que.Wat:ClC1()
  self:Upd()
end
function Nx.Win:GeF2()
  return self.BaF
end
function Nx.Fav:M_OP1()
  if not self.CoB then
      Nx.prt("Nothing to paste")
      return
  end
  if type(self.CoB) ~= "table" then
      Nx.prt("Can't paste that on the left side")
      return
  end
  local new1 = Nx.U_TCR(self.CoB)
  local ite = self.CuF
  if ite then
      local par = self:GetParent(ite)
      local i = Nx.U_TFII(par, ite)
      tinsert(par, i, new1)
  else
      tinsert(self.CuF1, 1, new1)
  end
  self:Upd()
  self:SeC1()
end
function Nx.Que.Lis:M_OSOD(ite)
  self.SOD = ite:GetChecked()
  self:Upd()
end
function Nx.Map.Gui:M_OD1()
  local ite = self.MCI
  local mod1 = strbyte(ite.T)
  if mod1 == 40 then
      local npN = strsub(ite.T, 2)
      local vv = NxData.NXVendorV
      vv[npN] = nil
  end
  self:UVV()
  local par = Nx.GuI
  for n = 2, #self.PaH do
      local i = max(min(self.PHS[n - 1], #par), 1)
      self.PaH[n] = par[i]
      par = self.PaH[n]
  end
  self:ClA()
  self:SeL2()
end
function Nx.Fav:FiF(nam, par)
  par = par or self.Fol
  for _, ite in ipairs(par) do
      if ite["T"] == "F" then
          if ite["Name"] == nam then
              return ite
          end
      end
  end
end
function Nx.Ut_(t)
  local n = 0
  if t then
      for k, v in pairs(t) do
          n = n + 1
      end
  end
  return n
end
function Nx.Map:Cre(ind)
  local Map = Nx.Map
  local m = {}
  local gop = Nx.GGO()
  m.GOp = gop
  local opt = NxMapOpts.NXMaps[ind]
  m.LOp = opt
  opt.NXPOIAtScale = opt.NXPOIAtScale or 1
  setmetatable(m, self)
  self.__index = self
  m.Tic = 0
  m.Debug = nil
  m.DeT = nil
  m.DFC = nil
  m.DAS = .1
  m.MaI3 = ind
  if not Nx.Fre then
      m.MMO1 = gop["MapMMOwn"] and ind == 1
  end
  m.ShU = opt.NXShowUnexplored
  m.KiS = opt.NXKillShow
  m.TiH = 0
  m.PaX = 0
  m.Sca = .025
  m.ScD = .025
  m.MaS = opt.NXMapScale or 1
  m.MaW = 150
  m.MaH = 140
  m.W = m.MaW + m.PaX * 2
  m.H = m.MaH + m.TiH + 1
  m.LCT = 0
  m.Scr2 = false
  m.StT = 0
  m.MaI = 0
  m.BaS = 1
  m.PlX = 0
  m.PlY = 0
  m.PRZX = 0
  m.PRZY = 0
  m.PlD = 0
  m.PLD = 999
  m.PlS = 0
  m.PSX = 0
  m.PSY = 0
  m.PSCT = GetTime()
  m.MoD = 0
  m.MLX = 0
  m.MLY = 0
  m.VSD = {}
  m.MPX = 2200
  m.MPY = -100
  m.MPXD = m.MPX
  m.MPYD = m.MPY
  m.MDO = {}
  m.MDF = {}
  m.MiB = gop["MapDetailSize"]
  m.BAF = opt.NXBackgndAlphaFade
  m.BAF1 = opt.NXBackgndAlphaFull
  m.BaA = 0
  m.BAT = m.BAF
  m.WoA = 0
  m.DZS = opt.NXDotZoneScale
  m.DPS = opt.NXDotPalScale
  m.DPS1 = opt.NXDotPartyScale
  m.DRS = opt.NXDotRaidScale
  m.INS = opt.NXIconNavScale
  m.IcS = opt.NXIconScale
  m.ArP = 1
  m.ArS = 0
  m.UTD = 0
  m.UTD1 = 0
  m.Tar = {}
  m.TNUI = 1
  m.Tra1 = {}
  m.TrP = {}
  m.Dat = {}
  m.IcF = {}
  m.IcF.Nex = 1
  m.INIF = {}
  m.INIF.Nex = 1
  m.ISF1 = {}
  m.ISF1.Nex = 1
  m.TFS2 = {}
  m.TFS2.Nex = 1
  m.MMGUD = 1
  Nx.Win:SCF(1, 0)
  local wna = m:GWN()
  local i = gop["MapShowTitle2"] and 2 or 1
  local win = Nx.Win:Cre(wna, nil, nil, nil, i)
  m.Win1 = win
  win:SBGA(0, 1)
  win:CrB(true)
  win:ILD(nil, -.0001, -.4, -.19, -.3, 1)
  for n = 9001, 9004 do
      win:ILD(tostring(n), -.0001, -.4, -.19, -.3, 1)
  end
  win:ILD("9008", -.0001, -.4, -.19, -.3, 1)
  win:ILD("9009", -.0001, -.4, -.19, -.3, 1)
  win:SeU(m, self.OnW)
  win.UUF = m.WUF
  win.Frm:SetToplevel(true)
  win.Frm.NxM1 = m
  m.StS = win:IsShown()
  win.Frm:Show()
  local f = CreateFrame("Frame", nil, UIParent)
  m.Frm = f
  f.NxM1 = m
  win:Att(f, 0, 1, 0, 1)
  win:RegisterEvent("WORLD_MAP_UPDATE", self.OnE)
  f:SetScript("OnMouseDown", self.OMD)
  f:SetScript("OnMouseUp", self.OMU)
  f:SetScript("OnMouseWheel", self.OMW)
  f:EnableMouse(true)
  f:EnableMouseWheel(true)
  f:SetScript("OnUpdate", self.OnU)
  f:SetMovable(true)
  f:SetResizable(true)
  f:SetWidth(m.W)
  f:SetHeight(m.H)
  f:SetMinResize(50, 50)
  local t = f:CreateTexture()
  t:SetTexture(0, 0, 0, .2)
  t:SetAllPoints(f)
  f.tex = t
  f:Show()
  local tsf = CreateFrame("ScrollFrame", nil, f)
  m.TSF = tsf
  tsf:SetAllPoints(f)
  local tf = CreateFrame("Frame", nil, tsf)
  m.TeF = tf
  tf:SetPoint("TOPLEFT", 0, 0)
  tf:SetWidth(100)
  tf:SetHeight(100)
  tsf:SetScrollChild(tf)
  m:CLT1()
  m:CTB()
  local bw, bh = win:GBS()
  local function fun(self, but1)
      self.LOp.NXAutoScaleOn = but1:GeP()
  end
  m.BASO = Nx.But:Cre(win.Frm, "MapAutoScale", nil, nil, -20, -bh, "TOPRIGHT", 12, 12, fun, m)
  m.BASO:SeP2(opt.NXAutoScaleOn)
  local men = Nx.Men:Cre(f)
  m.Men = men
  men:AdI1(0, "Goto", self.M_OG, m)
  men:AdI1(0, "Clear Goto", self.M_OCG, m)
  men:AdI1(0, "Add Note", self.M_OAN, m)
  men:AdI1(0, "Save Map Scale", self.M_OSS, m)
  men:AdI1(0, "Restore Map Scale", self.M_OSR, m)
  m.MIPF = men:AdI1(0, "Follow You", self.M_OPF, m)
  local ite = men:AdI1(0, "Select Cities Last", self.SLWH, m)
  ite:SetChecked(m, "NXCitiesUnder")
  m.MIMZ = men:AdI1(0, "Monitor Zone", self.M_OMZ, m)
  men:AdI1(0, "", nil, self)
  local roM = Nx.Men:Cre(f)
  men:ASM(roM, "Route...")
  local function fun(self)
      self:RoG()
  end
  local ite = roM:AdI1(0, "Current Gather Locations", fun, m)
  local function fun(self)
      self:RoT()
  end
  local ite = roM:AdI1(0, "Current Goto Targets", fun, m)
  local function fun(self)
      self.ShU = false
      self:UOU()
      self:TOU()
      self:RoT()
  end
  roM:AdI1(0, "Unexplored Locations", fun, m)
  local function fun(self)
      self:ReT()
  end
  roM:AdI1(0, "Reverse Targets", fun, m)
  local ite = roM:AdI1(0, "Recycle Reached Targets")
  ite:SetChecked(gop, "RouteRecycle")
  local ite = roM:AdI1(0, "Gather Target Radius")
  ite:SeS2(gop, 7, 300, nil, "RouteGatherRadius")
  local ite = roM:AdI1(0, "Gather Merge Radius")
  ite:SeS2(gop, 0, 100, nil, "RouteMergeRadius")
  local shM = Nx.Men:Cre(f)
  men:ASM(shM, "Show...")
  shM:AdI1(0, "Show Player Zone", self.M_OSPZ, m)
  local function fun(self)
      self.Gui:UGF()
  end
  local ite = shM:AdI1(0, "Show Herb Locations", fun, m)
  m.MISH = ite
  ite:SetChecked(Nx.ChO, "MapShowGatherH")
  local ite = shM:AdI1(0, "Show Mining Locations", fun, m)
  m.MISM = ite
  ite:SetChecked(Nx.ChO, "MapShowGatherM")
  local ite = shM:AdI1(0, "Show Notes")
  ite:SetChecked(gop, "MapShowNotes")
  local ite = shM:AdI1(0, "Show Punks")
  ite:SetChecked(gop, "MapShowPunks")
  local function fun(self, ite)
      self.ShU = ite:GetChecked()
  end
  local ite = shM:AdI1(0, "Show Unexplored Areas", fun, m)
  ite:SetChecked(m.ShU)
  m.MISW = shM:AdI1(0, "Show World", self.M_OSW, m)
  local function fSC(self)
      self.SCM = 10
  end
  local ite = shM:AdI1(0, "Show Cities", fSC, Map)
  ite:SetChecked(gop, "MapShowCCity")
  local ite = shM:AdI1(0, "Show Towns", fSC, Map)
  ite:SetChecked(gop, "MapShowCTown")
  local ite = shM:AdI1(0, "Show Extras", fSC, Map)
  ite:SetChecked(gop, "MapShowCExtra")
  local ite = shM:AdI1(0, "Show Kill Icons", self.M_OSK, m)
  ite:SetChecked(m.KiS)
  if not Nx.Fre then
      local mmm = Nx.Men:Cre(f)
      men:ASM(mmm, "Minimap...")
      local function fun(self, ite)
          self.LOp.NXMMFull = ite:GetChecked()
          self.MMZC = true
      end
      local ite = mmm:AdI1(0, "Full Size", fun, m)
      self.MMMIF = ite
      ite:SetChecked(opt.NXMMFull)
      local function fun(self, ite)
          self.LOp.NXMMAlpha = ite:GeS1()
      end
      local ite = mmm:AdI1(0, "Transparency", fun, m)
      ite:SeS2(opt.NXMMAlpha, 0, 1)
      local function fun(self, ite)
          self.LOp.NXMMDockScale = ite:GeS1()
          self.MMZC = true
      end
      local ite = mmm:AdI1(0, "Docked Scale", fun, m)
      ite:SeS2(opt.NXMMDockScale, .01, 3)
      local function fun(self, ite)
          self.LOp.NXMMDockScaleBG = ite:GeS1()
          self.MMZC = true
      end
      local ite = mmm:AdI1(0, "Docked Scale In BG", fun, m)
      ite:SeS2(opt.NXMMDockScaleBG, .01, 3)
      local function fun(self, ite)
          self.LOp.NXMMDockAlpha = ite:GeS1()
      end
      local ite = mmm:AdI1(0, "Docked Transparency", fun, m)
      ite:SeS2(opt.NXMMDockAlpha, 0, 1)
      local function fun(self, ite)
          self.LOp.NXMMDockOnAtScale = ite:GeS1()
      end
      local ite = mmm:AdI1(0, "Docking Below Map Scale", fun, m)
      ite:SeS2(opt.NXMMDockOnAtScale, 0, 5)
  end
  local sme = Nx.Men:Cre(f)
  men:ASM(sme, "Scale...")
  local ite = sme:AdI1(0, "Auto Scale Min")
  ite:SeS2(opt, .01, 10, nil, "NXAutoScaleMin")
  local ite = sme:AdI1(0, "Auto Scale Max")
  ite:SeS2(opt, .25, 10, nil, "NXAutoScaleMax")
  local ite = sme:AdI1(0, "Zone Dot Scale", self.M_ODZS, m)
  ite:SeS2(m.DZS, 0.1, 2)
  local ite = sme:AdI1(0, "Friend/Guild Dot Scale", self.M_ODPS, m)
  ite:SeS2(m.DPS, 0.1, 2)
  local ite = sme:AdI1(0, "Party Dot Scale", self.M_ODPS1, m)
  ite:SeS2(m.DPS1, 0.1, 2)
  local ite = sme:AdI1(0, "Raid Dot Scale", self.M_ODRS, m)
  ite:SeS2(m.DRS, 0.1, 2)
  local ite = sme:AdI1(0, "Icon Scale", self.M_OIS, m)
  ite:SeS2(m.IcS, 0.1, 3)
  local ite = sme:AdI1(0, "Navigation Icon Scale", self.M_OINS, m)
  ite:SeS2(m.INS, 0.1, 3)
  local function fun(self, ite)
      self.LOp.NXDetailScale = ite:GeS1()
  end
  local ite = sme:AdI1(0, "Details At Scale", fun, m)
  ite:SeS2(opt.NXDetailScale, .05, 10)
  local ite = sme:AdI1(0, "Gather Icons At Scale")
  ite:SeS2(gop, .01, 10, nil, "MapIconGatherAtScale")
  local ite = sme:AdI1(0, "POI Icons At Scale")
  ite:SeS2(opt, .1, 10, nil, "NXPOIAtScale")
  local tme = Nx.Men:Cre(f)
  m.TrM = tme
  men:ASM(tme, "Transparency...")
  local ite = tme:AdI1(0, "Detail Transparency", self.M_ODA, m)
  ite:SeS2(opt.NXDetailAlpha, .25, 1)
  local ite = tme:AdI1(0, "Fade In Transparency", self.M_OBAF, m)
  ite:SeS2(m.BAF1, .25, 1)
  local ite = tme:AdI1(0, "Fade Out Transparency", self.M_OBAF1, m)
  ite:SeS2(m.BAF, 0, 1)
  local function fun(self)
      self.Gui:UGF()
  end
  local ite = tme:AdI1(0, "Gather Icon Transparency", fun, m)
  ite:SeS2(gop, .2, 1, nil, "MapIconGatherA")
  local ite = tme:AdI1(0, "POI Icon Transparency")
  ite:SeS2(gop, .2, 1, nil, "MapIconPOIAlpha")
  local function fun(self, ite)
      self.LOp.NXUnexploredAlpha = ite:GeS1()
  end
  local ite = tme:AdI1(0, "Unexplored Transparency", fun, m)
  ite:SeS2(opt.NXUnexploredAlpha, 0, .9)
  local ite = men:AdI1(0, "Options...", self.M_OO, m)
  if NxData.DebugMap then
      m.DebugMap = true
      local dbm = Nx.Men:Cre(f)
      men:AdI1(0, "", nil, self)
      men:ASM(dbm, "Debug...")
      local function fun(self, ite)
          self.Debug = ite:GetChecked()
      end
      local ite = dbm:AdI1(0, "Map Debug", fun, m)
      ite:SetChecked(false)
      local ite = dbm:AdI1(0, "Hotspots", fun, m)
      ite:SetChecked(m, "DebugHotspots")
      dbm:AdI1(0, "Hotspots pack", self.PHD, m)
      local function fun(self, ite)
          self.DeT = ite:GetChecked()
      end
      local ite = dbm:AdI1(0, "Map Debug Time", fun, m)
      ite:SetChecked(false)
      local ite = dbm:AdI1(0, "Map Full Coords", self.M_OMDFC, m)
      ite:SetChecked(m.DFC)
      local ite = dbm:AdI1(0, "Quest Debug", self.M_OQD, m)
      ite:SetChecked(Nx.Que.Debug)
      local function fun(self, ite)
          self.DeS = ite:GeS1()
      end
      local ite = dbm:AdI1(0, "Scale", fun, m)
      ite:SeS2(0, 4, 6)
  end
  local men = Nx.Men:Cre(f)
  m.PIM = men
  men:AdI1(0, "Whisper", self.M_OW, m)
  men:AdI1(0, "Invite", self.M_OI, m)
  men:AdI1(0, "Get Quests", self.M_OGQ, m)
  local ite = men:AdI1(0, "Track Player", self.M_OTP, m)
  local ite = men:AdI1(0, "Remove From Tracking", self.M_ORT, m)
  men:AdI1(0, "Report Player AFK", self.M_ORPAFK, m)
  men:AdI1(0, "")
  local ite = men:AdI1(0, "Grow Conflict Bars", self.M_OGCB, m)
  ite:SetChecked(true)
  m.BGGB = true
  m:CIM1(f)
  m.BGIN = 0
  local men = Nx.Men:Cre(f)
  m.BGIM = men
  for n = 1, #NXlBGMessages, 2 do
      local function fun(self)
          self:BGM_S(NXlBGMessages[n + 1])
      end
      men:AdI1(0, NXlBGMessages[n], fun, m)
  end
  men:AdI1(0, NXlBGStatus, self.BGM_OS, m)
  local plf = CreateFrame("Frame", nil, f)
  m.PlF = plf
  plf.NxM1 = m
  plf:SetWidth(3)
  plf:SetHeight(3)
  t = plf:CreateTexture()
  plf.tex = t
  t:SetTexture("Interface\\Minimap\\MinimapArrow")
  t:SetAllPoints(plf)
  plf:SetPoint("CENTER", 0, (m.TiH - 1) * -.5)
  plf:Show()
  m:InF1()
  self.RMI = 9000
  m:SwO(-1, true)
  m:UpA()
  m.Gui = Map.Gui:Cre(m)
  self.MMF = getglobal("Minimap")
  assert(self.MMF)
  m:MOI()
  local function fun(self)
      if not Nx.IBG then
          self:GoP()
      end
  end
  Nx.Tim:Sta("MapIShow" .. m.MaI3, 1, m, fun)
  return m
end
function Nx.Win:OMW(val1)
  if not IsShiftKeyDown() then
      return
  end
  if not (IsControlKeyDown() or IsAltKeyDown()) then
      return
  end
  local win = this.NxW
  local f = win.Frm
  val1 = val1 > 0 and 1 or -1
  local cx, cy = GetCursorPosition()
  cx = cx / UIParent:GetEffectiveScale()
  cy = GetScreenHeight() - cy / UIParent:GetEffectiveScale()
  local s = f:GetScale()
  local top = GetScreenHeight() - f:GetTop() * s
  local lef = f:GetLeft() * s
  new = max(s + val1 * .025, .5)
  if IsAltKeyDown() then
      new = 1
  end
  local x = ((lef - cx) * new / s + cx) / new
  local y = ((top - cy) * new / s + cy) / new
  f:SetScale(new)
  f:ClearAllPoints()
  f:SetPoint("TOPLEFT", x, -y)
  win:Adj()
  win:RLD()
end
function Nx.Soc:ALP(nam, plN1, lev, cla)
  if Nx.IBG and not plN1 then
      return
  end
  local map = Nx.Map:GeM(1)
  nam = strmatch(nam, "[^-]+")
  self.LLP = nam
  local rMI = map.RMI
  local x, y = map.PRZX, map.PRZY
  if plN1 then
      plN1 = strmatch(plN1, "[^-]+")
      local i = Nx.GrM[plN1]
      if i then
          local uni = Nx.GrT .. i
          local s = UnitName(uni)
          if s then
              local pX, pY = GetPlayerMapPosition(uni)
              if pX ~= 0 or pY ~= 0 then
                  x = pX * 100
                  y = pY * 100
              end
          end
      end
  end
  local pun1 = self:GeP1(nam, plN1, rMI, x, y)
  if not pun1.Tim1 and not Nx.IBG and self.GOp["PunkNewLocalWarnChat"] then
      if not Nx.InS1 or self.GOp["PunkShowInSafeArea"] then
          local typ = self.Pun[nam] and "|cffff4040Punk" or "Enemy"
          Nx.prt("%s %s detected near you", typ, nam)
          if self.GOp["PunkNewLocalWarnSnd"] then
              Nx:PlaySoundFile("sound\\doodad\\belltolltribal.wav")
          end
      end
  end
  pun1.FiN1 = "me"
  pun1.Lvl = lev or pun1.Lvl or 0
  pun1.Cla = cla or pun1.Cla
  if not pun1.Tim1 or GetTime() - pun1.Tim1 > 2 then
      pun1.Tim1 = GetTime()
  end
  if not Nx.Tim:IsA("SocialUpdate") then
      Nx.Tim:Sta("SocialUpdate", 2, self, self.OUT)
  end
  self.PHUD:Add(nam)
end
function Nx.War:CID()
  Nx.Tim:Sta("WarehouseDur", 3, self, self.CIDT)
end
function Nx.Map:GSN(maI)
  return Nx.Map.MWI[maI].Sho
end
function Nx.Soc:OTB(ind, cli, iST)
  if self.IOTB then
      return
  end
  self.TaS1 = ind
  if not self.Win1:IsShown() then
      return
  end
  self.IOTB = true
  local lis = self.Lis.Lis
  local ff = FriendsFrame
  local tbH = Nx.TaB:GetHeight()
  if ff:GetParent() ~= self.FFH then
      local ffH = self.FFH
      ff:SetToplevel(false)
      ff:SetParent(ffH)
      ff:SetPoint("TOPLEFT", ffH, "TOPLEFT", 0, 0)
      self:SBT2(false)
  end
  if ind < self.OTI then
      self.FFH:Hide()
      lis.Frm:Show()
  else
      lis.Frm:Hide()
      self.FFH:Show()
      ff:Show()
  end
  self.Lis:Upd()
  self.IOTB = false
end
function Nx.Map.Gui:Bac()
  if #self.PaH > 1 then
      tremove(self.PaH)
  end
  self:Upd()
  self:SeL2()
end
function Nx:CCW(id)
  local map = Nx.Map:GeM(1)
  map:ClT1()
end
function Nx.Que:SBQD()
  self.SBMI = 1001
  Nx.Tim:Sta("QScanBlizz", .9, self, self.SBQDT)
end
function Nx.UEv:AdO(typ, nam)
  local maI = self:AdI(nam)
  local maI, x, y = self:GPP()
  Nx:Gat("Misc", typ, maI, x, y)
  self:UpA()
end
function Nx.Map:Pin()
  local frm = self.Frm
  local mx, my = Nx.U_GMCXY(frm)
  local top = frm:GetTop()
  local bot = frm:GetBottom()
  my = top - (my + bot)
  local mm = self.MMF
  local sca1 = self.MMS
  local inf = self.MWI[self.MaI]
  if inf.Cit and not inf.MMO then
      sca1 = self.MMSC
  end
  local zoo = mm:GetZoom() + 1
  local wx, wy = self:FPTWP(mx, my)
  local sc = sca1[zoo] / mm:GetWidth()
  local x = wx - self.PlX
  local y = self.PlY - wy
  mm:PingLocation(x / sc, y / sc)
end
function Nx:GICH1()
  Nx:GIC1("Herbalism")
end
function Nx.Opt:Ini()
  self.ChA = {"TopLeft", "Top", "TopRight", "Left", "Center", "Right", "BottomLeft", "Bottom", "BottomRight"}
  self.CA0 = {"None", "TopLeft", "Top", "TopRight", "Left", "Center", "Right", "BottomLeft", "Bottom", "BottomRight"}
  self.ChC = {"TopLeft", "TopRight", "BottomLeft", "BottomRight"}
  self.CQA = {"Solid", "SolidTexture", "HGrad"}
  self.CQAT = {
      ["SolidTexture"] = "Interface\\Buttons\\White8x8",
      ["HGrad"] = "Interface\\AddOns\\Carbonite\\Gfx\\Map\\AreaGrad"
  }
  self:Res(true)
  self:UpC1()
  Nx.Tim:Sta("OptsInit", .5, self, self.InT)
end
function Nx.ToB:AdB(typ, nam, ind, fun, pre2)
  local too = {}
  tinsert(self.Too, too)
  too.Nam = nam
  too.Fun = fun
  local but1 = Nx.But:Cre(self.Frm, typ, nil, nam, 0, 0, "TOPLEFT", 1, 1, self.OnB, self)
  too.But2 = but1
  but1:SeI(fun)
  but1:SeP2(pre2)
end
function Nx.Map:M_OQD(ite)
  Nx.Que.Debug = ite:GetChecked()
end
function Nx.pSH(msg, str)
  local prt = Nx.prt
  prt(msg .. ":")
  for n = 1, #str, 4 do
      local s = ""
      for n2 = n, min(#str, n + 3) do
          s = s .. format(" %x", strbyte(str, n2))
      end
      prt(s)
  end
end
function Nx.Com:OLT()
  if UnitOnTaxi("player") then
      local id = GetChannelName(1)
      if id ~= 1 then
          self.WOT = true
          return .5
      end
  end
  if self.WOT then
      self.WOT = nil
      return 3
  end
  local opt = Nx:GGO()
  if IsControlKeyDown() and IsAltKeyDown() then
      Nx.prt("Disabling com functions!")
      opt["ComNoGlobal"] = true
      opt["ComNoZone"] = true
  end
  local nee = 2
  if opt["ComNoGlobal"] then
      nee = 1
  end
  if opt["ComNoZone"] then
      nee = nee - 1
  end
  local fre = max(10 - self:GCC(), 0)
  if nee > fre then
      Nx.prt("|cffff9f5fNeed %d chat channel(s)!", nee - fre)
      Nx.prt("|cffff9f5fThis will disable some communication features")
      Nx.prt("|cffff9f5fYou may free channels using the chat tab")
  end
  self:ScC()
  self:UpC2()
  self:JoC("A")
end
function Nx.Map:SIUD(ico, dat)
  ico.UDa = dat
end
function Nx.Map:GeI1(leA)
  local frm1 = self.IcF
  local pos1 = frm1.Nex
  if pos1 > 1500 then
      pos1 = 1500
  end
  local f = frm1[pos1]
  if not f then
      f = CreateFrame("Frame", "NxIcon" .. pos1, self.Frm)
      frm1[pos1] = f
      f.NxM1 = self
      f:SetScript("OnMouseDown", self.IOMD)
      f:SetScript("OnMouseUp", self.IOMU)
      f:SetScript("OnEnter", self.IOE)
      f:SetScript("OnLeave", self.IOL)
      f:SetScript("OnHide", self.IOL)
      f:EnableMouse(true)
      local t = f:CreateTexture()
      f.tex = t
      t:SetAllPoints(f)
  end
  f:SetFrameLevel(self.Lev + (leA or 0))
  f.tex:SetVertexColor(1, 1, 1, 1)
  f.NxT = nil
  f.NXType = nil
  f.NXData = nil
  f.NXData2 = nil
  frm1.Nex = pos1 + 1
  return f
end
function Nx.ToB:SeU(use, fun)
  self.Use = use
  self.UsF = fun
end
function Nx.UEv.Lis:Ope()
  local UEv = Nx.UEv
  local win = self.Win1
  if win then
      if win:IsShown() then
          win:Show(false)
      else
          win:Show()
      end
      return
  end
  local win = Nx.Win:Cre("NxEventsList", nil, nil, nil, nil, nil, true)
  self.Win1 = win
  win:CrB(true)
  win:ILD(nil, -.75, -.6, -.25, -.1)
  local lis = Nx.Lis:Cre("Events", 2, -2, 100, 12 * 3, win.Frm)
  self.Lis = lis
  lis:CoA("Time", 1, 70)
  lis:CoA("Event", 2, 140)
  lis:CoA("#", 3, 30, "CENTER")
  lis:CoA("Position", 4, 500)
  win:Att(lis.Frm, 0, 1, 0, 1)
  UEv:UpA()
end
function Nx:GGO()
  return NxData.NXGOpts
end
function Nx.Fav:IM_OSI()
  Nx.DrD:Sta(self, self.SIA)
  for i, nam in ipairs(self.NoI) do
      local icS = self:GII(i)
      local s = format("%s %s", icS, nam)
      Nx.DrD:Add(s, false)
  end
  Nx.DrD:Show(self.Win1.Frm)
end
function Nx.Map:BGM_OA(ite)
  self:BGM_S("Attack")
end
function Nx.Lis:CrS()
  local f = self.Frm
  local hdH = self.HdH
  local liH = self:GLH()
  local wid = f:GetWidth()
  local paW = 1
  local paH = 0
  local x = 0
  local stN = 1
  for k, col3 in ipairs(self.Col) do
      local coW = col3.ClW
      local ofX = 0
      local ofY = 0
      for n = 1, self.Vis do
          local fst = self.Str[stN]
          if not fst then
              fst = f:CreateFontString()
              self.Str[stN] = fst
          end
          fst:SetFontObject(col3.FoO)
          fst:SetJustifyH(col3.JuH)
          if self.Off then
              local lin1 = self.Top + n - 1
              ofX = self.Off[lin1] or 0
              ofY = self.Off[-lin1] or 0
          end
          fst:SetPoint("TOPLEFT", paW + x + ofX, -(n - 1) * liH - hdH - paH - ofY)
          if not self.ShA then
              fst:SetWidth(coW - ofX)
          end
          fst:SetHeight(liH)
          fst:Show()
          stN = stN + 1
      end
      x = x + col3.Wid
  end
  for n = stN, #self.Str do
      self.Str[n]:Hide()
  end
end
function Nx.Que:UnN(inf)
  local sb = strbyte
  local i = sb(inf, 1) - 35 + 1
  return (sb(inf, i + 4) - 35) * 48841 + (sb(inf, i + 5) - 35) * 221 + sb(inf, i + 6) - 35
end
function Nx.Map:BGM_OS(ite)
  local id, x, y, str = strsplit("~", self.BGM)
  if id == "1" then
      self:BGM_S()
  else
      Nx.prt("No Status")
  end
end
function Nx.Lis:CSN(coI, nam)
  local coI1 = coI or 1
  local col3 = self.Col[coI1]
  col3.Nam = nam
  local fst = col3.FSt
  if fst then
      if self.SCI == coI then
          nam = ">" .. nam
      end
      fst:SetText(nam)
      fst:SetTextColor(.8, .8, 1, 1)
      self.SSW = nil
  end
end
function Nx.War.OG_1()
  local self = Nx.War
  if self.Ena then
      self:GuR(true)
  end
end
function Nx.Lis:NUF()
  if self.Lis1 then
      for ins in pairs(self.Lis1) do
          ins.SSW = nil
      end
  end
end
function Nx.Map.Gui:GST(prN)
  return " Trainer"
end
function Nx.OP__3()
  local self = Nx
  local mem = {}
  self.GrM = mem
  local meC = MAX_PARTY_MEMBERS
  local unN = "party"
  if GetNumRaidMembers() > 0 then
      meC = MAX_RAID_MEMBERS
      unN = "raid"
  end
  self.GrT = unN
  for n = 1, meC do
      local uni = unN .. n
      local nam = UnitName(uni)
      if nam then
          mem[nam] = n
      end
  end
  Nx.Que.OP__3()
end
function Nx.War:M_ORC(ite)
  if self.SeG then
      self:GuD1(self.SeG)
      self.SeG = false
  else
      local cn = self.SeC2
      local rc = Nx.ReC1[cn]
      if cn > 1 and rc then
          tremove(Nx.ReC1, cn)
          NxData.Characters[rc] = nil
          self.SeC2 = 1
      end
  end
  self:Upd()
end
function Nx.Tim:Fir(nam)
  local tm = self.Dat[nam]
  if tm then
      if tm.F then
          tm.T = tm.F(tm.U, nam, tm)
      end
      if not tm.T then
          self.Dat[nam] = nil
      end
  end
end
function Nx.Tim:Sto(nam)
  self.Dat[nam] = nil
end
function Nx:CAW(not2)
  local map = Nx.Map:GeM(1)
  local maI = Nx.MNTI1[not2["z"]]
  local con1, zon
  if maI then
      con1, zon = map:ITCZ(maI)
  end
  local id = Nx:TTSTCZXY(con1, zon, not2["x"] * 100, not2["y"] * 100, not2["n"])
  not2["WaypointID"] = id
end
function Nx.Opt:NXCmdCamForceMaxDist()
  if self.Opt["CameraForceMaxDist"] then
      SetCVar("cameraDistanceMaxFactor", 3.4)
  end
end
function Nx.Win:M_OT(ite)
  local tra = ite:GeS1()
  local svd = self.MeW.SaD
  svd[self.MeW.LaM .. "T"] = tra < 1 and tra or nil
  local f = self.MeW.Frm
  f:SetAlpha(tra)
end
function Nx.Que:CaD3(n1, n2)
  local Nx = Nx
  local Que = Nx.Que
  local qop = Nx:GQO()
  local Map = Nx.Map
  local map = Map:GeM(1)
  local px = map.PlX
  local py = map.PlY
  local plL2 = UnitLevel("player")
  local cur1 = self.CuQ
  if not cur1 then
      return
  end
  for n = n1, n2 do
      local cur = cur1[n]
      if not cur then
          break
      end
      local qi = cur.QI
      local qId = cur.QId
      local id = qId > 0 and qId or cur.Tit
      local qSt = Nx:GeQ(id)
      local qWa = (qSt == "W")
      local que = cur.Q
      cur.Pri = 1
      cur.Dis1 = 999999999
      cur.COI = -1
      if que then
          local cnt = (cur.CoM or cur.LBC == 0) and 0 or 99
          for qOb = 0, cnt do
              local quO1
              if qOb == 0 then
                  quO1 = (qi > 0 or cur.Par) and que[3] or que[2]
              else
                  quO1 = que[qOb + 3]
              end
              if not quO1 then
                  break
              end
              if bit.band(cur.TrM2, bit.lshift(1, qOb)) > 0 then
                  local nam, zon = self:GOP(que, quO1)
                  if zon then
                      local mId = Map.NTMI[zon]
                      if mId then
                          local x, y = self:GCOP(quO1, mId, px, py)
                          local dis = ((x - px) ^ 2 + (y - py) ^ 2) ^ .5
                          if dis < cur.Dis1 then
                              cur.COI = qOb
                              cur.Dis1 = dis
                          end
                          cur["OX" .. qOb] = x
                          cur["OY" .. qOb] = y
                          cur["OD" .. qOb] = dis
                      end
                  end
              end
          end
          local pri1 = 0
          if cur.CoM then
              pri1 = qop.NXWPriComplete * 8
          else
              local l = min(plL2 - cur.Lev, 10)
              l = max(l, -10)
              pri1 = l * qop.NXWPriLevel
          end
          cur.Pri = 1 - pri1 / 2010
          cur.InZ = Que:ChS(map.RMI, qId)
      end
  end
end
function Nx.Que:GOR(que, str)
  local Que = Nx.Que
  local nam, zon, loc = Que:UnO(str)
  if not zon then
      return
  end
  local x1 = 100
  local y1 = 100
  local x2 = 0
  local y2 = 0
  local cnt
  if strbyte(str, loc) == 32 then
      cnt = floor((#str - loc) / 4)
      local x, y
      for loN1 = loc + 1, loc + cnt * 4, 4 do
          x, y = Que:ULPO(str, loN1)
          x1 = min(x1, x)
          y1 = min(y1, y)
          x2 = max(x2, x)
          y2 = max(y2, y)
      end
  elseif strbyte(str, loc) == 33 then
      x1, y1 = Que:ULPR(str, loc + 1)
      x2, y2 = x1, y1
  else
      loc = loc - 1
      cnt = floor((#str - loc) / 4)
      for loN1 = loc + 1, loc + cnt * 4, 4 do
          local lo1 = strsub(str, loN1, loN1 + 3)
          local x, y, w, h = Que:ULR(lo1)
          x1 = min(x1, x)
          y1 = min(y1, y)
          x2 = max(x2, x + w / 1002 * 100)
          y2 = max(y2, y + h / 668 * 100)
      end
  end
  return x1, y1, x2, y2
end
function Nx.Que.Lis:ToW(qId, qIn, qOb, shi)
  local Que = Nx.Que
  local Map = Nx.Map
  if qOb == 0 and not shi then
      local i, cur, id = Que:FiC3(qId, qIn)
      if cur then
          local qSt = Nx:GeQ(id)
          if qSt == "W" then
              Nx.Que.Wat:ReW(qId, qIn)
          else
              Nx:SeQ(id, "W")
          end
          Que:PSS()
      end
  else
      if qId > 0 and qOb > 0 then
          if shi and qOb == 0 or qOb > 0 then
              local tbi = Que.Tra1[qId] or 0
              if qOb == 0 then
                  if bit.band(tbi, 1) > 0 then
                      Que.Tra1[qId] = nil
                  else
                      Que.Tra1[qId] = 0xffffffff
                  end
              else
                  Que.Tra1[qId] = bit.bxor(tbi, bit.lshift(1, qOb))
              end
              self:Upd()
          end
          local maI = Map:GCMI()
          Que:TOM(qId, qOb, qIn > 0, true)
          Map:SCM1(maI)
      end
  end
  self:Upd()
end
function Nx.Fon:GeI(nam)
  for k, v in ipairs(self.Fac) do
      if v[1] == nam then
          return k
      end
  end
  return 1
end
function Nx.Lis:Emp()
  self.Num = 0
  self.Dat = wipe(self.Dat or {})
  for k, col3 in pairs(self.Col) do
      col3.Dat = col3.Dat and wipe(col3.Dat)
  end
  if self.BuD then
      wipe(self.BuD)
  end
  if self.Off then
      wipe(self.Off)
  end
  if self.FrD then
      wipe(self.FrD)
  end
  Nx.Lis:FrF(self)
  self.Sor = false
end
function Nx.Inf:OpM(inf)
  self.CMI = inf
  self.MIT1:SetText(format("-- Info %d --", inf.Ind))
  self.MIE:SetText(inf.Edi and "Stop Edit" or "Edit View")
  for n = 1, 10 do
      local inf = self.Inf1[n]
      local b = inf and inf.Dat and not self.Inf1[n].Win1:IsShown()
      self.MIS3[n]:Show(b == true)
  end
  self.Men:Ope()
end
function Nx.Fav:GII(ind)
  local fil = "Interface\\TargetingFrame\\UI-RaidTargetingIcon_" .. ind
  return format("|T%s:16|t", fil)
end
function Nx:CARW(maN, yx, nam)
  local map = Nx.Map:GeM(1)
  local maI = Nx.MNTI1[maN]
  local con1, zon
  if maI then
      con1, zon = map:ITCZ(maI)
  end
  local zx = (yx % 10001) / 100
  local zy = floor(yx / 10001) / 100
  Nx:TTSTCZXY(con1, zon, zx, zy, nam)
end
function Nx.Sli:SeU(use, fun)
  self.Use = use
  self.UsF = fun
end
function Nx.U_TCR(t)
  local tc = {}
  for k, v in pairs(t) do
      if type(v) == "table" then
          tc[k] = Nx.U_TCR(v)
      else
          tc[k] = v
      end
  end
  return tc
end
function Nx.Lis:IGN()
  return self.Num
end
function Nx.Com1:Ini()
  self.KBs = 0
  self.Dea = 0
  self.HKs = 0
  self.Hon = 0
  self.DaD = 0
  self.HeD = 0
  local o = NxCombatOpts
  o.FrX = nil
  o.FrY = nil
  o.Ope1 = nil
  o.NXOpened = nil
  self.Frm = nil
  self.HiP = 1
  self.HiT = 0
  self.HiB = 0
  self.W = 400
  self.H = 80
  self.InC = false
  self.AtN = "?"
end
function Nx:AIE(nam, time, maI, x, y)
  self:AdE("Info", nam, time, maI, x, y)
end
function Nx.Win:SeS1(on)
  self.Siz = on
end
function Nx.UEv:Sor1()
  local et = Nx:GAE()
  self.Sor = {}
  local t = self.Sor
  local i = 1
  for k, v in ipairs(et) do
      t[i] = v
      i = i + 1
  end
  sort(self.Sor, self.SoC)
end
function Nx.Win:CSD(nam)
  local wd = Nx:GeD("Win")
  wd[nam] = nil
end
function Nx:AME(nam, time, maI, x, y)
  self:AdE("Mine", nam, time, maI, x, y)
end
function Nx.Inf:CTHP()
  if self.Var["TName"] then
      self.Var["THealth%"] = self.Var["THealth"] / self.Var["THealthMax"]
      return "|cffe0e0e0", format("%d", self.Var["THealth%"] * 100)
  end
end
function Nx.Map.Gui:SPNPCT()
  local npN = UnitName("NPC") or "?"
  self.PNPCT = "?~" .. npN
  for n, str in ipairs(self.PlT) do
      local tag, nam = strsplit("~", str)
      if npN == nam then
          self.PNPCT = str
          break
      end
  end
  local map = Nx.Map:GeM(1)
  local s = Nx:CMXY(map.PRZX, map.PRZY)
  self.PNPCTP = format("%d^%s", Nx.MITN1[map.RMI] or 0, s)
end
function Nx.Hel.Dem:NXOpenHelp()
  Nx.Hel:Ope()
end
function Nx.NXMapKeyTargetSkip()
  local self = Nx.Map:GeM(1)
  local tar1 = self.Tar[1]
  if tar1 then
      tar1.Rad = 999999999999
  end
end
function Nx.Que:GFP(plN)
  Nx.SMT()
  self.Lis.Bar:Sel1(4)
  self.FrQ = {}
  self.RcP = plN
  self.RPL = plN
  Nx.Com:Sen("W", "Q*", plN)
end
function Nx.Gra:UpF()
  self:ReF()
  for n = 1, self.Val.Nex - 1 do
      self:UpL(n)
  end
end
function Nx.Inf:M_ON(ite)
  self:New()
end
function Nx.Map.Gui:PaF(fol, par)
  local tra1
  if fol.Nam == "Trainer" and fol.Pre1 then
      tra1 = true
  end
  if fol.Pre1 and fol.Nam then
      fol.Nam = fol.Pre1 .. fol.Nam
      fol.Nam = strtrim(gsub(fol.Nam, "%u", " %1"), " ")
  end
  if par and par.Pre1 and fol.T then
      fol.T = par.Pre1 .. fol.T
  end
  if not fol.Nam and fol.T then
      local nam = strsplit("^", fol.T)
      fol.Nam = strtrim(gsub(nam, "%u", " %1"), " ")
  end
  if fol.Nam then
      fol.Nam = gsub(fol.Nam, " Trainer", "")
  end
  if not fol.Tx then
      fol.Tx = par.Tx
  end
  if not tra1 then
      for shT, chi in ipairs(fol) do
          if type(chi) == "table" then
              self:PaF(chi, fol)
          end
      end
  end
  if fol.Nam == "Travel" then
      local txT = {
          ["Boat"] = "Spell_Shadow_DemonBreath",
          ["Portal"] = "INV_Misc_QuestionMark",
          ["Tram"] = "INV_Misc_MissileSmall_White",
          ["Zeppelin"] = "INV_Misc_MissileSmall_Red"
      }
      local poT1 = {
          ["Blasted Lands"] = "Achievement_Zone_BlastedLands_01",
          ["Darnassus"] = "Spell_Arcane_TeleportDarnassus",
          ["Exodar"] = "Spell_Arcane_TeleportExodar",
          ["Hellfire Peninsula"] = "Achievement_Zone_HellfirePeninsula_01",
          ["Ironforge"] = "Spell_Arcane_TeleportIronForge",
          ["Isle of Quel'Danas"] = "Achievement_Zone_IsleOfQuelDanas",
          ["Lake Wintergrasp"] = "Ability_WIntergrasp_rank1",
          ["Orgrimmar"] = "Spell_Arcane_TeleportOrgrimmar",
          ["Shattrath"] = "Spell_Arcane_TeleportShattrath",
          ["Silvermoon"] = "Spell_Arcane_TeleportSilvermoon",
          ["Stormwind"] = "Spell_Arcane_TeleportStormWind",
          ["Thunder Bluff"] = "Spell_Arcane_TeleportThunderBluff",
          ["Undercity"] = "Spell_Arcane_TeleportUnderCity"
      }
      for i, str in ipairs(Nx.ZoC) do
          local fla, coT, mI1, x1, y1, mI2, x2, y2, na11, na21 = Nx.Map:CoU(str)
          if coT ~= 1 then
              local fac2 = bit.band(fla, 6) / 2
              local faS = fac2 == 1 and "^FA" or fac2 == 2 and "^FH" or ""
              if #na11 > 0 then
                  local f = {}
                  tinsert(fol, f)
                  f.Nam = format("%s", na11)
                  f.Fac1 = fac2
                  f.MaI = mI1
                  f.CoI1 = i
                  f.T = "*" .. i .. faS
                  local typ, loN2 = strmatch(na11, "(%S+) to (.+)")
                  f.Tx = typ == "Portal" and poT1[loN2] or txT[typ]
              end
              if #na21 > 0 and bit.band(fla, 1) ~= 0 then
                  local f = {}
                  tinsert(fol, f)
                  f.Nam = format("%s", na21)
                  f.Fac1 = fac2
                  f.MaI = mI2
                  f.CoI1 = i
                  f.Co2 = true
                  f.T = "*b" .. i .. faS
                  local typ, loN2 = strmatch(na21, "(%S+) to (.+)")
                  f.Tx = typ == "Portal" and poT1[loN2] or txT[typ]
              end
          end
      end
      sort(fol, function(a, b)
          return a.Nam < b.Nam
      end)
  elseif fol.Nam == "Herb" then
      for n = 1, 499 do
          local nam, tx, ski1 = Nx:GeG("H", n)
          if not nam then
              break
          end
          local f = {}
          f.Nam = nam
          f.Co21 = format("%3d", ski1)
          f.T = "$H" .. n
          f.Tx = tx
          f.Id = n
          fol[n] = f
      end
  elseif fol.Nam == "Ore" then
      for n = 1, 499 do
          local nam, tx, ski1 = Nx:GeG("M", n)
          if not nam then
              break
          end
          local f = {}
          f.Nam = nam
          f.Co21 = format("%3d", ski1)
          f.T = "$M" .. (n + 500)
          f.Tx = tx
          f.Id = n
          fol[n] = f
      end
  elseif fol.Map then
      if fol.Map == 4 and not Nx.V30 then
          par[5] = nil
          return
      end
      local Map = Nx.Map
      local co1 = fol.Map
      local co2 = co1
      if co1 == 0 then
          co1 = 1
          co2 = Map.CoC
      end
      for con1 = co1, co2 do
          local inf = Map.MaI2[con1]
          for id = inf.Min1, inf.Max1 do
              if Nx.V30 or id ~= 2030 then
                  local f = {}
                  local col, inS, miL = Map:GMND(id)
                  local nam = Map:ITN(id)
                  f.Nam = format("%s%s", col, nam)
                  f.Co21 = inS
                  local fis = Map.MWI[id].Fis
                  if fis then
                      f.Co3 = format("Fish %s, %s", max(1, fis - 95), fis)
                  end
                  f.T = "#Map" .. id
                  f.Tx = par.Tx
                  f.MId = id
                  f.SrN = nam
                  f.Srt = miL
                  tinsert(fol, f)
              end
          end
      end
      if fol.Map == 0 then
          sort(fol, function(a, b)
              if a.Srt == b.Srt then
                  return a.SrN < b.SrN
              else
                  return a.Srt < b.Srt
              end
          end)
      else
          sort(fol, function(a, b)
              return a.SrN < b.SrN
          end)
      end
  elseif fol.Ins then
      local fco = fol.Ins
      local n = 1
      for nxi, v in ipairs(Nx.Zon1) do
          local lon, miL, maL1, fac1, typ, own, pos1, nuP = strsplit("!", v)
          if fac1 == "3" then
              local maI = Nx.Map.NTMI[nxi]
              if maI then
                  local con1 = Nx.Map:ITCZ(maI)
                  if con1 == fco then
                      if nxi == 16 then
                          Nx.prt("%s [%s] %s", lon, nxi, v)
                      end
                      local f = {}
                      local nPS = nuP
                      if tonumber(nuP) == 1025 then
                          nPS = "10/25"
                      end
                      local plS1 = format("|cffff4040 %s-Man", nPS)
                      f.Nam = format("%s %s", lon, plS1)
                      if miL ~= "0" then
                          if miL == maL1 then
                              f.Co21 = format("%d", miL)
                          else
                              f.Co21 = format("%d-%d", miL, maL1)
                          end
                      end
                      f.T = "%In" .. nxi
                      f.IMI = maI
                      local owN = strsplit("!", Nx.Zon1[tonumber(own)])
                      local x, y = Nx.Que:ULPO(pos1, 1)
                      f.InT2 = format("%s |cffe0e040Lvl %s\n|r%s (%.1f %.1f)", f.Nam, f.Co21, owN, x, y)
                      f.Tx = par.Tx
                      fol[n] = f
                      n = n + 1
                  end
              end
          end
      end
  end
end
function Nx.Map:CIM1(frm)
  local men = Nx.Men:Cre(frm)
  self.GIM = men
  self.GIMITI = men:AdI1(0, "Toggle Instance Map", self.GM_OTI, self)
  self.GIMIFN = men:AdI1(0, "Find Note", self.GM_OFN, self)
  Nx.Que:CGIM(men, frm)
  men:AdI1(0, "Goto", self.GM_OG, self)
  men:AdI1(0, "Clear Goto", self.M_OCG, self)
  men:AdI1(0, "Paste Link", self.GM_OPL, self)
  men:AdI1(0, "Add Note", self.M_OAN, self)
end
function Nx.Sli:OnU(ela)
  local self = this.NxI
  self:Dra()
  if self.NeU then
      self.NeU = false
      self:DoU()
  end
end
function Nx.Map:OBZO()
  self:SSOT(-2)
end
function Nx.Fon:GeF1(nam)
  for k, v in ipairs(self.Fac) do
      if v[1] == nam then
          return v[2]
      end
  end
  return self.Fac[2][2]
end
function Nx.Opt:NXCmdMMChange()
  local map = Nx.Map:GeM(1)
  map:MNGI(true)
end
function Nx.Gra:OnL(mot)
  if GameTooltip:IsOwned(this) then
      GameTooltip:Hide()
  end
end
function Nx.Que.Wat:ReW(qId, qI)
  local i, cur, id = Nx.Que:FiC3(qId, qI)
  if i then
      local qSt, qTi = Nx:GeQ(id)
      if qSt == "W" then
          Nx:SeQ(id, "c", qTi)
          Nx.Que:PSS()
          if qId > 0 then
              Nx.Que.Tra1[qId] = nil
              if Nx.Que:IsT(qId) then
                  Nx.Que.Map:ClT1()
              end
          end
      end
      if IsQuestWatched(qI) then
          RemoveQuestWatch(qI)
      end
  end
end
function Nx.Map.Gui.OM_()
  local self = Nx.Map.Gui
  self:SPNPCT()
  self.VeR = CanMerchantRepair()
  self:CNPC(format("M%s", self.VeR and 1 or 0))
  self.CaC4 = true
  self.OM_1()
end
function Nx.Men:SeS4()
  local f = self.MaF
  local bk = Nx.Ski:GetBackdrop()
  f:SetBackdrop(bk)
  local col2 = Nx.Ski:GBGC()
  f:SetBackdropColor(col2[1], col2[2], col2[3], col2[4])
  local col2 = Nx.Ski:GBC()
  f:SetBackdropBorderColor(col2[1], col2[2], col2[3], col2[4])
end
function Nx.Map.Gui:ItI()
  self.IBT = {"", "Binds when picked up\n", "Binds when equipped\n", "Binds when used\n"}
  self.IHT = {"One-Hand", "Main Hand", "Off Hand"}
  self.IDT = {"Damage", "Holy Damage", "Fire Damage", "Nature Damage", "Frost Damage", "Shadow Damage",
              "Arcane Damage"}
  self.ITT = {"Use: ", "Equip: ", "Chance on hit: ", "", "", "", "Use: "}
  local fol = self:FiF("Items")
  assert(fol)
  for n, dat in pairs(self.ItC) do
      fol[n] = dat
  end
  self.ItC = nil
end
function Nx.Map.Gui:FiT2(caN)
  local eCN = caN
  for k, nam in pairs(NXlTaxiNames) do
      if nam == caN then
          eCN = k
          break
      end
  end
  if eCN == "Hellfire Peninsula" then
      caN = "The Dark Portal"
  end
  local Map = Nx.Map
  local Que = Nx.Que
  local hiF = UnitFactionGroup("player") == "Horde" and 1 or 2
  for con1 = 1, Map.CoC do
      local daS = Nx.GuD["Flight Master"][con1]
      for n = 1, #daS, 2 do
          local npI = (strbyte(daS, n) - 35) * 221 + (strbyte(daS, n + 1) - 35)
          local npS = Nx.NPCD[npI]
          local fac2 = strbyte(npS, 1) - 35
          if fac2 ~= hiF then
              local oSt = strsub(npS, 2)
              local des1, zon, loc = Que:UnO(oSt)
              local nam, cam = strsplit("!", des1)
              cam = NXlTaxiNames[cam] or cam
              if cam == caN then
                  if strbyte(oSt, loc) == 32 then
                      local maI = Map.NTMI[zon]
                      local x, y = Que:ULPO(oSt, loc + 1)
                      local wx, wy = Map:GWP(maI, x, y)
                      return nam, wx, wy
                  else
                      assert(0)
                  end
              end
          end
      end
  end
end
function Nx.Fav:TS_()
  if not self.Win1 then
      self:Cre()
  end
  self.Win1:Show(not self.Win1:IsShown())
  if self.Win1:IsShown() then
      self:Upd()
  end
end
function Nx.Tra:Ini()
  local gop = Nx.GGO()
  self.GOp = gop
  self.OTTN = TakeTaxiNode
  TakeTaxiNode = self.TakeTaxiNode
  local tr = {}
  self.Tra = tr
  for n = 1, 4 do
      tr[n] = {}
      self:Add("Flight Master", n)
  end
  self.CFN = GetSpellInfo(54197) or ""
end
function Nx.Map.Gui:IUS(sta4)
  if #sta4 == 0 then
      return ""
  end
  local sb = strbyte
  local out = ""
  local n = 1
  while n <= #sta4 do
      local typ = sb(sta4, n) - 35
      local nam, spe2 = strsplit("^", self.ISN[typ] or "?")
      local val = 0
      local len = self.ISL1[typ]
      if len == 1 then
          val = sb(sta4, n + 1) - 35
          n = n + 2
      elseif len == 2 then
          val = (sb(sta4, n + 1) - 35) * 221 + sb(sta4, n + 2) - 35 - 1000
          n = n + 3
      elseif len == 3 then
          val = ((sb(sta4, n + 1) - 35) * 48841 + (sb(sta4, n + 2) - 35) * 221 + sb(sta4, n + 3) - 35 - 1000) * .1
          n = n + 4
      elseif len == -1 then
          local daT = sb(sta4, n + 1) - 34
          local daM = (sb(sta4, n + 2) - 35) * 221 + sb(sta4, n + 3) - 35
          local daM1 = (sb(sta4, n + 4) - 35) * 221 + sb(sta4, n + 5) - 35
          if daM == daM1 then
              spe2 = gsub(spe2, " -- %%d", "")
              out = out .. format(spe2, daM, self.IDT[daT])
          else
              out = out .. format(spe2, daM, daM1, self.IDT[daT])
          end
          n = n + 6
      elseif len == -2 then
          local skT = sb(sta4, n + 1) - 35
          local ski1 = (sb(sta4, n + 2) - 35) * 221 + sb(sta4, n + 3) - 35
          out = out .. format("Requires %s (%d)\n", self.ISRS[skT], ski1)
          n = n + 4
      elseif len == -3 then
          local s = ""
          local cnt = sb(sta4, n + 1) - 35
          for n2 = 1, cnt do
              local cls = sb(sta4, n + 1 + n2) - 35
              s = s .. format("%s, ", self.ISAC[cls])
          end
          out = out .. format("Classes: %s\n", s)
          n = n + 2 + cnt
      else
          n = n + 1
      end
      if len >= 0 then
          if spe2 then
              out = out .. format(spe2, val)
          else
              out = out .. format("%+d %s\n", val, nam)
          end
      end
  end
  return out
end
function Nx.War:M_ORM(ite)
  self:Upd()
end
function Nx.Win:SetAttribute(wiN, atN, val1)
  local win = self:Fin(wiN)
  if win then
      if atN == "L" then
          win:Loc1(val1)
      elseif atN == "H" then
          win:Show(not val1)
      end
  end
end
function Nx.Map:SLT(tiS)
  local f = self.LTF
  local a = self.GOp["MapLocTipAnchor"]
  if tiS and a ~= "None" then
      local ar = self.GOp["MapLocTipAnchorRel"]
      ar = ar == "None" and a or ar
      f:ClearAllPoints()
      f:SetPoint(a, self.Frm, ar)
      local h = Nx.Fon:GeH("FontMapLoc")
      local fst1 = self.LTFS
      local i = 1
      local teW = 0
      for s in gmatch(tiS, "(%C+)") do
          local fst = fst1[i]
          fst:SetPoint("TOPLEFT", 2, 0 - (i - 1) * h)
          fst:SetText(s)
          teW = max(teW, fst:GetStringWidth())
          i = i + 1
      end
      for n = i, #fst1 do
          fst1[n]:SetText("")
      end
      f:SetWidth(4 + teW)
      f:SetHeight(2 + (i - 1) * h)
      f:Show()
  else
      f:Hide()
  end
end
function Nx.Map:M_OSPZ()
  self:GCZ()
end
function Nx.HUD:Ope()
  if not self.Cre1 then
      self:Cre()
      self.Cre1 = true
  end
  local ins = self
  ins.Win1:Show()
end
function Nx.Tim.Win1:Ope()
  if Nx.Fre then
      return
  end
  local win = self.Win1
  if win then
      if win:IsShown() then
          win:Show(false)
      else
          win:Show()
      end
      return
  end
end
function Nx.Soc:RFF()
  local ff = FriendsFrame
  if ff:GetParent() == self.FFH then
      local l = ff:GetFrameLevel(ff)
      self:SBT2()
      ff:SetParent(UIParent)
      ff:SetToplevel(true)
      ff:SetFrameLevel(l)
      ff:Raise()
      ff:Hide()
  end
end
function Nx.Win:ISM()
  return self.Siz and self.LaM == "Max"
end
function Nx.Map:M_OBAF1(ite)
  self.BAF = ite:GeS1()
end
function Nx.Tra:DCT()
  local num = NumTaxiNodes()
  if num > 0 then
      local map = Nx.Map:GeM(1)
      local mid = map:GRMI()
      local cap = NxData.TaC or {}
      NxData.TaC = cap
      local d = {}
      cap[mid] = d
      for n = 1, num do
          local nam = TaxiNodeName(n)
          local typ = TaxiNodeGetType(n)
          local x, y = TaxiNodePosition(n)
          Nx.prt("Taxi #%s %s, %s %f %f", n, nam, typ, x, y)
          tinsert(d, nam)
      end
  end
end
function Nx.Que:CrL(qId, reL, tit)
  if reL <= 0 then
      reL = -1
  end
  return format("|cffffff00|Hquest:%s:%s|h[%s]|h|r", qId, reL, tit)
end
function Nx.Tra:TFCT(srN, deN1)
  local Que = Nx.Que
  local sNPCN, x, y = Nx.Map.Gui:FiT2(srN)
  local dNPCN, x, y = Nx.Map.Gui:FiT2(deN1)
  local con4 = Nx.FlC
  for n = 1, #con4, 6 do
      local a1, a2, b1, b2, c1, c2 = strbyte(con4, n, n + 5)
      local i = (a1 - 35) * 221 + a2 - 35
      local oSt = strsub(Nx.NPCD[i], 2)
      local des1, zon, loc = Que:UnO(oSt)
      local nam = strsplit("!", des1)
      if nam == sNPCN then
          local i = (b1 - 35) * 221 + b2 - 35
          local oSt = strsub(Nx.NPCD[i], 2)
          local des1, zon, loc = Que:UnO(oSt)
          local nam = strsplit("!", des1)
          if nam == dNPCN then
              return ((c1 - 35) * 221 + c2 - 35) / 10
          end
      end
  end
  return 0
end
function Nx.HUD:Upd(map)
  local win = self.Win1
  local gop = self.GOp
  local opt = Nx:GHUDO()
  local nLD = not InCombatLockdown()
  if map.TrD and not gop["HUDHide"] and not (Nx.IBG and gop["HUDHideInBG"]) then
      local frm = self.Frm
      local but1 = self.But2
      local wfr = win.Frm
      if not wfr:IsVisible() then
          if not win:ICH() then
              win:Show()
          end
      end
      local dis = map.TDY
      local dir = (map.TrD - map.PlD) % 360
      if dis < 1 then
          dir = 0
      end
      local diD = dir <= 180 and dir or 360 - dir
      local str = map.TrN or ""
      win:SeT(str)
      if map.TrP1 and nLD then
          but1:SetAttribute("unit1", map.TrP1)
          but1:SetAttribute("shift-unit1", map.TrP1 .. "-target")
          but1:SetAttribute("unit2", map.TrP1 .. "-target")
      end
      local col2 = diD < 5 and "|cffa0a0ff" or ""
      local str = format("%s%d yds", col2, dis)
      if gop["HUDShowDir"] then
          str = format("%s %d deg", str, diD)
      end
      if map.PlS > .1 then
          self.ETAD = self.ETAD - 1
          if self.ETAD <= 0 then
              self.ETAD = 10
              local eta = map.TETA or dis / map.PlS
              if eta < 60 then
                  self.ETAS = format("|cffdfffdf %.0f secs", eta)
              else
                  self.ETAS = format("|cffdfdfdf %.1f mins", eta / 60)
              end
          end
          str = str .. self.ETAS
      else
          self.ETAD = 3
          self.ETAS = ""
      end
      win:SeT(str, 2)
      local atP, reT, reP, x, y = wfr:GetPoint()
      local w, h = win:GeS2()
      local tw = win:GTTW() + 2
      local d = (tw - w) / 2
      if strfind(atP, "LEFT") then
          x = x - d
      elseif strfind(atP, "RIGHT") then
          x = x + d
      end
      wfr:ClearAllPoints()
      wfr:SetPoint(atP, x, y)
      win:SeS(tw, 0, true)
      if gop["HUDTBut"] and not win:ICH() then
          if nLD then
              but1:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", frm:GetLeft(), frm:GetTop())
              but1:SetScale(wfr:GetScale())
              but1:Show()
              but1.tex:SetVertexColor(self.BuR, self.BuG, self.BuB, self.BuA)
          else
              but1.tex:SetVertexColor(self.BCR, self.BCG, self.BCB, self.BCA)
          end
      end
      local tX1 = -.5
      local tX2 = .5
      local tY1 = -.5
      local tY2 = .5
      local co = cos(dir)
      local si = sin(dir)
      t1x = tX1 * co + tY1 * si + .5
      t1y = tX1 * -si + tY1 * co + .5
      t2x = tX1 * co + tY2 * si + .5
      t2y = tX1 * -si + tY2 * co + .5
      t3x = tX2 * co + tY1 * si + .5
      t3y = tX2 * -si + tY1 * co + .5
      t4x = tX2 * co + tY2 * si + .5
      t4y = tX2 * -si + tY2 * co + .5
      local tex2 = frm.tex
      tex2:SetTexCoord(t1x, t1y, t2x, t2y, t3x, t3y, t4x, t4y)
      if diD < 5 then
          if dis < 1 then
              tex2:SetVertexColor(.2, 1, .2, .4)
              tex2:SetBlendMode("BLEND")
          else
              tex2:SetVertexColor(.7, .7, 1, 1)
              tex2:SetBlendMode("ADD")
          end
      else
          tex2:SetVertexColor(1, 1, .5, .9)
          tex2:SetBlendMode("BLEND")
      end
  else
      win:Show(false)
      if nLD then
          self.But2:Hide()
      end
  end
end
function Nx.War:M_OI1(ite)
  local cn = self.SeC2
  local rc = Nx.ReC1[cn]
  if cn > 1 and rc then
      local rna, sna = strsplit(".", rc)
      self.ImC = sna
      local s = format("Import %s's character data and reload?", sna)
      Nx:ShM(s, "Import", Nx.War.ImD, "Cancel")
  end
end
function Nx:FACFEB()
  return ChatEdit_GetActiveWindow()
end
function Nx.Fav:B_OID()
  local fav = self.CuF
  if fav and self.CII then
      if fav[self.CII] then
          tremove(fav, self.CII)
      end
  end
  self:Upd()
end
function Nx:GDH()
  NxData.NXGather.NXHerb = {}
end
function Nx.Map:M_ODPS1(ite)
  self.DPS1 = ite:GeS1()
end
function Nx.Opt:NXCmdSkinColor()
  Nx.Ski:Upd()
end
function Nx.Com:OBST(nam)
  local tm = GetTime()
  self.SBS1 = self.SeB / (tm - self.SBT)
  self.SeB = 0
  self.SBT = tm
  return 1
end
function Nx:CNPN(zon, x, y, nam)
  local not2 = {}
  if not y then
      y = floor(x / 10001) / 100
      x = (x % 10001) / 100
  end
  not2["z"] = zon
  not2["x"] = x
  not2["y"] = y
  not2["n"] = nam or ""
  return not2
end
function Nx.Win:SeS(wid, hei, skC)
  self.Frm:SetWidth(wid + self.BoW * 2)
  self.Frm:SetHeight(hei + self.TiH + self.BoH * 2)
  self:Adj(skC)
end
function Nx.Que.Wat:ClC1(qIM)
  local Que = Nx.Que
  self:Upd()
  local lis = self.Lis
  for ln = 1, lis:IGN() do
      local i = lis:IGD(ln)
      if i then
          local qIn = bit.band(i, 0xff)
          local qId = bit.rshift(i, 16)
          if qId > 0 and (not qIM or qIM == qId) then
              local _, cur = Que:FiC3(qId)
              if cur then
                  local qCo1 = cur.CoM
                  local qOb = bit.band(bit.rshift(i, 8), 0xff)
                  local tbi = Que.Tra1[qId] or 0
                  if tbi > 0 then
                      local obj2 = bit.lshift(1, qOb)
                      if qOb == 0 then
                          if qCo1 then
                              local qSt, qTi = Nx:GeQ(qId)
                              if qSt ~= "C" then
                                  if Nx.Que:IsT(qId) then
                                      Que.Tra1[qId] = bit.bor(tbi, obj2)
                                      Que:TOM(qId, 0, qIn > 0, true)
                                  end
                              end
                          end
                      else
                          local des1
                          local don = qCo1
                          local num = cur.LBC
                          if qOb <= num then
                              des1 = cur[qOb]
                              don = cur[qOb + 300]
                          end
                          if don then
                              local on = bit.band(tbi, obj2)
                              if on > 0 then
                                  Que.Tra1[qId] = bit.band(tbi, bit.bnot(obj2))
                                  Que:TOM(qId, qOb, qIn > 0)
                              end
                          end
                      end
                  end
              end
          end
      end
  end
end
function Nx.Map:M_OPF(ite)
  self.CuO.NXPlyrFollow = ite:GetChecked()
end
function Nx.War:CrM()
  local men = Nx.Men:Cre(self.Lis.Frm, 250)
  self.Men = men
  local ite = men:AdI1(0, "Remove Character or Guild", self.M_ORC, self)
  men:AdI1(0, "", nil, self)
  men:AdI1(0, "Import settings from selected character", self.M_OI1, self)
  men:AdI1(0, "Export current settings to all characters", self.M_OE1, self)
  men:AdI1(0, "", nil, self)
  men:AdI1(0, "Sync account transfer file", self.M_OSA1, self)
  local men = Nx.Men:Cre(self.Lis.Frm)
  self.ILM = men
  local ite = men:AdI1(0, "Show Item Headers", self.M_OSIC, self)
  ite:SetChecked(true)
  local ite = men:AdI1(0, "Sort By Rarity", self.M_OSBR, self)
  ite:SetChecked(false)
  self.NXRarityMin = 0
  local ite = men:AdI1(0, "Show Lowest Rarity", self.M_ORM, self)
  ite:SeS2(self, 0, 6, 1, "NXRarityMin")
  local ite = men:AdI1(0, "Sort By Slot", self.M_OSBS, self)
  ite:SetChecked(false)
end
function Nx.Que:FCBI(qi)
  assert(qi > 0)
  local cur1 = self.CuQ
  for n, v in ipairs(cur1) do
      if v.QI == qi then
          return n, v
      end
  end
end
function Nx.Com:MVM()
  local r = ""
  local dt = date("%y%m%d", time())
  local qCn = Nx.Que:CGC()
  local lvl = UnitLevel("player")
  return format("%f^%s^^%s^%f^%d^%x^%x", Nx.VERSION, r, dt, NxData.NXVer1, qCn, lvl, self.PMI)
end
function Nx.TaB:CrB1()
  local c2r = Nx.U_22
  local f = CreateFrame("Frame", nil, self.Frm)
  self.ToF1 = f
  f:SetPoint("TOPLEFT", 0, 0)
  f:SetPoint("TOPRIGHT", 0, 0)
  f:SetHeight(4)
  local t = f:CreateTexture()
  t:SetTexture(c2r("505050ff"))
  t:SetAllPoints(f)
  f.tex = t
  f:Show()
end
function Nx.Que:OMQ(plN, msg)
  local id = strsub(msg, 2, 2)
  if id == "*" then
      if not self.SeP4 or self.SeP4 == plN then
          Nx.prt("Sending quests to %s", plN)
          self.SeP4 = plN
          self:BQSD()
          Nx.Tim:Sta("QSendAll", 0, self, self.QSAT)
      else
          Nx.Com:Sen("W", "QB", plN)
      end
  elseif id == "C" then
      local opt = self.GOp
      if not opt["CaptureShare"] then
          Nx.Com:Sen("W", "QBs", plN)
          return
      end
      if not self.SeP4 then
          if self:BQCSD() then
              self.SeP4 = plN
              Nx.Tim:Sta("QSendAll", 0, self, self.QSAT)
          else
              Nx.Com:Sen("W", "Qc0", plN)
          end
      else
          Nx.Com:Sen("W", "QBC", plN)
      end
  elseif id == "c" then
      local pd = self.CPD[plN]
      if pd then
          local mod1 = strsub(msg, 3, 3)
          if mod1 == "1" then
              pd.RQI = tonumber(strsub(msg, 4, 8), 16) or 0
              pd.RcT = tonumber(strsub(msg, 9), 16) or 0
              pd.RcC1 = ""
          elseif mod1 == "D" then
              local dat = strsub(msg, 4)
              pd.RcC1 = pd.RcC1 .. dat
              if #pd.RcC1 >= pd.RcT then
                  pd.RcP = nil
                  if #pd.RcC1 == pd.RcT then
                      pd.RcC = pd.RcC + 1
                      Nx.prt("RCap %s %3d/%d %s #%s %s", plN, pd.RcC, pd.Tot, pd.RQI, #pd.RcC1, strsub(pd.RcC1, 1, 15))
                      local que1 = Nx:GeC()["Q"]
                      for n = 1, 999 do
                          local id = pd.RQI + n * 100000
                          if not que1[id] then
                              que1[id] = pd.RcC1
                              break
                          end
                      end
                  end
              end
          else
              Nx.prt("RCapEmpty %s (cnt %s)", pd.RcP, pd.RcC)
              pd.RPCN = nil
          end
      end
  elseif id == "B" then
      if plN == self.RcP then
          local mod1 = strsub(msg, 3, 3)
          if mod1 == "s" then
              Nx.prt(" %s -share", self.RcP)
          elseif mod1 == "C" then
              Nx.prt(" %s busy", self.RcP)
          else
              tinsert(self.FrQ, " ^Player is busy")
          end
          self.RcP = nil
          local pd = self.CPD[plN]
          if pd then
              pd.RPCN = nil
          end
      end
  elseif id == "D" then
      if plN == self.RcP then
          if #msg >= 4 then
              local dat = strsub(msg, 3)
              local mod1 = strsub(msg, 3, 3)
              if mod1 == "0" then
                  self.RcC = 0
                  self.RcT = tonumber(strsub(dat, 3)) or 0
              elseif mod1 == "H" then
                  tinsert(self.FrQ, dat)
                  self.Lis:Upd()
              elseif mod1 == "T" then
                  self.RcC = self.RcC + 1
                  tinsert(self.FrQ, dat)
                  self.Lis:Upd()
              elseif mod1 == "O" then
                  tinsert(self.FrQ, dat)
                  self.Lis:Upd()
              end
          else
              self.RcP = nil
          end
      end
  elseif id == "p" then
      self:OPM(plN, msg)
  end
end
function Nx.Com:SSG(pre, msg)
  if self.CAN then
      local num = GetChannelName(self.CAN)
      if num ~= 0 then
          local cs = self:Chk(msg)
          local str = self:Enc(format("%s%c%c%s", pre, floor(cs / 16) + 65, bit.band(cs, 15) + 65, msg))
          self:SeC(num, str)
      else
          Nx.prt("SendSecG Error: %s", pre)
      end
  end
end
function Nx.TaB:SeF1(fad2)
  local f = self.Frm
  f.tex:SetVertexColor(1, 1, 1, fad2 * .5)
  local tf = self.ToF1
  tf.tex:SetVertexColor(1, 1, 1, fad2)
  for i, tab in pairs(self.Tab1) do
      local f = tab.But2.Frm
      f.tex:SetVertexColor(1, 1, 1, fad2)
  end
end

function Nx.Map:GWZI(con1, zon)
  local nt = self.MaN[con1] or self.MaN[5]
  local nam = nt[zon] or "?"
  local inf = self.MaI2[con1]
  if not inf then
      return nam, 0, 0, 1002, 668
  end
  local id = self.CZ2I[con1][zon]
  local win1 = self.MWI[id]
  if not win1 then
      return
  end
  local x = inf.X + win1[2]
  local y = inf.Y + win1[3]
  local sca = win1[1] * 100
  return nam, x, y, sca, sca / 1.5
end
function Nx:pGCF()
  local t = {}
  for n = 1, 10 do
      local cfr = _G["ChatFrame" .. n]
      if cfr and cfr["name"] then
          tinsert(t, cfr["name"])
      end
  end
  sort(t)
  return t
end
function Nx.Map:RoG()
  local poi2 = {}
  local cnt = self:GIC2("!Ga")
  for n = 1, cnt do
      local wx, wy = self:GIP("!Ga", n)
      local x, y = self:GZP(self.MaI, wx, wy)
      local pt = {}
      tinsert(poi2, pt)
      pt.X = x
      pt.Y = y
  end
  self:RoM(poi2)
  local rou = self:Rou(poi2)
  if rou then
      self:RTT(rou, false)
  end
end
function Nx.Que:WAL()
  for n, cur in ipairs(self.CuQ) do
      local qSt = Nx:GeQ(cur.QId)
      if not qSt then
          self.Wat:Add(n)
      end
  end
end
function Nx.Win:M_OS(ite)
  local sca = ite:GeS1()
  local svd = self.MeW.SaD
  svd[self.MeW.LaM .. "S"] = sca
  local f = self.MeW.Frm
  local s = f:GetScale()
  local x = f:GetLeft() * s
  local y = GetScreenHeight() - f:GetTop() * s
  f:ClearAllPoints()
  f:SetPoint("TOPLEFT", x / sca, -y / sca)
  f:SetScale(sca)
end
function Nx.Win:GBGA()
  local m = self.BAM
  return m, m + self.BAD
end
function Nx.EdB.OEFL()
  local self = this.NxI
  if self.FiS == "" then
      this:SetText(self.FiD)
  end
end
function Nx.Que.Lis:GCS()
  local i = self.Lis:IGD()
  if i then
      local qi = bit.band(i, 0xff)
      local qid = bit.rshift(i, 16)
      if qid > 0 or qi > 0 then
          local _, cur = Nx.Que:FiC3(qid, qi)
          return cur
      end
  end
end
function Nx.Inf:Cre(ind)
  local inf = self.Inf1[ind] or {}
  self.Inf1[ind] = inf
  setmetatable(inf, self)
  self.__index = self
  inf:Cr2(ind)
end
function Nx.Que.Lis:M_OSH1(ite)
  self.QOp.NXShowHeaders = ite:GetChecked()
  Nx.Que:SoQ()
  self:Upd()
end
function Nx.Pro:SeF(pro, fun)
  pro.Fun = fun
end
function Nx:CSWHD(dis)
  local map = Nx.Map:GeM(1)
  if map.Tar[1] then
      map.Tar[1].Rad = dis
  end
end
function Nx.Map:GM_OPL()
  local nam
  if self.ClT2 == 3001 then
      nam = Nx.Soc:GPPI(self.ClI)
  else
      local ico = self.ClI
      nam = gsub(ico.Tip, "\n", ", ")
  end
  nam = gsub(nam, "|cff......", "")
  nam = gsub(nam, "|r", "")
  local frm = DEFAULT_CHAT_FRAME
  local eb = frm["editBox"]
  if eb:IsVisible() then
      eb:SetText(eb:GetText() .. nam)
  else
      Nx.prt("No edit box open!")
  end
end
function Nx.Hel.Lic:Cre()
  self.Top = 0
  Nx.Win:CSD("NxLic")
  local win = Nx.Win:Cre("NxLic", nil, nil, nil, 1, false)
  self.Win1 = win
  local frm = win.Frm
  win:ILD(nil, -.3, -.15, -.4, -.6, 3)
  frm:SetToplevel(true)
  win:SeT(Nx.TXTBLUE .. "CARBONITE " .. Nx.VERSION)
  win:SBGC(.1, .1, .1, 0)
  local bk = {
      ["bgFile"] = "Interface\\Buttons\\White8x8",
      ["edgeFile"] = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
      ["tile"] = true,
      ["tileSize"] = 16,
      ["edgeSize"] = 16,
      ["insets"] = {
          ["left"] = 2,
          ["right"] = 2,
          ["top"] = 2,
          ["bottom"] = 2
      }
  }
  frm:SetBackdrop(bk)
  frm:SetBackdropColor(.1, .1, .1, 1)
  local scf = CreateFrame("ScrollFrame", nil, UIParent)
  self.ScF = scf
  scf.NxI = self
  scf.NSS = self.OSS
  scf:SetScript("OnMouseWheel", self.OMW)
  scf:EnableMouseWheel(true)
  local f = CreateFrame("Frame", nil, UIParent)
  self.Frm = f
  f:SetPoint("TOPLEFT", 0, 0)
  f:SetWidth(1)
  f:SetHeight(1)
  local fst = f:CreateFontString()
  self.FSt = fst
  fst:SetFontObject("GameFontNormal")
  fst:SetJustifyH("LEFT")
  fst:SetPoint("TOPLEFT", 0, 0)
  f.NSS = self.OSS
  scf:SetScrollChild(f)
  self:SetText(1)
  local but2 = Nx.But:Cre(f, "Txt64", "Accept", nil, x, 0, "TOPLEFT", 64, 20, self.OBA, self)
  but2.Frm:SetPoint("TOPLEFT", self.FSt, "BOTTOMLEFT", 10, 0)
  local but3 = Nx.But:Cre(f, "Txt64", "Decline", nil, x, 0, "TOPLEFT", 64, 20, self.OBD, self)
  but3.Frm:SetPoint("TOPLEFT", but2.Frm, "TOPRIGHT", 10, 0)
  win:Att(scf, 0, 1, 0, 1)
  self.Sli = Nx.Sli:Cre(scf, "V", 10, 0)
  self.Sli:SeU(self, self.OnS)
  self.Sli:Set(0, 0, 1700, 100)
  self.Sli:Upd()
end
function Nx.Com:MoZ(maI, ena)
  local i = self.ZMo[maI]
  if ena then
      if not i or i < 0 then
          if self:GCC() >= 10 then
              Nx.prt("|cffff4040Monitor Error: All 10 chat channels are in use")
          else
              Nx.prt("|cff40ff40Monitored:")
          end
          self.ZMo[maI] = 0
          for maI, mod1 in pairs(self.ZMo) do
              if mod1 >= 0 then
                  local zs = self.ZSt[maI]
                  if zs and zs.ChN then
                      Nx.prt(" %s", Nx.MITN[maI])
                  else
                      Nx.prt(" %s (pending)", Nx.MITN[maI])
                  end
              end
          end
      end
  else
      if i and i >= 0 then
          self.ZMo[maI] = -1
      end
  end
  self:UpC2()
end
function Nx.Que.Lis:UpM2()
  local sho2 = self.MI1
  local hi1 = self.MI2
  local hi2 = self.MI3
  if self.TaS1 == 2 then
      sho2 = self.MI2
      hi1 = self.MI1
  elseif self.TaS1 == 3 then
      sho2 = self.MI3
      hi2 = self.MI1
  end
  for k, v in pairs(hi1) do
      v:Show(false)
  end
  for k, v in pairs(hi2) do
      v:Show(false)
  end
  for k, v in pairs(sho2) do
      v:Show()
  end
  if self.TaS1 == 1 then
      local show = -1
      local i = self.Lis:IGD()
      if i then
          local qi = bit.band(i, 0xff)
          if qi > 0 then
              local i, cur = Nx.Que:FCBI(qi)
              if cur then
                  if cur.CaS1 then
                      show = true
                  end
              end
          end
      end
      self.MIS4:Show(show)
  end
end
function Nx.Soc.Lis:M_OPSN()
  if self.MSN1 then
      local pun = Nx:GeS("Pk")
      local pun1 = pun[self.MSN1]
      if pun1 then
          self.MPN = self.MSN1
          local tm, lvl, cla, not2 = strsplit("~", pun1)
          Nx:SEB("Set note", not2 or "", self, self.PSN1)
      end
  end
end
function Nx.Map.Gui:Cre(map)
  self:PaD()
  local g = {}
  setmetatable(g, self)
  self.__index = self
  g.Map = map
  g.GuI1 = map.MaI3
  local opt = NxMapOpts.NXMaps[g.GuI1]
  g.TiH = 0
  g.TBW = 0
  g.PaX = 0
  g:ItI()
  g:PaF(Nx.GuI, nil)
  g.PaH = {}
  g.PaH[1] = Nx.GuI
  g.PHS = {}
  g.ShF = {}
  g.SQGC = true
  local win = Nx.Win:Cre("NxGuide" .. g.GuI1, nil, nil, nil, 1)
  g.Win1 = win
  win.Frm.NxI = g
  win:SeU(g, g.OnW)
  win:ReH()
  win:CrB(true)
  win:STLH(18)
  win:STXO(50)
  win:ILD(nil, -.15, -.2, -.63, -.5)
  win.Frm:SetToplevel(true)
  win:Show(false)
  tinsert(UISpecialFrames, win.Frm:GetName())
  local but1 = Nx.But:Cre(win.Frm, "Txt64", "Back", nil, 0, 0, "TOPLEFT", 100, 24, self.B_OB, g)
  win:Att(but1.Frm, 1.01, 1.01 + 44, -10020, -10001)
  Nx.Lis:SCF1("FontM", 28)
  local lis = Nx.Lis:Cre(false, 0, 0, 1, 1, win.Frm)
  g.Lis = lis
  lis:SeU(g, g.OLE)
  lis:SLH(16, 3)
  lis:CoA("", 1, 35)
  lis:CoA("", 2, 900)
  win:Att(lis.Frm, 0, .33, 0, 1)
  g:CrM()
  Nx.Lis:SCF1("FontM", 28)
  local lis = Nx.Lis:Cre(false, 0, 0, 1, 1, win.Frm)
  g.Li2 = lis
  lis:SeU(g, g.OL2E)
  lis:SLH(16, 11)
  lis:CoA("", 1, 35)
  lis:CoA("Name", 2, 220)
  lis:CoA("Info", 3, 60)
  lis:CoA("Info2", 4, 100)
  lis:CoA("Info3", 5, 300)
  win:Att(lis.Frm, .33, 1, 18, 1)
  g.EdB = Nx.EdB:Cre(win.Frm, g, g.OEB, 30)
  win:Att(g.EdB.Frm, .33, 1, 0, 18)
  g:CSF()
  g:UVV()
  g:Upd()
  map:IIT("!POI", "WP", "", 1, 1)
  map:IIT("!POIIn", "WP", "", 1, 1)
  return g
end
function Nx.Que:MaC()
  if self.ITQ then
      self:SBQDZ()
  end
end
function Nx.Map:GTP()
  local map = self.Map1[1]
  local tar1 = map.Tar[1]
  if tar1 then
      return tar1.TX1, tar1.TY1, tar1.TX2, tar1.TY2
  end
end
function Nx.Win:GeS2()
  return self.Frm:GetWidth() - self.BoW * 2, self.Frm:GetHeight() - self.TiH + self.BoH * 2
end
function Nx.UEv:UpM(upG)
  local Map = Nx.Map
  local maI = Map:GCMI()
  local m = Map:GeM(1)
  if m then
      if upG then
          m.Gui:Upd()
      end
      m:IIT("Kill", nil, "Interface\\TargetingFrame\\UI-TargetingFrame-Skull", 10, 10)
      m:IIT("Death", nil, "Interface\\TargetingFrame\\UI-TargetingFrame-Seal", 10, 10)
      local ico
      for k, ite in ipairs(self.Sor) do
          if ite.NXMapId == maI then
              if ite["T"] == "K" then
                  ico = m:AIP("Kill", ite.NXX, ite.NXY)
                  m:SIT(ico, ite.NXName)
              elseif ite["T"] == "D" then
                  ico = m:AIP("Death", ite.NXX, ite.NXY)
                  m:SIT(ico, ite.NXName)
              end
          end
      end
  end
end
function Nx.Map:UTB()
  local frm = self.ToB.Frm
  local opt = Nx:GGO()
  if opt["MapShowToolBar"] then
      frm:Show()
  else
      frm:Hide()
  end
end
function Nx:GAE()
  local cc = Nx.CuC
  local t = {}
  local i = 1
  for k, v in pairs(cc.E["Info"]) do
      v["T"] = "I"
      t[i] = v
      i = i + 1
  end
  for k, v in pairs(cc.E["Death"]) do
      v["T"] = "D"
      t[i] = v
      i = i + 1
  end
  for k, v in pairs(cc.E["Kill"]) do
      v["T"] = "K"
      t[i] = v
      i = i + 1
  end
  for k, v in pairs(cc.E["Herb"]) do
      v["T"] = "H"
      t[i] = v
      i = i + 1
  end
  for k, v in pairs(cc.E["Mine"]) do
      v["T"] = "M"
      t[i] = v
      i = i + 1
  end
  return t
end
function Nx.Map.Gui:FiC2(fiT)
  local Que = Nx.Que
  local Map = Nx.Map
  local map = self.Map
  assert(map)
  local co1 = 1
  local co2 = 4
  if not self.SAC then
      local maI = map.RMI
      co1 = map:ITCZ(maI)
      co2 = co1
  end
  local hiF = self:GHF()
  local clo1
  local cMI1, clX, clY
  local clD = 999999999
  local px = map.PlX
  local py = map.PlY
  for shT, fol in pairs(self.ShF) do
      if shT == fiT then
          local mod1 = strbyte(shT)
          if mod1 == 36 then
              local type = strsub(shT, 2, 2)
              local loT = type == "H" and "Herb" or type == "M" and "Mine"
              if loT then
                  local fid = fol.Id
                  local dat = Nx:GeD(loT)
                  for con1 = co1, co2 do
                      local idm = Map.MaI2[con1].Min1
                      local idm1 = Map.MaI2[con1].Max1
                      for maI = idm, idm1 do
                          local zoT = dat[maI]
                          if zoT then
                              local noT = zoT[fid]
                              if noT then
                                  for k, nod in ipairs(noT) do
                                      local x, y = Nx:GaU(nod)
                                      local wx, wy = Map:GWP(maI, x, y)
                                      local dis = (wx - px) ^ 2 + (wy - py) ^ 2
                                      if dis < clD then
                                          clD = dis
                                          clo1 = 0
                                          cMI1 = maI
                                          clX, clY = wx, wy
                                      end
                                  end
                              end
                          end
                      end
                  end
              end
          elseif mod1 == 35 then
          elseif mod1 == 37 then
          elseif mod1 == 38 then
          elseif mod1 == 40 then
              local maI, x, y = strsplit("^", fol.VeP1)
              maI = tonumber(maI)
              x = tonumber(x)
              y = tonumber(y)
              local wx, wy = Map:GWP(maI, x, y)
              local dis = (wx - px) ^ 2 + (wy - py) ^ 2
              if dis < clD then
                  clD = dis
                  clo1 = 0
                  cMI1 = maI
                  clX, clY = wx, wy
              end
          elseif mod1 == 41 then
              local vv = NxData.NXVendorV
              local t = {strsplit("^", fol.ItS1)}
              for _, npN in pairs(t) do
                  local lin2 = vv[npN]["POS"]
                  local maI, x, y = strsplit("^", lin2)
                  maI = tonumber(maI)
                  x = tonumber(x)
                  y = tonumber(y)
                  local wx, wy = Map:GWP(maI, x, y)
                  local dis = (wx - px) ^ 2 + (wy - py) ^ 2
                  if dis < clD then
                      clD = dis
                      clo1 = 0
                      cMI1 = maI
                      clX, clY = wx, wy
                  end
              end
          elseif mod1 == 42 then
          else
              for con1 = co1, co2 do
                  local daS = Nx.GuD[shT][con1]
                  if strbyte(daS, 1) == 32 then
                      for n = 2, #daS, 6 do
                          local fac2 = strbyte(daS, n) - 35
                          if fac2 ~= hiF then
                              local zon = strbyte(daS, n + 1) - 35
                              local maI = Map.NTMI[zon]
                              local loc = strsub(daS, n + 2, n + 5)
                              local x, y = Que:UnL(loc, true)
                              local wx, wy = map:GWP(maI, x, y)
                              local dis = (wx - px) ^ 2 + (wy - py) ^ 2
                              if dis < clD then
                                  clD = dis
                                  clo1 = 0
                                  cMI1 = maI
                                  clX, clY = wx, wy
                              end
                          end
                      end
                  elseif strbyte(daS) == 33 then
                  else
                      for n = 1, #daS, 2 do
                          local npI = (strbyte(daS, n) - 35) * 221 + (strbyte(daS, n + 1) - 35)
                          local npS = Nx.NPCD[npI]
                          local fac2 = strbyte(npS, 1) - 35
                          if fac2 ~= hiF then
                              local oSt = strsub(npS, 2)
                              local des1, zon, loc = Que:UnO(oSt)
                              local maI = Map.NTMI[zon]
                              if maI then
                                  if strbyte(oSt, loc) == 32 then
                                      loc = loc + 1
                                      local cnt = floor((#oSt - loc + 1) / 4)
                                      for loN1 = loc, loc + cnt * 4 - 1, 4 do
                                          local lo1 = strsub(oSt, loN1, loN1 + 3)
                                          local x, y = Que:UnL(lo1, true)
                                          local wx, wy = map:GWP(maI, x, y)
                                          local dis = (wx - px) ^ 2 + (wy - py) ^ 2
                                          if dis < clD then
                                              clD = dis
                                              clo1 = npI
                                              cMI1 = maI
                                              clX, clY = wx, wy
                                          end
                                      end
                                  else
                                      local des1, zon, x, y = Que:GOP(nil, oSt)
                                      local wx, wy = map:GWP(maI, x, y)
                                      local dis = (wx - px) ^ 2 + (wy - py) ^ 2
                                      if dis < clD then
                                          clD = dis
                                          clo1 = npI
                                          cMI1 = maI
                                          clX, clY = wx, wy
                                      end
                                  end
                              end
                          end
                      end
                  end
              end
          end
      end
  end
  return clo1, cMI1, clX, clY
end
function Nx.Lis:OCD(id)
  local f = ColorPickerFrame
  f:SetMovable(true)
  self.CoI = id
  f.NXList = self
  f.NXTbl = self.BuD[id + 8000000]
  f.NXVName = self.BuD[id + 9000000]
  local haA = not self.BuD[id + 10000000]
  f["func"] = function()
      local f = ColorPickerFrame
      local r, g, b = f:GetColorRGB()
      local a = f["hasOpacity"] and (1 - OpacitySliderFrame:GetValue()) or 1
      f.NXTbl[f.NXVName] = floor(r * 255) * 0x1000000 + floor(g * 255) * 0x10000 + floor(b * 255) * 0x100 +
                               floor(a * 255)
      local self = f.NXList
      self:Upd()
      if self.UsF then
          self.UsF(self.Use, "color", self.CoI)
      end
  end
  f["hasOpacity"] = haA
  f["opacityFunc"] = f["func"]
  f["cancelFunc"] = function(old)
      f.NXTbl[f.NXVName] = old
      local self = f.NXList
      self:Upd()
      if self.UsF then
          self.UsF(self.Use, "color", self.CoI)
      end
  end
  local col2 = f.NXTbl[f.NXVName]
  f["previousValues"] = col2
  local r, g, b, a = Nx.U_23(col2)
  f:SetColorRGB(r, g, b)
  f["opacity"] = 1 - a
  ShowUIPanel(f)
end
function Nx.War:Upd()
  local Nx = Nx
  if not Nx.CuC then
      return
  end
  if not self.Win1 then
      return
  end
  self.Win1:SeT(format("Warehouse: %d characters", #Nx.ReC1))
  local myN = UnitName("player")
  local toC = 0
  local toM = 0
  local toP = 0
  local hic = "|cffcfcfcf"
  local lis = self.Lis
  lis:Emp()
  lis:ItA(99)
  lis:ISB("Warehouse", false, "Interface\\Icons\\INV_Misc_GroupNeedMore")
  local alI = lis:IGN()
  local war = NxData.NXWare
  local rn = GetRealmName()
  for nam, gui1 in pairs(war) do
      if nam == rn then
          for gNa1, gui2 in pairs(gui1) do
              local moS = gui2["Money"] and Nx.U_GMS(gui2["Money"]) or "?"
              lis:ItA(100)
              lis:ItS(2, format("|cffff7fff%s %s", gNa1, moS))
              lis:ISDE(nil, gNa1, 1)
          end
      end
  end
  lis:ItA(0)
  lis:ItS(2, "-------------------------")
  for cnu, rc in ipairs(Nx.ReC1) do
      local rna, cna = strsplit(".", rc)
      local cnC = "|cffafdfaf"
      if cna == myN then
          cnC = "|cffdfffdf"
      end
      local ch = NxData.Characters[rc]
      if ch then
          toC = toC + 1
          toP = toP + ch["TimePlayed"]
          local lvl = tonumber(ch["Level"] or 0)
          local cls = ch["Class"] or "?"
          local mon = ch["Money"]
          toM = toM + (mon or 0)
          local moS = Nx.U_GMS(mon)
          lis:ItA(cnu)
          local s = ch["Account"] and format("%s (%s)", cna, ch["Account"]) or cna
          lis:ItS(2, format("%s%s %s %s  %s", cnC, s, lvl, cls, moS))
          local hid = ch["WHHide"]
          if self.ClI1[ch["Class"]] then
              lis:ISB("Warehouse", hid, "Interface\\Icons\\" .. self.ClI1[ch["Class"]])
          end
          if not hid then
              if cna == myN then
                  local sec = difftime(time(), ch["LTime"])
                  local min1 = sec / 60 % 60
                  local hou = sec / 3600
                  local lvH = difftime(time(), ch["LvlTime"]) / 3600
                  local pla1 = Nx.U_GTES(ch["TimePlayed"])
                  lis:ItA(cnu)
                  lis:ItS(2, format(" Time On: %s%2d:%02d:%02d|r, Played: %s%s", hic, hou, min1, sec % 60, hic, pla1))
                  local mon = (ch["Money"] or 0) - ch["LMoney"]
                  local moS = Nx.U_GMS(mon)
                  local mHS = Nx.U_GMS(mon / hou)
                  lis:ItA(cnu)
                  lis:ItS(2, format(" Session Money: %s|r, Per Hour: %s", moS, mHS))
                  if ch["DurPercent"] then
                      local col2 = (ch["DurPercent"] < 50 or ch["DurLowPercent"] < 50) and "|cffff0000" or hic
                      lis:ItA(cnu)
                      lis:ItS(2,
                          format(" Durability: %s%d%%, lowest %d%%", col2, ch["DurPercent"], ch["DurLowPercent"]))
                  end
                  if lvl < MAX_PLAYER_LEVEL then
                      local res2 = ch["LXPRest"] / ch["LXPMax"] * 100
                      local xp = ch["XP"] - ch["LXP"]
                      lis:ItA(cnu)
                      lis:ItS(2, format(" Session XP: %s, Per Hour: %.0f", xp, xp / lvH))
                      xp = max(1, xp)
                      local lvT = (ch["XPMax"] - ch["XP"]) / (xp / lvH)
                      if lvT < 100 then
                          lis:ItA(cnu)
                          lis:ItS(2, format(" Hours To Level: %s%.1f", hic, lvT))
                      end
                  end
              else
                  if ch["Time"] then
                      local sec = difftime(time(), ch["Time"])
                      local str = Nx.U_GTES(sec)
                      local pla1 = Nx.U_GTES(ch["TimePlayed"])
                      lis:ItA(cnu)
                      lis:ItS(2, format(" Last On: %s%s|r, Played: %s%s", hic, str, hic, pla1))
                  end
                  if ch["Pos"] then
                      local mid, x, y = strsplit("^", ch["Pos"])
                      local map = Nx.Map:GeM(1)
                      local nam = map:ITN(tonumber(mid))
                      lis:ItA(cnu)
                      lis:ItS(2, format(" Location: %s%s (%d, %d)", hic, nam, x, y))
                  end
              end
              if lvl < MAX_PLAYER_LEVEL then
                  if ch["XP"] then
                      local res2 = ch["LXPRest"] / ch["LXPMax"] * 100
                      lis:ItA(cnu)
                      lis:ItS(2,
                          format(" Start XP: %s%s/%s (%.0f%%)|r Rest: %s%.0f%%", hic, ch["LXP"], ch["LXPMax"],
                              ch["LXP"] / ch["LXPMax"] * 100, hic, res2))
                      local res2 = ch["XPRest"] / ch["XPMax"] * 100
                      if ch["Time"] then
                          res2 = min(150, res2 + difftime(time(), ch["Time"]) * .0001736111)
                      end
                      lis:ItA(cnu)
                      lis:ItS(2, format(" XP: %s%s/%s (%.0f%%)|r Rest: %s%.0f%%", hic, ch["XP"], ch["XPMax"],
                          ch["XP"] / ch["XPMax"] * 100, hic, res2))
                  end
              end
              if ch["Honor"] then
                  local hoS = ""
                  if cna == myN then
                      local hk, hon = GetPVPSessionStats()
                      if hon > 0 then
                          hoS = format(" (+%d)", hon)
                      end
                  end
                  lis:ItA(cnu)
                  lis:ItS(2, format(" Honor: %s%s%s|r, Arena Pts: %s%s", hic, ch["Honor"], hoS, hic, ch["ArenaPts"]))
              end
              if ch["Profs"] then
                  local pro3 = ch["Profs"]
                  local nam1 = {}
                  for nam, dat in pairs(pro3) do
                      tinsert(nam1, nam)
                  end
                  sort(nam1)
                  for n, nam in ipairs(nam1) do
                      local p = pro3[nam]
                      lis:ItA(cnu)
                      lis:ISDE(nil, nam, 1)
                      lis:ItS(2, format(" %s %s%s", nam, hic, p["Rank"]))
                      if p["Link"] then
                          lis:ISB("WarehouseProf", false)
                      end
                  end
              end
          end
      end
  end
  local mon = Nx.U_GMS(toM)
  local pla1 = Nx.U_GTES(toP)
  lis:ItS(2, format("|cffafdfafAll: %s. |cffafdfafPlayed: %s%s", mon, hic, pla1), alI)
  lis:Upd()
  if not self.SeP5 then
      self:UpI1()
  else
      self:UpP()
  end
end
function Nx.Map:UpW()
    if self.Debug then
        Nx.prt("%d Map UpdateWorld1 %d L%d", self.Tic, self:GCMI(), GetCurrentMapDungeonLevel())
    end
    self.NWU = false
    local maI = self:GCMI()
    local win1 = self.MWI[maI]
    if win1.MaL1 then
        if GetCurrentMapDungeonLevel() ~= win1.MaL1 then
            SetDungeonMapLevel(win1.MaL1)
        end
    end
    local i = self:GEON()
    if self.CWUMI == maI and i == self.CWUON then
        return
    end
    self.CWUMI = maI
    self.CWUON = i
    local mFN = GetMapInfo()
    if not mFN then
        if GetCurrentMapContinent() == WORLDMAP_COSMIC_ID then
            mFN = "Cosmic"
        else
            mFN = "World"
        end
    end
    self:UOU()
    if self.Debug then
        Nx.prt("%d Map UpdateWorld %d", self.Tic, self:GCMI())
        Nx.prt(" File %s", mFN)
    end
    Nx.UEv:UpM(true)
    if not win1.NoB1 then
        local nam = win1.MBN or mFN
        for i = 1, NUM_WORLDMAP_DETAIL_TILES, 1 do
            self.TiF1[i].tex:SetTexture("Interface\\WorldMap\\" .. mFN .. "\\" .. nam .. i)
        end
    end
end

function Nx.Map:GIP(icT, ind)
  local ico = self.Dat[icT][ind]
  return ico.X, ico.Y
end
function Nx.Map:BGM_OI(ite)
  self:BGM_S(NXlBGMsgIncoming)
end
function Nx:NXMapKeyTogHerb()
  local map = Nx.Map:GeM(1)
  Nx.ChO["MapShowGatherH"] = not Nx.ChO["MapShowGatherH"]
  map.MISH:SetChecked(Nx.ChO, "MapShowGatherH")
  map.Gui:UGF()
end
function Nx.Opt:GeV(vaN)
  local dat = Nx.OpV[vaN]
  if dat then
      local sco1, typ, val = strsplit("~", dat)
      local opt = sco1 == "-" and self.COp or self.Opt
      if typ == "B" then
          return opt[vaN]
      elseif typ == "CH" then
          return opt[vaN]
      elseif typ == "F" or typ == "I" or typ == "S" then
          return opt[vaN]
      end
  end
end
function Nx.Win:ReB()
  if self.Win2 then
      local bk = Nx.Ski:GetBackdrop()
      for win, v in pairs(self.Win2) do
          if win.Bor1 then
              win.Frm:SetBackdrop(bk)
              win.BaF = win.BFT + .0001
          end
      end
  end
end
function Nx.Map:HMF()
    for n = 1, self.MiB ^ 2 do
        self.MiF[n]:Hide()
    end
end
function Nx.Ite:Ini()
    self.Nee = {}
    self.Ask = {}
end
function Nx.Que.Lis:Ope()
    local gop = Nx:GGO()
    local qop = Nx:GQO()
    self.QOp = qop
    local TaB = Nx.TaB
    self.SAZ = false
    self.Ope1 = true
    local win = Nx.Win:Cre("NxQuestList")
    self.Win1 = win
    win:CrB(true, true)
    win:ILD(nil, -.24, -.15, -.52, -.65)
    tinsert(UISpecialFrames, "QuestLogFrame")
    tinsert(UISpecialFrames, win.Frm:GetName())
    win.Frm:SetToplevel(true)
    win.Frm:SetMinResize(250, 120)
    win:SeU(self, self.OnW)
    win:RegisterEvent("PLAYER_LOGIN", self.OQU)
    win:RegisterEvent("QUEST_LOG_UPDATE", self.OQU)
    win:RegisterEvent("QUEST_WATCH_UPDATE", self.OQU)
    win:RegisterEvent("UPDATE_FACTION", self.OQU)
    win:RegisterEvent("UNIT_QUEST_LOG_CHANGED", self.OQU)
    win:RegisterEvent("QUEST_PROGRESS", self.OQU)
    win:RegisterEvent("QUEST_COMPLETE", self.OQU)
    local f = CreateFrame("EditBox", "NxQuestFilter", win.Frm)
    self.FiF2 = f
    f.NxI = self
    f:SetScript("OnEditFocusGained", self.FOEFG)
    f:SetScript("OnEditFocusLost", self.FOEFL)
    f:SetScript("OnTextChanged", self.FOTC)
    f:SetScript("OnEnterPressed", self.FOEP)
    f:SetScript("OnEscapePressed", self.FOEP1)
    f:SetFontObject("NxFontS")
    local t = f:CreateTexture()
    t:SetTexture(.1, .2, .3, 1)
    t:SetAllPoints(f)
    f.tex = t
    f:SetAutoFocus(false)
    f:ClearFocus()
    win:Att(f, 0, 1, 0, 18)
    self.FiD = "Search: [click]"
    self.FDE = "Search: %[click%]"
    self.Fil = {"", "", "", ""}
    f:SetText(self.FiD)
    f:SetMaxLetters(30)
    Nx.Lis:SCF1("FontQuest", 12)
    local lis = Nx.Lis:Cre("Quest", 0, 0, 1, 1, win.Frm)
    self.Lis = lis
    lis:SeU(self, self.OLE)
    lis:SLH(0, 6)
    lis:CoA("", 1, 20)
    lis:CoA("", 2, 300)
    lis:CoA("", 3, 0)
    lis:CoA("", 4, 600)
    lis:CoA("", 5, 200)
    lis:CoA("", 6, 500)
    local men = Nx.Men:Cre(lis.Frm, 240)
    self.Men = men
    local me1 = {}
    self.MI1 = me1
    local me2 = {}
    self.MI2 = me2
    local me3 = {}
    self.MI3 = me3
    local me4 = {}
    self.MI4 = me4
    local ite = men:AdI1(0, "Toggle High Watch Priority", self.M_OHP, self)
    tinsert(me1, ite)
    local ite = men:AdI1(0, "Show Category Headers", self.M_OSH1, self)
    ite:SetChecked(qop.NXShowHeaders)
    tinsert(me1, ite)
    local ite = men:AdI1(0, "Show Objectives", self.M_OSO, self)
    ite:SetChecked(qop.NXShowObj)
    tinsert(me1, ite)
    local ite = men:AdI1(0, "Show Only Party Quests", self.M_OSP, self)
    ite:SetChecked(false)
    tinsert(me1, ite)
    local ite = men:AdI1(0, "")
    tinsert(me1, ite)
    local ite = men:AdI1(0, "Watch All Quests", self.M_OWA, self)
    tinsert(me1, ite)
    local ite = men:AdI1(0, "Watch All Completed Quests", self.M_OWC, self)
    tinsert(me1, ite)
    local ite = men:AdI1(0, "")
    tinsert(me1, ite)
    local ite = men:AdI1(0, "Broadcast Quest Changes To Party", nil, self)
    ite:SetChecked(gop, "QBroadcastQChanges")
    tinsert(me1, ite)
    local ite = men:AdI1(0, "Send Quest Status To Party", self.M_OSQI, self)
    tinsert(me1, ite)
    local ite = men:AdI1(0, "Share", self.M_OS3, self)
    self.MIS4 = ite
    tinsert(me1, ite)
    local ite = men:AdI1(0, "")
    tinsert(me1, ite)
    local ite = men:AdI1(0, "Abandon", self.M_OA, self)
    tinsert(me1, ite)
    local ite = men:AdI1(0, "Remove", self.M_OC3, self)
    tinsert(me2, ite)
    local ite = men:AdI1(0, "Remove All", self.M_OHRA, self)
    tinsert(me2, ite)
    local function fun()
        Nx.CuC["QHAskedGet"] = true
        QueryQuestsCompleted()
    end
    local ite = men:AdI1(0, "Get Completed From Server", fun, self)
    tinsert(me2, ite)
    local ite = men:AdI1(0, "Mark As Previously Completed", self.M_OC3, self)
    tinsert(me3, ite)
    tinsert(me3, men:AdI1(0, "Goto Quest Giver", self.M_OG, self))
    local ite = men:AdI1(0, "")
    tinsert(me2, ite)
    tinsert(me3, ite)
    local ite = men:AdI1(0, "Show All Quests", self.M_OSAQ, self)
    ite:SetChecked(false)
    tinsert(me2, ite)
    tinsert(me3, ite)
    local ite = men:AdI1(0, "Show Low Level Quests", self.M_OSLL, self)
    ite:SetChecked(false)
    tinsert(me3, ite)
    local ite = men:AdI1(0, "Show High Level Quests", self.M_OSHL, self)
    ite:SetChecked(false)
    tinsert(me3, ite)
    local ite = men:AdI1(0, "Show Quests From All Zones", self.M_OSAZ, self)
    ite:SetChecked(false)
    tinsert(me2, ite)
    tinsert(me3, ite)
    local ite = men:AdI1(0, "Show Finished Quests", self.M_OSF, self)
    ite:SetChecked(false)
    tinsert(me3, ite)
    local ite = men:AdI1(0, "Show Only Non Dungeon Dailies", self.M_OSOD, self)
    ite:SetChecked(false)
    tinsert(me3, ite)
    local ite = men:AdI1(0, "")
    tinsert(me3, ite)
    local ite = men:AdI1(0, "Track None", self.M_OTN, self)
    tinsert(me3, ite)
    local ite = men:AdI1(0, "")
    tinsert(me1, ite)
    tinsert(me2, ite)
    tinsert(me3, ite)
    local function fun()
        Nx.Opt:Ope("Quest")
    end
    local ite = men:AdI1(0, "Options...", fun)
    tinsert(me1, ite)
    tinsert(me2, ite)
    tinsert(me3, ite)
    local f
    if Nx.V33 then
        f = CreateFrame("ScrollFrame", "NxQuestD", win.Frm, "NxQuestDetails")
    else
        f = CreateFrame("ScrollFrame", "NxQuestD", win.Frm, "NxQuestDetailsOld")
    end
    self.DeF = f
    f.NSS = self.ODSS
    f:SetMovable(true)
    f:EnableMouse(true)
    f:SetFrameStrata("MEDIUM")
    local t = f:CreateTexture()
    t:SetTexture(.7, .7, .5, 1)
    t:SetAllPoints(f)
    f.tex = t
    f:Show()
    local bar = TaB:Cre(nil, win.Frm, 1, 1)
    self.Bar = bar
    local tbH = TaB:GetHeight()
    win:Att(bar.Frm, 0, 1, -tbH, 1)
    bar:SeU(self, self.OTB)
    self.TaS1 = 1
    bar:AdT1("Current", 1, nil, true)
    bar:AdT1("History", 2)
    bar:AdT1("Database", 3)
    bar:AdT1("Player", 4)
    self:AtF()
end

function Nx.Map.Gui:OL2E(evN, sel, va2, cli)
  self:OLED(self.Li2, evN, sel, va2, cli)
end
function Nx.Ski:Ini()
  Nx.Ski1 = {
      ["Blackout"] = {
          ["Folder"] = "",
          ["WinBrH"] = "WinBrH",
          ["WinBrV"] = "WinBrV",
          ["TabOff"] = "TabOff",
          ["TabOn"] = "TabOn",
          ["Backdrop"] = {
              ["bgFile"] = "Interface\\Buttons\\White8x8",
              ["edgeFile"] = "Interface\\Addons\\Carbonite\\Gfx\\Skin\\EdgeSquare",
              ["tile"] = true,
              ["tileSize"] = 8,
              ["edgeSize"] = 8,
              ["insets"] = {
                  ["left"] = 0,
                  ["right"] = 0,
                  ["top"] = 0,
                  ["bottom"] = 0
              }
          },
          ["BdCol"] = 0xff,
          ["BgCol"] = 0xff
      },
      ["BlackoutBlues"] = {
          ["Folder"] = "",
          ["WinBrH"] = "WinBrH",
          ["WinBrV"] = "WinBrV",
          ["TabOff"] = "TabOff",
          ["TabOn"] = "TabOn",
          ["Backdrop"] = {
              ["bgFile"] = "Interface\\Buttons\\White8x8",
              ["edgeFile"] = "Interface\\Tooltips\\UI-Tooltip-Border",
              ["tile"] = true,
              ["tileSize"] = 9,
              ["edgeSize"] = 9,
              ["insets"] = {
                  ["left"] = 1,
                  ["right"] = 1,
                  ["top"] = 1,
                  ["bottom"] = 1
              }
          },
          ["BdCol"] = 0xccccffff,
          ["BgCol"] = 0xff
      },
      ["DialogBlue"] = {
          ["Folder"] = "",
          ["WinBrH"] = "WinBrH",
          ["WinBrV"] = "WinBrV",
          ["TabOff"] = "TabOff",
          ["TabOn"] = "TabOn",
          ["Backdrop"] = {
              ["bgFile"] = "Interface\\Buttons\\White8x8",
              ["edgeFile"] = "Interface\\DialogFrame\\UI-DialogBox-Border",
              ["tile"] = true,
              ["tileSize"] = 16,
              ["edgeSize"] = 16,
              ["insets"] = {
                  ["left"] = 2,
                  ["right"] = 2,
                  ["top"] = 2,
                  ["bottom"] = 2
              }
          },
          ["BdCol"] = 0xccccffff,
          ["BgCol"] = 0x1f1f1fe0
      },
      ["DialogGold"] = {
          ["Folder"] = "",
          ["WinBrH"] = "WinBrH",
          ["WinBrV"] = "WinBrV",
          ["TabOff"] = "TabOff",
          ["TabOn"] = "TabOn",
          ["Backdrop"] = {
              ["bgFile"] = "Interface\\Buttons\\White8x8",
              ["edgeFile"] = "Interface\\DialogFrame\\UI-DialogBox-Gold-Border",
              ["tile"] = true,
              ["tileSize"] = 16,
              ["edgeSize"] = 16,
              ["insets"] = {
                  ["left"] = 2,
                  ["right"] = 2,
                  ["top"] = 2,
                  ["bottom"] = 2
              }
          },
          ["BdCol"] = 0xffffffff,
          ["BgCol"] = 0x262600e0
      },
      ["SimpleBlue"] = {
          ["Folder"] = "",
          ["WinBrH"] = "WinBrH",
          ["WinBrV"] = "WinBrV",
          ["TabOff"] = "TabOff",
          ["TabOn"] = "TabOn",
          ["Backdrop"] = {
              ["bgFile"] = "Interface\\Buttons\\White8x8",
              ["edgeFile"] = "Interface\\Addons\\Carbonite\\Gfx\\Skin\\EdgeSquare",
              ["tile"] = true,
              ["tileSize"] = 8,
              ["edgeSize"] = 8,
              ["insets"] = {
                  ["left"] = 0,
                  ["right"] = 0,
                  ["top"] = 0,
                  ["bottom"] = 0
              }
          },
          ["BdCol"] = 0xb2b2ffcc,
          ["BgCol"] = 0x1f1f1fe0
      },
      ["Stone"] = {
          ["Folder"] = "",
          ["WinBrH"] = "WinBrH",
          ["WinBrV"] = "WinBrV",
          ["TabOff"] = "TabOff",
          ["TabOn"] = "TabOn",
          ["Backdrop"] = {
              ["bgFile"] = "Interface\\Buttons\\White8x8",
              ["edgeFile"] = "Interface\\Glues\\Common\\TextPanel-Border",
              ["tileSize"] = 256,
              ["edgeSize"] = 16,
              ["insets"] = {
                  ["left"] = 3,
                  ["right"] = 2,
                  ["top"] = 2,
                  ["bottom"] = 2
              }
          },
          ["BdCol"] = 0xffffffff,
          ["BgCol"] = 0x0f0f0ff0
      },
      ["ToolBlue"] = {
          ["Folder"] = "",
          ["WinBrH"] = "WinBrH",
          ["WinBrV"] = "WinBrV",
          ["TabOff"] = "TabOff",
          ["TabOn"] = "TabOn",
          ["Backdrop"] = {
              ["bgFile"] = "Interface\\Buttons\\White8x8",
              ["edgeFile"] = "Interface\\Tooltips\\UI-Tooltip-Border",
              ["tile"] = true,
              ["tileSize"] = 9,
              ["edgeSize"] = 9,
              ["insets"] = {
                  ["left"] = 1,
                  ["right"] = 1,
                  ["top"] = 1,
                  ["bottom"] = 1
              }
          },
          ["BdCol"] = 0xccccffff,
          ["BgCol"] = 0x1f1f1fe0
      }
  }
  local opt = Nx:GGO()
  self.GOp = opt
  self:Set(opt["SkinName"], true)
end
function Nx.Que.Wat:M_ORW(ite)
  self:ReW(self.MQI, self.MQI1)
  self:Upd()
  Nx.Que.Lis:Upd()
end
function Nx.Lis:GLH()
  return Nx.Fon:GeH(self.Fon) + self.LHP
end
function Nx.Que.Lis:M_OHRA()
  local idT = Nx.Que.ITCQ
  local quT = Nx.CuC.Q
  for id in pairs(quT) do
      if not idT[id] then
          quT[id] = nil
      end
  end
  Nx.prt("History cleared")
  self:Upd()
end
function Nx:NXGuideKeyToggleShow()
  local map = Nx.Map:GeM(1)
  map.Gui:ToS()
end
function Nx.Que.Wat:Upd()
end
function Nx.Map:GOT(ind)
  local map = Nx.Map.Map1[ind]
  local opt = NxMapOpts.NXMaps[ind]
  return opt[map.RMI] or opt[0]
end
function Nx.Opt.ESA(str, ite)
  local self = Nx.Opt
  if str then
      self:SeV(ite.V, str)
      self:Upd()
      if ite.VF then
          local var = self:GeV(ite.V)
          self[ite.VF](self, ite, var)
      end
  end
end
function Nx.Fav:OILE(evN, sel, va2, cli)
  local lis = self.ItL
  local ite = lis:IGD(sel)
  self.CII = sel
  self.Sid = 2
  if evN == "select" or evN == "mid" or evN == "menu" then
      if evN == "menu" then
          self.ItM:Show(self.CuF and true or -1)
          self.ItM:Ope()
      end
  elseif evN == "button" then
      local fla = va2 and 1 or 0
      self:SIF(sel, 0xfe, fla)
  end
  self:SeI1(sel)
  self:Upd()
end
function Nx.Lis:ISL()
  local top = self.Num - self.Vis + 1
  top = max(top, 1)
  return self.Top == top
end
function Nx.Men:IAO()
  return self.Cur and self.Cur.MaF:IsVisible()
end
function Nx.Map:GMBN(miT, x, y)
  local off1 = x * 100 + y
  return miT[1][off1 + miT[2]]
end
function Nx.War.OL_()
  local self = Nx.War
  if not self.LoT then
      self.LoT = format("U^%s", UnitName("target") or "")
  end
  self.LoI3 = {}
  for n = 1, GetNumLootItems() do
      self.LoI3[n] = GetLootSlotLink(n)
  end
  self:prt1("LOOT_OPENED %s (%s %s)", self.LoT, arg1, arg2 or "nil")
end
function Nx.Fav:MXY(x, y)
  local s = Nx:CMXY(x, y % 100)
  return s .. strchar(floor(y / 100) + 35)
end
function Nx.Map:SWMI(sca)
  for n = 1, MAX_PARTY_MEMBERS do
      local f = getglobal("WorldMapParty" .. n)
      if f then
          f:SetScale(sca)
      end
  end
  for n = 1, MAX_RAID_MEMBERS do
      local f = getglobal("WorldMapRaid" .. n)
      if f then
          f:SetScale(sca)
      end
  end
  local fla = GetNumBattlefieldFlagPositions()
  for n = 1, fla do
      local f = getglobal("WorldMapFlag" .. n)
      if f then
          f:SetScale(sca)
      end
  end
  for k, f in ipairs(_G["MAP_VEHICLES"]) do
      f:SetScale(sca)
  end
  for k, nam in ipairs(Nx.Map.WMHN) do
      local f = getglobal(nam)
      if f then
          f:SetScale(sca)
      end
  end
end
function Nx:OP__()
  Nx.Soc:PCH()
  Nx.Win:UpC()
end
function Nx.Map:STAS(str)
  local mId, zx, zy = self:PTS(str)
  if mId then
      local wx, wy = self:GWP(mId, zx, zy)
      local str = format("%.0f, %.0f", zx, zy)
      self:SeT3("Goto", wx, wy, wx, wy, nil, nil, str, nil, mId)
  end
end
function Nx.NXMiniMapBut:NXOnEnter()
  local gop = Nx.GGO()
  local mmo = gop["MapMMButOwn"]
  local tip = GameTooltip
  tip:SetOwner(this, "ANCHOR_LEFT")
  tip:SetText(NXTITLEFULL .. " " .. Nx.VERSION)
  tip:AddLine("carboniteaddon.com", .6, .6, 1, 1)
  tip:AddLine("Left click toggle Map", 1, 1, 1, 1)
  if mmo then
      tip:AddLine("Shift left click toggle minimize", 1, 1, 1, 1)
  end
  tip:AddLine("Alt left click toggle Watch List", 1, 1, 1, 1)
  tip:AddLine("Middle click toggle Guide", 1, 1, 1, 1)
  tip:AddLine("Right click for Menu", 1, 1, 1, 1)
  if not mmo then
      tip:AddLine("Shift drag to move", 1, 1, 1, 1)
  end
  tip:AppendText("")
end
function Nx.Map:SIM(maI)
  self.IMI = nil
  if not maI then
      return
  end
  local Map = Nx.Map
  local inf = Map.InI1[maI]
  local siz1, siz2 = 1002, 668
  self.IMA = nil
  if not inf and getglobal("AtlasMaps") then
      inf = Map.AII[maI]
      siz1, siz2 = 668, 668
      self.IMA = true
  end
  if inf then
      self:SCM1(maI)
      self.IMI = maI
      self.IMI1 = inf
      local win1 = Map.MWI[maI]
      local wx = win1[2]
      local wy = win1[3]
      self.IMWX1 = wx
      self.IMWY1 = wy
      self.IMWX2 = wx + siz1 / 256
      self.IMWY2 = wy + siz2 / 256 * #inf / 3
  end
end
function Nx.Map.Minimap_OnEvent()
  local map = Nx.Map:GeM(1)
  map:MiZ()
end
function Nx.Map:IOE(mot)
  local map = this.NxM1
  map:BPL()
  if this.NxT then
      local tt = GameTooltip
      local str = strsplit("~", this.NxT)
      local own = this
      local tip2 = "ANCHOR_CURSOR"
      local opt = Nx:GGO()
      if opt["MapTopTooltip"] then
          own = map.Win1.Frm
          tip2 = "ANCHOR_TOPLEFT"
      end
      own.NXIconFrm = this
      tt:SetOwner(own, tip2, 0, 0)
      Nx:STT(str .. Nx.Map.PNTS)
      own["UpdateTooltip"] = Nx.Map.IOUT
  end
  local t = this.NXType or -1
  if t >= 9000 then
      Nx.Que:IOE(this)
  end
end
function Nx:GHUDO()
  return NxData.NXHUDOpts
end
function Nx.Que.Wat:M_OA(ite)
  Nx.Que.Lis:Sel1(self.MQI, self.MQI1)
  Nx.Que:Aba(self.MQI1, self.MQI)
end
function Nx.But:Cre(paF, typ, tex1, tip, bx, by, sid, wid, hei, fun, use, template)
  paF = paF or UIParent
  local but1 = {}
  setmetatable(but1, self)
  self.__index = self
  but1:SeU(use, fun)
  but1.Typ = self.TyD[typ]
  assert(not typ or but1.Typ)
  local fTy = template and "Button" or "Frame"
  local fna = tex1 and ("NxBut" .. tex1)
  local f = CreateFrame(fTy, fna, paF, template)
  but1.Frm = f
  f.NxB = but1
  but1.Tip = tip
  f.NxT = tip or (typ and self.TyD[typ].Tip)
  sid = sid or "TOPLEFT"
  f:SetPoint(sid, bx, by)
  f:SetWidth(wid)
  f:SetHeight(hei)
  f:SetScript("OnMouseDown", self.OMD)
  f:SetScript("OnMouseUp", self.OMU)
  f:SetScript("OnEnter", self.OnE1)
  f:SetScript("OnLeave", self.OnL)
  f:EnableMouse(true)
  f:SetScript("OnUpdate", self.OnU)
  local t = f:CreateTexture()
  f.tex = t
  t:SetAllPoints(f)
  f:Show()
  if tex1 then
      local fst = f:CreateFontString()
      but1.FSt = fst
      fst:SetFontObject("NxFontS")
      fst:SetJustifyH("CENTER")
      fst:SetHeight(hei)
      but1:SetText(tex1, 0, 0)
      fst:Show()
  end
  but1:Upd()
  if template then
      local reg = {f:GetRegions()}
      for n, o in ipairs(reg) do
          if o:IsObjectType("Texture") and o ~= f.tex then
              o:Hide()
          end
      end
  end
  return but1
end
function Nx.Map:BGM_OH(ite)
  self:BGM_S("Help")
end
function Nx.Win:CoS(str)
  local nam, mod1 = self:PaC(str)
  local win = self:FNC(nam)
  if win then
      if not mod1 then
          win:Show(not win:IsShown())
      elseif mod1 == 0 then
          win:Show(false)
      else
          win:Show()
      end
      return
  end
  Nx.prt("Window not found (%s)", str)
end
function Nx.Que:GCOP(str, maI, px, py)
  local nam, zon, loc = self:UnO(str)
  if not zon then
      return
  end
  local Map = Nx.Map
  if strbyte(str, loc) <= 33 then
      local x1, y1, x2, y2 = self:GOR(nil, str)
      x1, y1 = Map:GWP(maI, (x1 + x2) / 2, (y1 + y2) / 2)
      return x1, y1
  else
      local clD = 999999999
      local clX, clY
      loc = loc - 1
      local loC = floor((#str - loc) / 4)
      cnt = 0
      for loN1 = loc + 1, loc + loC * 4, 4 do
          local x, y
          local lo1 = strsub(str, loN1, loN1 + 3)
          assert(lo1 ~= "")
          local x, y, w, h = self:ULR(lo1)
          w = w / 1002 * 100
          h = h / 668 * 100
          local wx1, wy1 = Map:GWP(maI, x, y)
          local wx2, wy2 = Map:GWP(maI, x + w, y + h)
          x = wx1
          y = wy1
          if px >= wx1 and px <= wx2 then
              if py >= wy1 and py <= wy2 then
                  return px, py
              end
              x = px
          elseif px >= wx2 then
              x = wx2
          end
          if py >= wy1 then
              y = py
          end
          if py >= wy2 then
              y = wy2
          end
          local dis = (x - px) ^ 2 + (y - py) ^ 2
          if dis < clD then
              clD = dis
              clX = x
              clY = y
          end
      end
      return clX, clY
  end
end
function Nx.But:OMU(but)
  local but1 = this.NxB
  if but == "LeftButton" then
      if not (but1.Typ.Boo or but1.Typ.Sta1 or but1.Typ.Scr1) then
          but1.Pre = false
          if Nx.U_IMO(but1.Frm) then
              if but1.UsF then
                  but1.UsF(but1.Use, but1, but1.Id, but)
              end
          end
      elseif but1.Typ.Scr1 then
          but1.Pre = false
      end
  end
  but1.Scr2 = false
  but1:Upd()
end
function Nx.Tra:MaP(tra2, sMI, srX, srY, dMI, dsX, dsY, taT1)
  if not self.GOp["MapRouteUse"] then
      return
  end
  if UnitOnTaxi("player") then
      return
  end
  local Map = Nx.Map
  local win1 = Map.MWI
  local srI1 = win1[sMI]
  sMI = srI1.EMI or sMI
  local dsI1 = win1[dMI]
  dMI = dsI1.EMI or dMI
  local x = dsX - srX
  local y = dsY - srY
  local taD = (x * x + y * y) ^ .5
  if sMI == dMI and taD < 500 / 4.575 then
      return
  end
  local rid1 = Nx.War.SkR
  local co1 = Map:ITCZ(sMI)
  local co2 = Map:ITCZ(dMI)
  local lvl = UnitLevel("player")
  local coF = GetSpellInfo(self.CFN)
  self.FlM = rid1 >= 225 and (co1 == 3 or co1 == 4 and coF)
  local spe1 = 2 / 4.5
  if rid1 < 75 then
      spe1 = 1 / 4.5
  elseif rid1 < 150 then
      spe1 = 1.6 / 4.5
  elseif self.FlM then
      spe1 = 2.5 / 4.5
  end
  self.Spe = spe1
  if co1 == co2 then
      if rid1 >= 300 and self.FlM then
          return
      end
      self.VMI = {}
      local pat = {}
      local no1 = {}
      no1.MaI = sMI
      no1.X = srX
      no1.Y = srY
      tinsert(pat, no1)
      local no2 = {}
      no2.MaI = dMI
      no2.X = dsX
      no2.Y = dsY
      tinsert(pat, no2)
      local wat1 = 10
      repeat
          local noC = #pat
          for n = 1, #pat - 1 do
              local no1 = pat[n]
              local no2 = pat[n + 1]
              if not no1.NoS1 then
                  if no1.MaI ~= no2.MaI then
                      local coD1, con = self:FiC5(no1.MaI, no1.X, no1.Y, no2.MaI, no2.X, no2.Y)
                      local flD, fpa = self:FiF3(no1.MaI, no1.X, no1.Y, no2.MaI, no2.X, no2.Y)
                      if coD1 and (not fpa or coD1 < flD) then
                          if con then
                              local an1 = math.deg(math.atan2(srX - con.StX, srY - con.StY))
                              local an2 = math.deg(math.atan2(srX - con.EnX, srY - con.EnY))
                              local ang = abs(an1 - an2)
                              ang = ang > 180 and 360 - ang or ang
                              if con.SMI ~= no1.MaI then
                                  no1.NoS1 = true
                              end
                              local nam = format("Connection: %s to %s", Nx.MITN[con.SMI], Nx.MITN[con.EMI1])
                              local nod = {}
                              nod.NoS1 = true
                              nod.MaI = con.SMI
                              nod.X = con.StX
                              nod.Y = con.StY
                              nod.Nam = nam
                              nod.Tex1 = "Interface\\Icons\\Spell_Nature_FarSight"
                              tinsert(pat, n + 1, nod)
                              self.VMI[con.SMI] = true
                              if ang > 90 then
                                  nod.Die = true
                              end
                              local nod = {}
                              nod.MaI = con.EMI1
                              nod.X = con.EnX
                              nod.Y = con.EnY
                              nod.Nam = nam
                              nod.Tex1 = "Interface\\Icons\\Spell_Nature_FarSight"
                              tinsert(pat, n + 2, nod)
                          end
                      else
                          if fpa then
                              tinsert(pat, n + 1, fpa[1])
                              tinsert(pat, n + 2, fpa[2])
                          end
                      end
                  else
                      local diD1 = ((no1.X - no2.X) ^ 2 + (no1.Y - no2.Y) ^ 2) ^ .5
                      local flD, fpa = self:FiF3(no1.MaI, no1.X, no1.Y, no2.MaI, no2.X, no2.Y)
                      if fpa and flD < diD1 then
                          tinsert(pat, n + 1, fpa[1])
                          tinsert(pat, n + 2, fpa[2])
                      end
                  end
              end
          end
          wat1 = wat1 - 1
          if wat1 < 0 then
              break
          end
      until noC == #pat
      for n = 2, #pat - 1 do
          local no1 = pat[n]
          if not no1.Die then
              local x, y = no1.X, no1.Y
              local t1 = {}
              t1.TaT = taT1
              t1.TX1 = x
              t1.TY1 = y
              t1.TX2 = x
              t1.TY2 = y
              t1.TMX = x
              t1.TMY = y
              t1.TaT1 = no1.Tex1
              t1.TaN1 = no1.Nam
              if no1.Fli then
                  t1.Mod = "F"
              end
              tinsert(tra2, t1)
          end
      end
  end
end
function Nx.Map:SCL(frm, lvl)
  local ch = {frm:GetChildren()}
  for n, chf in pairs(ch) do
      chf:SetFrameLevel(lvl)
      if chf:GetNumChildren() > 0 then
          self:SCL(chf, lvl + 1)
      end
  end
end
function Nx.Tra:TST1(tm)
  if self.TSN then
      NxData.NXTravel["TaxiTime"][self.TSN] = tm
      self.TSN = false
  end
end
function Nx.Men:I_OE(mot)
  local ite = this.NMI
  if ite.ShS and ite.ShS < 0 then
      ite.AlT = .5
  else
      ite.AlT = .9
  end
end
function Nx.Map:M_OAN()
  local wx, wy = self:FPTWP(self.CFX, self.CFY)
  local zx, zy = self:GZP(self.MaI, wx, wy)
  self:AdN("?", self.MaI, zx, zy)
end
function Nx.UEv.Lis:Upd()
  local UEv = Nx.UEv
  if not self.Win1 then
      return
  end
  self.Win1:SeT(format("Events: %d", #UEv.Sor))
  local lis = self.Lis
  local isL = lis:ISL()
  lis:Emp()
  for k, ite in ipairs(UEv.Sor) do
      lis:ItA()
      lis:ItS(1, date("%d %H:%M:%S", ite.NXTime))
      local eSt = ite.NXName
      if ite["T"] == "D" then
          eSt = "|cffff6060Died! " .. ite.NXName
      elseif ite["T"] == "K" then
          local str = format("%d", ite.NXKills)
          lis:ItS(3, str)
          eSt = "|cffff60ffKilled " .. ite.NXName
      elseif ite["T"] == "H" then
          eSt = "|cff60ff60Picked " .. ite.NXName
      elseif ite["T"] == "M" then
          eSt = "|cffc0c0c0Mined " .. ite.NXName
      end
      lis:ItS(2, eSt)
      local maN = Nx.Map:ITN(ite.NXMapId)
      local str = format("%s %.0f %.0f", maN, ite.NXX, ite.NXY)
      lis:ItS(4, str)
  end
  lis:Upd(isL)
end
function Nx.Map.Gui:CaT3()
  Nx.Tim:PrS("Guide CapTimer")
  local map = Nx.Map:GeM(1)
  local g = map.Gui
  local ok = g:CaI()
  g:UVV()
  g:Upd()
  Nx.Tim:PrE("Guide CapTimer")
  if not ok and MerchantFrame:IsVisible() then
      if Nx.LoO then
          Nx.prt("CapTimer retry")
      end
      return .5
  end
  self.CaC4 = false
end
function Nx.Que:UQD()
  Nx.Tim:Sta("QDetail", 0, self, self.UQDT)
end
function Nx.Map:HEF()
  local frm1 = self.Frm1
  for n = frm1.Nex, frm1.Use1 do
      frm1[n]:Hide()
  end
end
function Nx.Que.Lis.FOEP1()
  local self = this.NxI
  self.Fil[self.TaS1] = ""
  this:ClearFocus()
end
function Nx.Com.Lis:AdI(type, nam)
end
function Nx.Win:ReH()
  local function fun()
      local win = this.NxW
      win:Not("Hide")
  end
  self.Frm:SetScript("OnHide", fun)
end
function Nx.slC(txt)
  local UEv = Nx.UEv
  Nx.prt(txt)
  local cmd, a1, a2 = strsplit(" ", txt)
  cmd = strlower(cmd)
  a1 = a1 or ""
  a2 = a2 or ""
  if cmd == "" or cmd == "?" or cmd == "help" then
      Nx.prt("Commands:")
      Nx.prt(" goto [zone] x y  (make map goto)")
      Nx.prt(" menu  (open menu)")
      Nx.prt(" note [\"]name[\"] [zone] [x y]  (make map note)")
      Nx.prt(" options  (open options window)")
      Nx.prt(" resetwin  (reset window layouts)")
      Nx.prt(" rl  (reload UI)")
      Nx.prt(" track name  (track the player)")
      Nx.prt(" winpos name x y  (position a window)")
      Nx.prt(" winshow name [0/1]  (toggle or show a window)")
      Nx.prt(" winsize name w h  (size a window)")
  elseif cmd == "goto" then
      local map = Nx.Map:GeM(1)
      local s = gsub(txt, "goto%s*", "")
      map:STAS(s)
  elseif cmd == "menu" then
      Nx.NXMiniMapBut:OpM()
  elseif cmd == "note" then
      local s = gsub(txt, "note%s*", "")
      Nx.Fav:SNAS(s)
  elseif cmd == "options" then
      Nx.Opt:Ope()
  elseif cmd == "resetwin" then
      Nx.Win:ReL()
  elseif cmd == "rl" then
      ReloadUI()
  elseif cmd == "track" then
      if a1 then
          local map = Nx.Map:GeM(1)
          map.TrP[a1] = true
      end
  elseif cmd == "winpos" then
      Nx.Win:CoP(gsub(txt, "winpos%s*", ""))
  elseif cmd == "winshow" then
      Nx.Win:CoS(gsub(txt, "winshow%s*", ""))
  elseif cmd == "winsize" then
      Nx.Win:CoS1(gsub(txt, "winsize%s*", ""))
  elseif cmd == "gatherd" then
      NxData.NXDBGather = not NxData.NXDBGather
  elseif cmd == "herb" then
      UEv:AdH(strtrim(a1 .. " " .. a2))
  elseif cmd == "dbmapmax" then
      NxData.NXDBMapMax = not NxData.NXDBMapMax
  elseif cmd == "mine" then
      UEv:AdM(strtrim(a1 .. " " .. a2))
  elseif cmd == "addopen" then
      UEv:AdO(a1, a2)
  elseif cmd == "pro" then
      Nx.Tim:PrD()
  elseif cmd == "c" then
      Nx.Com1:Ope()
  elseif cmd == "cap" then
      Nx.CaI()
  elseif cmd == "crash" then
      assert()
  elseif cmd == "com" then
      Nx.Com.Lis:Ope()
  elseif cmd == "comd" then
      NxData.DeC = not NxData.DeC
      ReloadUI()
  elseif cmd == "comt" then
      Nx.Com:Tes(a1, a2)
  elseif cmd == "comver" then
      if NxData.NXVerDebug then
          Nx.Com:GUV()
      end
  elseif cmd == "d" then
      Nx.DebugOn = not Nx.DebugOn
  elseif cmd == "dock" then
      NxData.DebugDock = not NxData.DebugDock
  elseif cmd == "events" then
      UEv.Lis:Ope()
  elseif cmd == "g" then
      Nx.Gra:Cre(20, 50, UIParent)
      local g2 = Nx.Gra:Cre(200, 20, UIParent)
      g2.Frm:SetPoint("CENTER", 0, 100)
  elseif cmd == "item" then
      local id = format("Hitem:%s", a1)
      GameTooltip:SetOwner(UIParent, "ANCHOR_LEFT", 0, 0)
      GameTooltip:SetHyperlink(id)
      local nam, iLi, iRa, lvl, miL, type, suT, stC, eqL, tx = GetItemInfo(id)
      Nx.prt("Item: %s %s", nam or "nil", iLi or "")
  elseif cmd == "kill" then
      UEv:AdK(a1)
  elseif cmd == "loot" then
      Nx.LoO = not Nx.LoO
      Nx.prt("Loot %s", Nx.LoO and "On" or "Off")
  elseif cmd == "mapd" then
      NxData.DebugMap = not NxData.DebugMap
      ReloadUI()
  elseif cmd == "questclr" then
      Nx.Que:ClC()
  elseif cmd == "unitd" then
      NxData.DebugUnit = not NxData.DebugUnit
  elseif cmd == "vehpos" then
      Nx.Map:GeM(1):VDP()
  else
      Nx.prt("Unknown command")
  end
end
function Nx.Map:CMMW(frm, bx, by, w, h)
  local sca = self.ScD
  local bw = w * sca
  local bh = h * sca
  local clW = self.MaW
  local clH = self.MaH
  local x = (bx - self.MPXD) * sca + clW / 2
  local y = (by - self.MPYD) * sca + clH / 2
  local vx0 = x - bw * .5
  local vx1 = vx0
  local vx2 = vx0 + bw
  if vx1 < 0 or vx2 > clW then
      return false
  end
  w = vx2 - vx1
  if w <= 0 then
      return false
  end
  local vy0 = y - bh * .5
  local vy1 = vy0
  local vy2 = vy0 + bh
  if vy1 < 0 or vy2 > clH then
      return false
  end
  h = vy2 - vy1
  if h <= 0 then
      return false
  end
  local sc = w / 140
  self.MMFS = sc
  local isc = self.GOp["MapMMIScale"]
  self:MSS(sc, isc)
  frm:SetPoint("TOPLEFT", self.Frm, "TOPLEFT", vx1 / isc, (-vy1 - self.TiH) / isc)
  frm:Show()
  return true
end
function Nx.Sli:Get()
  return self.Pos
end
function Nx:NXOnLoad()
  SlashCmdList["Carbonite"] = Nx.slC
  SLASH_Carbonite1 = "/Carb"
  SLASH_Carbonite2 = "/Nx"
  self.Frm = this
  self.TiF = 0
  self.CCS = Nx.U_2(RAID_CLASS_COLORS)
  self:RegisterEvent("ADDON_LOADED", Nx.ADDON_LOADED)
  Nx.Tim:Ini()
  Nx.CaD = 0
end
function Nx:TTSTCZXY(con1, zon, zx, zy, nam, _persist, _minimap, _world, caT)
  local map = Nx.Map:GeM(1)
  local mid = map:GCMI()
  if con1 and zon then
      mid = map:CZ2MI(con1, zon)
  end
  local tar1 = map:STXY(mid, zx, zy, nam, true)
  map:CTO(-1, 1)
  if caT and caT["distance"] then
      local d = 99999
      local f
      for dis, fun in pairs(caT["distance"]) do
          if dis < d then
              d = dis
              f = fun
          end
      end
      tar1.Rad = d
      tar1.RaF = f
  end
  return tar1.UnI
end
function Nx:GIC1(typ)
  local not1 = Cartographer_Notes
  local dat = _G["Cartographer_" .. typ .. "DB"]
  if not dat then
      Nx.prt("Cartographer_%sDB missing", typ)
      return
  end
  if not not1 then
      Nx.prt("Cartographer notes missing")
      return
  end
  local gXY = not1["getXY"]
  if not gXY then
      Nx.prt("Cartographer getXY missing")
      return
  end
  local nTI = Nx.HNTI
  local gat1 = Nx.GaH
  if typ == "Mining" then
      nTI = Nx.MNTI
      gat1 = Nx.GaM
  end
  local imC = 0
  for zNa, zDa in pairs(dat) do
      if type(zDa) == "table" then
          local maI = Nx.MNTI1[zNa]
          if not maI then
              Nx.prt("Unknown zone %s", zNa)
          else
              for id, nam in pairs(zDa) do
                  local noI = nTI(Nx, nam)
                  if noI then
                      imC = imC + 1
                      local x, y = gXY(id)
                      gat1(Nx, noI, maI, x * 100, y * 100)
                  else
                      Nx.prt("Import unknown %s", nam)
                  end
              end
          end
      end
  end
  Nx.prt("Imported %s nodes", imC)
end
function Nx.Map:CoU(str)
  local fla, ta, tb, z1, x1a, x1b, y1a, y1b, z2, x2a, x2b, y2a, y2b, na1 = strbyte(str, 1, 14)
  fla = fla - 35
  local coT = (ta - 35) * 221 + tb - 35
  local mI1 = self.NTMI[z1 - 35]
  local mI2 = self.NTMI[z2 - 35]
  na1 = na1 - 35
  local na11 = na1 == 0 and "" or strsub(str, 15, 14 + na1)
  local i = 15 + na1
  local na2 = strbyte(str, i)
  local na21 = na2 == 0 and "" or strsub(str, i + 1, i + na2)
  local x1 = ((x1a - 35) * 221 + x1b - 35) / 100
  local y1 = ((y1a - 35) * 221 + y1b - 35) / 100
  local x2 = ((x2a - 35) * 221 + x2b - 35) / 100
  local y2 = ((y2a - 35) * 221 + y2b - 35) / 100
  return fla, coT, mI1, x1, y1, mI2, x2, y2, na11, na21
end
function Nx.U_25(col1)
  local rshift = bit.rshift
  local band = bit.band
  return format("|c%02x%02x%02x%02x", band(col1, 0xff), rshift(col1, 24), band(rshift(col1, 16), 0xff),
      band(rshift(col1, 8), 0xff))
end
function Nx.AuA.AuctionFrameBrowse_Update()
  if not Nx.ASBOP then
      return
  end
  local low = 99999999
  local loN
  local lIN
  local nBA, toA = GetNumAuctionItems("list")
  local off = FauxScrollFrame_GetOffset(BrowseScrollFrame)
  local las = off + NUM_BROWSE_TO_DISPLAY
  for n = 1, NUM_AUCTION_ITEMS_PER_PAGE do
      local nam, tex, cou, qua, caU, lev, miB, miI, buP, biA, hiB, own = GetAuctionItemInfo("list", n)
      local ind = n + NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse["page"]
      if ind > nBA + NUM_AUCTION_ITEMS_PER_PAGE * AuctionFrameBrowse["page"] then
          break
      end
      if biA == 0 then
          reB = miB
      else
          reB = biA + miI
      end
      if reB >= MAXIMUM_BID_PRICE then
          buP = reB
      end
      if buP > 0 then
          local pr1 = floor(buP / cou)
          if n > off and n <= las then
              local buN = "BrowseButton" .. (n - off)
              local itN = getglobal(buN .. "Name")
              if pr1 < low then
                  low = pr1
                  loN = nam
                  lIN = itN
              end
              if cou > 1 then
                  itN:SetText(format("%s *", nam))
                  local col = ITEM_QUALITY_COLORS[qua]
                  itN:SetVertexColor(col.r, col.g, col.b)
                  local bf = getglobal(buN .. "BuyoutFrameMoney")
                  if bf then
                      MoneyFrame_Update(bf:GetName(), pr1)
                  end
              end
          elseif pr1 < low then
              low = pr1
              loN = nil
          end
      end
  end
  if loN then
      lIN:SetText(format("%s * low", loN))
  end
end
function Nx.Opt:NXCmdResetWatchWinLayout()
  Nx.Que.Wat.Win1:ReL1()
end
function Nx.Fav:IM_OC()
  local fav = self.CuF
  if fav and self.CII then
      if fav[self.CII] then
          self.CoB = fav[self.CII]
          tremove(fav, self.CII)
      end
  end
  self:Upd()
end
function Nx.Inf:EOLE(evN, sel, va2, cli)
  local dat = self.Lis:IGD(sel)
end
function Nx.Fav:Upd()
  self.Dra1 = false
  local Nx = Nx
  if not self.Win1 then
      return
  end
  local lis = self.Lis
  lis:Emp()
  lis:ItA()
  lis:ItS(2, "|cff808080Root")
  self.FaC = 0
  self:UpF1(self.Fol, 1)
  lis:Upd()
  self:UpI1()
  self.Win1:SeT(format("Favorites: %s", self.FaC))
end
function Nx.Lis:FuU()
  local w = self.SSW
  self.SSW = nil
  self:SeS(w, self.SSH)
end
function Nx.UEv.SoC(v1, v2)
  v1.NXTime = v1.NXTime or 0
  v2.NXTime = v2.NXTime or 0
  return v1.NXTime < v2.NXTime
end
function Nx.NXMiniMapBut:ToP1()
  RegisterCVar("scriptProfile")
  local var = GetCVar("scriptProfile")
  var = var == "0" and "1" or "0"
  SetCVar("scriptProfile", var)
  ReloadUI()
end
function Nx.Tim:POU()
end
function Nx:InC1()
  local cha = NxData.Characters
  local fuN = GetRealmName() .. "." .. UnitName("player")
  local ch = cha[fuN]
  if not ch or ch.Version < Nx.VERSIONCHAR then
      ch = {}
      cha[fuN] = ch
      ch.Version = Nx.VERSIONCHAR
      ch.E = {}
      ch.Q = {}
  end
  Nx.CuC = ch
  ch["Opts"] = ch["Opts"] or {}
  Nx.ChO = ch["Opts"]
  ch["L"] = ch["L"] or {}
  ch.W = ch.W or {}
  if not ch["TBar"] then
      ch["TBar"] = {}
  end
  ch["Profs"] = ch["Profs"] or {}
  ch["Professions"] = nil
  if not ch.E["Info"] then
      ch.E["Info"] = {}
  end
  if not ch.E["Death"] then
      ch.E["Death"] = {}
  end
  if not ch.E["Kill"] then
      ch.E["Kill"] = {}
  end
  if not ch.E["Herb"] then
      ch.E["Herb"] = {}
  end
  if not ch.E["Mine"] then
      ch.E["Mine"] = {}
  end
  self:DOE()
  ch.NXLoggedOnNum = ch.NXLoggedOnNum or 0 + 1
  local cd = NxCData
  if not cd or cd.Version < Nx.VERSIONCD then
      cd = {}
      NxCData = cd
      cd.Version = Nx.VERSIONCD
      cd["Taxi"] = {}
  end
  self:CRC()
end
function Nx.Men:I_SUS(ite, x)
  local old = ite:GeS1()
  ite:SeS2(x)
  if ite:GeS1() ~= old then
      Nx.Men:SlU(ite)
      if ite.Fun then
          ite.Fun(ite.Use, ite, ite.Use)
      end
  end
end
function Nx.Map:M_OW()
  for _, nam in pairs(Nx.Map.PlN1) do
      local frm = DEFAULT_CHAT_FRAME
      local eb = frm["editBox"]
      if not eb:IsVisible() then
          ChatFrame_OpenChat("/w " .. nam, frm)
      else
          eb:SetText("/w " .. nam .. " " .. eb:GetText())
      end
      break
  end
end
function Nx.Sec:Sta()
  Nx.Tim:Sta(0, .1, self, self.VaT)
end
function Nx.Gra:OnE1(mot)
  if not GameTooltip:IsOwned(this) and this.NGP then
      local self = this.NxG
      Nx.ToO = this
      GameTooltip:SetOwner(this, "ANCHOR_CURSOR")
      local v = self.Val
      local str = format("%.2f: %s", v[-this.NGP], v[this.NGP + 0x2000000])
      GameTooltip:SetText(str)
      GameTooltip:Show()
  end
end
function Nx.Fav:M_OR1(ite)
  local function fun(str, self)
      if self.CFOF then
          self.CFOF["Name"] = str
          self:Upd()
      end
  end
  if self.CFOF then
      local nam = self.CFOF["Name"]
      Nx:SEB("Name", nam, self, fun)
  end
end
function Nx.Que:PSS()
  if GetNumRaidMembers() > 0 or GetNumPartyMembers() == 0 then
      return
  end
  if self.GOp["QPartyShare"] then
      Nx.Tim:Sta("QSendParty", .5, self, self.PBSD)
  end
end
function Nx.Hel.Lic:OnS(sli, pos1)
  self.Top = floor(pos1)
  self.Frm:SetPoint("TOPLEFT", 0, self.Top)
end
function Nx.Tim:SeF(nam, fun)
  if self.Dat[nam] then
      self.Dat[nam].F = fun
  end
end
function Nx.War:M_OSBR(ite)
  self.SBR = ite:GetChecked()
  self:Upd()
end
function Nx.Que:PUT()
  self:ReQ1()
  self.Wat:Upd()
end
function Nx.Map:GRMI()
  local zNa = GetRealZoneText()
  local maI = Nx.MNTI1[zNa] or 9000
  local suT1 = self.MSN[zNa]
  if suT1 then
      if suT1[GetSubZoneText()] then
          return self.MWI[maI].L2I or maI
      end
  end
  return maI
end
function Nx.Map:MTTI(fst, ico, ox, oy)
  local f = ico
  local atP, reT, reP, x, y = f:GetPoint()
  fst:SetPoint("TOPLEFT", x + ox, y - oy)
  fst:Show()
end
function Nx.Fav:Rec1(typ, nam, id, x, y)
  if self.IUT then
      return
  end
  local fav = self.Rec
  self.ReI = id
  self.ReX = x
  self.ReY = y
  if typ == "Note" then
      local function fun(nam, self)
          local fav = self.Rec or self:GNF(self.ReI)
          local s = self:CrI("N", 0, nam, 1, self.ReI, self.ReX, self.ReY)
          self:AdI1(fav, self.CII, s)
          self:Upd()
      end
      Nx:SEB("Name", nam, self, fun)
  elseif typ == "TargetS" then
      local fav = self.Rec
      if fav then
          local s = self:CrI("T", 0, nam, self.ReI, self.ReX, self.ReY)
          self:AdI1(fav, self.CII, s)
          self:Upd()
      end
  elseif typ == "Target" then
      local fav = self.Rec
      if fav then
          local s = self:CrI("t", 0, nam, self.ReI, self.ReX, self.ReY)
          self:AdI1(fav, self.CII, s)
          self:Upd()
      end
  end
end
function Nx.Que.Wat:M_ORAW(ite)
  local cur1 = Nx.Que.CuQ
  for n = 1, cur1 and #cur1 or 0 do
      local cur = cur1[n]
      self:ReW(cur.QId, cur.QI)
  end
  self:Upd()
  Nx.Que.Lis:Upd()
end
function Nx.Map:HEI()
  local frm1 = self.IcF
  for n = frm1.Nex, frm1.Use1 do
      frm1[n]:Hide()
  end
  local frm1 = self.INIF
  for n = frm1.Nex, frm1.Use1 do
      frm1[n]:Hide()
  end
  local frm1 = self.ISF1
  for n = frm1.Nex, frm1.Use1 do
      frm1[n]:Hide()
  end
  local dat = self.TFS2
  for n = dat.Nex, dat.Use1 do
      dat[n]:Hide()
  end
end
function Nx.Com:RcV(nam, msg)
  if NxData.NXVerDebug then
      local ver, r, c, dt, ve1, qCn, lvl, maI = strsplit("^", msg)
      ver = tonumber(strsub(ver, 5))
      lvl = tonumber(lvl or 0, 16)
      maI = tonumber(maI or 0, 16)
      Nx.prt("Ver %s %s (%s) %s %s %s Q%s L%s %s", nam, ver, ve1 or "", r, c, dt, qCn or "", lvl, maI)
      if ver >= 1.191 and ver < 1.5 or ver >= 1.6 then
          self.VeP[nam] = msg
          Nx.Soc.Lis:Upd()
      end
  end
end
function Nx.Map.Minimap_ZoomOutClick()
  local map = Nx.Map:GeM(1)
  map:MiZ(-2)
end
function Nx.HideUIPanel(fra)
  if fra then
      local opt = Nx:GGO()
      if fra == getglobal("FriendsFrame") and opt["SocialEnable"] then
          Nx.Soc:HideUIPanel(fra)
      elseif fra == getglobal("QuestLogFrame") then
          Nx.Que:HideUIPanel(fra)
      end
  end
end
function Nx.MapAddIconPoint(icT, maN, x, y, tex)
  local map = Nx.Map:GeM(1)
  local maI = Nx.MNTI1[maN]
  if maI then
      local wx, wy = map:GWP(maI, x, y)
      map:AIP(icT, wx, wy, nil, tex)
  end
end
function Nx.Que.Lis:DSW(w)
  if Nx.V33 then
      QuestInfoObjectivesText:SetWidth(w)
      QuestInfoDescriptionText:SetWidth(w)
      QuestInfoItemChooseText:SetWidth(w)
  end
end
function Nx.Inf:OpU()
  local opt = Nx:GGO()
  local loc1 = opt["IWinLock"]
  for i, inf in pairs(self.Inf1) do
      local win = inf.Win1
      if win then
          win:SBGA(0, 1)
          if loc1 then
              win:Loc1(true, true)
          else
              win:Loc1(false, true)
          end
          inf.Lis:Loc1(loc1)
          local cr, cg, cb, ca = Nx.U_23(opt["IWinListCol"])
          inf.Lis:SBGC(cr, cg, cb, ca, true)
      end
  end
end
function Nx.Inf:CaC2()
  if UnitCastingInfo("player") or UnitChannelInfo("player") then
      return
  end
  local GetActionCooldown = GetActionCooldown
  for n = 1, 120 do
      local sta2, dur = GetActionCooldown(n)
      if dur > 0 and dur <= 1.5 then
          local low = dur - (GetTime() - sta2)
          return "|cffc0c020", string.rep(".", low * 10)
      end
  end
end
function Nx.Fav:AdF2(nam, par, ind)
  local fav = {}
  fav["Name"] = nam
  par = par or self.Fol
  if par then
      ind = ind or #par + 1
      tinsert(par, ind, fav)
  end
  return fav
end
function Nx.Map.Gui:ASF(fol, remove, fil2)
  if type(fol) == "table" then
      local typ, fil1 = self:CaT2(fol)
      fil2 = fil2 or fil1 and typ
      if fil2 and typ ~= fil2 and not remove then
          typ = nil
      end
      if typ then
          self.ShF[typ] = not remove and fol or nil
      end
      if remove or not fol.NSC then
          for shT, chF1 in ipairs(fol) do
              self:ASF(chF1, remove, fil2)
          end
      end
  end
end
function Nx.Win:Att(chF, pX1, pX2, pY1, pY2, wid, hei)
  local f = self.Frm
  if not pX1 then
      pX1 = 0
      pX2 = 1
      pY1 = 0
      pY2 = 1
  end
  local chi
  for i, ch in ipairs(self.ChF) do
      if ch.Frm == chF then
          chi = ch
          break
      end
  end
  if not chi then
      chi = {}
      tinsert(self.ChF, chi)
      chi.Frm = chF
      chF:SetParent(f)
  end
  chi.PX1 = pX1
  chi.PX2 = pX2
  chi.PY1 = pY1
  chi.PY2 = pY2
  if wid then
      chi.ScW = wid
      chi.ScH = hei
  end
  self:Adj()
end
function Nx.Map:OMNGT(nam)
  self.MMF:SetBlipTexture("Interface\\AddOns\\Carbonite\\Gfx\\Map\\MMOIcons")
  Nx.Tim:SeF(nam, self.OMNGTG)
  return self.GOp["MapMMNodeGD"] / 2
end
function Nx.NXMiniMapBut:OpM()
  if self.Men then
      self.Men:Ope()
  end
end
function Nx.Com:PLGP(nam, msg)
  if strbyte(msg) == 0x50 then
      local x, x2, y, y2, len = strbyte(msg, 2, 6)
      if len and len > 1 then
          x = ((x - 1) * 255 + x2 - 1) / (255 ^ 2) * 100
          y = ((y - 1) * 255 + y2 - 1) / (255 ^ 2) * 100
          local zoN = strsub(msg, 7, 5 + len)
          local maI = Nx.MOTMI[strlower(zoN)]
          if maI then
              local inf = self.PaI[nam]
              if not inf then
                  inf = {}
                  self.PaI[nam] = inf
              end
              inf.T = GetTime()
              inf.MId = maI
              inf.EMI = maI
              inf.X = x
              inf.Y = y
              inf.F = 0
              inf.Tip = nam
          end
      end
  end
end
function Nx.Que:ExQ()
  repeat
      local fou = false
      local cnt = GetNumQuestLogEntries()
      for qn = 1, cnt do
          local tit, lev, tag, grC, isH, isC = GetQuestLogTitle(qn)
          if isH and isC then
              local he = self.HeE
              he[tit] = true
              ExpandQuestHeader(qn)
              fou = true
              break
          end
      end
  until not fou
end
function Nx.Hel:SCT()
  if _G["Cartographer3"] then
      Nx.prt("\n|cffffff00Cartographer 3 may conflict with Carbonite\nThis can cause BLAH! to appear")
  end
end
function Nx:LoI()
  local opt = Nx:GGO()
  local loc = GetLocale()
  if not opt["LoginHideVer"] then
      Nx.prt(" %s", loc)
  end
  if loc ~= "deDE" and loc ~= "frFR" and loc ~= "esES" and loc ~= "esMX" then
      loc = "enUS"
  end
  Nx.Loc = loc
end
function Nx.Map:AIR(icT, maI, x, y, x2, y2, col)
  local d = self.Dat
  assert(d[icT])
  local tda = d[icT]
  tda.Num = tda.Num + 1
  local ico = {}
  tda[tda.Num] = ico
  ico.MaI = maI
  ico.X = x
  ico.Y = y
  ico.X2 = x2
  ico.Y2 = y2
  ico.Col1 = col
  return ico
end
function Nx.Que.Wat:FiC4()
  Nx.Win:CSD("NxQuestWatch")
end
function Nx.Inf:Del1(ind)
  NxData.NXInfo[ind] = nil
  local inf = self.Inf1[ind]
  if inf then
      inf.Win1:Show(false)
  end
  inf.Dat = nil
  Nx.Win:CSD("NxInfo" .. ind)
end
function Nx.Map:M_OO(ite)
  Nx.Opt:Ope("Map")
end
function Nx.Que.Lis:M_OG(ite)
  local i = self.Lis:IGD()
  if i then
      local qIn = bit.band(i, 0xff)
      if qIn > 0 then
          Nx.prt("Already have the quest!")
      else
          local qId = bit.rshift(i, 16)
          Nx.Que:Got(qId)
          self:Upd()
      end
  end
end
function Nx.Win:OnU(ela)
  local win = this.NxW
  local seO = not (win.Sec1 and InCombatLockdown())
  if win.DMU and seO then
      win.DMU = nil
      win:SFS(win.SaD[win.LaM .. "L"])
      this:Raise()
  end
  if win.MoS and seO then
      if IsAltKeyDown() then
          Nx.U_STS(this)
      end
  end
  if win.CIS then
      win.CIS = false
      ResetCursor()
  end
  local x = not win.FuL and Nx.U_IMO(this)
  if x then
      if GetMouseFocus() == this then
          local x, y = GetCursorPosition()
          x = x / this:GetEffectiveScale()
          y = y / this:GetEffectiveScale()
          local sid = win:IOWUI(x, y)
          if sid == 0 then
              SetCursor("ITEM_CURSOR")
              win.CIS = true
          elseif sid > 0 then
              SetCursor("INTERACT_CURSOR")
              win.CIS = true
          end
      end
  end
  if (x or win.Siz1) and seO then
      win:Adj()
      win.BFT = win.BFI
  else
      win.BFT = win.BFO
  end
  local fad2 = Nx.U_SV(win.BaF, win.BFT, ela * 2)
  if fad2 ~= win.BaF then
      if win.UUF then
          win.UUF(win.Use, fad2)
      end
      win.BaF = fad2
      local a = fad2 * win.BAD + win.BAM
      if this.tex then
          this.tex:SetVertexColor(1, 1, 1, a)
      else
          local col2 = Nx.Ski:GBGC()
          if not win.Siz and win.Bor1 then
              col2 = Nx.Ski:GFSBGC()
          end
          this:SetBackdropColor(col2[1], col2[2], col2[3], col2[4] * a)
      end
      if not win.Loc2 then
          win:SBF(fad2)
      end
      if win.BuC then
          win.BuC.Frm:SetAlpha(fad2 * .9 + .1)
      end
      if win.BuM then
          win.BuM.Frm:SetAlpha(fad2 * .9 + .1)
      end
      if win.BuM1 then
          win.BuM1.Frm:SetAlpha(fad2 * .9 + .1)
      end
      for n = 1, #win.ChF do
          local chi = win.ChF[n]
          local cf = chi.Frm
          local ins = cf.NxI
          if ins and ins.SeF1 then
              ins:SeF1(fad2)
          else
              if cf.tex then
                  cf.tex:SetVertexColor(1, 1, 1, fad2 * .7 + .3)
              end
          end
      end
  end
end
function Nx.Map:BPL()
  local Map = Nx.Map
  Map.PlN1 = {}
  Map.AFK1 = {}
  local tiS = ""
  local frm1 = self.IcF
  local f
  local cnt = 0
  for n = 1, frm1.Nex - 1 do
      f = frm1[n]
      local ply = f.NXType == 1000 and f.NXData2
      if ply then
          local x, y = Nx.U_IMO(f)
          if x then
              tinsert(Map.PlN1, ply)
              if f.NXData then
                  tinsert(Map.AFK1, f.NXData)
              end
          end
      end
  end
  if #Map.PlN1 >= 2 then
      tiS = format("\n\n|cff00cf00%s players:", #Map.PlN1)
      sort(Map.PlN1)
      for _, nam in ipairs(Map.PlN1) do
          tiS = tiS .. "\n" .. nam
      end
  end
  Map.PNTS = tiS
end
function Nx.But:SeS3(sta1)
  self.Sta2 = sta1
  self:Upd()
end
function Nx.Com:UCT()
  if Nx.Tim:IsA("ComLogin") then
      return 0
  end
  local opt = Nx:GGO()
  local cMI = Nx.Map:GRMI()
  if UnitIsAFK("player") or opt["ComNoZone"] then
      cMI = nil
  else
      if Nx.Map:INM(cMI) then
          local zs = self.ZSt[cMI] or {}
          zs.Joi = true
          self.ZSt[cMI] = zs
      end
  end
  for maI, mod1 in pairs(self.ZMo) do
      if mod1 == 0 then
          self.ZMo[maI] = 1
          local zs = self.ZSt[maI] or {}
          zs.Joi = true
          self.ZSt[maI] = zs
      elseif mod1 == -1 then
          self.ZMo[maI] = nil
      end
  end
  for maI, sta in pairs(self.ZSt) do
      if sta.ChN then
          if cMI ~= maI and not self.ZMo[maI] then
              sta.Lea = true
          end
      end
      if sta.Lea then
          sta.Lea = false
          Nx.Tim:Sto("ComZ" .. maI)
          if sta.ChN then
              LeaveChannelByName(sta.ChN)
          end
      end
      if sta.Joi then
          sta.Joi = false
          if not sta.ChN then
              local tiN = "ComZ" .. maI
              if not Nx.Tim:IsA(tiN) then
                  local tim = Nx.Tim:Sta(tiN, 2, self, self.OJCZT)
                  tim.UMI = maI
                  tim.UTC = 0
              end
          end
      end
  end
end
function Nx.Map:CFW(frm, bx, by, w, h, dir)
  local bw = w
  local bh = h
  local clW = self.MaW
  local clH = self.MaH
  local sca = self.ScD
  local x = (bx - self.MPXD) * sca + clW / 2
  local y = (by - self.MPYD) * sca + clH / 2
  local tX1 = 0
  local tX2 = 1
  local vx0 = x - bw * .5
  local vx1 = vx0
  local vx2 = vx0 + bw
  if vx1 < 0 then
      vx1 = 0
      tX1 = (vx1 - vx0) / bw
  end
  if vx2 > clW then
      vx2 = clW
      tX2 = (vx2 - vx0) / bw
  end
  w = vx2 - vx1
  if w < .3 then
      if self.ScF1 ~= frm then
          frm:Hide()
      else
          frm:SetWidth(.001)
      end
      return false
  end
  local tY1 = 0
  local tY2 = 1
  local vy0 = y - bh * .5
  local vy1 = vy0
  local vy2 = vy0 + bh
  if vy1 < 0 then
      vy1 = 0
      tY1 = (vy1 - vy0) / bh
  end
  if vy2 > clH then
      vy2 = clH
      tY2 = (vy2 - vy0) / bh
  end
  h = vy2 - vy1
  if h < .3 then
      if self.ScF1 ~= frm then
          frm:Hide()
      else
          frm:SetWidth(.001)
      end
      return false
  end
  frm:SetPoint("TOPLEFT", vx1, -vy1 - self.TiH)
  frm:SetWidth(w)
  frm:SetHeight(h)
  if dir == 0 then
      frm.tex:SetTexCoord(tX1, tX2, tY1, tY2)
  else
      local t1x, t1y, t2x, t2y, t3x, t3y, t4x, t4y
      tX1 = tX1 - .5
      tX2 = tX2 - .5
      tY1 = tY1 - .5
      tY2 = tY2 - .5
      local co = cos(dir)
      local si = sin(dir)
      t1x = tX1 * co + tY1 * si + .5
      t1y = tX1 * -si + tY1 * co + .5
      t2x = tX1 * co + tY2 * si + .5
      t2y = tX1 * -si + tY2 * co + .5
      t3x = tX2 * co + tY1 * si + .5
      t3y = tX2 * -si + tY1 * co + .5
      t4x = tX2 * co + tY2 * si + .5
      t4y = tX2 * -si + tY2 * co + .5
      frm.tex:SetTexCoord(t1x, t1y, t2x, t2y, t3x, t3y, t4x, t4y)
  end
  frm:Show()
  return true
end
function Nx.Map.Doc:MDF1()
  if Nx.Tic % self.UpM1 ~= 0 then
      return
  end
  if not self.Win1 then
      return
  end
  self.UpM1 = 30
  if NxData.DebugDock then
      Nx.prt("Dock %s", #self.MMF1)
  end
  local mm = getglobal("Minimap")
  local mmC = getglobal("TimeManagerClockButton")
  local win = self.Win1
  local win2 = win.Frm
  local buL = win2:GetFrameLevel() + 1
  local cLv = buL + 1
  local sCL = Nx.U_SCL
  local str1 = win2:GetFrameStrata()
  local min4 = self.GOp["MMButWinMinimize"]
  local cx, cy = win:GCO()
  local cw, ch = win:GeS2()
  local coC = min4 and 1 or self.GOp["MapMMButColumns"]
  local coS1 = 0
  local coE = coC - 1
  local coA = 1
  local spa1 = self.GOp["MapMMButSpacing"]
  local yAd = spa1
  local y = cy + 6
  local s = self.GOp["MapMMButCorner"]
  if s == "TopRight" or s == "BottomRight" then
      coE = -coE
      coA = -1
  end
  if s == "BottomLeft" or s == "BottomRight" then
      yAd = -yAd
      y = cy - 6
  end
  local col3 = coS1
  local boS = win:GBS()
  local baX = boS + 17
  local baY = y
  local inR
  for n, f in ipairs(self.MMF1) do
      if f:IsVisible() then
          local w = f:GetWidth()
          if w > 0 then
              local sc = 32 / max(w, 32)
              if inR then
                  inR = false
                  col3 = coS1
                  y = y + yAd
              end
              if min4 and n > 1 then
                  col3 = 0
                  y = baY
                  buL = 1
                  cLv = 1
                  sc = .1
              end
              local x = baX + col3 * spa1
              f:SetParent(win2)
              f:ClearAllPoints()
              if f == mmC then
                  sc = sc * 1.5
              end
              f:SetPoint("CENTER", win2, "TOPLEFT", x / sc, -y / sc)
              f:SetScale(sc)
              f:SetFrameStrata(str1)
              f:SetFrameLevel(buL)
              sCL(f, cLv)
              if col3 == coE then
                  inR = true
              end
              col3 = col3 + coA
          end
      elseif f:IsShown() then
          f:Show()
      end
  end
  if not win.MoS then
      local x = win2:GetLeft()
      win:SeS(34, 11)
  end
end
function Nx.U_GTEMSS(sec1)
  return format("%d:%02d", sec1 / 60 % 60, sec1 % 60)
end
function Nx.Que.GetQuestReward(cho, ...)
  local q = Nx.Que
  q:FiQ()
  q.BGQR(cho, ...)
end
function Nx.Com:SPV(nam)
  self:SSW1("V?", "", nam)
end
function Nx.Opt:NXCmdQWHideRaid()
  Nx.Que.Wat.Win1.Frm:Show()
end
function Nx.Que:OPM(plN, msg)
  if not self.GOp["QPartyShare"] then
      return
  end
  local pq = self.PaQ
  local pl = pq[plN]
  if pl then
      if strbyte(msg, 3) == 49 then
          pl = {}
          pq[plN] = pl
      end
      local Que = Nx.Que
      local off1 = 4
      for n = 1, 99 do
          if #msg < off1 + 5 then
              break
          end
          local qId = tonumber(strsub(msg, off1, off1 + 3), 16) or 0
          local flg, oCn = strbyte(msg, off1 + 4, off1 + 5)
          flg = flg - 35
          oCn = oCn - 35
          if #msg < off1 + 5 + oCn * 4 then
              break
          end
          local que = self.ITQ[qId]
          if que then
              local q = pl[qId] or {}
              pl[qId] = q
              q.Com2 = bit.band(flg, 1) == 1 and 1 or nil
              for i = 1, oCn do
                  local o = off1 + 6 + (i - 1) * 4
                  local cnt = tonumber(strsub(msg, o, o + 1), 16) or 0
                  local tot = tonumber(strsub(msg, o + 2, o + 3), 16) or 0
                  q[i] = cnt
                  q[i + 100] = tot
              end
          end
          off1 = off1 + 6 + oCn * 4
      end
  end
  Nx.Tim:Sta("QPartyUpdate", .7, self, self.PUT)
end
function Nx.Map:OBSD2(but1, cli, x, y)
  self.DAS = self.DAS + x * .001
  Nx.prt("Adj scale %s", self.DAS)
end
function Nx.Que.Lis:MDL(cur, id, deb)
  local qId = cur and cur.QId or id
  local Que = Nx.Que
  local que = cur and cur.Q or Que.ITQ[qId]
  local tit = cur and cur.Tit
  local reL = cur and cur.ReL2
  if que then
      local s
      s, _, reL = Que:Unp(que[1])
      tit = tit or s
  end
  local lev = reL
  if reL <= 0 then
      lev = UnitLevel("player")
  end
  local s = Que:CrL(qId, reL, tit)
  local opt = Nx:GGO()
  if que and opt["QShowLinkExtra"] then
      local par2 = Que:GPT1(que, cur)
      s = format(" [%s] %s%s", lev, s, par2)
  else
      s = format(" %s", s)
  end
  if deb then
      local fac2 = strsub(UnitFactionGroup("player"), 1, 1)
      s = format("%s[%s %d]", s, fac2, qId)
  end
  return s
end
function Nx:Tim1()
  self.TiF = self.TiF + .000001
  return time() + self.TiF
end
function Nx.Map:CCM(maI)
  local map = self.Map1[1]
  map:CeM(maI)
end
function Nx.Tit:Ini()
  local f = CreateFrame("Frame", nil, UIParent)
  f.NxI = self
  self.Frm = f
  f:SetFrameStrata("HIGH")
  f:SetWidth(400)
  f:SetHeight(192)
  local bk = {
      ["bgFile"] = "Interface\\Buttons\\White8x8",
      ["edgeFile"] = "Interface\\DialogFrame\\UI-DialogBox-Border",
      ["tile"] = true,
      ["tileSize"] = 16,
      ["edgeSize"] = 16,
      ["insets"] = {
          ["left"] = 2,
          ["right"] = 2,
          ["top"] = 2,
          ["bottom"] = 2
      }
  }
  f:SetBackdrop(bk)
  f:SetBackdropColor(0, 0, .1, 1)
  local lf = CreateFrame("Frame", nil, f)
  lf:SetWidth(256)
  lf:SetHeight(128)
  lf:SetPoint("CENTER", 0, 0)
  local t = lf:CreateTexture()
  t:SetTexture(Nx.Hel.Log)
  t:SetAllPoints(lf)
  lf.tex = t
  for n = 1, 2 do
      local fst = f:CreateFontString()
      self["NXFStr" .. n] = fst
      fst:SetFontObject("GameFontNormal")
      fst:SetJustifyH("CENTER")
      fst:SetPoint("TOPLEFT", 0, -158 - (n - 1) * 14)
      fst:SetWidth(400)
      fst:Show()
  end
  local str
  if Nx.VERMINOR > 0 then
      str = NXTITLEFULL .. " |cffe0e0ffVersion %.6f Build %d"
  else
      str = NXTITLEFULL .. " |cffe0e0ffVersion %.3f Build %d"
  end
  str = format(str, Nx.VERSION, Nx.BUILD)
  self.NXFStr1:SetText(str)
  self.NXFStr2:SetText("|cffe0e0ffCopyright 2007-2010 Carbon Based Creations, LLC")
  Nx.Pro:New(self, self.TiW, 40)
end
function Nx.Opt:NXCmdResetOpts()
  local function fun()
      local self = Nx.Opt
      self:Res()
      self:Upd()
      Nx.Ski:Set()
      Nx.Fon:Upd()
      Nx.Que:OpR()
      Nx.Que:CWC()
      self:NXCmdHUDChange()
      self:NXCmdGryphonsUpdate()
      self:NXCmdInfoWinUpdate()
      self:NXCmdUIChange()
  end
  Nx:ShM("Reset options?", "Reset", fun, "Cancel")
end
function Nx.U_TFII(t, ite)
  for i, v in ipairs(t) do
      if v == ite then
          return i
      end
  end
end
function Nx.Map:SeO(ind, nam, val1)
  local map = Nx.Map.Map1[ind]
  local opt = NxMapOpts.NXMaps[ind]
  local id = map.RMI
  id = opt[id] and id or 0
  opt[id][nam] = val1
end
function Nx.Map:RoO(rou)
  local swa
  for len = #rou - 2, 2, -1 do
      for n = 1, #rou - len - 1 do
          local r1 = rou[n]
          local r2 = rou[n + 1]
          local n2 = n + len
          local r3 = rou[n2]
          local r4 = rou[n2 + 1]
          if r1.Dis + r3.Dis > ((r1.X - r3.X) ^ 2 + (r1.Y - r3.Y) ^ 2) ^ .5 + ((r2.X - r4.X) ^ 2 + (r2.Y - r4.Y) ^ 2) ^
              .5 then
              self:RoS(rou, n + 1, len)
              swa = true
          end
      end
  end
  return swa
end
function Nx.prC(msg, ...)
end
function Nx.But:OMD(but)
  local but1 = this.NxB
  if but == "LeftButton" or but == "MiddleButton" then
      if but1.Typ.Boo then
          but1.Pre = not but1.Pre
          if but1.UsF then
              but1.UsF(but1.Use, but1, but1.Id, but)
          end
      elseif but1.Typ.Sta1 then
          but1.Sta2 = but1.Sta2 % but1.Typ.Sta1 + 1
          if but1.UsF then
              but1.UsF(but1.Use, but1, but1.Id, but)
          end
      else
          but1.Pre = true
      end
  end
  if but1.Typ.Scr1 then
      local x, y = GetCursorPosition()
      but1.ScX = x / this:GetEffectiveScale()
      but1.ScY = y / this:GetEffectiveScale()
      but1.Scr2 = true
      return
  elseif but == "RightButton" then
      if but1.UsF then
          but1.UsF(but1.Use, but1, but1.Id, but)
      end
  end
  but1:Upd()
end
function Nx.Win:M_OL(ite)
  self.MeW:Loc1(ite:GetChecked())
end
function Nx.Que:UQDT()
  if Nx.V33 then
      QuestInfo_Display(QUEST_TEMPLATE_LOG, NXQuestLogDetailScrollChildFrame, nil, nil, "Carb")
      local r, g, b, a = Nx.U_23(self.GOp["QDetailBC"])
      self.Lis.DeF.tex:SetTexture(r, g, b, a)
      local r, g, b = Nx.U_23(self.GOp["QDetailTC"])
      local t = {"QuestInfoTitleHeader", "QuestInfoDescriptionHeader", "QuestInfoObjectivesHeader",
                 "QuestInfoRewardsHeader", "QuestInfoDescriptionText", "QuestInfoObjectivesText",
                 "QuestInfoGroupSize", "QuestInfoRewardText", "QuestInfoItemChooseText", "QuestInfoItemReceiveText",
                 "QuestInfoSpellLearnText", "QuestInfoHonorFrameReceiveText", "QuestInfoArenaPointsFrameReceiveText",
                 "QuestInfoTalentFrameReceiveText", "QuestInfoXPFrameReceiveText"}
      for k, nam in ipairs(t) do
          _G[nam]:SetTextColor(r, g, b)
      end
      for n = 1, 10 do
          _G["QuestInfoObjective" .. n]:SetTextColor(r, g, b)
      end
      return
  end
  QuestFrame_SetAsLastShown(NxQuestDSC, NxQuestDSCSpacerFrame)
  Nx.Que:FI_U()
  local qID = GetQuestLogSelection()
  local quT2 = GetQuestLogTitle(qID) or ""
  if IsCurrentQuestFailed() then
      quT2 = quT2 .. " - (" .. FAILED .. ")"
  end
  local tit = NxQuestDSCQuestTitle
  tit:SetText(quT2)
  local _, reT = NxQuestDSCSpacerFrame:GetPoint()
  local cor = reT == NxQuestDSC and "TOP" or "BOTTOM"
  tit:ClearAllPoints()
  tit:SetPoint("TOP", reT, cor, 0, -10)
  tit:SetPoint("LEFT", NxQuestDSC, "LEFT", 0, 0)
  local quD, quO = GetQuestLogQuestText()
  NxQuestDSCObjectivesText:SetText(quO)
  local quT3 = GetQuestLogTimeLeft()
  if quT3 then
      NxQuestDSCTimerText:Show()
      NxQuestDSCTimerText:SetText(TIME_REMAINING .. " " .. SecondsToTime(quT3))
      NxQuestDSCObjective1:SetPoint("TOPLEFT", "NxQuestDSCTimerText", "BOTTOMLEFT", 0, -10)
  else
      NxQuestDSCTimerText:Hide()
      NxQuestDSCObjective1:SetPoint("TOPLEFT", "NxQuestDSCObjectivesText", "BOTTOMLEFT", 0, -10)
  end
  local nuO = GetNumQuestLeaderBoards()
  for i = 1, nuO do
      local string = getglobal("NxQuestDSCObjective" .. i)
      local tex1, typ, fin = GetQuestLogLeaderBoard(i)
      if not tex1 or strlen(tex1) == 0 then
          tex1 = typ
      end
      if fin then
          string:SetTextColor(.2, .2, .2)
          tex1 = tex1 .. " (" .. COMPLETE .. ")"
      else
          string:SetTextColor(0, 0, 0)
      end
      string:SetText(tex1)
      string:Show()
      QuestFrame_SetAsLastShown(string, NxQuestDSCSpacerFrame)
  end
  for i = nuO + 1, MAX_OBJECTIVES, 1 do
      getglobal("NxQuestDSCObjective" .. i):Hide()
  end
  if GetQuestLogRequiredMoney() > 0 then
      if nuO > 0 then
          NxQuestDSCRequiredMoneyText:SetPoint("TOPLEFT", "NxQuestDSCObjective" .. nuO, "BOTTOMLEFT", 0, -4)
      else
          NxQuestDSCRequiredMoneyText:SetPoint("TOPLEFT", "NxQuestDSCObjectivesText", "BOTTOMLEFT", 0, -10)
      end
      MoneyFrame_Update("NxQuestDSCRequiredMoneyFrame", GetQuestLogRequiredMoney())
      if GetQuestLogRequiredMoney() > GetMoney() then
          NxQuestDSCRequiredMoneyText:SetTextColor(0, 0, 0)
          SetMoneyFrameColor("NxQuestDSCRequiredMoneyFrame", 1, .1, .1)
      else
          NxQuestDSCRequiredMoneyText:SetTextColor(.2, .2, .2)
          SetMoneyFrameColor("NxQuestDSCRequiredMoneyFrame", 1, 1, 1)
      end
      NxQuestDSCRequiredMoneyText:Show()
      NxQuestDSCRequiredMoneyFrame:Show()
  else
      NxQuestDSCRequiredMoneyText:Hide()
      NxQuestDSCRequiredMoneyFrame:Hide()
  end
  if GetQuestLogGroupNum() > 0 then
      local sGS = format(QUEST_SUGGESTED_GROUP_NUM, GetQuestLogGroupNum())
      NxQuestDSCSuggestedGroupNum:SetText(sGS)
      NxQuestDSCSuggestedGroupNum:Show()
      NxQuestDSCSuggestedGroupNum:ClearAllPoints()
      if GetQuestLogRequiredMoney() > 0 then
          NxQuestDSCSuggestedGroupNum:SetPoint("TOPLEFT", "NxQuestDSCRequiredMoneyText", "BOTTOMLEFT", 0, -4)
      elseif nuO > 0 then
          NxQuestDSCSuggestedGroupNum:SetPoint("TOPLEFT", "NxQuestDSCObjective" .. nuO, "BOTTOMLEFT", 0, -4)
      elseif quT3 then
          NxQuestDSCSuggestedGroupNum:SetPoint("TOPLEFT", "NxQuestDSCTimerText", "BOTTOMLEFT", 0, -10)
      else
          NxQuestDSCSuggestedGroupNum:SetPoint("TOPLEFT", "NxQuestDSCObjectivesText", "BOTTOMLEFT", 0, -10)
      end
  else
      NxQuestDSCSuggestedGroupNum:Hide()
  end
  if GetQuestLogGroupNum() > 0 then
      NxQuestDSCDescriptionTitle:SetPoint("TOPLEFT", "NxQuestDSCSuggestedGroupNum", "BOTTOMLEFT", 0, -10)
  elseif GetQuestLogRequiredMoney() > 0 then
      NxQuestDSCDescriptionTitle:SetPoint("TOPLEFT", "NxQuestDSCRequiredMoneyText", "BOTTOMLEFT", 0, -10)
  elseif nuO > 0 then
      NxQuestDSCDescriptionTitle:SetPoint("TOPLEFT", "NxQuestDSCObjective" .. nuO, "BOTTOMLEFT", 0, -10)
  else
      if quT3 then
          NxQuestDSCDescriptionTitle:SetPoint("TOPLEFT", "NxQuestDSCTimerText", "BOTTOMLEFT", 0, -10)
      else
          NxQuestDSCDescriptionTitle:SetPoint("TOPLEFT", "NxQuestDSCObjectivesText", "BOTTOMLEFT", 0, -10)
      end
  end
  if quD then
      NxQuestDSCQuestDescription:SetText(quD)
      QuestFrame_SetAsLastShown(NxQuestDSCQuestDescription, NxQuestDSCSpacerFrame)
  end
  local nuR = GetNumQuestLogRewards()
  local nuC = GetNumQuestLogChoices()
  local mon = GetQuestLogRewardMoney()
  if nuR + nuC + mon > 0 then
      NxQuestDSCRewardTitleText:Show()
  else
      NxQuestDSCRewardTitleText:Hide()
  end
  NxQuestDScrollBar:SetValue(0)
  NxQuestD:UpdateScrollChildRect()
end
function Nx.Que:CCNM(cur, que)
  if que.CNu then
      cur.CNM = que.CNu - 1
      local qc = que
      while qc do
          cur.CNM = cur.CNM + 1
          qc = self.ITQ[self:UnN(qc[1])]
      end
  end
end
function Nx.Soc:GPPI(nam)
  local pun1 = self.PuA[nam]
  if pun1 then
      local lvl = pun1.Lvl > 0 and pun1.Lvl or "?"
      local cla = pun1.Cla or "?"
      return format("Punk: %s, %s %s at %s %d %d", nam, lvl, cla, Nx.MITN[pun1.MId] or "?", pun1.X, pun1.Y)
  end
  return ""
end
function Nx.Win:SeM(miO)
  if self.BuM1 then
      if miO then
          self.LMN = self.LaM
          self:SetLayoutMode("Min")
          self:Not("SizeMin")
      else
          self:SetLayoutMode(self.LMN)
          self:Not("SizeNorm")
      end
  end
end
function Nx.Map:ScS(val1)
  local s = self.Sca
  if val1 < 0 then
      val1 = val1 * .76923
  end
  return math.max(s + val1 * s * .3, .015)
end
function Nx.Que:PST()
  local qi = self.PSDI
  local dat = self.PSD[qi]
  if dat then
      local s = qi == 1 and "1" or " "
      Nx.Com:Sen("p", "Qp" .. s .. dat)
  end
  self.PSDI = qi + 1
  if self.PSD[self.PSDI] then
      return .15
  end
end
function Nx:SEB(msg, val, usD, fuA, fuC)
  local pop = StaticPopupDialogs["NxEdit"]
  if not pop then
      pop = {
          ["whileDead"] = 1,
          ["hideOnEscape"] = 1,
          ["timeout"] = 0,
          ["exclusive"] = 1,
          ["hasEditBox"] = 1
      }
      StaticPopupDialogs["NxEdit"] = pop
  end
  pop["maxLetters"] = 110
  pop["text"] = msg
  Nx.SEBV = tostring(val)
  Nx.SEBUD = usD
  Nx.SEBF = fuA
  pop["OnAccept"] = function()
      if Nx.SEBF then
          Nx.SEBF(getglobal(this:GetParent():GetName() .. "EditBox"):GetText(), Nx.SEBUD)
      end
  end
  pop["EditBoxOnEnterPressed"] = function()
      if Nx.SEBF then
          Nx.SEBF(getglobal(this:GetParent():GetName() .. "EditBox"):GetText(), Nx.SEBUD)
      end
      this:GetParent():Hide()
  end
  pop["EditBoxOnEscapePressed"] = function()
      this:GetParent():Hide()
  end
  pop["OnShow"] = function()
      ChatEdit_FocusActiveWindow()
      local eb = getglobal(this:GetName() .. "EditBox")
      eb:SetFocus()
      eb:SetText(Nx.SEBV)
      eb:HighlightText()
  end
  pop["OnHide"] = function()
      getglobal(this:GetName() .. "EditBox"):SetText("")
  end
  pop["button1"] = ACCEPT
  pop["button2"] = CANCEL
  pop["OnCancel"] = fuC
  StaticPopup_Show("NxEdit")
end
function Nx.Que:FiC3(qId, qIn)
  if type(qId) == "string" then
      for n, v in ipairs(self.CuQ) do
          if v.Tit == qId then
              return n, v, qId
          end
      end
      return
  end
  if qIn and qId == 0 then
      local i, cur = self:FCBI(qIn)
      return i, cur, cur.Tit
  end
  assert(qId > 0)
  for n, v in ipairs(self.CuQ) do
      if v.QId == qId then
          return n, v, qId
      end
  end
end
function Nx.War.OM_2()
  Nx.War:CID()
end
function Nx.DrD:Ini()
  local win = Nx.Win:Cre("NxDD", nil, nil, nil, 0, true, true, true)
  self.Win1 = win
  local frm = win.Frm
  win:EnM(false)
  win:ILD(nil, 0, 0, 200, 200)
  tinsert(UISpecialFrames, frm:GetName())
  frm:SetClampedToScreen(true)
  frm:SetToplevel(true)
  Nx.Lis:SCF1("FontM")
  local lis = Nx.Lis:Cre(false, 0, 0, 1, 1, frm, false, true)
  self.Lis = lis
  lis:SeU(self, self.OLE)
  lis:CoA("", 1)
  win:Att(lis.Frm, 0, 1, 0, 1)
end
function Nx.Que:OnU(ela)
  if not self.Lis.Win1:IsShown() then
      return
  end
  if self.LHA1 then
      local pro1 = self.LHA1
      if self.LHO ~= pro1["open"] then
          self:LHA(self.Lis.Win1.Frm, true)
      end
      if Nx.Tic % 20 == 0 then
          self:LHA(self.Lis.Win1.Frm, true, true)
      end
  end
end
function Nx.But:SetAlpha(a)
  self.Frm:SetAlpha(a)
end
function Nx.Que:Unp(inf)
  local strbyte = strbyte
  local i = strbyte(inf, 1) - 35 + 1
  local nam = strsub(inf, 2, i)
  local sid, lvl, min5, n1, n2, n3 = strbyte(inf, i + 1, i + 6)
  local neI = (n1 - 35) * 48841 + (n2 - 35) * 221 + n3 - 35
  return nam, sid - 35, lvl - 35, min5 - 35, neI
end
function Nx.Que:RQL()
  local qcn = GetNumQuestLogEntries()
  local opt = self.GOp
  local cur1 = self.CuQ
  local olS = GetQuestLogSelection()
  local laC
  local qId1 = {}
  self.QId1 = qId1
  local paS
  if self.RQE == qcn then
      for cur2, cur in ipairs(cur1) do
          local qi = cur.QI
          if qi > 0 then
              local tit, lev, tag, grC, isH, isC, isC1 = GetQuestLogTitle(qi)
              tit = self:ExT(tit)
              if cur.Tit == tit then
                  local cha1
                  if isC1 == 1 and not cur.Com2 then
                      Nx.prt("Quest Complete '%s'", tit)
                      if opt["QSndPlayCompleted"] then
                          self:PlaySound()
                      end
                      if opt["QWRemoveComplete"] then
                          self.Wat:ReW(cur.QId, cur.QI)
                          self.Wat:Upd()
                          cha1 = false
                      else
                          cha1 = true
                      end
                  end
                  local lbC = GetNumQuestLeaderBoards(qi)
                  for n = 1, lbC do
                      local des1, typ, don = GetQuestLogLeaderBoard(n, qi)
                      if des1 ~= cur[n] or don ~= cur[n + 100] then
                          if opt["QWAddChanged"] then
                              if cha1 == nil then
                                  cha1 = true
                              end
                          end
                          local s1, _, olC1 = strfind(cur[n] or "", ": (%d+)/")
                          if s1 then
                              olC1 = tonumber(olC1)
                          end
                          local s1, _, neC = strfind(des1, ": (%d+)/")
                          if s1 then
                              neC = tonumber(neC)
                          end
                          if don or (olC1 and neC and neC > olC1) then
                              self:Cap(cur2, n)
                          end
                          laC = cur
                          paS = true
                      end
                  end
                  if cha1 and opt["QWAddChanged"] then
                      self.Wat:Add(cur2)
                  end
              end
          end
      end
  else
      paS = true
  end
  local fak = {}
  local n = 1
  while cur1[n] do
      local cur = cur1[n]
      if not cur.Got or cur.Par then
          table.remove(cur1, n)
      else
          fak[cur.Q] = cur
          n = n + 1
      end
  end
  self.ReQ = {}
  local hea = "?"
  self.RQE = qcn
  local ind = #cur1 + 1
  for qn = 1, qcn do
      local tit, lev, tag, grC, isH, isC, isC1, isD = GetQuestLogTitle(qn)
      if isH then
          hea = tit or "?"
      else
          tit = self:ExT(tit)
          SelectQuestLogEntry(qn)
          local qDe, qOb = GetQuestLogQuestText()
          local qId, qLe = self:GLIL(qn)
          assert(qId)
          local que = self.ITQ[qId]
          local lbC = GetNumQuestLeaderBoards(qn)
          local cur = que and fak[que]
          if not cur then
              cur = {}
              cur1[ind] = cur
              cur.Ind = ind
              ind = ind + 1
          else
              cur.Got = nil
              cur.Ind = ind
              if que then
                  self.Tra1[qId] = 0
                  self:TOM(qId, 0, true)
              end
          end
          qId1[qId] = cur
          cur.Q = que
          cur.QI = qn
          cur.QId = qId or 0
          cur.Hea1 = hea
          cur.Tit = tit
          cur.ObT = qOb
          cur.DeT1 = qDe
          cur.Lev = lev
          cur.ReL2 = qLe
          cur.Tag = tag
          cur.GCn = grC or 0
          cur.PaS1 = grC or 1
          if tag == "Dungeon" or tag == "Heroic" then
              cur.PaS1 = 5
          elseif tag == "Raid" then
              cur.PaS1 = 10
          end
          cur.TaS = self.TaN2[tag] or ""
          cur.Dai = isD
          if isD then
              cur.TaS = "$" .. cur.TaS
          end
          cur.CaS1 = GetQuestLogPushable()
          cur.Com2 = isC1
          local lef = GetQuestLogTimeLeft()
          if lef then
              cur.TiE = time() + lef
              cur.HiP1 = true
          end
          cur.ItL2, cur.ItI1, cur.ItC1 = GetQuestLogSpecialItemInfo(qn)
          cur.Pri = 1
          cur.Dis1 = 999999999
          cur.LBC = lbC
          for n = 1, lbC do
              local des1, typ, don = GetQuestLogLeaderBoard(n, qn)
              cur[n] = des1
              cur[n + 100] = don
          end
          local mas = 0
          local end1 = que and (que[3] or que[2])
          if (isC1 and end1) or lbC == 0 or (cur.Got and que[2]) then
              mas = 1
          else
              for n = 1, 99 do
                  local don
                  if n <= lbC then
                      don = cur[n + 100]
                  end
                  local obj = que and que[3 + n]
                  if not obj then
                      break
                  end
                  if obj and not don then
                      mas = mas + bit.lshift(1, n)
                  end
              end
          end
          cur.TrM2 = mas
          self.ReQ[tit] = cur
          if que then
              self:CCNM(cur, que)
          end
      end
  end
  if self.GOp["QPartyShare"] and self.Wat.BSP:GeP() then
      local pq = self.PaQ
      for plN, pda in pairs(pq) do
          for qId, qT in pairs(pda) do
              local que = self.ITQ[qId]
              local cur = qId1[qId]
              if cur then
                  local s = format("\n|cff8080f0%s|r", plN)
                  if not cur.PaD1 then
                      cur.PaD1 = ""
                      cur.PaN1 = "\n|cfff080f0Me"
                      cur.PaC1 = 0
                      cur.PaC2 = cur.Com2
                      for n, cnt in ipairs(qT) do
                          cur[n + 200] = cur[n + 100]
                          cur[n + 400] = "\n|cfff080f0Me" .. s
                      end
                  end
                  cur.PaD1 = cur.PaD1 .. s
                  cur.PaN1 = cur.PaN1 .. s
                  cur.PaC1 = cur.PaC1 + 1
                  cur.PaC2 = cur.PaC2 and qT.Com2
                  local mas = (cur.PaC2 or #qT == 0) and 1 or 0
                  for n, cnt in ipairs(qT) do
                      local tot = qT[n + 100]
                      local des1, don = self:CaD2(que, n, cnt, tot)
                      don = cur[n + 200] and don
                      cur[n + 200] = don
                      cur.PaD1 = cur.PaD1 .. "\n " .. des1
                      cur[n + 400] = cur[n + 400] .. " " .. des1
                      if not don then
                          mas = mas + bit.lshift(1, n)
                      end
                  end
                  cur.TrM2 = mas
              elseif que then
                  local nam, sid, lvl = self:Unp(que[1])
                  local cur = {}
                  cur.Got = true
                  cur.Par = plN
                  cur.PaD1 = format("\n|cff8080f0%s|r", plN)
                  cur.PaN1 = cur.PaD1
                  cur.Q = que
                  cur.QI = 0
                  cur.QId = qId
                  cur.Hea1 = "Party, " .. plN
                  cur.Tit = nam
                  cur.ObT = ""
                  cur.Lev = lvl
                  cur.PaS1 = 1
                  cur.TaS = ""
                  cur.Com2 = qT.Com2
                  cur.Pri = 1
                  cur.Dis1 = 999999999
                  self:CCNM(cur, que)
                  tinsert(cur1, cur)
                  cur.Ind = #cur1
                  cur.LBC = #qT
                  local mas = (qT.Com2 or #qT == 0) and 1 or 0
                  for n, cnt in ipairs(qT) do
                      local tot = qT[n + 100]
                      cur[n], cur[n + 100] = self:CaD2(que, n, cnt, tot)
                      cur[n + 400] = cur.PaN1
                      if not cur[n + 100] then
                          mas = mas + bit.lshift(1, n)
                      end
                  end
                  cur.TrM2 = mas
              end
          end
      end
  end
  for cur2, cur in ipairs(cur1) do
      if cur.PaC1 then
          cur.CoM = cur.PaC2
          for n, des1 in ipairs(cur) do
              cur[n + 300] = cur[n + 200]
          end
      else
          cur.CoM = cur.Com2
          for n, des1 in ipairs(cur) do
              cur[n + 300] = cur[n + 100]
          end
      end
  end
  if laC then
      self.QLC = self:FCFO(laC)
  end
  SelectQuestLogEntry(olS)
  self:SoQ()
  if paS then
      self:PSS()
  end
  self.Map.Gui:UMI1()
end
function Nx.Sli:Dra()
  if self.DrX then
      local frm = self.Frm
      local x, y = Nx.U_GMCXY(frm)
      if x then
          local tfr = self.ThF
          if self.TyH then
              local dx = self.DrX - x
          else
              local dy = self.DrY - y
              local h = (frm:GetTop() or 0) - (frm:GetBottom() or 0)
              y = h - y
              if dy ~= 0 then
                  local i = dy / h * (self.Max1 - self.Min1 + 1)
                  self:Set(self.DrP + i)
                  self:Upd()
                  if self.UsF then
                      self.UsF(self.Use, self, self.Pos)
                  end
              end
          end
      else
      end
  end
end
function Nx.Win:OMU(but)
  local win = this.NxW
  if win.MoS then
      this:StopMovingOrSizing()
      win.MoS = false
      if win.Sec1 and InCombatLockdown() then
          win.DMU = true
      else
          win:SFS(win.SaD[win.LaM .. "L"])
          this:Raise()
      end
      win:RLD()
  end
  ResetCursor()
  win:Adj()
end
function Nx.Map.Gui:OEB(edi, message)
  if message == "Changed" then
      self:Upd()
  end
end
function Nx.Opt:OPLE(evN, sel, va2)
  if evN == "select" or evN == "back" then
      self.PaS = sel
      self:Upd()
  end
end
function Nx.Map:GINI(leA)
  local frm1 = self.INIF
  local pos1 = frm1.Nex
  if pos1 > 1500 then
      pos1 = 1500
  end
  local f = frm1[pos1]
  if not f then
      f = CreateFrame("Frame", "NxIconNI" .. pos1, self.Frm)
      frm1[pos1] = f
      f.NxM1 = self
      local t = f:CreateTexture()
      f.tex = t
      t:SetAllPoints(f)
  end
  local add = leA or 0
  f:SetFrameLevel(self.Lev + add)
  f.tex:SetVertexColor(1, 1, 1, 1)
  f.tex:SetBlendMode("BLEND")
  frm1.Nex = pos1 + 1
  return f
end
function Nx.Hel:Cre()
  local win = Nx.Win:Cre("NxHelp", nil, nil, nil, 1)
  self.Win1 = win
  local frm = win.Frm
  win:CrB(true, true)
  win:ILD(nil, -.25, -.1, -.5, -.7)
  tinsert(UISpecialFrames, frm:GetName())
  frm:SetToplevel(true)
  local str = Nx.TXTBLUE .. NXTITLEFULL .. " " .. Nx.VERSION .. "|cffffffff Help"
  win:SeT(str)
  local liW = 70
  local dat = {"Welcome", "Using", "WotLK Help", "Keys", "Map", "3.34", "3.33", "3.32", "3.31", "3.30", "3.23",
               "3.22", "3.21", "3.20", "3.13", "3.12", "3.11", "3.10", "3.00"}
  local lis = Nx.Lis:Cre(false, 0, 0, 1, 1, frm)
  self.Lis = lis
  lis:SeU(self, self.OLE)
  win:Att(lis.Frm, 0, liW, 0, 1)
  lis:CoA("Page", 1, liW)
  for k, str in ipairs(dat) do
      lis:ItA()
      lis:ItS(1, str)
  end
  local scf = CreateFrame("ScrollFrame", nil, UIParent)
  self.ScF = scf
  win:Att(scf, liW, 1, 0, 1)
  local f = CreateFrame("Frame", nil, UIParent)
  self.Frm = f
  local fst = f:CreateFontString()
  self.FSt = fst
  fst:SetFontObject("GameFontNormalSmall")
  fst:SetJustifyH("LEFT")
  fst:SetPoint("TOPLEFT", 0, -6)
  f.NSS = self.OSS
  win:Att(f, liW, 1, 0, 1)
  scf:SetScrollChild(f)
  self:SetText(1)
end
function Nx.Que:FiQ()
  local fiT1 = GetTitleText()
  fiT1 = self:ExT(fiT1)
  local i, cur = self:FiC3(fiT1)
  if not i then
      return
  end
  cur.QI = 0
  local qId = cur.QId
  assert(type(qId) ~= "string")
  local id = qId > 0 and qId or cur.Tit
  Nx:SeQ(id, "C", time())
  self:RQAOF()
  self:Cap(i, -1)
  if cur.Q then
      self.Tra1[qId] = 0
      self:TOM(qId, 0)
  end
  self.Wat:Upd()
end
function Nx.Map:CFTL(frm, bx, by, w, h)
  local sca = self.ScD
  local bw = w * sca
  local clW = self.MaW
  local x = (bx - self.MPXD) * sca + clW / 2
  local tX1 = 0
  local tX2 = 1
  local vx1 = x
  local vx2 = x + bw
  if vx1 < 0 then
      vx1 = 0
      tX1 = (vx1 - x) / bw
  end
  if vx2 > clW then
      vx2 = clW
      tX2 = (vx2 - x) / bw
  end
  w = vx2 - vx1
  if w < .3 then
      if self.ScF1 ~= frm then
          frm:Hide()
      else
          frm:SetWidth(.001)
      end
      return false
  end
  local bh = h * sca
  local clH = self.MaH
  local y = (by - self.MPYD) * sca + clH / 2
  local tY1 = 0
  local tY2 = 1
  local vy1 = y
  local vy2 = y + bh
  if vy1 < 0 then
      vy1 = 0
      tY1 = (vy1 - y) / bh
  end
  if vy2 > clH then
      vy2 = clH
      tY2 = (vy2 - y) / bh
  end
  h = vy2 - vy1
  if h < .3 then
      if self.ScF1 ~= frm then
          frm:Hide()
      else
          frm:SetWidth(.001)
      end
      return false
  end
  frm:SetPoint("TOPLEFT", vx1, -vy1 - self.TiH)
  if w <= 1.2 then
      w = self.Si1
      if w <= 0 then
          frm:SetWidth(.001)
          return
      end
  end
  if h <= 1.2 then
      h = self.Si1
      if h <= 0 then
          frm:SetWidth(.001)
          return
      end
  end
  frm:SetWidth(w)
  frm:SetHeight(h)
  frm.tex:SetTexCoord(tX1, tX2, tY1, tY2)
  frm:Show()
  return true
end
function Nx.Inf:CIC()
  if Nx.InC then
      return "", ""
  end
end
function Nx.Inf:GeF3()
  local frm1 = self.Frm1
  local pos1 = frm1.Nex
  local f = frm1[pos1]
  if not f then
      f = CreateFrame("Frame", "NxInfo" .. pos1, self.Frm)
      frm1[pos1] = f
      local t = f:CreateTexture()
      f.tex = t
      t:SetAllPoints(f)
  end
  frm1.Nex = pos1 + 1
  return f
end
function Nx.Map.Gui:OLED(lis, evN, sel, va2, cli)
  local typ = lis:IGD(sel) or 0
  local paI1 = max(#self.PaH - 1, 1)
  if lis == self.Li2 then
      paI1 = #self.PaH
  end
  if evN == "select" or evN == "mid" or evN == "menu" then
      self.PHS[paI1] = sel
      local fol = self.PaH[paI1]
      local ite = fol[typ]
      if evN ~= "menu" or lis == self.Lis then
          if type(ite) == "table" then
              if ite[1] or ite.Ite then
                  self.PaH[paI1 + 1] = ite
                  self.PHS[paI1 + 1] = 1
                  self:SeL2()
              else
                  if lis == self.Lis then
                      if #self.PaH == 2 then
                          self:Bac()
                      end
                  end
              end
          end
      end
      if type(ite) == "number" then
          local id = ite
          if IsControlKeyDown() then
              DressUpItemLink(format("item:%d", id))
          else
              local nam, lin = GetItemInfo(id)
              SetItemRef(format("item:%d", id), lin)
          end
      else
          if IsControlKeyDown() then
              if ite.Lin then
                  DressUpItemLink(ite.Lin)
              end
          end
      end
      self:Upd()
      if evN == "menu" then
          self:OpM(ite)
      end
  elseif evN == "back" then
      self:Bac()
  elseif evN == "sort" then
      if lis == self.Li2 then
          lis:CoS2(va2)
          self:Upd()
      end
  elseif evN == "button" then
      local pre1 = va2
      if typ > 0 then
          local map = self.Map
          local fol = self.PaH[paI1]
          if type(fol[typ]) == "table" then
              fol = fol[typ]
          end
          if fol.TrM1 then
              Nx.SMT()
          end
          local sin1 = not (IsShiftKeyDown() or cli == "MiddleButton")
          if fol.MId and pre1 then
              map:SCM1(fol.MId)
              map:CeM(fol.MId, 1)
              Nx.Que.Lis:Upd()
              sin1 = true
          end
          if sin1 then
              self:CSF()
              map:ClT1(not pre1 and "Guide")
          elseif not pre1 then
              local typ, id = map:GTI()
              if id == fol then
                  map:ClT1()
              end
          end
          if fol.Per and not pre1 then
              local v = Nx.ChO[fol.Per]
              if not v or v == 1 then
                  self:ASF(fol, not pre1)
              end
          else
              self:ASF(fol, not pre1)
          end
          self:Upd()
          if sin1 and pre1 then
              local typ, fil1 = self:CaT2(fol)
              self.FiC1 = typ
              if typ then
                  local npI, maI, x, y = self:FiC2(typ)
                  if npI then
                      Nx.Que.Wat:CAT()
                      map:SeT3("Guide", x, y, x, y, false, fol, fol.Nam, false, maI)
                      map:GoP()
                  end
              else
                  PlaySound("igPlayerInviteDecline")
              end
          end
      end
  end
end
function Nx.Map:DCPOI()
  if self.ScD > self.LOp.NXPOIAtScale then
      return
  end
  local geC = WorldMap_GetPOITextureCoords
  for con1 = 1, self.CoC do
      for k, poi1 in ipairs(self.CPOI[con1]) do
          local f = self:GeI1(3)
          if self:CFW(f, poi1.WX, poi1.WY, 16, 16, 0) then
              f.NxT = poi1.Nam
              local t1x, t1y, t4x, t4y, t2x = f.tex:GetTexCoord()
              f.tex:SetTexture("Interface\\Minimap\\POIIcons")
              local tX11, tX21, tY11, tY21 = geC(poi1.TxI)
              local x = tX11 + .003
              local y = tY11 + .003
              local w = tX21 - .003 - x
              local h = tY21 - .003 - y
              f.tex:SetTexCoord(x + w * t1x, x + w * t2x, y + h * t1y, y + h * t4y)
          end
      end
  end
  self.Lev = self.Lev + 1
end
function Nx.War:M_OSBS(ite)
  self.SBS2 = ite:GetChecked()
  self:Upd()
end
function Nx.DrD:OLE(evN, sel, va2, cli)
  local nam = self.Lis:IGD(sel)
  if nam then
      if evN == "select" or evN == "mid" then
          self.Fun(self.Use, nam, sel)
      end
  end
  self.Win1:Show(false)
end
function Nx.Map.Gui:OpM(ite)
  self.MCI = ite
  local caD = false
  local cGQ = false
  if type(ite) == "table" then
      if ite.T then
          local mod1 = strbyte(ite.T)
          if mod1 == 40 then
              caD = true
          end
      end
      if ite.QId then
          cGQ = true
      end
  end
  self.MID:Show(caD)
  self.MIGQ:Show(cGQ)
  self.Men:Ope()
end
function Nx.War:Cre()
  if not self.Ena then
      return
  end
  self.SeC2 = 1
  self.SIC = true
  local win = Nx.Win:Cre("NxWarehouse", nil, nil, nil, 1)
  self.Win1 = win
  win.Frm.NxI = self
  win:CrB(true, true)
  win:ILD(nil, -.25, -.15, -.5, -.6)
  win.Frm:SetToplevel(true)
  win:Show(false)
  tinsert(UISpecialFrames, win.Frm:GetName())
  Nx.Lis:SCF1("FontM", 16)
  local lis = Nx.Lis:Cre(false, 0, 0, 1, 1, win.Frm)
  self.Lis = lis
  lis:SeU(self, self.OLE)
  lis:SLH(4)
  lis:CoA("", 1, 24)
  lis:CoA("Name", 2, 900)
  win:Att(lis.Frm, 0, .5, 0, 1)
  Nx.Lis:SCF1("FontWarehouseI", 16)
  local lis = Nx.Lis:Cre(false, 0, 0, 1, 1, win.Frm)
  self.ItL = lis
  lis:SeU(self, self.OILE)
  lis:CoA("", 1, 17)
  lis:CoA("", 2, 35, "RIGHT", "FontS")
  lis:CoA("", 3, 900)
  win:Att(lis.Frm, .5, 1, 18, 1)
  self.EdB = Nx.EdB:Cre(win.Frm, self, self.OEB, 30)
  win:Att(self.EdB.Frm, .5, 1, 0, 18)
  self:CrM()
  self:Upd()
  self.Lis:Sel1(3)
  self.Lis:FuU()
end
function Nx.Que.Lis:M_OTN(ite)
  Nx.Que.Wat:CAT()
  self:Upd()
end
function Nx.Map:GZP(maI, woX, woY)
  local win1 = self.MWI[maI]
  if win1 then
      local sca = win1[1]
      return (woX - win1[4]) / sca, (woY - win1[5]) / sca * 1.5
  end
  return 0, 0
end
function Nx.Sec:Dat1()
  local w, m, d, y = CalendarGetDate()
  y = y - 2000
  return y * 10000 + m * 100 + d
end
function Nx.Inf:CTC(w, h)
  w = tonumber(w) or 50
  h = tonumber(h) or 10
  local spe, ran, nam, ico, stT1, enT = UnitCastingInfo("target")
  if not nam then
      spe, ran, nam, ico, stT1, enT = UnitChannelInfo("target")
  end
  if nam then
      local rem1 = enT / 1000 - GetTime()
      local per = rem1 * 1000 / (enT - stT1)
      return "|cffc0c0f0",
          format("|T%s:16|t %.1f |TInterface\\BUTTONS\\gradblue:%d:%d|t", ico, rem1, h, max(per * w, 1))
  end
end
function Nx.Hel.Lic:OBA()
  self.Win1:Show(false)
  local opt = Nx:GGO()
  opt["LicenseAccept" .. Nx.VERSION] = true
  Nx.Sec:Sta()
end
function Nx.Map:GMO(ico, typ)
  self.GIMITI:Show(false)
  self.GIMIFN:Show(false)
  if typ == 3000 then
      if ico.UDa then
          self.GIMITI:Show()
      end
      if ico.FD1 then
          self.GIMIFN:Show()
      end
  end
  Nx.Que:OGIM(ico, typ)
  self.GIM:Ope()
end
function Nx.Map:STAC()
  Nx.Que.Wat:CAT()
  local wx, wy = self:FPTWP(self.CFX, self.CFY)
  local zx, zy = self:GZP(self.MaI, wx, wy)
  local str = format("Goto %.0f, %.0f", zx, zy)
  self:SeT3("Goto", wx, wy, wx, wy, nil, nil, str, IsShiftKeyDown())
end
function Nx.Inf:CaM()
  return "|cffc0c0c0", format("%d", self.Var["Mana"])
end
function Nx.HUD:UpO()
  local win = self.Win1
  if not Nx.Fre then
      local loc1 = win:IsL()
      win:SBGA(0, loc1 and 0 or 1)
  end
  local gop = self.GOp
  local nam = gop["HUDAGfx"]
  self.Frm.tex:SetTexture("Interface\\AddOns\\Carbonite\\Gfx\\Map\\HUDArrow" .. nam)
  local f = self.Frm
  f:SetPoint("CENTER", gop["HUDAXO"], -win.TiH / 2 - 32 - gop["HUDAYO"])
  local wh = gop["HUDASize"]
  f:SetWidth(wh)
  f:SetHeight(wh)
  if not InCombatLockdown() then
      local f = self.But2
      f:SetWidth(wh)
      f:SetHeight(wh)
      f:Hide()
  end
  self.BuR, self.BuG, self.BuB, self.BuA = Nx.U_23(gop["HUDTButColor"])
  self.BCR, self.BCG, self.BCB, self.BCA = Nx.U_23(gop["HUDTButCombatColor"])
end
function Nx.Que:IsT(qId, qOb, x1, y1, x2, y2)
  local typ, tid = Nx.Map:GTI()
  if typ == "Q" then
      local tqi = floor(tid / 100)
      if tqi == qId then
          if x1 then
              local tx1, ty1, tx2, ty2 = Nx.Map:GTP()
              if x1 ~= tx1 or y1 ~= ty1 or x2 ~= tx2 or y2 ~= ty2 then
                  return false
              end
          end
          if not qOb then
              return true
          end
          if tid % 100 == qOb then
              return true
          end
      end
  end
  return false
end
function Nx.Com:OLAT()
  self:LeC("A")
end
function Nx.Map:CaF1(opN)
  local nam = self.GOp[opN]
  if nam == "None" then
      return
  end
  local fun = self.Fun1[nam]
  if fun then
      fun(self)
  else
      Nx.prt("Unknown map function %s", nam)
  end
  return true
end
function Nx.Soc.Lis:M_OPR()
  if self.MSN1 then
      local pun = Nx:GeS("Pk")
      pun[self.MSN1] = nil
      self:Upd()
  end
end
function Nx.Lis:IGBT(ind)
  if self.BuD then
      return self.BuD[ind + 2000000]
  end
end
function Nx:SMT()
end
function Nx.Que.OC____()
  local self = Nx.Que
  local for2 = FACTION_STANDING_INCREASED
  for2 = gsub(for2, "%%s", "(.+)")
  for2 = gsub(for2, "%%d", "(%%d+)")
  local faN, rep = strmatch(arg1, for2)
  rep = tonumber(rep)
  if faN and rep and self.CQET and GetTime() - self.CQET < 2 then
      local faN1 = self.CFA[faN]
      if faN1 then
          local _, rac = UnitRace("player")
          if rac == "Human" then
              rep = rep / 1.1 + .5
          end
          local cap = Nx:GeC()
          local que1 = Nx:CaF(cap, "Q")
          local qda = {strsplit("~", que1[self.CQEI])}
          local end1, rep2 = strsplit("@", qda[2])
          local rep3 = rep2 and {strsplit("^", rep2)} or {}
          tinsert(rep3, format("%d %x", rep, faN1))
          rep2 = table.concat(rep3, "^")
          qda[2] = format("%s@%s", end1, rep2)
          que1[self.CQEI] = table.concat(qda, "~")
      end
  end
  self.CQET = nil
end
function Nx.Que:REQ()
end
function Nx.Men:Ope()
  if Nx.Men.Cur then
      Nx.Men.Cur:Clo2()
  end
  Nx.Men.Cur = self
  local mf = self.MaF
  self.Clo1 = nil
  self.ClT = 60 * 1
  self.Alp = 0
  self.AlT = 1
  local meW = self.Wid
  local meH = self:Upd() + 14
  mf:SetFrameStrata("DIALOG")
  mf:SetClampedToScreen(true)
  mf:SetWidth(meW)
  mf:SetHeight(meH)
  local cx, cy = GetCursorPosition()
  cx = cx / UIParent:GetEffectiveScale()
  cy = cy / UIParent:GetEffectiveScale()
  local opt = Nx:GGO()
  local x = cx - 4
  local y = cy + 4
  if opt["MenuCenterH"] then
      x = cx - meW * .5
  end
  if opt["MenuCenterV"] then
      y = cy + meH * .5
  end
  mf:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y)
  mf:Show()
  mf:Raise()
end
function Nx.Com1:OnE1(mot)
end
function Nx.Soc:SBT2(show)
  for n = 1, 10 do
      local tab1 = getglobal("FriendsFrameTab" .. n)
      if tab1 then
          if show ~= false then
              tab1:Show()
          else
              tab1:Hide()
          end
      end
  end
end
function Nx.Map.Gui:GPT(prN)
  return " Trainer"
end
function Nx.Scr:Tic(scr)
  scr.Del = scr.Del - 1
  if scr.Del > 0 then
      return
  end
  local pos1 = scr.Pos
  local cmd = scr.Cmd[pos1]
  while cmd do
      pos1 = pos1 + 1
      local nam, a1, a2, a3 = strsplit("^", cmd)
      if nam == "" then
          scr.Del = tonumber(a1)
          break
      elseif nam == "Restart" then
          pos1 = 1
      elseif nam == "Show" then
          scr.Dat[a1]:Show()
      elseif nam == "Hide" then
          scr.Dat[a1]:Hide()
      elseif nam == "Text" then
          scr.Dat[a1]:SetText(a2)
      elseif nam == "Func" then
          scr.Dat[a1](scr.Dat, a2, a3)
      elseif nam == "Set" then
          scr.Dat[a1] = tonumber(a2)
      elseif nam == "PosAt" then
      elseif nam == "Prt" then
          Nx.prt(a1)
      end
      cmd = scr.Cmd[pos1]
  end
  if not cmd then
      return true
  end
  scr.Pos = pos1
end
function Nx.Com:OC___(eve, ...)
  local sNa, sFl, dId, dNa, dFl = select(4, ...)
  if sNa and bit.band(sFl, 0x440) == 0x440 then
      local nea
      if dNa and bit.band(dFl, 0x440) == 0x400 then
          nea = dNa
      end
      Nx.Soc:ALP(sNa, nea)
      if not Nx.IBG then
          Nx.Com.Pun[sNa] = 0
      end
  end
  if dNa and dNa ~= sNa and bit.band(dFl, 0x440) == 0x440 then
      local nea
      if sNa and bit.band(sFl, 0x440) == 0x400 then
          nea = sNa
      end
      Nx.Soc:ALP(dNa, nea)
      if not Nx.IBG then
          Nx.Com.Pun[dNa] = 0
      end
  end
end
function Nx.Que:ULR(loS1)
  local x, y, w, h = strbyte(loS1, 1, 4)
  return (x - 35) * .5, (y - 35) * .5, (w - 35) * 5.01, (h - 35) * 3.34
end
function Nx.Pro:OnU(ela)
  ela = min(ela, .2) * 60
  ela = ela + self.TiL1
  while ela >= 1 do
      ela = ela - 1
      local n = 1
      while 1 do
          local p = self.Pro1[n]
          if not p then
              break
          end
          local d = p.Del - 1
          if d <= 0 then
              d = p.Fun(p.Use, p) or 1
              if d < 0 then
                  tremove(self.Pro1, n)
                  n = n - 1
              end
          end
          p.Del = d
          n = n + 1
      end
  end
  self.TiL1 = ela
end
function Nx.Win:GCO()
  return self.BoW, self.TiH + self.BoH
end
function Nx.Men:I_OL(mot)
  local ite = this.NMI
  ite.AlT = Nx.Men.I_ALPHAFADE
end
function Nx.Opt:NXCmdResetWinLayouts()
  local function fun()
      Nx.Win:ReL()
  end
  Nx:ShM("Reset window layouts?", "Reset", fun, "Cancel")
end
function Nx.Com.Lis:Upd()
  if not self.Ope1 then
      return
  end
  self.Win1:SeT(format("Com %d Bytes sec %d", #self.Sor, Nx.Com.SBS1 or 0))
  local lis = self.Lis
  local isL = lis:ISL()
  lis:Emp()
  for k, v in pairs(self.Sor) do
      lis:ItA()
      lis:ItS(1, date("%d %H:%M:%S", v.Tim1))
      lis:ItS(2, v.Typ)
      lis:ItS(3, v.Nam)
  end
  lis:Upd(isL)
end
function Nx.War:CaG(t, key)
  assert(type(t) == "table" and key)
  local d = t[key] or {}
  t[key] = d
  return d
end
function Nx.Tra:FiF3(sMI, srX, srY, dMI, dsX, dsY)
  local t1D, t1N, t1t = self:FiC2(sMI, srX, srY)
  if t1N then
      local spe1 = self.Spe
      local t1N1 = t1N.Nam
      local t1x, t1y = t1N.WX, t1N.WY
      local b2N
      local beD = 9999999999
      for per = 0, .5, .2 do
          local dx = dsX - srX * per
          local dy = dsY - srY * per
          local t2D, t2N, t2t = self:FiC2(dMI, dx, dy)
          if t2N then
              if t1N1 == t2N.Nam then
                  break
              end
              local t2x, t2y = t2N.WX, t2N.WY
              local flD1 = ((t1x - t2x) ^ 2 + (t1y - t2y) ^ 2) ^ .5 * spe1
              t2D = ((dsX - t2x) ^ 2 + (dsY - t2y) ^ 2) ^ .5
              local trD = t1D + flD1 + t2D
              if beD > trD then
                  beD = trD
                  b2N = t2N
              end
          end
      end
      if not b2N then
          return
      end
      local pat = {}
      local nam = format("Fly: %s to %s", gsub(t1N.Nam, ".+!", ""), gsub(b2N.Nam, ".+!", ""))
      local no1 = {}
      no1.NoS1 = true
      no1.MaI = t1N.MaI
      no1.X = t1x
      no1.Y = t1y
      no1.Nam = nam
      no1.Tex1 = "Interface\\Icons\\Ability_Mount_Wyvern_01"
      tinsert(pat, no1)
      local no2 = {}
      no2.Fli = true
      no2.MaI = b2N.MaI
      no2.X = b2N.WX
      no2.Y = b2N.WY
      no2.Nam = nam
      no2.Tex1 = "Interface\\Icons\\Ability_Mount_Wyvern_01"
      tinsert(pat, no2)
      return beD, pat
  end
end
function Nx.Map:GWR(maI, maX, maY, mX2, mY2)
  local x, y = self:GWP(maI, maX, maY)
  local x2, y2 = self:GWP(maI, mX2, mY2)
  return x, y, x2, y2
end
function Nx.Com1:SeL(val1, coS, inS)
  self:EnC()
  if val1 > self.HiP then
      self.HiP = val1
      self.GrH:SeP(self.HiP)
  end
  self.HiT = self.HiT + val1
  if val1 > self.HiB then
      self.HiB = val1
  end
  local time = GetTime() - self.TiS + .001
  self.GrH:SeL(time, val1, coS, inS)
  local txt = string.format("Hit %3.0f Peak " .. self.HiP .. " Best " .. self.HiB .. " Total %.0f Time %.2f DPS %.1f",
      val1, self.HiT, time, self.HiT / time)
  self.Win1:SeT(txt)
end
function Nx:CCD(srN, dsN)
  if not srN then
      local sch = Nx.CuC
      for rc, dch in pairs(NxData.Characters) do
          if dch ~= sch then
              Nx.Win:CLC(sch.W, dch.W)
              dch.W = sch.W
              dch["L"] = sch["L"]
              dch["TBar"] = sch["TBar"]
          end
      end
  else
      local sch = Nx:FiC(srN)
      local dch = Nx:FiC(dsN)
      if not sch or not dch then
          Nx.prt("Missing character data!")
          return
      end
      if not Nx.Win:CLC(sch.W, dch.W) then
          return
      end
      dch.W = sch.W
      dch["L"] = sch["L"]
      dch["TBar"] = sch["TBar"]
  end
  return true
end
function Nx.Com:ScC()
  local baN = self.Nam .. "Z"
  for n = 1, 10 do
      local id, nam = GetChannelName(n)
      if id > 0 and nam then
          local na4 = strsub(nam, 1, 4)
          if na4 == baN then
              local naR = strsplit("I", nam)
              local maI = tonumber(strsub(naR, 5))
              if maI then
                  local zs = self.ZSt[maI] or {}
                  zs.ChN = nam
                  self.ZSt[maI] = zs
              end
          end
      end
  end
end
function Nx.NXMiniMapBut:NXOnUpdate()
  if this.NXDrag then
      local mm = getglobal("Minimap")
      local x, y = GetCursorPosition()
      local s = mm:GetEffectiveScale()
      self:Mov(x / s, y / s)
  end
end
function Nx.But:SeP1(sid, x, y)
  self.Frm:SetPoint(sid, x, y)
end
function Nx.Hel.Lic:OBD()
  self.Frm:Hide()
  Nx:ShM(
      "|cffff4f4fYou have declined the license agreement:\n\n|rPress the Escape key twice.\nSelect 'Exit Game'.\nDelete your copy of CARBONITE from the AddOns folder.",
      "OK", Nx.Hel.Lic.OnC, nil, Nx.Hel.Lic.OnC)
end
function Nx.Fav:CrM()
  local men = Nx.Men:Cre(self.Lis.Frm, 250)
  self.Men = men
  men:AdI1(0, "Add Folder", self.M_OAF, self)
  men:AdI1(0, "Add Favorite", self.M_OAF1, self)
  men:AdI1(0, "")
  men:AdI1(0, "Rename", self.M_OR1, self)
  men:AdI1(0, "Cut", self.M_OC, self)
  men:AdI1(0, "Copy", self.M_OC1, self)
  men:AdI1(0, "Paste", self.M_OP1, self)
  local function fun()
      Nx.Opt:Ope("Favorites")
  end
  men:AdI1(0, "")
  men:AdI1(0, "Options...", fun)
  local men = Nx.Men:Cre(self.Lis.Frm, 250)
  self.ItM = men
  men:AdI1(0, "Add Comment", self.IM_OAC, self)
  men:AdI1(0, "")
  men:AdI1(0, "Rename", self.IM_OR, self)
  men:AdI1(0, "Cut", self.IM_OC, self)
  men:AdI1(0, "Copy", self.IM_OC1, self)
  men:AdI1(0, "Paste", self.IM_OP, self)
  men:AdI1(0, "")
  men:AdI1(0, "Set Icon", self.IM_OSI, self)
end
function Nx.Map:CZ2MI(con1, zon)
  if con1 <= 0 then
      return 9000
  end
  return self.CZ2I[con1][zon]
end
function Nx.Fav:CrI(typ, fla, nam, p1, p2, p3, p4)
  fla = fla + 35
  nam = gsub(nam, "[~^]", "")
  nam = gsub(nam, "\n", " ")
  if typ == "" then
      return format("~%c~%s", fla, nam)
  elseif typ == "N" then
      local id = Nx.MITN1[p2]
      s = self:MXY(p3, p4)
      return format("N~%c~%s~%c%02x%s", fla, nam, p1 + 35, id, s)
  elseif typ == "T" or typ == "t" then
      local id = Nx.MITN1[p1]
      s = self:MXY(p2, p3)
      return format("%s~%c~%s~%02x%s", typ, fla, nam, id, s)
  end
end
function Nx.But:OnU(ela)
  local but1 = this.NxB
  if but1.Scr2 then
      local cx, cy = GetCursorPosition()
      cx = cx / this:GetEffectiveScale()
      cy = cy / this:GetEffectiveScale()
      local x = cx - but1.ScX
      local y = but1.ScY - cy
      if x ~= 0 or y ~= 0 then
          but1.ScX = cx
          but1.ScY = cy
          if IsShiftKeyDown() then
              x = x * .1
              y = y * .1
          end
          if but1.UsF then
              but1.UsF(but1.Use, but1, but1.Id, "scroll", x, y)
          end
      end
  end
end
function Nx.Que:UpI(map)
  Nx.Tim:PrS("Quest UpdateIcons")
  local Nx = Nx
  local Que = Nx.Que
  local Map = Nx.Map
  local qLC = Que.QLC1
  local ptS = 4 * map.ScD
  local nav = Que.Map.INS * 16
  local sOM = Que.Wat.BSOM:GeP()
  local opt = self.GOp
  local sWA = opt["QMapShowWatchAreas"]
  local trR, trG, trB, trA = Nx.U_23(opt["QMapWatchAreaTrackColor"])
  local hoR, hoG, hoB, hoA = Nx.U_23(opt["QMapWatchAreaHoverColor"])
  local typ, tid = Map:GTI()
  if typ == "Q" then
      local qid = floor(tid / 100)
      local i, cur = Que:FiC3(qid)
      if cur then
          Que:CaD3(cur.Ind, cur.Ind)
          Que:TOM(cur.QId, tid % 100, cur.QI > 0 or cur.Par, true, true)
      end
  end
  for k, cur in ipairs(Que.CuQ) do
      if cur.Q and cur.CoM then
          local q = cur.Q
          local obj = q[3] or q[2]
          local enN, zon, x, y = Que:GOP(q, obj)
          local maI = Map.NTMI[zon]
          if maI then
              local wx, wy = map:GWP(maI, x, y)
              local f = map:GIS(4)
              if map:CFW(f, wx, wy, nav, nav, 0) then
                  f.NXType = 9000
                  f.NXData = cur
                  local qna = Nx.TXTBLUE .. "Quest: " .. cur.Tit
                  f.NxT = format("%s\nEnd: %s (%.1f %.1f)", qna, enN, x, y)
                  if cur.PaN1 then
                      f.NxT = f.NxT .. "\n" .. cur.PaN1
                  end
                  f.tex:SetTexture("Interface\\AddOns\\Carbonite\\Gfx\\Map\\IconQuestion")
              end
          end
      end
  end
  local tra2 = self.IcT
  if Nx.Tic % 10 == 0 then
      tra2 = {}
      for trI, trM in pairs(Que.Tra1) do
          tra2[trI] = trM
      end
      if sOM then
          for k, cur in ipairs(Que.CuQ) do
              if cur.Q and (Nx:GeQ(cur.QId) == "W" or cur.PaD1) then
                  tra2[cur.QId] = (tra2[cur.QId] or 0) + 0x10000
              end
          end
      end
      self.IcT = tra2
  end
  local arT1 = Nx.Opt.CQAT[opt["QMapWatchAreaGfx"]]
  local cPQ = opt["QMapWatchColorPerQ"]
  local coM = opt["QMapWatchColorCnt"]
  for trI, trM in pairs(tra2) do
      local cur = Que.ITCQ[trI]
      local que = cur and cur.Q or Que.ITQ[trI]
      local qna = Nx.TXTBLUE .. "Quest: " .. (cur and cur.Tit or Que:UnN1(que[1]))
      local mas = sOM and cur and cur.TrM2 or trM
      local shE
      if bit.band(mas, 1) > 0 then
          if not (cur and (cur.QI > 0 or cur.Par)) then
              local stN1, zon, x, y = Que:GOP(que, que[2])
              local maI = Map.NTMI[zon]
              if maI then
                  local wx, wy = map:GWP(maI, x, y)
                  local f = map:GIS(4)
                  if map:CFW(f, wx, wy, nav, nav, 0) then
                      f.NxT = format("%s\nStart: %s (%.1f %.1f)", qna, stN1, x, y)
                      f.tex:SetTexture("Interface\\AddOns\\Carbonite\\Gfx\\Map\\IconExclaim")
                  end
              end
          else
              shE = true
          end
      end
      if shE or bit.band(mas, 0x10000) > 0 then
          local obj = que[3] or que[2]
          local enN, zon, x, y = Que:GOP(que, obj)
          local maI = Map.NTMI[zon]
          if maI and (not cur or not cur.CoM) then
              local wx, wy = map:GWP(maI, x, y)
              local f = map:GIS(4)
              if map:CFW(f, wx, wy, nav, nav, 0) then
                  f.NXType = 9000
                  f.NXData = cur
                  f.NxT = format("%s\nEnd: %s (%.1f %.1f)", qna, enN, x, y)
                  if cur and cur.PaN1 then
                      f.NxT = f.NxT .. "\n" .. cur.PaN1
                  end
                  f.tex:SetVertexColor(.6, 1, .6, 1)
                  f.tex:SetTexture("Interface\\AddOns\\Carbonite\\Gfx\\Map\\IconQuestion")
              end
          end
      end
      if not cur or cur.QI > 0 or cur.Par then
          local drA
          if cur then
              local qSt = Nx:GeQ(cur.QId)
              drA = sWA and qSt == "W"
          end
          for n = 1, 15 do
              local obj = que[n + 3]
              if not obj then
                  break
              end
              local obN1, obZ, loc = Que:UnO(obj)
              if obZ then
                  local maI = Map.NTMI[obZ]
                  if not maI then
                      break
                  end
                  if loc and bit.band(mas, bit.lshift(1, n)) > 0 then
                      local coI2 = n
                      if cPQ then
                          coI2 = ((cur and cur.Ind or 1) - 1) % coM + 1
                      end
                      local col2 = qLC[coI2]
                      local r = col2[1]
                      local g = col2[2]
                      local b = col2[3]
                      local ona = cur and cur[n] or obN1
                      if strbyte(obj, loc) == 32 then
                          loc = loc + 1
                          local cnt = floor((#obj - loc + 1) / 4)
                          local sz = nav
                          if cnt > 1 then
                              sz = map:GWZS(maI) / 10.02 * ptS
                          end
                          for loN1 = loc, loc + cnt * 4 - 1, 4 do
                              local x, y = Que:ULPO(obj, loN1)
                              local wx, wy = map:GWP(maI, x, y)
                              local f = map:GIS(4)
                              if map:CFW(f, wx, wy, sz, sz, 0) then
                                  f.NXType = 9000 + n
                                  f.NXData = cur
                                  f.NxT = format("%s\nObj: %s (%.1f %.1f)", qna, ona, x, y)
                                  if cur and cur[n + 400] then
                                      f.NxT = f.NxT .. "\n" .. cur[n + 400]
                                  end
                                  if cnt == 1 then
                                      f.tex:SetTexture("Interface\\AddOns\\Carbonite\\Gfx\\Map\\IconQTarget")
                                      f.tex:SetVertexColor(r, g, b, .9)
                                  else
                                      f.tex:SetTexture("Interface\\AddOns\\Carbonite\\Gfx\\Map\\IconCirclePlus")
                                      f.tex:SetVertexColor(r, g, b, .5)
                                  end
                              end
                          end
                      else
                          local hov = Que.IHC == cur and Que.IHOI == n
                          local tra2 = bit.band(trM, bit.lshift(1, n)) > 0
                          local tip = format("%s\nObj: %s", qna, ona)
                          if cur and cur[n + 400] then
                              tip = tip .. "\n" .. cur[n + 400]
                          end
                          local x
                          if cur then
                              local d = cur["OD" .. n]
                              if d and d > 0 then
                                  x = cur["OX" .. n]
                              end
                          end
                          if x then
                              local y = cur["OY" .. n]
                              local f = map:GeI1(4)
                              local sz = nav
                              if not hov then
                                  sz = sz * .8
                              end
                              if map:CFW(f, x, y, sz, sz, 0) then
                                  f.NXType = 9000 + n
                                  f.NXData = cur
                                  f.NxT = tip
                                  f.tex:SetTexture("Interface\\AddOns\\Carbonite\\Gfx\\Map\\IconAreaArrows")
                                  if tra2 then
                                      f.tex:SetVertexColor(.8, .8, .8, 1)
                                  else
                                      f.tex:SetVertexColor(r, g, b, .7)
                                  end
                              end
                          end
                          if not cur or drA or hov or (bit.band(trM, bit.lshift(1, n)) > 0 and trA > .05) then
                              local sca = map:GWZS(maI) / 10.02
                              local cnt = floor((#obj - loc + 1) / 4)
                              for loN1 = loc, loc + cnt * 4 - 1, 4 do
                                  local lo1 = strsub(obj, loN1, loN1 + 3)
                                  if lo1 == "" then
                                      break
                                  end
                                  local x, y, w, h = Que:ULR(lo1)
                                  local wx, wy = map:GWP(maI, x, y)
                                  local f = map:GIS(hov and 1)
                                  if map:CFTL(f, wx, wy, w * sca, h * sca, 0) then
                                      f.NXType = 9000 + n
                                      f.NXData = cur
                                      f.NxT = tip
                                      if arT1 then
                                          f.tex:SetTexture(arT1)
                                          if hov then
                                              f.tex:SetVertexColor(hoR, hoG, hoB, hoA)
                                          elseif tra2 then
                                              f.tex:SetVertexColor(trR, trG, trB, trA)
                                          else
                                              f.tex:SetVertexColor(r, g, b, col2[4])
                                          end
                                      else
                                          if hov then
                                              f.tex:SetTexture(hoR, hoG, hoB, hoA)
                                          elseif tra2 then
                                              f.tex:SetTexture(trR, trG, trB, trA)
                                          else
                                              f.tex:SetTexture(r, g, b, col2[4])
                                          end
                                      end
                                  end
                              end
                          end
                      end
                  end
              end
          end
      end
  end
  Nx.Tim:PrE("Quest UpdateIcons")
end
function Nx.Que:SBQDT()
  local Map = Nx.Map
  local cMI = Map:GCMI()
  local maI = self.SBMI
  local scC = 0
  while scC < 10 do
      if maI ~= cMI then
          Map:SCM1(maI)
          scC = scC + 1
      end
      local con1 = Map:ITCZ(maI)
      local inf = Map.MaI2[con1]
      maI = maI + 1
      if maI > inf.Max1 then
          if con1 == 4 then
              Map:SCM1(cMI)
              self:RQL()
              return
          end
          maI = (con1 + 1) * 1000 + 1
      end
      self.SBMI = maI
  end
  Map:SCM1(cMI)
  return 0
end
function Nx.Soc.Lis:PuA1(nam, lev, cla)
  local pun = Nx:GeS("Pk")
  nam = Nx.U_CN(nam)
  local pun1 = Nx.Soc.PuA[nam]
  if pun1 then
      lev = lev or pun1.Lvl
      cla = cla or pun1.Cla
  end
  pun[nam] = format("%s~%s~%s", time(), lev or "", cla or "")
end
function Nx.But:GeP()
  return self.Pre
end
function Nx.Map.Gui:CrM()
  local men = Nx.Men:Cre(self.Lis.Frm)
  self.Men = men
  self.MID = men:AdI1(0, "Delete", self.M_OD1, self)
  self.MIGQ = men:AdI1(0, "Add Goto Quest", self.M_OAGQ, self)
  local ite = men:AdI1(0, "Show On All Continents", self.M_OSAC, self)
  ite:SetChecked(true)
  self.SAC = true
  local function fun(self, ite)
      self.SQGC = ite:GetChecked()
      self:Upd()
  end
  local ite = men:AdI1(0, "Show Completed Quest Givers", fun, self)
  ite:SetChecked(false)
  self.SQGC = false
  local str = UnitFactionGroup("player") == "Horde" and "Alliance" or "Horde"
  local ite = men:AdI1(0, "Show " .. str, self.M_OSE1, self)
  ite:SetChecked(false)
  men:AdI1(0, "Clear Selection", self.M_OCS, self)
  local function fun()
      Nx.Opt:Ope("Guide")
  end
  men:AdI1(0, "Options...", fun, self)
end
function Nx.Men:SlU(ite)
  if ite.Tab then
      ite.SlP = ite.Tab[ite.VaN]
  end
  local tfr = ite.STF
  local per = (ite.SlP - ite.SlM1) / (ite.SlM2 - ite.SlM1)
  tfr:SetPoint("TOPLEFT", per * 100, 0)
  if ite.Tex then
      local fst = ite.TFS1
      fst:SetText(format("%s (%.2f)", ite.Tex, ite.SlP))
  end
end
function Nx.Inf:CMP()
  return "|cffe0e0e0", format("%d", self.Var["Mana%"] * 100)
end
function Nx:NXWarehouseKeyToggleShow()
  Nx.War:ToS()
end
function Nx.Que:GZA(alw)
  local mId = Nx.Map:GCMI()
  local a = Nx.Map.MWI[mId].QAI
  if a then
      local id, nam, _, don = GetAchievementInfo(a)
      if alw or not don then
          local _, _, don, cnt, nee = GetAchievementCriteriaInfo(a, 1)
          local col2 = don and "|cff808080" or "|cff8080ff"
          return format("%s%s %d/%d", col2, nam, cnt, nee)
      end
  end
end
function Nx.Map:SIFD(ico, da1, da2)
  ico.FD1 = da1
  ico.FD2 = da2
end
function Nx.But:SeU(use, fun)
  self.Use = use
  self.UsF = fun
end
function Nx.Que:ToP(stC2)
  local tiS = GameTooltipTextLeft1:GetText()
  if not tiS then
      return
  end
  Nx.TLDT = tiS
  local show = Nx.Que:TP2(stC2, tiS)
  show = Nx.War:ToP() or show
  if show then
      GameTooltip:Show()
  end
  Nx.TLDNL = GameTooltip:NumLines()
end
function Nx.Win:M_OFO(ite)
  local v = ite:GeS1()
  local svd = self.MeW.SaD
  svd["FO"] = v
  self.MeW.BFO = v
end
function Nx.Inf:Cr2(ind)
  self.Ind = ind
  self.Dat = NxData.NXInfo[ind] or {}
  NxData.NXInfo[ind] = self.Dat
  local ite1 = self.Dat["Items"]
  if not ite1 then
      ite1 = {}
      self.Dat["Items"] = ite1
      if ind == 1 then
          tinsert(ite1,
              "<IfLTOrCombat;1;Health%><Health><c>HP <t> <HealthChange><c><t> <IfCombat>|cffff4040* <Threat%;player><c><t>")
          tinsert(ite1, "<IfLTOrCombat;1;Health%>     <Health%><c><t>%<BarH%;G;Health%><t>")
          tinsert(ite1, "<IfMana><Mana><c>MP <t> <ManaChange><c><t>")
          tinsert(ite1, "<IfMana>     <Mana%><c><t>%<BarH%;B;Mana%><t>")
          tinsert(ite1, "<Combo><c><t>")
          tinsert(ite1, "<Cooldown><c><t>")
          tinsert(ite1, "<Cast><c><t>")
      elseif ind == 2 then
          tinsert(ite1, "<THealth><c>HP <t>")
          tinsert(ite1, "     <THealth%><c><t>%<BarH%;G;THealth%><t>")
          tinsert(ite1, "<TMana><c>MP <t>")
          tinsert(ite1, "     <TMana%><c><t>%<BarH%;B;TMana%><t>")
          tinsert(ite1, "<Cast;target><c><t>")
      elseif ind == 3 then
          tinsert(ite1, "<Dur><c>Durability <t>%")
          tinsert(ite1, "<LvlTime><c>Lvl <t> hours")
          tinsert(ite1, "")
      elseif ind == 4 then
          tinsert(ite1, "<BGQueue;1><c><t>")
          tinsert(ite1, "<BGQueue;2><c><t>")
          tinsert(ite1, "<BGQueue;3><c><t>")
          tinsert(ite1, "<BGStart><c>BG start <t>")
          tinsert(ite1, "<BGDuration><c>BG duration <t>")
          tinsert(ite1, "<IfF;InBG><BGWingWait><c>Wing wait <t>")
          tinsert(ite1, "<IfBG><BGHonor><c>Honor <t>")
          tinsert(ite1, "<BGStats><c>Stats <t>")
      elseif ind == 5 then
          tinsert(ite1, "<Time;%a %m/%d %I:%M %p><c><t>")
          tinsert(ite1, "<FPS><t>")
          tinsert(ite1, "")
      elseif ind == 6 then
          tinsert(ite1, "<Stat;XPRest%><c>Rest <t>%")
          tinsert(ite1, "")
          tinsert(ite1, "")
      end
  end
  self.HeL = UnitHealth("player")
  self.HLV = 0
  self.MaL = UnitMana("player")
  self.MLV = 0
  if self.Win1 then
      self.Win1:Show()
      return
  end
  local lay1 = {
      [0] = {-.72, -.2, 100, 41},
      {200000, -.20, 110, 80, 1.1},
      {300040, -.20, 120, 80, 1.1}
  }
  Nx.Win:SCF(1, 0)
  local win = Nx.Win:Cre("NxInfo" .. ind, 50, 20, nil, 1, nil, nil, true)
  self.Win1 = win
  win.Frm.NxI = self
  win:STLH(3)
  local lay2 = lay1[ind] or lay1[0]
  local i = ind <= 2 and 0 or ind - 3
  local sca = lay2[5] or 1
  local x = lay2[3] + sca * lay2[4] - lay2[4]
  win:ILD(nil, lay2[1], lay2[2] - i * .06, x, lay2[4], nil, lay2[5])
  win.Frm:SetToplevel(true)
  local bw, bh = win:GBS()
  Nx.Lis:SCF1("FontInfo", 11)
  local lis = Nx.Lis:Cre(false, 0, 0, 1, 1, win.Frm, false, true)
  self.Lis = lis
  lis:SeU(self, self.OLE)
  lis:SLH(0, 0)
  lis:CoA("", 1, 900)
  win:Att(lis.Frm, 0, 1, 0, 1)
  self.Frm1 = {}
  self.Frm1.Nex = 1
  self:Upd()
  self.Lis:FuU()
end
function Nx.Lis:ShL()
  self.Top = self.Num - self.Vis + 1
  self.Top = max(self.Top, 1)
end
function Nx:GIC(noT1)
  if not LoadAddOn("CarboniteNodes") then
      Nx.prt("CarboniteNodes addon could not be loaded!")
      return
  end
  if not CarboniteNodes then
      Nx.prt("CarboniteNodes addon is not loaded!")
      return
  end
  local srT = CarboniteNodes[noT1]
  if srT then
      local cnt = 0
      for maI, zoT in pairs(srT) do
          for noI, noS in pairs(zoT) do
              for n = 1, #noS, 6 do
                  cnt = cnt + 1
                  local nx = tonumber(strsub(noS, n, n + 2), 16) / 40.9
                  local ny = tonumber(strsub(noS, n + 3, n + 5), 16) / 40.9
                  if nx < .1 or nx > 99.9 or ny < .1 or ny > 99.9 then
                  else
                      Nx:Gat(noT1, noI, maI, nx, ny)
                  end
              end
          end
      end
      Nx.prt("Imported %s %s", noT1, cnt)
  end
end
function Nx.Win:Adj(skC)
  local f = self.Frm
  local w = f:GetWidth() - self.BoW * 2
  local h = f:GetHeight() - self.TiH - self.BoH * 2
  for _, fst in ipairs(self.TFS) do
      fst:SetWidth(w - self.BuW)
  end
  if not skC then
      local x, y
      for n = 1, #self.ChF do
          local chi = self.ChF[n]
          local cf = chi.Frm
          x = chi.PX1
          if x < 0 then
              x = w + x
          elseif x <= 1 then
              x = w * x
          end
          local x2 = chi.PX2
          if x2 < 0 then
              x2 = w + x2
          elseif x2 <= 1 then
              x2 = w * x2
          end
          y = chi.PY1
          if y <= -10000 then
              y = y + 10000
          elseif y < 0 then
              y = h + y
          elseif y <= 1 then
              y = h * y
          end
          local y2 = chi.PY2
          if y2 <= -10000 then
              y2 = y2 + 10000
          elseif y2 < 0 then
              y2 = h + y2
          elseif y2 <= 1 then
              y2 = h * y2
          end
          cf:SetPoint("TOPLEFT", f, "TOPLEFT", x + self.BoW, -y - self.ToH)
          local chW = x2 - x
          local chH = y2 - y
          if chi.ScW then
              local sw = chW / chi.ScW
              local sh = chH / chi.ScH
              local sca = max(min(sw, sh), .001)
              cf:SetScale(sca)
              cf:SetPoint("TOPLEFT", f, "TOPLEFT", (self.BoW + w * chi.PX1) / sca, (-self.ToH - h * chi.PY1) / sca)
          else
              local ins = cf.NxI
              if ins and ins.SeS then
                  ins:SeS(chW, chH)
              else
                  cf:SetWidth(chW)
                  cf:SetHeight(chH)
              end
          end
          if cf.NSS then
              cf:NSS(chW, chH)
          end
      end
  end
end
function Nx.Ski:GeT(txN)
  return self.Pat .. txN
end
function Nx.Opt:InT()
  self:NXCmdGryphonsUpdate()
  self:NXCmdCamForceMaxDist()
  Nx.Tim:Sta("OptsQO", 2, self, self.QOT)
end
function Nx.Scr:New(dat, cmd1)
  local scr = {}
  scr.Dat = dat
  scr.Cmd = cmd1
  scr.Pos = 1
  scr.Del = 0
  return scr
end
function Nx:GICH()
  Nx:GIC("NXHerb")
end
function Nx.Inf:CTP(uni)
  local isT, sta, thr, raw, thr1 = UnitDetailedThreatSituation(uni, "target")
  if thr then
      return "|cffc0c0c0", format("%d%%", thr)
  end
end
function Nx.Soc.PHUD:Add(nam)
  if not self.Pun[nam] then
      local pun = Nx.Soc.Pun
      if pun[nam] then
          tinsert(self.Pun, 1, nam)
      else
          local fou
          for n = 1, #self.Pun do
              if not pun[self.Pun[n]] then
                  tinsert(self.Pun, n, nam)
                  fou = true
                  break
              end
          end
          if not fou then
              tinsert(self.Pun, nam)
          end
      end
  end
  self.Pun[nam] = true
  self.Cha = true
end
function Nx.Map:CFZTL(frm, x, y, w, h)
  x, y = self:GWP(self.MaI, x, y)
  return self:CFTL(frm, x, y, w, h)
end
function Nx.HUDGetTracking()
  local map = Nx.Map:GeM(1)
  return map.TrD, map.TDY, map.TrN
end
function Nx.Que:OGIM(ico, typ)
  self.GIMIC:Show(false)
  self.GIMII:Show(false)
  if typ ~= 3000 then
      return
  end
  self.GIMC:Show(false)
  self.GIMI:Show(false)
  if ico.UDQGD then
      self.GIMIC:Show()
      self.GIMII:Show()
      self.GIMCD = ico.UDQGD
      self:UGIM()
  end
end
function Nx.Que.Lis:M_OSP(ite)
  self.ShP = ite:GetChecked()
  self:Upd()
end
function Nx.Soc:OFLU(eve)
  self.Lis:Upd()
end
function Nx.Map:InF1()
  local f = self.Frm
  local m = self
  self.TiF1 = {}
  local tf
  for i = 1, NUM_WORLDMAP_DETAIL_TILES do
      tf = CreateFrame("Frame", nil, f)
      m.TiF1[i] = tf
      local t = tf:CreateTexture()
      t:SetAllPoints(tf)
      tf.tex = t
  end
  Nx.CoB1 = {{0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0}, {0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0},
             {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}}
  self.CoF = {}
  for n = 1, Nx.Map.CoC do
      self.CoF[n] = {}
      local mFN = self.MaI2[n].FiN
      local tex3 = 1
      for i = 1, NUM_WORLDMAP_DETAIL_TILES, 1 do
          if Nx.CoB1[n][i] ~= 0 then
              local cf = CreateFrame("Frame", nil, f)
              m.CoF[n][i] = cf
              local t = cf:CreateTexture()
              t:SetAllPoints(cf)
              cf.tex = t
              if n == 0 then
                  t:SetTexture("Interface\\AddOns\\Carbonite\\Gfx\\Map\\Cont\\" .. "Kal" .. tex3)
                  tex3 = tex3 + 1
              else
                  t:SetTexture("Interface\\WorldMap\\" .. mFN .. "\\" .. mFN .. i)
              end
          end
      end
  end
  local cf = CreateFrame("Frame", nil, f)
  self.CFF = cf
  local t = cf:CreateTexture()
  t:SetAllPoints(cf)
  cf.tex = t
  t:SetTexture("Interface\\AddOns\\Carbonite\\Gfx\\Map\\HBlend")
  t:SetVertexColor(1, 1, 1, .7)
  self.MiF = {}
  for n = 1, self.MiB ^ 2 do
      local tf = CreateFrame("Frame", nil, f)
      m.MiF[n] = tf
      local t = tf:CreateTexture()
      tf.tex = t
      t:SetAllPoints(tf)
  end
  self:InH()
end
function Nx.Fav:Ini()
  self.Fol = Nx.GeF()
  self.NoI = {"Star", "Circle", "Diamond", "Triangle", "Moon", "Square", "Cross", "Skull"}
end
function Nx.Que:M_OW1(ite)
  local cur = self.IMC
  self.Lis:ToW(cur.QId, cur.QI, 0)
end
function Nx.Hel.Lic:OnC()
  Nx.Hel.Lic.Frm:Show()
end
function Nx.Com:UpI(map)
  if Nx.Tic % 20 == 1 then
      local meN = {}
      self.MeN = meN
      local mem = MAX_PARTY_MEMBERS
      local unN = "party"
      if GetNumRaidMembers() > 0 then
          mem = MAX_RAID_MEMBERS
          unN = "raid"
      end
      local maI = map.MaI
      local paI = self.PaI
      for n = 1, mem do
          local uni = unN .. n
          local nam = UnitName(uni)
          if nam then
              local x, y = GetPlayerMapPosition(uni)
              if x ~= 0 or y ~= 0 then
                  meN[nam] = 1
              else
                  local inf = paI[nam]
                  if inf and inf.EMI == maI then
                      meN[nam] = 1
                  end
              end
          end
      end
  end
  local alt = IsAltKeyDown()
  if alt then
      map.Lev = map.Lev + 3
  end
  local opt = Nx:GGO()
  self.TrX = nil
  if map:GWZ(map.RMI).Cit then
      if opt["MapShowOthersInCities"] then
          self:UPI(self.ZPI, map, "IconPlyrZ")
      end
      if opt["MapShowPalsInCities"] then
          self:UPI(self.PaI, map, "IconPlyrG")
      end
  else
      if opt["MapShowOthersInZ"] then
          self:UPI(self.ZPI, map, "IconPlyrZ")
      end
      self:UPI(self.PaI, map, "IconPlyrG")
  end
  if alt then
      map.Lev = map.Lev - 3
  end
  return self.TrN, self.TrX, self.TrY
end
function Nx.Inf:SBGST(sec)
  self.BGSS = sec
  self.BGST = GetTime()
end
function Nx.Fav:OFTF(ite, fol)
  fol = fol or self.Fol
  for ind, it in ipairs(fol) do
      if it == ite then
          return ind
      end
      if it["T"] == "F" then
          ind = self:OFTF(ite, it)
          if ind then
              it["Hide"] = nil
              return ind
          end
      end
  end
end
function Nx.Map:OpM()
  local opt = self:GOT(self.MaI3)
  self.MIPF:SetChecked(self.CuO.NXPlyrFollow)
  self.MISW:SetChecked(self.CuO.NXWorldShow)
  self.MIMZ:SetChecked(Nx.Com:IZM(self.MaI))
  self.MMI = self.MaI
  self.Men:Ope()
end
function Nx.War.OL_1()
  local self = Nx.War
  self.LoT = nil
  self:prt1("LOOT_CLOSED")
end
function Nx.prt(msg, ...)
  local f = Nx.pCF or DEFAULT_CHAT_FRAME
  f:AddMessage(Nx.TXTBLUE .. NXTITLE .. " |cffffffff" .. (format(msg, ...) or "nil"), 1, 1, 1)
end
function Nx.Com:UPI(inf, map, icN)
  local meN = self.MeN
  local iTN = Nx.MITN
  local alt = IsAltKeyDown()
  local reG = abs(GetTime() * 400 % 200 - 100) / 200 + .5
  local iBG = Nx.IBG
  local t = GetTime()
  local sTT = not Nx.Fre
  for nam, pl in pairs(inf) do
      if t - pl.T > 35 then
          inf[nam] = nil
      elseif not meN[nam] and (not iBG or map.MaI ~= pl.MId) and pl.Y then
          local maI = pl.MId
          local wx, wy = map:GWP(maI, pl.X, pl.Y)
          local sz = 14 * map.DZS
          if self.PaN[nam] ~= nil then
              sz = 17 * map.DPS
          end
          if map.TrP[nam] then
              sz = 22 * map.DPS
              self.TrN = nam
              self.TrX, self.TrY = wx, wy
          end
          local f = map:GeI1()
          if map:CFW(f, wx, wy, sz, sz, 0) then
              f.NXType = 1000
              f.NXData2 = nam
              local maN = iTN[maI] or "?"
              local tSt = pl.TSt or ""
              local qSt1 = pl.QSt or ""
              f.NxT = format("%s\n  %s (%d,%d)%s%s", pl.Tip, maN, pl.X, pl.Y, tSt, qSt1)
              local txN = icN
              if self.PaN[nam] == false then
                  txN = "IconPlyrF"
              end
              if bit.band(pl.F, 1) > 0 then
                  txN = txN .. "C"
              end
              f.tex:SetTexture("Interface\\AddOns\\Carbonite\\Gfx\\Map\\" .. txN)
              if alt then
                  local s = pl.TTy == 2 and sTT and (nam .. tSt) or nam
                  local txt = map:GetText(s)
                  map:MTTI(txt, f, 15, 1)
              end
          end
          if pl.Hea then
              f = map:GINI(1)
              local per = pl.Hea / 100
              if per >= .33 then
                  local sc = map.ScD
                  map:CFTL(f, wx - 8 / sc, wy - 8 / sc, 14 * per / sc, 1 / sc)
                  f.tex:SetTexture(1, 1, 1, 1)
              else
                  map:CFW(f, wx, wy, 8, 8, 0)
                  if per > 0 then
                      f.tex:SetTexture(1, .1, .1, 1 - per * 2)
                  else
                      f.tex:SetTexture(0, 0, 0, .5)
                  end
              end
              local tt = pl.TTy
              if tt then
                  local per = pl.TH / 100
                  local f = map:GINI(1)
                  local sc = map.ScD
                  if tt == 1 then
                      map:CFTL(f, wx - 8 / sc, wy - 2 / sc, 14 * per / sc, 1 / sc)
                      f.tex:SetTexture(0, 1, 0, 1)
                  else
                      map:CFTL(f, wx - 8 / sc, wy - 7 / sc, 1 / sc, 13 * per / sc)
                      if tt == 2 then
                          f.tex:SetTexture(reG, .1, 0, 1)
                      elseif tt == 3 then
                          f.tex:SetTexture(1, 1, 0, 1)
                      elseif tt == 4 then
                          f.tex:SetTexture(1, .4, 1, 1)
                      else
                          f.tex:SetTexture(.7, .7, 1, 1)
                      end
                  end
              end
          end
      end
  end
end
function Nx:RegisterEvent(eve, han)
  self.Frm:RegisterEvent(eve)
  if not self.Eve then
      self.Eve = {}
  end
  self.Eve[eve] = han
end
function Nx.Que.Lis:M_OC3(ite)
  local i = self.Lis:IGD()
  if i then
      local qId = bit.rshift(i, 16)
      local qSt, qTi = Nx:GeQ(qId)
      if qSt == "C" then
          qSt = "c"
      else
          qSt = "C"
          qTi = time()
      end
      Nx:SeQ(qId, qSt, qTi)
      self:Upd()
  end
end
function Nx.Fav:GITN(ind)
  local fav = self.CuF
  if fav then
      local typ, fla, nam = strsplit("~", fav[ind])
      return typ, nam
  end
end
function Nx.U_STS(frm)
  local sw = GetScreenWidth()
  local sh = GetScreenHeight()
  local atP, reT, reP, x, y = frm:GetPoint()
  local sc = frm:GetScale()
  local l = frm:GetLeft() * sc
  local r = frm:GetRight() * sc
  local t = frm:GetTop() * sc
  local b = frm:GetBottom() * sc
  local dis = 4
  if abs(l - 0) < dis then
      x = x - l / sc
  end
  if abs(r - sw) < dis then
      x = x - (r - sw) / sc
  end
  if MultiBarLeft:IsVisible() then
      local ml = MultiBarLeft:GetLeft()
      if abs(r - ml) < dis then
          x = x - (r - ml) / sc
      end
  end
  if MultiBarRight:IsVisible() then
      local ml = MultiBarRight:GetLeft()
      if abs(r - ml) < dis then
          x = x - (r - ml) / sc
      end
  end
  if abs(b - 0) < dis then
      y = y - b / sc
  end
  if abs(t - sh) < dis then
      y = y - (t - sh) / sc
  end
  frm:SetPoint(atP, x, y)
  return nil
end
function Nx.Men:Upd()
  local mf = self.MaF
  local meX = 14
  local meY = 14
  local meW = self.Wid
  for n = 1, #self.Ite1 do
      local ite = self.Ite1[n]
      local itF = ite.Frm
      if not ite.ShS then
          if itF then
              itF:Hide()
          end
      else
          local itH = 12
          if not ite.Spa then
              ite.Alp = 0
              ite.AlT = self.I_ALPHAFADE
              if not itF then
                  ite.Frm = CreateFrame("Frame", nil, mf)
                  itF = ite.Frm
                  itF.NMI = ite
                  itF:SetWidth(meW - meX * 2)
                  itF:SetScript("OnEnter", self.I_OE)
                  itF:SetScript("OnLeave", self.I_OL)
                  itF:SetScript("OnUpdate", self.I_OU)
                  itF:SetScript("OnMouseDown", self.I_OMD)
                  itF:SetScript("OnMouseUp", self.I_OMU)
                  local t = itF:CreateTexture()
                  t:SetTexture(1, 1, 1, 1)
                  t:SetAllPoints(itF)
                  itF.tex = t
              end
              if ite.Tex then
                  local fst = ite.TFS1
                  if not fst then
                      fst = itF:CreateFontString()
                      ite.TFS1 = fst
                      fst:SetFontObject("NxFontMenu")
                      fst:SetPoint("TOPLEFT", 20, 0)
                      fst:SetWidth(meW - 20)
                      fst:SetHeight(12)
                      fst:SetJustifyH("LEFT")
                  end
                  if ite.ShS < 0 then
                      fst:SetText("|cff707070" .. ite.Tex)
                  else
                      fst:SetText("|cfff7f7f7" .. ite.Tex)
                  end
                  fst:Show()
              end
              if ite.Che1 then
                  local frm = ite.ChF1
                  if not frm then
                      frm = CreateFrame("Frame", nil, itF)
                      ite.ChF1 = frm
                      frm:SetWidth(12)
                      frm:SetHeight(12)
                      frm.tex = frm:CreateTexture()
                      frm.tex:SetAllPoints(frm)
                  end
                  frm:SetPoint("TOPLEFT", 1, 0)
                  frm:Show()
                  self:ChU(ite)
              end
              if ite.Sli then
                  itF:SetScript("OnMouseWheel", self.I_OMW)
                  itF:EnableMouseWheel(true)
                  local h = 10
                  local frm = ite.SlF
                  if not frm then
                      frm = CreateFrame("Frame", nil, itF)
                      ite.SlF = frm
                      frm:SetWidth(102)
                      frm:SetHeight(h)
                      frm.tex = frm:CreateTexture()
                      frm.tex:SetAllPoints(frm)
                      frm.tex:SetTexture(0, 0, 0, .5)
                  end
                  local tfr = ite.STF
                  if not tfr then
                      tfr = CreateFrame("Frame", nil, frm)
                      ite.STF = tfr
                      tfr:SetWidth(3)
                      tfr:SetHeight(h)
                      tfr.tex = tfr:CreateTexture()
                      tfr.tex:SetAllPoints(tfr)
                      tfr.tex:SetTexture(.5, 1, .5, 1)
                  end
                  frm:SetPoint("TOPLEFT", 12, -itH - 1)
                  frm:Show()
                  self:SlU(ite)
                  itH = itH + h + 2
              end
              itF:SetPoint("TOPLEFT", meX, -meY)
              itF:SetHeight(itH)
              itF:Show()
              itF:EnableMouse(true)
          end
          meY = meY + itH + 1
      end
  end
  return meY
end
function Nx.HUD:Show(show)
  self.Win1:Show(show)
end
function Nx.Win:OMD(but)
  local win = this.NxW
  local x, y = GetCursorPosition()
  x = x / this:GetEffectiveScale()
  y = y / this:GetEffectiveScale()
  ResetCursor()
  if win.Sec1 and InCombatLockdown() then
      return
  end
  if but == "LeftButton" then
      local sid = win:IOWUI(x, y)
      if win.Siz then
          if sid > 0 then
              this:StartSizing(win.SiN[sid])
              win.MoS = true
          end
      end
      if not win.MoS and sid == 0 then
          this:StartMoving()
          win.MoS = true
      end
      if win.MoS then
          SetCursor("INSPECT_CURSOR")
          this:SetFrameStrata("HIGH")
      end
  elseif but == "MiddleButton" then
      win:ToS1()
  elseif but == "RightButton" then
      if IsShiftKeyDown() and IsControlKeyDown() then
          win:ReL1()
      else
          win:OpM(win.NoB)
      end
  end
end
function Nx.Que.Lis:M_OS3(ite)
  local i = self.Lis:IGD()
  if i then
      local qi = bit.band(i, 0xff)
      if qi > 0 then
          if GetNumPartyMembers() > 0 then
              QuestLogPushQuest()
          else
              Nx.prt("Must be in party to share")
          end
      end
  end
end
function Nx.Soc:HideUIPanel(fra)
  if self.Win1 then
      self.NoS = true
      self:RFF()
      self:Show(false)
      self.NoS = false
  end
end
function Nx.Que:GLT(cur)
  local tit = format("[%d] %s", cur.Lev, cur.Tit)
  local que = cur.Q
  if que and que.CNu then
      tit = tit .. format(" (Part %d of %d)", que.CNu, cur.CNM)
  end
  return tit
end
function Nx.U_IMO(frm)
  local x, y = GetCursorPosition()
  x = x / frm:GetEffectiveScale()
  local lef = frm:GetLeft()
  local rig = frm:GetRight()
  if x >= lef and x <= rig then
      y = y / frm:GetEffectiveScale()
      local top = frm:GetTop()
      local bot = frm:GetBottom()
      if y >= bot and y <= top then
          return x - lef, y - bot
      end
  end
end
function Nx.Win:CrB(clo, max1, min2)
  self.Clo = clo
  self.Max = max1
  self.Min = min2
  local x = -self.BoW
  if self.Clo then
      self.BuC.Frm:Show()
  end
  x = x - 15
  if self.Siz and self.Max then
      self.BuM = Nx.But:Cre(self.Frm, "Max", nil, nil, x, -self.BoH, "TOPRIGHT", 12, 12, self.OMB, self)
      x = x - 15
  end
  if self.Min then
      local y = self.Siz and -self.BoH or -3
      self.BuM1 = Nx.But:Cre(self.Frm, "Min", nil, nil, x, y, "TOPRIGHT", 12, 12, self.OMB1, self)
      x = x - 15
  end
  self.BuW = -x - self.BoW
  self:Loc1(self:IsL())
end
function Nx.Lis:GeS4()
  return self.Sel
end
function Nx.Pro:New(use, fun, del)
  local p = {}
  tinsert(self.Pro1, p)
  p.Use = use
  p.Fun = fun
  p.Del = del or 1
end
function Nx.U_21(col1)
  local r = tonumber(strsub(col1, 1, 2), 16) / 255
  local g = tonumber(strsub(col1, 3, 4), 16) / 255
  local b = tonumber(strsub(col1, 5, 6), 16) / 255
  return r, g, b
end
function Nx.Ski:Upd()
  local opt = self.GOp
  self.BdC = {Nx.U_23(opt["SkinWinBdColor"])}
  self.BgC = {Nx.U_23(opt["SkinWinSizedBgColor"])}
  self.FBC = {Nx.U_23(opt["SkinWinFixedBgColor"])}
  Nx.Win:ReB()
  Nx.Men:ReS()
end
function Nx.Hel.Dem:Sta(qui)
  self:Cre()
  self.X = 0
  self.Y = 0
  self.NXXV = 0
  self.NXYV = 0
  self.Sca = 1
  self.ScT = 1
  self.Alp = 0
  self.NXAlphaTarget = 1
  local cmd1 = {"Text^NXFStr1^Demo starting...", "^240", "Text^NXFStr1^The CARBONITE minimap icon can be clicked",
                "^240", "Text^NXFStr1^Left click to toggle map\nRight click for menu", "^240",
                "Text^NXFStr1^The menu can be used to open the help window", "^240", "Func^NXOpenHelp",
                "Text^NXFStr1^Read the help to learn the basic features\n\nThe End", "^240", "Set^NXAlphaTarget^0",
                "Set^NXYV^-2", "^240"}
  if qui then
      cmd1 = {"Func^NXOpenHelp"}
  end
  self.Scr = Nx.Scr:New(self, cmd1)
  Nx.Pro:New(self, self.Tic, 1)
end
function Nx.Que.Lis:OSQIT()
  local qi = self.SQIQI
  local i, cur = Nx.Que:FCBI(qi)
  if not i then
      return
  end
  local seS
  local mod1 = self.SQIM
  if mod1 == -1 then
      seS = self:MDL(cur)
      mod1 = 0
  else
      local des1 = cur[mod1]
      if not des1 then
          return
      end
      seS = format("  %s", des1)
  end
  if self.SQT then
      SendChatMessage(seS, "WHISPER", self.SQL, self.SQT);
  else
      Nx.Com:Sen("P", seS)
  end
  self.SQIM = mod1 + 1
  return .33
end
function Nx.EdB.OTC()
  local self = this.NxI
  self.FiS = gsub(this:GetText(), self.FDE, "")
  if self.UsF then
      self.UsF(self.Use, self, "Changed")
  end
end
function Nx.Map:GCFP(woX, woY)
  if woY < -2050 then
      return 3
  end
  if woX > 2200 then
      return 2
  end
  return 1
end
function Nx.Que.Lis:Upd()
end
function Nx.Opt:CaC(nam, mod1, val)
  if nam == "FontFace" then
      if mod1 == "Inc" then
          local i = Nx.Fon:GeI(val) + 1
          return Nx.Fon:GetName(i) or Nx.Fon:GetName(1)
      elseif mod1 == "Get" then
          dat = {}
          for n = 1, 999 do
              local nam = Nx.Fon:GetName(n)
              if not nam then
                  break
              end
              tinsert(dat, nam)
          end
          sort(dat)
          return dat
      end
      return
  elseif nam == "HUDAGfx" then
      return Nx.HUD.TeN
  elseif nam == "Anchor" then
      return self.ChA
  elseif nam == "Anchor0" then
      return self.CA0
  elseif nam == "Chat" then
      return Nx:pGCF()
  elseif nam == "Corner" then
      return self.ChC
  elseif nam == "MapFunc" then
      return Nx.Map:GeF4()
  elseif nam == "QArea" then
      return self.CQA
  end
end
function Nx.Map:GM_OTI()
  local ico = self.ClI
  local maI = ico.UDa
  if maI then
      if self.IMI == maI then
          self:SIM(nil)
      else
          local atl = getglobal("AtlasMaps")
          if not (Nx.Map.InI1[maI] or atl) then
              UIErrorsFrame:AddMessage("Non WotLK instance maps require the Atlas addon be installed", 1, .1, .1, 1)
              return
          end
          self:SIM(maI)
      end
  end
end
function Nx.Opt:NXCmdQWFadeAll(ite, var)
  Nx.Que.Wat:WUF(var and Nx.Que.Wat.Win1:GeF2() or 1, true)
end
function Nx.Com:Ini()
  if NCO.Version < NCOMOPTS_VERSION then
      if NCO.Version ~= 0 then
          Nx.prt("Com options reset (%f, %f)", NCO.Version, NCOD.Version)
      end
      NCO = NCOD
  end
  self.Cre1 = false
  self.Dat = {}
  self.Dat.Rcv = {}
  self.Dat.Sen = {}
  self.Nam = "Crb"
  self.CAL = Nx.Fre and "Y" or Nx.Ads and "M" or "B"
  self.SeR = 1
  self.SQN = {
      ["Chan"] = 1,
      ["Guild"] = 2,
      ["Friend"] = 3,
      ["Zone"] = 4
  }
  local sq = {}
  self.SeQ1 = sq
  sq[1] = {}
  sq[2] = {}
  sq[3] = {}
  sq[4] = {}
  self.SQM = 1
  self.PaI = {}
  self.PSQ = {}
  self.PaN = {}
  self.MeN = {}
  self.Fri = {}
  self.Pun = {}
  self.ZPI = {}
  self.ZSt = {}
  self.ZMo = {}
  self.VeP = {}
  self.SCQ = {}
  self.PSN = -2
  self.SZS = 1
  self.TyC = {"|cff80ff80", "|cffff4040", "|cffffff40", "|cffffffe0", "|cffc0c0ff"}
  self.ClN = {
      [0] = "?",
      "Druid",
      "Hunter",
      "Mage",
      "Paladin",
      "Priest",
      "Rogue",
      "Shaman",
      "Warlock",
      "Warrior",
      "Deathknight"
  }
  for k, v in ipairs(self.ClN) do
      self.ClN[v] = k
      self.ClN[strupper(v)] = k
  end
  self.Cre1 = true
  self.Lis.Ope1 = false
  self.Lis.Sor = {}
  self.SeB = 0
  self.SBS1 = 0
  self.SBT = GetTime()
  Nx.Tim:Sta("ComBytesSec", 1, self, self.OBST)
  hooksecurefunc("SendChatMessage", self.SCH)
end
function Nx.Que:UnO(obj)
  if not obj then
      return
  end
  local i = strbyte(obj) - 35 + 1
  local des1 = strsub(obj, 2, i)
  if #obj == i then
      return des1
  end
  local zon = strbyte(obj, i + 1) - 35
  return des1, zon, i + 2
end
function Nx.Que:IOL(frm)
  self.IHC = nil
end
function Nx.Com:OF_()
  local self = Nx.Com
  local gNa = {}
  local gNu = GetNumGuildMembers()
  for n = 1, gNu do
      local nam, _, _, _, _, _, _, _, onl = GetGuildRosterInfo(n)
      if onl then
          gNa[nam] = true
      end
  end
  self.Fri = {}
  local i = 1
  for n = 1, GetNumFriends() do
      local nam, lvl, cla, are, con, sta = GetFriendInfo(n)
      if con then
          if not gNa[nam] then
              self.Fri[i] = nam
              i = i + 1
          end
      end
  end
  for k, v in ipairs(self.Fri) do
      gNa[v] = false
  end
  self.PaN = gNa
end
function Nx:NXMapKeyTogOriginal()
  Nx.Map.BlT = true
  ToggleWorldMap()
  Nx.Map.BlT = nil
end
function Nx:ICD()
  local tDa = CarboniteTransferData
  if not tDa then
      Nx.prE("Carbonite Transfer addon is not loaded")
      return
  end
  local acN = GetCVar("accountName")
  if acN == "" then
      Nx.prE("'Remember Account Name' must be checked")
      return
  end
  local reN = GetRealmName()
  for aNa, aDa in pairs(tDa) do
      if aNa ~= acN then
          if aDa.Version ~= Nx.VERSIONTD then
              Nx.prt("Account %s data has wrong version", aNa)
          else
              for rNa, rDa in pairs(aDa) do
                  if rNa == reN then
                      Nx.prt("Importing accout %s", aNa)
                      for cNa, cDa in pairs(rDa) do
                          local rc = rNa .. "." .. cNa
                          NxData.Characters[rc] = cDa
                          cDa["Account"] = aNa
                      end
                      aDa[rNa] = nil
                  end
              end
          end
      end
  end
end
function Nx.Map:DrT1(srX, srY, dsX, dsY, tex2, mod1, nam)
  local x = dsX - srX
  local y = dsY - srY
  local dis = (x * x + y * y) ^ .5
  self.TDY = dis * 4.575
  if tex2 ~= false then
      local f = self:GeI1(1)
      local siz = 16 * self.INS
      self:CFW(f, dsX, dsY, siz, siz, 0)
      local s = nam or self.TrN
      f.NxT = format("%s\n%d yds", s, dis * 4.575)
      f.tex:SetTexture(tex2 or "Interface\\AddOns\\Carbonite\\Gfx\\Map\\IconWayTarget")
  end
  self.TrD = false
  if 1 then
      local dir = math.deg(math.atan2(y, x)) + 90
      self.TrD = dir
      local sx = self.ScD
      local sy = self.ScD / 1.5
      x = x * sx
      y = y * sy
      local cnt = (x * x + y * y) ^ .5 / 15 / self.INS
      if cnt < 5 then
          cnt = cnt + .5
      end
      cnt = min(floor(cnt), 40)
      if cnt >= 1 then
          local dx = x / cnt
          local dy = y / cnt
          local off = self.ArS
          x = dx * off
          y = dy * off
          local siz = 16 * self.INS
          local usI = true
          local f
          for n = 1, cnt do
              local wx = srX + x / sx
              local wy = srY + y / sy
              if usI then
                  usI = false
                  f = self:GINI()
              end
              if self:CFW(f, wx, wy, siz, siz, dir) then
                  f.tex:SetTexture("Interface\\AddOns\\Carbonite\\Gfx\\Map\\IconArrowGrad")
                  if mod1 == "B" then
                      f.tex:SetVertexColor(.7, .7, 1, .5)
                  elseif mod1 == "F" then
                      f.tex:SetVertexColor(1, 1, 0, .9)
                  elseif mod1 == "D" then
                      f.tex:SetVertexColor(1, 0, 0, 1)
                  end
                  usI = true
              end
              x = x + dx
              y = y + dy
          end
      end
  end
end
function Nx.NXMiniMapBut:M_OSH()
  Nx.Hel:Ope()
end
function Nx:AHE(nam, time, maI, x, y)
  self:AdE("Herb", nam, time, maI, x, y)
end
function Nx.Map:ITN(maI)
  return Nx.MITN[maI] or "?"
end
function Nx.Hel.Dem:StO()
  local opt = Nx:GGO()
  if not opt["DemoShown"] then
      opt["DemoShown"] = true
      Nx.Hel.Dem:Sta(true)
  end
end
function Nx.Fav:GNF(maI)
  local not1 = self:FiF("Notes")
  if not not1 then
      not1 = self:AdF1("Notes")
  end
  local nam = Nx.Map:ITN(maI)
  local fav = self:FiF1(nam, "Name", not1)
  if not fav then
      fav = self:AdF2(nam, not1)
      fav["ID"] = maI
      sort(not1, function(a, b)
          return a["Name"] < b["Name"]
      end)
  end
  return fav
end
function Nx.Map:M_ODPS(ite)
  self.DPS = ite:GeS1()
end
function Nx.Opt:NXCmdHUDChange()
  Nx.HUD:UpO()
end
function Nx.Map:SITAS(icT, sca)
  local d = self.Dat
  assert(d[icT])
  d[icT].AtS = sca
end
function Nx.Win:EnM(on)
  self.MeD = not on
end
function Nx.Lis:Sor1()
  local col3 = self.Col[self.SCI]
  local cDa = col3.Dat
  if not cDa then
      return
  end
  self.Sor = true
  local cND = self.Col[2].Dat
  local t = {}
  for n = 1, self.Num do
      local nam = gsub(cND[n], "|cff......", "")
      t[n] = gsub(cDa[n] or "", "|cff......", "") .. " " .. strsub(nam, 1, 1) .. "~" .. n
  end
  sort(t)
  for n = 1, #t do
      local _, i = strsplit("~", t[n])
      t[n] = tonumber(i)
  end
  local dat = {}
  for n = 1, #t do
      dat[n] = self.Dat[t[n]]
  end
  self.Dat = dat
  for k, col3 in pairs(self.Col) do
      if col3.Dat then
          local dat = {}
          for n = 1, #t do
              dat[n] = col3.Dat[t[n]]
          end
          col3.Dat = dat
      end
  end
  if self.BuD then
      local dat = {}
      for n = 1, #t do
          local i = t[n]
          dat[n] = self.BuD[i]
          dat[-n] = self.BuD[-i]
          dat[n + 1000000] = self.BuD[i + 1000000]
          dat[n + 2000000] = self.BuD[i + 2000000]
          dat[n + 3000000] = self.BuD[i + 3000000]
          dat[n + 8000000] = self.BuD[i + 8000000]
          dat[n + 9000000] = self.BuD[i + 9000000]
      end
      self.BuD = dat
  end
  if self.Off then
      local dat = {}
      for n = 1, #t do
          dat[n] = self.Off[t[n]]
      end
      self.Off = dat
  end
end
function Nx.ShowUIPanel(fra)
  if fra then
      local opt = Nx:GGO()
      if fra == getglobal("FriendsFrame") and opt["SocialEnable"] then
          Nx.Soc:ShowUIPanel(fra)
      elseif fra == getglobal("QuestLogFrame") then
          Nx.Que:ShowUIPanel(fra)
      else
          if not InCombatLockdown() then
              fra:Raise()
          end
      end
  end
end
function Nx.War:UpI2(pre, nam, baC, baC1, maC3, lin, sIL)
  local lis = self.ItL
  nam = nam or lin
  baC = tonumber(baC)
  baC1 = tonumber(baC1)
  maC3 = tonumber(maC3)
  local tot = baC + baC1 + maC3
  local str
  if baC1 + maC3 == 0 then
      if baC <= 1 then
          str = format("%s", nam)
      else
          str = format("%s  |r%s", nam, baC)
      end
  else
      str = format("%s  |r%s", nam, baC)
      if baC1 > 0 then
          str = format("%s |cffcfcfff(%s Bank)", str, baC1)
      end
      if maC3 > 0 then
          str = format("%s |cffcfffff(%s Mail)", str, maC3)
      end
  end
  local ina1, iLi, iRa, lvl, miL, ity, suT, stC, eqL, tx = GetItemInfo(lin)
  if not ina1 then
      iLi = lin
      iRa = 0
      miL = 0
  end
  iRa = min(iRa, 6)
  local col2 = iRa == 1 and "|cffe7e7e7" or ITEM_QUALITY_COLORS[iRa]["hex"]
  local show = true
  local ist = pre .. col2 .. str
  if sIL and lvl then
      ist = ist .. ",  |ri" .. lvl
  end
  local fiS = self.EdB:GetText()
  if fiS ~= "" then
      local lst = strlower(format("%s", ist))
      local fiS1 = strlower(fiS)
      show = strfind(lst, fiS1, 1, true)
  end
  if show then
      lis:ItA(0)
      if tot > 1 then
          lis:ItS(2, format("|cffcfcfff%s  ", baC + baC1 + maC3))
      end
      if miL > UnitLevel("player") then
          ist = format("%s |cffff4040[%s]", ist, miL)
      end
      lis:ItS(3, ist)
      lis:ISB("WarehouseItem", false, tx, "!" .. iLi)
      local s1, s2, id = strfind(lin, "item:(%d+)")
      assert(s1)
      assert(id)
      if self.IOI == id then
          local pos1 = 1
          for n = 1, 99 do
              local e = strfind(self.ItO, "\n", pos1)
              str = strsub(self.ItO, pos1, e and e - 1)
              lis:ItA(0)
              lis:ItS(3, format("        %s", str))
              if not e then
                  break
              end
              pos1 = e + 1
          end
      end
  end
end
function Nx:GICM1()
  Nx:GIC1("Mining")
end
function Nx.Fav:B_OD()
  self:MoC()
end
function Nx.Lis:ItS(coI, str, ind)
  local i = ind or self.Num
  local col3 = self.Col[coI]
  col3.Dat[i] = str
end
function Nx.Inf:CBGS()
  local inf = Nx.Inf
  if Nx.IBG and inf.BGST then
      local i = inf.BGSS - (GetTime() - inf.BGST)
      if i >= 0 then
          return "|cff8080ff", format("%d:%02d", i / 60 % 60, i % 60)
      else
          inf.BGST = nil
      end
  else
      inf.BGST = nil
  end
end
function Nx:OP_(eve, ...)
  Nx.OP__3()
  Nx:RCL()
  Nx.Com:OnE(eve)
  Nx.BCF_DTP = ChatFrame_DisplayTimePlayed
  ChatFrame_DisplayTimePlayed = function()
  end
  RequestTimePlayed()
end
function Nx.TaB:AdT1(nam, ind, wid, pre2, template, buI)
  local tab = {}
  self.Tab1[ind] = tab
  tab.Nam = nam
  local w = wid or 66
  local x = 1 + (ind - 1) * (w + 2)
  tab.W = w
  local but1 = Nx.But:Cre(self.ToF1, "Tab", nam, nil, x, -1, "TOPLEFT", w, 20, self.OnB, self, template)
  tab.But2 = but1
  if buI then
      but1.Frm:SetID(buI)
  end
  but1:SeI(ind)
  if pre2 then
      but1:SeP2(true)
      local txt = "|cffffffff" .. nam
      but1:SetText(txt, 0, 2)
  end
end
function Nx.Com:OC__(eve)
  local self = Nx.Com
  if strsub(arg9, 1, 3) == self.Nam then
      local nam = arg2
      if nam ~= self.PlN then
          local msg = self:ReC2(arg1)
          local id = strbyte(msg)
          if id == 83 then
              if not self.PaI[nam] then
                  if #msg >= 16 then
                      local pl = self.ZPI[nam]
                      if not pl then
                          pl = {}
                          self.ZPI[nam] = pl
                      end
                      self:PPS(nam, pl, msg)
                  end
              end
          elseif id == 86 then
              self:OMV(nam, msg)
          end
      end
  end
end
function Nx.U_22(col1)
  local r = tonumber(strsub(col1, 1, 2), 16) / 255
  local g = tonumber(strsub(col1, 3, 4), 16) / 255
  local b = tonumber(strsub(col1, 5, 6), 16) / 255
  local a = tonumber(strsub(col1, 7, 8), 16) / 255
  return r, g, b, a
end
function Nx.Map.Gui:SeL2()
  local i = self.PHS[max(#self.PaH - 1, 1)]
  if i and i <= self.Lis:IGN() then
      self.Lis:Sel1(i)
  end
  self.Lis:Upd()
  local i = self.PHS[#self.PaH]
  if i and i <= self.Li2:IGN() then
      self.Li2:Sel1(i)
  end
  self.Li2:Upd()
end
function Nx.Map:RoS(rou, fir, len)
  local las = fir + len - 1
  local sto = fir + floor(len / 2) - 1
  local n2 = las
  for n = fir, sto do
      rou[n], rou[n2] = rou[n2], rou[n]
      n2 = n2 - 1
  end
  for n = fir - 1, las do
      local r1 = rou[n]
      local r2 = rou[n + 1]
      r1.Dis = ((r1.X - r2.X) ^ 2 + (r1.Y - r2.Y) ^ 2) ^ .5
  end
end
function Nx.Com:OVT()
  self:SSG("V ", self:MVM())
  if IsInGuild() then
      GuildRoster()
  end
  self:LeC1("A")
end
function Nx.Map:OMNGTG(nam)
  self.MMF:SetBlipTexture("Interface\\AddOns\\Carbonite\\Gfx\\Map\\MMOIconsG")
  Nx.Tim:SeF(nam, self.OMNGT)
  return self.GOp["MapMMNodeGD"] / 2
end
function Nx:NXMapKeyTogNormalMax()
  Nx.Map:ToS1()
end
function Nx.Lis:SeU(use, fun)
  self.Use = use
  self.UsF = fun
end
function Nx.NXMiniMapBut:M_OSM()
  Nx.Map:ToS1()
end
function Nx.Map.Gui:PaD()
  Nx.GuD = Nx["GuideData"] or Nx.GuD
  Nx.NPCD = Nx["NPCData"] or Nx.NPCD
  local dat = Nx.GuD
  local npc = Nx.NPCD
  local fix = {"Mailbox", 2, nil, 1068, 81.5, 21.1, 2, nil, 1068, 60.8, 55.5, 2, nil, 1068, 53.6, 65.8, 2, nil, 1068,
               49.5, 71.3, 2, nil, 1068, 38.1, 74.8, 2, nil, 1068, 45.6, 54.1, 2, nil, 1068, 51.7, 59.1, 2, nil, 2108,
               69.8, 36.4, 2, nil, 2108, 62.2, 36.4, 2, nil, 2108, 62.1, 51.6, 2, nil, 2108, 69.7, 51.6, 2, nil, 2108,
               71.4, 61.6, 1, nil, 1032, 67.0, 16.4, 1, nil, 1032, 55.8, 45.5, 1, nil, 1032, 59.8, 55.0, 1, nil, 1032,
               64.8, 71.2, 1, nil, 2084, 72.8, 48.6, 1, nil, 2084, 66.6, 65.3, 1, nil, 2084, 72.5, 69.1, 1, nil, 2084,
               67.4, 49.7, 1, nil, 2084, 61.5, 43.5, 1, nil, 2084, 60.7, 50.6, 1, nil, 2084, 54.6, 63.0, 1, nil, 2084,
               45.7, 54.0, 1, nil, 2084, 50.9, 70.5, 1, nil, 2084, 57.3, 71.7, 1, nil, 2084, 62.5, 74.8, 1, nil, 2084,
               61.6, 70.7, 1, nil, 2084, 49.7, 87.0, 1, nil, 2084, 40.9, 62.0, 1, nil, 2084, 36.8, 69.1, 1, nil, 2084,
               54.7, 57.6, 1, nil, 2084, 64.7, 37.0, 1, nil, 2084, 75.7, 64.6, 1, nil, 2084, 37.9, 34.4, 1, nil, 2084,
               30.3, 25.5, 1, nil, 2084, 30.3, 49.2}
  local typ
  local n = 1
  while fix[n] do
      if type(fix[n]) == "string" then
          typ = fix[n]
          n = n + 1
      else
          local x = fix[n + 3] * 100
          local y = fix[n + 4] * 100
          local xs = strchar(floor(x / 221) + 35, x % 221 + 35)
          local ys = strchar(floor(y / 221) + 35, y % 221 + 35)
          local con1 = floor(fix[n + 2] / 1000)
          local zon = fix[n + 2] % 1000
          if fix[n + 1] then
          else
              local s = format("%c%c%s%s", fix[n] + 35, zon + 35, xs, ys)
              dat[typ][con1] = dat[typ][con1] .. s
          end
          n = n + 5
      end
  end
end
function Nx.Opt:NXCmdDeleteMine()
  local function fun()
      Nx:GDM()
  end
  Nx:ShM("Delete Mine Locations?", "Delete", fun, "Cancel")
end
function Nx.Map:OMW(val1)
  this.NxM1:MoW(val1)
end
function Nx.Que:QSAT()
  local qi = self.QSDI
  local dat = self.QSD[qi]
  if dat then
      Nx.Com:Sen("W", dat, self.SeP4)
  end
  self.QSDI = qi + 1
  if self.QSD[self.QSDI] then
      return .2
  end
  self.SeP4 = nil
end
function Nx.Men:AdI1(id, tex1, fun, use)
  local ite = {}
  self.Ite1[#self.Ite1 + 1] = ite
  setmetatable(ite, Nx.MeI)
  ite.Men = self
  ite.Id = id
  ite.Tex = tex1
  ite.Fun = fun
  ite.Use = use
  ite.ShS = 1
  if tex1 == "" then
      ite.Spa = true
  end
  return ite
end
function Nx.Que.Wat:M_OS3(ite)
  local qi = self.MQI1
  if qi > 0 then
      if GetNumPartyMembers() > 0 then
          Nx.Que:ExQ()
          QuestLogPushQuest(qi)
          Nx.Que:REQ()
      else
          Nx.prt("Must be in party to share")
      end
  end
end
function Nx.Win:CoP(str)
  local nam, x, y = self:PaC(str)
  if not (x and y) then
      Nx.prt("XY missing (%s)", str)
      return
  end
  local win = self:FNC(nam)
  if win then
      win:SeP1(x, -y)
      return
  end
  Nx.prt("Window not found (%s)", str)
end
function Nx:GeS(typ)
  local rn = GetRealmName()
  return NxData.NXSocial[rn][typ]
end
function Nx:UII()
  local qc = {}
  self.QuC = qc
  for n = -1, 10 do
      local r, g, b, hex = GetItemQualityColor(n)
      qc[n] = hex
  end
  qc[1] = "|cffe7e7e7"
  Nx.Fon:Ini()
  Nx.Ski:Ini()
  Nx.Men:Ini()
  Nx.Win:Ini()
  Nx.But:Ini()
  Nx.Lis:Ini()
  Nx.DrD:Ini()
  Nx.ToB:Ini()
end
function Nx.Map:MOL(mot)
  local map = Nx.Map.Map1[1]
  if map.MMZT ~= 0 then
      this.NxM1 = map
      map:IOL(mot)
  end
end
function Nx.Tim:PrD()
  sort(self.Pro2, function(a, b)
      return a.Nam < b.Nam
  end)
  Nx.prt("Profiler: FPS %.0f", GetFramerate())
  for _, pro4 in ipairs(self.Pro2) do
      Nx.prt(" %s %.4f %.4f avrg, #%s, %.3f tot", pro4.Nam, pro4.TiL2, pro4.Tim1 / pro4.Cnt, pro4.Cnt, pro4.Tim1)
  end
  Nx.prt("Run time %.0f", GetTime() - self.RuT)
end
function Nx.Map:MCZT(cle)
  local maI = self.MaI
  local wzo = self:GWZ(maI)
  if not cle and (not wzo or wzo.Cit or self:IBGM(maI)) then
      local alp = self.BaA * (wzo.Alp or 1)
      self:MZT(self.Con, self.Zon, self.TiF1, alp, self.Lev)
      self.Lev = self.Lev + 1
  else
      local frm1, frm
      frm1 = self.TiF1
      for i = 1, NUM_WORLDMAP_DETAIL_TILES do
          frm = frm1[i]
          if frm then
              frm:Hide()
          end
      end
  end
end
function Nx.Map:OBZI()
  self:SSOT(2)
end
function Nx.War.OB_2()
  local self = Nx.War
  if self.Ena then
      self.BaO = false
      self:CaU()
  end
end
function Nx.Win:SBGA(min, max)
  self.BAM = min
  self.BAD = max - min
  self.BaF = self.BFT + .0001
end
function Nx.AuA.OA___()
  Nx.AuA:Upd()
end
function Nx.Fav:OLE(evN, sel, va2, cli)
  local dat = self.Lis:IGD(sel)
  if not dat then
      self.CuF1 = self.Fol
      self.CuF = nil
  else
      if dat["T"] == "F" then
          self.CuF1 = dat
          self.CuF = nil
      else
          self.CuF1 = self:GetParent(dat)
          self.CuF = dat
          self:SeI1(1)
      end
  end
  self.CFOF = dat
  self.Sid = 1
  if evN == "select" or evN == "mid" or evN == "menu" then
      if evN == "menu" then
          self.Men:Ope()
      end
      self:Upd()
  elseif evN == "button" then
      self.Lis:Sel1(sel)
      if dat then
          if dat["Hide"] then
              dat["Hide"] = nil
          else
              dat["Hide"] = true
          end
          self:Upd()
      end
  end
end
function Nx.Que.Lis.FOEFL()
  local self = this.NxI
  if self.Fil[self.TaS1] == "" then
      this:SetText(self.FiD)
  end
end
function Nx.Fav:M_OC()
  local ite = self.CFOF
  if ite then
      local par = self:GetParent(ite)
      for i, it in ipairs(par) do
          if it == ite then
              tremove(par, i)
              self.CoB = ite
              self:Upd()
          end
      end
      self:SeC1()
  end
end
function Nx.Inf:CBGQ(num)
  local n = tonumber(num) or 1
  local sta, nam = GetBattlefieldStatus(n)
  if sta == "queued" then
      nam = gsub(nam, "%U", "")
      local i = (GetBattlefieldEstimatedWaitTime(n) - GetBattlefieldTimeWaited(n)) / 1000
      if i >= 0 then
          return "", format("%s ETA %d:%02d", nam, i / 60 % 60, i % 60)
      else
          return "|cffff0000", format("%s ETA -%d:%02d", nam, -i / 60 % 60, -i % 60)
      end
  elseif sta == "confirm" then
      nam = gsub(nam, "%U", "")
      local i = GetBattlefieldPortExpiration(n) / (Nx.V32 and 1 or 1000)
      return "|cff00ff00", format("%s cancel %d:%02d", nam, i / 60 % 60, i % 60)
  end
end
function Nx.Tra:TaT2()
  if UnitOnTaxi("player") then
      Nx.Map.TETA1 = max(0, self.TTE - GetTime())
      return .5
  end
end
function Nx.prD(msg)
  if Nx.DebugOn then
      Nx.prt(msg)
  end
end
function Nx.Opt:NXCmdMMButUpdate()
  Nx.Map:MBSU()
  Nx.Map.Doc:UpO()
end
function Nx.Que.Lis:M_OA(ite)
  local i = self.Lis:IGD()
  if i then
      local qIn = bit.band(i, 0xff)
      local qId = bit.rshift(i, 16)
      Nx.Que:Aba(qIn, qId)
  end
end
function Nx.NXMiniMapBut:Ini()
  local opt = Nx:GGO()
  local f = NXMiniMapBut
  if not opt["MapMMButOwn"] then
      f:RegisterForDrag("LeftButton")
  end
  local men = Nx.Men:Cre(f)
  self.Men = men
  men:AdI1(0, "Help", self.M_OSH, self)
  men:AdI1(0, "Options", self.M_OO, self)
  men:AdI1(0, "Show Map", self.M_OSM, self)
  if not Nx.Fre then
      men:AdI1(0, "Show Combat Graph", self.M_OSC, self)
      men:AdI1(0, "Show Events", self.M_OSE, self)
      local function fun()
          Nx.Fav:ToS()
      end
      men:AdI1(0, "Show Favorites", fun, self)
      if opt["IWinEnable"] then
          local function fun()
              Nx.Inf:ToS()
          end
          men:AdI1(0, "Show Info 1 2", fun, self)
      end
      local function fun()
          Nx.War:ToS()
      end
      men:AdI1(0, "Show Warehouse", fun, self)
      men:AdI1(0, "Start Demo", self.M_OSD, self)
      men:AdI1(0, "", nil, self)
  end
  local ite = men:AdI1(0, "Show Auction Buyout Per Item", self.M_OSA, self)
  ite:SetChecked(false)
  if NxData.DeC then
      men:AdI1(0, "", nil, self)
      men:AdI1(0, "Show Com Window", self.M_OSC1, self)
  end
  if NxData.DebugMap then
      men:AdI1(0, "", nil, self)
      men:AdI1(0, "Toggle Profiling", self.M_OP, self)
  end
  NXMiniMapBut:SetClampedToScreen(true)
  local ok, var = pcall(GetCVar, "scriptProfile")
  if ok and var ~= "0" then
      Nx:ShM("Profiling is on. This decreases game performance. Disable?", "Disable and Reload", self.ToP1, "Cancel")
  end
end
function Nx.But:SetTexture(tex2)
  self.Tx = tex2
end
function Nx.Soc:Show(on)
  self:Cre()
  if self.Win1 then
      self.Win1:Show(on)
  end
end
function Nx.Que:GCOR(str, maI, px, py)
  local Map = Nx.Map
  local Que = Nx.Que
  local nam, zon, loc = Que:UnO(str)
  if not zon then
      return
  end
  local clo1
  local clX, clY
  local clD = 999999999
  if strbyte(str, loc) <= 33 then
      local x1, y1, x2, y2 = self:GOR(nil, str)
      x1, y1 = Map:GWP(maI, x1, y1)
      x2, y2 = Map:GWP(maI, x2, y2)
      return x1, y1, x2, y2
  else
      loc = loc - 1
      local loC = floor((#str - loc) / 4)
      cnt = 0
      for loN1 = loc + 1, loc + loC * 4, 4 do
          local lo1 = strsub(str, loN1, loN1 + 3)
          assert(lo1 ~= "")
          local x, y, w, h = Que:ULR(lo1)
          w = w / 1002 * 100
          h = h / 668 * 100
          local wx1, wy1 = Map:GWP(maI, x, y)
          local wx2, wy2 = Map:GWP(maI, x + w, y + h)
          x = wx1
          y = wy1
          if px >= wx1 and px <= wx2 then
              if py >= wy1 and py <= wy2 then
                  clD = 0
                  clo1 = lo1
              end
              x = px
          elseif px >= wx2 then
              x = wx2
          end
          if py >= wy1 then
              y = py
          end
          if py >= wy2 then
              y = wy2
          end
          local dis = (x - px) ^ 2 + (y - py) ^ 2
          if dis < clD then
              clD = dis
              clo1 = lo1
          end
      end
      local x, y, w, h = Que:ULR(clo1)
      w = w / 1002 * 100
      h = h / 668 * 100
      local x1, y1 = Nx.Map:GWP(maI, x - 3, y - 3)
      local x2, y2 = Nx.Map:GWP(maI, x + w + 3, y + h + 3)
      return x1, y1, x2, y2
  end
end
function Nx.Opt:NXCmdImportCarbMine()
  local function fun()
      Nx:GICM()
  end
  Nx:ShM("Import Mining?", "Import", fun, "Cancel")
end
function Nx.Map:UpO1(maI, bri, noU)
  local wzo = self:GWZ(maI)
  if wzo and wzo.Cit then
      return
  end
  local txF = wzo and wzo.Ove1 or ""
  local ove1 = Nx.Map.ZoO[txF]
  local une
  if not noU and (not ove1 or not self.ShU) then
      if not (wzo and wzo.Exp) then
          une = true
      end
      ove1 = self.CuO1
      txF = self.COTF
  end
  if not ove1 then
      return
  end
  local bW, bH
  local txI
  local tPW, tFW, tPH, tFH
  local pat = "Interface\\Worldmap\\" .. txF .. "\\"
  local alp = self.BaA
  local uEA = self.LOp.NXUnexploredAlpha
  local zsc = self:GWZS(maI) / 10
  for txN, whS in pairs(ove1) do
      local lev1 = 0
      local brt = bri
      txN = pat .. txN
      local oX, oY, txW, txH, mod1 = strsplit(",", whS)
      txW = tonumber(txW)
      txH = tonumber(txH)
      oX = tonumber(oX)
      oY = tonumber(oY)
      if une then
          if oX < 0 then
              oX = oX + 10000
          else
              brt = uEA
              lev1 = 1
          end
      end
      bW = ceil(txW / 256)
      bH = ceil(txH / 256)
      txI = 1
      for bY = 0, bH - 1 do
          if bY < bH - 1 then
              tPH = 256
              tFH = 256
          else
              tPH = mod(txH, 256)
              if tPH == 0 then
                  tPH = 256
              end
              tFH = 16
              while tFH < tPH do
                  tFH = tFH * 2
              end
          end
          for bX = 0, bW - 1 do
              if bX < bW - 1 then
                  tPW = 256
                  tFW = 256
              else
                  tPW = mod(txW, 256)
                  if tPW == 0 then
                      tPW = 256
                  end
                  tFW = 16
                  while tFW < tPW do
                      tFW = tFW * 2
                  end
              end
              local f = self:GINI(lev1)
              local wx, wy = self:GWP(maI, (oX + bX * 256) / 1002 * 100, (oY + bY * 256) / 668 * 100)
              if self:CFTL(f, wx, wy, tFW * zsc, tFH * zsc) then
                  f.tex:SetTexture(mod1 and txN or txN .. txI)
                  f.tex:SetVertexColor(brt, brt, brt, alp)
              end
              txI = txI + 1
          end
      end
  end
  self.Lev = self.Lev + 2
end
function Nx.Win:M_OFI(ite)
  local v = ite:GeS1()
  local svd = self.MeW.SaD
  svd["FI"] = v
  self.MeW.BFI = v
end
function Nx.MapMinimapOwned()
  local map = Nx.Map:GeM(1)
  return map.MMO1
end
function Nx.But:SeP2(dow)
  self.Pre = dow
  self:Upd()
end
function Nx.Inf:M_OC2()
  self.CMI.Win1:Show(false)
end
function Nx.Map:UpG(plX, plY)
  local alt = IsAltKeyDown()
  local reG = abs(GetTime() * 400 % 200 - 100) / 200 + .5
  local mem = MAX_PARTY_MEMBERS
  local unN = "party"
  local rai
  if GetNumRaidMembers() > 0 then
      mem = MAX_RAID_MEMBERS
      unN = "raid"
      rai = true
  end
  local pal1 = Nx.Com.PaN
  local paN1
  local paD = 99999999
  local paX, paY
  local coN1
  local coU
  local coH
  local coD = 99999999
  local coX1, coY
  local paI = Nx.Com.PaI
  for i = 1, mem do
      local uni = unN .. i
      local nam, unR = UnitName(uni)
      local maI = self.MaI
      local pX, pY = GetPlayerMapPosition(uni)
      if pX <= 0 and pY <= 0 then
          local inf = paI[nam]
          if inf and inf.EMI == maI then
              maI = inf.MId
              pX = inf.X + .00001
              pY = inf.Y
          end
      else
          pX = pX * 100
          pY = pY * 100
      end
      if (pX ~= 0 or pY ~= 0) and not UnitIsUnit(uni, "player") then
          local fuN = unR and #unR > 0 and (nam .. "-" .. unR) or nam
          local wx, wy = self:GWP(maI, pX, pY)
          local sz = 16 * self.DRS
          if UnitInParty(uni) then
              sz = 18 * self.DPS1
          end
          local cls = UnitClass(uni) or ""
          local inC1
          inC1 = UnitAffectingCombat(uni)
          local h = UnitHealth(uni)
          if UnitIsDeadOrGhost(uni) then
              h = 0
          end
          local m = UnitHealthMax(uni)
          local per = min(h / m, 1)
          if per > 0 then
              if pal1[nam] ~= nil or self.TrP[nam] then
                  sz = 20 * self.DPS
                  if self.TrP[nam] then
                      sz = 25 * self.DPS
                  end
                  local dis = (plX - wx) ^ 2 + (plY - wy) ^ 2
                  if dis < paD then
                      paN1 = nam
                      paD = dis
                      paX, paY = wx, wy
                  end
              end
              if inC1 then
                  local dis = (plX - wx) ^ 2 + (plY - wy) ^ 2
                  if dis < coD then
                      coN1 = nam
                      coU = uni
                      coH = per
                      coD = dis
                      coX1, coY = wx, wy
                  end
              end
          end
          local f1 = self:GeI1(1)
          if self:CFW(f1, wx, wy, sz, sz, 0) then
              f1.NXType = 1000
              f1.NXData = uni
              f1.NXData2 = fuN
              local ina
              for n = 1, MAX_TARGET_DEBUFFS do
                  if UnitDebuff(uni, n) == "Inactive" then
                      ina = true
                      per = 0
                      break
                  end
              end
              local txN = "IconPlyrP"
              if pal1[nam] == false then
                  txN = "IconPlyrF"
              elseif pal1[nam] == true then
                  txN = "IconPlyrG"
              end
              if inC1 then
                  txN = txN .. "C"
              end
              f1.tex:SetTexture("Interface\\AddOns\\Carbonite\\Gfx\\Map\\" .. txN)
              local tSt = ""
              f = self:GINI(2)
              if per > .33 then
                  local sc = self.ScD
                  self:CFTL(f, wx - 9 / sc, wy - 10 / sc, 16 * per / sc, 1 / sc)
                  f.tex:SetTexture(1, 1, 1, 1)
              else
                  self:CFW(f, wx, wy, 7, 7, 0)
                  if per > 0 then
                      f.tex:SetTexture(1, .1, .1, 1 - per * 2)
                  else
                      if ina then
                          f.tex:SetTexture(1, 0, 1, .7)
                      else
                          f.tex:SetTexture(0, 0, 0, .5)
                      end
                  end
              end
              local unT = uni .. "target"
              local tNa = UnitName(unT)
              local tEP
              if tNa then
                  local tLv = UnitLevel(unT)
                  local tCl = UnitClass(unT) or ""
                  if tNa == tCl then
                      tCl = ""
                  end
                  local th = UnitHealth(unT)
                  if UnitIsDeadOrGhost(unT) then
                      th = 0
                  end
                  local tm = max(UnitHealthMax(unT), 1)
                  local per = min(th / tm, 1)
                  local f = self:GINI(2)
                  local sc = self.ScD
                  if UnitIsFriend("player", unT) then
                      self:CFTL(f, wx - 9 / sc, wy - 2 / sc, 16 * per / sc, 1 / sc)
                      f.tex:SetTexture(0, 1, 0, 1)
                      tSt = format("\n|cff80ff80%s %d %s %d", tNa, tLv, tCl, th)
                      if not UnitIsPlayer(unT) then
                          tSt = tSt .. "%"
                      end
                  else
                      self:CFTL(f, wx - 9 / sc, wy - 9 / sc, 1 / sc, 15 * per / sc)
                      if UnitIsPlayer(unT) then
                          tEP = true
                          tSt = format("\n|cffff4040%s %d %s %d%%", tNa, tLv, tCl, th)
                          f.tex:SetTexture(reG, .1, 0, 1)
                      elseif UnitIsEnemy("player", unT) then
                          tSt = format("\n|cffffff40%s %d %s %d%%", tNa, tLv, tCl, th)
                          if Nx:UnitIsPlusMob(unT) then
                              f.tex:SetTexture(1, .4, 1, 1)
                          else
                              f.tex:SetTexture(1, 1, 0, 1)
                          end
                      else
                          tSt = format("\n|cffc0c0ff%s %d %s %d%%", tNa, tLv, tCl, th)
                          f.tex:SetTexture(.7, .7, 1, 1)
                      end
                  end
              end
              local lvl = UnitLevel(uni)
              local qSt1 = Nx.Com:GPQS(nam)
              if rai then
                  local nam, ran, grp = GetRaidRosterInfo(i)
                  cls = cls .. " G" .. grp
              end
              f1.NxT = format("%s %d %s %d%%\n(%d,%d) %s %s%s", fuN, lvl, cls, per * 100, pX, pY,
                  ina and "Inactive" or "", tSt, qSt1 or "")
              if alt then
                  local s = tEP and (nam .. tSt) or nam
                  local txt = self:GetText(s)
                  self:MTTI(txt, f1, 15, 1)
              end
          end
      end
  end
  self.Lev = self.Lev + 3
  if paN1 then
      if not coN1 or coD > paD then
          self.TrP1 = paN1
          return paN1, paX, paY
      end
  end
  if coN1 then
      if not self.InC or coD > 35 then
          self.TrP1 = coN1
          return format("Combat, %s %d%%", coN1, coH * 100), coX1, coY
      end
  end
end
function Nx.Sli:OMU(but)
  local self = this.NxI
  self.DrX = nil
end
function Nx.Map:OBTE(but1)
  Nx.UEv.Lis:Ope()
end
function Nx.Fav:ToS()
  Nx.Sec:VaM()
end
function Nx.Map.Gui:UII1(con1)
  local Map = Nx.Map
  local map = self.Map
  local fol = self:FiF("Instances")
  local ins = fol[con1]
  if not ins then
      return
  end
  for shT, fol in ipairs(ins) do
      local maI = fol.IMI
      local win1 = Map.MWI[maI]
      if win1.EMI == map.MaI then
          local wx = win1[2]
          local wy = win1[3]
          local ico = map:AIP("!POIIn", wx, wy, nil, "Interface\\Icons\\INV_Misc_ShadowEgg")
          map:SIT(ico, fol.InT2)
          map:SIUD(ico, fol.IMI)
      end
  end
end
function Nx:MNTI(nam)
  if Nx.Loc == "deDE" then
      nam = gsub(nam, "Br\195\188hschlammbedecktes ", "")
      if nam == "reiches Thoriumvorkommen" then
          nam = "Reiches Thoriumvorkommen"
      end
      if nam == "Thoriumvorkommen" then
          nam = "Kleines Thoriumvorkommen"
      end
  elseif Nx.Loc == "frFR" then
      nam = gsub(nam, " couvert de limon", "")
      nam = gsub(nam, " couvert de vase", "")
      if nam == "Filon de thorium" then
          nam = "Petit filon de thorium"
      end
  elseif Nx.Loc == "esES" or Nx.Loc == "esMX" then
      nam = gsub(nam, " cubierto de moco", "")
      nam = gsub(nam, " cubierta de moco", "")
      if nam == "Fil\195\179n de torio" then
          nam = "Fil\195\179n peque\195\177o de torio"
      end
  else
      nam = gsub(nam, "Ooze Covered ", "")
      if nam == "Thorium Vein" then
          nam = "Small Thorium Vein"
      end
  end
  local i = self.GLI
  for k, v in ipairs(Nx.GaI1["M"]) do
      if v[i] == nam then
          return k
      end
  end
  if NxData.NXDBGather then
      Nx.prt("Unknown ore %s", nam)
  end
end
function Nx.Soc:UpI(map)
  if Nx.Tic % 120 == 4 then
      self:CaP()
  end
  local math = math
  local alt = IsAltKeyDown()
  local tm = GetTime()
  local iTN = Nx.MITN
  local pun = self.Pun
  local puA = self.PuA
  local siz = self.GOp["PunkAreaSize"] * map.ScD
  local siM = self.GOp["PunkMAreaSize"] * map.ScD
  local arR, arG, arB = Nx.U_23(self.GOp["PunkAreaColor"])
  local icR, icG, icB, icA = Nx.U_23(self.GOp["PunkIconColor"])
  local aRM, aGM, aBM = Nx.U_23(self.GOp["PunkMAreaColor"])
  local sIN = self.GOp["PunkShowInNorthrend"]
  local sISA = self.GOp["PunkShowInSafeArea"]
  local dec = .24
  local deM1 = .21
  local iBG = Nx.IBG
  if iBG then
      if not self.GOp["PunkShowInBG"] or Nx.Fre then
          return
      end
      siz = self.GOp["PunkBGAreaSize"] * map.ScD
      arR, arG, arB = Nx.U_23(self.GOp["PunkBGAreaColor"])
      local dec = 2
      local deM1 = .25
  end
  local icG1 = abs(GetTime() * 400 % 200 - 100) / 400 + .75
  if alt then
      map.Lev = map.Lev + 11
  end
  for pNa, pun1 in pairs(puA) do
      local dur = tm - pun1.Tim1
      local ciD = tm - pun1.CiT
      local pMI = pun1.MId
      local wx, wy = map:GWP(pMI, pun1.X, pun1.Y)
      local x = wx + math.sin(pun1.DrD1) * 2
      local y = wy + math.cos(pun1.DrD1) * 2
      if pun[pNa] then
          local sz = siM / (ciD * deM1 + 1)
          if sz >= 1 then
              sz = max(sz, 25)
              local f = map:GINI()
              if map:CFW(f, x, y, sz, sz, 0) then
                  f.tex:SetBlendMode("ADD")
                  f.tex:SetTexture("Interface\\AddOns\\Carbonite\\Gfx\\Map\\IconCircle")
                  if dur < .1 then
                      f.tex:SetVertexColor(.3, 1, .3, 1)
                  else
                      f.tex:SetVertexColor(aRM, aGM, aBM, 1)
                  end
              end
          end
      else
          if (not Nx.InS1 or sISA) and ((pMI < 4000 or pMI > 4999) or sIN) then
              local sz = siz / (ciD * dec + 1)
              if sz >= 1 then
                  sz = max(sz, 22)
                  local f = map:GINI()
                  if map:CFW(f, x, y, sz, sz, 0) then
                      f.tex:SetBlendMode("ADD")
                      f.tex:SetTexture("Interface\\AddOns\\Carbonite\\Gfx\\Map\\IconCircle")
                      if dur < .05 then
                          if iBG then
                              f.tex:SetVertexColor(.15, .15, .15, 1)
                          else
                              f.tex:SetVertexColor(.25, .25, .25, 1)
                          end
                      else
                          f.tex:SetVertexColor(arR, arG, arB, 1)
                      end
                  end
              end
          end
      end
      if pun[pNa] then
          local f = map:GeI1(2)
          if map:CFW(f, x, y, 14, 14, 0) then
              local lvl = pun1.Lvl > 0 and pun1.Lvl or "?"
              local maN = iTN[pMI] or "?"
              f.NxT = format("*|cffff0000%s %s, %d:%02d ago\n%s (%d,%d)", pNa, lvl, dur / 60 % 60, dur % 60, maN,
                  pun1.X, pun1.Y)
              f.NXType = 3001
              f.NXData = pNa
              f.tex:SetTexture("Interface\\AddOns\\Carbonite\\Gfx\\Map\\IconPlyrZ")
              f.tex:SetVertexColor(icR, icG, icB, icA * icG1)
              if alt then
                  local txt = map:GetText(format("*|cffff0000%s|r*", pNa))
                  map:MTTI(txt, f, 18, 1)
              end
          end
      else
          if (not Nx.InS1 or sISA) and ((pMI < 4000 or pMI > 4999) or sIN) then
              local i = dur < 10 and 2 or 1
              local f = map:GeI1(i)
              if map:CFW(f, x, y, 10, 10, 0) then
                  local lvl = pun1.Lvl > 0 and pun1.Lvl or "?"
                  local maN = iTN[pMI] or "?"
                  f.NxT = format("|cffff6060%s %s, %d:%02d ago\n%s (%d,%d)", pNa, lvl, dur / 60 % 60, dur % 60, maN,
                      pun1.X, pun1.Y)
                  f.NXType = 3001
                  f.NXData = pNa
                  f.tex:SetTexture("Interface\\AddOns\\Carbonite\\Gfx\\Map\\IconPlyrZ")
                  if dur < 10 then
                      f.tex:SetVertexColor(icR, icG, icB, icA * icG1)
                  else
                      f.tex:SetVertexColor(icR, icG, icB, icA * .6)
                  end
              end
          end
      end
  end
  if alt then
      map.Lev = map.Lev - 11
  else
      map.Lev = map.Lev + 3
  end
end
function Nx.Com:UpC2()
  Nx.Tim:Sta("ComUC", 0, self, self.UCT)
end
function Nx.Win:Ini()
  local wd = Nx:GeD("Win")
  if not wd.Version or wd.Version < Nx.VERSIONW1 then
      if wd.Version then
          Nx.prt("Reset old layout data")
      end
      wd.Version = Nx.VERSIONW1
      for k, win in pairs(wd) do
          if type(win) == "table" then
              wd[k] = nil
          end
      end
  end
  self.Win2 = {}
  self.BORDERW = 7
  self.BORDERH = 7
  self.Bor = {"TOPLEFT", "TOPRIGHT", 1, self.BORDERH, "WinBrH", "BOTTOMLEFT", "BOTTOMRIGHT", 1, self.BORDERH,
              "WinBrH", "TOPLEFT", "BOTTOMLEFT", self.BORDERW, 1, "WinBrV", "TOPRIGHT", "BOTTOMRIGHT", self.BORDERW,
              1, "WinBrV"}
  self.SiN = {"LEFT", "RIGHT", "", "TOP", "TOPLEFT", "TOPRIGHT", "", "BOTTOM", "BOTTOMLEFT", "BOTTOMRIGHT"}
  self.StN = {
      "LOW",
      "MEDIUM",
      "HIGH",
      "DIALOG",
      ["LOW"] = 1,
      ["MEDIUM"] = 2,
      ["HIGH"] = 3,
      ["DIALOG"] = 4
  }
  local men = Nx.Men:Cre(UIParent)
  self.Men = men
  self.MIHIC = men:AdI1(0, "Hide In Combat", self.M_OHIC, self)
  self.MIL = men:AdI1(0, "Lock", self.M_OL, self)
  self.MIFI = men:AdI1(0, "Fade In", self.M_OFI, self)
  self.MIFO = men:AdI1(0, "Fade Out", self.M_OFO, self)
  self.MIL1 = men:AdI1(0, "Layer", self.M_OL1, self)
  self.MIS = men:AdI1(0, "Scale", self.M_OS, self)
  self.MIT = men:AdI1(0, "Transparency", self.M_OT, self)
  local function fun(ite)
      self.MeW:ReL1()
  end
  men:AdI1(0, "Reset Layout", fun, self)
end
function Nx.War:OILE(evN, sel, va2, cli)
  local lis = self.ItL
  local id = lis:IGD(sel) or 0
  if evN == "select" or evN == "mid" or evN == "menu" then
      if evN == "menu" then
          self.ILM:Ope()
      else
          if id > 0 then
              if not IsModifiedClick() then
                  SetItemRef("item:" .. id)
              end
          elseif id == 0 then
              local olI = self.IOI
              self.IOI = nil
              local tip = lis:IGBT(sel)
              if tip then
                  tip = strsub(tip, 2)
                  local str, cou = self:FCWI(tip)
                  if str then
                      if olI then
                          if sel > self.IOS then
                              sel = sel - self.IOC
                              lis:Sel1(sel)
                          end
                      end
                      self.IOS = sel
                      self.IOC = cou
                      local id = strmatch(tip, "item:(%d+)")
                      self.IOI = id
                      self.ItO = str
                  end
              end
          end
      end
      self:Upd()
  elseif evN == "button" then
      local tip = lis:IGBT(sel)
      if tip then
          local nam, lin
          lin = strsub(tip, 2)
          if id > 0 then
              nam, lin = GetItemInfo(id)
          elseif id < 0 then
              nam = GetSpellInfo(-id)
              lin = GetSpellLink(-id)
          else
              nam = GetItemInfo(lin)
          end
          local frm = DEFAULT_CHAT_FRAME
          local eb = frm["editBox"]
          if eb:IsVisible() and lin then
              eb:SetText(eb:GetText() .. lin)
          elseif BrowseName and BrowseName:IsVisible() then
              if nam then
                  BrowseName:SetText(nam)
                  AuctionFrameBrowse_Search()
              end
          else
              Nx.prt("No edit box open!")
          end
      end
  end
end
function Nx:OT__(eve, ...)
  Nx.War.TiP = arg1
end
function Nx.Map:CaT1()
  Nx.Tim:PrS("Map Tracking")
  local Tra = Nx.Tra
  local tr = {}
  self.Tra1 = tr
  local srX = self.PlX
  local srY = self.PlY
  local sMI = self.RMI
  for n, tar1 in ipairs(self.Tar) do
      Tra:MaP(tr, sMI, srX, srY, tar1.MaI, tar1.TMX, tar1.TMY, tar1.TaT)
      tinsert(tr, tar1)
      srX = tar1.TMX
      srY = tar1.TMY
      sMI = tar1.MaI
  end
  Nx.Tim:PrE("Map Tracking")
end
function Nx.Que.ToH1()
  Nx.Que:ToP()
end
function Nx.Win:ICH()
  if self.SaD["HideC"] then
      return UnitAffectingCombat("player")
  end
end
function Nx.Map:M_OSS()
  self.CuO.NXScaleSave = self.Sca
end
function Nx.Map:UIM()
  local maI = self.IMI
  if not maI then
      return
  end
  local Map = Nx.Map
  local win1 = Map.MWI[maI]
  local inf = self.IMI1
  if self.IMA then
      local wx = win1[2]
      local wy = win1[3]
      for n = 1, #inf, 3 do
          local sc = 668 / 256
          local f = self:GINI()
          if self:CFTL(f, wx, wy + (n - 1) * 668 / 768, sc, sc) then
              local tex2 = inf[n + 2]
              tex2 = "Interface\\Addons\\Atlas\\Images\\Maps\\" .. tex2
              f.tex:SetTexture(tex2)
          end
      end
      self.Lev = self.Lev + 1
  else
      local wx = win1[2]
      local wy = win1[3]
      for n = 1, #inf, 3 do
          local imI = 1
          local off2 = 0
          local off3 = inf[n + 1] * .03 * 668 / 768
          for by = 0, 2 do
              for bx = 0, 3 do
                  local sc = 1
                  local f = self:GINI()
                  if self:CFTL(f, wx + bx - off2, wy + by - off3, sc, sc) then
                      local tex2 = inf[n + 2]
                      tex2 = "Interface\\WorldMap\\" .. tex2 .. imI
                      f.tex:SetTexture(tex2)
                  end
                  imI = imI + 1
              end
          end
      end
      self.Lev = self.Lev + 1
  end
end
function Nx.Tra:Add(typ, con1)
  local tda = self.Tra[con1]
  local Map = Nx.Map
  local Que = Nx.Que
  local hiF = UnitFactionGroup("player") == "Horde" and 1 or 2
  if 1 then
      local daS = Nx.GuD[typ][con1]
      for n = 1, #daS, 2 do
          local npI = (strbyte(daS, n) - 35) * 221 + (strbyte(daS, n + 1) - 35)
          local npS = Nx.NPCD[npI]
          local fac2 = strbyte(npS, 1) - 35
          if fac2 ~= hiF then
              local oSt = strsub(npS, 2)
              local des1, zon, loc = Que:UnO(oSt)
              local nam, loN2 = strsplit("!", des1)
              if strbyte(oSt, loc) == 32 then
                  local maI = Map.NTMI[zon]
                  local x, y = Que:ULPO(oSt, loc + 1)
                  local wx, wy = Map:GWP(maI, x, y)
                  local nod = {}
                  nod.Nam = des1
                  nod.LoN = NXlTaxiNames[loN2] or loN2
                  nod.MaI = maI
                  nod.WX = wx
                  nod.WY = wy
                  tinsert(tda, nod)
              else
                  assert(0)
              end
          end
      end
  end
end
function Nx.Map:IIM(maI)
  return maI >= 10000
end
function Nx.Win:STJ(mod1, lin1)
  lin1 = lin1 or 1
  self.TFS[lin1]:SetJustifyH(mod1)
end
function Nx:CALHW(con1, zon, zx, zy, nam)
  Nx:TTSTCZXY(con1, zon, zx, zy, nam)
end
function Nx.Win:PaC(str)
  local str = gsub(strlower(str), ",", " ")
  local nam
  local x, y
  for s in gmatch(str, "%S+") do
      local i = tonumber(s)
      if i then
          if x then
              y = y or i
          else
              x = i
          end
      else
          if nam then
              nam = nam .. " " .. s
          else
              nam = s
          end
      end
  end
  local nam1 = {
      ["map"] = "NxMap1"
  }
  return nam1[nam] or nam, x, y
end
function Nx.Map:IDC()
  if GetTime() - self.LCT < .5 then
      self.LCT = 0
      return true
  end
end
function Nx.Tim:Ini()
  self.Dat = {}
  self:PrI()
end
function Nx.Map.Gui:M_OSE1(ite)
  self.ShE = ite:GetChecked()
  self:ClA()
end
function Nx.Map:GCZ()
  if self.InI then
      self:Mov(self.PlX, self.PlY, 20, 30)
  else
      SetMapToCurrentZone()
      local maI = self:GCMI()
      self:CeM(maI)
  end
end
function Nx.CloseWindows()
  if not InCombatLockdown() then
      Nx.Soc:HideUIPanel(getglobal("FriendsFrame"))
  end
  local f = getglobal("QuestLogFrame")
  Nx.Que:HideUIPanel(f)
end
function Nx.War.OI__()
  if type(arg2) ~= "number" then
      return
  end
  local self = Nx.War
  if not self.Ena then
      return
  end
  if arg1 == KEYRING_CONTAINER or arg1 == BACKPACK_CONTAINER or (arg1 >= 1 and arg1 <= NUM_BAG_SLOTS) or arg1 ==
      BANK_CONTAINER or (arg1 >= NUM_BAG_SLOTS + 1 and arg1 <= NUM_BAG_SLOTS + NUM_BANKBAGSLOTS) then
      self.LoB = nil
      if arg1 == BANK_CONTAINER or (arg1 >= NUM_BAG_SLOTS + 1 and arg1 <= NUM_BAG_SLOTS + NUM_BANKBAGSLOTS) then
          self.LoB = true
      end
      self:prt1("LockChg %s %s", arg1, tostring(arg2))
      self.LoB1 = arg1
      self.LoS = arg2
      local tx, cou, loc2 = GetContainerItemInfo(arg1, arg2)
      if tx then
          self.LoC = cou
          self.LoL = GetContainerItemLink(arg1, arg2)
      end
      if loc2 then
          self.Loc2 = true
      else
          self.Loc2 = false
      end
      self:CaU()
      self.LoB1 = nil
  end
end
function Nx.Lis:IGD(ind)
  ind = ind or self.Sel
  return ind and self.Dat[ind]
end
function Nx.Map:CFZ(frm, x, y, w, h, dir)
  x, y = self:GWP(self.MaI, x, y)
  return self:CFW(frm, x, y, w, h, dir)
end
function Nx.Fav:SIA(nam, sel)
  local fav = self.CuF
  local ind = self.CII
  if fav and ind then
      local ite = fav[ind]
      local typ, fla, nam, dat = self:PaI1(ite)
      fla = strbyte(fla) - 35
      if typ == "N" then
          local ico, id, x, y = self:PIN(dat)
          fav[ind] = self:CrI("N", fla, nam, sel, id, x, y)
          self:Upd()
      end
  end
end
function Nx.Com:InC2(chN1)
  for n = 1, 10 do
      local _, nam = GetChannelName(n)
      if chN1 == nam then
          return true
      end
  end
end
function Nx.Lis:SaC()
  if self.Save then
      local str = ""
      local sep = ""
      for id, col3 in ipairs(self.Col) do
          str = str .. sep .. col3.Wid
          sep = "^"
      end
      self.Save["ColW"] = str
  end
end
function Nx.Com:OMV(nam, enm)
  local msg = self:Dec(enm)
  if self:ICOK(msg) then
      local suT = strsub(msg, 2, 2)
      if suT == " " then
          local ver, r, c, dt, ve1, qCn = strsplit("^", msg)
          ver = tonumber(strsub(ver, 5))
          if ver then
              if Nx.VERMINOR <= 0 then
                  local ver1 = floor(ver * 1000) / 1000
                  local ver2 = ver - ver1
                  if ver2 > 0 then
                      return
                  end
              end
              if ver - .0000001 > Nx.VERSION and not self.NVM then
                  self.NVM = true
                  Nx.Tim:Sta("ComShowVer", 60, self, self.SVT)
              end
              self.Lis:AdI("C:" .. arg9, format("(%s) ver %s", arg2, ver))
              self:RcV(nam, msg)
          end
      elseif suT == "?" then
          local str = self:MVM()
          self:SSW1("V!", str, nam)
      elseif suT == "!" then
          self:RcV(nam, msg)
      end
  else
      if NxData.DeC then
          Nx.prt("Ver chksum fail %s", msg)
      end
  end
end
function Nx.Com1:OpG()
  self.GrH = Nx.Gra:Cre(self.W, 50, self.Frm)
  local f = self.GrH.MaF
  self.Win1:Att(f, 0, 1, 0, 1)
end
function Nx.Gra:Clear()
  self.Val = {}
  self.Val.Nex = 1
  self.Pea = 1
  self:ReF()
end
function Nx.Que.Lis:M_OHP(ite)
  local cur = self:GCS()
  if cur then
      cur.HiP1 = not cur.HiP1
      self:Upd()
  end
end
function Nx.Inf:CaC1(tar, w, h)
  tar = tar or "player"
  w = tonumber(w) or 50
  h = tonumber(h) or 10
  local spe, ran, nam, ico, stT1, enT = UnitCastingInfo(tar)
  if not nam then
      spe, ran, nam, ico, stT1, enT = UnitChannelInfo(tar)
  end
  if nam then
      local rem1 = enT / 1000 - GetTime()
      local per = rem1 * 1000 / (enT - stT1)
      return "|cffc0c0f0",
          format("|T%s:16|t %.1f |TInterface\\BUTTONS\\gradblue:%d:%d|t", ico, rem1, h, max(per * w, 1))
  end
end
function Nx:NXOnEvent(eve, ...)
  local h = self.Eve[eve]
  if h then
      h(nil, eve, ...)
  else
      assert(0)
  end
end
function Nx:GaI()
  self.GLI = 3
  if Nx.Loc == "deDE" then
      self.GLI = 4
  elseif Nx.Loc == "frFR" then
      self.GLI = 5
  elseif Nx.Loc == "esES" or Nx.Loc == "esMX" then
      self.GLI = 6
  end
  if self.DGU then
      self.DGU = nil
      Nx:GVU()
  end
  Nx.GVU = nil
  Nx.GVUT = nil
end
function Nx.Opt:Res(onN)
  self.Opt = Nx:GGO()
  self.COp = Nx.CuC["Opts"]
  if not onN then
      Nx.prt("Reset global options")
  end
  for nam, v in pairs(Nx.OpV) do
      local sco1, typ, val = strsplit("~", v)
      local opt = sco1 == "-" and self.COp or self.Opt
      if sco1 == "-" and self.Opt[nam] ~= nil then
          self.Opt[nam] = nil
      end
      if not onN or opt[nam] == nil then
          if typ == "B" then
              opt[nam] = false
              if val == "T" then
                  opt[nam] = true
              end
          elseif typ == "C" or typ == "RGB" then
              opt[nam] = 0xffffffff
              if val then
                  opt[nam] = tonumber(val, 16)
              end
          elseif typ == "CH" then
              opt[nam] = ""
              if val then
                  opt[nam] = val
              end
          elseif typ == "F" then
              opt[nam] = 0
              if val then
                  opt[nam] = tonumber(val)
              end
          elseif typ == "I" then
              opt[nam] = 0
              if val then
                  opt[nam] = tonumber(val)
              end
          elseif typ == "S" then
              opt[nam] = ""
              if val then
                  opt[nam] = val
              end
          elseif typ == "" then
              opt[nam] = nil
          end
      end
  end
end
function Nx.Map:M_ODA(ite)
  self.LOp.NXDetailAlpha = ite:GeS1()
end
function Nx.Map:MOU(ela)
  if self.Cre1 then
      local map = self:GeM(1)
      local win = map.Win1
      local show, sho1 = win:IsShown()
      if not show then
          if sho1 and not win:ICH() then
              win:Show()
              map:ReS1()
              return
          end
          local sav1 = this
          this = map.Frm
          self:OnU(ela)
          this = sav1
      end
  end
end
function Nx.War:CaU()
  self:CaI()
  if self.Win1 then
      Nx.Tim:PrS("WH CaptureUpdate")
      self:Upd()
      Nx.Tim:PrE("WH CaptureUpdate")
  end
end
function Nx.Com.SCH(msg, chN1)
  if chN1 == "CHANNEL" then
      Nx.Com.SCT1 = GetTime()
  end
end
function Nx.Que.Lis.FOEP()
  this:ClearFocus()
end
function Nx.Fav:FLI(ite, fol, ind)
  fol = fol or self.Fol
  ind = ind or 1
  for _, it in ipairs(fol) do
      if it == ite then
          return ind
      end
      ind = ind + 1
      if it["T"] == "F" then
          if not it["Hide"] then
              ind = self:FLI(ite, it, ind)
              if ind > 0 then
                  return ind
              end
              ind = -ind
          end
      end
  end
  return -ind
end
function Nx.Opt:UpC1()
  local opt = self.Opt
  local mas = 0
  if opt["InfoToF"] then
      mas = mas + 1
  end
  if opt["InfoToG"] then
      mas = mas + 2
  end
  if opt["InfoToZ"] then
      mas = mas + 4
  end
  Nx.Com:SSPM(mas)
end
function Nx:TTSCA(id, dis, str)
  local map = Nx.Map:GeM(1)
  local tar1 = map:FiT(id)
  if tar1 then
      tar1.Rad = dis
      tar1.TaN1 = str
  end
end
function Nx.ToB:M_OS1(ite)
  self:MDU("Size", ite:GeS1())
end
function Nx.Map:SITA(icT, alp, alN)
  local d = self.Dat
  assert(d[icT])
  d[icT].Alp = alp
  d[icT].AlN = alN
end
function Nx.Map:FiT(unI)
  for n, tar1 in ipairs(self.Tar) do
      if tar1.UnI == unI then
          return tar1, n
      end
  end
end
function Nx.Fav:M_OAF(ite)
  local function fun(str, self)
      self:AdF1(str, self.CuF1)
      self:Upd()
  end
  Nx:SEB("Name", "", self, fun)
end
function Nx.Map:OBSD(but1, cli, x, y)
  x = x * self.DAS
  y = y * self.DAS
  local mod1 = 1
  if mod1 == 1 then
      local id = self.DMI1 or 1001
      if IsControlKeyDown() then
          x = x * .1 + self.MWI[id][1]
          self.MWI[id][1] = x
          Nx.prt("Sc %f", x)
      else
          local inf = self.MWI[id]
          inf[4] = x + inf[4]
          inf[5] = y + inf[5]
          x = x + inf[2]
          inf[2] = x
          y = y + inf[3]
          inf[3] = y
          Nx.prt("XY %f %f", x, y)
      end
  elseif mod1 == 2 then
      if self.DMI1 then
          local miT = self:GMI(self.DMI1)
          miT[3] = x + miT[3]
          miT[4] = y + miT[4]
          Nx.prt("XY %f %f", miT[3], miT[4])
      end
  end
  return true
end
function Nx.HUD:Ini()
  Nx.HUD.TeN = {"", "Chip", "Gloss", "Glow", "Neon"}
  Nx.HUD:Ope()
end
function Nx.ToB:SeF1(fad2)
  self.Frm:SetAlpha(fad2)
end
function Nx:OU__3(eve, ...)
  if arg1 == "player" then
      Nx.GaT = nil
      Nx.War.LoT = nil
  end
end
function Nx.Gra:SeP(pea)
  if pea < 1 then
      pea = 1
  end
  if pea > self.Pea then
      self.Pea = pea
      self:UpF()
  end
end
function Nx.Que:SBQDZ()
  local num = QuestMapUpdateAllQuests()
  if num > 0 then
      QuestPOIUpdateIcons()
      local Map = Nx.Map
      local maI = Map:GCMI()
      local zon = Nx.MITN1[maI]
      for n = 1, num do
          local id, qi = QuestPOIGetQuestIDByVisibleIndex(n)
          if not self.ITQ[id] or self.ITQ[-id] then
              local _, x, y, obj1 = QuestPOIGetIconInfo(id)
              local tit = GetQuestLogTitle(qi)
              local que = self.ITQ[-id]
              if not que then
                  que = {}
                  que[1] = format("%c%s######", #tit + 35, tit)
                  self.ITQ[id] = que
                  self.ITQ[-id] = que
                  Nx.Que1[(id + 7) * 2 - 3] = que
              end
              local s = tit
              x = x * 10000
              y = y * 10000
              que[2] = format("%c%s%c %c%c%c%c", #s + 35, s, zon + 35, floor(x / 221) + 35, x % 221 + 35,
                  floor(y / 221) + 35, y % 221 + 35)
              local lbC = GetNumQuestLeaderBoards(qi)
              for i = 1, lbC do
                  que[3 + i] = que[2]
              end
          end
      end
  end
end
function Nx.Map.Doc:Cre()
  if Nx.Fre then
      return
  end
  self.UpM1 = 100
  local gop = Nx.GGO()
  self.GOp = gop
  if not gop["MapMMButOwn"] then
      return
  end
  Nx.Win:SCF(1, 0)
  local win = Nx.Win:Cre("NxMapDock", nil, nil, nil, 1, 1, nil, true)
  self.Win1 = win
  win:SBGA(0, 1)
  win:CrB()
  win:ILD(nil, 100045, -.08, 45, 50, 2)
  win.Frm:SetToplevel(true)
  self:UpO()
  self.InP = true
  Nx.Tim:Sta("DockMinimapScan", 3, self, self.MOI)
end
function Nx.Map.Gui:OnW(typ)
  if typ == "Hide" then
      self:ItF1()
  end
end
function Nx.NXMiniMapBut:M_OSC1()
  Nx.Com.Lis:Ope()
end
function Nx.Map:CWH(wx, wy)
  if self.IMI then
      if wx >= self.IMWX1 and wx <= self.IMWX2 and wy >= self.IMWY1 and wy <= self.IMWY2 then
          if self.IMI ~= self.MaI then
              self:SCM1(self.IMI)
          end
          self.WHTS = Nx.MITN[self.IMI] .. "\n"
          return
      end
  end
  local qu1 = self.WHC
  local qu2 = self.WoH
  if self.NXCitiesUnder then
      qu1, qu2 = qu2, qu1
  end
  if self:CWHT(wx, wy, qu1) then
      return
  end
  if self:CWHT(wx, wy, qu2) then
      return
  end
  self.WHTS = false
end
function Nx.Map:ReT()
  local tar1 = self.Tar
  local n2 = #tar1
  for n = 1, n2 / 2 do
      local a = tar1[n]
      tar1[n] = tar1[n2]
      tar1[n2] = a
      n2 = n2 - 1
  end
  self.Tra1 = {}
end
function Nx.Map:GTI()
  local map = self.Map1[1]
  local tar1 = map.Tar[1]
  if tar1 then
      return tar1.TaT, tar1.TaI
  end
end
function Nx.Map:Ini()
  local gop = Nx.GGO()
  self.GOp = gop
  local plF = UnitFactionGroup("player")
  plF = strsub(plF, 1, 1)
  self.PFN = plF == "A" and 0 or 1
  self.PFS = plF == "A" and "Ally" or "Horde"
  self.Map1 = {}
  self.Cre1 = false
  self:InF()
  self:InT1()
  self.PlN1 = {}
  self.AFK1 = {}
  self.PNTS = ""
  self.SCM = 10
  self.CPOI = {}
  for con1 = 1, self.CoC do
      self.CPOI[con1] = {}
  end
  self.BGT = {}
  local his = {}
  self.PlH = his
  his.LaX = -99999999
  his.LaY = -99999999
  his.Nex = 1
  his.Cnt = self.GOp["MapTrailCnt"]
  for n = 1, his.Cnt * 4, 4 do
      his[n] = 0
      his[n + 1] = 0
      his[n + 2] = 0
      his[n + 3] = 0
  end
  Nx.MPOIT = {
      [0] = 0,
      0,
      2,
      1,
      1,
      0,
      0,
      0,
      0,
      1,
      2,
      1,
      2,
      2,
      2,
      1,
      0,
      1,
      1,
      2,
      2,
      0,
      1,
      1,
      2,
      2,
      0,
      1,
      1,
      2,
      2,
      0,
      1,
      1,
      2,
      2,
      0,
      1,
      1,
      2,
      2,
      0,
      0,
      1,
      2,
      0,
      1,
      1,
      2,
      2,
      [136] = 1,
      [137] = 1,
      [138] = 2,
      [139] = 2,
      [141] = 1,
      [142] = 1,
      [143] = 2,
      [144] = 2,
      [146] = 1,
      [147] = 1,
      [148] = 2,
      [149] = 2,
      [151] = 1,
      [152] = 1,
      [153] = 2,
      [154] = 2
  }
  self.WMHN = {"WorldMapCorpse", "WorldMapDeathRelease", "WorldMapPing", "OutlandButton", "AzerothButton"}
  self.AMN = {
      ["GatherNote"] = true,
      ["GatherMatePin"] = true,
      ["MobMapMinimapDot_"] = true,
      ["CartographerNotesPOI"] = true,
      ["RecipeRadarMinimapIcon"] = true,
      ["NauticusMiniIcon"] = true
  }
  if gop["EmuTomTom"] and not TomTom then
      local tom = {}
      TomTom = tom
      tom["version"] = "236"
      tom["AddWaypoint"] = Nx.TTAW
      tom["AddZWaypoint"] = Nx.TTSTCZXY
      tom["SetCustomWaypoint"] = Nx.TTSCW
      tom["RemoveWaypoint"] = Nx.TTRW
      tom["SetCrazyArrow"] = Nx.TTSCA
  end
  if gop["EmuCartWP"] and not Cartographer then
      local car = {}
      Cartographer = car
      car["HasModule"] = function(self, mod3)
          return mod3 == "Waypoints" or mod3 == Cartographer_Waypoints
      end
      car["IsModuleActive"] = car["HasModule"]
      car["GetDistanceToPoint"] = Nx.CGDTP
      local car1 = {}
      Cartographer_Waypoints = car1
      car1["SetPointAsWaypoint"] = Nx.CSPAW
      car1["AddLHWaypoint"] = Nx.CALHW
      car1["AddRoutesWaypoint"] = Nx.CARW
      car1["AddWaypoint"] = Nx.CAW
      car1["UpdateWaypoint"] = function(self)
      end
      car1["CancelWaypoint"] = Nx.CCW
      car1["GetWaypointHitDistance"] = function()
          return 7
      end
      car1["SetWaypointHitDistance"] = Nx.CSWHD
      if not NotePoint then
          local np = {}
          NotePoint = np
          np["new"] = Nx.CNPN
      end
  end
end
function Nx.Map.Gui:M_OCS()
  self:ClA()
end
function Nx.Win:ToS1()
  if self.Siz then
      if self.LaM ~= "Max" then
          self.LMN = self.LaM
          self:SetLayoutMode("Max")
          self:Not("SizeMax")
      else
          self:SetLayoutMode(self.LMN)
          self:Not("SizeNorm")
      end
  end
end
function Nx.Map.Gui:IUSE(sta4, id)
  if #sta4 == 0 then
      return ""
  end
  local sb = strbyte
  local wor = CarboniteItems["Words"]
  local out = ""
  local n = 1
  while n < #sta4 do
      local tri = sb(sta4, n) - 35
      local len = sb(sta4, n + 1) - 35
      local des1 = ""
      for n2 = n + 2, n + 1 + len, 2 do
          local h, l = strbyte(sta4, n2, n2 + 1)
          des1 = des1 .. wor[(h - 35) * 221 + l - 35] .. " "
      end
      out = out .. format("|cff10f010%s%s\n", self.ITT[tri], des1)
      n = n + 2 + len
  end
  return out
end
function Nx.Que.Lis:OnW(typ)
  if typ == "Close" then
      HideUIPanel(QuestLogFrame)
  end
end
function Nx.Map:NTI(maN)
  return Nx.MNTI1[maN]
end
function Nx.Win:OfP(xo, yo)
  local f = self.Frm
  local atP, reT, reP, x, y = f:GetPoint()
  f:SetPoint(atP, reT, reP, x + xo, y + yo)
  self:RLD()
end
function Nx.Soc.PHUD:Rem(nam)
  for n = 1, #self.Pun do
      if self.Pun[n] == nam then
          tremove(self.Pun, n)
          break
      end
  end
  self.Pun[nam] = nil
  self.Cha = true
end
function Nx.Map:SSOT(ste1)
  local ste = ste1 >= 0 and 1 or -1
  for n = 1, abs(ste1) do
      self.Sca = self:ScS(ste)
  end
  self.StT = 10
end
function Nx.Que:BQSD()
  local dat = {}
  self.QSD = dat
  self.QSDI = 1
  local hea
  local cnt = 0
  for n, cur in ipairs(self.CuQ) do
      if not cur.Got then
          if cur.Hea1 ~= hea then
              hea = cur.Hea1
              local str = format("QDH^%s", hea)
              tinsert(dat, str)
          end
          local qSt = Nx:GeQ(cur.QId)
          local wat = qSt == "W" and 1 or 0
          local str = format("QDT^%s^%s^%s^%s^%s", cur.QId, wat, cur.Com2 or 0, cur.Lev, cur.Tit)
          tinsert(dat, str)
          for n = 1, cur.LBC do
              local str = format("QDO^%s^%s", -n, cur[n])
              tinsert(dat, str)
          end
          cnt = cnt + 1
      end
  end
  tinsert(dat, "QD")
  local str = format("QD0^%d", cnt)
  tinsert(dat, 1, str)
end
function Nx.Fon:AdL()
  if not self.Ini1 then
      return
  end
  local ace = _G["AceLibrary"]
  if ace then
      local fou
      fou = self:FoS(ace, "LibSharedMedia-2.0")
      fou = fou or self:FoS(ace, "LibSharedMedia-3.0")
      if fou then
          self:Upd()
      end
  end
end
function Nx.Map:M_OGQ(ite)
  for _, nam in pairs(Nx.Map.PlN1) do
      Nx.Que:GFP(nam)
      break
  end
end
function Nx.Map:Upd(ela)
  local Nx = Nx
  local Map = Nx.Map
  if self.NWU then
      self:UpW()
  end
  self.MaW = self.Frm:GetWidth() - self.PaX * 2
  self.MaH = self.Frm:GetHeight() - self.TiH
  self.Lev = self.Frm:GetFrameLevel() + 1
  local maI = self:GCMI()
  self.Con, self.Zon = self:ITCZ(maI)
  Nx.InS1 = GetZonePVPInfo() == "sanctuary"
  local dSCZ
  local maC
  if self.MaI ~= maI then
      if self.Debug then
          Nx.prt("%d Map change %d to %d", self.Tic, self.MaI, maI)
      end
      self.CMBG = self:IBGM(maI)
      if not self:IBGM(self.MaI) then
          self:AOM(maI)
      end
      self.MaI = maI
      maC = true
      Nx.Com.PlC = GetTime()
  end
  local rid = self:GRMI()
  local iBG = self:IBGM(rid)
  if Nx.IBG and Nx.IBG ~= rid then
      local cb = Nx.Com1
      if Nx.InA then
          local s = Nx.Map:GSN(Nx.InA)
          Nx.UEv:AdI(format("Left %s %d %d %dD %dH", s, cb.KBs, cb.Dea, cb.DaD, cb.HeD))
      else
          local tot = cb.KBs + cb.Dea + cb.HKs + cb.Hon
          if tot > 0 then
              local sna = Nx.Map:GSN(Nx.IBG)
              Nx.UEv:AdI(format("Left %s %d %d %d %d", sna, cb.KBs, cb.Dea, cb.HKs, cb.Hon))
              local tm = GetTime() - cb.BGET
              local hGa = GetHonorCurrency() - cb.BGEH
              Nx.UEv:AdI(format(" %s +%d honor, +%d hour", Nx.U_GTEMSS(tm), hGa, hGa / tm * 3600))
              local xpG = UnitXP("player") - cb.BGEXP
              if xpG > 0 then
                  Nx.UEv:AdI(format(" +%d xp, +%d hour", xpG, xpG / tm * 3600))
              end
          end
      end
      cb.KBs = 0
      cb.Dea = 0
      cb.HKs = 0
      cb.Hon = 0
      Nx.IBG = nil
      if Nx.InA then
          self.LOp.NXMMFull = false
      end
      Nx.InA = nil
  end
  if iBG and Nx.IBG ~= rid then
      Nx.IBG = rid
      local cb = Nx.Com1
      cb.BGET = GetTime()
      cb.BGEH = GetHonorCurrency()
      cb.BGEXP = UnitXP("player")
      if self.MWI[rid].Are then
          Nx.InA = rid
          self.LOp.NXMMFull = true
      end
      dSCZ = true
  end
  local ont = UnitOnTaxi("player")
  if ont then
      if not Map.TaO then
          Map.TST = GetTime()
          Map.TaO = true
          if NxData.DebugMap then
              Nx.prt("Taxi start")
          end
      end
  elseif Map.TaO then
      Map.TaO = false
      Map.TaX = nil
      local tm = GetTime() - Map.TST
      Nx.Tra:TST1(tm)
      if NxData.DebugMap then
          Nx.prt("Taxi time %.1f seconds", tm)
      end
  end
  if self.RMI ~= rid then
      if rid ~= 9000 then
          if self.RMI == 9000 then
              self.CuO = nil
              self:SwO(rid, true)
          end
          self.RMI = rid
          self:SwO(rid)
          self:SRM(rid)
      end
  end
  local pZX, pZY = GetPlayerMapPosition("player")
  self.InI = false
  if self:IIM(rid) then
      self.InI = rid
      pZX = pZX * 100
      pZY = pZY * 100
      self.PRZX = pZX
      self.PRZY = pZY
      local x, y = self:GWP(rid, 0, 0)
      local lvl = max(GetCurrentMapDungeonLevel(), 1)
      if not self.IMI then
          pZX = 0
          pZY = 0
      end
      self.PlX = x + pZX * 1002 / 25600
      self.PlY = y + pZY * 668 / 25600 + (lvl - 1) * 668 / 256
  elseif pZX > 0 or pZY > 0 then
      pZX = pZX * 100
      pZY = pZY * 100
      local x, y = self:GWP(maI, pZX, pZY)
      if ela > 0 then
          if x == self.PlX and y == self.PlY then
              self.PSCT = GetTime()
              self.PlS = 0
              self.PSX = x
              self.PSY = y
          else
              local tmD = GetTime() - self.PSCT
              if tmD > .5 then
                  self.PSCT = GetTime()
                  self.PlS = ((x - self.PSX) ^ 2 + (y - self.PSY) ^ 2) ^ .5 * 4.575 / tmD
                  self.PSX = x
                  self.PSY = y
              end
          end
      end
      self.PlX = x
      self.PlY = y
      if maI ~= rid then
          pZX, pZY = self:GZP(rid, x, y)
      end
      self.PRZX = pZX
      self.PRZY = pZY
      if maC then
          self.MLX = x
          self.MLY = y
      end
  end
  self.PlD = 360 - GetPlayerFacing() / 2 / math.pi * 360
  local plX = self.PlX
  local plY = self.PlY
  local x = plX - self.MLX
  local y = plY - self.MLY
  local ang = self.PlD - self.PLD
  local moD = (x * x + y * y) ^ .5
  if moD >= .01 * self.BaS or abs(ang) > .01 then
      Nx.Com.PlC = GetTime()
      if self.MLX ~= -1 then
          self.MoD = math.deg(math.atan2(x, -y / 1.5))
      end
      self.MLX = plX
      self.MLY = plY
      self.PLD = self.PlD
      if not self.Scr2 and not self.MouseIsOver and not WorldMapFrame:IsVisible() then
          if self.CuO.NXPlyrFollow then
              local scO = self.LOp.NXAutoScaleOn
              if pZX ~= 0 or pZY ~= 0 then
                  if #self.Tra1 == 0 or not scO then
                      self:Mov(plX, plY, nil, 60)
                  end
              end
              if scO then
                  local miX
                  local miY
                  local dtx
                  local dty
                  local cX, cY = GetCorpseMapPosition()
                  if cX ~= 0 or cY ~= 0 then
                      miX, miY = self:GWP(maI, cX * 100, cY * 100)
                      dtx = 1
                      dty = 1
                  elseif #self.Tra1 > 0 then
                      local tr = self.Tra1[1]
                      miX = tr.TMX
                      miY = tr.TMY
                      dtx = abs(tr.TX1 - tr.TX2)
                      dty = abs(tr.TY1 - tr.TY2)
                  elseif Map.TaX then
                      miX, miY = self.TaX, self.TaY
                      dtx = 1
                      dty = 1
                  end
                  if miX then
                      local mX = (miX + self.PlX) * .5
                      local mY = (miY + self.PlY) * .5
                      local dx = abs(miX - self.PlX)
                      local dy = abs(miY - self.PlY)
                      dx = self.MaW / dx
                      dy = self.MaH / dy
                      local sca = min(dx, dy) * .5
                      dx = self.MaW / dtx
                      dy = self.MaH / dty
                      sca = min(min(dx, dy), sca)
                      sca = max(min(sca, self.LOp.NXAutoScaleMax), self.LOp.NXAutoScaleMin)
                      self:Mov(mX, mY, sca, 60)
                  end
              end
              if rid ~= maI then
                  dSCZ = true
              end
          end
      end
  end
  local scD = abs(self.ScD - self.Sca)
  local xDi = self.MPXD - self.MPX
  local yDi = self.MPYD - self.MPY
  if self.StT ~= 0 and (scD > 0 or xDi ~= 0 or yDi ~= 0) then
      if self.StT > 0 then
          self.StT = -self.StT
          self.SDW = 1 / self.ScD
          self.ScW = 1 / self.Sca
      end
      local st = -self.StT
      self.MPXD = Nx.U_SV(self.MPXD, self.MPX, abs(xDi) / st)
      self.MPYD = Nx.U_SV(self.MPYD, self.MPY, abs(yDi) / st)
      self.SDW = Nx.U_SV(self.SDW, self.ScW, abs(self.SDW - self.ScW) / st)
      self.ScD = 1 / self.SDW
      self.StT = self.StT + 1
  end
  local _, zx, zy, zw = self:GWZI(self.Con, self.Zon)
  if zx then
      self.MaS = self.Sca / 10.02
  end
  local plS = self.GOp["MapPlyrArrowSize"]
  if IsShiftKeyDown() then
      plS = 5
  end
  self.PlF:Show()
  self:CFW(self.PlF, self.PlX, self.PlY, plS, plS, self.PlD)
  self.InC = UnitAffectingCombat("player")
  local g = 1
  local b = 1
  local al = 1
  if self.InC then
      g = 0
      b = 0
      al = abs(GetTime() % 1 - .5) / .5 * .5 + .4
  end
  self.PlF.tex:SetVertexColor(1, g, b, al)
  self.BaA = Nx.U_SV(self.BaA, self.BAT, .05)
  self.Frm.tex:SetVertexColor(1, 1, 1, self.BaA)
  self.WoA = (self.BaA - self.BAF) / (self.BAF1 - self.BAF) * self.BAF1
  self:ReI1()
  self:MoC1()
  self:UpZ()
  self:UIM()
  self:MiU()
  self:UWM()
  self:DCPOI()
  if self.GOp["MapShowTrail"] then
      self:UPH()
  end
  if self.GOp["MapShowPunks"] then
      Nx.Soc:UpI(self)
  end
  local vte = _G["VEHICLE_TEXTURES"]
  for n = 1, GetNumBattlefieldVehicles() do
      local x, y, unN, pos2, typ, ori, pla = GetBattlefieldVehicleInfo(n)
      if x and x > 0 and not pla then
          if vte[typ] then
              local f2 = self:GINI(1)
              local sc = self.ScD * .8
              if typ == "Drive" or typ == "Fly" then
                  sc = 1
              end
              if self:CFZ(f2, x * 100, y * 100, vte[typ]["width"] * sc, vte[typ]["height"] * sc, ori / PI * -180) then
                  f2.tex:SetTexture(WorldMap_GetVehicleTexture(typ, pos2))
              end
          end
      end
  end
  local olL = self.Lev
  if IsShiftKeyDown() then
      self.Lev = self.Lev + 6
      olL = olL - 4
  end
  local nam, des, txI, pX, pY
  local tX11, tX21, tY11, tY21
  local poN = GetNumMapLandmarks()
  for i = 1, poN do
      nam, des1, txI, pX, pY = GetMapLandmarkInfo(i)
      if txI ~= 0 then
          local tip = nam
          if des1 then
              tip = format("%s\n%s", nam, des1)
          end
          pX = pX * 100
          pY = pY * 100
          local f = self:GeI1(3)
          if self.CMBG then
              f.NXType = 2000
              local icT = Nx.MPOIT[txI]
              local siS = ""
              if icT == 1 then
                  siS = " (Ally)"
              elseif icT == 2 then
                  siS = " (Horde)"
              end
              if des1 == NXlINCONFLICT then
                  local sta1 = self.BGT[nam]
                  if sta1 ~= txI then
                      self.BGT[nam] = txI
                      self.BGT[nam .. "#"] = GetTime()
                  end
                  local dur = GetTime() - self.BGT[nam .. "#"]
                  local doD = (rid == 9001 or rid == 9009) and 64 or 241
                  local leD = max(doD - dur, 0)
                  local tmS
                  if leD < 60 then
                      tmS = format(":%02d", leD)
                  else
                      tmS = format("%d:%02d", floor(leD / 60), floor(leD % 60))
                  end
                  f.NXData = format("1~%f~%f~%s%s %s", pX, pY, nam, siS, tmS)
                  tip = format("%s\n%s", tip, tmS)
                  local sz = 30 / self.ScD
                  local f2 = self:GeI1(0)
                  self:CFZTLO(f2, pX, pY, sz, sz, -15, -15)
                  f2.tex:SetTexture(0, 0, 0, .35)
                  f2.NXType = 2000
                  f2.NxT = tip
                  f2.NXData = f.NXData
                  local f2 = self:GINI(1)
                  if leD < 10 then
                      if self.BGGB then
                          local al = abs(GetTime() % .4 - .2) / .2 * .2 + .8
                          local f3 = self:GINI(2)
                          self:CFZTLO(f3, pX, pY, sz * (10 - leD) * .1, 3 / self.ScD, -15, -15)
                          f3.tex:SetTexture(.5, 1, .5, al)
                          local f3 = self:GINI(2)
                          self:CFZTLO(f3, pX, pY, sz * (10 - leD) * .1, 3 / self.ScD, -15, 12)
                          f3.tex:SetTexture(.5, 1, .5, al)
                      end
                  end
                  local red = .3
                  local blu = 1
                  if icT == 2 then
                      red = 1
                      blu = .3
                  end
                  f2.tex:SetTexture(red, .3, blu, abs(GetTime() % 2 - 1) * .5 + .5)
                  local per = leD / doD
                  local vpe = per > .1 and 1 or per * 10
                  if self.BGGB then
                      per = 1 - per
                      vpe = 1
                  else
                      per = max(per, .1)
                  end
                  self:CFZTLO(f2, pX, pY, sz * per, sz * vpe, -15, -15)
              else
                  f.NXData = format("0~%f~%f~%s%s", pX, pY, nam, siS)
                  self.BGT[nam] = nil
                  local sz = 30 / self.ScD
                  local f2 = self:GeI1(0)
                  self:CFZTLO(f2, pX, pY, sz, sz, -15, -15)
                  if icT == 1 then
                      f2.tex:SetTexture(0, 0, 1, .3)
                  elseif icT == 2 then
                      f2.tex:SetTexture(1, 0, 0, .3)
                  else
                      f2.tex:SetTexture(0, 0, 0, .3)
                  end
                  f2.NXType = 2000
                  f2.NxT = tip
                  f2.NXData = f.NXData
              end
          end
          f.NxT = tip
          self:CFZ(f, pX, pY, 16, 16, 0)
          f.tex:SetTexture("Interface\\Minimap\\POIIcons")
          tX11, tX21, tY11, tY21 = WorldMap_GetPOITextureCoords(txI)
          f.tex:SetTexCoord(tX11 + .003, tX21 - .003, tY11 + .003, tY21 - .003)
          f.tex:SetVertexColor(1, 1, 1, 1)
      end
  end
  self.Lev = olL + 4
  Nx.HUD:Upd(self)
  local cTN, cTX, cTY = Nx.Com:UpI(self)
  self.Lev = self.Lev + 2
  self.Gui:UZPOII()
  Nx.Fav:UpI()
  self:UpI(self.KiS)
  self.Lev = self.Lev - 2
  Nx.Que:UpI(self)
  self.Lev = self.Lev + 7
  local fX, fY, fTo
  local flN = GetNumBattlefieldFlagPositions()
  for i = 1, flN do
      fX, fY, fTo = GetBattlefieldFlagPosition(i)
      if fX ~= 0 or fY ~= 0 then
          local f = self:GINI()
          f.tex:SetTexture("Interface\\WorldStateFrame\\" .. fTo)
          self:CFZ(f, fX * 100, fY * 100, 36, 36, 0)
      end
  end
  self.Lev = self.Lev + 1
  local paN1, paX, paY = self:UpG(plX, plY)
  if self.PlS == 0 then
      self.ArS = self.ArS + .01
      if self.ArS >= 1 then
          self.ArS = 0
      end
  end
  self.TrD = false
  self.Gui:OMU1()
  if #self.Tar > 0 then
      self:UpT()
      self:UpT1()
      self.Lev = self.Lev + 2
  end
  self.TETA = false
  local cX, cY = GetCorpseMapPosition()
  if (cX > 0 or cY > 0) and not iBG then
      self.TrN = "Corpse"
      local x, y = self:GWP(maI, cX * 100, cY * 100)
      self:DrT1(plX, plY, x, y, false, "D")
      local f = self:GeI1(1)
      f.NxT = "Your corpse"
      f.tex:SetTexture("Interface\\Minimap\\POIIcons")
      self:CFZ(f, cX * 100, cY * 100, 16, 16, 0)
      f.tex:SetTexCoord(.502, .5605, 0, .0605)
      self.Lev = self.Lev + 2
  elseif ont and Map.TaX then
      self.TrN = Map.TaN
      self.TETA = Map.TETA1
      local x, y = self.TaX, self.TaY
      self:DrT1(plX, plY, x, y, false, "F")
      local f = self:GeI1(1)
      f.NxT = Map.TaN
      f.tex:SetTexture("Interface\\Icons\\Ability_Mount_Wyvern_01")
      self:CFW(f, x, y, 16, 16, 0)
      self.Lev = self.Lev + 2
  end
  if (paX or cTX) and (iBG or next(self.TrP)) then
      if paX then
          self.TrN = paN1
          self:DrT1(plX, plY, paX, paY, false, "B")
      else
          self.TrN = cTN
          self:DrT1(plX, plY, cTX, cTY, false)
      end
      self.Lev = self.Lev + 2
  end
  self.TSF:SetFrameLevel(self.Lev)
  self.PlF:SetFrameLevel(self.Lev + 1)
  self.ToB:SeL1(self.Lev + 2)
  self.Lev = self.Lev + 3
  self:MUE()
  self.LTF:SetFrameLevel(self.Lev + 2)
  self:HEI()
  if Nx.Tic % self.SCM == 3 then
      self:ScC1()
  end
  if dSCZ then
      SetMapToCurrentZone()
  end
end
function Nx.Map:OBTF(but1)
  Nx.Fav:ToS()
end
function Nx.Soc:OnW(typ)
  if typ == "Close" then
      self:HideUIPanel(FriendsFrame)
  end
end
function Nx.Lis:Ini()
  local lda = Nx:GeD("List")
  self.SaD = lda
  if not lda.Version or lda.Version < Nx.VERSIONL then
      if lda.Version then
          Nx.prt("Reset old list data")
      end
      lda.Version = Nx.VERSIONL
      for k, lis in pairs(lda) do
          if type(lis) == "table" then
              lda[k] = nil
          end
      end
  end
  self.Lis1 = {}
  local frm1 = {}
  self.Frm1 = frm1
  self.FUI = 0
  local typ1 = {"Color", "WatchItem", "Info"}
  for n, s in ipairs(typ1) do
      frm1[s] = {}
  end
end
function Nx.Map:CaC3()
  local f = self.Frm
  local x, y = GetCursorPosition()
  x = x / f:GetEffectiveScale()
  y = y / f:GetEffectiveScale()
  self.CFX = x - f:GetLeft()
  self.CFY = f:GetTop() - y
end
function Nx.Win:OMB(but1, id, cli)
  if cli == "LeftButton" then
      self:ToS1()
  else
      self:OpM()
  end
end
function Nx.War.OB_()
  local self = Nx.War
  if self.Ena then
      local del = self.BaO and 0 or .8
      Nx.Tim:Sta("WarehouseCap", del, self, self.CaU)
  end
end
function Nx.Tim:PrE(nam)
  local pro4 = self.Pro2[nam]
  assert(pro4)
  pro4.TiL2 = GetTime() - pro4.Sta
  pro4.Tim1 = pro4.Tim1 + pro4.TiL2
end
function Nx.Map:GWCI(con1)
  local inf = self.MaI2[con1]
  if not inf then
      return
  end
  return inf.Nam, inf.X, inf.Y
end
function Nx.War:AdL1(lin, cou, inv)
  local nam, iLi = GetItemInfo(lin)
  if nam and inv then
      local tot = 0
      if inv[nam] then
          tot = strsplit("^", inv[nam])
      end
      tot = tot + cou
      inv[nam] = format("%d^%s", tot, iLi)
  else
  end
end
function Nx.Map:CFWC(frm, bx, by, w, h)
  local bw = w
  local bh = h
  local clW = self.MaW
  local clH = self.MaH
  local sca = self.ScD
  local x = (bx - self.MPXD) * sca + clW / 2
  local y = (by - self.MPYD) * sca + clH / 2
  local tX1 = 0
  local tX2 = 1
  local vx0 = x - bw * .5
  local vx1 = vx0
  local vx2 = vx0 + bw
  if vx1 < 0 then
      vx1 = 0
      tX1 = (vx1 - vx0) / bw
  end
  if vx2 > clW then
      vx2 = clW
      tX2 = (vx2 - vx0) / bw
  end
  w = vx2 - vx1
  if w < .3 then
      if self.ScF1 ~= frm then
          frm:Hide()
      else
          frm:SetWidth(.001)
      end
      return false
  end
  local tY1 = 0
  local tY2 = 1
  local vy0 = y - bh * .5
  local vy1 = vy0
  local vy2 = vy0 + bh
  if vy1 < 0 then
      vy1 = 0
      tY1 = (vy1 - vy0) / bh
  end
  if vy2 > clH then
      vy2 = clH
      tY2 = (vy2 - vy0) / bh
  end
  h = vy2 - vy1
  if h < .3 then
      if self.ScF1 ~= frm then
          frm:Hide()
      else
          frm:SetWidth(.001)
      end
      return false
  end
  frm:SetPoint("TOPLEFT", vx1, -vy1 - self.TiH)
  frm:SetWidth(w)
  frm:SetHeight(h)
  frm.tex:SetTexCoord(tX1 * .9 + .05, tX2 * .9 + .05, tY1 * .9 + .05, tY2 * .9 + .05)
  frm:Show()
  return true
end
function Nx.Soc.THUD:Cre()
  local opt = Nx:GGO()
  if not opt["TeamTWinEnable"] then
      return
  end
  self.Pla = {}
  for n = 1, MAX_RAID_MEMBERS do
      local dat = {}
      dat.Dis = 999999999
      self.Pla[n] = dat
  end
  self.But1 = {}
  self.NuB = opt["TeamTWinMaxButs"]
  self.HeF = {}
  self.FSt1 = {}
  self.UpT2 = 0
  Nx.Win:SCF(.5, 0)
  local win = Nx.Win:Cre("NxTeamHUD", 20, nil, true, 1, nil, true, true)
  self.Win1 = win
  win:SBGA(0, 1)
  win:ILD(nil, -.6, -.3, 100, 10)
  win.Frm:SetToplevel(true)
  local ox, oy = win:GCO()
  local x = ox - 2
  local y = -oy
  for n = 1, self.NuB do
      local but1 = CreateFrame("Button", nil, win.Frm, "SecureUnitButtonTemplate")
      self.But1[n] = but1
      but1:SetPoint("TOPLEFT", x, y)
      y = y - 14
      if n == 1 then
          but1:SetAttribute("type", "target")
          but1:SetAttribute("unit1", "player")
          but1:SetAttribute("unit2", "targetenemy")
      else
          but1:SetAttribute("type", "macro")
          but1:Hide()
      end
      but1:RegisterForClicks("LeftButtonDown", "RightButtonDown")
      local t = but1:CreateTexture()
      t:SetTexture(0, .1, 0, .9)
      t:SetAllPoints(but1)
      but1.tex = t
      but1:SetWidth(50)
      but1:SetHeight(12)
      local f = CreateFrame("Frame", nil, but1)
      self.HeF[n] = f
      f:SetPoint("TOPLEFT", 0, 0)
      local t = f:CreateTexture()
      t:SetAllPoints(f)
      f.tex = t
      f:SetHeight(12)
      local fst = f:CreateFontString()
      self.FSt1[n] = fst
      fst:SetAllPoints(but1)
      fst:SetFontObject("GameFontNormalSmall")
      fst:SetJustifyH("LEFT")
      fst:SetPoint("TOPLEFT", 0, 0)
      fst:SetWidth(50)
      fst:SetHeight(12)
      fst:SetText("Me")
  end
end
function Nx.Map:SaveView(nam)
  local str = format("%s%s", Nx.IBG or "", nam)
  local v = self.VSD[str]
  if not v then
      v = {}
      self.VSD[str] = v
  end
  v.Sca = self.Sca
  v.X = self.MPX
  v.Y = self.MPY
end
function Nx.TaB:GetHeight()
  return 22
end
function Nx.Inf:CrM()
  local men = Nx.Men:Cre(UIParent, 160)
  self.Men = men
  self.MIT1 = men:AdI1(0, "?", nil, self)
  local ite = men:AdI1(0, "Close", self.M_OC2, self)
  self.MIE = men:AdI1(0, "?", self.M_OE, self)
  men:AdI1(0, "Edit Item", self.M_OEI, self)
  men:AdI1(0, "", nil, self)
  local shM = Nx.Men:Cre(UIParent)
  men:ASM(shM, "Show...")
  self.MIS3 = {}
  for n = 1, 10 do
      local function fun(self, ite)
          Nx.Inf.Inf1[n].Win1:Show()
      end
      self.MIS3[n] = shM:AdI1(0, "#" .. n, fun, self)
  end
  men:AdI1(0, "", nil, self)
  local ite = men:AdI1(0, "New Info Window", self.M_ON, self)
  local ite = men:AdI1(0, "Delete This Window", self.M_OD1, self)
  men:AdI1(0, "", nil, self)
  local function fun()
      Nx.Opt:Ope("Info Windows")
  end
  men:AdI1(0, "Options...", fun)
end
function Nx.Map:AIP(icT, x, y, col, tex)
  local d = self.Dat
  assert(d[icT])
  local tda = d[icT]
  tda.Num = tda.Num + 1
  local ico = {}
  tda[tda.Num] = ico
  ico.X = x
  ico.Y = y
  ico.Col1 = col
  ico.Tex1 = tex
  assert(tda.Tex1 or tex or col)
  return ico
end
function Nx.Lis:SIFSA(sca, alp)
  self.IFS = sca
  self.IFA = alp
end
function Nx.TaB:Cre(nam, paF, wid, hei)
  local c2r = Nx.U_22
  paF = paF or UIParent
  local bar = {}
  setmetatable(bar, self)
  self.__index = self
  bar.Nam = nam
  bar.Tab1 = {}
  local f = CreateFrame("Frame", nam, paF)
  bar.Frm = f
  f.NxI = bar
  f:SetWidth(wid)
  f:SetHeight(hei)
  f:SetPoint("TOPLEFT", 100, -100)
  local t = f:CreateTexture()
  t:SetTexture(c2r("00000080"))
  t:SetAllPoints(f)
  f.tex = t
  f:Show()
  bar:CrB1()
  return bar
end
function Nx.Win:ToM()
  self:SeM(not self.BuM1:GeP())
end
function Nx.Soc.Lis:ClF2(fri)
  local pal = Nx:GeS("Pal")
  for per1, fri1 in pairs(pal) do
      fri1[fri] = nil
      if not next(fri1) then
          if per1 ~= "" then
              pal[per1] = nil
          end
      end
  end
end
function Nx.Que:TPOC()
  if self.RQE ~= GetNumQuestLogEntries() then
      return
  end
  local opt = self.GOp
  if not opt["QBroadcastQChanges"] then
      return
  end
  local cur1 = self.CuQ
  for _, cur in ipairs(cur1) do
      if cur.QI > 0 then
          for n = 1, cur.LBC do
              local ski
              local des1, _, don = GetQuestLogLeaderBoard(n, cur.QI)
              if des1 then
                  if not don then
                      local num = opt["QBroadcastQChangesNum"]
                      local olC1 = tonumber(strmatch(cur[n] or "", ": (%d+)/"))
                      local neC = tonumber(strmatch(des1, ": (%d+)/"))
                      if olC1 and neC then
                          if floor(olC1 / num) == floor(neC / num) then
                              ski = true
                          end
                      end
                  end
                  if not ski and (des1 ~= cur[n] or don ~= cur[n + 100]) then
                      Nx.Com:Sen("P", des1)
                  end
              end
          end
      end
  end
end
function Nx.Lis:GeS2()
  return self.SSW, self.SSH
end
function Nx.Que.Lis:M_OSLL(ite)
  self.SLL = ite:GetChecked()
  self:Upd()
end
function Nx.Ite.ELFS()
  local self = Nx.Ite
  self.ToF = CreateFrame("GameTooltip", "NxTooltipItem", UIParent, "GameTooltipTemplate")
  self.ToF:SetOwner(UIParent, "ANCHOR_NONE")
  self.ItR = 0
  Nx.Tim:Sta("Item", 1, self, self.Tim)
end
function Nx.But:OnE1(mot)
  local but1 = this.NxB
  but1.Ove = true
  but1:Upd()
  local own = this.NXTipFrm or this
  if GameTooltip:IsOwned(own) then
      return
  end
  local tip = this.NxT
  if tip then
      Nx.ToO = own
      if this.NXTipFrm then
          GameTooltip:SetOwner(own, "ANCHOR_TOPLEFT", 0, 0)
      else
          GameTooltip:SetOwner(own, "ANCHOR_LEFT", 0, 5)
      end
      Nx:STT(tip)
  end
end
function Nx.Map:MiU()
  if not self.MMO1 then
      self:MDF1()
      return
  end
  if self.GOp["MapMMMoveCapBars"] then
      local y = 0
      for n = 1, NUM_EXTENDED_UI_FRAMES do
          local f = getglobal("WorldStateCaptureBar" .. n)
          if f and f:IsShown() then
              f:SetPoint("TOPRIGHT", self.Win1.Frm, "BOTTOMRIGHT", 0, y)
              y = y + f:GetHeight()
          end
      end
  end
  if self.DeS then
      self.MMS1 = 0
      local sc = self.DeS
      for n = 1, 6 do
          self.MMS[n] = (8 - n) * 66.6666666666666 / sc
      end
  end
  local mm = self.MMF
  local lOp = self.LOp
  local sca1 = self.MMS
  local inf = self.MWI[self.RMI]
  if inf.Cit and not inf.MMO then
      sca1 = self.MMSC
  end
  local zoT1 = 0
  local zoo = mm:GetZoom(1)
  local doc = lOp.NXMMFull or self.GOp["MapMMDockAlways"]
  if self.Win1:ISM() and self.GOp["MapMMDockOnMax"] then
      doc = true
  end
  if not doc and not self.InI and self.ScD > lOp.NXMMDockOnAtScale then
      mm:ClearAllPoints()
      for n = 1, 6 do
          local sz = sca1[n]
          if self:CMMW(mm, self.PlX, self.PlY, sz, sz) then
              zoT1 = n
              break
          end
      end
  end
  local al = lOp.NXMMAlpha
  local ind1 = IsIndoors()
  local inC = self.Ind1 ~= ind1
  self.Ind1 = ind1
  if self.InI then
      al = 1
  else
      if ind1 and self.GOp["MapMMDockIndoors"] then
          zoT1 = 0
      end
      if inC and self.GOp["MapMMIndoorTogFullSize"] then
          lOp.NXMMFull = false
          if not inf.Cit and ind1 then
              lOp.NXMMFull = true
          end
          self.MMMIF:SetChecked(lOp.NXMMFull)
          Nx.Men:ChU(self.MMMIF)
      end
      if zoT1 == 0 then
          al = lOp.NXMMDockAlpha
      end
      if IsAltKeyDown() then
          al = 1
          self.MMZC = true
      end
  end
  if self.MMZT ~= zoT1 or zoT1 > 0 and self.MMS1 ~= self.ScD or inC then
      self.MMZT = zoT1
      self.MMS1 = self.ScD
      self.MMZC = true
      if self.MMAD == 0 then
          self.MMAD = 2
      end
  end
  if self.MMAD > 0 then
      self.MMAD = self.MMAD - 1
      self.MMZC = true
  end
  mm:SetAlpha(al)
  self:MDF1()
  if zoT1 > 0 then
      self:MUM("MapMMSquare")
      local abo = IsControlKeyDown()
      if self.GOp["MapMMAboveIcons"] then
          abo = not abo
      end
      local lvl = self.Lev
      if abo then
          lvl = lvl + 15
      end
      mm:SetFrameLevel(lvl)
      self:MUDF(lvl + 1)
      self.Lev = self.Lev + 2
  else
      local sc = self.MMFS
      self.MMFS = Nx.IBG and lOp.NXMMDockScaleBG or lOp.NXMMDockScale
      if lOp.NXMMFull then
          self.MMFS = min(self.MaW, self.MaH) / 140
      end
  end
end
function Nx.Que:TOM(qId, qOb, usE, tar, skS)
  local Que = Nx.Que
  local Map = Nx.Map
  local que = Que.ITQ[qId]
  if que then
      local tbi = Que.Tra1[qId] or 0
      local tra3 = bit.band(tbi, bit.lshift(1, qOb))
      local nam
      local zon
      local quO1
      if qOb == 0 then
          quO1 = usE and que[3] or que[2]
      else
          quO1 = que[qOb + 3]
      end
      if quO1 then
          nam, zon = Que:GOP(que, quO1)
      end
      if tra3 > 0 and zon then
          local mId = Map.NTMI[zon]
          if mId then
              if tar then
                  local x1, y1, x2, y2
                  if qOb > 0 then
                      local map = Map:GeM(1)
                      local px = map.PlX
                      local py = map.PlY
                      x1, y1 = Que:GCOP(quO1, mId, px, py)
                      x2 = x1
                      y2 = y1
                  else
                      x1, y1, x2, y2 = Que:GOR(que, quO1)
                      x1, y1 = Map:GWP(mId, x1, y1)
                      x2, y2 = Map:GWP(mId, x2, y2)
                  end
                  if skS then
                      if self:IsT(qId, qOb, x1, y1, x2, y2) then
                          return
                      end
                  end
                  local _, cur = self:FiC3(qId)
                  if cur then
                      if qOb > 0 then
                          nam = cur[qOb] or nam
                      end
                  end
                  self.Map:SeT3("Q", x1, y1, x2, y2, false, qId * 100 + qOb, nam, false, mId)
                  self.Map.Gui:ClA()
              end
              self.Map:GoP()
          else
              Nx.Que:MNIDB("Z")
          end
      else
          local typ, tid = Map:GTI()
          if typ == "Q" then
              local tqi = floor(tid / 100)
              if tqi == qId then
                  if tbi == 0 or (tid == qId * 100 + qOb) then
                      self.Map:ClT1()
                  end
              end
          end
      end
  end
end
function Nx.Map:Ope()
  local Map = Nx.Map
  local m = self.Map1[1]
  if not NxMapOpts.NXMaps then
      NxMapOpts.Version = 0
  end
  if NxMapOpts.Version < NMAPOPTS_VERSION then
      if NxMapOpts.Version > 0 then
          Nx.prt("Reset map options %f", NxMapOpts.Version)
      end
      NxMapOpts = NMOD
  end
  local opt = NxMapOpts.NXMaps[1]
  for k, v in pairs(NMOD.NXMaps[1]) do
      if opt[k] == nil then
          opt[k] = v
      end
  end
  if self.Cre1 then
      if m.Frm:IsShown() then
          m.Frm:Hide()
      else
          m.Frm:Show()
      end
      return
  end
  self.Map1[1] = self:Cre(1)
  self.Doc:Cre()
  self.Cre1 = true
end
function Nx.Fav:OEB(edi, message)
  if message == "Changed" then
      self:Upd()
  end
end
function Nx.Map.Gui.OT_()
  local self = Nx.Map.Gui
  self:SPNPCT()
  self:CNPC("T")
end
function Nx.Map.Gui:GHF()
  local fac2 = UnitFactionGroup("player") == "Horde" and 1 or 2
  if self.ShE then
      fac2 = fac2 == 1 and 2 or 1
  end
  return fac2
end
function Nx.Map:Mov(x, y, sca, stT2)
  self.MPX = x
  self.MPY = y
  if sca then
      self.Sca = sca
  end
  local dis = ((self.MPXD - self.MPX) ^ 2 + (self.MPYD - self.MPY) ^ 2) ^ .5
  local sz = max(self.MaW, self.MaH)
  if dis * self.Sca / sz > 10 then
      stT2 = 1
  end
  local st = abs(self.StT)
  if st > 0 and st < stT2 then
      stT2 = st
  end
  self.StT = stT2
  if dis < .25 then
      self.MPXD = self.MPX
      self.MPYD = self.MPY
  end
  if abs(1 / self.ScD - 1 / self.Sca) < .01 then
      self.ScD = self.Sca
      if dis < .25 then
          self.StT = 0
      end
  end
end
function Nx.ToB:MDU(vaN, val1)
  local bar = self.Act
  local dat = Nx:GDTB()
  local svd = dat[bar.Nam]
  svd[vaN] = val1
  bar:Upd()
end
function Nx.Map:SIT(ico, tip)
  ico.Tip = tip
end
function Nx.Hel:Ini()
  Nx.Tim:Sta("HelpSC", 5, self, self.SCT)
end
function Nx.Map.Gui:M_OSAC(ite)
  self.SAC = ite:GetChecked()
  self:Upd()
end
function Nx.Que:BCS()
  local _
  local cur = self.Wat.ClC2
  local obj = 0
  local flg = 2
  if self.QLC then
      cur = self.QLC
  else
      local typ, tid = Nx.Map:GTI()
      if typ == "Q" then
          local qid = floor(tid / 100)
          _, cur = self:FiC3(qid)
          obj = tid % 100
          flg = 0
      end
  end
  if cur then
      if cur.Com2 then
          flg = flg + 1
      end
      local str = format("%04x%c%c%c", cur.QId, obj + 35, flg + 35, cur.LBC + 35)
      for n = 1, cur.LBC do
          local s1, _, cnt, tot = strfind(cur[n], ": (%d+)/(%d+)")
          if s1 then
              tot = tonumber(tot)
              if tot > 50 then
                  cnt = cnt / tot * 60
                  tot = 60
              end
              cnt = cnt + 2
          else
              cnt = 0
              if cur[n + 100] then
                  cnt = 1
              end
              tot = 0
          end
          str = str .. format("%c%c", cnt + 35, tot + 35)
      end
      return str, 4
  end
  return "", 0
end
function Nx.Fav:MoC(low)
  if self.Sid == 1 then
      local ite = self.CFOF
      if ite then
          local par = self:GetParent(ite)
          Nx.U_TMI1(par, ite, low)
          local i = self:FLI(ite)
          if i > 0 then
              self.Lis:Sel1(i + 1)
          end
      end
  else
      local fav = self.CuF
      if fav and self.CII then
          local i = Nx.U_TMI(fav, self.CII, low)
          if i then
              self.CII = i
              self.ItL:Sel1(i)
          end
      end
  end
  self:Upd()
end
function Nx.Ite:Tim()
  local id = next(self.Nee)
  if id then
      local tip = self.ToF
      self.Nee[id] = nil
      local nam = GetItemInfo(id)
      if nam then
          return .01
      end
      self.Ask[id] = time()
      if not strfind(id, "item:") then
          id = "item:" .. id
      end
      tip:SetHyperlink(id)
      self.ItR = self.ItR + 1
      if next(self.Nee) then
          if not Nx.Tim:IsA("ItemDraw") then
              Nx.Tim:Sta("ItemDraw", 10, self, self.DrT)
          end
          return .1
      end
      Nx.Tim:Sta("ItemDraw", 3, self, self.DrT)
  end
  return 2
end
function Nx.Que.Wat:OLE(evN, va1, va2, cli, but1)
  if evN == "button" then
      local Que = Nx.Que
      local dat = self.Lis:IGD(va1)
      if dat then
          local qIn = bit.band(dat, 0xff)
          local qId = bit.rshift(dat, 16)
          local typ = but1:GeT1()
          if cli == "LeftButton" then
              if typ.WaE then
                  Que:MNIDB("O")
              else
                  if IsAltKeyDown() then
                      Que.Lis:SQI(qIn)
                  else
                      if typ.WaT then
                          va2 = false
                          self:Set(dat, va2)
                      else
                          self:Set(dat, va2, not IsShiftKeyDown())
                      end
                  end
              end
          elseif cli == "RightButton" then
              if typ.WaT then
                  return
              end
              if IsAltKeyDown() then
                  Que.IgA = true
                  ShowUIPanel(QuestLogFrame)
                  Que.IgA = nil
                  Que.Lis.Bar:Sel1(1)
                  Que.Lis:Sel1(qId, qIn)
              elseif IsShiftKeyDown() then
                  Que:LiC(qId)
              else
                  self.MID1 = dat
                  self.MQI1 = qIn
                  self.MQI = qId
                  self.WaM:Ope()
              end
          end
      end
  end
end
function Nx.Map:UpT()
  local del = self.UTD
  if del > 0 then
      self.UTD = del - 1
      return
  end
  local tar1 = self.Tar[1]
  local x = tar1.TMX - self.PlX
  local y = tar1.TMY - self.PlY
  local diY = (x * x + y * y) ^ .5 * 4.575
  if diY < (tar1.Rad or 7) then
      if tar1.TaT ~= "Q" then
          self.UTD = 20
          self.UTD1 = 0
          tremove(self.Tar, 1)
          if #self.Tar > 0 and self.GOp["RouteRecycle"] then
              tinsert(self.Tar, tar1)
          end
          if self.GOp["HUDTSoundOn"] then
              Nx:PlaySoundFile("sound\\interface\\magicclick.wav")
          end
          UIErrorsFrame:AddMessage("Target " .. tar1.TaN1 .. " reached", 1, 1, 1, 1)
          self.Gui:ClA()
          if tar1.RaF then
              tar1.RaF("distance", tar1.UnI, tar1.Rad, diY, diY)
              tar1.RaF = nil
          end
      end
  end
end
function Nx.Map:GIS(leA)
  local frm1 = self.ISF1
  local pos1 = frm1.Nex
  if pos1 > 1500 then
      pos1 = 1500
  end
  local f = frm1[pos1]
  if not f then
      f = CreateFrame("Frame", "NxIconS" .. pos1, self.Frm)
      frm1[pos1] = f
      f.NxM1 = self
      f:SetScript("OnMouseDown", self.IOMD)
      f:SetScript("OnMouseUp", self.IOMU)
      f:SetScript("OnEnter", self.IOE)
      f:SetScript("OnLeave", self.IOL)
      f:SetScript("OnHide", self.IOL)
      f:EnableMouse(true)
      local t = f:CreateTexture()
      f.tex = t
      t:SetAllPoints(f)
  end
  local add = leA or 0
  f:SetFrameLevel(self.Lev + add)
  f.tex:SetVertexColor(1, 1, 1, 1)
  f.NxT = nil
  f.NXType = nil
  f.NXData = nil
  f.NXData2 = nil
  frm1.Nex = pos1 + 1
  return f
end
function Nx.War:OEB(edi, message)
  if message == "Changed" then
      self:Upd()
  end
end
function Nx.Inf:CaD1()
  Nx.Inf.NeD = true
  local dur = Nx.CuC["DurLowPercent"]
  if dur then
      if dur >= 30 then
          return "|cffa0a0a0", format("%d", dur)
      end
      return "|cffff2020", format("%d", dur)
  end
end
function Nx:CRC()
  local cha = NxData.Characters
  local reN = GetRealmName()
  local fuN = reN .. "." .. UnitName("player")
  local t = {}
  for rc, v in pairs(cha) do
      if v ~= Nx.CuC then
          local rna = strsplit(".", rc)
          if rna == reN then
              tinsert(t, rc)
          end
      end
  end
  sort(t)
  tinsert(t, 1, fuN)
  self.ReC1 = t
  for cnu, rc in ipairs(self.ReC1) do
      local ch = cha[rc]
      if ch then
          if ch["XP"] then
              ch["XPMax"] = ch["XPMax"] or 1
              ch["XPRest"] = ch["XPRest"] or 0
              ch["LXP"] = ch["LXP"] or 0
              ch["LXPMax"] = ch["LXPMax"] or 1
              ch["LXPRest"] = ch["LXPRest"] or 0
          end
          ch["TimePlayed"] = ch["TimePlayed"] or 0
      end
  end
end
function Nx.Men:ASM(men, tex1)
  local ite = {}
  self.Ite1[#self.Ite1 + 1] = ite
  setmetatable(ite, Nx.MeI)
  ite.Men = self
  ite.SuM = men
  ite.Tex = tex1
  ite.ShS = 1
  return ite
end
function Nx:CMXY(x, y)
  x = max(0, min(100, x))
  y = max(0, min(100, y))
  return format("%03x%03x", x * 40.9 + .5, y * 40.9 + .5)
end
function Nx.Fav:UpT()
  local sho = self.Win1 and self.Win1:IsShown()
  if self.CuF and self.CII and (self.Rec or sho) then
      self.IUT = true
      local map = Nx.Map:GeM(1)
      local kee
      for n = self.CII, #self.CuF do
          local str = self.CuF[n]
          local typ, fla, nam, dat = self:PaI1(str)
          if typ == "T" then
              if n ~= self.CII then
                  break
              end
              local maI, x, y = self:PIT(dat)
              map:STXY(maI, x, y, nam, kee)
              kee = true
          elseif typ == "t" then
              local maI, x, y = self:PIT(dat)
              map:STXY(maI, x, y, nam, kee)
              kee = true
          else
              break
          end
      end
      if kee then
          map:GoP()
      end
      self.IUT = false
  end
end
function Nx.Win:SeT(tex1, lin1)
  lin1 = lin1 or 1
  if self.TFS[lin1] then
      self.TFS[lin1]:SetText(tex1)
  end
end
function Nx.Fav:IM_OP()
  if not self.CoB then
      Nx.prt("Nothing to paste")
      return
  end
  if type(self.CoB) ~= "string" then
      Nx.prt("Can't paste that on the right side")
      return
  end
  local fav = self.CuF
  if fav then
      local i = min(self.CII, #fav) + 1
      tinsert(fav, i, self.CoB)
  end
  self:Upd()
end
function Nx.Map:BGM_OL(ite)
  self:BGM_S("Losing")
end
function Nx.ToB:M_OAB(ite)
  self:MDU("AlignB", ite:GetChecked())
end
function Nx.Map:InF()
  self.Fun1 = {
      ["None"] = function()
      end,
      ["Add Note"] = self.M_OAN,
      ["Goto"] = self.STAC,
      ["Show Player Zone"] = self.GCZ,
      ["Show Selected Zone"] = self.CeM,
      ["Menu"] = self.OpM,
      ["Zoom In"] = self.CZI,
      ["Zoom Out"] = self.CZO
  }
end
function Nx.Win:ReL1()
  local dat = self.SaD
  if dat["_X"] then
      for k, v in pairs(dat) do
          if k ~= "_X" then
              if strsub(k, -1) == "X" then
                  local mod1 = strsub(k, 1, #k - 1)
                  self:SLD(mod1, dat["_X"], dat["_Y"], dat["_W"], dat["_H"], dat["_L"], dat["_A"], dat["_S"])
                  self:SMSD()
              end
          end
      end
      self.LaM = false
      self:SetLayoutMode()
  end
  self:Loc1(false)
  if self.Nam == "NxMap1" or self.Nam == "NxQuestWatch" then
      self.Frm:Show()
      dat["Hide"] = nil
  end
end
function Nx.Map.Gui:IUS1(src, ite)
  if #src == 0 then
      return ""
  end
  local itD = {"", "normal", "heroic"}
  local raT = {".1%", "1-2%", "3-14%", "15-24%", "25-50%", "51%-99%", "100%"}
  local s = ""
  local typ = strbyte(src, 1)
  if typ == 99 then
      local cnt = strbyte(src, 2) - 35
      for n = 1, cnt do
      end
      local rat = raT[strbyte(src, 2) - 34]
      local i = (strbyte(src, 3) - 35) * 221 + strbyte(src, 4) - 35
      local cre = CarboniteItems["Sources"][i]
      local dif = itD[strbyte(cre, 1) - 34]
      s = format("Creature drop: %s %s (%s)", strsub(cre, 2), dif, rat)
  elseif typ == 111 then
      s = format("Container: %s", strsub(src, 2))
  elseif typ == 113 then
      local cnt = strbyte(src, 2) - 35
      local qs = ""
      for n = 1, cnt do
          if n > 1 then
              qs = qs .. ", "
          end
          local i = n * 2
          local id = (strbyte(src, 1 + i) - 35) * 221 + strbyte(src, 2 + i) - 35
          local q = Nx.Que.ITQ[id]
          if q then
              ite.QId = id
              local qNa, _, lvl = Nx.Que:Unp(q[1])
              qs = qs .. format("[%d] %s", lvl, qNa)
          else
              qs = qs .. id
          end
      end
      s = format("Quest: %s", qs)
  elseif typ == 115 then
      s = format("Spell")
  elseif typ == 118 then
      local cnt = strbyte(src, 2) - 35
      local i = (strbyte(src, 3) - 35) * 221 + strbyte(src, 4) - 35
      local ven = CarboniteItems["Sources"][i]
      s = format("Vendor: %s", ven)
      if cnt > 4 then
          s = s .. " (" .. cnt .. " Total)"
      end
  elseif typ == 119 then
      if #src == 1 then
          return "World drop"
      end
      local maR = raT[strbyte(src, 2) - 34]
      local cnt = strbyte(src, 3) - 35
      s = format("World drop: %s (%s)", strsub(src, 4), maR)
      if cnt > 1 then
          s = s .. " (" .. cnt .. " Total)"
      end
  else
      s = format("%s?", typ)
  end
  return "|cff8080e0" .. s
end
function Nx.Opt:QOT()
  local opt = Nx:GGO()
  local i = opt["OptsQuickVer"] or 0
  local ver = 5
  opt["OptsQuickVer"] = ver
  if i < ver then
      local function fun()
          local opt = Nx:GGO()
          opt["MapMMOwn"] = true
          opt["MapMMButOwn"] = true
          opt["MapMMShowOldNameplate"] = false
          ReloadUI()
      end
      local s =
          "Put the game minimap into the Carbonite map?\n\nThis will make one unified map. The minimap buttons will go into the Carbonite button window. This can also be changed using the Map Minimap options page."
      Nx:ShM(s, "Yes", fun, "No")
  end
end
function Nx.Map:UMF()
  local Map = Nx.Map
  local maI = self.MaI
  local win1 = self.MWI[maI]
  local opt = self.LOp
  local alR1 = opt.NXDetailScale * .35
  local s = opt.NXDetailScale - alR1
  if self.ScD <= s or opt.NXDetailAlpha <= 0 or self:IBGM(maI) then
      self:HMF()
      return
  end
  local alP = min((self.ScD - s) / alR1, 1)
  local miT, bas, bas1, bas2 = self:GMI(maI)
  if not miT then
      self:HMF()
      return
  end
  local lev = self.Lev
  self.Lev = self.Lev + 1
  local f
  local frN = 1
  local sca = 256 * 0.416767770014 * bas2
  local siz = sca
  local miX1 = floor((self.MPXD - bas) / sca - self.MiB / 2 + .5)
  local miY1 = floor((self.MPYD - bas1) / sca - self.MiB / 2 + .5)
  bas = bas + miX1 * sca
  bas1 = bas1 + miY1 * sca
  local wx
  local wy = bas1
  local al = self.BaA * opt.NXDetailAlpha * alP
  for y = miY1, miY1 + self.MiB - 1 do
      wx = bas
      for x = miX1, miX1 + self.MiB - 1 do
          f = self.MiF[frN]
          local txn = Map:GMBN(miT, x, y)
          if txn then
              if self:CFTL(f, wx, wy, siz, siz) then
                  f:SetFrameLevel(lev)
                  f.tex:SetVertexColor(1, 1, 1, al)
                  txn = "Textures\\Minimap\\" .. txn
                  f.tex:SetTexture(txn)
              end
          else
              f:Hide()
          end
          wx = wx + sca
          frN = frN + 1
      end
      wy = wy + sca
  end
end
function Nx.Map.Gui.OG_()
  local self = Nx.Map.Gui
  self:SPNPCT()
  self:CNPC("G")
end
function Nx:OP__1()
  Nx.Win:UpC()
end
function Nx:GeF()
  return NxData.NXFav
end
function Nx.Sli:STLO(tlO)
  local par1 = self.Frm:GetParent()
  self.Frm:SetPoint("TOPRIGHT", par1, "TOPRIGHT", 0, -tlO)
end
function Nx.Opt:NXCmdImportCartHerb()
  local function fun()
      Nx:GICH1()
  end
  Nx:ShM("Import Herbs?", "Import", fun, "Cancel")
end
function Nx.Fav:SNAS(str)
  local wor = {}
  local quo
  local stD
  local cuS = ""
  for s in gmatch(str, ".") do
      if s == quo then
          quo = false
          stD = true
      elseif not quo and (s == '"' or s == "'") then
          quo = s
      elseif s == ' ' and not quo then
          stD = true
      else
          cuS = cuS .. s
      end
      if stD then
          if #cuS > 0 then
              tinsert(wor, cuS)
          end
          stD = false
          cuS = ""
      end
  end
  if #cuS > 0 then
      tinsert(wor, cuS)
  end
  local map = Nx.Map:GeM(1)
  local mId = map.RMI
  local zx, zy = map.PRZX, map.PRZY
  if #wor > 1 then
      mId, zx, zy = map:PTS(table.concat(wor, " ", 2))
  end
  if mId then
      local fav = self.Rec or self:GNF(mId)
      local s = self:CrI("N", 0, wor[1] or "", 1, mId, zx, zy)
      self:AdI1(fav, nil, s)
      self:Upd()
  end
end
function Nx.Tra.TakeTaxiNode(nod)
  local self = Nx.Tra
  local map = Nx.Map
  map.TaN = strsplit(",", TaxiNodeName(nod))
  local nam, x, y = Nx.Map.Gui:FiT2(map.TaN)
  map.TaX = x
  map.TaY = y
  Nx.Map.TETA1 = false
  local tm = self:TCT(nod)
  if tm > 0 and self.TNS then
      self.TTE = GetTime() + tm
      Nx.Tim:Sta("TaxiTime", 1, self, self.TaT2)
  end
  if NxData.DebugMap then
      Nx.prt("Taxi %s (%s) %s secs, node %d", nam or "nil", map.TaN, tm, nod)
  end
  Nx.Tra.OTTN(nod)
end
function Nx.Win:M_OL1(ite)
  local lay = ite:GeS1()
  self.MeW:SFS(lay)
end
function Nx.War:TS_()
  if not self.Ena then
      Nx.prt("Disabled")
      return
  end
  if not self.Win1 then
      self:Cre()
  end
  self.Win1:Show(not self.Win1:IsShown())
  if self.Win1:IsShown() then
      self:CIDT()
      self:Upd()
  end
end
function Nx.Map:MSS(sca, icS1)
  local mm = self.MMF
  local sz = 140 * sca / icS1
  mm:SetWidth(sz)
  mm:SetHeight(sz)
  mm:SetScale(icS1)
end
function Nx:InG()
  if NxData.Version < Nx.VERSIONDATA then
      if NxData.Version > 0 then
          Nx.prt("Reset old data %f", NxData.Version)
      end
      NxData = {}
      NxData.Version = Nx.VERSIONDATA
      NxData.Characters = {}
  end
  if not NxData.NXVer1 then
      NxData.NXVer1 = Nx.VERSION
  end
  Nx:InC1()
  local opt = NxData.NXGOpts
  if not opt or opt.Version < Nx.VERSIONGOPTS then
      if opt and opt.Version < Nx.VERSIONGOPTS then
          Nx.prt("Reset old global options %f", opt.Version)
          Nx:ShM("Options have been reset for the new version.\nPrivacy or other settings may have changed.", "OK")
      end
      opt = {}
      NxData.NXGOpts = opt
      opt.Version = Nx.VERSIONGOPTS
      Nx.Opt:Res()
  end
  if not opt.NXCleaned then
      opt.NXCleaned = true
      local kee = {
          ["Characters"] = 1,
          ["NXCap"] = 1,
          ["NXFav"] = 1,
          ["NXGather"] = 1,
          ["NXGOpts"] = 1,
          ["NXHUDOpts"] = 1,
          ["NXInfo"] = 1,
          ["NXQOpts"] = 1,
          ["NXSocial"] = 1,
          ["NXTravel"] = 1,
          ["NXVendorV"] = 1,
          ["NXVendorVVersion"] = 1,
          ["NXVer1"] = 1,
          ["NXVerT"] = 1,
          ["NXWare"] = 1,
          ["Version"] = 1
      }
      local cnt = 0
      for k, v in pairs(NxData) do
          if not kee[k] then
              NxData[k] = nil
              cnt = cnt + 1
          end
      end
      if cnt > 0 then
          Nx.prt("Cleaned %d items", cnt)
      end
  end
  local fav = NxData.NXFav
  if not fav or fav.Version < Nx.VERSIONFAV then
      if fav then
          Nx.prt("Reset old favorite data %f", fav.Version)
      end
      fav = {}
      NxData.NXFav = fav
      fav.Version = Nx.VERSIONFAV
  end
  local opt = NxData.NXHUDOpts
  if not opt or opt.Version < Nx.VERSIONHUDOPTS then
      if opt then
          Nx.prt("Reset old HUD options %f", opt.Version)
      end
      opt = {}
      NxData.NXHUDOpts = opt
      opt.Version = Nx.VERSIONHUDOPTS
  end
  local inf = NxData.NXInfo
  if not inf or inf.Version < Nx.VERSIONINFO then
      if inf then
          Nx.prt("Reset old info data %f", inf.Version)
      end
      inf = {}
      NxData.NXInfo = inf
      inf.Version = Nx.VERSIONINFO
  end
  local qop = NxData.NXQOpts
  if not qop or qop.Version < Nx.VERSIONQOPTS then
      if qop then
          Nx.prt("Reset old quest options %f", qop.Version)
      end
      qop = {}
      NxData.NXQOpts = qop
      qop.Version = Nx.VERSIONQOPTS
      Nx.Que:OpR()
  end
  local soc = NxData.NXSocial
  if not soc or soc.Version < Nx.VERSIONSOCIAL then
      if soc then
          Nx.prt("Reset old social data %f", soc.Version)
      end
      soc = {}
      NxData.NXSocial = soc
      soc.Version = Nx.VERSIONSOCIAL
  end
  local rn = GetRealmName()
  if not soc[rn] then
      local t = {}
      soc[rn] = t
      t["Pal"] = {}
      t["Pal"][""] = {}
      t["Pk"] = {}
  end
  soc[rn]["PkAct"] = soc[rn]["PkAct"] or {}
  local tr = NxData.NXTravel
  if not tr or tr.Version < Nx.VERSIONTRAVEL then
      if tr then
          Nx.prt("Reset old travel data %f", tr.Version)
      end
      tr = {}
      NxData.NXTravel = tr
      tr.Version = Nx.VERSIONTRAVEL
  end
  tr["TaxiTime"] = tr["TaxiTime"] or {}
  local war = NxData.NXWare
  if not war or war.Version < Nx.VERSIONW then
      if war then
          Nx.prt("Reset old warehouse data %f", war.Version)
      end
      war = {}
      NxData.NXWare = war
      war.Version = Nx.VERSIONW
  end
  local gat = NxData.NXGather
  if not gat or gat.Version < Nx.VERSIONGATHER then
      if gat and gat.Version < .5 then
          Nx.DGU = gat.Version
      else
          if gat then
              Nx.prt("Reset old gather data %f", gat.Version)
          end
          gat = {}
          NxData.NXGather = gat
          gat.NXHerb = {}
          gat.NXMine = {}
      end
      gat.Version = Nx.VERSIONGATHER
  end
  gat["Misc"] = gat["Misc"] or {}
  self.SC2 = {8, 11, 8}
  local cap = NxData.NXCap
  if not cap or cap.Version < Nx.VERSIONCAP then
      cap = {}
      NxData.NXCap = cap
      cap.Version = Nx.VERSIONCAP
      cap["Q"] = {}
  end
  cap["NPC"] = cap["NPC"] or {}
end
function Nx.War.ExD()
  if Nx:CCD() then
      ReloadUI()
  end
end
function Nx.Map.Gui:TS_()
  self.Win1:Show(not self.Win1:IsShown())
end
function Nx.Map.Gui:IFC(fol)
  for n, v in ipairs(fol) do
      if fol.Ite and fol.Ite ~= -8 then
          fol[n] = nil
      else
          self:IFC(v)
      end
  end
end
function Nx.Que:GHT()
  if not Nx.CuC["QHAskedGet"] then
      Nx.CuC["QHAskedGet"] = true
      local function fun()
          QueryQuestsCompleted()
      end
      Nx:ShM("Get character's quest completion data from the server?", "Get", fun, "Cancel")
  end
end
function Nx.Win:SBF(fad2)
  if self.Bor1 then
      local col2 = Nx.Ski:GBC()
      self.Frm:SetBackdropBorderColor(col2[1], col2[2], col2[3], col2[4] * fad2)
  end
end
function Nx.Gra:ReF()
  local n = 1
  local f
  while true do
      f = self.Frm1[n]
      if not f then
          break
      end
      f:Hide()
      n = n + 1
  end
  self.Frm1.Nex = 1
end
function Nx.Win:ISM1()
  return self.BuM1 and self.BuM1:GeP()
end
function Nx:Gat(noT1, id, maI, x, y)
  local rem = self.GaR[noT1]
  if rem then
      id = rem[id] or id
  end
  local dat = NxData.NXGather[noT1]
  local zoT = dat[maI]
  if not zoT then
      zoT = {}
      dat[maI] = zoT
  end
  local maD = (5 / Nx.Map:GWZS(maI)) ^ 2
  local ind
  local noT = zoT[id] or {}
  zoT[id] = noT
  for n, nod in ipairs(noT) do
      local nx = tonumber(strsub(nod, 1, 3), 16) / 40.9
      local ny = tonumber(strsub(nod, 4, 6), 16) / 40.9
      local dis = (nx - x) ^ 2 + (ny - y) ^ 2
      if dis < maD then
          ind = n
          break
      end
  end
  local cnt = 1
  if not ind then
      ind = #noT + 1
  else
      local xy, nCn = strsplit("^", noT[ind])
      local nx = tonumber(strsub(xy, 1, 3), 16) / 40.9
      local ny = tonumber(strsub(xy, 4, 6), 16) / 40.9
      cnt = nCn + 1
      x = (nx * nCn + x) / cnt
      y = (ny * nCn + y) / cnt
  end
  noT[ind] = format("%s^%d", Nx:CMXY(x, y), cnt)
end
function Nx.DrD:AdT(dat, seI)
  for n, nam in ipairs(dat) do
      self:Add(nam, n == seI)
  end
end
function Nx.Lis:ISDE(ind, dat, num)
  self.Dat[(ind or self.Num) + num * 10000000] = dat
end
function Nx.AuA:Upd()
end
function Nx.War.OU__5()
  if arg1 == "player" and not UnitAffectingCombat("player") and Nx.Inf and Nx.Inf.NeD then
      Nx.War:CID()
  end
end
function Nx.Inf:CTMP()
  if self.Var["TMana"] >= 0 then
      self.Var["TMana%"] = self.Var["TMana"] / self.Var["TManaMax"]
      return "|cffe0e0e0", format("%d", self.Var["TMana%"] * 100)
  end
end
function Nx.Hel.Lic:OSS(w, h)
  local self = Nx.Hel.Lic
  self.Frm:SetPoint("TOPLEFT", 0, self.Top)
  self.FSt:SetWidth(w - 20)
end
function Nx.Opt:NXCmdQMapWatchColor()
  Nx.Que:CWC()
end
function Nx.Tim:OnU(ela)
  ela = min(ela, .5)
  for nam, tm in pairs(self.Dat) do
      tm.T = tm.T - ela
      if tm.T <= 0 then
          if tm.F then
              tm.T = tm.F(tm.U, nam, tm)
          end
          if not tm.T then
              self.Dat[nam] = nil
          end
      end
  end
  self:POU()
end
function Nx.prE(msg, ...)
  UIErrorsFrame:AddMessage(format(msg, ...), 1, 1, 0)
end
function Nx.Com.Lis.SoC(v1, v2)
  return v1.Tim1 < v2.Tim1
end
function Nx:STT(str)
  if strbyte(str) == 33 then
      local lin, s = strsplit("^", str)
      if not s or #s < 1 or IsAltKeyDown() then
          str = strsub(lin, 2)
          Nx.Ite:ShT(str, true)
          return
      end
      str = s
  elseif strbyte(str) == 64 then
      str = "quest:" .. strsub(str, 2)
      Nx.Ite:ShT(str, true)
      return
  elseif strbyte(str) == 35 then
      str = strsub(str, 2)
      GameTooltip:SetHyperlink(str)
      GameTooltip_ShowCompareItem()
      return
  end
  local s1, s2 = strfind(str, "\n")
  if s1 then
      local t = {strsplit("\n", str)}
      GameTooltip:SetText(t[1], 1, 1, 1, 1, 1)
      tremove(t, 1)
      for _, lin1 in ipairs(t) do
          local s1, s2 = strsplit("\t", lin1)
          if s2 then
              GameTooltip:AddDoubleLine(s1, s2, 1, 1, 1, 1, 1, 1)
          else
              GameTooltip:AddLine(lin1, 1, 1, 1, 1)
          end
      end
      GameTooltip:Show()
  else
      GameTooltip:SetText(str, 1, 1, 1, 1, 1)
  end
end
function Nx.NXMiniMapBut:M_OSD()
  Nx.Hel.Dem:Sta()
end
function Nx.Soc:OnU()
  if self.Win1 then
      local wf = self.Win1.Frm
      if wf:IsVisible() then
          if self.Win1:IMOS() then
              return
          end
          local f = GuildControlPopupFrame
          if f:IsVisible() then
              if f:GetFrameStrata() ~= wf:GetFrameStrata() then
                  f:SetFrameStrata(wf:GetFrameStrata())
              end
              if f:GetFrameLevel() <= self.Win1.Frm:GetFrameLevel() then
                  f:Raise()
              end
          end
          local f = ChannelFrameDaughterFrame
          if f:IsVisible() then
              f:SetFrameLevel(wf:GetFrameLevel() + 100)
          end
      end
  end
end
function Nx.War.OC__3()
  local self = Nx.War
  if self.Ena then
      Nx.Tim:Sta("WarehouseRec", .5, self, self.RCS)
  end
end
function Nx.Tit:TW2(pro)
  Nx.Hel.Lic:ShO()
  self.X = 0
  self.Y = GetScreenHeight() * .4
  self.XV = 0
  self.YV = 0
  self.Sca = .8
  self.ScT = .8
  self.Alp = 0
  self.AlT = 1
  local opt = Nx:GGO()
  if opt["TitleSoundOn"] then
      PlaySound("ReadyCheck")
  end
  Nx.Pro:SeF(pro, self.Tic)
end
function Nx.NXMiniMapBut:M_OSE()
  Nx.UEv.Lis:Ope()
end
function Nx.Fav:IM_OAC()
  local function fun(str, self)
      local s = self:CrI("", 0, str)
      self:AdI1(self.CuF, self.CII, s)
  end
  Nx:SEB("Name", "", self, fun)
end
function Nx:HNTI(nam)
  local i = self.GLI
  for k, v in ipairs(Nx.GaI1["H"]) do
      if v[i] == nam then
          return k
      end
  end
  if NxData.NXDBGather then
      Nx.prt("Unknown herb %s", nam)
  end
end
function Nx.Inf:CTH()
  if self.Var["TName"] then
      return "|cffc0c0c0", format("%d", self.Var["THealth"])
  end
end
function Nx.TaB:SeU(use, fun)
  self.Use = use
  self.UsF = fun
end
function Nx.Win:SetLayoutMode(mod1)
  local dat = self.SaD
  if mod1 == 1 then
      mod1 = dat["Mode"]
      if mod1 == "Min" then
          self:SetLayoutMode()
          self:SeM(true)
          return
      end
  end
  if mod1 == "" then
      mod1 = nil
  end
  dat["Mode"] = mod1
  mod1 = mod1 or ""
  local f = self.Frm
  local olM = self.LaM
  if olM then
      self:RLD()
  end
  if self.BuM1 then
      if mod1 == "Min" then
          dat["Min"] = true
          self.BuM1:SeP2(true)
      else
          dat["Min"] = nil
          self.BuM1:SeP2(false)
      end
  end
  if self.BuM then
      if mod1 == "Max" then
          self.BuM:SeT1("MaxOn")
      else
          self.BuM:SeT1("Max")
      end
      self.BuM:Upd()
  end
  self.LaM = mod1
  local sw = GetScreenWidth()
  local sh = GetScreenHeight()
  if mod1 == "Max" and not dat["MaxX"] then
      self:SMSD()
  end
  local x = dat[mod1 .. "X"]
  if not x then
      if mod1 == "Min" then
          self:SLD(mod1, sw * .9, sh * .4, 1, 1)
      else
          self:SLD(mod1, sw * .4, sh * .4, sw * .2, sh * .2)
      end
  else
      local w = dat[mod1 .. "W"]
      if w < 0 then
          w = sw * -w
      end
      local h = dat[mod1 .. "H"]
      if h < 0 then
          h = sh * -h
      end
      if x >= 999999 then
          x = (sw - w) * .5
      elseif x >= 300000 then
          local s = dat[mod1 .. "S"] or 1
          x = (sw * .5 + (x - 300000)) / s
      elseif x >= 200000 then
          local s = dat[mod1 .. "S"] or 1
          x = (sw * -.5 - (x - 200000)) / s
      elseif x > 100000 then
          x = sw - x + 100000 - self.BoW
      elseif x < 0 and x > -1 then
          x = sw * -x
      end
      local y = dat[mod1 .. "Y"]
      if y >= 999999 then
          y = (sh - h) * .5
      elseif y < 0 and y > -1 then
          y = sh * -y
      end
      self:SLD(mod1, x, y, w, h, false, dat[mod1 .. "A"], dat[mod1 .. "S"])
  end
  self:SFS(dat[mod1 .. "L"])
  f:ClearAllPoints()
  f:SetPoint(dat[mod1 .. "A"] or "TOPLEFT", dat[mod1 .. "X"], -dat[mod1 .. "Y"])
  f:SetWidth(dat[mod1 .. "W"])
  f:SetHeight(dat[mod1 .. "H"])
  f:SetScale(dat[mod1 .. "S"] or 1)
  f:SetAlpha(dat[mod1 .. "T"] or 1)
  if mod1 == "Max" then
      f:Raise()
      f:Raise()
  end
  if mod1 == "Min" then
      f:SetWidth(125)
      f:SetHeight(28)
  end
  self:Adj()
end
function Nx:OP__2(eve)
  Nx.UEv:AdI(format("Level %d", arg1))
  Nx.Com:OP__2(eve)
end
function Nx.Opt.EIA(str, ite)
  local self = Nx.Opt
  local i = tonumber(str)
  if i then
      self:SeV(ite.V, floor(i))
      self:Upd()
      if ite.VF then
          local var = self:GeV(ite.V)
          self[ite.VF](self, ite, var)
      end
  end
end
function Nx.Ite:Loa1(id)
  if self.Ask[id] then
      if time() - self.Ask[id] > 600 then
          local nam = GetItemInfo(id)
          if not nam then
              return -1
          end
      end
      return
  end
  local nam, lin = GetItemInfo(id)
  if not nam then
      if Nx:GGO()["ItemRequest"] then
          if not self.ATL then
              Nx:ShM(Nx.TXTBLUE ..
                         "Carbonite:\n|cffffff60Data for some items is not available.\nRetrieve data from the server?\n\n|cffff4040May cause a disconnect if an item is not seen on the server yet.",
                  "Get Data", self.ELFS, "Cancel", self.DLFS)
              self.ATL = true
          end
          self.Nee[id] = true
      end
  end
end
function Nx.Map:UpA()
  self.NWU = true
end
function Nx:GeD(nam, ch)
  ch = ch or Nx.CuC
  if nam == "Events" then
      return ch.E
  elseif nam == "List" then
      return ch["L"]
  elseif nam == "Quests" then
      return ch.Q
  elseif nam == "Win" then
      return ch.W
  elseif nam == "Herb" then
      return NxData.NXGather.NXHerb
  elseif nam == "Mine" then
      return NxData.NXGather.NXMine
  end
end
function Nx.Map:OBTW(but1)
  Nx.War:ToS()
end
function Nx.Com:SVM()
  local s1 = format("A newer version of %s is available", NXTITLEFULL)
  local s2 = format("Visit %s%s|cffffffff for an update", Nx.TXTBLUE, Nx.WeS)
  UIErrorsFrame:AddMessage(s2, 1, 1, 1, 1)
  UIErrorsFrame:AddMessage(s1, 1, 1, 0, 1)
  Nx.prt(s1)
  Nx.prt(s2)
end
function Nx.Map:CFZTLO(frm, x, y, w, h, xo, yo)
  x, y = self:GWP(self.MaI, x, y)
  return self:CFTL(frm, x + xo / self.ScD, y + yo / self.ScD, w, h)
end
function Nx.Que:CPC(des1, don)
  local s1, _, i, tot = strfind(des1, ": (%d+)/(%d+)")
  if don then
      return self.PeC[9], s1
  else
      i = s1 and floor(tonumber(i) / tonumber(tot) * 8.99) + 1 or 1
      return self.PeC[i], s1
  end
end
function Nx.Fon:Ini()
  self.Ini1 = true
  self.Fon1 = {
      ["FontS"] = {"NxFontS", "GameFontNormalSmall"},
      ["FontM"] = {"NxFontM", "GameFontNormal"},
      ["FontInfo"] = {"NxFontI", "GameFontNormal"},
      ["FontMap"] = {"NxFontMap", "GameFontNormalSmall"},
      ["FontMapLoc"] = {"NxFontMapLoc", "GameFontNormalSmall"},
      ["FontMenu"] = {"NxFontMenu", "GameFontNormalSmall"},
      ["FontQuest"] = {"NxFontQ", "GameFontNormal"},
      ["FontWatch"] = {"NxFontW", "GameFontNormal"},
      ["FontWarehouseI"] = {"NxFontWHI", "GameFontNormal"}
  }
  self.Fac = {{"Arial", "Fonts\\ARIALN.TTF"}, {"Friz", "Fonts\\FRIZQT__.TTF"}, {"Morpheus", "Fonts\\MORPHEUS.TTF"},
              {"Skurri", "Fonts\\SKURRI.TTF"}}
  self.AdF = {
      ["Arial Narrow"] = true,
      ["Friz Quadrata TT"] = true,
      ["Morpheus"] = true,
      ["Skurri"] = true
  }
  for nam, v in pairs(self.Fon1) do
      local fon = CreateFont(v[1])
      v.Fon = fon
      fon:SetFontObject(v[2])
  end
  self:Upd()
end
function Nx.MeI:SetText(tex1)
  self.Tex = tex1
end
function Nx.War:FCWI(lin)
  local s1, s2, lin = strfind(lin, "item:(%d+)")
  assert(s1)
  local str
  local chC1 = 0
  local toC1 = 0
  for cnu, rc in ipairs(Nx.ReC1) do
      local baC = 0
      local baC1 = 0
      local maC3 = 0
      local rna, cna = strsplit(".", rc)
      local ch = NxData.Characters[rc]
      local bag = ch["WareBags"]
      if bag then
          for nam, dat in pairs(bag) do
              local iCo, iLi = strsplit("^", dat)
              local s1, s2, iLi = strfind(iLi, "item:(%d+)")
              if iLi == lin then
                  baC = baC + iCo
                  break
              end
          end
      end
      local ban = ch["WareBank"]
      if ban then
          for nam, dat in pairs(ban) do
              local iCo, iLi = strsplit("^", dat)
              local s1, s2, iLi = strfind(iLi, "item:(%d+)")
              if iLi == lin then
                  baC1 = baC1 + iCo
                  break
              end
          end
      end
      local mai = ch["WareMail"]
      if mai then
          for nam, dat in pairs(mai) do
              local iCo, iLi = strsplit("^", dat)
              local s1, s2, iLi = strfind(iLi, "item:(%d+)")
              if iLi == lin then
                  maC3 = maC3 + iCo
                  break
              end
          end
      end
      local cnt = baC + baC1 + maC3
      if cnt > 0 then
          chC1 = chC1 + 1
          toC1 = toC1 + cnt
          local s
          if baC1 > 0 then
              s = format("%s %d (%d Bank)", cna, baC, baC1)
          else
              s = format("%s %d", cna, baC)
          end
          if maC3 > 0 then
              s = format("%s (%s Mail)", s, maC3)
          end
          if not str then
              str = s
          else
              str = format("%s\n%s", str, s)
          end
      end
  end
  return str, chC1, toC1
end
function Nx.Map:UOU()
  self.CuO1 = false
  local txF
  local maI = self:GCMI()
  local wzo = self:GWZ(maI)
  if wzo then
      if wzo.Cit then
          return
      end
      txF = wzo.Ove1
  end
  local ove1
  if txF then
      ove1 = Nx.Map.ZoO[txF]
  end
  if not ove1 or not self.ShU then
      local s1, s2, fil
      local ol = {}
      if ove1 then
          for txN, whS in pairs(ove1) do
              ol[txN] = whS
          end
      end
      ove1 = ol
      for i = 1, 99 do
          local txN, txW, txH, oX, oY = GetMapOverlayInfo(i)
          if not txN then
              break
          end
          local s1, s2, fol, fil = strfind(txN, ".+\\.+\\(.+)\\(.+)")
          if s1 then
              txF = fol
              fil = strlower(fil)
              ove1[fil] = format("%d,%d,%d,%d", oX - 10000, oY, txW, txH)
          end
      end
      if not txF then
          ove1 = false
      end
  end
  self.CuO1 = ove1
  self.COTF = txF
end
function Nx.UEv:AdK(nam)
  local maI, x, y = self:GPP()
  Nx:AKE(nam, Nx:Tim1(), maI, x, y)
  self:UpA()
end
function Nx.Com:GCC()
  local chC = 0
  for n = 1, GetNumDisplayChannels() do
      local chn, hea, col4, chN, plC, act1, cat, voE, voA = GetChannelDisplayInfo(n)
      if not hea then
          chC = chC + 1
      end
  end
  return chC
end
function Nx.Map:SCM1(maI)
  if maI then
      self.BaS = 1
      if maI > 1000 and maI < 5000 then
          local con1 = self.MWI[maI].Con
          local zon = self.MWI[maI].Zon
          if not con1 or not zon or maI == self:GRBMI() or maI == self:GRMI() then
              SetMapToCurrentZone()
          else
              SetMapZoom(con1, zon)
          end
      elseif maI > 11000 then
          self.BaS = .025
          if maI == self:GRBMI() then
              self.MaI = 0
              SetMapToCurrentZone()
          else
              SetMapZoom(-1)
              self.MaI = maI
          end
      end
  end
end
function Nx:DOE1(evt, maE)
  if #evt > maE then
      for n = 1, #evt - maE do
          table.remove(evt, 1)
      end
  end
end
function Nx.Fav:SIN(ind, nam)
  nam = gsub(nam, "[~^]", "")
  nam = gsub(nam, "\n", " ")
  local fav = self.CuF
  if fav then
      local typ, fla, _, dat = strsplit("~", fav[ind])
      if dat then
          fav[ind] = format("%s~%s~%s~%s", typ, fla, nam, dat)
      else
          fav[ind] = format("%s~%s~%s", typ, fla, nam)
      end
  end
end
function Nx.War:AdB1(bag1, isB, inv)
  local slo1 = GetContainerNumSlots(bag1)
  for slo = 1, slo1 do
      local tx, cou, loc2 = GetContainerItemInfo(bag1, slo)
      if not loc2 then
          local lin = GetContainerItemLink(bag1, slo)
          if lin then
              self:AdL1(lin, cou, inv)
          end
      end
  end
end
function Nx:OU__(eve, ...)
  Nx.Que:ToP(true)
  if NxData.DebugUnit then
      local gui = UnitGUID("mouseover")
      if gui then
          local tip = GameTooltip
          local typ = tonumber(strsub(gui, 5, 5), 16)
          if typ == 0 then
              tip:AddLine(format("GUID player %s", strsub(gui, 6)))
          elseif typ == 3 then
              local id = tonumber(strsub(gui, 9, 12), 16)
              tip:AddLine(format("GUID NPC %d", id))
          elseif typ == 4 then
              tip:AddLine(format("GUID pet %s", strsub(gui, 13)))
          end
          tip:AddLine(format(" %s", gui))
          tip:Show()
      end
  end
end
function Nx.Inf:CBGWW()
  local i = GetWintergraspWaitTime()
  if i and i > 0 then
      i = i / 60
      return "", format("%d:%02d", i / 60 % 60, i % 60)
  end
end
function Nx.Que:PlaySound(snI)
  if not snI then
      local opt = self.GOp
      local cnt = 0
      for n = 1, 10 do
          if opt["QSnd" .. n] then
              cnt = cnt + 1
          end
      end
      if cnt > 0 then
          local i = random(1, cnt)
          cnt = 0
          for n = 1, 10 do
              if opt["QSnd" .. n] then
                  cnt = cnt + 1
                  if cnt == i then
                      snI = n
                      break
                  end
              end
          end
      end
  end
  if snI then
      local snd = Nx.ODS[snI]
      Nx:PlaySoundFile(snd)
  end
end
function Nx:TTRW(id)
  local map = Nx.Map:GeM(1)
  map:ClearTarget(id)
end
function Nx.Que:ExT(tit)
  local _, e = strfind(tit, "^%[%S+%] ")
  if e then
      tit = strsub(tit, e + 1)
  else
      local _, e = strfind(tit, "^%d+%S* ")
      if e then
          tit = strsub(tit, e + 1)
      end
  end
  return tit
end
function Nx.Fav:SIN1(ico)
  local fav, ind = Nx.Map:GIFD(ico)
  self:OFTF(fav)
  self.FTS = fav
  self.CuF1 = self:GetParent(fav)
  self.CuF = fav
  self.CII = ind
  self.CFOF = fav
  if not (self.Win1 and self.Win1:IsShown()) then
      self:ToS()
      if not self.Win1 then
          return
      end
  else
      self:Upd()
  end
  self:SeI1(ind)
end
function Nx.U_CN(nam)
  nam = Nx.U_CS(nam)
  nam = gsub(nam, "[~%^]", "")
  return nam
end
function Nx.Tra:CaT4()
  self.TNS = false
  local taT = NxCData["Taxi"]
  for n = 1, NumTaxiNodes() do
      local loN2 = strsplit(",", TaxiNodeName(n))
      taT[loN2] = true
      if TaxiNodeGetType(n) == "CURRENT" then
          self.TNS = loN2
          if NxData.DebugMap then
              local nam = Nx.Map.Gui:FiT2(loN2)
              Nx.prt("Taxi current %s (%s)", nam or "nil", loN2)
          end
      end
  end
end
function Nx.Map:UpI(dNG)
  local c2r1 = Nx.U_21
  local c2r = Nx.U_22
  local d = self.Dat
  local wpS = 1
  local wpM = self.GOp["MapIconScaleMin"]
  if wpM >= 0 then
      wpS = self.ScD * .08
  end
  for type, v in pairs(d) do
      v.Ena = dNG or strbyte(type) == 33
      if v.AtS then
          if self.ScD < v.AtS then
              v.Ena = false
          end
      end
  end
  for k, v in pairs(d) do
      if v.Ena then
          if v.DrM == "ZP" then
              local sca = self.IcS * v.Sca * self.ScD
              local w = v.W * sca
              local h = v.H * sca
              for n = 1, v.Num do
                  local ico = v[n]
                  local f = self:GIS(v.Lvl)
                  if self:CFZ(f, ico.X, ico.Y, w, h, 0) then
                      f.NxT = ico.Tip
                      if ico.Tex1 then
                          f.tex:SetTexture(ico.Tex1)
                      elseif v.Tex1 then
                          f.tex:SetTexture(v.Tex1)
                      else
                          f.tex:SetTexture(c2r1(ico.Col1))
                      end
                  end
              end
          elseif v.DrM == "WP" then
              local sca = self.IcS * v.Sca * wpS
              local w = max(v.W * sca, wpM)
              local h = max(v.H * sca, wpM)
              if v.AlN then
                  local aNe = v.AlN * (abs(GetTime() % .7 - .35) / .7 + .5)
                  for n = 1, v.Num do
                      local ico = v[n]
                      local f = self:GIS(v.Lvl)
                      if v.ClF1(self, f, ico.X, ico.Y, w, h, 0) then
                          f.NxT = ico.Tip
                          f.NXType = 3000
                          f.NXData = ico
                          if ico.Tex1 then
                              f.tex:SetTexture(ico.Tex1)
                          elseif v.Tex1 then
                              f.tex:SetTexture(v.Tex1)
                          else
                              f.tex:SetTexture(c2r1(ico.Col1))
                          end
                          local a = v.Alp
                          local dis = (ico.X - self.PlX) ^ 2 + (ico.Y - self.PlY) ^ 2
                          if dis < 306 then
                              a = aNe
                          end
                          f.tex:SetVertexColor(1, 1, 1, a)
                      end
                  end
              else
                  for n = 1, v.Num do
                      local ico = v[n]
                      local f = self:GIS(v.Lvl)
                      if v.ClF1(self, f, ico.X, ico.Y, w, h, 0) then
                          f.NxT = ico.Tip
                          f.NXType = 3000
                          f.NXData = ico
                          if ico.Tex1 then
                              f.tex:SetTexture(ico.Tex1)
                          elseif v.Tex1 then
                              f.tex:SetTexture(v.Tex1)
                          else
                              f.tex:SetTexture(c2r1(ico.Col1))
                          end
                          if v.Alp then
                              f.tex:SetVertexColor(1, 1, 1, v.Alp)
                          end
                      end
                  end
              end
          elseif v.DrM == "ZR" then
              local x, y, x2, y2
              for n = 1, v.Num do
                  local ico = v[n]
                  local f = self:GIS(v.Lvl)
                  f.NxT = ico.Tip
                  x, y = self:GWP(ico.MaI, ico.X, ico.Y)
                  x2, y2 = self:GWP(ico.MaI, ico.X2, ico.Y2)
                  if self:CFTL(f, x, y, x2 - x, y2 - y) then
                      if v.Tex2 then
                          f.tex:SetTexture(v.Tex1)
                      else
                          f.tex:SetTexture(c2r(ico.Col1))
                      end
                  end
              end
          end
      end
  end
end
function Nx.Map:CZO()
  self:OMW(-1)
end
function Nx.Hel.Dem:Cre()
  if self.NXFrm then
      self.NXFrm:Show()
      return
  end
  local f = CreateFrame("Frame", "NxDemo", UIParent)
  f.NxI = self
  self.NXFrm = f
  tinsert(UISpecialFrames, f:GetName())
  f:SetFrameStrata("DIALOG")
  f:SetWidth(400)
  f:SetHeight(100)
  local t = f:CreateTexture()
  t:SetTexture(.05, .05, .05, .95)
  t:SetAllPoints(f)
  f.tex = t
  local fst = f:CreateFontString()
  fst:SetFontObject("GameFontNormalSmall")
  fst:SetJustifyH("CENTER")
  fst:SetJustifyV("TOP")
  fst:SetPoint("TOPLEFT", 0, -3)
  fst:SetWidth(400)
  fst:SetHeight(100)
  fst:SetText("CARBONITE demo. Press escape key to cancel")
  for n = 1, 1 do
      local fst = f:CreateFontString()
      self["NXFStr" .. n] = fst
      fst:SetFontObject("GameFontNormal")
      fst:SetJustifyH("CENTER")
      fst:SetJustifyV("CENTER")
      fst:SetPoint("TOPLEFT", 0, 0)
      fst:SetWidth(400)
      fst:SetHeight(100)
  end
end
function Nx.U_2(col1)
  local t = {}
  for k, v in pairs(col1) do
      t[k] = format("|cff%02x%02x%02x", v.r * 255, v.g * 255, v.b * 255)
  end
  return t
end
function Nx.Que:BQCSD()
  local que1 = Nx:GeC()["Q"]
  for qid, qSt1 in pairs(que1) do
      local dat = {}
      self.QSD = dat
      self.QSDI = 1
      local cnt = 0
      for n = 1, #qSt1, 70 do
          local par2 = strsub(qSt1, n, n + 69)
          local str = format("QcD%s", par2)
          tinsert(dat, str)
      end
      local str = format("Qc1%05x%03x", qid, #qSt1)
      tinsert(dat, 1, str)
      que1[qid] = nil
      return true
  end
end
function Nx.Soc.Lis:FFI(fri)
  local cnt = GetNumFriends()
  for n = 1, cnt do
      local nam, lev, cla, are, con3, sta, not2 = GetFriendInfo(n)
      if nam == fri then
          return n
      end
  end
end
function Nx.Que:IOE(frm)
  local i = frm.NXType - 9000
  local cur = frm.NXData
  self.IHC = cur
  self.IHOI = i
end
function Nx.Lis:OnS(sli, pos1)
  self.Top = floor(pos1)
  self:Upd()
end
function Nx.Que:UnL(loS1, isP)
  local off1 = 0
  if isP == nil then
      isP = strbyte(loS1) <= 33
      off1 = 1
  end
  if isP then
      local x1, x2, y1, y2 = strbyte(loS1, 1 + off1, 4 + off1)
      return ((x1 - 35) * 221 + (x2 - 35)) / 100, ((y1 - 35) * 221 + (y2 - 35)) / 100
  end
  local x, y, w, h = strbyte(loS1, 1, 4)
  return (x - 35) * .5, (y - 35) * .5, (w - 35) * 5.01, (h - 35) * 3.34
end
function Nx.Soc.Lis:Upd()
end
function Nx.ToB:M_OV(ite)
  self:MDU("Vert", ite:GetChecked())
end
function Nx.Inf:CHP()
  return "|cffe0e0e0", format("%d", self.Var["Health%"] * 100)
end
function Nx.Map.Gui:ISF2(fol)
  if fol.T then
      local t = self:CaT2(fol)
      if self.ShF[t] then
          return true
      end
  end
  for shT, chi in ipairs(fol) do
      if type(chi) == "table" then
          if self:ISF2(chi) then
              return true
          end
      end
  end
end
function Nx.Soc.Lis:OLE(evN, sel, va2, cli)
  local nam = self.Lis:IGD(sel)
  self.SeN = nam
  local taI1 = Nx.Soc.TaS1
  if taI1 == 1 then
      local i = self:FFI(nam)
      if i then
          SetSelectedFriend(i)
      end
  end
  if evN == "select" or evN == "mid" or evN == "back" then
  elseif evN == "menu" then
      self.MSN1 = self.SeN
      if taI1 == 1 then
          local i = self:FFI(self.SeN)
          self.PMIN:Show(i ~= nil)
          self.PaM:Ope()
      elseif taI1 == 2 then
          self.PuM:Ope()
      else
          self.CoM1:Ope()
      end
  end
end
function Nx.Lis:ISO(ofX, ofY)
  if not self.Off then
      self.Off = {}
  end
  self.Off[self.Num] = ofX
  self.Off[-self.Num] = ofY
end
function Nx.Lis:ISCB(table, key, haA)
  if not self.BuD then
      self.BuD = {}
  end
  local ind = self.Num
  self.BuD[ind] = "Color"
  self.BuD[ind + 8000000] = table
  self.BuD[ind + 9000000] = key
  if not haA then
      self.BuD[ind + 10000000] = true
  end
end
function Nx.ToB:SeL1(lev)
  self.Frm:SetFrameLevel(lev)
  for n, too in ipairs(self.Too) do
      local but1 = too.But2
      if but1 then
          but1.Frm:SetFrameLevel(lev + 1)
      end
  end
end
function Nx.Que:UGIM()
  local qda = self.GIMCD
  local qId1 = self.QId1
  local cuI1 = 1
  for n = 1, #qda, 4 do
      local qId = tonumber(strsub(qda, n, n + 3), 16)
      local que = self.ITQ[qId]
      local qna, _, lvl, min5 = self:Unp(que[1])
      local col2 = ""
      local sta, qTi = Nx:GeQ(qId)
      if sta == "C" then
          col2 = "|cff808080"
      else
          if qId1[qId] then
              col2 = "|cffa0f0a0"
          end
      end
      local s = format("%s%d %s", col2, lvl, qna)
      local meI = self.GIMICT[cuI1]
      if not meI then
          break
      end
      meI:Show()
      meI:SetText(s)
      meI.UDa = qId
      meI:SetChecked(sta == "C")
      local meI = self.GIMIIT[cuI1]
      meI:Show()
      meI:SetText(s)
      meI.UDa = qId
      cuI1 = cuI1 + 1
  end
end
function Nx.Ski:GBGC()
  return self.BgC
end
function Nx.Win:OnE(eve, ...)
  local win = this.NxW
  if eve == "PLAYER_LOGIN" then
      Nx.Win.LoD = true
      win.LaM = false
      win:SetLayoutMode(1)
  end
  if win.Eve and win.Eve[eve] then
      win.Eve[eve](win.Use, eve, ...)
  end
end
function Nx.Que:CGIM(maM, frm)
  local coM1 = Nx.Men:Cre(frm)
  self.GIMC = coM1
  self.GIMIC = maM:ASM(coM1, "Quest Completion...")
  self.GIMICT = {}
  for n = 1, 29 do
      local function fun(self, ite)
          local s = ite:GetChecked() and "C" or "c"
          Nx:SeQ(ite.UDa, s, time())
          if ite:GetChecked() then
              self:CPD1(ite.UDa)
          end
          self:UGIM()
          self.GIMC:Upd()
          local map = Nx.Map:GeM(1)
          map.Gui:UMI1()
      end
      self.GIMICT[n] = coM1:AdI1(0, "?", fun, self)
      self.GIMICT[n]:SetChecked()
  end
  local inM = Nx.Men:Cre(frm)
  self.GIMI = inM
  self.GIMII = maM:ASM(inM, "Quest Info (shift click - goto)...")
  self.GIMIIT = {}
  for n = 1, 29 do
      local function fun(self, ite)
          if not IsShiftKeyDown() then
              local lin = self:CrL(ite.UDa, -1, "x")
              SetItemRef(lin)
          else
              self:Got(ite.UDa)
          end
      end
      self.GIMIIT[n] = inM:AdI1(0, "?", fun, self)
  end
end
function Nx.Map:M_OINS(ite)
  self.INS = ite:GeS1()
end
function Nx.Opt:PaV(vaN)
  local dat = Nx.OpV[vaN]
  local sco1, typ, val, a1 = strsplit("~", dat)
  local opt = sco1 == "-" and self.COp or self.Opt
  local pre1
  local tx
  if typ == "B" then
      pre1 = false
      tx = "But"
      if opt[vaN] then
          pre1 = true
          tx = "ButChk"
      end
      return typ, pre1, tx
  elseif typ == "CH" then
      return typ, a1
  elseif typ == "W" then
      local wiN, atN = strsplit("^", val)
      local typ, val = Nx.Win:GetAttribute(wiN, atN)
      if typ == "B" then
          if val then
              return typ, true, "ButChk"
          end
          return typ, false, "But"
      end
      return typ, val
  end
  return typ
end
function Nx.Com:LeC1(tyN)
  for n = 1, 10 do
      local id, nam = GetChannelName(n)
      if id > 0 and nam then
          local na3 = strsub(nam, 1, 3)
          if na3 == self.Nam then
              local typ = strupper(strsub(nam, 4, 4))
              if typ == tyN then
                  if typ == "Z" then
                      local naR = strsplit("I", nam)
                      local id = tonumber(strsub(naR, 5))
                      if not self.ZMo[id] then
                          LeaveChannelByName(nam)
                      end
                  else
                      LeaveChannelByName(nam)
                  end
              end
          end
      end
  end
end
function Nx.Map:MUM(opN)
  local nam = self.GOp[opN] and "Interface\\Buttons\\White8x8" or "textures\\MinimapMask"
  if self.MMMN ~= nam then
      self.MMMN = nam
      local mm = self.MMF
      mm:SetMaskTexture(nam)
  end
  local nam = self.MMZT == 0 and "Interface\\Minimap\\MinimapArrow" or ""
  if self.MMAN ~= nam then
      self.MMAN = nam
      self.MMF:SetPlayerTexture(nam)
  end
end
function Nx.Inf:CILTOC(val, vaN)
  if Nx.InC or (self.Var[vaN] or 0) < (tonumber(val) or 1) then
      return "", ""
  end
end
function Nx.Lis:CoS2(coI)
  self.Sor = false
  if self.SCI == coI then
      self.SCI = nil
  else
      self.SCI = coI
  end
  for id, col3 in pairs(self.Col) do
      self:CSN(id, col3.Nam)
  end
end
function Nx.Map:UPH()
  local Map = Nx.Map
  local his = Map.PlH
  local tm = GetTime()
  local sca = self.BaS
  local x = his.LaX - self.MLX
  local y = his.LaY - self.MLY
  local moD = (x * x + y * y) ^ .5
  if moD > self.GOp["MapTrailDist"] * sca then
      his.LaX = self.MLX
      his.LaY = self.MLY
      his.Tim1 = tm
      local next = his.Nex
      local o = next * 4 - 3
      his[o] = GetTime()
      his[o + 1] = self.PlX
      his[o + 2] = self.PlY
      his[o + 3] = self.PlD
      if next >= his.Cnt then
          next = 0
      end
      his.Nex = next + 1
  end
  local siz = min(max(4 * self.ScD * self.BaS, 3), 25)
  local faT = self.GOp["MapTrailTime"]
  for n = 1, his.Cnt * 4, 4 do
      local sec = his[n]
      local tmd = tm - sec
      if tmd < faT then
          local x = his[n + 1]
          local y = his[n + 2]
          local dir = his[n + 3]
          local f = self:GINI()
          if self:CFW(f, x, y, siz, siz, dir) then
              f.tex:SetTexture("Interface\\AddOns\\Carbonite\\Gfx\\Map\\IconCircleFade")
              local a = (faT - tmd) / faT * .9
              f.tex:SetVertexColor(1, 0, 0, a)
          end
      end
  end
end
function Nx.Win:GLM()
  return self.LaM
end
function Nx.Map:M_ORT(ite)
  for _, nam in pairs(Nx.Map.PlN1) do
      self.TrP[nam] = nil
  end
end
function Nx.Lis:OMW(val1)
  if IsShiftKeyDown() then
      val1 = val1 * 5
      if IsControlKeyDown() then
          val1 = val1 * 20
      end
  end
  local ins = this.NxI
  ins.Top = ins.Top - val1
  ins:Upd()
end
function Nx.Win:CoS1(str)
  local nam, x, y = self:PaC(str)
  if not (x and y) then
      Nx.prt("XY missing (%s)", str)
      return
  end
  local win = self:FNC(nam)
  if win then
      win:STS(x, y)
      return
  end
  Nx.prt("Window not found (%s)", str)
end
function Nx.Que:GOP(que, str)
  local Que = Nx.Que
  local nam, zon, loc = Que:UnO(str)
  if not zon then
      return
  end
  local cnt
  local ox = 0
  local oy = 0
  local typ = strbyte(str, loc)
  if typ == 32 then
      cnt = floor((#str - loc) / 4)
      local x, y
      for loN1 = loc + 1, loc + cnt * 4, 4 do
          x, y = Que:ULPO(str, loN1)
          ox = ox + x
          oy = oy + y
      end
  elseif typ == 33 then
      cnt = 1
      ox, oy = Que:ULPR(str, loc + 1)
  else
      loc = loc - 1
      local loC = floor((#str - loc) / 4)
      cnt = 0
      for loN1 = loc + 1, loc + loC * 4, 4 do
          local lo1 = strsub(str, loN1, loN1 + 3)
          local x, y, w, h = Que:ULR(lo1)
          w = w / 1002 * 100
          h = h / 668 * 100
          local are = w * h
          cnt = cnt + are
          ox = ox + (x + w * .5) * are
          oy = oy + (y + h * .5) * are
      end
  end
  ox = ox / cnt
  oy = oy / cnt
  return nam, zon, ox, oy
end
function Nx.Map:GMND(maI)
  local nxz = Nx.MITN1[maI] or 0
  local _, miL, maL1, fac1 = strsplit("!", Nx.Zon1[nxz])
  miL = tonumber(miL)
  fac1 = tonumber(fac1)
  local inS = format("%d-%d", miL, maL1)
  local col = "|cffffffff"
  if self.PFN == fac1 then
      col = "|cff20ff20"
  elseif fac1 == 2 then
      col = "|cffffff00"
  elseif fac1 < 2 then
      col = "|cffff6060"
  end
  if miL == 0 then
      inS = "Any"
  end
  if self:GWZ(maI).Cit then
      inS = "City"
      miL = -1
  end
  return col, inS, miL
end

function Nx.Map:InT1()
  local Nx = Nx
  local woI = self.MWI
  Nx.MNTI1 = {}
  Nx.MITN = {}
  Nx.MITN1 = {}
  self.NTMI = {}
  Nx.NTMI = self.NTMI
  Nx.MOTMI = {}
  self.MaN = {{GetMapZones(1)}, {GetMapZones(2)}, {GetMapZones(3)}, {}, {}}
  -elf.MaN[4] = {GetMapZones(4)}
  self.MaN = {{}, {}, {}, {}, {}}
  tinsert(self.MaN[2], NXlMapNames["Plaguelands: The Scarlet Enclave"] or "Plaguelands: The Scarlet Enclave")
  local BGN = {}
  self.MaN[9] = BGN
  for n = 1, 999 do
      local win1 = woI[9000 + n]
      if not win1 then
          break
      end
      BGN[n] = NXlMapNames[win1.Nam] or win1.Nam
  end
  -- for k, v in ipairs({1, 2, 3, 4}) do
  --     for n = 1, 999 do
  --         local win1 = woI[v * 1000 + n]
  --         if not win1 then
  --             break
  --         end
  --         self.MaN[v][n] = NXlMapNames[win1.Nam] or win1.Nam
  --     end
  -- end

  self.ZoO["lakewintergrasp"][NXlMapWGOverlayName] = "0,0,1024,768"
  self.MSN = NXlMapSubNames
  tinsert(Nx.Zon1, "Dalaran Underbelly!0!0!2!7!!")
  tinsert(self.MaN[4], "Dalaran Underbelly")
  self.CoC = 3
  local coN2 = {1, 2, 3, 9}
  if Nx.V30 then
      self.CoC = 4
      coN2 = {1, 2, 3, 4, 9}
  else
      for n = 122, #Nx.Zon1 do
          Nx.Zon1[n] = nil
      end
  end
  local CZ2I = {}
  self.CZ2I = CZ2I
  for _, ci in ipairs(coN2) do
      local z2i = {}
      CZ2I[ci] = z2i
      if Nx.V30 then
          local inf = self.MaI2[ci]
          inf.X = inf.V30X or inf.X
          inf.Y = inf.V30Y or inf.Y
      end
      for n = 1, 999 do
          local maI = ci * 1000 + n
          local win1 = woI[maI]
          if not win1 then
              break
          end
          if Nx.PFN == 1 and win1.QAIH then
              win1.QAI = win1.QAIH
          end
          local loN2 = NXlMapNames[win1.Nam] or win1.Nam
          local findi = -1
          for i, nam in ipairs(self.MaN[ci]) do
              if nam == loN2 then
                  findi = i
                  z2i[i] = maI
                  break
              end
          end
          -- if findi == -1 then
          --   Nx.prt("Unknown loN2: %s %s", ci, loN2)
          -- end
      end
      for k, v in ipairs(CZ2I[ci]) do
          woI[v].Con = ci
          woI[v].Zon = k
          local ov = woI[v].Ove1
          if ov then
              Nx.MOTMI[ov] = v
          end
      end
  end
  for n = 1, self.CoC do
      CZ2I[n][0] = n * 1000
  end

  for _, ci in ipairs(coN2) do
      if self.CZ2I[ci] then
          for mi, maN in pairs(self.MaN[ci]) do
              Nx.MNTI1[maN] = self.CZ2I[ci][mi]
              if not Nx.MNTI1[maN] then
                  Nx.prt("Unknown map name: %s (%s %s)", maN, ci, mi)
              end
              Nx.MITN[Nx.MNTI1[maN]] = maN
          end
      else
          Nx.prt("Unknown map1 %s", ci)
      end

  end

  for id, v in ipairs(Nx.Zon1) do
      local i = strfind(v, "!")
      local nam = strsub(v, 1, i - 1)
      local dat = strsub(v, i + 1)
      local loN2 = NXlMapNames[nam]
      if loN2 then
          Nx.Zon1[id] = loN2 .. "!" .. dat
      end
  end
  for _, ci in ipairs(coN2) do
      local inf = self.MaI2[ci]
      local cx = inf.X
      local cy = inf.Y
      for n = 0, 999 do
          local win1 = woI[ci * 1000 + n]
          if not win1 then
              break
          end
          win1[4] = cx + win1[2]
          win1[5] = cy + win1[3]
      end
  end
  for id, v in pairs(Nx.Zon1) do
      local nam, miL, maL1, fac1, con1, enI, enP = strsplit("!", v)
      if fac1 == "3" and con1 == "5" then
          assert(enI and enP)
          if enI == "0" then
              enI = "125"
          end
          local i = strfind(nam, ": ")
          if i then
              nam = strsub(nam, i + 2)
          end
          local enZ = Nx.Zon1[tonumber(enI)]
          local ena2, _, _, _, con1 = strsplit("!", enZ)
          if con1 == "7" then
              con1 = 4
          end
          local mid = con1 * 1000 + 10000 + id
          Nx.MNTI1[nam] = mid
          Nx.MITN[mid] = nam
          local emi = Nx.MNTI1[ena2]
          local ex, ey = Nx.Que:UnL(enP, true)
          if self.MWI[mid] then
              ex = ex + self.MWI[mid][2]
              ey = ey + self.MWI[mid][3]
          end
          local x, y = self:GWP(emi, ex, ey)
          local ewi = self.MWI[emi]
          if not ewi then
              Nx.prt("? %s %s", ena2, emi or "nil")
          end
          local win1 = {}
          win1.EMI = emi
          win1[1] = 1002 / 25600
          win1[2] = x
          win1[3] = y
          win1[4] = x
          win1[5] = y
          self.MWI[mid] = win1
      end
  end
  for id, v in ipairs(Nx.Zon1) do
      local nam, miL, maL1, fac1 = strsplit("!", v)
      if id ~= 146 then
          local i = strfind(nam, ": ")
          if i then
              nam = strsub(nam, i + 2)
          end
      end
      local maI = Nx.MNTI1[nam]
      if maI then
          Nx.MITN1[maI] = id
          self.NTMI[id] = maI
      else
      end
  end
  for k, v in ipairs(Nx.Zon1) do
      local nam, miL, maL1, fac1, con1, enI = strsplit("!", v)
      if fac1 ~= "3" then
          if enI and enI ~= "" then
              self.NTMI[k] = self.NTMI[tonumber(enI)]
          end
      end
  end
  Nx.ZoC = Nx["ZoneConnections"] or Nx.ZoC
  for ci = 1, self.CoC do
      for n = 0, 999 do
          local maI = ci * 1000 + n
          local win1 = woI[maI]
          if not win1 then
              break
          end
          local con2 = {}
          win1.Con1 = con2
          for _, str in ipairs(Nx.ZoC) do
              local fla, ta, tb, z1, x1a, x1b, y1a, y1b, z2, x2a, x2b, y2a, y2b, na1 = strbyte(str, 1, 14)
              --print(fla, ta, tb, z1, x1a, x1b, y1a, y1b, z2, x2a, x2b, y2a, y2b, na1)
              fla = fla - 35
              local coT = (ta - 35) * 221 + tb - 35
              local mI1 = self.NTMI[z1 - 35]
              local mI2 = self.NTMI[z2 - 35]
              if coT == 1 and (maI == mI1 or (maI == mI2 and bit.band(fla, 1) == 1)) then
                  local co1 = self:ITCZ(mI1)
                  local co2 = self:ITCZ(mI2)
                  if co1 == co2 then
                      na1 = na1 - 35
                      local na11 = na1 == 0 and "" or strsub(str, 15, 14 + na1)
                      local i = 15 + na1
                      local na2 = strbyte(str, i)
                      if na2 == nil then
                        Nx.prt(maI.." "..str.." "..i)
                      end
                      local na21 = na2 == 0 and "" or strsub(str, i + 1, i + na2)
                      local x1 = ((x1a - 35) * 221 + x1b - 35) / 100
                      local y1 = ((y1a - 35) * 221 + y1b - 35) / 100
                      local x2 = ((x2a - 35) * 221 + x2b - 35) / 100
                      local y2 = ((y2a - 35) * 221 + y2b - 35) / 100
                      if maI == mI2 then
                          mI1, mI2 = mI2, mI1
                          x1, y1, x2, y2 = x2, y2, x1, y1
                      end
                      local zco = con2[mI2] or {}
                      con2[mI2] = zco
                      if x1 ~= 0 and y1 ~= 0 then
                          local con = {}
                          tinsert(zco, con)
                          x1, y1 = self:GWP(mI1, x1, y1)
                          x2, y2 = self:GWP(mI2, x2, y2)
                          con.SMI = mI1
                          con.StX = x1
                          con.StY = y1
                          con.EMI1 = mI2
                          con.EnX = x2
                          con.EnY = y2
                          con.Dis = ((x1 - x2) ^ 2 + (y1 - y2) ^ 2) ^ .5
                      end
                  end
              end
          end
      end
  end
end
function Nx:ShM(msg, f1T, fu1, f2T, fu2)
  local pop = StaticPopupDialogs["NxMsg"]
  if not pop then
      pop = {
          ["whileDead"] = 1,
          ["hideOnEscape"] = 1,
          ["timeout"] = 0
      }
      StaticPopupDialogs["NxMsg"] = pop
  end
  pop["text"] = msg
  pop["button1"] = f1T
  pop["OnAccept"] = fu1
  pop["button2"] = f2T
  pop["OnCancel"] = fu2
  StaticPopup_Show("NxMsg")
end
function Nx.Fav:PIT(dat)
  local zon = tonumber(strsub(dat, 1, 2), 16)
  local id = Nx.NTMI[zon]
  local x = tonumber(strsub(dat, 3, 5), 16) / 4090 * 100
  local y = tonumber(strsub(dat, 6, 8), 16) / 4090 * 100
  local dLv = (strbyte(dat, 9) or 35) - 35
  return id, x, y + dLv * 100
end
function Nx:ReC()
  local ch = self.CuC
  local map = self.Map:GeM(1)
  if map.RMI then
      ch["Pos"] = format("%d^%f^%f", map.RMI, map.PRZX, map.PRZY)
  end
  ch["Time"] = time()
  ch["Level"] = UnitLevel("player")
  if ch["Level"] > ch["LLevel"] then
      ch["LLevel"] = ch["Level"]
      ch["LvlTime"] = time()
      ch["LXP"] = UnitXP("player")
      ch["LXPMax"] = UnitXPMax("player")
      ch["LXPRest"] = GetXPExhaustion() or 0
  end
  ch["Money"] = GetMoney()
  ch["XP"] = UnitXP("player")
  ch["XPMax"] = UnitXPMax("player")
  ch["XPRest"] = GetXPExhaustion() or 0
  ch["ArenaPts"] = GetArenaCurrency()
  ch["Honor"] = GetHonorCurrency()
  if self.War.TiP then
      ch["TimePlayed"] = self.War.TiP
      self.War.TiP = nil
      if Nx.BCF_DTP then
          ChatFrame_DisplayTimePlayed = Nx.BCF_DTP
          Nx.BCF_DTP = nil
      end
  end
  Nx.InS["ArenaPts"] = ch["ArenaPts"]
  Nx.InS["Honor"] = ch["Honor"]
  Nx.InS["XPRest%"] = ch["XPRest"] / ch["XPMax"] * 100
end
function Nx.Com:SeP3(msg)
  assert(msg)
  self.PSQ[#self.PSQ + 1] = msg
end
function Nx:AdE(eve, nam, time, maI, x, y)
  local ev = Nx.CuC.E[eve]
  local i = #ev + 1
  local ite = {}
  ev[i] = ite
  ite.NXName = nam
  ite.NXTime = time
  ite.NXMapId = maI
  ite.NXX = x
  ite.NXY = y
end
function Nx.Map.Gui:CaI()
  if not NxData.NXVendorV then
      return
  end
  local opt = Nx:GGO()
  local map = Nx.Map:GeM(1)
  if MerchantFrame:IsVisible() then
      local vca = Nx.VCA
      local npc = self.PNPCT
      local tag, nam = strsplit("~", npc)
      npc = format("%s~%s", tag, nam)
      local lin2 = {}
      lin2["POS"] = format("%d^%s^%s", map.RMI, map.PRZX, map.PRZY)
      lin2["T"] = time()
      lin2["R"] = self.VeR
      for n = 1, GetMerchantNumItems() do
          local nam, tx, pri, qua2, nuA, usa, exC = GetMerchantItemInfo(n)
          local lin = GetMerchantItemLink(n)
          if not lin then
              return
          end
          local prS1 = Nx.U_GMS(pri)
          if exC then
              local hon, are1, iCn = GetMerchantItemCostInfo(n)
              if pri <= 0 then
                  prS1 = ""
              else
                  prS1 = prS1 .. " "
              end
              if hon and hon > 0 then
                  prS1 = format("%s|cffff70a0%d honor", prS1, hon)
              elseif are1 and are1 > 0 then
                  prS1 = format("%s|cffff90a0%d arena", prS1, are1)
              end
              if iCn > 0 then
                  for i = 1, MAX_ITEM_COST do
                      local tx, val1 = GetMerchantItemCostItem(n, i)
                      if tx and val1 and val1 > 0 then
                          tx = gsub(tx, "Interface\\Icons\\", "")
                          prS1 = prS1 .. format(" |r%d %s", val1, vca[tx] or tx)
                      end
                  end
              end
          end
          local _, id = strsplit(":", lin)
          lin2[n] = id .. "^" .. strtrim(prS1)
      end
      local vv = NxData.NXVendorV
      vv[npc] = lin2
      local oNa
      local maC1 = min(max(1, opt["GuideVendorVMax"]), 1000)
      opt["GuideVendorVMax"] = maC1
      while true do
          local old = math.huge
          local cnt = 0
          for npN, lin2 in pairs(vv) do
              cnt = cnt + 1
              if lin2["T"] < old then
                  old = lin2["T"]
                  oNa = npN
              end
          end
          if cnt <= maC1 then
              break
          end
          vv[oNa] = nil
      end
      if Nx.LoO then
          Nx.prt("Captured %s (%d)", npc, #lin2)
      end
      return true
  end
end
function Nx.Map.Gui:M_OAGQ()
  local ite = self.MCI
  if ite.QId then
      Nx.Que:Got(ite.QId)
  end
end
function Nx.Fav:FiF1(val, vaN, par)
  par = par or self.Fol
  for _, ite in ipairs(par) do
      if ite["T"] == nil then
          if ite[vaN] == val then
              return ite
          end
      end
  end
end
function Nx.Map.Doc:MOI()
  self.InP = nil
  local map = Nx.Map:GeM(1)
  local mm = getglobal("Minimap")
  local mON = {"NXMiniMapBut", "GameTimeFrame", "TimeManagerClockButton", "MiniMapWorldMapButton", "MiniMapMailFrame",
               "MiniMapTracking", "MiniMapVoiceChatFrame", "MiniMapBattlefieldFrame", "MiniMapLFGFrame"}
  local f = getglobal("MinimapBackdrop")
  map.MMOF[f] = 0
  self.MMF1 = {}
  for k, nam in ipairs(mON) do
      local f = getglobal(nam)
      if f then
          map.MMOF[f] = 0
          tinsert(self.MMF1, f)
          f:SetParent(self.Win1.Frm)
          if nam == "MiniMapTracking" then
              f:Show()
          end
      end
  end
  local tex4 = {
      ["Interface\\AddOns\\CT_Core\\Images\\minimapIcon"] = 1
  }
  local map1 = map.Frm
  local win2 = self.Win1.Frm
  local fou = {}
  local f = EnumerateFrames()
  while f do
      if not f:IsObjectType("Model") then
          local pt, reT = f:GetPoint()
          if reT == mm then
              local par = f:GetParent()
              if par ~= mm and par ~= map1 then
                  fou[f] = 1
              end
          end
          local reg = {f:GetRegions()}
          for k, v in ipairs(reg) do
              if v:IsObjectType("Texture") then
                  local tna = v:GetTexture()
                  if tna and tex4[tna] then
                      fou[f] = 1
                      break
                  end
              end
          end
      end
      f = EnumerateFrames(f)
  end
  for f in pairs(fou) do
      if not map.MMOF[f] then
          map.MMOF[f] = 0
          tinsert(self.MMF1, f)
          f:SetParent(win2)
      end
  end
  map.Win1:Show(map.StS)
  Nx.Map:MBSU()
  if NxData.DebugDock then
      Nx.prt("DockScan %s", #self.MMF1)
  end
end
function Nx.Map:HEZT()
  local frm1 = self.TiF1
  frm1[4]:Hide()
  frm1[8]:Hide()
  frm1[9]:Hide()
  frm1[12]:Hide()
end
function Nx.Soc.Lis:FFP(fri)
  local pal = Nx:GeS("Pal")
  for per1, fri1 in pairs(pal) do
      for fna, v in pairs(fri1) do
          if fri == fna then
              return per1
          end
      end
  end
end
function Nx.Win:SMSD()
  local sw = GetScreenWidth()
  local sh = GetScreenHeight()
  self:SLD("Max", sw * .1, sh * .1, sw * .8, sh * .8, 2, "TOPLEFT")
end
function Nx:GVU()
  Nx:GVUT("NXHerb")
  Nx:GVUT("NXMine")
end
function Nx.Win:OMB1(but1, id, cli)
  self:SeM(but1:GeP())
end
function Nx.Inf:Up_()
  local Nx = Nx
  if not self.Win1 or not self.Win1:IsVisible() then
      return
  end
  local lis = self.Lis
  lis:Emp()
  self:UpI1()
  lis:Upd()
end
function Nx.Com:Tes(a1, a2)
  self:SSG("? }a", "")
end
function Nx.Que.Lis.FOEFG()
  Nx.SMT()
  local self = this.NxI
  local s = self.Fil[self.TaS1]
  if s ~= "" then
      this:SetText(s)
  else
      this:SetText("")
  end
end
function Nx.Opt:NXCmdGryphonsUpdate()
  if self.Opt["GryphonsHide"] then
      MainMenuBarLeftEndCap:Hide()
      MainMenuBarRightEndCap:Hide()
  else
      MainMenuBarLeftEndCap:Show()
      MainMenuBarRightEndCap:Show()
  end
end
function Nx.Que:TP2(stC2, tiS)
  if not self.GOp["QAddTooltip"] then
      return
  end
  local tip = GameTooltip
  local teN = "GameTooltipTextLeft"
  local quS = format("|cffffffffQ%suest:", Nx.TXTBLUE)
  for n = 2, tip:NumLines() do
      local s1 = strfind(getglobal(teN .. n):GetText() or "", quS)
      if s1 then
          return
      end
  end
  if stC2 then
      tiS = gsub(tiS, "|c%x%x%x%x%x%x%x%x", "")
  end
  if tiS and #tiS > 5 and #tiS < 50 and not self.TTI[tiS] then
      tiS = self.TTC[tiS] or tiS
      local tSL = strlower(tiS)
      local cur1 = self.CuQ
      for cur2, cur in ipairs(cur1) do
          if not cur.Got then
              local s1 = strfind(cur.ObT, tiS, 1, true)
              if not s1 then
                  s1 = strfind(cur.DeT1, tiS, 1, true)
              end
              if not s1 then
                  s1 = strfind(cur.ObT, tSL, 1, true)
              end
              if not s1 then
                  s1 = strfind(cur.DeT1, tSL, 1, true)
              end
              if not s1 then
                  for n = 1, cur.LBC do
                      s1 = strfind(cur[n], tiS)
                      if s1 then
                          break
                      end
                  end
              end
              if s1 then
                  local col = self:GetDifficultyColor(cur.Lev)
                  col = format("|cff%02x%02x%02x", col.r * 255, col.g * 255, col.b * 255)
                  tip:AddLine(format("%s %s%d %s", quS, col, cur.Lev, cur.Tit))
                  for n = 1, cur.LBC do
                      if strfind(cur[n], tiS) then
                          local col, s1 = self:CPC(cur[n], cur[n + 100])
                          if s1 then
                              local oNa = strsub(cur[n], 1, s1 - 1)
                              tip:AddLine(format("    |cffb0b0b0%s%s%s", oNa, col, strsub(cur[n], s1)))
                          else
                              tip:AddLine(format("    %s%s", col, cur[n]))
                          end
                      end
                  end
                  return true;
              end
          end
      end
  end
end
function Nx.UEv:AdM(nam)
  local maI, x, y = self:GPP()
  local id = Nx:MNTI(nam)
  if id then
      Nx:AME(nam, Nx:Tim1(), maI, x, y)
      Nx:GaM(id, maI, x, y)
  end
  self:UpA(true)
end
function Nx:GaU(ite)
  local xy = strsplit("^", ite)
  local x = tonumber(strsub(xy, 1, 3), 16) / 40.9
  local y = tonumber(strsub(xy, 4, 6), 16) / 40.9
  return x, y
end
function Nx.ToB:OpM(bar)
  local dat = Nx:GDTB()
  local svd = dat[bar.Nam]
  self.MIS1:SeS2(svd["Size"])
  self.MIS2:SeS2(svd["Space"] or 3)
  self.MIAR:SetChecked(svd["AlignR"])
  self.MIAB:SetChecked(svd["AlignB"])
  self.MIV:SetChecked(svd["Vert"])
  self.Act = bar
  self.Men:Ope()
end
function Nx.Que:PBSD()
  local dat = {}
  self.PSD = dat
  self.PSDI = 1
  local seS = ""
  for n, cur in ipairs(self.CuQ) do
      local qId = cur.QId
      if not cur.Got and Nx:GeQ(qId) == "W" then
          local flg = 0
          if cur.Com2 then
              flg = flg + 1
          end
          local str = format("%04x%c%c", qId, flg + 35, cur.LBC + 35)
          for n = 1, cur.LBC do
              local _, _, cnt, tot = strfind(cur[n], ": (%d+)/(%d+)")
              cnt = tonumber(cnt)
              tot = tonumber(tot)
              if cnt and tot then
                  if cnt > 200 then
                      cnt = 200
                  end
              else
                  cnt = 0
                  if cur[n + 100] then
                      cnt = 1
                  end
                  tot = 0
              end
              str = str .. format("%02x%02x", cnt, tot)
          end
          seS = seS .. str
          if #seS > 80 then
              tinsert(dat, seS)
              seS = ""
          end
      end
  end
  if #seS > 0 or #dat == 0 then
      tinsert(dat, seS)
  end
  Nx.Tim:Sta("QSendParty", 0, self, self.PST)
  return 0
end
function Nx.Inf:CFPS()
  return "|cffc0c0c0", format("%.0f", GetFramerate())
end
function Nx.Lis:SeF1(fad2)
  if not self.NBGF then
      self.Frm.tex:SetVertexColor(1, 1, 1, fad2)
  end
  local hf = self.HdF
  if hf then
      hf.tex:SetVertexColor(1, 1, 1, fad2)
  end
  self.SeF2:SetAlpha(fad2)
  if self.Sli then
      self.Sli.Frm.tex:SetAlpha(fad2 * .6)
      self.Sli.ThF.tex:SetAlpha(fad2 * .9)
  end
end
function Nx.Map:BGM_OG(ite)
  self:BGM_S("Guard")
end
function Nx.Win:SLM(mod1)
  mod1 = mod1 or ""
  if self.LaM ~= mod1 then
      if self.LaM == "Max" then
          self.LMN = mod1
      else
          self:SetLayoutMode(mod1)
      end
  end
end
function Nx.NXMiniMapBut:M_OSC()
  Nx.Com1:Ope()
end
function Nx.Gra:OSS(w, h)
  local g = self.NxG
  if g.Wid ~= w or g.Hei ~= h then
      g.Wid = w
      g.Hei = h
      g:UpF()
  end
end
function Nx.Map:CZI()
  self:OMW(1)
end
function Nx.Win:IsVisible()
  return self.Frm:IsVisible()
end
function Nx.Map:M_OMZ(ite)
  Nx.Com:MoZ(self.MMI, ite:GetChecked())
end
function Nx.EdB:GetText()
  return self.FiS
end
function Nx.Men:Show(show)
  for _, ite in ipairs(self.Ite1) do
      ite:Show(show)
  end
end
function Nx.Opt:NXCmdMMOwnChange(ite, var)
  self:SeV("MapMMShowOldNameplate", not var)
  self:SeV("MapMMButOwn", var)
  self:Upd()
  self:NXCmdReload()
end
function Nx.Que:CWC()
  local opt = self.GOp
  local col1 = {}
  self.QLC1 = col1
  local a = Nx.U_24(opt["QMapWatchAreaAlpha"])
  local coM = opt["QMapWatchColorCnt"]
  local coI2 = 1
  for n = 1, 15 do
      local col = {}
      col1[n] = col
      local r, g, b = Nx.U_23(opt["QMapWatchC" .. coI2])
      col[1] = r
      col[2] = g
      col[3] = b
      col[4] = a
      col[5] = "QuestListWatch"
      coI2 = coI2 + 1
      coI2 = coI2 > coM and 1 or coI2
  end
end
function Nx.Opt:NXCmdQSound(ite, var)
  if var then
      local snI = tonumber(gsub(ite.V, "%a", ""), 10)
      Nx.Que:PlaySound(snI)
  end
end
function Nx.Inf:CaT(str)
  local ok, s = pcall(date, str ~= "" and str or nil)
  return "|cffa0a0a0", ok and s or "?"
end
function Nx.U_DS(str)
  local s = ""
  local sc = strchar
  local sb = strbyte
  local i = 4
  for n = 1, #str do
      s = s .. sc(sb(str, n) + 2 - (n % i))
  end
  return s
end
function Nx.Fav:UpI1(seI)
  local lis = self.ItL
  if not lis then
      return
  end
  lis:Emp()
  if self.CuF then
      for ind, str in ipairs(self.CuF) do
          local typ, fla, nam, dat = self:PaI1(str)
          lis:ItA(ite)
          lis:ISB("Chk", bit.band(strbyte(fla) - 35, 1) > 0)
          if typ == "" then
              lis:ItS(3, format("|cffa0a0a0-- %s", nam))
          elseif typ == "N" then
              local ico, id, x, y = self:PIN(dat)
              ico = self:GII(ico)
              id = Nx.MITN[id] or "?"
              lis:ItS(2, "Note:")
              lis:ItS(3, format("%s %s", ico, nam))
              lis:ItS(4, format("|cff80ef80(%s %.1f %.1f)", id, x, y))
          elseif typ == "T" or typ == "t" then
              local tyN1 = typ == "T" and "Target 1st" or "Target"
              local maI, x, y = self:PIT(dat)
              local maN = Nx.MITN[maI] or "?"
              lis:ItS(2, format("%s:", tyN1))
              lis:ItS(3, format("%s", nam))
              lis:ItS(4, format("|cff80ef80(%s %.1f %.1f)", maN, x, y))
          end
      end
  end
  if seI then
      lis:Sel1(seI)
  end
  lis:Upd()
end
function Nx.Win:SBGC(r, g, b, a)
  if self.Frm.tex then
      self.Frm.tex:SetTexture(r, g, b, a or 1)
  end
end
function Nx.Win:Not(nam, ...)
  if self.UsF then
      self.UsF(self.Use, nam, ...)
  end
end
function Nx.Map:UpT1()
  local del = self.UTD1 - 1
  if del <= 0 then
      self:CaT1()
      del = 45
  end
  self.UTD1 = del
  self.Lev = self.Lev + 2
  local di1
  local di11
  local srX = self.PlX
  local srY = self.PlY
  for n = 1, #self.Tra1 do
      local tr = self.Tra1[n]
      self:DrT1(srX, srY, tr.TMX, tr.TMY, tr.TaT1, tr.Mod, tr.TaN1)
      if n == 1 then
          self.TrN = tr.TaN1
          di1 = self.TDY
          di11 = self.TrD
      end
      srX = tr.TMX
      srY = tr.TMY
  end
  self.TDY = di1
  self.TrD = di11
end
function Nx.Map:VDP()
  for n = 1, GetNumBattlefieldVehicles() do
      local x, y, unN, pos2, typ, dir, pla = GetBattlefieldVehicleInfo(n)
      if x and not pla then
          local xo = self.PRZX - x * 100
          local yo = (self.PRZY - y * 100) / 1.5
          dir = dir / PI * -180
          xo, yo = xo * cos(dir) + yo * sin(dir), (xo * -sin(dir) + yo * cos(dir)) * 1.5
          Nx.prt("#%s %s %f %f %.3f %s", n, unN or "nil", xo, yo, dir or -1, typ or "no type")
      end
  end
end
function Nx.Map:GRBMI()
  return Nx.MNTI1[GetRealZoneText()] or 9000
end
function Nx.Com:GPQS(nam)
  local inf = self.PaI[nam] or self.ZPI[nam]
  return inf and inf.QSt
end
function Nx.ToB:M_OR(ite)
end
function Nx.Inf:CIF(vaN)
  if not self.Var[vaN] then
      return "", ""
  end
end
function Nx.Map.Gui:CSF()
  local opt = Nx:GGO()
  self.ShF = {}
  local gFo = self:FiF("Gather")
  if Nx.ChO["MapShowGatherH"] then
      local fol = self:FiF("Herb", gFo)
      self:ASF(fol)
  end
  if Nx.ChO["MapShowGatherM"] then
      local fol = self:FiF("Ore", gFo)
      self:ASF(fol)
  end
  if Nx.ChO["QMapShowQuestGivers3"] > 1 then
      local fol = self:FiF("Quest Givers")
      self:ASF(fol)
  end
end
function Nx.Hel:OLE(evN, sel, va2)
  if evN == "select" or evN == "back" then
      self:SetText(sel)
  end
end
function Nx.Fav:AdI1(fav, ind, ite)
  if fav then
      local i = max(min(ind or 999999, #fav), 0) + 1
      tinsert(fav, i, ite)
      self:SeI1(i)
  end
end
function Nx.Que.Lis:M_OSO(ite)
  self.QOp.NXShowObj = ite:GetChecked()
  self:Upd()
end
function Nx:ClS(typ)
  local rn = GetRealmName()
  NxData.NXSocial[rn][typ] = {}
end
function Nx.Map:MUDF(lvl)
  local sc = self.MMFS
  local arr = sc
  local msc = min(1 / sc, 1) * .5
  if Nx.IBG then
      arr = .001
  end
  local mmp = Nx.Map.MPM
  for n, f in ipairs(self.MMM) do
      if f:IsShown() then
          f:SetFrameLevel(lvl)
          local nam = f:GetModel()
          if nam == "interface\\minimap\\ping\\minimapping.m2" then
              f:SetScale(sc)
              f:SetModelScale(msc)
              f:SetAlpha(1)
          elseif f == mmp then
              if self.MMZT == 0 then
                  f:SetScale(max(.4, min(.9, sc)) * self.GOp["MapPlyrArrowSize"] / 28)
                  f:SetModelScale(1)
              else
                  f:SetScale(.1)
                  f:SetModelScale(1)
              end
          else
              f:SetScale(arr)
              f:SetModelScale(msc)
          end
      end
  end
  for f, v in pairs(self.MMAF) do
      f:SetFrameLevel(lvl)
  end
end
function Nx.Map:GCMI()
    local con1 = GetCurrentMapContinent()
    local zon = GetCurrentMapZone()
    if con1 <= 0 or con1 > 4 then
        if con1 == -1 and (self.MaI or 0) > 11000 then
            return self.MaI
        end
        return self:GRMI()
    end
    local maI = self.CZ2I[con1][zon] or 9000
    if maI == Nx.MNTI1[GetRealZoneText()] then
        return self:GRMI()
    end
    return maI
end

function Nx.Que:WaA()
  local cur1 = self.CuQ
  if cur1 then
      for i, cur in ipairs(cur1) do
          self.Wat:Add(i)
      end
  end
end
function Nx.Map:M_OCG(ite)
  self:ClT1()
  self.Gui:ClA()
end
function Nx.Inf:EdC(ind)
  self.Ind = ind
  self.Dat = NxData.NXInfo[ind]
  if self.Win1 then
      self.Win1:Show()
      return
  end
  local win = Nx.Win:Cre("NxInfoEdit", 50, 20, nil, 1)
  self.Win1 = win
  win.Frm.NxI = self
  win:CrB(true, true)
  win:STLH(18)
  win:ILD(nil, -.3, -.2, -.5, -.6)
  win.Frm:SetToplevel(true)
  local bw, bh = win:GBS()
  Nx.Lis:SCF1("FontM", 16)
  local lis = Nx.Lis:Cre(false, 0, 0, 1, 1, win.Frm, false, true)
  self.Lis = lis
  lis:SeU(self, self.EOLE)
  lis:SLH(0, 0)
  lis:CoA("", 1, 900)
  win:Att(lis.Frm, 0, 1, 0, 1)
  self:Upd()
  self.Lis:FuU()
end
function Nx.Ski:Set(skN, ini)
  self.Dat = Nx.Ski1[skN or ""]
  if not self.Dat then
      skN = "ToolBlue"
      self.Dat = Nx.Ski1[skN]
  end
  self.GOp["SkinName"] = skN
  local dat = self.Dat
  self.Pat = "Interface\\Addons\\Carbonite\\Gfx\\Skin\\" .. dat["Folder"]
  if not ini then
      self.GOp["SkinWinBdColor"] = dat["BdCol"]
      self.GOp["SkinWinFixedBgColor"] = 0x80808080
      self.GOp["SkinWinSizedBgColor"] = dat["BgCol"]
  end
  self:Upd()
end
function Nx.Com:SeC(num, msg)
  local dat = {}
  dat.ChN1 = num
  dat.Msg = msg
  tinsert(self.SCQ, dat)
end
function Nx.Map:BTWM()
  if WorldMapFrame:IsShown() then
      HideUIPanel(WorldMapFrame)
  else
      local map = self:GeM(1)
      map:DWM()
      ShowUIPanel(WorldMapFrame)
  end
end
function Nx.Map.Gui:OMU1()
  if Nx.Fre then
      return
  end
  local typ = self.FiC1
  if typ then
      local t, fol = self.Map:GTI()
      if t == "Guide" and type(fol) == "table" then
          local npI, maI, x, y = self:FiC2(typ)
          if npI then
              self.Map:SeT3("Guide", x, y, x, y, false, fol, fol.Nam, false, maI)
          end
      end
  end
end
function Nx.Win:SeP1(x, y)
  local f = self.Frm
  f:ClearAllPoints()
  f:SetPoint("TOPLEFT", x, y)
  self:RLD()
end
function Nx.UEv:AdD(nam)
  local maI, x, y = self:GPP()
  Nx:ADE(nam, Nx:Tim1(), maI, x, y)
  self:UpA()
  if Nx.Map:IBGM(maI) then
      RequestBattlefieldScoreData()
  end
end
function Nx.Map:M_ODZS(ite)
  self.DZS = ite:GeS1()
end
function Nx.Opt.EFA(str, ite)
  local self = Nx.Opt
  local i = tonumber(str)
  if i then
      self:SeV(ite.V, i)
      self:Upd()
      if ite.VF then
          local var = self:GeV(ite.V)
          self[ite.VF](self, ite, var)
      end
  end
end
function Nx.Tim:IsA(nam)
  return self.Dat[nam]
end
function Nx.Que.Wat:M_OSQ()
  ShowUIPanel(QuestLogFrame)
  Nx.Que.Lis.Bar:Sel1(1)
  Nx.Que.Lis:Sel1(self.MQI, self.MQI1)
end
function Nx.War.OB_1()
  local self = Nx.War
  if self.Ena then
      self.BaO = true
      self:CaU()
  end
end
function Nx.Map.Gui:UpL1(lis, paI1, liS)
  lis:Emp()
  local cuF = self.PaH[paI1]
  if cuF then
      local fiS = strlower(self.EdB:GetText())
      if liS == 1 then
          fiS = ""
      end
      if cuF.Ite then
          self:IUF(cuF)
      end
      for ind, fol in ipairs(cuF) do
          if type(fol) == "number" then
              local id = fol
              Nx.Ite:Loa1(id)
              local nam, iLi, iRa, lvl, miL, type, suT, stC, eqL, tx = GetItemInfo(id)
              local show = true
              if fiS ~= "" then
                  local lst = strlower(format("%s", nam))
                  show = strfind(lst, fiS, 1, true)
              end
              if show then
                  if not nam then
                      nam = id .. "?"
                      tx = "Interface\\Icons\\INV_Misc_QuestionMark"
                  else
                      nam = strsub(iLi, 1, 10) .. nam
                  end
                  lis:ItA(ind)
                  lis:ItS(2, format("%s", nam))
                  local tip = iLi and format("!%s", iLi) or fol.Tip
                  lis:ISB("Guide", false, tx, tip)
              end
          else
              local add = true
              if fol.T then
                  add = self:CaT2(fol)
              end
              if add then
                  local nam = fol.Nam
                  if strbyte(nam) == 64 then
                      nam = Nx.GuA[strsub(nam, 2)]
                  end
                  local show = true
                  local co4
                  if fiS ~= "" then
                      local ft = fol.FiT1
                      local lst = strlower(ft or nam)
                      show = strfind(lst, fiS, 1, true)
                      if show and ft then
                          for n = show, 10, -1 do
                              if strbyte(ft, n) == 10 or n == 10 then
                                  local ftE = strfind(ft, "\n", n + 1, true)
                                  co4 = strsub(ft, n + 1, ftE)
                                  break
                              end
                          end
                      end
                  end
                  if show then
                      local col2 = "|cffdfdfdf"
                      if fol[1] or fol.Ite then
                          col2 = "|cff8fdf8f"
                          nam = nam .. "  |cffbf6f6f>>"
                      end
                      lis:ItA(ind)
                      lis:ItS(2, format("%s%s", col2, nam))
                      if liS == 2 then
                          if fol.Co21 then
                              lis:ItS(3, fol.Co21)
                          end
                          if fol.Co3 then
                              lis:ItS(4, fol.Co3)
                          end
                          if co4 then
                              lis:ItS(5, co4)
                          end
                          if fol.Co4 then
                              lis:ItS(5, fol.Co4)
                          end
                      end
                      local pre1 = self:ISF2(fol)
                      local tx = fol.Tx
                      if not tx then
                          for n = #self.PaH, 1, -1 do
                              local fol = self.PaH[n]
                              tx = fol.Tx
                              if tx then
                                  break
                              end
                          end
                      end
                      tx = "Interface\\Icons\\" .. tx
                      local tip = fol.Lin and format("!%s^%s", fol.Lin, fol.Tip or "") or fol.Tip
                      lis:ISB("Guide", pre1, tx, tip)
                  end
              end
          end
      end
  end
  lis:Upd()
end
function Nx.Ite:DrT()
  if next(self.Nee) then
      Nx.prt(" %d items retrieved", self.ItR)
  else
      Nx.prt("Item retrieval from server complete")
  end
  Nx.War:Upd()
  local g = Nx.Map:GeM(1).Gui
  g:UVV()
  g:Upd()
end
function Nx.Com:OC__1(eve)
  local self = Nx.Com
  if strsub(arg1, 1, 3) == self.Nam then
      local nam = arg4
      if nam ~= self.PlN then
          local dat = {strsplit("\t", arg2)}
          for k, msg in ipairs(dat) do
              local id = strbyte(msg)
              if id == 83 then
                  if self.PaN[nam] ~= nil then
                      if #msg >= 16 then
                          local pal = self.PaI[nam]
                          if not pal then
                              pal = {}
                              self.PaI[nam] = pal
                          end
                          self:PPS(nam, pal, msg)
                      end
                  end
              elseif id == 76 then
                  local opt = Nx:GGO()
                  if opt["InfoLvlUpShow"] then
                      local s = format("%s reached level %d!", nam, strbyte(msg, 2) - 35)
                      Nx.prt(s)
                      Nx.UEv:AdI(s)
                  end
              elseif id == 81 then
                  Nx.Que:OMQ(nam, msg)
              elseif id == 86 then
                  self:OMV(nam, msg)
              end
          end
      end
  elseif arg1 == "LGP" then
      local nam = arg4
      if nam ~= self.PlN then
          if self.PaN[nam] ~= nil then
              self:PLGP(nam, arg2)
          end
      end
  end
end
function Nx.Lis:CHT(x)
  local coX = 0
  for id, col3 in ipairs(self.Col) do
      if x >= coX and x < coX + col3.Wid then
          return id, col3
      end
      coX = coX + col3.Wid
  end
end
function Nx.Inf:New()
  local din = NxData.NXInfo
  for n = 1, 10 do
      if not din[n] then
          self:Cre(n)
          self.Inf1[n].Win1:ReL1()
          break
      end
  end
  self:OpU()
end
function Nx.Soc.Lis:SPF(per1, fri)
  self:ClF2(fri)
  local pal = Nx:GeS("Pal")
  local fri1 = pal[per1] or {}
  pal[per1] = fri1
  fri1[fri] = ""
end
function Nx.Que.Lis:M_OSAQ(ite)
  self.SAQ = ite:GetChecked()
  self:Upd()
end
function Nx.Map:BGM_S(msg)
  local id, tx, ty, str = strsplit("~", self.BGM)
  tx, ty = self:GWP(self.RMI, tonumber(tx), tonumber(ty))
  local mem = MAX_PARTY_MEMBERS
  local unN = "party"
  if GetNumRaidMembers() > 0 then
      mem = MAX_RAID_MEMBERS
      unN = "raid"
  end
  local cnt = 0
  local maD = (100 / 4.575) ^ 2
  for i = 1, mem do
      local uni = unN .. i
      local pX, pY = GetPlayerMapPosition(uni)
      if (pX > 0 or pY > 0) and not UnitIsDeadOrGhost(uni) then
          local x, y = self:GWP(self.RMI, pX * 100, pY * 100)
          local dis = (tx - x) ^ 2 + (ty - y) ^ 2
          if dis <= maD then
              cnt = cnt + 1
          end
      end
  end
  local dst1 = ", No "
  if cnt > 0 then
      dst1 = format(", %d ", cnt)
  end
  dst1 = dst1 .. Nx.Map.PFS .. " in area"
  if msg then
      SendChatMessage(msg .. " - " .. str .. dst1, "BATTLEGROUND")
  else
      SendChatMessage(str .. dst1, "BATTLEGROUND")
  end
end
function Nx.EdB.OEP()
  this:ClearFocus()
end
function Nx.Que.OC____1()
  if arg1 then
      if GetMinimapZoneText() == "Heb'Valok" then
          local self = Nx.Que
          local nam = gsub(arg1, "!", "")
          local dat = self.AAD[nam]
          if dat then
              local she, ite, x, y = strsplit("~", dat)
              x = tonumber(x) * .01
              y = tonumber(y) * .01
              local s = format("%s on %s in %s", nam, she, ite)
              if tonumber(she) then
                  s = format("%s, shelf %s, item %s", nam, she, ite)
              end
              self.Map:STXY(4011, x, y, s)
          end
      end
  end
end
function Nx.Soc:CaP()
  local pun = self.Pun
  local puA = self.PuA
  local tm = GetTime() - (Nx.IBG and 30 or 90)
  for pNa, pun1 in pairs(puA) do
      if pun[pNa] then
          if tm - 240 > pun1.Tim1 then
              puA[pNa] = nil
              self.PHUD:Rem(pNa)
          end
      else
          if tm > pun1.Tim1 then
              puA[pNa] = nil
              self.PHUD:Rem(pNa)
          end
      end
  end
end
function Nx.Fav:M_OAF1(ite)
  local function fun(str, self)
      self:AdF2(str, self.CuF1)
      self:Upd()
  end
  Nx:SEB("Name", "", self, fun)
end
function Nx.Map:MoC1()
  if self.CuO.NXWorldShow then
      for coN = 1, Nx.Map.CoC do
          local lvl = coN ~= 4 and self.Lev or self.Lev + 1
          self:MZT(coN, 0, self.CoF[coN], self.WoA, lvl)
      end
      local f = self.CFF
      if f then
          if Nx.V30 then
              self:CFTL(f, 1600, -1600, 1500, 4400, 0)
          else
              self:CFTL(f, 1600, -1900, 1500, 4650, 0)
          end
          f:SetFrameLevel(self.Lev + 1)
          f:SetAlpha(self.WoA)
      end
      self.Lev = self.Lev + 2
  else
      local frm1, frm
      for coN = 1, Nx.Map.CoC do
          frm1 = self.CoF[coN]
          for i = 1, NUM_WORLDMAP_DETAIL_TILES do
              frm = frm1[i]
              if frm then
                  frm:Hide()
              end
          end
      end
      if self.CFF then
          self.CFF:Hide()
      end
  end
end
function Nx.Opt:ECHA(nam)
  local ite = self.CuI
  self:SeV(ite.V, nam)
  self:Upd()
  if ite.VF then
      local var = self:GeV(ite.V)
      self[ite.VF](self, ite, var)
  end
end
function Nx:ADDON_LOADED(eve, ...)
  if arg1 == NXTITLELOW then
      local fac = UnitFactionGroup("player")
      Nx.PFN = strsub(fac, 1, 1) == "A" and 0 or 1
      Nx.AiT = Nx.PFN == 0 and "Airship Alliance" or "Airship Horde"
      Nx:InG()
      local opt = Nx:GGO()
      Nx:pSCF()
      if not opt["LoginHideVer"] then
          Nx.prt(NXTITLE .. " |cffffffff" .. Nx.VERSION .. " B" .. Nx.BUILD .. " " .. NXLOADING)
      end
      Nx:LoI()
      Nx:InE()
      Nx.Pro:Ini()
      Nx.Opt:Ini()
      Nx:UII()
      Nx.Ite:Ini()
      Nx.Hel:Ini()
      Nx.Tit:Ini()
      Nx.NXMiniMapBut:Ini()
      Nx.Com:Ini()
      Nx.HUD:Ini()
      Nx.Map:Ini()
      Nx:GaI()
      Nx.Map:Ope()
      Nx.Fav:Ini()
      Nx.Tra:Ini()
      Nx.Inf:Ini()
      Nx.Que:Ini()
      Nx.War:Ini()
      Nx.Soc:Ini()
      Nx.Com1:Ini()
      Nx.Com1:Ope()
      Nx.UEv:Ini()
      Nx.UEv.Lis:Ope()
      hooksecurefunc("ShowUIPanel", Nx.ShowUIPanel)
      hooksecurefunc("HideUIPanel", Nx.HideUIPanel)
      hooksecurefunc("CloseWindows", Nx.CloseWindows)
      if not opt["LoginHideVer"] then
          Nx.prt(NXLOAD_DONE)
      end
      Nx.Loa = true
  end
  if Nx.Fon.AdL then
      Nx.Fon:AdL()
  end
end
function Nx.Ski:GBC()
  return self.BdC
end
function Nx.Fav:IM_OR()
  local function fun(str, self)
      if self.CFOF then
          self:SIN(self.CII, str)
          self:Upd()
      end
  end
  local typ, nam = self:GITN(self.CII)
  Nx:SEB("Name", nam, self, fun)
end
function Nx.Map:DWM()
  local f = self.WMF
  if f then
      self.WMF = nil
      f:SetParent(self.WMFP)
      f:SetScale(self.WMFS)
      f:SetPoint("TOPLEFT", "WorldMapDetailFrame", "TOPLEFT", 0, 0)
      f:EnableMouse(true)
      self:SWMI(1)
      local tip1 = getglobal("WorldMapTooltip")
      if tip1 then
          tip1:SetParent(self.WMFP)
          tip1:SetFrameStrata("TOOLTIP")
      end
      local af = getglobal("WorldMapFrameAreaFrame")
      if af then
          af:Show()
      end
  end
end
function Nx.Que:LiC(qId)
  local box = ChatEdit_ChooseBoxForSend()
  ChatEdit_ActivateChat(box)
  if box then
      local s = self.Lis:MDL(nil, qId, IsControlKeyDown())
      if s then
          box:Insert(s)
      end
  else
      Nx.prt("|cffff4040No edit box open!")
  end
end
function Nx.Inf:CMC()
  local i = self.Var["Mana"] - self.MaL
  self.MaL = self.Var["Mana"]
  if i == 0 then
      i = self.MLV
      if i > 0 then
          return "|cff205f20", format("+%d", i)
      end
      return "|cff5f2020", format("%d", i)
  else
      self.MLV = i
      if i > 0 then
          return "|cff20ff20", format("+%d", i)
      end
      return "|cffff2020", format("%d", i)
  end
end
function Nx.Map:GeF4()
  local t = {}
  for nam in pairs(self.Fun1) do
      tinsert(t, nam)
  end
  sort(t)
  return t
end
function Nx.NXMiniMapBut:Mov(x, y)
  local but1 = NXMiniMapBut
  local mm = getglobal("Minimap")
  local l = mm:GetLeft() + 70
  local b = mm:GetBottom() + 70
  x = x - l
  y = y - b
  local ang = atan2(y, x)
  local r = (x ^ 2 + y ^ 2) ^ .5
  r = max(r, 79)
  r = min(r, 110)
  x = r * cos(ang)
  y = r * sin(ang)
  but1:SetPoint("TOPLEFT", mm, "TOPLEFT", x + 54, y - 54)
  but1:SetUserPlaced(true)
end
function Nx.Sec:OlM()
  local nam = "ILQUD"
  NxData.NXGOpts[nam] = nil
  local s = "\n|cffff4040This version is pretty old.\n|rVisit |cff40ff40" .. Nx.WeS ..
                "|r and check for a newer version."
  Nx.prt(s)
end
function Nx.Opt:NXCmdFavCartImport()
  Nx.Fav:CIN()
end

function Nx.Que:MNIDB(typ)
  if typ == "O" then
      UIErrorsFrame:AddMessage("This objective is not in the database", 1, 0, 0, 1)
  elseif typ == "Z" then
      UIErrorsFrame:AddMessage("This objective zone is not in the database", 1, 0, 0, 1)
  else
      UIErrorsFrame:AddMessage("This quest is not in the database", 1, 0, 0, 1)
  end
end
function Nx.UEv:AdI(nam)
  local maI, x, y = self:GPP()
  Nx:AIE(nam, Nx:Tim1(), maI, x, y)
  self:UpA()
  return maI
end
