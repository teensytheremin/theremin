#ifndef THEREMINSCOREPROJECT_H
#define THEREMINSCOREPROJECT_H

#include "pitchandvolumetrack.h"

class ThereminScoreProject
{
protected:
    PitchAndVolumeTrack _track;
    bool _changed;
public:
    PitchAndVolumeTrack * track() { return &_track; }
    ThereminScoreProject();
    ~ThereminScoreProject();
    bool save(const char * filename);
    bool load(const char * filename);
    void setChanged() { _changed = true; }
    bool isChanged() { return _changed; }
};

#endif // THEREMINSCOREPROJECT_H
