extends CharacterBody2D

# === НАСТРОЙКИ ДВИЖЕНИЯ ===
var speed = 100      # Скорость движения шарика (пикселей в секунду)
var angle = 0        # Текущий угол на окружности (0-360 градусов)
var radius = 50      # Радиус круговой траектории (пикселей)

# === ФИЗИЧЕСКИЙ ПРОЦЕСС (вызывается 60 раз в секунду) ===
func _physics_process(delta):
	# Время между кадрами: если игра работает на 60 FPS
	# delta ≈ 0.0167 секунды (1 / 60)
	angle += delta * 2  # Каждый кадр увеличиваем угол для вращения
	# За 1 секунду: 0.0334 * 60 ≈ 2 радиана
	# Это примерно 114 градусов в секунду
	# Через 3 секунды угол станет: 0 + 2*3 = 6 радиан
	# В круге 2π радиан ≈ 6.28, значит почти полный круг за 3 секунды

	# Вычисляем новую позицию на окружности:
	# sin(угол) * радиус = координата X
	# cos(угол) * радиус = координата Y
	var new_position = Vector2(
		sin(angle) * radius,  # X координата
		cos(angle) * radius   # Y координата
	)
	
	# Устанавливаем скорость и двигаем шарик
	velocity = new_position * speed * delta  # velocity - встроенная переменная CharacterBody2D
	move_and_slide()  # Метод для движения с физикой и столкновениями

# === ОБРАБОТКА ВВОДА (мышь, клавиатура) ===
func _input(event):
	# Проверяем: была ли нажата левая кнопка мыши?
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:  # 1 = левая кнопка мыши
		var mouse_pos = get_global_mouse_position()  # Получаем глобальные координаты мыши
		
		# Преобразуем глобальные координаты мыши в локальные относительно спрайта
		# affine_inverse() "переворачивает" преобразование координат
		var local_mouse_pos = $Sprite2D.get_global_transform().affine_inverse() * mouse_pos
		
		# Проверяем, находится ли точка клика внутри прямоугольника спрайта
		if $Sprite2D.get_rect().has_point(local_mouse_pos):
			# Если да - запускаем анимацию
			$AnimationPlayer.play("happy_click")
			print("Анимация запущена!")  # Вывод в консоль для отладки
		else:
			print("Клик мимо шарика!")  # Для отладки

# === ПОДГОТОВКА ПРИ ЗАПУСКЕ ===
func _ready():
	# Создаем отдельную анимацию для клика
	create_click_animation()
	print("Шарик инициализирован!")  # Сообщение в консоль при запуске

# === СОЗДАНИЕ АНИМАЦИИ ДЛЯ КЛИКА ===
func create_click_animation():
	# 1. СОЗДАЕМ НОВУЮ АНИМАЦИЮ
	var anim = Animation.new()  # Создаем пустую анимацию
	anim.length = 1  # Устанавливаем длительность: 0.5 секунды
	
	# 2. СОЗДАЕМ ДОРОЖКУ (track) ДЛЯ СВОЙСТВА "ТЕКСТУРА"
	# TYPE_VALUE - тип дорожки для обычных значений (текстур, чисел, цветов)
	var track_idx = anim.add_track(Animation.TYPE_VALUE)
	# Указываем путь к свойству: узел Sprite2D, свойство "texture"
	anim.track_set_path(track_idx, "Sprite2D:texture")
	
	# 3. ДОБАВЛЯЕМ КЛЮЧЕВЫЕ КАДРЫ (keyframes) НА ДОРОЖКУ
	# Время 0.0 сек: Normal 1.png - обычное состояние
	anim.track_insert_key(track_idx, 0.0, load("res://Normal 1.png"))
	# Время 0.2 сек: Smile1.png - улыбка (через 0.2 секунды)
	anim.track_insert_key(track_idx, 0.3, load("res://Smile1.png"))
	# Время 0.4 сек: Sleep1.png - сонное состояние (через 0.4 секунды)
	anim.track_insert_key(track_idx, 0.6, load("res://Sleep1.png"))
	# Время 0.6 сек: Normal.png - сонное состояние (через 0.4 секунды)
	anim.track_insert_key(track_idx, 0.9, load("res://Normal 1.png"))

	# 4. ДОБАВЛЯЕМ АНИМАЦИЮ В ANIMATIONPLAYER
	# get_animation_library("") - получаем основную библиотеку анимаций
	# add_animation() - добавляем анимацию с именем "happy_click"
	$AnimationPlayer.get_animation_library("").add_animation("happy_click", anim)
	
	print("Анимация 'happy_click' создана успешно!")  # Подтверждение создания

# === ВАЖНЫЕ МОМЕНТЫ ДЛЯ ПОНИМАНИЯ: ===
# 1. delta - время между кадрами (примерно 0.016 сек при 60 FPS)
# 2. Vector2 - тип данных для 2D векторов (x, y)
# 3. $Sprite2D - короткая запись для get_node("Sprite2D")
# 4. load() - загружает ресурс (текстуру) во время выполнения
# 5. move_and_slide() - учитывает физику и столкновения
# 6. CharacterBody2D - специальный тип узла для персонажей с физикой
