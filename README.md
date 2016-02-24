# vk-ane

подключить библиотеку bin/com.nikaent.ane.vk.ane

Первая инициализация:
	VK.init(APP_ID);

APP_ID - Идентификатор приложения в VK


Подписаться на события:
	VK.addEventListener(VKEvent, callback);

VKEvent:
	VKEvent.AUTH_FAILED - ошибка авторизации
	VKEvent.AUTH_SUCCESSFUL - авторизация прошла успешно
	VKEvent.TOKEN_INVALID - ошибка в ключе


Авторизация/логин:
	VK.login(Scope.FRIENDS, Scope.NOTIFICATIONS, ...rest);
	в параметрах метода перечисляем все нужные Scopes