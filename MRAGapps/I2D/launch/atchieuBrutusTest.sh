#!/bin/bash

EXECNAME=$1

NTHREADS=16

SETTINGS=

# STUDY
SETTINGS+=" -study FLUID_MEDIATED_INTERACTIONS"
#SETTINGS+=" -study SMART_INTERACTIONS"
#SETTINGS+=" -study RL"

# CPU
SETTINGS+=" -nthreads ${NTHREADS}" # number of threads

# FLOW PARAMETERS
SETTINGS+=" -tend 1.0" # sim time
SETTINGS+=" -D 0.10" # body/system size
SETTINGS+=" -lambda 1e4" # penalization factor
SETTINGS+=" -re 550" # Reynolds number
SETTINGS+=" -uinfx 0.10"	# freestream velocity in x
SETTINGS+=" -uinfy 0.0"	# freestream velocity in y

# TIME STEP CONSTRAINTS
SETTINGS+=" -lcfl 0.5" # Lagrangian CFL condition based on strain (advection)
SETTINGS+=" -cfl 0.5" # standard CFL condition on dt, based on max velocity (advection)
SETTINGS+=" -fc 0.5" # Fourier coefficeint condition on dt (diffusion)
SETTINGS+=" -ramp 100" # condition on dt to ramp up at sim initialization

# OBJECT IN FLOW
SETTINGS+=" -xpos 0.5" # grid offset for intialized objects in x
SETTINGS+=" -ypos 0.5" # grid offset for intialized objects
SETTINGS+=" -mollfactor 4" # number of grid points to smooth the characteristic function
SETTINGS+=" -obstacle heterogeneous" # type of obstacle
SETTINGS+=" -factory factory" # which factory file to use

# OTHER
SETTINGS+=" -particles 1" # true = use particles
SETTINGS+=" -hilbert 0" # true = use hilbert ordering for grid (?)
SETTINGS+=" -usekillvort 0" # true = kill vorticity at right boundary, fluid mediated interactions only --> other studies: set to 0
SETTINGS+=" -killvort 1" # range for vorticity killing, comment out if usekillvort==0
SETTINGS+=" -useoptimizer 0" # true: fitness function for CMA-ES is calculated, false: fitness function not calculated, fluid mediated interactions only --> other studies: set to 0
SETTINGS+=" -tbound 40" # lower bound of drag coefficient integration (for fitness function), comment out if useoptimizer == 0

# MRAG
SETTINGS+=" -bpd 8" # initial number of blocks per dimension
SETTINGS+=" -lmax 4" # max levels of refinement, N blocks 2^lmax, each block 32x32 grid pts.
SETTINGS+=" -jump 2" # max jump in grid level between any two blocks
SETTINGS+=" -rtol 1e-3" # threshold for refinement, smaller = less
SETTINGS+=" -ctol 1e-4" # threshold for compression, smaller = less, should be less than rtol
SETTINGS+=" -adaptfreq 5" # number of steps between refinement and compression
SETTINGS+=" -refine-omega-only 0" # true = use omega only for refine, false = use velocity too
SETTINGS+=" -rio free_frame" # controls whether refinement occurs everywhere, interior blocks, or at outlet or inlet blocks
SETTINGS+=" -uniform 0" # true = uniform resolution, no refinement/compression

# FMM
SETTINGS+=" -fmm velocity" # fmm = fast multipole method, use to determine velocity
SETTINGS+=" -fmm-potential 0" # (?)
SETTINGS+=" -fmm-theta 0.8" # fmm factor, 0 = N^2, 1 = fast, inaccurate
SETTINGS+=" -core-fmm sse" # use sse for fmm (?)
SETTINGS+=" -fmm-skip 0" # skip fmm (?)

# FTLE
SETTINGS+=" -tStartFTLE 0.0"
SETTINGS+=" -tEndFTLE 0.0"
SETTINGS+=" -tStartEff 0.0"
SETTINGS+=" -tEndEff 0.0"

# REINFORCEMENT LEARNING
SETTINGS+=" -lr 0.1" # learning rate, 0 = no learning/memory
SETTINGS+=" -gamma 0.1" # future action value, 0 = don't look forward, 1 look infinitely forward
SETTINGS+=" -greedyEps 0.01" # randomness in actions, fraction of actions chosen at random
SETTINGS+=" -shared 0" # true = everyone updates and shares a general policy

# I/O
SETTINGS+=" -vtu 0"	# dump vtu/vtk file (slow)
SETTINGS+=" -dumpfreq 16" # number of dumps per sim time, dumps are on the dot 
SETTINGS+=" -savefreq 2000"	# frequency to save a full restart of simulation (super slow)

RESTART=" -restart 0"	# true = restart from last 

OPTIONS=${SETTINGS}${RESTART}

export OMP_NUM_THREADS=${NTHREADS}
export LD_LIBRARY_PATH+=:/cluster/home/mavt/atchieu/Library/myVTK/lib/vtk-5.2/:
# export LD_LIBRARY_PATH+=:/cluster/home/mavt/atchieu/Library/tbb22_012oss/build/linux_intel64_icc_cc4.1.2_libc2.5_kernel2.6.18_release/:
export LD_LIBRARY_PATH+=:/cluster/home/mavt/atchieu/Library/tbb40_20120613oss/build/linux_intel64_gcc_cc4.6.1_libc2.5_kernel2.6.18_release:
rm -fr ../run
mkdir ../run
cp andrewBrutusTest.sh ../run/
cp ../makefiles/${EXECNAME} ../run/executable  
cp ctrl* factory ../run/
cd ../run

echo "====================="
echo "SETTINGS FOR THIS RUN"
echo "====================="
echo ${OPTIONS}

./executable ${OPTIONS}


