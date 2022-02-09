#include "thereminscoreproject.h"
#include <stdio.h>

ThereminScoreProject::ThereminScoreProject() : _changed(false)
{

}

ThereminScoreProject::~ThereminScoreProject() {

}

bool ThereminScoreProject::save(const char * filename) {
    FILE * f = nullptr;
    errno_t res = fopen_s(&f, filename, "wb");
    if (res) {
        // error: cannot create file
        return false;
    }
    fprintf(f, "ThereminScoreProject v0.1\n");
    fclose(f);
    return false;
}

bool ThereminScoreProject::load(const char * filename) {
    return false;
}
