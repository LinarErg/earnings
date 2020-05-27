﻿
&НаСервере
Процедура СформироватьНаСервере()
	
	Обработка = РеквизитФормыВЗначение("Объект");	
	
	Макет = Обработка.ПолучитьМакет("Макет");
	
	ТабличныйДокумент = ТабДок;
	ТабличныйДокумент.Очистить();
	
	облШапка 		= Макет.ПолучитьОбласть("облШапка");
	облСтрока 		= Макет.ПолучитьОбласть("ОблСтрока");
	облИтого 		= Макет.ПолучитьОбласть("облИтого");

	ТабличныйДокумент.Вывести(облШапка);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЛотереяОстатки.ВидЛотереи КАК ВидЛотереи,
		|	ЛотереяОстатки.СуммаОстаток КАК СуммаОстаток
		|ИЗ
		|	РегистрНакопления.Лотерея.Остатки(, ) КАК ЛотереяОстатки
		|ИТОГИ
		|	СУММА(СуммаОстаток)
		|ПО
		|	ОБЩИЕ";
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	
	Пока РезультатЗапроса.Следующий() цикл
		облИтого.Параметры.Сумма = РезультатЗапроса.СуммаОстаток;
		
		ВыборкаВидЛотереи = РезультатЗапроса.Выбрать();	
		Пока ВыборкаВидЛотереи.Следующий() Цикл
			облСтрока.Параметры.Лот = ВыборкаВидЛотереи.ВидЛотереи;
			облСтрока.Параметры.Сумма = ВыборкаВидЛотереи.СуммаОстаток;
			ТабличныйДокумент.Вывести(облСтрока);
		КонецЦикла;
		ТабДок.Вывести(облИтого);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьНаСервере();
КонецПроцедуры
