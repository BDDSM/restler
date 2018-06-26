
Перем мКлиент;
Перем мНавигация;

Перем Лог;

Процедура ПриСозданииОбъекта(Клиент)
	мКлиент = Клиент;
	Лог = Логирование.ПолучитьЛог("oscript.lib.restler");
	ОбновитьНавигацию();
КонецПроцедуры

Процедура РазобратьНавигацию(Знач Заголовки)
	
	мНавигация      = Новый Соответствие;
	СсылкиНавигации = Заголовки["Link"];

	Если СсылкиНавигации = Неопределено Тогда
		Лог.Отладка("Не обнаружен заголовок Link");
		Возврат;
	КонецЕсли;

	Паттерн = "<(.+)>;\s*rel=""([a-z]+)""";
	Выражение = Новый РегулярноеВыражение(Паттерн);
	Выражение.Многострочный = Истина;

	Лог.Отладка("Заголовок навигации: %1", СсылкиНавигации);
	Совпадения = Выражение.НайтиСовпадения(СсылкиНавигации);
	Лог.Отладка("Совпадений: %1", Совпадения.Количество());
	Для Каждого Совпадение Из Совпадения Цикл
		Ключ     = Совпадение.Группы[2].Значение;
		Значение = Совпадение.Группы[1].Значение;
		мНавигация.Вставить(Ключ, Значение);
	КонецЦикла;

КонецПроцедуры

Функция АдресСтраницы(Знач Ключ) Экспорт
	Возврат мНавигация[Ключ];
КонецФункции

Функция Получить(Знач КлючНавигации) Экспорт
	Ответ = мКлиент.Получить(мНавигация[КлючНавигации]);
	ОбновитьНавигацию();
	Возврат Ответ;
КонецФункции

Процедура ОбновитьНавигацию() Экспорт
	РазобратьНавигацию(мКлиент.ПолучитьЗаголовкиОтвета());
КонецПроцедуры