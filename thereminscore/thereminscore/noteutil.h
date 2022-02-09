#ifndef NOTEUTIL_H
#define NOTEUTIL_H


// Note <-> Frequency conversions

// convert MIDI note number to frequency (Hz) for A4=440.0Hz
float midiNoteToFrequency(float note);

// convert frequency (Hz) to MIDI note number for A4=440.0Hz
float frequencyToMidiNote(float freq);

// convert dB to gain multiplier (x1.0 gain == 0dB)
float dbToGain(float db);

// convert gain multiplier to dB (x1.0 gain == 0dB)
float gainToDb(float gain);


#define MIN_NOTE 0.0f
#define MAX_NOTE 127.0f

#define MAX_VOLUME_DB 10.0f
#define MIN_VOLUME_DB (-110.0f)

// ensure volume is between MIN_VOLUME_DB and MAX_VOLUME_DB
float clampVolume(float volume);

// ensure pitch note is between MIN_NOTE and MAX_NOTE
float clampNote(float note);

#endif // NOTEUTIL_H
