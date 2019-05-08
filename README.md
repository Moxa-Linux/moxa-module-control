# moxa-module-control

`moxa-module-control` is a utility for controlling modules on platform. Including power control, module detection, initialize setting, and SIM slot switching (for Cellular modules) features.

## Rationale

![rationale](/rationale.png)

The modules on platform should be defined in configuration file `/etc/moxa-configs/moxa-module-control.conf`.

### - uevents & udev rule

Once a module is detected by kernel, kernel will trigger uevents. The udev rule `88-moxa-module-control-probe.rules` will check if the incoming uevent matches our target modules. If so, call `moxa-module-control-probe` for further actions. `moxa-module-control-probe` will load the configuration file `/etc/moxa-configs/moxa-module-control.conf` and get module information from platform. Finally update the module status to the directory `/etc/moxa-module-control/status.d/`.

### - systemd service

`moxa-module-control.service` will be started/stopped by systemd. The service will execute `moxa-module-control-src` script, which invoke `module_service_start` & `module_service_stop` function defined in the configuration file `/etc/moxa-configs/moxa-module-control.conf`. So you can define some action to be done on system boot or shutdown.

### - mx-module-ctl utility

`mx-module-ctl` utility provides module controlling functions with simple interface for user. This utility load the configuration file `/etc/moxa-configs/moxa-module-control.conf` and get module status from the directory `/etc/moxa-module-control/status.d/`, to control the modules or show their information.

## Usage

Usage of `mx-module-ctl` utility version "1.3.0":
```
Usage:
	mx-module-ctl [Options]

Operations:
	-v,--version
		Show utility version
	-l,--list
		List module slots
	-s,--slot <module_slot_id>
		Select slot
	-p,--power on|off
		Power on/off module
	-r,--reset on|off
		Reset module
	-i,--sim 1|2
		Select sim card slot

Example:
	Power on module 1
	# mx-module-ctl -s 1 -p on

	Reset module 2
	# mx-module-ctl -s 2 -r on

	Select SIM 2 for module 1
	# mx-module-ctl -s 1 -i 2
```

## Modules Supported list

* Wi-Fi modules
	* SparkLAN WPEQ-160ACN
* Cellular modules
	* Gemalto ELS61
	* Huawei ME909s-821
	* Sierra MC7304/MC7354
	* u-blox TOBY L2 Series
	* Telit LE910C1-NS/NF

## Documentation

[Configuration File Guide](/Configuration_Guide.md)

