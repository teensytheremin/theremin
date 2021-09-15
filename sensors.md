# Digital Theremin sensors

Teensy Theremin has two 3-pin connector (GND, 3.3V, OUT) for interfacing with theremin antenna sensors.

Output signal from sensor is supposed to be 3.3V square wave with duty cycle close to 50%.

Typical frequency of sensor output is 500KHz..2MHz.

Sensor signal frequency will be reduced by 5..7% when hand approaches antenna.

## Current Sensing oscillator sensors

### LTC6752 based oscillator

![LTSpice model](/images/ltspice/current_sensing_oscillator_ltc6752_ltspice_model.png)

