## Distributed systems of data storage lab work 1

### Задание

Используя сведения из системных каталогов, сформировать запрос, реализующий полнотекстовый поиск по исходному коду 
всех процедур, функций и триггеров в пределах заданной схемы. Поиск должен осуществляться независимо от регистра 
символов в строке запроса. Полученная информация должна быть представлена в виде списка следующего вида:

```text
 Текст запроса: Н_Люди

 No. Имя объекта	   # строки	  Текст
 --- -------------------   -------------  --------------------------------------------
   1 MyFunction1           16		  SELECT * FROM н_люди WHERE
   2 MyProcedure1	   42		  INSERT INTO Н_ЛЮДИ
		...
```

Программу оформить в виде процедуры.


### Структура

* [text_finder.sql](./text_finder.sql) - процедура поиска по исходному коду функций, процедур, триггеров (триггерных функций)
* [def_finder.sql](./def_finder.sql) - процедура поиска по объявлению функций, процедур, триггеров