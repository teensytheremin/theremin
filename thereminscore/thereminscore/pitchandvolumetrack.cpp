#include "pitchandvolumetrack.h"

#include <math.h>


// limit values to valid ones, if exceeded
void PitchAndVolume::clamp() {
    // ensure note is in midi note range 0..127
    note = clampNote(note);
    volume = clampVolume(volume);
}


PitchAndVolumeTrack::PitchAndVolumeTrack() : _data(nullptr), _size(0), _len(0), _framesPerSecond(SCORE_FRAME_RATE)
{

}

PitchAndVolumeTrack::~PitchAndVolumeTrack() {
    clear();
}

void PitchAndVolumeTrack::clear() {
    if (_data)
        delete[] _data;
    _data = nullptr;
    _len = 0;
    _size = 0;
}

PitchAndVolume defPitchAndVolumeItem;
const PitchAndVolume& PitchAndVolumeTrack::operator[] (int index) const {
    if (index < 0 || index >= _len)
        return defPitchAndVolumeItem;
    return _data[index];
}

PitchAndVolume rwdefPitchAndVolumeItem;
PitchAndVolume& PitchAndVolumeTrack::operator[] (int index) {
    if (index < 0)
        return rwdefPitchAndVolumeItem;
    if (index >= _len)
        setLength(index + 1);
    return _data[index];
}

PitchAndVolume PitchAndVolumeTrack::getInterpolated(double position) {
    PitchAndVolume a;
    PitchAndVolume b;
    if (_len < 2)
        return a;
    int baseIndex = (int)position;
    if (baseIndex > _len - 2)
        baseIndex = _len - 2;
    if (baseIndex < 0)
        baseIndex = 0;
    float delta = (float)(position - baseIndex);
    a = _data[baseIndex];
    b = _data[baseIndex + 1];
    // linear interpolation
    PitchAndVolume res;
    res.note = (1.0f - delta) * a.note + delta * b.note;
    res.volume = (1.0f - delta) * a.volume + delta * b.volume;
    res.clamp();
    return res;
}

float PitchAndVolumeTrack::posToSeconds(float pos) {
    return pos / _framesPerSecond;
}

float PitchAndVolumeTrack::secondsToPos(float seconds) {
    return seconds * _framesPerSecond;
}

void PitchAndVolumeTrack::truncate(int newLength) {
    if (newLength < _len && newLength >= 0) {
        setLength(newLength);
    }
}

void PitchAndVolumeTrack::setLength(int newLength) {
    if (newLength <= 0) {
        clear();
        return;
    }
    PitchAndVolume init;
    if (_len > 0) {
        init = _data[_len - 1];
    }
    if (newLength > _size) {
        int newSize = _size < 1200 ? 1200 : _size * 2;
        if (newSize < newLength) {
            newSize = newLength;
        }
        PitchAndVolume * p = new PitchAndVolume[newSize];
        if (_data) {
            // copy existing data
            for (int i = 0; i < _size; i++) {
                p[i] = _data[i];
            }
            delete[] _data;
        }
        _data = p;
        for (int i = _size; i < newSize; i++) {
            _data[i] = init;
        }
        _size = newSize;
    }
    // init with last sample
    for (int i = _len; i < newLength; i++) {
        _data[i] = init;
    }
    _len = newLength;
}

void PitchAndVolumeTrack::setPitchVelocityLimited(int xpos, float pitch, float maxVelocity) {
    if (xpos < 0)
        return;
    if (xpos >= _len) {
        setLength(xpos + 1);
    }
    float note = clampNote(pitch);
    _data[xpos].note = note;
    int maxDist = 1000;
    bool leftFixed = false;
    bool rightFixed = false;
    for (int dist = 1; dist < maxDist && (!leftFixed || !rightFixed); dist++ ) {
        float minlimit = clampNote(note - dist * maxVelocity);
        float maxlimit = clampNote(note + dist * maxVelocity);
        if (!leftFixed) {
            int left = xpos - dist;
            if (left >= 0) {
                if (_data[left].note > maxlimit) {
                    _data[left].note = maxlimit;
                } else if (_data[left].note < minlimit) {
                    _data[left].note = minlimit;
                } else {
                    leftFixed = true;
                }
            } else {
                leftFixed = true;
            }
        }
        if (!rightFixed) {
            int right = xpos + dist;
            if (right < _len) {
                if (_data[right].note > maxlimit) {
                    _data[right].note = maxlimit;
                } else if (_data[right].note < minlimit) {
                    _data[right].note = minlimit;
                } else {
                    rightFixed = true;
                }
            } else {
                rightFixed = true;
            }
        }
    }
}

void PitchAndVolumeTrack::setPitchInterpolated(int startx, float startPitch, int endx, float endPitch) {
    if (startx < 0)
        startx = 0;
    if (endx < 0)
        endx = 0;
    if (startx >= _len)
        setLength(startx);
    if (endx >= _len)
        setLength(endx);
    int step = endx > startx ? 1 : -1;
    int dist = endx > startx ? (endx - startx) : (startx - endx);
    if (!dist) {
        _data[startx].note = endPitch;
        return;
    }
    for (int i = 0; i <= dist; i++) {
        int x = startx + i * step;
        float interpolated = startPitch + (endPitch - startPitch) * i / dist;
        _data[x].note = interpolated;
    }
}

void PitchAndVolumeTrack::setVolumeVelocityLimited(int xpos, float volume, float maxVelocity) {
    if (xpos < 0)
        return;
    if (xpos >= _len) {
        setLength(xpos + 1);
    }
    float v = clampVolume(volume);
    _data[xpos].volume = v;
    int maxDist = 1000;
    bool leftFixed = false;
    bool rightFixed = false;
    for (int dist = 1; dist < maxDist && (!leftFixed || !rightFixed); dist++ ) {
        float minlimit = clampVolume(v - dist * maxVelocity);
        float maxlimit = clampVolume(v + dist * maxVelocity);
        if (!leftFixed) {
            int left = xpos - dist;
            if (left >= 0) {
                if (_data[left].volume > maxlimit) {
                    _data[left].volume = maxlimit;
                } else if (_data[left].volume < minlimit) {
                    _data[left].volume = minlimit;
                } else {
                    leftFixed = true;
                }
            } else {
                leftFixed = true;
            }
        }
        if (!rightFixed) {
            int right = xpos + dist;
            if (right < _len) {
                if (_data[right].volume > maxlimit) {
                    _data[right].volume = maxlimit;
                } else if (_data[right].volume < minlimit) {
                    _data[right].volume = minlimit;
                } else {
                    rightFixed = true;
                }
            } else {
                rightFixed = true;
            }
        }
    }
}

void PitchAndVolumeTrack::setVolumeInterpolated(int startx, float startVolume, int endx, float endVolume) {
    if (startx < 0)
        startx = 0;
    if (endx < 0)
        endx = 0;
    if (startx >= _len)
        setLength(startx);
    if (endx >= _len)
        setLength(endx);
    int step = endx > startx ? 1 : -1;
    int dist = endx > startx ? (endx - startx) : (startx - endx);
    if (!dist) {
        _data[startx].volume = startVolume;
        return;
    }
    for (int i = 0; i <= dist; i++) {
        int x = startx + i * step;
        float interpolated = startVolume + (endVolume - startVolume) * i / dist;
        _data[x].volume = interpolated;
    }
}
