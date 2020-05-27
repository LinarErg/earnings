﻿
&НаСервере
Процедура СформироватьНаСервере()

	Обработка = РеквизитФормыВЗначение("Объект");	
	
	Макет = Обработка.ПолучитьМакет("Макет");
	
	ТабличныйДокумент = ТабДок;
	ТабличныйДокумент.Очистить();
	
	облЗаголовок 	= Макет.ПолучитьОбласть("ОблЗаголовок");
	облШапка 		= Макет.ПолучитьОбласть("облШапка");
	облСтрока 		= Макет.ПолучитьОбласть("ОблСтрока");
	облИтого 		= Макет.ПолучитьОбласть("облИтого");
	облМесяц		= Макет.ПолучитьОбласть("облМесяц");

	ТабличныйДокумент.Вывести(облЗаголовок);
	ТабличныйДокумент.Вывести(облШапка);
	
	Если Объект.ВариантГруппировки = Перечисления.ВариантыГруппировкиОтчетаЗаработок.ПоЗаказчику тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ЗаработокОбороты.Заказчик КАК Заказчик,
			|	ЗаработокОбороты.СуммаОборот КАК СуммаОборот,
			|	ЗаработокОбороты.ПериодМесяц КАК ПериодМесяц
			|ИЗ
			|	РегистрНакопления.Заработок.Обороты(
			|			&НачалоПериода,
			|			&КонецПериода,
			|			Авто,
			|			ВЫБОР
			|				КОГДА &Заказчик = НЕОПРЕДЕЛЕНО
			|					ТОГДА ИСТИНА
			|				ИНАЧЕ Заказчик = &Заказчик
			|			КОНЕЦ) КАК ЗаработокОбороты
			|
			|УПОРЯДОЧИТЬ ПО
			|	СуммаОборот УБЫВ
			|ИТОГИ
			|	СУММА(СуммаОборот)
			|ПО
			|	ОБЩИЕ,
			|	Заказчик";
		
	ИначеЕсли Объект.ВариантГруппировки = Перечисления.ВариантыГруппировкиОтчетаЗаработок.ПоПериоду тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ЗаработокОбороты.Заказчик КАК Заказчик,
			|	ЗаработокОбороты.СуммаОборот КАК СуммаОборот,
			|	ЗаработокОбороты.ПериодМесяц КАК ПериодМесяц
			|ИЗ
			|	РегистрНакопления.Заработок.Обороты(
			|			&НачалоПериода,
			|			&КонецПериода,
			|			Авто,
			|			ВЫБОР
			|				КОГДА &Заказчик = НЕОПРЕДЕЛЕНО
			|					ТОГДА ИСТИНА
			|				ИНАЧЕ Заказчик = &Заказчик
			|			КОНЕЦ) КАК ЗаработокОбороты
			|
			|УПОРЯДОЧИТЬ ПО
			|	ПериодМесяц УБЫВ
			|ИТОГИ
			|	СУММА(СуммаОборот)
			|ПО
			|	ОБЩИЕ,
			|	ПериодМесяц";
	
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Заказчик", ?(ЗначениеЗаполнено(Заказчик),Заказчик,Неопределено));
	Запрос.УстановитьПараметр("КонецПериода", ?(ЗначениеЗаполнено(КонецПериода),КонецПериода,Дата(2999,12,31,23,59,59)));
	Запрос.УстановитьПараметр("НачалоПериода", ?(ЗначениеЗаполнено(НачалоПериода),НачалоПериода,Дата(1,1,1,0,0,0)));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаОбщийИтог = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ВыборкаОбщийИтог.Следующий();		// Общий итог
	
	ТабличныйДокумент.НачатьАвтогруппировкуСтрок();
	
	облИтого.Параметры.Сумма = ВыборкаОбщийИтог.СуммаОборот;
	ТабличныйДокумент.Вывести(облИтого,1);
	
	ВыборкаПериодМесяц = ВыборкаОбщийИтог.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПериодМесяц.Следующий() Цикл
		Если Объект.ВариантГруппировки = Перечисления.ВариантыГруппировкиОтчетаЗаработок.ПоЗаказчику тогда
			облМесяц.Параметры.Месяц = ВыборкаПериодМесяц.Заказчик;
			облМесяц.Параметры.Сумма = ВыборкаПериодМесяц.СуммаОборот;	
		ИначеЕсли Объект.ВариантГруппировки = Перечисления.ВариантыГруппировкиОтчетаЗаработок.ПоПериоду тогда
			облМесяц.Параметры.Месяц = Формат(ВыборкаПериодМесяц.ПериодМесяц, "ДФ='MMММ yyyy'");
			облМесяц.Параметры.Сумма = ВыборкаПериодМесяц.СуммаОборот;
		КонецЕсли;
		ТабличныйДокумент.Вывести(облМесяц,2);
	
		ВыборкаДетальныеЗаписи = ВыборкаПериодМесяц.Выбрать();
	
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			облСтрока.Параметры.Заказчик = ВыборкаДетальныеЗаписи.Заказчик;
			облСтрока.Параметры.Сумма = ВыборкаДетальныеЗаписи.СуммаОборот;
			ТабличныйДокумент.Вывести(облСтрока,3);
		КонецЦикла;
	КонецЦикла;
	
	ТабличныйДокумент.ЗакончитьАвтогруппировкуСтрок();
	ТабличныйДокумент.ПоказатьУровеньГруппировокСтрок(1);

КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Объект.ВариантГруппировки = Перечисления.ВариантыГруппировкиОтчетаЗаработок.ПоПериоду;
	
КонецПроцедуры
