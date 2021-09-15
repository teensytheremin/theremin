# Sensors

In theremin sensor, we need to measure antenna capacitance with high precision, and fast enough.

Typical antenna capacitance is 8..10pF if there is no hand near antenna.

When hand is close to antenna, it adds 1.5 .. 2 pF to antenna C.

While hand is moved from antenna, each 10cm of distance reduces C introduced by hand by 3.5 times.

Total antenna C varies only by 15..20% for different hand distances.

To measure C we can use RC delay or LC tank resonance. For RC, measured value is proportional to C, while for LC - to sqrt(C). In absolute values, this leads to 20% of measured value changes for RC approach, and 8% for LC.
Although at first sight, RC looks more sensitive (output value is changed two times more than one from LC), in practice RC sensor can be used for toys with short working hand to antenna distance.

Antenna in theremin receives a lot of RF noise. With RC approach, voltage swing on antenna is limited by power supply voltage. With high Q LC tank, voltage on antenna exceeds power supply voltage by 10..200 times.
Noise received by antenna has the same level for both RC and LC, but voltage swing is much higher for LC, so signal to noise ratio is 10-100 times better just due to bigger voltage swing.
As well, LC tank filters out all frequencies outside its resonance band.

With LC approach, there are two possible methods to measure C in LC. We can either make LC oscillator and measure its frequency, or pass some drive signal with frequency close to LC resonance and measure phase shift between drive signal and LC current or voltage.
For Teensy Theremin, we will use LC osillator as sensor analog front end.

Teensy Theremin has two 3-pin connector (GND, 3.3V, OUT) for interfacing with theremin antenna sensors.

Output signal from sensor is supposed to be 3.3V square wave with duty cycle close to 50%.

Typical frequency of sensor output is 500KHz..2MHz.

Sensor signal frequency will be reduced by 5..7% when hand approaches antenna.

Almost any LC oscillator can be used with Teensy Theremin, while it meets signal requirements.


## Current Sensing oscillator sensors

### LTC6752 based oscillator

![LTSpice model](/images/ltspice/current_sensing_oscillator_ltc6752_ltspice_model.png)

