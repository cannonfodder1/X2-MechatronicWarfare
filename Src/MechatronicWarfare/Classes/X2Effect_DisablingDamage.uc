class X2Effect_DisablingDamage extends X2Effect_Persistent 
	dependson (XComGameStateContext_Ability);

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)

{
	if (AbilityState.GetMyTemplateName() == 'DisablingBurst')
	{
	`log("DISABLE DAMAGE APPLIED");
	return CurrentDamage * -0.5;
	}
}
