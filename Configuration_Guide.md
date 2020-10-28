# Configuration File Guide

The configuration file is located at `/etc/moxa-configs/moxa-module-control.conf`.

This document is for configuration file version "1.5.0". It consists of 5 parts.

---
### 1. Config file version

This part is quite simple.

#### Example
```
CONFIG_VERSION=1.5.0
```

---
### 2. Platform configuration for modules

This part contains modules definition on platform.

#### Variables
* `NUM_OF_MODULE_SLOTS`: The number of module slots on the platform.
* `MODULE_SLOT_X_SYSPATHS`: The system paths of module slot X. X stands for the module index. (This attribute should be an array because one module slot can have different system paths on a platform.)

#### Example
```
NUM_OF_MODULE_SLOTS=1
MODULE_SLOT_1_SYSPATHS=(
	"/sys/devices/platform/ocp/47400000.usb/47401400.usb/musb-hdrc.0.auto/usb1/1-1"
)
``` 


---
### 3. Common functions

This part just put some functions which are used in `mx-module-ctl interfaces` & `moxa-module-control.service interfaces`.

---
### 4. mx-module-ctl interfaces

This part contains interfaces for `mx-module-ctl` to control modules on platform.

#### Interfaces
* `module_power_on`
	* Set the module power on.
	* Number of arguments: 1
		* $1: module slot ID
* `module_power_off`
	* Set the module power off.
	* Number of arguments: 1
		* $1: module slot ID
* `module_reset_on`
	* Pull the module's reset pin up.
	* Number of arguments: 1
		* $1: module slot ID
* `module_reset_off`
	* Pull the module's reset pin down.
	* Number of arguments: 1
		* $1: module slot ID
* `module_switch_sim`
	* Set the module's SIM slot to the given number.
	* Number of arguments: 2
		* $1: module slot ID
		* $2: module SIM slot number
* `module_power_status`
	* Read the module power status
	* Number of arguments: 1
		* $1: module slot ID
* `module_sim_slot`
	* Get the module's SIM slot numbert.
	* Numbert of arguments: 1
		* $1: module slot ID

#### Example
```
module_power_on() {
	_set_gpio 481 "out" 1
}

module_power_off() {
	_set_gpio 481 "out" 0
}

module_reset_on() {
	_set_gpio 482 "out" 1
}

module_reset_off() {
	_set_gpio 482 "out" 0
}

module_switch_sim() {
	local sim=${2}
	
	if [ ${sim} -eq 1 ]; then
		_set_gpio 480 "out" 1
	elif [ ${sim} -eq 2 ]; then
		_set_gpio 480 "out" 0
	fi
}

module_power_status() {
	local slot="${1}"
	local value

	if [ "${slot}" -eq 1 ]; then
		value=$(_get_gpio 7)
		if [ "${value}" -eq 0 ]; then
			echo "on"
		elif [ "${value}" -eq 1 ]; then
			echo "off"
		else
			echo "unknown"
			return 1
		fi
	fi
	return 0
}

module_sim_slot() {
	local slot="${1}"
	local val=""

	if [ "${slot}" -eq 1 ]; then
		val=$(gpio_get_value 480)
	fi
	if [ ${val} -eq 1 ]; then
		echo "SIM Slot: 1"
	elif [ ${val} -eq 0 ]; then
		echo "SIM Slot: 2"
	fi
}

```

---
### 5. moxa-module-control.service interfaces

This part contains 2 functions named `module_service_start` & `module_service_stop`.

#### Interfaces
* `module_service_start`
	* Invoked by moxa-module-control systemd service on system boot. You can define some actions to be done on boot in this function.
	* Number of arguments: 0
* `module_service_stop`
	* Invoked by moxa-module-control systemd service on system shutdown. You can define some actions to be done on shutdown in this function.
	* Number of arguments: 0

#### Example
```
module_service_start() {
	module_switch_sim 1 1
}
```

As example showed, if nothing to be done, just don't define the function.

---
## Full Example

This is the full example for UC-5112-LX:

```
#
# Config file version
#
CONFIG_VERSION=1.3.0

#
# Platform configuration for modules
#
NUM_OF_MODULE_SLOTS=1
MODULE_SLOT_1_SYSPATHS=(
	"/sys/devices/platform/ocp/47400000.usb/47401400.usb/musb-hdrc.0.auto/usb1/1-1"
)

#
# Common functions
#
_set_gpio() {
	local gpio=${1}
	local direction=${2}
	local value=${3}

	if [ ! -e "/sys/class/gpio/gpio${gpio}" ]; then
		echo ${gpio} > "/sys/class/gpio/export"
		echo ${direction} > "/sys/class/gpio/gpio${gpio}/direction"
	fi
	if [ X"${direction}" == X"out" ]; then
		echo ${value} > "/sys/class/gpio/gpio${gpio}/value"
	fi
}

#
# mx-module-ctl interfaces
#
module_power_on() {
	_set_gpio 481 "out" 1
}

module_power_off() {
	_set_gpio 481 "out" 0
}

module_reset_on() {
	_set_gpio 482 "out" 1
}

module_reset_off() {
	_set_gpio 482 "out" 0
}

module_switch_sim() {
	local sim=${2}
	
	if [ ${sim} -eq 1 ]; then
		_set_gpio 480 "out" 1
	elif [ ${sim} -eq 2 ]; then
		_set_gpio 480 "out" 0
	fi
}

#
# moxa-module-control.service interfaces
#
module_service_start() {
	module_switch_sim 1 1
}
```
