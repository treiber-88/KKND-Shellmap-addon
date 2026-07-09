
--[[UnitTypes = {  "survivors_infantry_rpglauncher", "survivors_infantry_rpglauncher", "survivors_infantry_rpglauncher", "survivors_infantry_rpglauncher" }
	BeachUnitTypes = { "survivors_infantry_rpglauncher", "survivors_infantry_rpglauncher", "survivors_infantry_rpglauncher", "survivors_infantry_rpglauncher"}]]
	ProducedUnitTypes =
	{
		{ factory = SurvivorsBarracks, types = { "survivors_infantry_rpglauncher" } },
		--{ factory = AlliedWarFactory1, types = { "jeep", "1tnk", "2tnk", "arty", "ctnk" } },
		{ factory = EvolvedMenagerie, types = { "evolved_vehicle_missilecrab" } }
	}



-BindActorTriggers == function(a)
	if a.HasProperty("Hunt") then
		if a.Owner == Survivors then
			Trigger.OnIdle(a, function(a)
				if a.IsInWorld then
					a.Hunt()
				end
			end)
		else
			Trigger.OnIdle(a, function(a)
				if a.IsInWorld then
					a.AttackMove(SurvivorsPowerstation.Location)
				end
			end)
		end
	end

	if a.HasProperty("HasPassengers") then
		Trigger.OnPassengerExited(a, function(t, p)
			BindActorTriggers(p)
		end)

		Trigger.OnDamaged(a, function()
			if a.HasPassengers then
				a.Stop()
				a.UnloadPassengers()
			end
		end)
	end
end




BindActorTriggers = function(a)
	if a.HasProperty("Hunt") then
		if a.Owner == Survivors then
			Trigger.OnIdle(a, function(a)
				if a.IsInWorld then
					a.Hunt()
				end
			end)
		else
			Trigger.OnIdle(a, function(a)
				if a.IsInWorld then
					a.AttackMove(SurvivorsPowerstation.Location)
				end
			end)
		end
	end

	if a.HasProperty("HasPassengers") then
		Trigger.OnPassengerExited(a, function(t, p)
			BindActorTriggers(p)
		end)

		Trigger.OnDamaged(a, function()
			if a.HasPassengers then
				a.Stop()
				a.UnloadPassengers()
			end
		end)
	end
end 

--[[SendSovietUnits = function(entryCell, unitTypes, interval)
	local units = Reinforcements.Reinforce(Evolved, unitTypes, { entryCell }, interval)
	Utils.Do(units, function(unit)
		BindActorTriggers(unit)
	end)
	Trigger.OnAllKilled(units, function() SendSovietUnits(entryCell, unitTypes, interval) end)
end


ShipAlliedUnits = function()
	local units = Reinforcements.ReinforceWithTransport(Survivors, "survivors_infantry_rpglauncher",
		ShipUnitTypes, { LstEntry.Location, LstUnload.Location }, { LstEntry.Location })[2]

	Utils.Do(units, function(unit)
		BindActorTriggers(unit)
	end)

	Trigger.AfterDelay(DateTime.Seconds(60), ShipAlliedUnits)
end




ProduceUnits = function(t)
	local factory = t.factory
	if not factory.IsDead then
		local unitType = t.types[Utils.RandomInteger(1, #t.types + 1)]
		factory.Wait(Actor.BuildTime(unitType))
		factory.Produce(unitType)
		factory.CallFunc(function() ProduceUnits(t) end)
	end
end

SetupAlliedUnits = function()
	Utils.Do(Map.NamedActors, function(a)
		if a.Owner == Survivors and a.HasProperty("AcceptsCondition") and a.AcceptsCondition("unkillable") then
			--a.GrantCondition("unkillable")
			a.Stance = "Defend"
		end
	end)
end

SetupFactories = function()
	Utils.Do(ProducedUnitTypes, function(production)
		Trigger.OnProduction(production.factory, function(_, a) BindActorTriggers(a) end)
	end)
end


WorldLoaded = function()
	Survivors = Player.GetPlayer("Survivors")
	Evolved = Player.GetPlayer("Evolved")

	SetupAlliedUnits()
	SetupFactories()
	ShipAlliedUnits()
	InsertAlliedChinookReinforcements(Chinook1Entry, HeliPad1)
	InsertAlliedChinookReinforcements(Chinook2Entry, HeliPad2)
	PowerProxy = Actor.Create(ProxyType, false, { Owner = Evolved })
	ParadropSovietUnits()
	Trigger.AfterDelay(DateTime.Seconds(5), ChronoshiftAlliedUnits)
	Utils.Do(ProducedUnitTypes, ProduceUnits)


	SendSovietUnits(Entry1.Location, UnitTypes, 50)
	SendSovietUnits(Entry2.Location, UnitTypes, 50)
	SendSovietUnits(Entry3.Location, UnitTypes, 50)
	SendSovietUnits(Entry4.Location, UnitTypes, 50)
	SendSovietUnits(Entry5.Location, UnitTypes, 50)
	SendSovietUnits(Entry6.Location, UnitTypes, 50)
	SendSovietUnits(Entry7.Location, BeachUnitTypes, 15)
end ]]
