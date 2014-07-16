---------------------------------
-- �������
-- by������@˫����@׷����Ӱ
-- ref: �����������Դ�� @haimanchajian.com
---------------------------------
-----------------------------------------------
-- ���غ����ͱ���
-----------------------------------------------
MY = MY or {}
MY.Player = MY.Player or {}
local _Cache, _L = {}, MY.LoadLangPack()
--[[
#######################################################################################################
              #     #       #             # #                         #             #             
  # # # #     #     #         #     # # #         # # # # # #         #             #             
  #     #   #       #               #                 #         #     #     # # # # # # # # #     
  #     #   #   # # # #             #                 #         #     #             #             
  #   #   # #       #     # # #     # # # # # #       # # # #   #     #       # # # # # # #       
  #   #     #       #         #     #     #         #       #   #     #             #             
  #     #   #   #   #         #     #     #       #   #     #   #     #   # # # # # # # # # # #   
  #     #   #     # #         #     #     #             #   #   #     #           #   #           
  #     #   #       #         #     #     #               #     #     #         #     #       #   
  # # #     #       #         #   #       #             #             #       # #       #   #     
  #         #       #       #   #                     #               #   # #   #   #     #       
  #         #     # #     #       # # # # # # #     #             # # #         # #         # #  
#######################################################################################################
]]
_Cache.tNearNpc = {}      -- ������NPC
_Cache.tNearPlayer = {}   -- ��������Ʒ
_Cache.tNearDoodad = {}   -- ���������

--[[ ��ȡ����NPC�б�
    (table) MY.GetNearNpc(void)
]]
MY.Player.GetNearNpc = function(nLimit)
    local tNpc, i = {}, 0
    for dwID, _ in pairs(_Cache.tNearNpc) do
        local npc = GetNpc(dwID)
        if not npc then
            _Cache.tNearNpc[dwID] = nil
        else
            i = i + 1
            tNpc[dwID] = npc
            if nLimit and i == nLimit then break end
        end
    end
    return tNpc, i
end
MY.GetNearNpc = MY.Player.GetNearNpc

--[[ ��ȡ��������б�
    (table) MY.GetNearPlayer(void)
]]
MY.Player.GetNearPlayer = function(nLimit)
    local tPlayer, i = {}, 0
    for dwID, _ in pairs(_Cache.tNearPlayer) do
        local player = GetPlayer(dwID)
        if not player then
            _Cache.tNearPlayer[dwID] = nil
        else
            i = i + 1
            tPlayer[dwID] = player
            if nLimit and i == nLimit then break end
        end
    end
    return tPlayer, i
end
MY.GetNearPlayer = MY.Player.GetNearPlayer

--[[ ��ȡ������Ʒ�б�
    (table) MY.GetNearPlayer(void)
]]
MY.Player.GetNearDoodad = function(nLimit)
    local tDoodad, i = {}, 0
    for dwID, _ in pairs(_Cache.tNearDoodad) do
        local dooded = GetDoodad(dwID)
        if not dooded then
            _Cache.tNearDoodad[dwID] = nil
        else
            i = i + 1
            tDoodad[dwID] = dooded
            if nLimit and i == nLimit then break end
        end
    end
    return tDoodad, i
end
MY.GetNearDoodad = MY.Player.GetNearDoodad

RegisterEvent("NPC_ENTER_SCENE",    function() _Cache.tNearNpc[arg0]    = true end)
RegisterEvent("NPC_LEAVE_SCENE",    function() _Cache.tNearNpc[arg0]    = nil  end)
RegisterEvent("PLAYER_ENTER_SCENE", function() _Cache.tNearPlayer[arg0] = true end)
RegisterEvent("PLAYER_LEAVE_SCENE", function() _Cache.tNearPlayer[arg0] = nil  end)
RegisterEvent("DOODAD_ENTER_SCENE", function() _Cache.tNearDoodad[arg0] = true end)
RegisterEvent("DOODAD_LEAVE_SCENE", function() _Cache.tNearDoodad[arg0] = nil  end)

--[[
#######################################################################################################
                                  #                                                       #                   
  # # # # # # # # # # #         #                               # # # # # # # # #         #     # # # # #     
            #             # # # # # # # # # # #       #         #               #         #                   
          #               #                   #     #   #       #               #     # # # #                 
    # # # # # # # # # #   #                   #     #   #       # # # # # # # # #         #   # # # # # # #   
    #     #     #     #   #     # # # # #     #     # # # #     #               #       # #         #         
    #     # # # #     #   #     #       #     #   #   #   #     #               #       # # #       #         
    #     #     #     #   #     #       #     #   #   #   #     # # # # # # # # #     #   #     #   #   #     
    #     # # # #     #   #     #       #     #   #     #       #               #         #     #   #     #   
    #     #     #     #   #     # # # # #     #     # #   # #   #               #         #   #     #     #   
    # # # # # # # # # #   #                   #                 # # # # # # # # #         #         #         
    #                 #   #               # # #                 #               #         #       # #         
#######################################################################################################
]]
--[[ (KObject) MY.GetTarget()                                                       -- ȡ�õ�ǰĿ���������
-- (KObject) MY.GetTarget([number dwType, ]number dwID) -- ���� dwType ���ͺ� dwID ȡ�ò�������]]
MY.Player.GetTarget = function(dwType, dwID)
    if not dwType then
        local me = GetClientPlayer()
        if me then
            dwType, dwID = me.GetTarget()
        else
            dwType, dwID = TARGET.NO_TARGET, 0
        end
    elseif not dwID then
        dwID, dwType = dwType, TARGET.NPC
        if IsPlayer(dwID) then
            dwType = TARGET.PLAYER
        end
    end
    if dwID <= 0 or dwType == TARGET.NO_TARGET then
        return nil, TARGET.NO_TARGET
    elseif dwType == TARGET.PLAYER then
        return GetPlayer(dwID), TARGET.PLAYER
    elseif dwType == TARGET.DOODAD then
        return GetDoodad(dwID), TARGET.DOODAD
    else
        return GetNpc(dwID), TARGET.NPC
    end
end
MY.GetTarget = MY.Player.GetTarget

--[[ ���� dwType ���ͺ� dwID ����Ŀ��
-- (void) MY.SetTarget([number dwType, ]number dwID)
-- dwType   -- *��ѡ* Ŀ������
-- dwID     -- Ŀ�� ID]]
MY.Player.SetTarget = function(dwType, dwID)
    -- check dwType
    if type(dwType)=="userdata" then
        dwType, dwID = ( IsPlayer(dwType) and TARGET.PLAYER ) or TARGET.NPC, dwType.dwID
    elseif type(dwType)=="string" then
        dwType, dwID = 0, dwType
    end
    -- conv if dwID is string
    if type(dwID)=="string" then
        for _, p in pairs(MY.GetNearNpc()) do
            if p.szName == dwID then
                dwType, dwID = TARGET.NPC, p.dwID
            end
        end
        for _, p in pairs(MY.GetNearPlayer()) do
            if p.szName == dwID then
                dwType, dwID = TARGET.PLAYER, p.dwID
            end
        end
    end
    if not dwType or dwType <= 0 then
        dwType, dwID = TARGET.NO_TARGET, 0
    elseif not dwID then
        dwID, dwType = dwType, TARGET.NPC
        if IsPlayer(dwID) then
            dwType = TARGET.PLAYER
        end
    end
    SetTarget(dwType, dwID)
end
MY.SetTarget = MY.Player.SetTarget

--[[ ��N2��N1�������  --  ����+2
    -- ����N1���ꡢ����N2����
    (number) MY.GetFaceToTargetDegree(nX,nY,nFace,nTX,nTY)
    -- ����N1��N2
    (number) MY.GetFaceToTargetDegree(oN1, oN2)
    -- ���
    nil -- ��������
    number -- �����(0-180)
]]
MY.Player.GetFaceDegree = function(nX,nY,nFace,nTX,nTY)
    if type(nY)=="userdata" and type(nX)=="userdata" then nTX=nY.nX nTY=nY.nY nY=nX.nY nFace=nX.nFaceDirection nX=nX.nX end
    if type(nX)~="number" or type(nY)~="number" or type(nFace)~="number" or type(nTX)~="number" or type(nTY)~="number" then return nil end
    local a = nFace * math.pi / 128
    return math.acos( ( (nTX-nX)*math.cos(a) + (nTY-nY)*math.sin(a) ) / ( (nTX-nX)^2 + (nTY-nY)^2) ^ 0.5 ) * 180 / math.pi
end
--[[ ��oT2��oT1�����滹�Ǳ���
    (bool) MY.IsFaceToTarget(oT1,oT2)
    -- ���淵��true
    -- ���Է���false
    -- ��������ȷʱ����nil
]]
MY.Player.IsFaceToTarget = function(oT1,oT2)
    if type(oT1)~="userdata" or type(oT2)~="userdata" then return nil end
    local a = oT1.nFaceDirection * math.pi / 128
    return (oT2.nX-oT1.nX)*math.cos(a) + (oT2.nY-oT1.nY)*math.sin(a) > 0
end
--[[ װ����ΪszName��װ��
    (void) MY.Equip(szName)
    szName  װ������
]]
MY.Player.Equip = function(szName)
    local me = GetClientPlayer()
    for i=1,6 do
        if me.GetBoxSize(i)>0 then
            for j=0, me.GetBoxSize(i)-1 do
                local item = me.GetItem(i,j)
                if item == nil then
                    j=j+1
                elseif Table_GetItemName(item.nUiId)==szName then -- GetItemNameByItem(item)
                    local eRetCode, nEquipPos = me.GetEquipPos(i, j)
                    if szName==_L["ji guan"] or szName==_L["nu jian"] then
                        for k=0,15 do
                            if me.GetItem(INVENTORY_INDEX.BULLET_PACKAGE, k) == nil then
                                OnExchangeItem(i, j, INVENTORY_INDEX.BULLET_PACKAGE, k)
                                return
                            end
                        end
                        return
                    else
                        OnExchangeItem(i, j, INVENTORY_INDEX.EQUIP, nEquipPos)
                        return
                    end
                end
            end
        end
    end
end
AppendCommand("equip", MY.Player.Equip)

--[[ ��ȡ�����buff�б�
    (table) MY.GetBuffList(obj)
]]
MY.Player.GetBuffList = function(obj)
    obj = obj or GetClientPlayer()
    local aBuffTable = {}
    local nCount = obj.GetBuffCount() or 0
    for i=1,nCount,1 do
        local dwID, nLevel, bCanCancel, nEndFrame, nIndex, nStackNum, dwSkillSrcID, bValid = obj.GetBuff(i - 1)
        if dwID then
            table.insert(aBuffTable,{dwID = dwID, nLevel = nLevel, bCanCancel = bCanCancel, nEndFrame = nEndFrame, nIndex = nIndex, nStackNum = nStackNum, dwSkillSrcID = dwSkillSrcID, bValid = bValid})
        end
    end
    return aBuffTable
end

_Cache.tPlayerSkills = {} -- ��Ҽ����б�[����]
--[[ ͨ���������ƻ�ȡ���ܶ���
    (table) MY.GetSkillByName(szName)
]]
MY.Player.GetSkillByName = function(szName)
    if table.getn(_Cache.tPlayerSkills)==0 then
        for i = 1, g_tTable.Skill:GetRowCount() do
            local tLine = g_tTable.Skill:GetRow(i)
            if tLine~=nil and tLine.dwIconID~=nil and tLine.fSortOrder~=nil and tLine.szName~=nil and tLine.dwIconID~=13 and ( (not _Cache.tPlayerSkills[tLine.szName]) or tLine.fSortOrder>_Cache.tPlayerSkills[tLine.szName].fSortOrder) then
                _Cache.tPlayerSkills[tLine.szName] = tLine
            end
        end
    end
    return _Cache.tPlayerSkills[szName]
end
--[[ �жϼ��������Ƿ���Ч
    (bool) MY.IsValidSkill(szName)
]]
MY.Player.IsValidSkill = function(szName)
    if MY.Player.GetSkillByName(szName)==nil then return false else return true end
end
--[[ �жϵ�ǰ�û��Ƿ����ĳ������
    (bool) MY.CanUseSkill(number dwSkillID[, dwLevel])
]]
MY.Player.CanUseSkill = function(dwSkillID, dwLevel)
    -- �жϼ����Ƿ���Ч ����������ת��Ϊ����ID
    if type(dwSkillID) == "string" then if MY.IsValidSkill(dwSkillID) then dwSkillID = MY.Player.GetSkillByName(dwSkillID).dwSkillID else return false end end
    local me, box = GetClientPlayer(), _Cache.hBox
    if me and box then
        if not dwLevel then
            if dwSkillID ~= 9007 then
                dwLevel = me.GetSkillLevel(dwSkillID)
            else
                dwLevel = 1
            end
        end
        if dwLevel > 0 then
            box:EnableObject(false)
            box:SetObjectCoolDown(1)
            box:SetObject(UI_OBJECT_SKILL, dwSkillID, dwLevel)
            UpdataSkillCDProgress(me, box)
            return box:IsObjectEnable() and not box:IsObjectCoolDown()
        end
    end
    return false
end
--[[ �ͷż���,�ͷųɹ�����true
    (bool)MY.UseSkill(dwSkillID, bForceStopCurrentAction, eTargetType, dwTargetID)
    dwSkillID               ����ID
    bForceStopCurrentAction �Ƿ��ϵ�ǰ�˹�
    eTargetType             �ͷ�Ŀ������
    dwTargetID              �ͷ�Ŀ��ID
]]
MY.Player.UseSkill = function(dwSkillID, bForceStopCurrentAction, eTargetType, dwTargetID)
    -- �жϼ����Ƿ���Ч ����������ת��Ϊ����ID
    if type(dwSkillID) == "string" then if MY.Player.IsValidSkill(dwSkillID) then dwSkillID = MY.Player.GetSkillByName(dwSkillID).dwSkillID else return false end end
    local me = GetClientPlayer()
    -- ��ȡ����CD
    local bCool, nLeft, nTotal = me.GetSkillCDProgress( dwSkillID, me.GetSkillLevel(dwSkillID) ) local bIsPrepare ,dwPreSkillID ,dwPreSkillLevel , fPreProgress= me.GetSkillPrepareState()
    local oTTP, oTID = me.GetTarget()
    if dwTargetID~=nil then SetTarget(eTargetType, dwTargetID) end
    if ( not bCool or nLeft == 0 and nTotal == 0 ) and not ( not bForceStopCurrentAction and dwPreSkillID == dwSkillID ) then
        me.StopCurrentAction() OnAddOnUseSkill( dwSkillID, me.GetSkillLevel(dwSkillID) )
        if dwTargetID then SetTarget(oTTP, oTID) end
        return true
    else
        if dwTargetID then SetTarget(oTTP, oTID) end
        return false
    end
end

--[[ �ǳ���Ϸ
    (void) MY.LogOff(bCompletely)
    bCompletely Ϊtrue���ص�½ҳ Ϊfalse���ؽ�ɫҳ Ĭ��Ϊfalse
]]
MY.Player.LogOff = function(bCompletely)
    if bCompletely then
        ReInitUI(LOAD_LOGIN_REASON.RETURN_GAME_LOGIN)
    else
        ReInitUI(LOAD_LOGIN_REASON.RETURN_ROLE_LIST)
    end
end