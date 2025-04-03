extends Area2D

@onready var _pickup_animation: Callable = $PickupAnimation.play.bind(&"pickup")


func _on_body_entered(body: Node2D):
	if body is Player2D:
		body.collect(&"coin")
		_pickup_animation.call()
