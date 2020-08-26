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
	--
	-- 			      ВОИН              
	--
	-- -- -- -- -- -- -- -- -- -- --

  -- 105, -- Символ бдительности
	-- 106, -- Символ безудержного восстановления
	-- 113, -- Символ блокирования
		 138, -- Символ боевого крика
		 
	   121, -- Символ вихря
	-- 107, -- Символ вихря клинков
	   120, -- Символ властности
	-- 111, -- Символ вмешательства
	-- 126, -- Символ вульгарных оскорблений

	-- 108, -- Символ глухой обороны
	-- 119, -- Символ грохочущей мощи

	-- 133, -- Символ дразнящего удара

	   124, -- Символ казни (О)
	   135, -- Символ кровавой ярости
	-- 114, -- Символ кровожадности
		 131, -- Символ кровопускания
		 
	-- 122, -- Символ неоспоримой победы

	-- 109, -- Символ отражения заклинания
	-- 116, -- Символ отчаянной защиты

	-- 117, -- Символ победного ража
	-- 130, -- Символ подрезанного сухожилия
	-- 128, -- Символ превосходства
	-- 118, -- Символ провокации

	-- 123, -- Символ размашистого удара
	-- 129, -- Символ раскола брони
	   125, -- Символ рассечения
	   127, -- Символ реванша
		 137, -- Символ рывка (А)
		 
	-- 115, -- Символ смертельного удара
	-- 112, -- Символ сокрушения
	-- 134, -- Символ стремительного рывка

	   132, -- Символ удара героя
	-- 136, -- Символ удара грома
	-- 110, -- Символ ударной волны



	-- -- -- -- -- -- -- -- -- -- -- 
	--
	-- 			      ДРУИД              
	--
	-- -- -- -- -- -- -- -- -- -- --

  	 170, -- Символ безграничного возрождения
		 140, -- Символ берсерка (О)
		 141, -- Символ буйного роста
		 149, -- Символ быстрого восстановления

		 171, -- Символ водного облика
	-- 163, -- Символ возрождения
	   152, -- Символ восстановления (А)
	   164, -- Символ вызывающего рева

	-- 158, -- Символ глубокой раны
	-- 174, -- Символ гнева
	-- 173, -- Символ гнева деревьев
	-- 150, -- Символ грозы

	   142, -- Символ дикого рева
	   177, -- Символ дикой природы
	-- 143, -- Символ дубовой кожи

	-- 146, -- Символ жизнецвета

	-- 161, -- Символ звездного огня
	   147, -- Символ звездопада

	   145, -- Символ инстинкта выживания (О)

	-- 172, -- Символ когтя

	   167, -- Символ лунного огня

	   157, -- Символ неистового восстановления

	   151, -- Символ озарения (А)
	-- 175, -- Символ омоложения

	   144, -- Символ покровительства природы
	   159, -- Символ полосования (А)
	   166, -- Символ порыва

	   162, -- Символ разрывания
	   165, -- Символ роя насекомых
	-- 153, -- Символ рыка

	-- 160, -- Символ сезона дождей
	-- 155, -- Символ стремительного омоложения

	-- 156, -- Символ тайфуна
	   169, -- Символ трепки (О)

	   148, -- Символ увечья (А)

	   154, -- Символ фокусирования

	-- 168, -- Символ целительного прикосновения

	   176, -- Символ шипов



	-- -- -- -- -- -- -- -- -- -- -- 
	--
	-- 			      ЖРЕЦ             
	-- 
	-- -- -- -- -- -- -- -- -- -- --

	-- 205, -- Символ быстрого исцеления

	-- 204, -- Символ внутреннего огня
	
	-- 179, -- Символ гимна надежды

	-- 188, -- Символ духа воздаяния

	-- 196, -- Символ защиты от страха
	-- 203, -- Символ защиты от темной магии

	   180, -- Символ исповеди
	-- 181, -- Символ иссушения разума
		 193, -- Символ исчадия Тьмы
		 
	-- 199, -- Символ кары
	-- 187, -- Символ колодца Света
	-- 195, -- Символ кольца света
	-- 189, -- Символ контроля над разумом
		 186, -- Символ круга исцеления (О)
		 
		 201, -- Символ левитации
		 
	-- 184, -- Символ массового рассеивания
	-- 206, -- Символ ментального крика
	-- 190, -- Символ молитвы исцеления

	   182, -- Символ оберегающего духа (О)
		 202, -- Символ обновления (О)
		 
	-- 197, -- Символ подавления боли
		 200, -- Символ пытки разума
		 
	-- 198, -- Символ рассеивания заклинаний
	-- 210, -- Символ растворения в тени

	-- 192, -- Символ сдерживания Плети
	-- 208, -- Символ сковывания нежити
	-- 183, -- Символ слияния с Тьмой
	   209, -- Символ слова силы: Щит
	-- 194, -- Символ слова Тьмы: Боль
	-- 185, -- Символ слова Тьмы: Смерть
		 211, -- Символ стойкости
		 
		 191, -- Символ Тьмы
		 
		 207, -- Символ ухода в тень (А)
		 


	-- -- -- -- -- -- -- -- -- -- -- 
	--
	-- 			      МАГ      
	--        
	-- -- -- -- -- -- -- -- -- -- --

	-- 228, -- Символ взрывной волны

	-- 213, -- Символ глубокой заморозки

		 214, -- Символ живой бомбы
		 
		 245, -- Символ замедленного падения
		 239, -- Символ защиты от магии льда
		 242, -- Символ защиты от огня
	-- 215, -- Символ зеркального изображения

	-- 233, -- Символ извечной воды

	-- 244, -- Символ кольца льда

	-- 241, -- Символ ледяного доспеха
	-- 227, -- Символ ледяного копья
	-- 218, -- Символ ледяного огня
	   234, -- Символ ледяной глыбы (А)
	-- 216, -- Символ ледяной преграды
	-- 225, -- Символ ледяной стрелы

	-- 230, -- Символ магического доспеха
	-- 247, -- Символ морозного доспеха
	-- 229, -- Символ мощи тайной магии

	-- 219, -- Символ невидимости

	-- 224, -- Символ огненного взрыва
	   226, -- Символ огненного шара (А)
	-- 235, -- Символ ожога

	-- 246, -- Символ пингвина
	-- 223, -- Символ превращения
		 237, -- Символ прилива сил (О)
		 
		 220, -- Символ раскаленного доспеха
		 
		 232, -- Символ самоцвета маны (А)
	-- 238, -- Символ скачка
	-- 222, -- Символ снятия проклятия
	-- 236, -- Символ стылой крови

	-- 243, -- Символ чародейского взрыва
	-- 248, -- Символ чародейского интеллекта
	-- 217, -- Символ чародейского обстрела
	-- 231, -- Символ чародейской вспышки
	-- 240, -- Символ чародейских стрел

	-- 221, -- Символ элементаля воды



	-- -- -- -- -- -- -- -- -- -- -- 
	--
	-- 			      ОХОТНИК          
	--    
	-- -- -- -- -- -- -- -- -- -- --

  -- 258, -- Символ ауры меткого выстрела

	-- 266, -- Символ быстрой стрельбы

	   257, -- Символ верного выстрела
	   250, -- Символ взрывной ловушки
	-- 279, -- Символ воскрешения питомца
	-- 251, -- Символ выстрела химеры

	-- 259, -- Символ града стрел

	-- 252, -- Символ дезориентирующего выстрела
	-- 263, -- Символ духа гадюки
	-- 262, -- Символ духа зверя

	-- 273, -- Символ залпа
	-- 267, -- Символ замораживающей ловушки
	-- 260, -- Символ звериного гнева
	-- 256, -- Символ змеиной ловушки

	-- 265, -- Символ ледяной ловушки
	-- 275, -- Символ лечения
	   282, -- Символ лечения питомца
	   272, -- Символ ложной смерти

	-- 278, -- Символ метки охотника

	-- 274, -- Символ обжигающей ловушки
	-- 280, -- Символ овладения силой
	-- 281, -- Символ отпугивания зверя
	-- 268, -- Символ отрыва

	-- 271, -- Символ прицельного выстрела

	   253, -- Символ разрывного выстрела

	-- 270, -- Символ сдерживания
	-- 269, -- Символ стаи

	-- 254, -- Символ убийственного выстрела
	-- 255, -- Символ удара ящера
	-- 261, -- Символ укуса виверны
	   276, -- Символ укуса змеи

	-- 277, -- Символ чародейского выстрела

	-- 264, -- Символ ястреба



	-- -- -- -- -- -- -- -- -- -- -- 
	--
	-- 			      ПАЛАДИН          
	--    
	-- -- -- -- -- -- -- -- -- -- --

	   312, -- Символ благословения королей
	   317, -- Символ благословения могущества
	   315, -- Символ благословения мудрости
	-- 284, -- Символ божественной бури
	-- 308, -- Символ божественности

		 316, -- Символ возложения рук
		 301, -- Символ вспышки Света
		 
	-- 291, -- Символ гнева карателя

	-- 314, -- Символ духовного созвучия

	   299, -- Символ изгнания зла (О)

	-- 296, -- Символ молота гнева
	-- 285, -- Символ молота праведника
	-- 310, -- Символ молота правосудия
	   307, -- Символ мудрых (О)

	   304, -- Символ освящения (О)
	-- 305, -- Символ очищения

	-- 298, -- Символ печати Света
	   297, -- Символ печати мудрости
	   292, -- Символ печати отмщения
	-- 300, -- Символ печати повиновения
	   293, -- Символ печати праведности (А)
	-- 306, -- Символ праведной защиты
	-- 309, -- Символ правосудия

     311, -- Символ Света небес
	-- 286, -- Символ святой клятвы
	-- 294, -- Символ священного гнева
	-- 287, -- Символ спасения

		 303, -- Символ удара воина Света (А)
		 
	-- 288, -- Символ частицы Света
		 313, -- Символ чутья на нежить
		 
	-- 289, -- Символ шока небес

	-- 295, -- Символ щита мстителя
	-- 290, -- Символ щита праведности

	   302, -- Символ экзорцизма



	-- -- -- -- -- -- -- -- -- -- -- 
	--
	-- 			     РАЗБОЙНИК             
	-- 
	-- -- -- -- -- -- -- -- -- -- --

	   340, -- Символ безопасного падения

	-- 319, -- Символ веера клинков
	-- 349, -- Символ взлома
	-- 334, -- Символ внезапного удара
		 327, -- Символ выброса адреналина
		 
	-- 343, -- Символ гарроты

	-- 320, -- Символ жажды убийства
		 
	   344, -- Символ исчезновения

	-- 331, -- Символ калечащего яда
		 339, -- Символ коварного удара
	-- 328, -- Символ кровоизлияния

	-- 335, -- Символ ложного выпада

	-- 321, -- Символ маленьких хитростей
	 	 338, -- Символ мясорубки (А)

		 325, -- Символ неутомимости

	-- 352, -- Символ обшаривания карманов
	   351, -- Символ огромной скорости
	-- 346, -- Символ ослабления доспеха
		 345, -- Символ отвлечения (О)
	-- 341, -- Символ ошеломления
		 
	   342, -- Символ парализующего удара
	-- 322, -- Символ плаща Теней
	   329, -- Символ подготовки
	-- 348, -- Символ потрошения
	-- 332, -- Символ призрачного удара
	
	   337, -- Символ расправы (А)
		 333, -- Символ рваной раны

  -- 326, -- Символ смертельного броска
		 336, -- Символ спринта (О)
		 
     323, -- Символ танца теней (О)

	-- 350, -- Символ удара в спину
	-- 347, -- Символ ускользания
		 
	   324, -- Символ череды убийств 

	-- 330, -- Символ шквала клинков



	-- -- -- -- -- -- -- -- -- -- -- 
	--
	-- 			   РЫЦАРЬ СМЕРТИ            
	--  
	-- -- -- -- -- -- -- -- -- -- --

		 358, -- Символ антимагического панциря
		 
		 383, -- Символ болезни
		 
	-- 376, -- Символ взрыва трупа
	-- 377, -- Символ воскрешения мертвых
	-- 354, -- Символ воющего ветра
		 367, -- Символ вурдалака
		 
	-- 374, -- Символ захвата рун
		 371, -- Символ зимнего горна
		 
	-- 386, -- Символ костяного щита
	-- 373, -- Символ кровавого удара
	   368, -- Символ крови вампира (О)
	-- 372, -- Символ кровоотвода

	   382, -- Символ ледяного прикосновения
	   385, -- Символ ледяного удара
	-- 359, -- Символ ледяных оков

		 378, -- Символ мора
		 
	-- 360, -- Символ незыблемости льда
	   355, -- Символ ненасытной стужи (А)
	-- 375, -- Символ несокрушимой брони
	-- 356, -- Символ нечестивой порчи

		 379, -- Символ объятий смерти (А)
		 
		 361, -- Символ рунического удара (А)
		 
		 362, -- Символ смерти и разложения
		 
	-- 357, -- Символ танцующего рунического оружия
		 363, -- Символ темной власти
		 
	-- 370, -- Символ удара Плети
	-- 364, -- Символ удара в сердце
	   369, -- Символ удара смерти (А)
	-- 380, -- Символ удара чумы
	-- 366, -- Символ удушения
	   365, -- Символ уничтожения (О)

	-- 381, -- Символ хватки смерти

     384, -- Символ черной смерти



	-- -- -- -- -- -- -- -- -- -- -- 
	--
	-- 			    ЧЕРНОКНИЖНИК         
	--     
	-- -- -- -- -- -- -- -- -- -- --

     415, -- Символ беса (О)
	-- 421, -- Символ бесконечного дыхания
	-- 388, -- Символ блуждающего духа
		 404, -- Символ быстрого разложения
		 
	-- 398, -- Символ воя ужаса
	-- 400, -- Символ вытягивания жизни

	-- 411, -- Символ демона Бездны
	-- 389, -- Символ демонического круга
	-- 405, -- Символ душ

	-- 410, -- Символ жгучей боли
	-- 403, -- Символ жертвенного огня
	   390, -- Символ жизнеотвода

		 406, -- Символ испепеления
		 
	-- 409, -- Символ камня души
	-- 419, -- Символ камня здоровья
	-- 418, -- Символ канала здоровья
	-- 416, -- Символ Килрогга
	
	-- 397, -- Символ лика смерти
	
		 391, -- Символ метаморфозы
		 
	-- 395, -- Символ нестабильного колдовства

	-- 408, -- Символ ожога Тьмы
	-- 401, -- Символ охотника Скверны

	-- 392, -- Символ пламени Тьмы
	-- 399, -- Символ поджигания
	-- 414, -- Символ порабощения демона
	-- 420, -- Символ порчи
	-- 422, -- Символ похищения души
	-- 402, -- Символ проклятия агонии
	-- 413, -- Символ проклятия изнеможения

     393, -- Символ связки души (А)
	   396, -- Символ стража Скверны (О)
	-- 417, -- Символ страха
	-- 412, -- Символ стрелы Тьмы
	-- 394, -- Символ стрелы Хаоса
	-- 407, -- Символ суккуба



	-- -- -- -- -- -- -- -- -- -- -- 
	--
	-- 			       ШАМАН              
  --
	-- -- -- -- -- -- -- -- -- -- --

	-- 448, -- Символ астрального возвращения
	
	-- 424, -- Символ быстрины

	   456, -- Символ водного щита
	   435, -- Символ волны исцеления
	-- 447, -- Символ вскипания лавы

	-- 425, -- Символ грома
	-- 438, -- Символ грома и молнии
	   426, -- Символ духа дикого волка (О)

		 454, -- Символ кольца огня
		 
	   436, -- Символ лавы
	-- 446, -- Символ ледяного шока

	-- 444, -- Символ малой волны исцеления
	-- 451, -- Символ молнии

	   449, -- Символ обновленной жизни
	-- 458  -- Символ огненного шока
	   440, -- Символ оружия жизни земли
	-- 439, -- Символ оружия неистовства ветра
	-- 453, -- Символ оружия языка пламени

	-- 452, -- Символ подводного дыхания
	-- 430, -- Символ покорения стихий
		 457, -- Символ призрачного волка
		 
	-- 427, -- Символ сглаза

	   442, -- Символ тотема гнева
	   445, -- Символ тотема исцеляющего потока
	-- 428, -- Символ тотема каменного когтя
	-- 431, -- Символ тотема прилива маны
	-- 429, -- Символ тотема элементаля огня

	   437, -- Символ удара бури (О)

	-- 450, -- Символ хождения по воде
	   441, -- Символ хозяина вод (О)

	   432, -- Символ цепного исцеления
	-- 433, -- Символ цепной молнии

	-- 434, -- Символ шока

	-- 443, -- Символ щита земли
	   455, -- Символ щита молний (А)
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