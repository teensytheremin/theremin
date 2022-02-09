#ifndef PITCHANDVOLUMETRACK_H
#define PITCHANDVOLUMETRACK_H

#include "noteutil.h"

// sample rate samples per second
#define SCORE_SAMPLE_RATE 48000

/*

    Frame rate selection.

    Based on sample rate.
    Divisible by 50 and 60.

    lcm(50,60) = 300

    300,600,900,1200

    48000/1200 = 40
    48000/600 = 80

*/

// score frame rate, frames per second
#define SCORE_FRAME_RATE 1200
// score frame size, samples (40 for 48KHz / 1200 fps)
#define SCORE_FRAME_SIZE (SCORE_SAMPLE_RATE/SCORE_FRAME_RATE)


struct TrackMeter {
    float startOffsetSeconds;
    float mainTicksSeconds;
    int secondaryTicksCount;
    TrackMeter() : startOffsetSeconds(0.0f), mainTicksSeconds(2.0f), secondaryTicksCount(4) { }
};

struct PitchAndVolume {
    float note;
    float volume;
    PitchAndVolume() : note(69.0f), volume(-100.0f) {}
    PitchAndVolume(float p, float v) : note(p), volume(v) {}
    PitchAndVolume(const PitchAndVolume& v) : note(v.note), volume(v.volume) {}
    void operator = (const PitchAndVolume& v) {
        note = v.note;
        volume = v.volume;
    }
    // limit values to valid ones, if exceeded
    void clamp();
};

class PitchAndVolumeTrack
{
protected:
    PitchAndVolume * _data;
    int _size;
    int _len;

    int _framesPerSecond;
    TrackMeter _meter;

public:
    int size() const { return _size; }
    int length() const { return _len; }
    void setLength(int newLength);
    void truncate(int newLength);
    void clear();
    float posToSeconds(float pos);
    float secondsToPos(float seconds);
    int framesPerSecond() { return _framesPerSecond; }
    void setFramesPerSecond(float frames) { _framesPerSecond = frames; }
    TrackMeter & meter() { return _meter; }
    PitchAndVolume getInterpolated(double position);
    PitchAndVolumeTrack();
    ~PitchAndVolumeTrack();
    const PitchAndVolume& operator [] (int index) const;
    const PitchAndVolume& get(int index) const { return (*this)[index]; }
    PitchAndVolume& operator [] (int index);
    void setPitchVelocityLimited(int xpos, float pitch, float maxVelocity);
    void setPitchInterpolated(int startx, float startPitch, int endx, float endPitch);
    void setVolumeVelocityLimited(int xpos, float volume, float maxVelocity);
    void setVolumeInterpolated(int startx, float startVolume, int endx, float endVolume);
};

#endif // PITCHANDVOLUMETRACK_H
