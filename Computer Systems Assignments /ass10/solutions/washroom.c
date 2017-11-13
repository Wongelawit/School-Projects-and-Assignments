//
// This is the solution to CPSC 213 Assignment 10.
// Do not distribute this code or any portion of it to anyone in any way.
// Do not remove this comment.
//

#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <fcntl.h>
#include <unistd.h>
#include "uthread.h"
#include "uthread_mutex_cond.h"

#ifdef VERBOSE
#define VERBOSE_PRINT(S, ...) printf (S, ##__VA_ARGS__);
#else
#define VERBOSE_PRINT(S, ...) ;
#endif

#define MAX_OCCUPANCY      3
#define NUM_ITERATIONS     100
#define NUM_PEOPLE         20
#define FAIR_WAITING_COUNT 4

enum GenderIdentity {MALE = 0, FEMALE = 1};
const static enum GenderIdentity otherGender [] = {FEMALE, MALE};

struct Washroom {
  uthread_mutex_t     mutex;
  uthread_cond_t      canEnter [2];
  int                 occupantCount;
  enum GenderIdentity occupantGender;
  int                 waitersCount [2];
  int                 outGenderWaitingCount;
};

struct Washroom* createWashroom() {
  struct Washroom* washroom = malloc (sizeof (struct Washroom));
  washroom->mutex                 = uthread_mutex_create();
  washroom->canEnter [MALE]       = uthread_cond_create (washroom->mutex);
  washroom->canEnter [FEMALE]     = uthread_cond_create (washroom->mutex);
  washroom->occupantCount         = 0;
  washroom->occupantGender        = 0;
  washroom->waitersCount [MALE]   = 0;
  washroom->waitersCount [FEMALE] = 0;
  washroom->outGenderWaitingCount = 0;
  return washroom;
}

#define WAITING_HISTOGRAM_SIZE (NUM_ITERATIONS * NUM_PEOPLE)
int             entryTicker;
int             waitingHistogram         [WAITING_HISTOGRAM_SIZE];
int             waitingHistogramOverflow;
uthread_mutex_t waitingHistogrammutex;
int             occupancyHistogram       [2] [MAX_OCCUPANCY + 1];

void enterWashroom (struct Washroom* washroom, enum GenderIdentity gender) {
  uthread_mutex_lock (washroom->mutex);
    while (1) {
      int isEmpty            = washroom->occupantCount                       == 0;
      int hasRoom            = washroom->occupantCount                       <  MAX_OCCUPANCY;
      int sameGender         = washroom->occupantGender                      == gender;
      int otherGenderWaiting = washroom->waitersCount [otherGender [gender]] >  0;
      int waitingNotFair     = washroom->outGenderWaitingCount               >= FAIR_WAITING_COUNT;
      int otherGendersTurn   = otherGenderWaiting && waitingNotFair;
      if (isEmpty || (hasRoom && sameGender && ! otherGendersTurn)) {
        if (sameGender)
          washroom->outGenderWaitingCount ++;
        else
          washroom->outGenderWaitingCount = 0;
        entryTicker ++;
        break;
      }
      VERBOSE_PRINT ("waiting to enter: %d %d %d %d %d %d\n", gender, isEmpty, hasRoom, sameGender, otherGenderWaiting, waitingNotFair);
      if (! sameGender && washroom->waitersCount [gender] == 0)
        washroom->outGenderWaitingCount = 0;
      washroom->waitersCount [gender] ++;
      uthread_cond_wait (washroom->canEnter [gender]);
      washroom->waitersCount [gender] --;
    }
    VERBOSE_PRINT ("entering %d %d\n", gender, washroom->occupantCount+1);
    assert (washroom->occupantCount == 0 || washroom->occupantGender == gender);
    assert (washroom->occupantCount < MAX_OCCUPANCY);
    washroom->occupantGender = gender;
    washroom->occupantCount += 1;
    occupancyHistogram [washroom->occupantGender] [washroom->occupantCount] ++;
  uthread_mutex_unlock (washroom->mutex);
}

void leaveWashroom (struct Washroom* washroom) {
  uthread_mutex_lock (washroom->mutex);
    washroom->occupantCount -= 1;
    enum GenderIdentity inGender  = washroom->occupantGender;
    enum GenderIdentity outGender = otherGender [inGender];
    int      outGenderWaiting     = washroom->waitersCount [outGender]  >  0;
    int      waitingNotFair       = washroom->outGenderWaitingCount     >= FAIR_WAITING_COUNT;
    int      inGenderWaiting      = washroom->waitersCount [inGender]   >  0;
    VERBOSE_PRINT ("leaving %d %d %d %d\n", inGender, outGenderWaiting, inGenderWaiting, waitingNotFair);
    if (outGenderWaiting && (waitingNotFair || ! inGenderWaiting)) {
      if (washroom->occupantCount == 0) {
        for (int i = 0; i < MAX_OCCUPANCY; i++) {
          VERBOSE_PRINT ("signalling out Gender %d\n", outGender);
          uthread_cond_signal (washroom->canEnter [outGender]);
        }
      }
    } else if (inGenderWaiting) {
      VERBOSE_PRINT ("signalling in Gender %d\n", inGender);
      uthread_cond_signal (washroom->canEnter [inGender]);
    }
  uthread_mutex_unlock (washroom->mutex);
}

void recordWaitingTime (int waitingTime) {
  uthread_mutex_lock (waitingHistogrammutex);
  if (waitingTime < WAITING_HISTOGRAM_SIZE)
    waitingHistogram [waitingTime] ++;
  else
    waitingHistogramOverflow ++;
  uthread_mutex_unlock (waitingHistogrammutex);
}

void* person (void* washroomv) {
  struct Washroom*    washroom = washroomv;
  enum GenderIdentity gender   = random() & 1;
  
  for (int i = 0; i < NUM_ITERATIONS; i++) {
    int startTime = entryTicker;
    enterWashroom (washroom, gender);
    recordWaitingTime (entryTicker - startTime - 1);
    for (int j = 0; j < NUM_PEOPLE; j++) uthread_yield();
    leaveWashroom (washroom);
    for (int j = 0; j < NUM_PEOPLE; j++) uthread_yield();
  }
  return NULL;
}

void mysrandomdev() {
  unsigned long seed;
  int f = open ("/dev/random", O_RDONLY);
  read    (f, &seed, sizeof (seed));
  close   (f);
  srandom (seed);
}

int main (int argc, char** argv) {
  uthread_init (1);
  mysrandomdev();
  struct Washroom* washroom = createWashroom();
  uthread_t        pt [NUM_PEOPLE];
  waitingHistogrammutex = uthread_mutex_create ();
  
  for (int i = 0; i < NUM_PEOPLE; i++)
    pt [i] = uthread_create (person, washroom);
  for (int i = 0; i < NUM_PEOPLE; i++)
    uthread_join (pt [i], 0);
    
  printf ("Times with 1 male    %d\n", occupancyHistogram [MALE]   [1]);
  printf ("Times with 2 males   %d\n", occupancyHistogram [MALE]   [2]);
  printf ("Times with 3 males   %d\n", occupancyHistogram [MALE]   [3]);
  printf ("Times with 1 female  %d\n", occupancyHistogram [FEMALE] [1]);
  printf ("Times with 2 females %d\n", occupancyHistogram [FEMALE] [2]);
  printf ("Times with 3 females %d\n", occupancyHistogram [FEMALE] [3]);
  printf ("Waiting Histogram\n");
  for (int i=0; i<WAITING_HISTOGRAM_SIZE; i++)
    if (waitingHistogram [i])
      printf ("  Number of times people waited for %d %s to enter: %d\n", i, i==1?"person":"people", waitingHistogram [i]);
  if (waitingHistogramOverflow)
    printf ("  Number of times people waited more than %d entries: %d\n", WAITING_HISTOGRAM_SIZE, waitingHistogramOverflow);
}
