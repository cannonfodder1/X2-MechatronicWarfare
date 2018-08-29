class X2StrategyElement_StaffSlotsMW extends X2StrategyElement;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> StaffSlots;

	StaffSlots.AddItem(CreateSparkStaffSlotTemplate());

	return StaffSlots;
}

static function X2DataTemplate CreateSparkStaffSlotTemplate()
{
	local X2StaffSlotTemplate Template;

	`CREATE_X2TEMPLATE(class'X2StaffSlotTemplate', Template, 'SparkStaffSlot2');
	Template = class'X2StrategyElement_DefaultStaffSlots'.static.CreateStaffSlotTemplate('SparkStaffSlot2');
	Template.bSoldierSlot = true;
	Template.AssociatedProjectClass = class'XComGameState_HeadquartersProjectHealSpark';
	Template.FillFn = class'X2StrategyElement_DLC_Day90StaffSlots'.static.FillSparkSlot;
	Template.EmptyFn = class'X2StrategyElement_DLC_Day90StaffSlots'.static.EmptySparkSlot;
	Template.ShouldDisplayToDoWarningFn = class'X2StrategyElement_DLC_Day90StaffSlots'.static.ShouldDisplaySparkToDoWarning;
	Template.GetSkillDisplayStringFn = class'X2StrategyElement_DLC_Day90StaffSlots'.static.GetSparkSkillDisplayString;
	Template.GetBonusDisplayStringFn = class'X2StrategyElement_DLC_Day90StaffSlots'.static.GetSparkBonusDisplayString;
	Template.IsUnitValidForSlotFn = class'X2StrategyElement_DLC_Day90StaffSlots'.static.IsUnitValidForSparkSlot;
	Template.MatineeSlotName = "Spark";

	return Template;
}
