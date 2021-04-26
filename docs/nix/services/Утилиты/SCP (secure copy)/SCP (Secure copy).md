### SCP (Secure copy)

---

**SCP** (от [англ.](https://ru.wikipedia.org/wiki/Английский_язык) *secure copy*) — утилита и протокол копирования файлов между компьютерами, использующий в качестве транспорта шифрованный **SSH**. Сходная по функционалу утилита — **sftp**.

В UNIX-подобных операционных системах одноимённая (`scp`) утилита удалённого копирования файлов часто входит в состав пакета openssh.

#### Применение

* Команда копирования локального SourceFile на удалённый хост:

  ```
  scp SourceFile user@host:/directory/TargetFile
  ```

* Команда копирования SourceFile с удалённого хоста:

  ```
  scp user@host:/directory/SourceFile TargetFile
  ```

* Если ssh работает на другом порту, то тогда указывается порт с атрибутом -P:

  ```
  scp -P port user@host:/directory/SourceFile /directory/TargetFile 
  ```

* Копирование SourceFolder с удалённого хоста внутрь локального TargetFolder (на локальном хосте получится, что SourceFolder будет находиться внутри TargetFolder):

  ```
  scp -r user@host:/directory/SourceFolder TargetFolder
  ```