#!/bin/bash

# Environment setup for CMSSW CMake build
# This script sets up the paths for CVMFS externals

# GCC 13
export GCC_ROOT="/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/gcc/13.4.0-6908cfdf803923e783448096ca4f0923"
export PATH="${GCC_ROOT}/bin:${PATH}"
export LD_LIBRARY_PATH="${GCC_ROOT}/lib64:${GCC_ROOT}/lib:${LD_LIBRARY_PATH}"

# TBB
export TBB_ROOT="/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/tbb/v2022.3.0-88eb7be4ee320d604a798a914aea6359"
export LD_LIBRARY_PATH="${TBB_ROOT}/lib:${LD_LIBRARY_PATH}"

# Boost
export BOOST_ROOT="/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/boost/1.80.0-4e041c5f850405476cd4bc42f965d947"
export LD_LIBRARY_PATH="${BOOST_ROOT}/lib:${LD_LIBRARY_PATH}"

# ROOT
export ROOT_DIR="/cvmfs/cms.cern.ch/el8_amd64_gcc13/lcg/root/6.36.09-550a5cc65f2c3764971305621e222830"
export LD_LIBRARY_PATH="${ROOT_DIR}/lib:${LD_LIBRARY_PATH}"
export PATH="${ROOT_DIR}/bin:${PATH}"

# MD5
export MD5_ROOT="/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/md5/1.0.0-26057075013e190e56dad37d35219376"
export LD_LIBRARY_PATH="${MD5_ROOT}/lib:${LD_LIBRARY_PATH}"

# TinyXML2
export TINYXML2_ROOT="/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/tinyxml2/6.2.0-67924ead96ecb4e69aad321b767979a5"
export LD_LIBRARY_PATH="${TINYXML2_ROOT}/lib:${LD_LIBRARY_PATH}"

# CLHEP
export CLHEP_ROOT="/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/clhep/2.4.7.2-9d5b7c3a55c3af00652fa823dcdd8319"
export LD_LIBRARY_PATH="${CLHEP_ROOT}/lib:${LD_LIBRARY_PATH}"

# Python3
export PYTHON3_ROOT="/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/python3/3.9.14-e16d2924e9eb9db8fddd14e187cf7209"
export LD_LIBRARY_PATH="${PYTHON3_ROOT}/lib:${LD_LIBRARY_PATH}"
export PATH="${PYTHON3_ROOT}/bin:${PATH}"

# pybind11
export PYBIND11_ROOT="/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/py3-pybind11/3.0.1-225a0aebad9d3cd25d37aabcec07d773"

# cpu_features
export CPU_FEATURES_ROOT="/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/cpu_features/0.9.0-9345f64300a0e12ee5bd1420a0e15254"
export LD_LIBRARY_PATH="${CPU_FEATURES_ROOT}/lib64:${LD_LIBRARY_PATH}"

# Python3
export PYTHON3_ROOT="/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/python3/3.9.14-e16d2924e9eb9db8fddd14e187cf7209"
export PATH="${PYTHON3_ROOT}/bin:${PATH}"
export LD_LIBRARY_PATH="${PYTHON3_ROOT}/lib:${LD_LIBRARY_PATH}"

# Additional CVMFS externals that may be needed
# ISL (required by GCC)
if [ -d "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/isl" ]; then
    ISL_DIRS=$(ls -d /cvmfs/cms.cern.ch/el8_amd64_gcc13/external/isl/*/ 2>/dev/null | head -1)
    if [ -n "$ISL_DIRS" ]; then
        export LD_LIBRARY_PATH="${ISL_DIRS}lib:${LD_LIBRARY_PATH}"
    fi
fi

# MPC, MPFR, GMP (may be needed by GCC)
for LIB in mpc mpfr gmp; do
    if [ -d "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/${LIB}" ]; then
        LIB_DIR=$(ls -d /cvmfs/cms.cern.ch/el8_amd64_gcc13/external/${LIB}/*/ 2>/dev/null | head -1)
        if [ -n "$LIB_DIR" ]; then
            export LD_LIBRARY_PATH="${LIB_DIR}lib:${LD_LIBRARY_PATH}"
        fi
    fi
done

echo "Environment configured for CMSSW build"
echo "GCC: $(${GCC_ROOT}/bin/g++ --version | head -1)"
echo "LD_LIBRARY_PATH: ${LD_LIBRARY_PATH}"
