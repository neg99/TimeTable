Отображение расписания СтатМода на Ruby+JS.

## Установка и запуск

1. Установите интерпретатор [Ruby](http://rubyinstaller.org/downloads/) версии 1.9, про номер верии см. здесь [cross-compile](https://github.com/sparklemotion/nokogiri/issues/1256)

2. Установите [Bundler](http://gembundler.com/) - Не нужно. Просто запустить cmd из корневой папки и потом >gem install bundle

3. Запустите `bundle install` из корневой директории проекта.

4. Запуститe `ruby app.rb`

5. Теперь можно попасть в расписание как http://127.0.0.1:4567/3course

## Онлайн-версия

Текущая версия приложения доступна по адресу <http://statmod-timetable.heroku.com>

([Heroku](http://www.heroku.com/) - облачная платформа для развёртывания веб-приложений.)

## Используемые компоненты

### [Sinatra](http://www.sinatrarb.com/)

Легковесный веб-фреймворк (Ruby)

### [Haml](http://haml.info)

Шаблонизатор (Ruby).

### [HappyMapper](http://happymapper.rubyforge.org/)

Библиотека для полуавтоматического отображения XML-файлов в классы Ruby.

### [REDIPS.drag](http://www.redips.net/javascript/drag-and-drop-table-content/)

Библиотека для отображения таблиц с огромным числом возможностей (JavaScript).

### [Jeditable](http://www.appelsiini.net/projects/jeditable)

JQuery in-place editor: div-ы по щелчку мыши превращаются в поля ввода текста.
