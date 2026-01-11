class_name GameState
extends Node

signal score_changed(score: int)
signal kills_changed(kills: int)
signal coins_changed(coins: int)
signal time_changed(time_alive: float)
signal game_over

var score: int = 0
var kills: int = 0
var coins: int = 0
var time_alive: float = 0.0
var is_running: bool = false

func start_run():
	score = 0
	kills = 0
	coins = 0
	time_alive = 0.0
	is_running = true

	emit_signal("score_changed", score)
	emit_signal("kills_changed", kills)
	emit_signal("coins_changed", coins)
	emit_signal("time_changed", time_alive)

func end_run():
	is_running = false
	emit_signal("game_over")

func add_kill():
	kills += 1
	emit_signal("kills_changed", kills)

func add_score(amount: int):
	score += amount
	emit_signal("score_changed", score)

func update_time(delta: float):
	if not is_running:
		return
	time_alive += delta
	emit_signal("time_changed", time_alive)
