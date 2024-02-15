extends Node

## This node is responsible for holding all the BLEPeripherals
var peripherals_ : Array = []
var selected_peripheral_ : BLEPeripheral = null
var selected_peripheral_services : Array
var selected_service_ : BLEService = null

@onready
var list_of_services : ItemList = get_node("../BLEUI/ListServices")


signal new_peripheral_stored
signal cleared_stored_peripherals
signal updated_peripheral_services(selected_peripehral_services : Array)

func _on_ble_adapter_found_new_peripheral(id):
	var new_peripheral : BLEPeripheral = instance_from_id(id)
	#new_peripheral.init_services()
	store_new_peripheral(new_peripheral)
	
func store_new_peripheral(new_peripheral : BLEPeripheral):
	peripherals_.append(new_peripheral)
	emit_signal("new_peripheral_stored")


func _on_ble_adapter_started_scan():
	peripherals_.clear()
	emit_signal("cleared_stored_peripherals")

func connect_peripheral(peripheral : BLEPeripheral):
	if (!peripheral.is_peripheral_connected()):
		peripheral.connect_peripheral()
		peripheral.init_services()
	else:
		print_debug(peripheral.identifier(), " is already connected")
		peripheral.init_services()
		peripheral.emit_signal("peripheral_is_connected", peripheral.identifier())
		

func _on_item_list_item_selected(index):
	var peripheral_list : ItemList = get_node("../BLEUI/VBoxContainer/ListPeripherals")
	for peripheral : BLEPeripheral in peripherals_:
		var id = peripheral.get_instance_id()
		if(peripheral.identifier() == peripheral_list.get_item_text(index)):
			select_peripheral(id)


func select_peripheral(id : int):
	selected_peripheral_ = instance_from_id(id)
	print_debug(selected_peripheral_.identifier() ," was selected.")
	connect_peripheral(selected_peripheral_)
	connect_peripheral_to_signals(selected_peripheral_)
	selected_peripheral_.emit_services()


func connect_peripheral_to_signals(peripheral : BLEPeripheral):
	print_debug("Connect ", peripheral.identifier(), " to service signals.")
	peripheral.connect("services_send", _on_services_send)
	peripheral.connect("received_data", _on_received_data)
	print_debug("Is connected to services_send: ", peripheral.is_connected("services_send", _on_services_send))

func _on_services_send(services : Array):
	selected_peripheral_services = services
	emit_signal("updated_peripheral_services",selected_peripheral_services)


func _on_list_services_item_selected(index):
	selected_service_ = selected_peripheral_services[index]
	print_debug(selected_service_.get_uuids())


func _on_received_data(data : String):
	print_debug(data)


func _on_button_subscribe_button_up():
	var uuids = selected_service_.get_uuids()
	selected_peripheral_.subscribe(uuids[0],uuids[1])


func _on_button_unsubscribe_button_down():
	var uuids = selected_service_.get_uuids() 
	selected_peripheral_.unsubscribe(uuids[0],uuids[1])
