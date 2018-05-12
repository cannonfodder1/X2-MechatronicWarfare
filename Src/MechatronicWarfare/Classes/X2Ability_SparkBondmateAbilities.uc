// Shamelessly stolen from the Spark Bondmate Abilities mod with a few tweaks
class X2Ability_SparkBondmateAbilities extends X2Ability_DefaultBondmateAbilities;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	// Teamwork Lv.1
	Templates.AddItem(CreateBondmateInspireAbilityForSparks('BondmateTeamwork_Spark',
												   "img:///UILibrary_XPACK_Common.UIPerk_bond_teamwork",
												   1,
												   2,
												   1));


	// Teamwork Lv.3
	Templates.AddItem(CreateBondmateInspireAbilityForSparks('BondmateTeamwork_Improved_Spark',
												   "img:///UILibrary_XPACK_Common.UIPerk_bond_teamwork2",
												   3,
												   3,
												   2));

	return Templates;
}

static function X2AbilityTemplate CreateBondmateInspireAbilityForSparks(name TemplateName,
															   string TemplateIconImage,
															   int MinBondLevel,
															   int MaxBondLevel,
															   int Charges)
{
	local X2AbilityTemplate				Template;
	local X2AbilityCost_ActionPoints	ActionPointCost;
	local X2Effect_GrantActionPoints	ActionPointEffect;
	local X2Effect_Persistent			ActionPointPersistEffect;
	local X2Condition_Bondmate			BondmateCondition;
	local X2AbilityCost_Charges			ChargeCost;
	local X2Condition_UnitProperty      TargetCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, TemplateName);

	// Icon Properties
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Commander';                                       // color of the icon
	Template.IconImage = TemplateIconImage;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.bLimitTargetIcons = true;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

	BondmateCondition = new class'X2Condition_Bondmate';
	BondmateCondition.MinBondLevel = MinBondLevel;
	BondmateCondition.MaxBondLevel = MaxBondLevel;
	BondmateCondition.RequiresAdjacency = EAR_AnyAdjacency;
	Template.AbilityShooterConditions.AddItem(BondmateCondition);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeHostileToSource = true;
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.RequireSquadmates = true;
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.ExcludeDead = true;
	TargetCondition.ExcludeRobotic = true;
	TargetCondition.ExcludeUnableToAct = true;
	TargetCondition.ExcludePanicked = true;
	Template.AbilityTargetConditions.AddItem(TargetCondition);
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	ActionPointEffect = new class'X2Effect_GrantActionPoints';
	ActionPointEffect.NumActionPoints = 1;
	ActionPointEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
	ActionPointEffect.bSelectUnit = true;
	Template.AddTargetEffect(ActionPointEffect);

	// A persistent effect for the effects code to attach a duration to
	ActionPointPersistEffect = new class'X2Effect_Persistent';
	ActionPointPersistEffect.EffectName = TemplateName;
	ActionPointPersistEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	ActionPointPersistEffect.bRemoveWhenTargetDies = true;
	Template.AddTargetEffect(ActionPointPersistEffect);

	Template.AbilityTargetStyle = default.BondmateTarget;

	// Template.ActivationSpeech = 'Inspire';
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.bShowActivation = true;
	// Template.CustomFireAnim = 'HL_Teamwork';
	// This will just make the SPARK point at the target
	Template.CustomFireAnim = 'FF_FireShredStormCannon';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	// Template.CinescriptCameraType = "Psionic_FireAtUnit";
	Template.CinescriptCameraType = "Spark_Intimidate";

	Template.AbilityCharges = new class'X2AbilityCharges';
	Template.AbilityCharges.InitialCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	ChargeCost.bAlsoExpendChargesOnSharedBondmateAbility = true;
	Template.AbilityCosts.AddItem(ChargeCost);

	return Template;
}