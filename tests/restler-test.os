#Использовать asserts
#Использовать moskito
#Использовать "../src"

Функция ПолучитьСписокТестов(МенеджерТестирования) Экспорт
    
    МассивТестов = Новый Массив;
    МассивТестов.Добавить("ТестДолжен_ПроверитьЧтоРаботаетМетодGET");
    МассивТестов.Добавить("ТестДолжен_ПроверитьЧтоРаботаетУстановкаЗаголовков");
    МассивТестов.Добавить("ТестДолжен_ПроверитьЧтоПолученыЗаголовкиОтвета");
    МассивТестов.Добавить("ТестДолжен_РазобратьЗаголовокНавигацииПерваяСтраница");
    
    Возврат МассивТестов;
    
КонецФункции

Процедура ТестДолжен_ПроверитьЧтоРаботаетМетодGET() Экспорт

	ЗаглушкаСоединения = Мок.Получить(Новый HTTPСоединение("localhost"));
	
	ЗаглушкаОтвета = Мок.Получить(Тип("HTTPОтвет"));
	ЗаглушкаОтвета.Когда().ПолучитьТелоКакСтроку().ТогдаВозвращает("{""prop"": ""testvalue""}");
	ЗаглушкаОтвета.КодСостояния = 200;

	ЗаглушкаСоединения.Когда().Получить(Новый HTTPЗапрос("/point/document")).ТогдаВозвращает(ЗаглушкаОтвета);

	Клиент = Новый КлиентВебAPI();
	Клиент.ИспользоватьСоединение(ЗаглушкаСоединения);

	Документ = Клиент.Получить("/point/document");

	Ожидаем.Что(Документ).ИмеетТип("Соответствие");
	Ожидаем.Что(Документ["prop"]).Равно("testvalue");

КонецПроцедуры

Процедура ТестДолжен_ПроверитьЧтоРаботаетУстановкаЗаголовков() Экспорт
	
	Клиент = Новый КлиентВебAPI();
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Test", "Value");
	Клиент.УстановитьЗаголовки(Заголовки);
	Запрос = Клиент.ПолучитьHTTPЗапрос("/test");

	Ожидаем.Что(Запрос.Заголовки["Test"], "Value");

КонецПроцедуры

Процедура ТестДолжен_ПроверитьЧтоПолученыЗаголовкиОтвета() Экспорт

	ЗаглушкаСоединения = Мок.Получить(Новый HTTPСоединение("localhost"));
	
	ЗаголовкиОтвета = Новый Соответствие;
	ЗаголовкиОтвета["Link"] = "<https://api.github.com/search/code?q=addClass+user%3Amozilla&page=2>; rel=""next""";
	ЗаглушкаОтвета = Мок.Получить(Тип("HTTPОтвет"));
	ЗаглушкаОтвета.КодСостояния = 200;
	ЗаглушкаОтвета.Заголовки = ЗаголовкиОтвета;

	ЗаглушкаСоединения.Когда().Получить(Новый HTTPЗапрос("/point/document")).ТогдаВозвращает(ЗаглушкаОтвета);

	Клиент = Новый КлиентВебAPI();
	Клиент.ИспользоватьСоединение(ЗаглушкаСоединения);

	Клиент.Получить("/point/document");

	ЗаголовкиОтветаТест = Клиент.ПолучитьЗаголовкиОтвета();
	Ожидаем.Что(ЗаголовкиОтветаТест).ИмеетТип("Соответствие");
	Ожидаем.Что(ЗаголовкиОтветаТест["Link"]).Равно("<https://api.github.com/search/code?q=addClass+user%3Amozilla&page=2>; rel=""next""");

КонецПроцедуры

Процедура ТестДолжен_РазобратьЗаголовокНавигацииПерваяСтраница() Экспорт

	ЗаглушкаСоединения = Мок.Получить(Новый HTTPСоединение("localhost"));
	
	ЗаголовкиОтвета = Новый Соответствие;
	ЗаголовкиОтвета["Link"] = "Link: <https://api.github.com/search/code?q=addClass+user%3Amozilla&page=2>; rel=""next"",<https://api.github.com/search/code?q=addClass+user%3Amozilla&page=34>; rel=""last""";
	
	ЗаглушкаОтвета = Мок.Получить(Тип("HTTPОтвет"));
	ЗаглушкаОтвета.КодСостояния = 200;
	ЗаглушкаОтвета.Заголовки = ЗаголовкиОтвета;

	ЗаглушкаСоединения.Когда().Получить(Новый HTTPЗапрос("/point/document")).ТогдаВозвращает(ЗаглушкаОтвета);

	Клиент = Новый КлиентВебAPI();
	Клиент.ИспользоватьСоединение(ЗаглушкаСоединения);

	Клиент.Получить("/point/document");
	Навигатор = Новый НавигаторСтраниц(Клиент);

	Ожидаем
		.Что(Навигатор.АдресСтраницы("next"))
		.Равно("https://api.github.com/search/code?q=addClass+user%3Amozilla&page=2")
		.Что(Навигатор.АдресСтраницы("last"))
		.Равно("https://api.github.com/search/code?q=addClass+user%3Amozilla&page=34")
		.Что(Навигатор.АдресСтраницы("first"))
		.Равно(Неопределено);

КонецПроцедуры