// Wholesale ripped from RealityMachina's Metal Over Flesh Redux mod. You're a genius, RM, and this couldn't have happened without you
class XComGameState_TacticalCleanup_MW extends XComGameState_BaseObject;

var bool bRegistered;

function RegisterToListen()
{
	local Object ThisObj;
	ThisObj = self;

	if (!bRegistered)
	{
		`log("Mechatronic Warfare TacticalCleanup :: TacticalEventListener Loaded");
		bRegistered = true;
		`XEVENTMGR.RegisterForEvent(ThisObj, 'TacticalGameEnd', CleanupTacticalGame, ELD_OnStateSubmitted, , , true);
	}
	else
	{
		`log("Mechatronic Warfare TacticalCleanup :: Listener already present");
	}
}

function EventListenerReturn CleanupTacticalGame(Object EventData, Object EventSource, XComGameState GivenGameState, Name Event, Object CallbackData)
{
	local XComGameStateHistory History;
	local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local X2ItemTemplateManager ItemTemplateManager;
	local XComGameState_Item ItemState;
	local X2ItemTemplate ItemTemplate;
	local XComGameState_Unit Unit, NewUnitState;
	local int i;
	local XComGameState_BattleData BattleData;

	History = `XCOMHISTORY;
	`log("Mechatronic Warfare :: Recovering SPARK datacores");
	
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Cleanup Tactical Mission Loot");
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.CreateStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	NewGameState.AddStateObject(XComHQ);

	BattleData = XComGameState_BattleData(History.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemTemplate = ItemTemplateManager.FindItemTemplate('CorpseSpark');
	for (i = 0; i < XComHQ.Squad.Length; ++i) 
	{
	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectId(XComHQ.Squad[i].ObjectID));

		if(Unit.GetMyTemplateName() == 'SparkSoldier' && Unit.IsDead())
		{
			ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
			NewGameState.AddStateObject(ItemState);
			ItemState.Quantity = 1;
			ItemState.OwnerStateObject = XComHQ.GetReference();
			XComHQ.PutItemInInventory(NewGameState, ItemState, true);

			NewUnitState = XComGameState_Unit(NewGameState.CreateStateObject(class'XComGameState_Unit', Unit.ObjectID));
			NewUnitState.bBodyRecovered = true;
			NewGameState.AddStateObject(NewUnitState);
		}

	}
	
	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	return ELR_NoInterrupt;
}


function bool HasAnyTriadObjective(XComGameState_BattleData Battle)
{
	local int ObjectiveIndex;

	for( ObjectiveIndex = 0; ObjectiveIndex < Battle.MapData.ActiveMission.MissionObjectives.Length; ++ObjectiveIndex )
	{
		if( Battle.MapData.ActiveMission.MissionObjectives[ObjectiveIndex].bIsTriadObjective )
		{
			return true;
		}
	}

	return false;
}