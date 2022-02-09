#include "noteutil.h"
#include <math.h>

#define BASE_NOTE_FREQUENCY 440.0f

// convert MIDI note number to frequency (Hz) for A4=440.0Hz
float midiNoteToFrequency(float note) {
    return (BASE_NOTE_FREQUENCY / 32.0f) * powf(2.0f, ((note - 9.0f) / 12.0f));
}

// convert frequency (Hz) to MIDI note number for A4=440.0Hz
float frequencyToMidiNote(float freq) {
    return logf(freq/BASE_NOTE_FREQUENCY)/logf(2.0f) * 12.0f + 69.f;
}

#define ZERO_DB_FACTOR 1.0f

// convert dB to gain multiplier (x1.0 gain == 0dB)
float dbToGain(float db) {
    return ZERO_DB_FACTOR * powf(10.0f, db / 20.0);
}

// convert gain multiplier to dB (x1.0 gain == 0dB)
float gainToDb(float gain) {
    return 20 * log10(gain / ZERO_DB_FACTOR);
}



float clampVolume(float volume) {
    if (volume < MIN_VOLUME_DB)
        return MIN_VOLUME_DB;
    else if (volume > MAX_VOLUME_DB)
        return MAX_VOLUME_DB;
    return volume;
}

// ensure pitch note is between MIN_NOTE and MAX_NOTE
float clampNote(float note) {
    if (note < MIN_NOTE)
        return MIN_NOTE;
    else if (note > MAX_NOTE)
        return MAX_NOTE;
    return note;
}

