# Windows 09.04



* Кастомное собщение о запрете доступа

  https://4sysops.com/archives/file-server-resource-manager-fsrm-part-6-classification-management/

  https://docs.microsoft.com/ru-ru/windows-server/identity/solution-guides/deploy-access-denied-assistance--demonstration-steps-

  http://www.alexandreviot.net/2015/09/27/server-2012-customize-access-denied-on-shared-folder/

  Путь - FSRM administrative tool under Classification Management > Classification Properties > Set Folder Management Properties.

  Указываем путь к папке, добавляем сообщение и готово. Проверить галочку на Access-based enumeration, в "Разрешениях" можно оставить только группу у которой будет доступ на "Фулл".

  Почему-то заработало только после включения этой же функции в групповых политиках (**странно**).

  



- DISKPART: создание RAID и форматирование