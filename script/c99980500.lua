--HN MAGES.
--Scripted by Raivost
function c99980500.initial_effect(c)
  aux.EnablePendulumAttribute(c)
  --Pendulum Effcts
  --(1) Destroy replace
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_DESTROY_REPLACE)
  e1:SetRange(LOCATION_PZONE)
  e1:SetTarget(c99980500.dreptg)
  e1:SetValue(c99980500.drepval)
  e1:SetOperation(c99980500.drepop)
  c:RegisterEffect(e1)
  --(2) Inflict damage
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_DAMAGE)
  e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetProperty(EFFECT_FLAG_DELAY)
  e2:SetRange(LOCATION_PZONE)
  e2:SetCondition(c99980500.damcon)
  e2:SetOperation(c99980500.damop)
  c:RegisterEffect(e2)
  --Monster Effects
  --(1) Unsaffected by S/T
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE)
  e3:SetCode(EFFECT_IMMUNE_EFFECT)
  e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e3:SetRange(LOCATION_MZONE)
  e3:SetValue(c99980500.unfilter)
  c:RegisterEffect(e3)
  --(2) Special Summon
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(99980500,0))
  e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e4:SetType(EFFECT_TYPE_IGNITION)
  e4:SetRange(LOCATION_MZONE)
  e4:SetCountLimit(1,99980500)
  e4:SetCondition(c99980500.spcon)
  e4:SetTarget(c99980500.sptg)
  e4:SetOperation(c99980500.spop)
  c:RegisterEffect(e4)
  if not c99980500.global_check then
    c99980500.global_check=true
    local ge1=Effect.CreateEffect(c)
    ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    ge1:SetCode(EVENT_SUMMON_SUCCESS)
    ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    ge1:SetLabel(99980500)
    ge1:SetOperation(aux.sumreg)
    Duel.RegisterEffect(ge1,0)
    local ge2=ge1:Clone()
    ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
    ge2:SetLabel(99980500)
    Duel.RegisterEffect(ge2,0)
  end
end
--(1) Destroy replace
function c99980500.drepfilter(c,tp)
  return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
    and c:IsSetCard(0x998) and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp
end
function c99980500.dreptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return eg:IsExists(c99980500.drepfilter,1,nil,tp) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED) end
  return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c99980500.drepval(e,c)
  return c99980500.drepfilter(c,e:GetHandlerPlayer())
end
function c99980500.drepop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
--(2) Inflict damage
function c99980500.damconfilter(c,tp)
  return c:IsFaceup() and c:IsSetCard(0x998) and c:GetSummonPlayer()==tp
end
function c99980500.damcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(c99980500.damconfilter,1,nil,tp)
end
function c99980500.damop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_CARD,0,99980500)
  Duel.Damage(1-tp,300,REASON_EFFECT)
end
--Monster Effects
--(1) Unsaffected by S/T
function c99980500.unfilter(e,te)
  return te:IsActiveType(TYPE_TRAP+TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--(2) Special Summon
function c99980500.spcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetFlagEffect(99980500)>0
end
function c99980500.spfilter(c,e,tp)
  return c:IsSetCard(0x998) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99980500.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c99980500.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c99980500.damfilter(c)
  return c:IsFaceup() and c:IsSetCard(0x998)
end
function c99980500.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c99980500.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
  if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
    local sg=Duel.GetMatchingGroup(c99980500.damfilter,tp,LOCATION_MZONE,0,nil)
    Duel.Damage(1-tp,sg:GetCount()*300,REASON_EFFECT)
  end
end