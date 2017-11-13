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

/**
 * You might find these declarations useful.
 */
enum GenderIdentity {MALE = 0, FEMALE = 1};
const static enum GenderIdentity otherGender [] = {FEMALE, MALE};

#define bool int
#define true 1
#define false 0

int number_female = 0;
int number_male = 0;
int male_inside;
int female_inside;
int male_waiting;
int female_waiting;
int occup = 0;
bool is_ready = false;



struct Washroom {
    // TODO
    uthread_mutex_t mutex;
    uthread_cond_t male;
    uthread_cond_t female;
    uthread_cond_t entered;
    uthread_cond_t is_ready;
};

struct Washroom* createWashroom() {
  struct Washroom* washroom = malloc (sizeof (struct Washroom));
  // TODO
    
    Washroom-> mutex           = uthread_cond_create();
    Washroom-> male            = uthread_cond_create(washroom->mutex);
    Washroom-> female          = uthread_cond_create(washroom->mutex);
    Washroom-> entered         = uthread_cond_create(washroom->mutex);
    Washroom-> is_ready  = uthread_cond_create(washroom->mutex);

  return washroom;
}

struct Washroom* washroom;

#define WAITING_HISTOGRAM_SIZE (NUM_ITERATIONS * NUM_PEOPLE)
int             entryTicker;                                          // incremented with each entry
int             waitingHistogram         [WAITING_HISTOGRAM_SIZE];
int             waitingHistogramOverflow;
uthread_mutex_t waitingHistogrammutex;
int             occupancyHistogram       [2] [MAX_OCCUPANCY + 1];

void enterWashroom (enum GenderIdentity g) {
     // TODO
    if(g==MALE){
        int wait_ticker = entryTicker;
        male_waiting++;
        while(occup==3)||(female_inside>0)){
            wait_ticker++;
        }
        male_waiting--;
        wait_ticker = entryTicker - wait_ticker;
        recordWaitingTime(wait_ticker);
        assert(occup<4);
        assert(female_inside==0);
        male_inside++;
        occup++;
        occupancyHistogram[MALE][male_inside]++;
        }
    else{
        int wait_ticker = entryTicker;
        female_waiting++;
        while((occup==3)||(male_inside>0)){
            wait_ticker++;
        }
        female_waiting--;
        wait_ticker =entryTicker-wait_ticker;
        recordWaitingTime(wait_ticker);
        assert(occup<4);
        assert(male_inside==0);
        female_inside++;
        occup++;
        occupancyHistogram[FEMALE][female_inside]++;
    }
 
}


void leaveWashroom() {
     // TODO
    uthread_mutex_lock(mutex);
    if (males_inside >= 1){
        male_inside--;
        if (female_waiting > 0 && male_inside == 0) {
            for (int i = 0; i < 3; i++) {
                uthread_cond_signal(washroom->female);
            }
        }
        else {
            uthread_cond_signal(washroom->male);
        }
    }else{
        female_inside--;
        if (male_waiting > 0 && female_inside == 0) {
            for (int i = 0; i < 3; i++) {
                uthread_cond_signal(washroom->male);
            }
        }
        else {
            uthread_cond_signal(washroom->female);
        }
    }
    occup;
    uthread_mutex_unlock(washroom->mutex);
}





void recordWaitingTime (int waitingTime) {
  uthread_mutex_lock (waitingHistogrammutex);
  if (waitingTime < WAITING_HISTOGRAM_SIZE)
    waitingHistogram [waitingTime] ++;
  else
    waitingHistogramOverflow ++;
  uthread_mutex_unlock (waitingHistogrammutex);
}

//
// TODO
// You will probably need to create some additional produres etc.
//

int main (int argc, char** argv) {
  uthread_init (1);
  washroom = createWashroom();
  uthread_t pt [NUM_PEOPLE];
  waitingHistogrammutex = uthread_mutex_create ();

  // TODO
    male_inside=0;
    male_waiting=0;
    female_inside=0;
    female_waiting=0;
    for(int i=0; i< NUM_PEOPLE; i++){
    pt[i]= uthread_create(person, washroom);
    }
    uthread_t gk = uthread_create(gatekeeper, washroom);
    uthread_join(gk, 0);
    
  printf ("Times with 1 person who identifies as male   %d\n", occupancyHistogram [MALE]   [1]);
  printf ("Times with 2 people who identifies as male   %d\n", occupancyHistogram [MALE]   [2]);
  printf ("Times with 3 people who identifies as male   %d\n", occupancyHistogram [MALE]   [3]);
  printf ("Times with 1 person who identifies as female %d\n", occupancyHistogram [FEMALE] [1]);
  printf ("Times with 2 people who identifies as female %d\n", occupancyHistogram [FEMALE] [2]);
  printf ("Times with 3 people who identifies as female %d\n", occupancyHistogram [FEMALE] [3]);
  printf ("Waiting Histogram\n");
  for (int i=0; i<WAITING_HISTOGRAM_SIZE; i++)
    if (waitingHistogram [i])
      printf ("  Number of times people waited for %d %s to enter: %d\n", i, i==1?"person":"people", waitingHistogram [i]);
  if (waitingHistogramOverflow)
    printf ("  Number of times people waited more than %d entries: %d\n", WAITING_HISTOGRAM_SIZE, waitingHistogramOverflow);
}
