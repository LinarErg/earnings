﻿
Процедура ОбработкаПроведения(Отказ, Режим)

	// регистр РасходДенег 
	Движения.РасходДенег.Записывать = Истина;
	Движение = Движения.РасходДенег.Добавить();
	Движение.Период 		= Дата;
	Движение.РегулярныйРасход = РегулярныйРасход;
	Движение.СтатьяРасходов = СтатьяРасходов;
	Движение.СуммаРасхода 	= Сумма;

КонецПроцедуры
