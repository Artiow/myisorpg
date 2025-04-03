class_name Platform2D
extends StaticBody2D

@onready var collision: CollisionShape2D = $CollisionShape
@onready var monitoring_area: Area2D = $MonitoringArea


func drop_through():
	_enable_monitoring.call_deferred()


func _on_monitoring_area_body_entered(_body: Node2D):
	_disable_collision.call_deferred()


func _on_monitoring_area_body_exited(_body: Node2D):
	_enable_collision.call_deferred()


func _enable_monitoring():
	monitoring_area.monitoring = true


func _disable_collision():
	collision.disabled = true


func _enable_collision():
	collision.disabled = false
	monitoring_area.monitoring = false
