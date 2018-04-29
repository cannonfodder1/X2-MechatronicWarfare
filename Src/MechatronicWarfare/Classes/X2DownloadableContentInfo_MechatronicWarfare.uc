class X2DownloadableContentInfo_MechatronicWarfare extends X2DownloadableContentInfo dependson(X2Character) config(UpdateSpark);

var config bool SPARK_CANNON_BREAKTHROUGH;

`define GETTECH(TECHNAME) X2TechTemplate(ElementManager.FindStrategyElementTemplate('`TECHNAME'))
`define IFGETTECH(TECHNAME) CannonTech=`GETTECH(`TECHNAME); if (CannonTech!=None)

`define GETITEM(ITEMNAME) X2GremlinTemplate(ItemManager.FindItemTemplate('`ITEMNAME'))
`define IFGETITEM(ITEMNAME) Bit=`GETITEM(`ITEMNAME); IF (bit!=None)
`define FIXBIT(ITEMNAME, BONUSNAME) `IFGETITEM(`ITEMNAME){Bit.SetUIStatMarkup(class'XLocalizedData'.default.TechBonusLabel, eStat_Hacking, class'X2Item_DLC_Day90Weapons'.default.`BONUSNAME);}

static event OnPostTemplatesCreated()
{
	PatchSparkItemT2Arm();
	PatchSparkItemT2Wep();
	PatchSparkItemT2Bit();
	PatchSparkItemT3Arm();
	PatchSparkItemT3Wep();
	PatchSparkItemT3Bit();

	PatchSparkBuildT2Arm();
	PatchSparkBuildT2Wep();
	PatchSparkBuildT2Bit();
	PatchSparkBuildT3Arm();
	PatchSparkBuildT3Wep();
	PatchSparkBuildT3Bit();
	
	PatchSquadBuildT2Arm();
	PatchSquadBuildT2Wep();
	PatchSquadBuildT2Grem();
	PatchSquadBuildT3Arm();
	PatchSquadBuildT3Wep();
	PatchSquadBuildT3Grem();

	PatchBreakthrough();
	PatchBondmates();
	PatchSparkBonding();
}

//================================================================================================================
// ITEMS
//================================================================================================================

static function PatchSparkItemT2Arm()
{
	local X2ItemTemplateManager			TemplateManager;
	local X2ItemTemplate				Template;

	// Find the item template
	TemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	Template = TemplateManager.FindItemTemplate('PlatedSparkArmor');
	
	// Change the schematic that creates this item from the Reinforced Frame schematic to the Predator Armor schematic
	Template.CreatorTemplateName = 'MediumPlatedArmor_Schematic';
	`log("Spark T2 Armour Patched");
}

static function PatchSparkItemT2Wep()
{
	local X2ItemTemplateManager			TemplateManager;
	local X2ItemTemplate				Template;

	// Find the item template
	TemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	Template = TemplateManager.FindItemTemplate('SparkRifle_MG');

	// Change the schematic that creates this item from the Helix Autocannon schematic to the Mag Cannon schematic
	Template.CreatorTemplateName = 'Cannon_MG_Schematic';
	`log("Spark T2 Weapon Patched");
}

static function PatchSparkItemT2Bit()
{
	local X2ItemTemplateManager			TemplateManager;
	local X2ItemTemplate				Template;

	// Find the item template
	TemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	Template = TemplateManager.FindItemTemplate('SparkBit_MG');

	// Change the schematic that creates this item from the Reinforced Frame schematic to the Gremlin MK2 schematic
	Template.CreatorTemplateName = 'Gremlin_MG_Schematic';
	`log("Spark T2 BIT Patched");
}

static function PatchSparkItemT3Arm()
{
	local X2ItemTemplateManager			TemplateManager;
	local X2ItemTemplate				Template;

	// Find the item template
	TemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	Template = TemplateManager.FindItemTemplate('PoweredSparkArmor');
	
	// Change the schematic that creates this item from the Anodized Chassis schematic to the Warden Armor schematic
	Template.CreatorTemplateName = 'MediumPoweredArmor_Schematic';
	`log("Spark T3 Armour Patched");
}

static function PatchSparkItemT3Wep()
{
	local X2ItemTemplateManager			TemplateManager;
	local X2ItemTemplate				Template;

	// Find the item template
	TemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	Template = TemplateManager.FindItemTemplate('SparkRifle_BM');
	
	// Change the schematic that creates this item from the Elerium Phase-Cannon schematic to the Beam Cannon schematic
	Template.CreatorTemplateName = 'Cannon_BM_Schematic';
	`log("Spark T3 Weapon Patched");
}

static function PatchSparkItemT3Bit()
{
	local X2ItemTemplateManager			TemplateManager;
	local X2ItemTemplate				Template;

	// Find the item template
	TemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	Template = TemplateManager.FindItemTemplate('SparkBit_BM');
	
	// Change the schematic that creates this item from the Anodized Chassis schematic to the Gremlin MK3 schematic
	Template.CreatorTemplateName = 'Gremlin_BM_Schematic';
	`log("Spark T3 BIT Patched");
}

//================================================================================================================
// SCHEMATICS
//================================================================================================================

static function PatchSparkBuildT2Arm()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2TechTemplate                        FakeTechTemplate;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;
	local StrategyRequirement					AltReq;

	// Setup bogus research project
	FakeTechTemplate = CreateFakeTechTemplate();
	AllStratElements = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	AllStratElements.AddStrategyElementTemplate(FakeTechTemplate, true);

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('PlatedSparkArmor_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('PlatedSparkArmor_Schematic', DifficultyTemplates);
	
	// Change the schematic's requirement tech to a nonexistent tech, effectively disabling this schematic
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
            CurrentSchematic.Requirements.RequiredTechs.Length = 0;
            CurrentSchematic.Requirements.RequiredTechs.AddItem('NonExistent');

			CurrentSchematic.AlternateRequirements.Length = 0;
			AltReq.RequiredTechs.AddItem('NonExistent');
			CurrentSchematic.AlternateRequirements.AddItem(AltReq);

			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Armor_Mk2";
		}
	}
	`log("Spark T2 Armour Schematic Patched");
}

static function PatchSparkBuildT2Wep()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2TechTemplate                        FakeTechTemplate;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;
	local StrategyRequirement					AltReq;

	// Setup bogus research project
	FakeTechTemplate = CreateFakeTechTemplate();
	AllStratElements = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	AllStratElements.AddStrategyElementTemplate(FakeTechTemplate, true);

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('SparkRifle_MG_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('SparkRifle_MG_Schematic', DifficultyTemplates);
	
	// Change the schematic's requirement tech to a nonexistent tech, effectively disabling this schematic
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
            CurrentSchematic.Requirements.RequiredTechs.Length = 0;
            CurrentSchematic.Requirements.RequiredTechs.AddItem('NonExistent');

			CurrentSchematic.AlternateRequirements.Length = 0;
			AltReq.RequiredTechs.AddItem('NonExistent');
			CurrentSchematic.AlternateRequirements.AddItem(AltReq);

			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Cannon_Mk2";
		}
	}
	`log("Spark T2 Weapon Schematic Patched");
}

static function PatchSparkBuildT2Bit()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2TechTemplate                        FakeTechTemplate;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;
	local StrategyRequirement					AltReq;

	// Setup bogus research project
	FakeTechTemplate = CreateFakeTechTemplate();
	AllStratElements = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	AllStratElements.AddStrategyElementTemplate(FakeTechTemplate, true);

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('SparkBit_MG_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('SparkBit_MG_Schematic', DifficultyTemplates);
	
	// Change the schematic's requirement tech to a nonexistent tech, effectively disabling this schematic
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
            CurrentSchematic.Requirements.RequiredTechs.Length = 0;
            CurrentSchematic.Requirements.RequiredTechs.AddItem('NonExistent');

			CurrentSchematic.AlternateRequirements.Length = 0;
			AltReq.RequiredTechs.AddItem('NonExistent');
			CurrentSchematic.AlternateRequirements.AddItem(AltReq);

			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Drone_Mk2";
		}
	}
	`log("Spark T2 BIT Schematic Patched");
}

static function PatchSparkBuildT3Arm()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2TechTemplate                        FakeTechTemplate;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;
	local StrategyRequirement					AltReq;

	// Setup bogus research project
	FakeTechTemplate = CreateFakeTechTemplate();
	AllStratElements = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	AllStratElements.AddStrategyElementTemplate(FakeTechTemplate, true);

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('PoweredSparkArmor_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('PoweredSparkArmor_Schematic', DifficultyTemplates);
	
	// Change the schematic's requirement tech to a nonexistent tech, effectively disabling this schematic
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
            CurrentSchematic.Requirements.RequiredTechs.Length = 0;
            CurrentSchematic.Requirements.RequiredTechs.AddItem('NonExistent');

			CurrentSchematic.AlternateRequirements.Length = 0;
			AltReq.RequiredTechs.AddItem('NonExistent');
			CurrentSchematic.AlternateRequirements.AddItem(AltReq);

			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Armor_Mk3";
		}
	}
	`log("Spark T3 Armour Schematic Patched");
}

static function PatchSparkBuildT3Wep()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2TechTemplate                        FakeTechTemplate;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;
	local StrategyRequirement					AltReq;

	// Setup bogus research project
	FakeTechTemplate = CreateFakeTechTemplate();
	AllStratElements = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	AllStratElements.AddStrategyElementTemplate(FakeTechTemplate, true);

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('SparkRifle_BM_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('SparkRifle_BM_Schematic', DifficultyTemplates);
	
	// Change the schematic's requirement tech to a nonexistent tech, effectively disabling this schematic
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
            CurrentSchematic.Requirements.RequiredTechs.Length = 0;
            CurrentSchematic.Requirements.RequiredTechs.AddItem('NonExistent');

			CurrentSchematic.AlternateRequirements.Length = 0;
			AltReq.RequiredTechs.AddItem('NonExistent');
			CurrentSchematic.AlternateRequirements.AddItem(AltReq);

			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Cannon_Mk3";
		}
	}
	`log("Spark T3 Weapon Schematic Patched");
}

static function PatchSparkBuildT3Bit()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2TechTemplate                        FakeTechTemplate;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;
	local StrategyRequirement					AltReq;

	// Setup bogus research project
	FakeTechTemplate = CreateFakeTechTemplate();
	AllStratElements = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	AllStratElements.AddStrategyElementTemplate(FakeTechTemplate, true);

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('SparkBit_BM_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('SparkBit_BM_Schematic', DifficultyTemplates);
	
	// Change the schematic's requirement tech to a nonexistent tech, effectively disabling this schematic
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
            CurrentSchematic.Requirements.RequiredTechs.Length = 0;
            CurrentSchematic.Requirements.RequiredTechs.AddItem('NonExistent');

			CurrentSchematic.AlternateRequirements.Length = 0;
			AltReq.RequiredTechs.AddItem('NonExistent');
			CurrentSchematic.AlternateRequirements.AddItem(AltReq);

			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Drone_Mk3";
		}
	}
	`log("Spark T3 BIT Schematic Patched");
}

static function X2TechTemplate CreateFakeTechTemplate()
{
	local X2TechTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, 'NonExistent');
	Template.PointsToComplete = 0;
	Template.SortingTier = 0;

	// Make Adv. Mag Weapons the requirement for this tech to show up
	// Make the prerequisite for Adv. Mag Weapons be the tech that will hide this tech from the menu
	// I love making Catch-22s
	Template.Requirements.RequiredTechs.AddItem('GaussWeapons');
	Template.UnavailableIfResearched = 'MagnetizedWeapons';

	return Template;
}

//================================================================================================================
// SQUISHY HUMAN SCHEMATICS
//================================================================================================================

static function PatchSquadBuildT2Arm()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('MediumPlatedArmor_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('MediumPlatedArmor_Schematic', DifficultyTemplates);
	
	// Change the schematic's image in Engineering to this mod's custom images
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Armor_Mk2";
		}
	}
	`log("Squad T2 Armour Schematic Patched");
}

static function PatchSquadBuildT2Wep()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('Cannon_MG_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('Cannon_MG_Schematic', DifficultyTemplates);
	
	// Change the schematic's image in Engineering to this mod's custom images
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Cannon_Mk2";
		}
	}
	`log("Squad T2 Cannon Schematic Patched");
}

static function PatchSquadBuildT2Grem()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('Gremlin_MG_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('Gremlin_MG_Schematic', DifficultyTemplates);
	
	// Change the schematic's image in Engineering to this mod's custom images
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Drone_Mk2";
		}
	}
	`log("Squad T2 Gremlin Schematic Patched");
}

static function PatchSquadBuildT3Arm()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('MediumPoweredArmor_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('MediumPoweredArmor_Schematic', DifficultyTemplates);
	
	// Change the schematic's image in Engineering to this mod's custom images
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Armor_Mk3";
		}
	}
	`log("Squad T3 Armour Schematic Patched");
}

static function PatchSquadBuildT3Wep()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('Cannon_BM_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('Cannon_BM_Schematic', DifficultyTemplates);
	
	// Change the schematic's image in Engineering to this mod's custom images
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Cannon_Mk3";
		}
	}
	`log("Squad T3 Cannon Schematic Patched");
}

static function PatchSquadBuildT3Grem()
{
	local X2ItemTemplateManager                 AllItems;
	local X2SchematicTemplate                   CurrentSchematic;
	local X2StrategyElementTemplateManager      AllStratElements;
	local X2DataTemplate					    DifficultyTemplate;
	local array<X2DataTemplate>				    DifficultyTemplates;

	// Find the schematic template
	AllItems = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	CurrentSchematic = X2SchematicTemplate(AllItems.FindItemTemplate('Gremlin_BM_Schematic'));
	AllItems.FindDataTemplateAllDifficulties('Gremlin_BM_Schematic', DifficultyTemplates);
	
	// Change the schematic's image in Engineering to this mod's custom images
	foreach DifficultyTemplates(DifficultyTemplate)
	{
		CurrentSchematic = X2SchematicTemplate(DifficultyTemplate);
		if ( CurrentSchematic != none )
		{
			CurrentSchematic.strImage = "";
			CurrentSchematic.strImage = "img:///UILibrary_MW.Inv_Drone_Mk3";
		}
	}
	`log("Squad T3 Gremlin Schematic Patched");
}

static function PatchBreakthrough()
{
	local X2StrategyElementTemplateManager ElementManager;
	local X2TechTemplate CannonTech;
	local X2ItemTemplateManager ItemManager;
	local X2GremlinTemplate Bit;

	ItemManager=class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	`FIXBIT(SparkBit_CV, SPARKBIT_CONVENTIONAL_HACKBONUS);
	`FIXBIT(SparkBit_MG, SPARKBIT_MAGNETIC_HACKBONUS);
	`FIXBIT(SparkBit_BM, SPARKBIT_BEAM_HACKBONUS);

	ElementManager=class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	`IFGETTECH(BreakthroughCannonWeaponUpgrade)
	{
		CannonTech.ResearchCompletedFn = BreakthroughWeaponUpgradeCompleted;
	}

	if (default.SPARK_CANNON_BREAKTHROUGH) UpdateDamageTemplate();
}

static function UpdateDamageTemplate(optional bool bAddTech=true)
{
	local X2StrategyElementTemplateManager ElementManager;
	local X2TechTemplate CannonTech;
	local X2BreakthroughCondition WeaponCondition;
	
	ElementManager=class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	`IFGETTECH(BreakthroughCannonDamage)
	{
		if (bAddTech)
		{
			WeaponCondition = new class'X2BreakthroughCondition_WeaponTypes';
			X2BreakthroughCondition_WeaponTypes(WeaponCondition).WeaponTypeMatch.additem('cannon');
			X2BreakthroughCondition_WeaponTypes(WeaponCondition).WeaponTypeMatch.additem('sparkrifle');
		}
		else
		{
			WeaponCondition = new class'X2BreakthroughCondition_WeaponType';
			X2BreakthroughCondition_WeaponType(WeaponCondition).WeaponTypeMatch='cannon';
		}
		if (WeaponCondition==none) `redscreen("wtf???????????????");
		CannonTech.BreakthroughCondition = WeaponCondition;
	}
}

static event OnLoadedSavedGame()
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState NewGameState;
	local XComGameState_Unit UnitState;
	local bool bSubmit;
	local int idx;

	OnExitPostMissionSequence();

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("upgrading sparkrifles");
	XComHQ = `XCOMHQ;
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

	for (idx = 0; idx < XComHQ.Crew.Length; idx++)
	{
		if (XComHQ.Crew[idx].ObjectID != 0)
		{
			UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(XComHQ.Crew[idx].ObjectID));

			if ( UnitState.GetMyTemplateName()=='SparkSoldier' &&
				(UnitState.GetCurrentStat(eStat_CombatSims)==0 ||
				!UnitState.bRolledForAWCAbility) )
			{
				NewGameState.AddStateObject(UnitState);
				UnitState.SetCurrentStat(eStat_CombatSims, 1);
				UnitState.RollForTrainingCenterAbilities();
				bSubmit=true;
			}
		}
	}
	if (bSubmit) `XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	else `XCOMHISTORY.CleanupPendingGameState(NewGameState);
}

static event OnExitPostMissionSequence()
{
	local array <name> arrTest;
	local int i;

	arrTest=`XCOMHQ.ExtraUpgradeWeaponCats;

	if (default.SPARK_CANNON_BREAKTHROUGH)
	{
		if (arrTest.find('cannon')!=INDEX_NONE &&
			arrTest.find('sparkrifle')==INDEX_NONE)
		{
			UpDateUpgradeSlot();
		}
	}
	else if (arrTest.Find('cannon')!=INDEX_NONE &&  arrTest.Find('sparkrifle')!=INDEX_NONE) //Do they have the cannon breakthrough?
	{
		if(arrTest.Find('SBMarker')!=INDEX_NONE) //Our trick marker entry!
			UpdateUpgradeSlot(false);
		else
		{
			i=arrTest.Length;
			arrTest.RemoveItem('sparkrifle');
			if (i-arrTest.Length>1)
				UpdateUpgradeSlot(false);
		}
	}
}

static event OnLoadedSavedGameToStrategy()
{
	OnExitPostMissionSequence();
}

static function UpDateUpgradeSlot (optional bool bAddTech=true)
{
	local XComGameState NewGameState;
	local array <name> arrTest;
	arrTest=`XCOMHQ.ExtraUpgradeWeaponCats;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("upgrading sparkrifles");
	if (bAddTech)
	{
		ArrTest.AddItem('sparkrifle');
		ArrTest.AddItem('SBMarker');
	}
	else
	{
		ArrTest.Remove(ArrTest.find('sparkrifle'), 1);
		ArrTest.RemoveItem('SBMarker');
	}
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
}

static function BreakthroughWeaponUpgradeCompleted(XComGameState NewGameState, XComGameState_Tech TechState)
{
	local XComGameState_HeadquartersXCom XComHQ;

	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', `XComHQ.ObjectID));
	XComHQ.ExtraUpgradeWeaponCats.AddItem(TechState.GetMyTemplate().RewardName);
	if ((default.SPARK_CANNON_BREAKTHROUGH) &&TechState.GetMyTemplate().RewardName=='cannon')
	{
		XComHQ.ExtraUpgradeWeaponCats.AddItem('sparkrifle');
		XComHQ.ExtraUpgradeWeaponCats.AddItem('SBMarker');
	}
}

static function PatchBondmates()
{
	local X2AbilityTemplateManager AbilityTemplateManager;
	local X2AbilityTemplate AbilityTemplate;
	local X2Condition_UnitProperty TargetCondition;

	// Allow bondmate abilities to target robotic units
	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeHostileToSource = true;
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.RequireSquadmates = true;
	TargetCondition.FailOnNonUnits = true;
	TargetCondition.ExcludeDead = true;
	TargetCondition.ExcludeRobotic = false;
	TargetCondition.ExcludeUnableToAct = true;
	TargetCondition.ExcludePanicked = true;
		
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('BondmateTeamwork');
	AbilityTemplate.AbilityTargetConditions[0] = TargetCondition;

	AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('BondmateTeamwork_Improved');
	AbilityTemplate.AbilityTargetConditions[0] = TargetCondition;
}

static function PatchSparkBonding()
{
	local X2CharacterTemplateManager CharacterTemplateMgr;
	local X2CharacterTemplate CharTemplate;

	CharacterTemplateMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	CharTemplate = CharacterTemplateMgr.FindCharacterTemplate('SparkSoldier');

	// Add SPARK bondmate abilities
	CharTemplate.Abilities.AddItem('BondmateSolaceCleanse');
	CharTemplate.Abilities.AddItem('BondmateSolacePassive');
	CharTemplate.Abilities.AddItem('BondmateTeamwork_Spark');
	CharTemplate.Abilities.AddItem('BondmateTeamwork_Improved_Spark');
	CharTemplate.Abilities.AddItem('BondmateSpotter_Aim');
	CharTemplate.Abilities.AddItem('BondmateSpotter_Aim_Adjacency');
	CharTemplate.Abilities.AddItem('BondmateDualStrike');
}
