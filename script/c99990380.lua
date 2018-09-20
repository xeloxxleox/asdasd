--SAO Kobold Sentinels
--Scripted by Raivost
function c99990380.initial_effect(c)
  --(1) Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(99990380,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,99990380+EFFECT_COUNT_CODE_OATH)
  e1:SetTarget(c99990380.target)
  e1:SetOperation(c99990380.activate)
  c:RegisterEffect(e1)
end
--(1) Special Summon
function c99990380.target(e,tp,eg,ep,ev,re,r,rp,chk)
  local ct=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
  if chk==0 then
    if e:GetLabel()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return false end
    e:SetLabel(0)
    return ct>0 and (ct==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133)) 
    and Duel.IsPlayerCanSpecialSummonMonster(tp,99990135,0x9999,0x4011,1000,1000,4,RACE_BEASTWARRIOR,ATTRIBUTE_DARK)
  end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,0,0)
end
function c99990380.activate(e,tp,eg,ep,ev,re,r,rp)
  local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
  local ct=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
  if ft>ct then ft=ct end
  if ft<=0 then return end
  if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
  if not Duel.IsPlayerCanSpecialSummonMonster(tp,99990135,0x9999,0x4011,1000,1000,4,RACE_BEASTWARRIOR,ATTRIBUTE_DARK) then return end
  repeat
    local token=Duel.CreateToken(tp,99990135)
    Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
     --(1.1) Link limit
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e1:SetValue(c99990380.linklimit)
    e1:SetReset(RESET_EVENT+0x1fe0000)
    token:RegisterEffect(e1,true)
    ft=ft-1
  until ft<=0 or not Duel.SelectYesNo(tp,aux.Stringid(99990380,1))
  Duel.SpecialSummonComplete()
end
--(1.1) Link limit
function c99990380.linklimit(e,c)
  if not c then return false end
  return not c:IsSetCard(0x999)
end