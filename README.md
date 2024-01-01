# Home Assistant Add-on: syrlex2mqtt

The SYR water softening units of the LEX Plus series, e.g. LEX Plus 10 Connect or LEX Plus 10 S Connect, are sharing their status with the SYR Connect cloud and receiving commands and settings changes from it. The SYR Connect cloud can be either accessed through the [SYR Connect web interface](https://syrconnect.de/) or the [SYR App](https://www.syr.de/de/SYR_App). This add-on uses [syrlex2mqtt](https://github.com/Richard-Schaller/syrlex2mqtt) which simulates the SyrConnect cloud and makes the SYR water softening units of the LEX Plus series available via MQTT and thus Home Assistant.

## Features

For supported features see [https://github.com/Richard-Schaller/syrlex2mqtt](https://github.com/Richard-Schaller/syrlex2mqtt).

## Supported Devices

For supported devices see [https://github.com/Richard-Schaller/syrlex2mqtt](https://github.com/Richard-Schaller/syrlex2mqtt).

## Setup

Setting up this software involves multiple steps:

- Find out the IP of your Home Assistant Server. For the following example we will assume it is 192.168.178.42.
- Install and start this add-on. For a first set up you may want to enable verbose logging.
- Install and start the add-on `Mosquitto broker`
- Next, a DNS server needs to be installed: Therefore install the Home Assistant add-on `Dnsmasq`. In the configuration tab of Dnsmasq, enable `Log Queries` and put the following under `Hosts`; replace 192.168.178.42 with the IP of your Home Assistant Server:
```
- host: connect.saocal.pl
  ip: 192.168.178.42
- host: www.husty.pl
  ip: 192.168.178.42
- host: husty.pl
  ip: 192.168.178.42
- host: syrconnect.de
  ip: 192.168.178.42
- host: firmware.syrconnect.de
  ip: 192.168.178.42
- host: syrconnect.consoft.de
  ip: 192.168.178.42
```

- Configure your SYR water softening unit to use a static IP, gateway and DNS server by using the on-screen display of the device and going to Settings/Network. Set the following settings
  - DHCP-Client: off
  - IP-Address:&nbsp; &lt;unused IP&gt;, e.g. 192.168.178.201
  - Subnet mask:&nbsp; &lt;subnet mask of your network&gt;, likely 255.255.255.0
  - Default Gateway:&nbsp; &lt;IP of your router&gt;, e.g. 192.168.178.1
  - DNS server:&nbsp; &lt;IP of your Home Assistant Server&gt;, e.g. 192.168.178.42
  - Save the settings and then restart your water softening unit by interrupting power supply
- Check that the set up is working:
  - Look at the log of Dnsmasq to see if the SYR water softening unit tried to resolve any of the mention domains 
  - Look at the output of syrlex2mqtt to see if a device is connecting with syrlex2mqtt
  - Check if a new device is showing up in your MQTT broker, e.g. with [MQTT explorer](http://mqtt-explorer.com/).
- If everything went fine you should find a new device in your MQTT integration, e.g. named 'LEXplus10S'

## Configuration Options


Option |  Description 
-|-
http server port | The port to listen for incoming connections from the SYR water softening unit. The unit expects to be able to communicate with port 80.
https server port | The port to listen for incoming connections from the SYR water softening unit. The unit expects to be able to communicate with port 443.
verbose logging | Set to `true` to get log output about the communication with the SYR water softening unit
additional_properties | A comma separated list of additional properties to request from the SYR water softening unit, e.g. `TOF, CWF` to get statistics about the water consumption of the current day and week (see description of the [SYR Connect Protocol](https://github.com/Richard-Schaller/syrlex2mqtt/blob/main/doc/syrconnect-protocol.md) for further information). The properties are exposed via MQTT under their name, e.g. `TOF` and `CWF`.
