local f = CreateFrame("Frame");
local buttonCreateList = CreateFrame("Button", "createList", nil);
local buttonCraftItems = CreateFrame("Button", "craftItems", nil);
local buttonSkipNext = CreateFrame("Button", "skipNext", nil);
local craftListIsEmpty = "Список на изготовление пуст!";
local inventoryIsFull = "Инвентарь переполнен!";
local nextItemIs = "Следующий: ";
local glyphs = {};
local totalGlyphs = 0;
local totalReagents = {};
local tradeSkillCastTime = 3250; -- ВРЕМЯ ДЕЛАНЬЯ ОДНОГО СИМВОЛА
local doTradeSkillRepeats = 10; -- `tradeSkillCastTime * doTradeSkillRepeats` ms delay for clicker by /ca_craftnext macros (СКОЛЬКО ШТУК ДЕЛАТЬ)

-- НЕ УДАЛЯТЬ НОМЕРА СИМВОЛОВ, НЕ ИЗМЕНЯТЬ, ТОЛЬКО КОММЕНТИРОВАТЬ СТРОКИ ЕСЛИ СИМВОЛ НЕ НАДО (ОСТАВИЛ ТОЛЬКО УПОМЯНУТЫЕ В ГАЙДАХ НА WOWCIRCLE)
local defaultGlyphs = {
	-- -- -- -- -- -- -- -- -- -- -- 
	-- 			      ВОИН              
	-- -- -- -- -- -- -- -- -- -- --

	-- 105, -- Символ бдительности
	-- 106, -- Символ безудержного восстановления
	-- 107, -- Символ вихря клинков
	-- 108, -- Символ глухой обороны
	-- 109, -- Символ отражения заклинания
	-- 110, -- Символ ударной волны
	-- 111, -- Символ вмешательства
	-- 112, -- Символ сокрушения
	-- 113, -- Символ блокирования
	-- 114, -- Символ кровожадности
	-- 115, -- Символ смертельного удара
	-- 116, -- Символ отчаянной защиты
	-- 117, -- Символ победного ража
	-- 118, -- Символ провокации
	-- 119, -- Символ грохочущей мощи
	120, -- Символ властности
	121, -- Символ вихря
	-- 122, -- Символ неоспоримой победы
	-- 123, -- Символ размашистого удара
	-- 124, -- Символ казни
	125, -- Символ рассечения
	-- 126, -- Символ вульгарных оскорблений
	127, -- Символ реванша
	-- 128, -- Символ превосходства
	-- 129, -- Символ раскола брони
	-- 130, -- Символ подрезанного сухожилия
	131, -- Символ кровопускания
	132, -- Символ удара героя
	-- 133, -- Символ дразнящего удара
	-- 134, -- Символ стремительного рывка
	135, -- Символ кровавой ярости
	-- 136, -- Символ удара грома
	137, -- Символ рывка
	138, -- Символ боевого крика

	-- -- -- -- -- -- -- -- -- -- -- 
	-- 			      ДРУИД              
	-- -- -- -- -- -- -- -- -- -- --

	-- 140, -- Символ берсерка
	141, -- Символ буйного роста
	142, -- Символ дикого рева
	-- 143, -- Символ дубовой кожи
	144, -- Символ покровительства природы
	-- 145, -- Символ инстинкта выживания
	-- 146, -- Символ жизнецвета
	147, -- Символ звездопада
	148, -- Символ увечья
	149, -- Символ быстрого восстановления
	-- 150, -- Символ грозы
	151, -- Символ озарения
	152, -- Символ восстановления
	-- 153, -- Символ рыка
	154, -- Символ фокусирования
	-- 155, -- Символ стремительного омоложения
	-- 156, -- Символ тайфуна
	157, -- Символ неистового восстановления
	-- 158, -- Символ глубокой раны
	159, -- Символ полосования
	-- 160, -- Символ сезона дождей
	-- 161, -- Символ звездного огня
	162, -- Символ разрывания
	-- 163, -- Символ возрождения
	164, -- Символ вызывающего рева
	165, -- Символ роя насекомых
	166, -- Символ порыва
	167, -- Символ лунного огня
	-- 168, -- Символ целительного прикосновения
	-- 169, -- Символ трепки
	170, -- Символ безграничного возрождения
	171, -- Символ водного облика
	-- 172, -- Символ когтя
	-- 173, -- Символ гнева деревьев
	-- 174, -- Символ гнева
	-- 175, -- Символ омоложения
	176, -- Символ шипов
	177, -- Символ дикой природы

	-- -- -- -- -- -- -- -- -- -- -- 
	-- 			      ЖРЕЦ              
	-- -- -- -- -- -- -- -- -- -- --

	-- 179, -- Символ гимна надежды
	180, -- Символ исповеди
	-- 181, -- Символ иссушения разума
	-- 182, -- Символ оберегающего духа
	-- 183, -- Символ слияния с Тьмой
	-- 184, -- Символ массового рассеивания
	-- 185, -- Символ слова Тьмы: Смерть
	-- 186, -- Символ круга исцеления
	-- 187, -- Символ колодца Света
	-- 188, -- Символ духа воздаяния
	-- 189, -- Символ контроля над разумом
	-- 190, -- Символ молитвы исцеления
	191, -- Символ Тьмы
	-- 192, -- Символ сдерживания Плети
	193, -- Символ исчадия Тьмы
	-- 194, -- Символ Слова Тьмы: Боль
	-- 195, -- Символ кольца света
	-- 196, -- Символ защиты от страха
	-- 197, -- Символ подавления боли
	-- 198, -- Символ рассеивания заклинаний
	-- 199, -- Символ кары
	200, -- Символ пытки разума
	201, -- Символ левитации
	-- 202, -- Символ обновления
	-- 203, -- Символ защиты от темной магии
  -- 204, -- Символ внутреннего огня
	-- 205, -- Символ быстрого исцеления
	-- 206, -- Символ ментального крика
	207, -- Символ ухода в тень
	-- 208, -- Символ сковывания нежити
	209, -- Символ слова силы: Щит
	-- 210, -- Символ растворения в тени
	211, -- Символ стойкости

	-- -- -- -- -- -- -- -- -- -- -- 
	-- 			      МАГ              
	-- -- -- -- -- -- -- -- -- -- --

	-- 213, -- Символ глубокой заморозки
	214, -- Символ живой бомбы
	-- 215, -- Символ зеркального изображения
	-- 216, -- Символ ледяной преграды
	-- 217, -- Символ чародейского обстрела
	-- 218, -- Символ ледяного огня
	-- 219, -- Символ невидимости
	220, -- Символ раскаленного доспеха
	-- 221, -- Символ элементаля воды
	-- 222, -- Символ снятия проклятия
	-- 223, -- Символ превращения
	-- 224, -- Символ огненного взрыва
	-- 225, -- Символ ледяной стрелы
	226, -- Символ огненного шара
	-- 227, -- Символ ледяного копья
	-- 228, -- Символ взрывной волны
	-- 229, -- Символ мощи тайной магии
	-- 230, -- Символ магического доспеха
	-- 231, -- Символ чародейской вспышки
	232, -- Символ самоцвета маны
	-- 233, -- Символ извечной воды
	234, -- Символ ледяной глыбы
	-- 235, -- Символ ожога
	-- 236, -- Символ стылой крови
	-- 237, -- Символ прилива сил
	-- 238, -- Символ скачка
	239, -- Символ защиты от магии льда
	-- 240, -- Символ чародейских стрел
	-- 241, -- Символ ледяного доспеха
	242, -- Символ защиты от огня
	-- 243, -- Символ чародейского взрыва
	-- 244, -- Символ кольца льда
	245, -- Символ замедленного падения
	-- 246, -- Символ пингвина
	-- 247, -- Символ морозного доспеха
	-- 248, -- Символ чародейского интеллекта

	-- -- -- -- -- -- -- -- -- -- -- 
	-- 			      ОХОТНИК              
	-- -- -- -- -- -- -- -- -- -- --

	250, -- Символ взрывной ловушки
	-- 251, -- Символ выстрела химеры
	-- 252, -- Символ дезориентирующего выстрела
	253, -- Символ разрывного выстрела
	-- 254, -- Символ убийственного выстрела
	-- 255, -- Символ удара ящера
	-- 256, -- Символ змеиной ловушки
	257, -- Символ верного выстрела
	-- 258, -- Символ ауры меткого выстрела
	-- 259, -- Символ града стрел
	-- 260, -- Символ звериного гнева
	-- 261, -- Символ укуса виверны
	-- 262, -- Символ духа зверя
	-- 263, -- Символ духа гадюки
	-- 264, -- Символ ястреба
	-- 265, -- Символ ледяной ловушки
	-- 266, -- Символ быстрой стрельбы
	-- 267, -- Символ замораживающей ловушки
	-- 268, -- Символ отрыва
	-- 269, -- Символ стаи
	-- 270, -- Символ сдерживания
	-- 271, -- Символ прицельного выстрела
	272, -- Символ ложной смерти
	-- 273, -- Символ залпа
	-- 274, -- Символ обжигающей ловушки
	-- 275, -- Символ лечения
	276, -- Символ укуса змеи
	-- 277, -- Символ чародейского выстрела
	-- 278, -- Символ метки охотника
	-- 279, -- Символ воскрешения питомца
	-- 280, -- Символ овладения силой
	-- 281, -- Символ отпугивания зверя
	282, -- Символ лечения питомца

	-- -- -- -- -- -- -- -- -- -- -- 
	-- 			      ПАЛАДИН              
	-- -- -- -- -- -- -- -- -- -- --

	-- 284, -- Символ божественной бури
	-- 285, -- Символ молота праведника
	-- 286, -- Символ святой клятвы
	-- 287, -- Символ спасения
	-- 288, -- Символ частицы Света
	-- 289, -- Символ шока небес
	-- 290, -- Символ щита праведности
	-- 291, -- Символ гнева карателя
	292, -- Символ печати отмщения
	293, -- Символ печати праведности
	-- 294, -- Символ священного гнева
	-- 295, -- Символ щита мстителя
	-- 296, -- Символ молота гнева
	297, -- Символ печати мудрости
	-- 298, -- Символ печати Света
	-- 299, -- Символ изгнания зла
	-- 300, -- Символ печати повиновения
	301, -- Символ вспышки Света
	302, -- Символ экзорцизма
	303, -- Символ удара воина Света
	-- 304, -- Символ освящения
	-- 305, -- Символ очищения
	-- 306, -- Символ праведной защиты
	-- 307, -- Символ мудрых
	-- 308, -- Символ божественности
	-- 309, -- Символ правосудия
	-- 310, -- Символ молота правосудия
	311, -- Символ Света небес
	312, -- Символ благословения королей
	313, -- Символ чутья на нежить
	-- 314, -- Символ духовного созвучия
	315, -- Символ благословения мудрости
	316, -- Символ возложения рук
	317, -- Символ благословения могущества

	-- -- -- -- -- -- -- -- -- -- -- 
	-- 			     РАЗБОЙНИК              
	-- -- -- -- -- -- -- -- -- -- --

	-- 319, -- Символ веера клинков
	320, -- Символ жажды убийства
	-- 321, -- Символ маленьких хитростей
	-- 322, -- Символ плаща Теней
	-- 323, -- Символ танца теней
	324, -- Символ череды убийств
	325, -- Символ неутомимости
	-- 326, -- Символ смертельного броска
	327, -- Символ выброса адреналина
	-- 328, -- Символ кровоизлияния
	329, -- Символ подготовки
	-- 330, -- Символ шквала клинков
	-- 331, -- Символ калечащего яда
	-- 332, -- Символ призрачного удара
	333, -- Символ рваной раны
	-- 334, -- Символ внезапного удара
	-- 335, -- Символ ложного выпада
	-- 336, -- Символ спринта
	337, -- Символ расправы
	338, -- Символ мясорубки
	339, -- Символ коварного удара
	340, -- Символ безопасного падения
	-- 341, -- Символ ошеломления
	342, -- Символ парализующего удара
	-- 343, -- Символ гарроты
	344, -- Символ исчезновения
	-- 345, -- Символ отвлечения
	-- 346, -- Символ ослабления доспеха
	-- 347, -- Символ ускользания
	-- 348, -- Символ потрошения
	-- 349, -- Символ взлома
	-- 350, -- Символ удара в спину
	351, -- Символ огромной скорости
	-- 352, -- Символ обшаривания карманов

	-- -- -- -- -- -- -- -- -- -- -- 
	-- 			   РЫЦАРЬ СМЕРТИ              
	-- -- -- -- -- -- -- -- -- -- --

	-- 354, -- Символ воющего ветра
	355, -- Символ ненасытной стужи
	-- 356, -- Символ нечестивой порчи
	-- 357, -- Символ танцующего рунического оружия
	358, -- Символ антимагического панциря
	-- 359, -- Символ ледяных оков
	-- 360, -- Символ незыблемости льда
	361, -- Символ рунического удара
	362, -- Символ смерти и разложения
	363, -- Символ темной власти
	-- 364, -- Символ удара в сердце
	-- 365, -- Символ уничтожения
	-- 366, -- Символ удушения
	367, -- Символ вурдалака
	-- 368, -- Символ крови вампира
	369, -- Символ удара смерти
	-- 370, -- Символ удара Плети
	371, -- Символ зимнего горна
	-- 372, -- Символ кровоотвода
	-- 373, -- Символ кровавого удара
	-- 374, -- Символ захвата рун
	-- 375, -- Символ несокрушимой брони
	-- 376, -- Символ взрыва трупа
	-- 377, -- Символ воскрешения мертвых
	378, -- Символ мора
	379, -- Символ объятий смерти
	-- 380, -- Символ удара чумы
	-- 381, -- Символ хватки смерти
	382, -- Символ ледяного прикосновения
	383, -- Символ болезни
	384, -- Символ черной смерти
	385, -- Символ ледяного удара
	-- 386, -- Символ костяного щита

	-- -- -- -- -- -- -- -- -- -- -- 
	-- 			    ЧЕРНОКНИЖНИК              
	-- -- -- -- -- -- -- -- -- -- --

	-- 388, -- Символ блуждающего духа
	-- 389, -- Символ демонического круга
	390, -- Символ жизнеотвода
	391, -- Символ метаморфозы
	-- 392, -- Символ пламени Тьмы
	393, -- Символ связки души
	-- 394, -- Символ стрелы Хаоса
	-- 395, -- Символ нестабильного колдовства
	-- 396, -- Символ стража Скверны
  -- 397, -- Символ лика смерти
	-- 398, -- Символ воя ужаса
	-- 399, -- Символ поджигания
	-- 400, -- Символ вытягивания жизни
	-- 401, -- Символ охотника Скверны
	-- 402, -- Символ проклятия агонии
	-- 403, -- Символ жертвенного огня
	404, -- Символ быстрого разложения
	-- 405, -- Символ душ
	406, -- Символ испепеления
	-- 407, -- Символ суккуба
	-- 408, -- Символ ожога Тьмы
	-- 409, -- Символ камня души
	-- 410, -- Символ жгучей боли
	-- 411, -- Символ демона Бездны
	-- 412, -- Символ стрелы Тьмы
	-- 413, -- Символ проклятия изнеможения
	-- 414, -- Символ порабощения демона
	-- 415, -- Символ беса
	-- 416, -- Символ Килрогга
	-- 417, -- Символ страха
	-- 418, -- Символ канала здоровья
	-- 419, -- Символ камня здоровья
	-- 420, -- Символ порчи
	-- 421, -- Символ бесконечного дыхания
	-- 422, -- Символ похищения души

	-- -- -- -- -- -- -- -- -- -- -- 
	-- 			       ШАМАН              
	-- -- -- -- -- -- -- -- -- -- --

	-- 424, -- Символ быстрины
	-- 425, -- Символ грома
	-- 426, -- Символ духа дикого волка
	-- 427, -- Символ сглаза
	-- 428, -- Символ тотема каменного когтя
	-- 429, -- Символ тотема элементаля огня
	-- 430, -- Символ покорения стихий
	-- 431, -- Символ тотема прилива маны
	432, -- Символ цепного исцеления
	-- 433, -- Символ цепной молнии
	-- 434, -- Символ шока
	435, -- Символ волны исцеления
	436, -- Символ лавы
	-- 437, -- Символ удара бури
	-- 438, -- Символ грома и молнии
	-- 439, -- Символ оружия неистовства ветра
	440, -- Символ оружия жизни земли
	-- 441, -- Символ хозяина вод
	442, -- Символ тотема гнева
	-- 443, -- Символ щита земли
	-- 444, -- Символ малой волны исцеления
	445, -- Символ тотема исцеляющего потока
	-- 446, -- Символ ледяного шока
	-- 447, -- Символ вскипания лавы
	-- 448, -- Символ астрального возвращения
	449, -- Символ обновленной жизни
	-- 450, -- Символ хождения по воде
	-- 451, -- Символ молнии
	-- 452, -- Символ подводного дыхания
	-- 453, -- Символ оружия языка пламени
	454, -- Символ кольца огня
	455, -- Символ щита молний
	456, -- Символ водного щита
	457, -- Символ призрачного волка
	-- 458  -- Символ огненного шока
};
local defaultGlyphsLength = table.getn(defaultGlyphs);

function applyTextures(button)
	applyNormalTexture(button);
	applyHightlighTexture(button);
	applyPushedTexture(button);
end;

function applyHightlighTexture(button)
	local tex = button:CreateTexture();
	tex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight");
	tex:SetTexCoord(0, 0.625, 0, 0.6875);
	tex:SetAllPoints();
	button:SetHighlightTexture(tex);
end;

function applyNormalTexture(button)
	local tex = button:CreateTexture();
	tex:SetTexture("Interface/Buttons/UI-Panel-Button-Up");
	tex:SetTexCoord(0, 0.625, 0, 0.6875);
	tex:SetAllPoints();
	button:SetNormalTexture(tex)
end;

function applyPushedTexture(button)
	local tex = button:CreateTexture();
	tex:SetTexture("Interface/Buttons/UI-Panel-Button-Down");
	tex:SetTexCoord(0, 0.625, 0, 0.6875);
	tex:SetAllPoints();
	button:SetPushedTexture(tex);
end;

function getFreeSlots() 
	local totalFreeSlots = 0;

	for i=0, 5 do 
		local currentBagFreeSlots = GetContainerNumFreeSlots(i);
		totalFreeSlots = currentBagFreeSlots + totalFreeSlots;
	end;

	return totalFreeSlots;
end;

function isTradeSkillWindowOpen()
	local firstGlyphId = 106;
	local firstSkillInfo = GetTradeSkillInfo(firstGlyphId);
	local isTradeOpen = firstSkillInfo ~= nil;

	return isTradeOpen;
end;

function createList(self, buttonCreateList, down)
	glyphs = copy(defaultGlyphs);
	totalReagents = {};
	
	-- этот кусок кода раньше использовался чтобы создать glyphs таблицу состаяющую из всех символов на основе сканирования твоей профы (не обязательно фул)
	-- CastSpellByName("Начертание");
	-- for i=1, GetNumTradeSkills() do 
		-- local n = GetTradeSkillInfo(i); 
		
		-- if(string.find(n,"^Символ ") ~= nil) then 
			-- print('Найден: ' .. n .. ', index: ' .. i); 
			-- print(i .. ', -- '.. n); 
			-- table.insert(glyphs, i);
		-- end; 
	-- end;

	CastSpellByName("Начертание");
	local next = GetTradeSkillInfo(glyphs[1]);
	CloseTradeSkill();
	buttonCraftItems:SetText(nextItemIs .. next);

	totalGlyphs = table.getn(glyphs);

	isEnoughCraftItems();

	print('Список из ' .. totalGlyphs .. ' элементов был создан. \nГотов делать. \nВ сумках свободно ' .. getFreeSlots() .. ' ячеек.');
end;

function isEnoughCraftItems() 
	print('Проверяю наличие реагентов для создания символов по |c11FF00FF' .. doTradeSkillRepeats .. '|c11FFFFFF штук ...')
	-- проверка что хватает реагентов на все doTradeSkillRepeats для каждого из glyphs
	for i=1, table.getn(glyphs) do 
		local numReagents = GetTradeSkillNumReagents(glyphs[i]);
		for r=1, numReagents, 1 do
			local reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(glyphs[i], r);

			if (reagentCount == nil) then 
				print('|c11FF0000ОШИБКА РАССЧЁТОВ! Выберите в окне профессии "Все подклассы" и повторите создание списка!');
				return;
			end;

			totalReagents[reagentName] = {
				['reagentName'] = reagentName,
				['requiredReagentCount'] = (tableHasKey(totalReagents, reagentName) and totalReagents[reagentName]['requiredReagentCount'] or 0) + reagentCount * doTradeSkillRepeats,
				['playerReagentCount'] = playerReagentCount
			}
		end;
	end;	
		
	for reagentName, calc in pairs(totalReagents) do
		local required = totalReagents[reagentName]['requiredReagentCount'];
		local playerHas = totalReagents[reagentName]['playerReagentCount'];
		local diff  = required - playerHas;	
		local modDiff = diff < 0 and diff * -1 or diff;
		local buyOrExtra = diff < 0 and 'лишнее' or 'купить';

		if (totalReagents[reagentName]['requiredReagentCount'] > totalReagents[reagentName]['playerReagentCount']) then	
			print('|c11FF0000Не хватает реагентов! |c11FFD300[' .. reagentName .. ']|c11FFFFFF: необходимо |c11FF0000' .. required .. '|c11FFFFFF, в сумках |c1100FF00' .. playerHas .. '|c11FFFFFF, '.. buyOrExtra ..' |c11FF7F50' .. modDiff);
		else 
			print('|c1100FF00Реагенты найдены! |c11FFD300[' .. reagentName .. ']|c11FFFFFF: необходимо |c11FF0000' .. required .. '|c11FFFFFF, в сумках |c1100FF00' .. playerHas .. '|c11FFFFFF, '.. buyOrExtra ..' |c11AAD3FF' .. modDiff);
		end;
	end;

	-- print(dump(totalReagents));
end;

function dump(o)
	if type(o) == 'table' then
		 local s = '{ '
		 for k,v in pairs(o) do
				if type(k) ~= 'number' then k = '"'..k..'"' end
				s = s .. '['..k..'] = ' .. dump(v) .. ','
		 end
		 return s .. '} '
	else
		 return tostring(o)
	end
end

function copy(obj, seen)
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
  return res
end

function tableHasKey(table,key)
	return table[key] ~= nil
end

function craftNextItem(self, button, down)
	local inventoryFreeSlots = getFreeSlots();
	local glyphsQueueLength = table.getn(glyphs);
	local progress = string.format("%.1f", 100 - glyphsQueueLength / defaultGlyphsLength * 100, 1);
	local remainingTime = ceil(glyphsQueueLength * doTradeSkillRepeats * tradeSkillCastTime / 1000 / 60); -- minutes
	local nGlyph = defaultGlyphsLength - glyphsQueueLength;
	--print('Trade skill open: ' .. isTradeSkillWindowOpen());
	
	if (not isTradeSkillWindowOpen()) then
		print('Открыть Начертание.')
		CastSpellByName("Начертание");
	end;
	
	if (glyphsQueueLength>0 and inventoryFreeSlots>0) then
		for i=1, GetNumTradeSkills() do 
			if(i == glyphs[1]) then 
				local current = GetTradeSkillInfo(i); 
				print(nGlyph .. ' / ' .. defaultGlyphsLength .. ' (завершено |c1132E0C4'..progress..'%|c11FFFFFF, ждать |c11e43f5a'.. remainingTime ..' мин.|c11FFFFFF). Сейчас: |c11FFD300[' .. current .. ']'); 				
				DoTradeSkill(i, doTradeSkillRepeats);
				table.remove(glyphs, 1);

				if (glyphsQueueLength>1) then
					local next = GetTradeSkillInfo(glyphs[1]);
					buttonCraftItems:SetText(nextItemIs .. next);
				else 
					buttonCraftItems:SetText(craftListIsEmpty);
				end;

				break;
			end; 
		end;
	else 
		if (inventoryFreeSlots == 0) then
			print(inventoryIsFull);
		end;

		if (glyphsQueueLength == 0) then 
			print(craftListIsEmpty); 
		end;
	end;
end;

function skipNext()
	local glyphsQueueLength = table.getn(glyphs);

	if (glyphsQueueLength>0) then
		CastSpellByName("Начертание");
		local skipped = GetTradeSkillInfo(glyphs[1]);
		CloseTradeSkill();	
		table.remove(glyphs, 1);
		totalGlyphs = table.getn(glyphs);
		
		if (totalGlyphs>0) then
			local next = GetTradeSkillInfo(glyphs[1]);
			buttonCraftItems:SetText(nextItemIs .. next);
			print('Пропуск: ' .. skipped .. ' > ' .. next);
		else 
			buttonCraftItems:SetText(craftListIsEmpty);
			print('Пропуск: ' .. skipped .. '. Конец списка.');
		end;
	else
		print(craftListIsEmpty);
	end;
	
end;


buttonCreateList:SetPoint("BOTTOMLEFT", 484, 90)
buttonCreateList:SetWidth(100)
buttonCreateList:SetHeight(28)
buttonCreateList:SetText("Создать список");
buttonCreateList:SetNormalFontObject("GameFontNormalSmall");
buttonCreateList:SetScript("OnClick", createList);
applyTextures(buttonCreateList);

buttonCraftItems:SetPoint("BOTTOMLEFT", 735, 90);
buttonCraftItems:SetWidth(300);
buttonCraftItems:SetHeight(28);
buttonCraftItems:SetText(craftListIsEmpty);
buttonCraftItems:SetNormalFontObject("GameFontNormalSmall");
buttonCraftItems:SetScript("OnClick", craftNextItem);

buttonSkipNext:SetPoint("BOTTOMLEFT", 585, 90);
buttonSkipNext:SetWidth(150);
buttonSkipNext:SetHeight(28);
buttonSkipNext:SetText('Пропустить следующий');
buttonSkipNext:SetNormalFontObject("GameFontNormalSmall");
buttonSkipNext:SetScript("OnClick", skipNext);
applyTextures(buttonSkipNext);

SLASH_CRAFT_NEXT_ITEM1 = "/ca_craftnext";
SLASH_CREATE_LIST1 = "/ca_createlist";
SLASH_SKIP_NEXT1 = "/ca_skipnext";
SLASH_SKIP_TEN1 = "/ca_skipten";

SlashCmdList["CRAFT_NEXT_ITEM"] = function(msg)
   buttonCraftItems:Click();
end 
SlashCmdList["CREATE_LIST"] = function(msg)
   buttonCreateList:Click();
end 
SlashCmdList["SKIP_NEXT"] = function(msg)
	buttonSkipNext:Click();
end 
SlashCmdList["SKIP_TEN"] = function(msg)
	for i=0,10 do
		buttonSkipNext:Click();
	end;	
end 