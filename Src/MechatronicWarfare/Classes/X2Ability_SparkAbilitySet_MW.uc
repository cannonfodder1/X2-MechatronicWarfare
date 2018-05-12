class X2Ability_SparkAbilitySet_MW extends X2Ability
	dependson(XComGameStateContext_Ability) config(GameData_SoldierSkills);

	var config int MWREPAIR_HEAL;
	var config int UNYIELDING_EXTRAHEAL;

	var config int KS_COOLDOWN;

	var config int CS_COOLDOWN;

	var config int OBLITERATOR_DMG;

	var config int COLLATERAL_COOLDOWN;
	var config int COLLATERAL_AMMO;
	var config int COLLATERAL_RADIUS;
	var config int COLLATERAL_ENVDMG;

	var config int DISABLE_COOLDOWN;
	var config int DISABLE_AMMO;
	var config int DISABLE_HITMOD;
	var config int DISABLE_STUN;

	var config int BOMBARDMENT_COOLDOWN;
	var config int BOMBARDMENT_RADIUS;
	var config int BOMBARDMENT_ENVDMG;

	var config int LS_COOLDOWN;

	var config int TRIANGULATION_HITMOD;

	var config int SUPERNOVA_CHARGES;
	var config int SUPERNOVA_COOLDOWN;
	var config int SUPERNOVA_RADIUS_METERS;
	var config int SUPERNOVA_RADIUS_SQ;
	var config WeaponDamageValue SUPERNOVA_DMG;
	var config int SUPERNOVA_ENVDMG;

	var config int EMERGENTAI_HACK;
	var config int EMERGENTAI_AIM;
	
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(RepairMW());
	Templates.AddItem(RedundantSystems());
	Templates.AddItem(KineticStrike());
	Templates.AddItem(CombinedArms());
	Templates.AddItem(PurePassive('RapidRepair', "img:///UILibrary_MW.UIPerk_rapid_repair"));
	Templates.AddItem(ConcussiveStrike());
	Templates.AddItem(Collateral());
	Templates.AddItem(Unyielding());
	Templates.AddItem(Obliterator());
	Templates.AddItem(DisablingBurst());
	Templates.AddItem(BrawlerProtocol());
	Templates.AddItem(BrawlerTrigger());
	Templates.AddItem(Bombardment());
	Templates.AddItem(IntimidateMW());
	Templates.AddItem(IntimidateTriggerMW());
	Templates.AddItem(Triangulation());
	Templates.AddItem(TriangulationTrigger());
	Templates.AddItem(LightningStrike());
	Templates.AddItem(Supernova());
	Templates.AddItem(SupernovaStun());
	Templates.AddItem(EmergentAI());

	return Templates;
}

static function X2AbilityTemplate RepairMW()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCharges_Repair               Charges;
	local X2AbilityCost_Charges                 ChargeCost;
	local X2AbilityCost_ActionPoints            ActionPointCost;
	local X2Effect_ApplyRepairHeal				HealEffect;
	local X2Effect_RepairArmor					ArmorEffect;
	local X2Condition_UnitProperty              UnitCondition;
	local X2Effect_RemoveEffectsByDamageType	RemoveEffects;
	local name HealType;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RepairMW');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_MW.UIPerk_repair";

	Charges = new class'X2AbilityCharges_Repair';
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('RapidRepair');
	Template.AbilityCosts.AddItem(ActionPointCost);

	HealEffect = new class'X2Effect_ApplyRepairHeal';
	HealEffect.PerUseHP = default.MWREPAIR_HEAL;
	HealEffect.IncreasedHealAbility = 'Unyielding';
	HealEffect.IncreasedPerUseHP = default.UNYIELDING_EXTRAHEAL;
	Template.AddTargetEffect(HealEffect);

	ArmorEffect = new class'X2Effect_RepairArmor';
	Template.AddTargetEffect(ArmorEffect);

	RemoveEffects = new class'X2Effect_RemoveEffectsByDamageType';
	foreach class'X2Ability_DefaultAbilitySet'.default.MedikitHealEffectTypes(HealType)
	{
		RemoveEffects.DamageTypesToRemove.AddItem(HealType);
	}
	Template.AddTargetEffect(RemoveEffects);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeDead = true;
	UnitCondition.ExcludeHostileToSource = true;
	UnitCondition.ExcludeFriendlyToSource = false;
	UnitCondition.ExcludeFullHealth = true;
	UnitCondition.ExcludeOrganic = true;
	Template.AbilityTargetConditions.AddItem(UnitCondition);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.bStationaryWeapon = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.CustomSelfFireAnim = 'NO_Repair';
	Template.bSkipPerkActivationActions = true;

	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	
	Template.CinescriptCameraType = "Spark_SendBit";

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	
	return Template;
}

static function X2AbilityTemplate RedundantSystems()
{
	local X2AbilityTemplate						Template;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RedundantSystems');
	Template.IconImage = "img:///UILibrary_MW.UIPerk_redundant_systems";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.AdditionalAbilities.AddItem('Sustain');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate KineticStrike()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_DLC_3StrikeDamage		WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_Knockback				KnockbackEffect;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'KineticStrike');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;		
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_strike";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.MeleePuckMeshPath = "Materials_DLC3.MovePuck_Strike";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.KS_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bMoveCost = true;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.BuiltInHitMod = 10;
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_DLC_3StrikeDamage';
	WeaponDamageEffect.EnvironmentalDamageAmount = 20;
	Template.AddTargetEffect(WeaponDamageEffect);

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = 1;
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	Template.CustomFireAnim = 'FF_Melee';
	Template.CustomMovingFireAnim = 'MV_Melee';	

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 8;
	KnockbackEffect.bKnockbackDestroysNonFragile = true;
	Template.AddTargetEffect(KnockbackEffect);
	Template.bOverrideMeleeDeath = true;

	// Voice events
	Template.SourceMissSpeech = 'SwordMiss';

	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Spark_Strike";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Strike'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'Strike'

	return Template;
}

static function X2AbilityTemplate CombinedArms()
{
	local X2AbilityTemplate					Template;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'CombinedArms');

	Template.IconImage = "img:///UILibrary_MW.UIPerk_defilade";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.AdditionalAbilities.AddItem('Shredder');
	Template.AdditionalAbilities.AddItem('AdaptiveAim');

	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;		
}

static function X2AbilityTemplate ConcussiveStrike()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_HalfDamage				WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_Knockback				KnockbackEffect;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	local X2Effect_Stunned					StunnedEffect;
	local X2Condition_UnitProperty			TargetProperty;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ConcussiveStrike');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;		
	Template.IconImage = "img:///UILibrary_MW.UIPerk_concussive";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.MeleePuckMeshPath = "Materials_DLC3.MovePuck_Strike";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.CS_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bMoveCost = true;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.BuiltInHitMod = 10;
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeRobotic = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_HalfDamage';
	WeaponDamageEffect.EnvironmentalDamageAmount = 20;
	Template.AddTargetEffect(WeaponDamageEffect);

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = 1;
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	Template.CustomFireAnim = 'FF_Melee';
	Template.CustomMovingFireAnim = 'MV_Melee';	

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 8;
	KnockbackEffect.bKnockbackDestroysNonFragile = true;
	Template.AddTargetEffect(KnockbackEffect);
	Template.bOverrideMeleeDeath = true;

	//Stunning Effect
	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, 100);
	StunnedEffect.MinStatContestResult = 0;
	StunnedEffect.MaxStatContestResult = 0;
	StunnedEffect.bRemoveWhenSourceDies = false;
	Template.AddTargetEffect(StunnedEffect);

	// Voice events
	Template.SourceMissSpeech = 'SwordMiss';

	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Spark_Strike";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Strike'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'Strike'

	return Template;
}

static function X2AbilityTemplate Collateral()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_Ammo					AmmoCost;
	local X2AbilityCooldown						Cooldown;
	local X2AbilityTarget_Cursor				CursorTarget;
	local X2AbilityMultiTarget_Radius			RadiusMultiTarget;
	local X2Effect_CollateralDamage				DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Collateral');

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_MW.UIPerk_collateral";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.bLimitTargetIcons = true;

	Template.AbilityCosts.AddItem(default.WeaponActionTurnEnding);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.COLLATERAL_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.COLLATERAL_AMMO;
	Template.AbilityCosts.AddItem(AmmoCost);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToWeaponRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	// Slightly modified from Rocket Launcher template to let it get over blocking cover better
	Template.TargetingMethod = class'X2TargetingMethod_Collateral';
		
	// Give it a radius multi-target
	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = `UNITSTOMETERS(default.COLLATERAL_RADIUS);
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	DamageEffect = new class'X2Effect_CollateralDamage';
	DamageEffect.BONUS_MULT = 0.5;
	DamageEffect.MIN_BONUS = 1;
	DamageEffect.EnvironmentalDamageAmount = default.COLLATERAL_ENVDMG;
	DamageEffect.AllowArmor = true;
	DamageEffect.AddBonus = true;
	Template.AddMultiTargetEffect(DamageEffect);
	
	Template.bOverrideVisualResult = true;
	Template.OverrideVisualResult = eHit_Miss;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Demolition'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'Demolition'

	return Template;
}

static function X2AbilityTemplate Unyielding()
{
	local X2AbilityTemplate					Template;
	local X2Effect_Unyielding				CritModifier;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Unyielding');

	Template.IconImage = "img:///UILibrary_MW.UIPerk_unyielding";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	CritModifier = new class 'X2Effect_Unyielding';
	CritModifier.CritDef_Bonus = 100;
	CritModifier.BuildPersistentEffect (1, true, false, true);
	CritModifier.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect (CritModifier);

	Template.bCrossClassEligible = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;		
}

static function X2AbilityTemplate Obliterator()
{
	local X2AbilityTemplate						Template;
	local X2Effect_BonusWeaponDamage            DamageEffect;
	local X2Effect_ToHitModifier                HitModEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Obliterator');
	Template.IconImage = "img:///UILibrary_MW.UIPerk_obliterator";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'X2Effect_BonusWeaponDamage';
	DamageEffect.BonusDmg = default.OBLITERATOR_DMG;
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.EffectName = 'Obliterator';
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,,Template.AbilitySourceName);
	Template.AddTargetEffect(DamageEffect);

	HitModEffect = new class'X2Effect_ToHitModifier';
	HitModEffect.AddEffectHitModifier(eHit_Success, 20, Template.LocFriendlyName, , true, false, true, true);
	HitModEffect.BuildPersistentEffect(1, true, false, false);
	HitModEffect.EffectName = 'ObliteratorAim';
	Template.AddTargetEffect(HitModEffect);

	Template.AdditionalAbilities.AddItem('WreckingBall');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate DisablingBurst()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_DisableWeapon			DisableEffect;
	local X2Condition_Visibility			VisibilityCondition;
	local X2Effect_Stunned					StunnedEffect;
	local X2Effect_CollateralDamage	        DamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'DisablingBurst');

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_MW.UIPerk_disable";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	//Template.AdditionalAbilities.AddItem('DisablingDamage');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.DISABLE_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.DISABLE_AMMO;
	Template.AbilityCosts.AddItem(AmmoCost);

	DisableEffect = new class'X2Effect_DisableWeapon';
	DisableEffect.ApplyChance = 100;
	Template.AddTargetEffect(DisableEffect);

	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(default.DISABLE_STUN, 100);	
	Template.AddTargetEffect(StunnedEffect);

	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.BuiltInHitMod = default.DISABLE_HITMOD;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	DamageEffect = new class'X2Effect_CollateralDamage';
	DamageEffect.BONUS_MULT = 0.4;
	DamageEffect.MIN_BONUS = 1;
	DamageEffect.EnvironmentalDamageAmount = 5;
	DamageEffect.AllowArmor = true;
	DamageEffect.AddBonus = true;
	Template.AddTargetEffect(DamageEffect);

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	Template.AddTargetEffect(class'X2Ability'.default.WeaponUpgradeMissDamage);
	Template.bAllowAmmoEffects = true;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.CinescriptCameraType = "StandardGunFiring";

	Template.bCrossClassEligible = true;

	return Template;
}

static function X2AbilityTemplate BrawlerProtocol()
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive('BrawlerProtocol', "img:///UILibrary_MW.UIPerk_counterstrike", false, 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('BrawlerTrigger');

	return Template;
}

static function X2AbilityTemplate BrawlerTrigger()
{
	local X2AbilityTemplate							Template;
	local X2AbilityToHitCalc_StandardMelee			ToHitCalc;
	local X2AbilityTrigger_Event					Trigger;
	local X2Effect_Persistent						BrawlerTargetEffect;
	local X2Condition_UnitEffectsWithAbilitySource	BrawlerTargetCondition;
	local X2AbilityTrigger_EventListener			EventListener;
	local X2Condition_UnitProperty					SourceNotConcealedCondition;
	local X2Condition_Visibility					TargetVisibilityCondition;
	local X2Effect_HalfDamage						DamageEffect;
	local X2Condition_PunchRange					RangeCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'BrawlerTrigger');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_MW.UIPerk_counterstrike";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;

	ToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
	ToHitCalc.bReactionFire = true;
	ToHitCalc.BuiltInHitMod = 10;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;

	// trigger on movement
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);
	// trigger on movement in the postbuild
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
	Trigger.MethodName = 'PostBuildGameState';
	Template.AbilityTriggers.AddItem(Trigger);
	// trigger on an attack
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_AttackObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);

	// it may be the case that enemy movement caused a concealment break, which made Brawler applicable - attempt to trigger afterwards
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitConcealmentBroken';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = BrawlerConcealmentListener;
	EventListener.ListenerData.Priority = 55;
	Template.AbilityTriggers.AddItem(EventListener);
	
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bRequireBasicVisibility = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true; //Don't use peek tiles for overwatch shots	
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

	//Ensure the attack only triggers in melee range
	RangeCondition = new class'X2Condition_PunchRange';
	Template.AbilityTargetConditions.AddItem(RangeCondition);

	//Ensure the caster isn't dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);	
	Template.AddShooterEffectExclusions();

	// Don't trigger when the source is concealed
	SourceNotConcealedCondition = new class'X2Condition_UnitProperty';
	SourceNotConcealedCondition.ExcludeConcealed = true;
	SourceNotConcealedCondition.RequireWithinRange = true;

	// Require that the target is next to the source
	SourceNotConcealedCondition.WithinRange = `TILESTOUNITS(1);
	Template.AbilityShooterConditions.AddItem(SourceNotConcealedCondition);

	Template.bAllowBonusWeaponEffects = true;
	
	DamageEffect = new class'X2Effect_HalfDamage';
	DamageEffect.EnvironmentalDamageAmount = 20;
	Template.AddTargetEffect(DamageEffect);

	//Prevent repeatedly hammering on a unit with Brawler triggers.
	//(This effect does nothing, but enables many-to-many marking of which Brawler attacks have already occurred each turn.)
	BrawlerTargetEffect = new class'X2Effect_Persistent';
	BrawlerTargetEffect.BuildPersistentEffect(1, false, true, true, eGameRule_PlayerTurnEnd);
	BrawlerTargetEffect.EffectName = 'BrawlerTarget';
	BrawlerTargetEffect.bApplyOnMiss = true; //Only one chance, even if you miss (prevents crazy flailing counter-attack chains with a Muton, for example)
	Template.AddTargetEffect(BrawlerTargetEffect);
	
	BrawlerTargetCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	BrawlerTargetCondition.AddExcludeEffect('BrawlerTarget', 'AA_DuplicateEffectIgnored');
	Template.AbilityTargetConditions.AddItem(BrawlerTargetCondition);

	Template.CustomFireAnim = 'FF_Melee';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = Brawler_BuildVisualization;
	Template.bShowActivation = true;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NormalChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}

//Must be static, because it will be called with a different object (an XComGameState_Ability)
//Used to trigger Brawler when the source's concealment is broken by a unit in melee range (the regular movement triggers get called too soon)
static function EventListenerReturn BrawlerConcealmentListener(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit ConcealmentBrokenUnit;
	local StateObjectReference BrawlerRef;
	local XComGameState_Ability BrawlerState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	ConcealmentBrokenUnit = XComGameState_Unit(EventSource);	
	if (ConcealmentBrokenUnit == None)
		return ELR_NoInterrupt;

	//Do not trigger if the Brawler SPARK himself moved to cause the concealment break - only when an enemy moved and caused it.
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext().GetFirstStateInEventChain().GetContext());
	if (AbilityContext != None && AbilityContext.InputContext.SourceObject != ConcealmentBrokenUnit.ConcealmentBrokenByUnitRef)
		return ELR_NoInterrupt;

	BrawlerRef = ConcealmentBrokenUnit.FindAbility('BrawlerTrigger');
	if (BrawlerRef.ObjectID == 0)
		return ELR_NoInterrupt;

	BrawlerState = XComGameState_Ability(History.GetGameStateForObjectID(BrawlerRef.ObjectID));
	if (BrawlerState == None)
		return ELR_NoInterrupt;
	
	BrawlerState.AbilityTriggerAgainstSingleTarget(ConcealmentBrokenUnit.ConcealmentBrokenByUnitRef, false);
	return ELR_NoInterrupt;
}

simulated function Brawler_BuildVisualization(XComGameState VisualizeGameState)
{
	// Build the first shot of Brawler's visualization
	TypicalAbility_BuildVisualization(VisualizeGameState);
}

static function X2AbilityTemplate Bombardment()
{
	local X2AbilityTemplate             Template;
	local X2AbilityTarget_Cursor        CursorTarget;
	local X2AbilityMultiTarget_Radius   RadiusMultiTarget;
	local X2AbilityCooldown             Cooldown;
	local X2Effect_ApplyWeaponDamage    DamageEffect;
	local X2Effect_PerkAttachForFX      PerkEffect;
	local X2AbilityCost_ActionPoints    ActionPointCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Bombardment');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_bombard";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BOMBARDMENT_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.TargetingMethod = class'X2TargetingMethod_VoidRift';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.AbilityToHitCalc = default.DeadEye;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.bRestrictToSquadsightRange = true;
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = default.BOMBARDMENT_RADIUS;
	RadiusMultiTarget.bIgnoreBlockingCover = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	PerkEffect = new class'X2Effect_PerkAttachForFX';
	PerkEffect.EffectAddedFn = class'X2Ability_SparkAbilitySet'.static.Bombard_EffectAdded;
	Template.AddShooterEffect(PerkEffect);

	Template.AbilityMultiTargetConditions.AddItem(default.LivingTargetOnlyProperty);

	// Everything in the blast radius receives physical damage
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'Bombardment';
	DamageEffect.EnvironmentalDamageAmount = default.BOMBARDMENT_ENVDMG;
	Template.AddMultiTargetEffect(DamageEffect);

	Template.PostActivationEvents.AddItem('ItemRecalled');

	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.SendGremlinToLocation_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SparkAbilitySet'.static.Bombard_BuildVisualization;

	Template.CinescriptCameraType = "Spark_Bombard";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}

static function X2AbilityTemplate LightningStrike()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_SparkRefund		    ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_HalfDamage				WeaponDamageEffect;
	local array<name>                       SkipExclusions;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_Knockback				KnockbackEffect;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LightningStrike');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;		
	Template.IconImage = "img:///UILibrary_MW.UIPerk_lightning";
	Template.bHideOnClassUnlock = false;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.MeleePuckMeshPath = "Materials_DLC3.MovePuck_Strike";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.LS_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_SparkRefund';
	ActionPointCost.bMoveCost = true;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.RefundedActionPointType = 'standard';
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.BuiltInHitMod = 10;
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Target Conditions
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
	Template.AddShooterEffectExclusions(SkipExclusions);

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_HalfDamage';
	WeaponDamageEffect.EnvironmentalDamageAmount = 20;
	Template.AddTargetEffect(WeaponDamageEffect);

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = 1;
	RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.bAllowBonusWeaponEffects = true;
	Template.bSkipMoveStop = true;
	Template.CustomFireAnim = 'FF_Melee';
	Template.CustomMovingFireAnim = 'MV_Melee';	

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 8;
	KnockbackEffect.bKnockbackDestroysNonFragile = true;
	Template.AddTargetEffect(KnockbackEffect);
	Template.bOverrideMeleeDeath = true;

	// Voice events
	Template.SourceMissSpeech = 'SwordMiss';

	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Spark_Strike";

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate IntimidateMW()
{
	local X2AbilityTemplate						Template;
	local X2Effect_CoveringFire                 CoveringEffect;

	Template = PurePassive('IntimidateMW', "img:///UILibrary_MW.UIPerk_intimidate", false, 'eAbilitySource_Perk', true);
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	CoveringEffect = new class'X2Effect_CoveringFire';
	CoveringEffect.BuildPersistentEffect(1, true, false, false);
	CoveringEffect.AbilityToActivate = 'IntimidateTriggerMW';
	CoveringEffect.GrantActionPoint = 'intimidate';
	CoveringEffect.bPreEmptiveFire = false;
	CoveringEffect.bDirectAttackOnly = true;
	CoveringEffect.bOnlyDuringEnemyTurn = true;
	CoveringEffect.bUseMultiTargets = false;
	CoveringEffect.EffectName = 'IntimidateWatchEffect';
	Template.AddTargetEffect(CoveringEffect);

	Template.AdditionalAbilities.AddItem('IntimidateTriggerMW');

	return Template;
}

static function X2AbilityTemplate IntimidateTriggerMW()
{
	local X2AbilityTemplate						Template;
	local X2Effect_Panicked						PanicEffect;
	local X2AbilityCost_ReserveActionPoints     ActionPointCost;
	local X2Condition_UnitEffects               UnitEffects;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IntimidateTriggerMW');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.IconImage = "img:///UILibrary_MW.UIPerk_intimidate";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Offensive;

	ActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.AllowedTypes.Length = 0;
	ActionPointCost.AllowedTypes.AddItem('intimidate');
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	UnitEffects = new class'X2Condition_UnitEffects';
	UnitEffects.AddExcludeEffect(class'X2AbilityTemplateManager'.default.StunnedName, 'AA_UnitIsStunned');
	Template.AbilityShooterConditions.AddItem(UnitEffects);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);

	PanicEffect = class'X2StatusEffects'.static.CreatePanickedStatusEffect();
	PanicEffect.ApplyChanceFn = class'X2Ability_SparkAbilitySet'.static.IntimidationApplyChance;
	PanicEffect.VisualizationFn = class'X2Ability_SparkAbilitySet'.static.Intimidate_Visualization;
	Template.AddTargetEffect(PanicEffect);

	// This line is the only difference from the original Intimidate
	Template.bSkipFireAction = false;
	Template.CustomFireAnim = 'FF_FireShredStormCannon';
	// It changes the animation from the blue targeting hologram to the SPARK simply pointing at a target

	Template.bShowActivation = true;
	Template.CinescriptCameraType = "Spark_Intimidate";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

//BEGIN AUTOGENERATED CODE: Template Overrides 'IntimidateTrigger'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'IntimidateTrigger'

	return Template;
}

static function X2AbilityTemplate Triangulation()
{
	local X2AbilityTemplate			Template;
	local X2Effect_CoveringFire		Effect;
	
	Template = PurePassive('Triangulation', "img:///UILibrary_MW.UIPerk_triangulation", false, 'eAbilitySource_Perk', true);
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Effect = new class'X2Effect_CoveringFire';
	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.AbilityToActivate = 'TriangulationTrigger';
	Effect.GrantActionPoint = 'triangulate';
	Effect.bPreEmptiveFire = false;
	Effect.bDirectAttackOnly = true;
	Effect.bOnlyDuringEnemyTurn = true;
	Effect.bUseMultiTargets = false;
	Effect.EffectName = 'TriangulationWatchEffect';
	Template.AddTargetEffect(Effect);
	
	Template.AdditionalAbilities.AddItem('TriangulationTrigger');

	return Template;
}

static function X2AbilityTemplate TriangulationTrigger()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTrigger_EventListener		EventListener;
	local X2Condition_UnitEffects				Condition;
	local X2Effect_HoloTarget					Effect;
	local X2AbilityCost_ReserveActionPoints		ActionPointCost;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'TriangulationTrigger');
	Template.IconImage = "img:///UILibrary_MW.UIPerk_triangulation";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.bShowActivation = true;
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.bCrossClassEligible = false;

	ActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.AllowedTypes.Length = 0;
	ActionPointCost.AllowedTypes.AddItem('triangulate');
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Condition = new class'X2Condition_UnitEffects';
	Condition.AddExcludeEffect(class'X2AbilityTemplateManager'.default.StunnedName, 'AA_UnitIsStunned');
	Template.AbilityShooterConditions.AddItem(Condition);

	// build the aim buff
    Effect = new class'X2Effect_HoloTarget';
	Effect.HitMod = default.TRIANGULATION_HITMOD;
	Effect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnEnd);
	Effect.SetDisplayInfo(ePerkBuff_Penalty, "Triangulated", "All enemies of this unit gain extra Aim when firing at it.", "img:///UILibrary_MW.UIPerk_triangulation", true);
	Effect.bRemoveWhenTargetDies = true;
	Effect.bUseSourcePlayerState = true;
	Template.AddTargetEffect(Effect);
	
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);

	Template.CustomFireAnim = 'NO_Intimidate';
	Template.bShowActivation = true;
	Template.CinescriptCameraType = "Spark_Intimidate";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate Supernova()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCooldown                     Cooldown;
	local X2AbilityCost_ActionPoints			ActionPointCost;
	local X2AbilityCost_Charges					ChargeCost;
	local X2AbilityCharges						Charges;
	local X2Effect_IncrementUnitValue           SetUnitValueEffect;
	local X2AbilityMultiTarget_Radius           MultiTargetRadius;
	local X2Effect_ApplyWeaponDamage            DamageEffect;
	local X2Effect_Stunned						StunnedEffect;
	local X2Condition_UnitProperty				UnitCondition;
	local X2Effect_DelayedAbilityActivation		TriggerStun;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Supernova');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_nova";

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = default.SUPERNOVA_CHARGES;
	Template.AbilityCharges = Charges;

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.SUPERNOVA_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = new class'X2AbilityTarget_Cursor';
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.TargetingMethod = class'X2TargetingMethod_Supernova';

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Stuns the caster
	TriggerStun = new class'X2Effect_DelayedAbilityActivation';
    TriggerStun.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnEnd);
	TriggerStun.TriggerEventName = 'SupernovaStun';
	Template.AddShooterEffect(TriggerStun);
	Template.AdditionalAbilities.AddItem('SupernovaStun');

	// Target everything in this blast radius
	MultiTargetRadius = new class'X2AbilityMultiTarget_Radius';
	MultiTargetRadius.fTargetRadius = default.SUPERNOVA_RADIUS_METERS;
	Template.AbilityMultiTargetStyle = MultiTargetRadius;
	
	// Target only living units that are not XCOM or Resistance
	Template.AbilityMultiTargetConditions.AddItem(default.LivingTargetOnlyProperty);
	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeDead = true;
	UnitCondition.ExcludeHostileToSource = false;
	UnitCondition.ExcludeFriendlyToSource = true;
	Template.AbilityMultiTargetConditions.AddItem(UnitCondition);

	// Everything in the blast radius receives physical damage
	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.EffectDamageValue = default.SUPERNOVA_DMG;
	DamageEffect.bIgnoreArmor = true;
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.EnvironmentalDamageAmount = default.SUPERNOVA_ENVDMG;
	Template.AddMultiTargetEffect(DamageEffect);
	
	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
	
	Template.bSkipExitCoverWhenFiring = true;
	Template.CustomFireAnim = 'FF_Nova';
	Template.DamagePreviewFn = SupernovaDamagePreview;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Nova'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'Nova'

	return Template;
}

function bool SupernovaDamagePreview(XComGameState_Ability AbilityState, StateObjectReference TargetRef, out WeaponDamageValue MinDamagePreview, out WeaponDamageValue MaxDamagePreview, out int AllowsShield)
{
	MinDamagePreview = default.SUPERNOVA_DMG;
	MaxDamagePreview = default.SUPERNOVA_DMG;
	return true;
}

static function X2AbilityTemplate SupernovaStun()
{
	local X2AbilityTemplate			Template;
	local X2Effect_Stunned			StunnedEffect;
	local X2AbilityTrigger_EventListener	Trigger;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'SupernovaStun');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_nova";

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'SupernovaStun';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_Self;
	Template.AbilityTriggers.AddItem(Trigger);
	
	StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, 100);
	StunnedEffect.MinStatContestResult = 0;
	StunnedEffect.MaxStatContestResult = 0;
	StunnedEffect.bRemoveWhenSourceDies = true;
	StunnedEffect.DuplicateResponse = eDupe_Ignore;
	Template.AddTargetEffect(StunnedEffect);

	/*
    StunnedEffect = new class'X2Effect_Stunned';
	StunnedEffect.MinStatContestResult = 0;
	StunnedEffect.MaxStatContestResult = 0;
	StunnedEffect.bRemoveWhenSourceDies = true;
	StunnedEffect.DuplicateResponse = eDupe_Ignore;
	StunnedEffect.ApplyChance = 100;
	StunnedEffect.StunLevel = 2;
	StunnedEffect.bIsImpairing = true;
	StunnedEffect.EffectHierarchyValue = class'X2StatusEffects'.default.STUNNED_HIERARCHY_VALUE;
	StunnedEffect.EffectName = class'X2AbilityTemplateManager'.default.StunnedName;
	StunnedEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);

	StunnedEffect.VisualizationFn = class'X2StatusEffects'.static.StunnedVisualization;
	StunnedEffect.EffectTickedVisualizationFn = class'X2StatusEffects'.static.StunnedVisualizationTicked;
	StunnedEffect.EffectRemovedVisualizationFn = class'X2StatusEffects'.static.StunnedVisualizationRemoved;
	StunnedEffect.EffectRemovedFn = class'X2StatusEffects'.static.StunnedEffectRemoved;
	StunnedEffect.bRemoveWhenTargetDies = true;
	StunnedEffect.bCanTickEveryAction = true;
	StunnedEffect.DamageTypes.AddItem('Mental');

	StunnedEffect.VFXTemplateName = class'X2StatusEffects'.default.StunnedParticle_Name;
	StunnedEffect.VFXSocket = class'X2StatusEffects'.default.StunnedSocket_Name;
	StunnedEffect.VFXSocketsArrayName = class'X2StatusEffects'.default.StunnedSocketsArray_Name;
	
	Template.AddTargetEffect(StunnedEffect);
	*/

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

static function X2AbilityTemplate EmergentAI()
{
	local X2AbilityTemplate					Template;
	local X2Effect_PersistentStatChange		HackEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'EmergentAI');	
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.IconImage = "img:///UILibrary_MW.UIPerk_emergent";
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;

	HackEffect = new class'X2Effect_PersistentStatChange';
	HackEffect.BuildPersistentEffect(1, true, false);
	HackEffect.SetDisplayInfo (ePerkBuff_Passive,Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName); 
	HackEffect.AddPersistentStatChange(eStat_Hacking, default.EMERGENTAI_HACK);
	HackEffect.AddPersistentStatChange(eStat_Offense, default.EMERGENTAI_AIM);
	Template.AddTargetEffect(HackEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.TechBonusLabel, eStat_Hacking, default.EMERGENTAI_HACK);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.TechBonusLabel, eStat_Offense, default.EMERGENTAI_AIM);
	
	Template.AdditionalAbilities.AddItem('HaywireProtocol');

	return Template;
}
