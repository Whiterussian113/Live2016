--Raptor's Intercept Form
function c511009079.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--swap
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(67547370,1))
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c511009079.atkcon)
	e5:SetOperation(c511009079.atkop)
	c:RegisterEffect(e5)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11819616,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c511009079.discon)
	e2:SetTarget(c511009079.distg)
	e2:SetOperation(c511009079.disop)
	c:RegisterEffect(e2)
end
function c511009079.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d and a and d:IsFaceup() and d:IsSetCard(0xba) and d:IsRelateToBattle() and bit.band(d:GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ 
		and not e:GetHandler():IsStatus(STATUS_CHAINING) and d:IsControler(tp)
end
function c511009079.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not e:GetHandler():IsRelateToEffect(e) or not a or not d or not d:IsRelateToBattle() or d:IsFacedown() then return end
	local atk=d:GetAttack()
	local def=d:GetDefense()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SWAP_ATTACK_FINAL)
	e1:SetValue(def)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
	d:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SWAP_DEFENSE_FINAL)
	e2:SetValue(atk)
	d:RegisterEffect(e2)
end
function c511009079.filter(c,tp)
	return c:IsFaceup() and bit.band(c:GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and c:IsSetCard(0xba) 
		and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c511009079.discon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c511009079.filter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function c511009079.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c511009079.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
