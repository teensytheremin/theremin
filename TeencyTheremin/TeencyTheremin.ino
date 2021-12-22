#include "ThereminAudio.h"

IntervalTimer pitchInputTimer;
IntervalTimer volumeInputTimer;

AudioSynthWaveformSine   sine1;         
AudioSynthWaveformSine   sine2;        
AudioOutputI2S           i2s1;           
AudioConnection          patchCord1(sine1, 0, i2s1, 0);
AudioConnection          patchCord2(sine2, 0, i2s1, 1);
ThereminAudioControlSGTL5000 codec;

const int ledPin = 13;  // the pin with a LED
bool ledOn = false;
volatile unsigned long pitchSensorValue = 22500; //mHz
volatile unsigned long volumeSensorValue = 1000000; //ppm

int regime = 1;
void simulatePitchInput() {
  
  if(regime == 1) {
    pitchSensorValue = (long) pitchSensorValue * 1.005;
  }
  if(regime == 2) { 
    pitchSensorValue = (long) pitchSensorValue * 0.995;
  }
  
  if(pitchSensorValue > 4000000){
    regime = 2;
  }
  if(pitchSensorValue < 22500){
    pitchSensorValue = 440000;
    volumeSensorValue = 10000;
    regime = 3;
  }
  
  sine1.frequency(pitchSensorValue / 1000.0);
  sine2.frequency(pitchSensorValue / 1000.0);
}
void simulateVolumeInput() {
  
  if(regime == 3) {
    volumeSensorValue = volumeSensorValue + 4000;
  }
  if(regime == 4) { 
    volumeSensorValue = volumeSensorValue - 4000;
  }
  
  if(volumeSensorValue > 1000000){
    regime = 4;
  }
  if(volumeSensorValue < 5000){
    pitchSensorValue = 22500;
    volumeSensorValue = 1000000;
    regime = 1;
  }
}

void setup()
{
  sine1.amplitude(1.0);
  sine2.amplitude(1.0);
  
  pinMode(ledPin, OUTPUT);
  pitchInputTimer.begin(simulatePitchInput, 5000);  // pitch changes every 0.005 seconds
  volumeInputTimer.begin(simulateVolumeInput, 10000);  // volume changes every 0.01 seconds
  
  Serial.begin(115200);
  //while (!Serial) ; // wait for Arduino Serial Monitor
  delay(200);
  
// http://gcc.gnu.org/onlinedocs/cpp/Standard-Predefined-Macros.html
  Serial.print("Begin ");
  Serial.println(__FILE__);
  
  // Proc = 12 (13),  Mem = 2 (8)
  // Audio connections require memory to work.
  // The memory usage code indicates that 10 is the maximum
  // so give it 12 just to be sure.
  AudioMemory(18);
  
  codec.enable();
  codec.volume(0.30);

  Serial.println("setup done");
  
  // Initialize processor and memory measurements
  AudioProcessorUsageMaxReset();
  AudioMemoryUsageMaxReset();
}

float volume;

unsigned long last_time = millis();
void loop()
{
  unsigned long pitchSensorValueCopy;  
  unsigned long volumeSensorValueCopy;

  noInterrupts();
  pitchSensorValueCopy = pitchSensorValue;
  volumeSensorValueCopy = volumeSensorValue;
  interrupts();
 
  if(millis() - last_time >= 1000) {
    Serial.print("Proc = ");
    Serial.print(AudioProcessorUsage());
    Serial.print(" (");    
    Serial.print(AudioProcessorUsageMax());
    Serial.print("),  Mem = ");
    Serial.print(AudioMemoryUsage());
    Serial.print(" (");    
    Serial.print(AudioMemoryUsageMax());
    Serial.println(")");

    if (ledOn == false) {
      ledOn = true;
    } 
    else {
      ledOn = false;
    }
    digitalWrite(ledPin, ledOn);
    Serial.print("regime = ");
    Serial.println(regime);
    Serial.print("pitchSensorValue = ");
    Serial.println(pitchSensorValueCopy);
    Serial.print("volumeSensorValue = ");
    Serial.println(volumeSensorValueCopy);
    Serial.print("volume = ");
    Serial.println(volume);
  
    last_time = millis();
  }

  float v = volumeSensorValueCopy / 1000000.0 / 2.0;
  if (v <= 0.5) { //You can damadge your ears if you use volume > 0.5
    if (v != volume) {
      codec.volume(v);
    }
    volume = v;
  }
}
