extends BLEAdapter

var ms_to_scan = 2500

func _ready():
	init_adapter()
	var adapterList = getAdapterList()


func _on_btn_start_scan_button_down():
	start_scan(ms_to_scan)


func _on_spin_box_value_changed(ms):
	ms_to_scan = ms
