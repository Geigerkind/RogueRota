-- Global Variables
RogueRota = {}
RogueRota.TickTime = 2
RogueRota.Global = 1
RogueRota.FirstTick = 0
RogueRota.Energy = 100
RogueRota.f = CreateFrame("Frame", "Energy", UIParent)
RogueRota.f:RegisterEvent("UNIT_ENERGY")
RogueRota.f:SetScript("OnEvent", function(self, event)
	if (UnitMana("player") == (RogueRota.Energy+20)) then
		RogueRota.FirstTick = GetTime()
	end
	RogueRota.Energy = UnitMana("player")
end)
if GetLocale() == "deDE" then
	RogueRota.name = {
		[1] = "Zerhäckseln",
		[2] = "Erdschlag",
		[3] = "Heilige Stärke",
		[4] = "Adrenalinrausch",
		[5] = "Finsterer Stoß",
		[6] = "Ausweiden"
	}

else
	RogueRota.name = {
		[1] = "Slice and Dice",
		[2] = "Earthstrike",
		[3] = "Holy Strength",
		[4] = "Adrenaline Rush",
		[5] = "Sinister Strike",
		[6] = "Eviscerate"
	}
end

-- Local Variables
local f = CreateFrame("GameTooltip", "f", UIParent, "GameTooltipTemplate")

-- Begin Functions

function RogueRota:GetNextTick()
	local i, now = RogueRota.FirstTick, GetTime()
	while true do
		if (i>now) then
			return (i-now)
		end
		i = i + RogueRota.TickTime
	end
end

function RogueRota:IsActive(name)
	for i=0, 31 do
		f:SetOwner(UIParent, "ANCHOR_NONE")
		f:ClearLines()
		f:SetPlayerBuff(GetPlayerBuff(i, "HELPFUL"))
		local buff = fTextLeft1:GetText()
		if (not buff) then break end
		if (buff == name) then
			return true, GetPlayerBuffTimeLeft(GetPlayerBuff(i, "HELPFUL"))
		end
		f:Hide()
	end
	return false, 0
end

function RogueRota:Rota()
	local active, timeLeft = RogueRota:IsActive(RogueRota.name[1])
	local Eactive, EtimeLeft = RogueRota:IsActive(RogueRota.name[2])
	local Cactive, CtimeLeft = RogueRota:IsActive(RogueRota.name[3])
	local Aactive, AtimeLeft = RogueRota:IsActive(RogueRota.name[4])
	local cP = GetComboPoints("player")
	local health = UnitHealth("target")
	local healthMax = UnitHealthMax("target")
	local healthPercent = 100*(health/healthMax)
	local energy = UnitMana("player")
	if (not UnitIsPlayer("target")) then
		if (cP<5) then 
			if ((cP==1 or cP==3) and (not active or timeLeft < 2)) then
				if (healthPercent<10 or (health<5000 and healthPercent<50)) then
					if (energy<=40 and RogueRota:GetNextTick() > 1) then
						return
					else
						if (cP==3) then
							CastSpellByName(RogueRota.name[6])
						else
							CastSpellByName(RogueRota.name[5])
						end
					end
				else
					if (cP>1 and Eactive) then
						CastSpellByName(RogueRota.name[5])
					else
						if (Active and AtimeLeft>RogueRota:GetNextTick()) then
							if (timeLeft>1 and energy<=30 and RogueRota:GetNextTick() > 1) then
								return
							else
								CastSpellByName(RogueRota.name[1])
							end
						else
							if (timeLeft>1 and energy<=65 and RogueRota:GetNextTick() > 1) then
								return
							else
								CastSpellByName(RogueRota.name[1])
							end
						end
					end
				end
			else
				if ((healthPercent<10 or (health<5000 and healthPercent<50)) and cP>2) then
					if (energy>=60) then
						if (health<2500 and healthPercent<25) then
							CastSpellByName(RogueRota.name[6])
						else
							CastSpellByName(RogueRota.name[5])
						end
					else
						CastSpellByName(RogueRota.name[6])
					end
				else
					if (healthPercent<5 or (health<2500 and healthPercent<25)) and (energy<40) then
						CastSpellByName(RogueRota.name[6])
					else
						CastSpellByName(RogueRota.name[5])
					end
				end
			end
		else 
			if (not active or timeLeft < 2) and (healthPercent>40 or (health>5000 and healthPercent>50)) then
				if (Eactive) then
					if (energy<=45 and not Cactive and not Active) then
						return
					else
						CastSpellByName(RogueRota.name[6])
					end
				else
					if (Active and AtimeLeft>RogueRota:GetNextTick()) then
						if (timeLeft>1 and energy<=30 and RogueRota:GetNextTick() > 1) then
							return
						else
							CastSpellByName(RogueRota.name[1])
						end
					else
						if (timeLeft>1 and energy<=65 and RogueRota:GetNextTick() > 1) then
							return
						else
							CastSpellByName(RogueRota.name[1])
						end
					end
				end
			else
				if (Cactive) then
					CastSpellByName(RogueRota.name[6])
				else
					if (Active and AtimeLeft>RogueRota:GetNextTick()) then
						if (energy<=45 and RogueRota:GetNextTick() > 1) then
							return
						else
							CastSpellByName(RogueRota.name[6])
						end
					else
						if (energy<=65 and RogueRota:GetNextTick() > 1) then
							return
						else
							CastSpellByName(RogueRota.name[6])
						end
					end
				end
			end
		end
	else
		CastSpellByName(RogueRota.name[5])
	end
end