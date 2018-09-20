--SAO Yui
--Scripted by Raivost
function c99990050.initial_effect(c)
  --(1) Special summon from hand
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99990050,0))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetRange(LOCATION_HAND)
  e1:SetCondition(c99990050.hspcon)
  c:RegisterEffect(e1)
  --(2) Draw
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(99990050,1))
  e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
  e2:SetCode(EVENT_BE_MATERIAL)
  e2:SetCountLimit(1,99990050)
  e2:SetCondition(c99990050.drcon)
  e2:SetTarget(c99990050.drtg)
  e2:SetOperation(c99990050.drop)
  c:RegisterEffect(e2)
  --(3) Level 1
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
  e3:SetOperation(c99990050.synop)
  c:RegisterEffect(e3)
end
--(1) Special Summon from hand
function c99990050.hspconfilter(c)
  return c:IsFaceup() and (aux.IsCodeListed(c,99990010) or aux.IsCodeListed(c,99990020))
end
function c99990050.hspcon(e,c)
  if c==nil then return true end
  return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
  Duel.IsExistingMatchingCard(c99990050.hspconfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
--(2) Draw
function c99990050.drcon(e,tp,eg,ep,ev,re,r,rp)
  return r==REASON_SYNCHRO and e:GetHandler():GetReasonCard():IsSetCard(0x999)
end
function c99990050.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return true end
  Duel.SetTargetPlayer(tp)
  Duel.SetTargetParam(1)
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99990050.drop(e,tp,eg,ep,ev,re,r,rp)
  local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
  if Duel.Draw(p,d,REASON_EFFECT)~=0 then
    Duel.BreakEffect()
    if e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsAbleToDeck()
    and not e:GetHandler():IsHasEffect(EFFECT_NECRO_VALLEY) then
      Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
    end
  end
end
--(3) Level 1
function c99990050.synop(e,tg,ntg,sg,lv,sc,tp)
  local res=sg:CheckWithSumEqual(Card.GetSynchroLevel,lv,sg:GetCount(),sg:GetCount(),sc) 
  or sg:CheckWithSumEqual(function() return 1 end,lv,sg:GetCount(),sg:GetCount())
  return res,true
end