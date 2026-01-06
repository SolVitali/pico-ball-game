extends CharacterBody2D

# === НАСТРОЙКИ ===
var speed = 100.0
var angle = 0.0
var radius = 50.0
var center = Vector2.ZERO

# === ЗАПУСК ===
func _ready():
	center = position
	print("✅ Balloon ready")
	
	# СОЗДАЕМ Sprite2D если его нет
	if not has_node("Sprite2D"):
		var sprite = Sprite2D.new()
		sprite.name = "Sprite2D"
		add_child(sprite)
		sprite.texture = load("res://Normal1.png")  # Без пробела!
	
	# СОЗДАЕМ AnimationPlayer если его нет
	if not has_node("AnimationPlayer"):
		var anim_player = AnimationPlayer.new()
		anim_player.name = "AnimationPlayer"
		add_child(anim_player)
	
	# Создаём анимацию
	create_click_animation()

# === ДВИЖЕНИЕ ===
func _physics_process(delta):
	angle += delta * 2.0
	position.x = center.x + sin(angle) * radius
	position.y = center.y + cos(angle) * radius

# === КЛИК ===
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		var mouse_pos = get_global_mouse_position()
		var sprite = $Sprite2D
		
		# Простая проверка расстояния (вместо сложного преобразования)
		if position.distance_to(mouse_pos) < radius * 2:
			$AnimationPlayer.play("happy_click")
			print("Анимация запущена!")

# === АНИМАЦИЯ ===
func create_click_animation():
	var anim = Animation.new()
	anim.length = 1.0
	
	# Дорожка для текстуры
	var track_idx = anim.add_track(Animation.TYPE_VALUE)
	anim.track_set_path(track_idx, "Sprite2D:texture")
	
	# Загружаем текстуры (с проверкой)
	var tex1 = load("res://Normal1.png") if ResourceLoader.exists("res://Normal1.png") else null
	var tex2 = load("res://Smile1.png") if ResourceLoader.exists("res://Smile1.png") else null
	var tex3 = load("res://Sleep1.png") if ResourceLoader.exists("res://Sleep1.png") else null
	
	# Ключевые кадры (с проверкой на null)
	if tex1:
		anim.track_insert_key(track_idx, 0.0, tex1)
	if tex2:
		anim.track_insert_key(track_idx, 0.3, tex2)
	if tex3:
		anim.track_insert_key(track_idx, 0.6, tex3)
	if tex1:
		anim.track_insert_key(track_idx, 0.9, tex1)
	
	# Добавляем анимацию
	$AnimationPlayer.add_animation("happy_click", anim)
	print("Анимация создана")
