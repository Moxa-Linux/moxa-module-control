# moxa-module-control

`moxa-module-control` is a utility for controlling modules on platform. Including power control, module detection, initialize setting, and SIM slot switching (for Cellular modules) features.

## Rationale

The modules on platform should be defined in configuration file `/etc/moxa-configs/moxa-module-control.conf`.

### - systemd service

`moxa-module-control.service` will be started/stopped by systemd. The service will execute `moxa-module-control-srv` script, which invoke `module_service_start` & `module_service_stop` function defined in the configuration file `/etc/moxa-configs/moxa-module-control.conf`. So you can define some action to be done on system boot or shutdown.

### - mx-module-ctl utility

`mx-module-ctl` utility provides module controlling functions with simple interface for user. This utility load the configuration file `/etc/moxa-configs/moxa-module-control.conf` to control the modules.

## Usage

Usage of `mx-module-ctl` utility version "1.5.0":
```
Usage:
	mx-module-ctl [Options]

Operations:
	-v, --version
		Show utility version
	-s, --slot <module_slot_id>
		Select module slot
	-p, --power on|off
		Power on/off module
	-r, --reset on|off
		Set reset pin to high(on)/low(off) to slot
	-i, --sim 1|2
		Select sim card slot
	-P, --power-status
		Get power status
	-I, --sim-slot
		Get SIM slot

Example:
	Power on module 1
	# mx-module-ctl -s 1 -p on

	Set module 2 reset pin to high
	# mx-module-ctl -s 2 -r on

	Select SIM 2 for module 1
	# mx-module-ctl -s 1 -i 2

	Get power status of module 1
	# mx-module-ctl -s 1 -P

	Get current SIM slot of module 1
	# mx-module-ctl -s 1 -I
```

## Documentation

[Configuration File Guide](/Configuration_Guide.md)

