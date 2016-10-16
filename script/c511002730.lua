--Hope 1
function c511002730.initial_effect(c)
	--Survive
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(511002521)
	e1:SetCost(c511002730.cost)
	e1:SetOperation(c511002730.activate)
	c:RegisterEffect(e1)
	if not c511002730.global_check then
		c511002730.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_CANNOT_LOSE_LP)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge1:SetTargetRange(1,0)
		ge1:SetCondition(c511002730.con2)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_ADJUST)
		ge3:SetOperation(c511002730.op)
		Duel.RegisterEffect(ge3,0)
	end
end
function c511002730.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,511002521)>0
end
function c511002730.op(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetLP(0)<=0 and ph~=PHASE_DAMAGE then
		Duel.RaiseEvent(Duel.GetMatchingGroup(nil,0,LOCATION_ONFIELD,0,nil),511002521,e,0,0,0,0)
		Duel.ResetFlagEffect(0,511002521)
	end
	if Duel.GetLP(1)<=0 and ph~=PHASE_DAMAGE then
		Duel.RaiseEvent(Duel.GetMatchingGroup(nil,1,LOCATION_ONFIELD,0,nil),511002521,e,0,0,0,0)
		Duel.ResetFlagEffect(1,511002521)
	end
	if Duel.GetLP(0)>0 and Duel.GetFlagEffect(0,511002521)==0 then
		Duel.RegisterFlagEffect(0,511002521,0,0,1)
	end
	if Duel.GetLP(1)>0 and Duel.GetFlagEffect(1,511002521)==0 then
		Duel.RegisterFlagEffect(1,511002521,0,0,1)
	end
end
function c511002730.costfilter(c,e,tp)
	return c:IsSetCard(0x107f) and c:IsAbleToGraveAsCost()
end
function c511002730.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511002730.costfilter,tp,LOCATION_MZONE,0,1,nil) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_CHAIN)
	e1:SetCode(EFFECT_CANNOT_LOSE_LP)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c511002730.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c511002730.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,1,REASON_EFFECT)
end
