/// / © Copyright 2014-2022, Juan Linietsky, Ariel Manzur and the Godot
/// community / (CC-BY 3.0)
#ifndef GDEXTENSIONSIMPLEBLE_H
#define GDEXTENSIONSIMPLEBLE__H

// We don't need windows.h in this plugin but many others do and it throws up on
// itself all the time So best to include it and make sure CI warns us when we
// use something Microsoft took for their own goals....
#ifdef WIN32
#include <windows.h>
#endif

#include <godot_cpp/classes/ref.hpp>
#include <simpleble/SimpleBLE.h>
#include <simpleble/Utils.h>

#include "bleadapter.h"
#include "bleperipheralmanager.h"

#include <string>
#include <vector>

using namespace godot;

class GDExtensionSimpleBLE : public RefCounted {
  GDCLASS(GDExtensionSimpleBLE, RefCounted);

private:
  std::unique_ptr<BLEPeripheralManager> peripheralManager_;

protected:
  static void _bind_methods();

public:
  GDExtensionSimpleBLE();
  ~GDExtensionSimpleBLE();
};

#endif // GDEXTENSIONSIMPLEBLE_CLASS_H
