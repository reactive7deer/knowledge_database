### GPO (Group Policy Object)

---

#### **Запрет анимации на первый вход пользователя**

- Путь - **Computer** **Configuration ->** **Administrative** **Templates ->** **System ->** **Logon**
- Параметр - **"Show first sign-in animation"**



#### **Добавление доменной группы в состав локальных администраторов на всех клиентских компьютерах**

1. Способ **№1**

   - Путь - **Computer Configuration –> Preferences –> Control Panel Settings –> Local Users and Groups**
   - Действие - ПКМ -> New -> Local Group
   
     ![image-20200922170023471](C:\Users\Delete\AppData\Roaming\Typora\typora-user-images\image-20200922170023471.png)

2. Способ **№2** (**Устаревший**)

   * Путь - **Computer Configuration –> Windows Settings –> Security Settings –> Restricted Groups**

   * Действие - ПКМ -> Add Group. Выбрать необходимую группу. Затем в области **"This group is a member of"** добавить группу, в которую будет включена наша выбранная группа (например, **Administrators**).

     ![image-20201104014015243](C:\Users\Delete\AppData\Roaming\Typora\typora-user-images\image-20201104014015243.png)



#### **Настройка стартовой страницы для IE и Microsoft Edge**

- IE (1-ый вариант)

   - Путь - **User Configuration** -> **Policies** -> **Administrative** **Templates** -> **Windows** **Components** -> **Internet** **Explorer**
   - Параметр - **"Disable changing home page settings"**
- IE (2-ой вариант)
   * Путь - **User Configuration** -> **User Configuration** -> **Preferences** -> **Internet Settings**
   * Действие - ПКМ -> New -> IE 10. Указать ссылку домашней страницы, нажать F5 для изменения цвета линии в области ввода, переключить пункт **Startup** на **"Start with home page"**
- Edge
   * Необходимо - установить дополнение **"Windows 10 and Windows Server 2016 ADMX"**. После установки, из папки (`C:\Programm Files(x86)\Microsoft Group Policy\Windows 10…`) нужно скопировать папку **"PolicyDefinitioins"** в папку размещение доменных политик (`\\<server_name>\Sysvol\<domain_name>\Polices`)
   * Путь - **Computer Configuration** -> **Administrative Templates** -> **Windows Components** -> **Microsoft Edge** -> **Configure Home Pages**



#### **Отключение "Режима  сна"**

* Путь - **Computer Configuration** -> **Policies** -> **Administrative** **Templates** -> **System** -> **Power Management** -> **Sleep Settings**
* Параметр - **"Allow standby states (S1-S3) when sleeping"** (DIsabled)



#### **Создание ярлыка**

* Путь - **User Configuration** \ **Computer Configuration** -> **Preferences** -> **Windows Settings** -> **Shortcuts**  

* Действие - **ПКМ** -> **New** -> **Shortcut**. **Action** оставить **"Update"**, **Name** - имя создаваемого ярлыка, **Location** - место создание ярлыка, **Target Path** - расположение оригинального приложения.

  ![image-20201104021245997](C:\Users\Delete\AppData\Roaming\Typora\typora-user-images\image-20201104021245997.png)



#### **Заставка рабочего стола**

* Путь - **User Configuration** -> **Policies** -> **Administrative Templates** -> **Desktop** -> **Desktop**
* Параметр - **"Desktop Wallpaper"**. Путь к изображению можно установить как локальный, так и на сетевую папку.



#### **Перемещаемые профили**

* Путь - **Computer Configuration** -> **Policies** -> **Administrative** **Templates** -> **System** -> **User Profiles**
* Параметр - **Set roaming profile path for all users logging onto this computer ** (Enabled и указать путь до шары в которой будет храниться папки профилей)



#### **Уведомление на доступ к папке без прав**

* Путь - **Computer Configuration** -> **Policies** -> **Administrative** **Templates** -> **System** -> **Access-Denied-Assistance**
* Параметр - **Enable access-denied assistance on client for all file types** (Enabled)
* Параметр - **Customize message for Access Denied errors** (Enabled и написать текст будущего уведомления)
  * Макросы, для удобства:
    1. **[Original File Path]** — путь к файлу;
    2. **[Original File Path Folder]** — путь к родительской папке;
    3. **[Admin Email]** — email администратора ресурса;
    4. **[Data Owner Email]** — email владельца ресурса.