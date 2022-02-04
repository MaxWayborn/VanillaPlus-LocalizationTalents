local DB = {
	["WARRIOR"] = {
		["Improved Heroic Strike"] = {
			k="^Increases the critical strike chance of your Heroic Strike ability by (%d+)%%%.$",
			v="Повышает вероятность критического удара при применении Heroic Strike на %s%%."},
		["Tactical Mastery"] = {
			k="^You retain up to (%d+) of your rage points when you change stances.$",
			v="Восполнение до %s ед. ярости при смене стойки."},
		["Deflection"] = {
			k="^Increases your Parry chance by (%d+)%%%.$",
			v="Увеличивает вероятность парирования атак на %s%%."},
		["Improved Charge"] = {
			k="^Increases the amount of rage generated by your Charge by (%d+)%. In addition, increases the range of your Charge by (%d+) yards%.$",
			v="Увеличивает количество ярости, накапливаемое способностью Charge на %s ед. А так же увеличивает дальность применения Charge на %s м."},
		["Duelist"] = {
			k="^Increases the critical strike chance of your Overpower and Revenge abilities by (%d+)%% and reduces the cooldown of your Retaliation ability by (%d+)%%%.$",
			v="Повышает вероятность критического удара при применении Overpower и Revenge на %s%% и сокращает время восстановления способности Retaliation на %s%%."},
		["Improved Thunder Clap"] = {
			k="^Increase the Slow effect and damage of your Thunder Clap ability by (%d+)%%%.$",
			v="Увеличивает эффект замедления и урон способности Thunder Clap на %s%%."},
		["Improved Hamstring"] = {
			k="^Increases the duration of your Hamstring by (%d+) sec and reduces the target's speed by an additional (%d+)%%%.$",
			v="Увеличивает длительность способности Hamstring на %s сек. и дополнительно снижает скорость передвижения противника на %s%%."},
		["Anger Management"] = {
			k="^Increases the time required for your rage to decay while out of combat by (%d+)%%%.$",
			v="Увеличивает время, по истечении которого у вас начинает убывать ярость, на %s%%."},
		["Impale"] = {
			k="^Increases the critical strike damage bonus of your abilities in Battle, Defensive, and Berserker stance by (%d+)%%%.$",
			v="Увеличивает урон от критических ударов ваших способностей в защитной стойке, боевой стойке и стойке берсерка на %s%%."},
		["Deep Wounds"] = {
			k="^Your critical strikes cause the opponent to bleed, dealing (%d+)%% of your melee weapon's average damage over (%d+) sec. Stacks up to (%d+) times%.$",
			v="Ваши критические удары вызывают у противника кровотечение, наносящее %s%% от среднего урона вашим оружием в течении %s%% сек. Эффект может суммироваться до %s раз."},
		["Poleaxe Specialization"] = {
			k="^Increases your chance to get a critical strike with Axes and Polearms by (%d+)%%%.$",
			v="Повышение вероятности критического удара топорами и полеармами на %s%%."},
		["Mace Specialization"] = {
			k="^Causes your attacks with maces to ignore up to (%d+)%(scales with your level%) of your target's Armor%.$",
			v="Ваши атаки булавой игнорируют %s брони цели."},
		["Sword Specialization"] = {
			k="^Gives you a (%d+)%% chance to get an extra attack on the same target after dealing damage with your Sword%.$",
			v="%s%% шанс атаковать цель повторно после того, как вы ударите ее мечом."},
		["Sweeping Strikes"] = {
			k="^Your attacks strike an additional nearby opponent. Lasts (%d+) sec%.$",
			v="Ваши атаки ближнего боя попадают еще по одному находяшемуся рядом врагу в течении %s сек."},
		["Two-Handed Weapon Specialization"] = {
			k="^Increases the damage you deal with two-handed melee weapons by (%d+)%%%.$",
			v="Увеличение урона от вашего двуручного оружия ближнего боя на %s%%."},
		["Maim"] = {
			k="^Your auto attacks have a (%d+)%% chance to injure the target, increasing physical damage taken by (%d+)%% for (%d+) sec%.$",
			v="Ваши автоатаки с вероятностью %s%% могут ранить цель увеличивая при этом получаемый физический урон на %s%% в течении %s сек."},
		["Para Bellum"] = {
			k="^Reduces the cooldown of your abilities by (%d+)%%%.$",
			v="Уменьшение времени восстановления ваших способностей на %s%%."},
		["Dog of War"] = {
			k="^Reduces the cost of your abilities by (%d+)%%%.$",
			v="Уменьшение стоимости ваших способностей на %s%%."},
		["Mortal Strike"] = {
			k="^A vicious strike that deals weapon damage plus (%d+) and wounds the target, reducing the effectiveness of any healing by (%d+)%% for (%d+) sec%.$",
			v="Жестокий удар, наносящий урон от оружия плюс %s ед. и наносящий цели серьезную рану, снижающую эффективность любого лечени на %s%% в течении %s сек."},
		["Improved Mortal Strike"] = {
			k="^Reduces the cooldown of your Mortal Strike ability by (.+) sec%.$", -- %d не подходит, тк тут дробное значение 0.5
			v="Уменьшение времени восстановления способности Mortal Strike на %s сек."},
	}
}

function FindTalentDesc(tempClass, tempTalent)
	for i = 3, GameTooltip:NumLines() do
		local r, g, b = getglobal("GameTooltipTextLeft" .. i):GetTextColor()
		if math_round(r, 2) == 1 and math_round(g, 2) == 0.82 and math_round(b, 2) == 0 then
			return {string.find(getglobal("GameTooltipTextLeft" .. i):GetText(), DB[tempClass][tempTalent].k)}
		end
	end
end

local HookSetTalent = GameTooltip.SetTalent
function GameTooltip.SetTalent(self, tabIndex, talentIndex)
	HookSetTalent(self, tabIndex, talentIndex)
	local _, tempClass = UnitClass("player")
	local tempTalent = getglobal("GameTooltipTextLeft1"):GetText()
	if DB[tempClass][tempTalent] then
		local r = FindTalentDesc(tempClass, tempTalent)
		GameTooltip:AddLine(" ", 1, 1, 1)
		GameTooltip:AddLine(string.format(DB[tempClass][tempTalent].v, (r[3] or ""), (r[4] or ""), (r[5] or "")), 1, 1, 1, 1)
		GameTooltip:Show()
	end
end
