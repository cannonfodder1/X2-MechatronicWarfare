class X2Effect_Triangulation extends X2Effect_Persistent;

var name Triangulation_TriggeredName;

function bool ChangeHitResultForTarget(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Defender, XComGameState_Ability AbilityState, bool bIsPrimaryTarget, const EAbilityHitResult CurrentResult, out EAbilityHitResult NewHitResult)
{
	local XComGameState		NewGameState;

	`log("TRIANGULATION FUNCTION CALLED");
	if (Defender.ControllingPlayer != Attacker.ControllingPlayer)
	{
		NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Triangulation: Apply Effect");
    
        `XEVENTMGR.TriggerEvent(default.Triangulation_TriggeredName, Attacker, Defender, NewGameState);
        `log("TRIGGERED TRIANGULATION EVENT");

        `GAMERULES.SubmitGameState(NewGameState);
	}
	return false;
}

DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
	EffectName = "Triangulation"
	Triangulation_TriggeredName = "Triangulation_Triggered"
}

/*

static function X2AbilityTemplate Triangulation()
{
	local X2AbilityTemplate			Template;
	local X2Effect_Triangulation	Effect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'Triangulation');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_MW.UIPerk_triangulation";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
    Effect = new class'X2Effect_Triangulation';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.EffectName = 'Triangulation';
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.AdditionalAbilities.AddItem('TriangulationTrigger');

	return Template;
}

static function X2AbilityTemplate TriangulationTrigger()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTrigger_EventListener		EventListener;
	local X2Condition_UnitEffects				Condition;
	local X2Effect_HoloTarget					Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TriangulationTrigger');
	Template.IconImage = "img:///UILibrary_MW.UIPerk_triangulation";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.bShowActivation = true;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.bCrossClassEligible = false;
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Condition = new class'X2Condition_UnitEffects';
	Condition.AddExcludeEffect(class'X2AbilityTemplateManager'.default.StunnedName, 'AA_UnitIsStunned');
	Template.AbilityShooterConditions.AddItem(Condition);

	// trigger on taking damage
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = class'X2Effect_Triangulation'.default.Triangulation_TriggeredName;
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = class'XComGameState_Ability'.static.VoidRiftInsanityListener;
	Template.AbilityTriggers.AddItem(EventListener);

	// build the aim buff
    Effect = new class'X2Effect_HoloTarget';
	Effect.HitMod = default.TRIANGULATION_HITMOD;
	Effect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnEnd);
	Effect.SetDisplayInfo(ePerkBuff_Penalty, "Triangulated", "All enemies of this unit gain extra Aim when firing at it.", "img:///UILibrary_PerkIcons.UIPerk_holotargeting", true);
	Effect.bRemoveWhenTargetDies = true;
	Effect.bUseSourcePlayerState = true;
	Template.AddTargetEffect(Effect);

	Template.CustomFireAnim = 'NO_Intimidate';
	Template.bShowActivation = true;
	Template.CinescriptCameraType = "Spark_Intimidate";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

*/