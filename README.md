   # vk-ane

- Подключить библиотеку 
>bin/com.nikaent.ane.vk.ane

- Первая инициализация:
```sh
VK.init(APP_ID);
```
APP_ID - Идентификатор приложения в VK

- Подписаться на события:
```sh
VK.addEventListener(VKEvent, callback);

// VKEvent:
// VKEvent.AUTH_FAILED - ошибка авторизации
// VKEvent.AUTH_SUCCESSFUL - авторизация прошла успешно
// VKEvent.TOKEN_INVALID - ошибка в ключе
```

- Авторизация/логин:
```sh
VK.login(Scope.FRIENDS, Scope.NOTIFICATIONS, ...rest);
```
в параметрах метода перечисляем все нужные Scopes


- Пример запроса в VK api
```sh
VK.api("users.get","id,first_name,last_name", function(str:String):void{
                trace(str);
            });
```
