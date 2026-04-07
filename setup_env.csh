#!/bin/tcsh

# Environment setup for CMSSW CMake build (tcsh version)
# This script sets up the paths for CVMFS externals

# GCC 13
setenv GCC_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/gcc/13.4.0-6908cfdf803923e783448096ca4f0923"
setenv PATH "${GCC_ROOT}/bin:${PATH}"

if ( $?LD_LIBRARY_PATH ) then
    setenv LD_LIBRARY_PATH "${GCC_ROOT}/lib64:${GCC_ROOT}/lib:${LD_LIBRARY_PATH}"
else
    setenv LD_LIBRARY_PATH "${GCC_ROOT}/lib64:${GCC_ROOT}/lib"
endif

# TBB
setenv TBB_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/tbb/v2022.3.0-88eb7be4ee320d604a798a914aea6359"
setenv LD_LIBRARY_PATH "${TBB_ROOT}/lib:${LD_LIBRARY_PATH}"

# Boost
setenv BOOST_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/boost/1.80.0-4e041c5f850405476cd4bc42f965d947"
setenv LD_LIBRARY_PATH "${BOOST_ROOT}/lib:${LD_LIBRARY_PATH}"

# ROOT
setenv ROOT_DIR "/cvmfs/cms.cern.ch/el8_amd64_gcc13/lcg/root/6.36.09-550a5cc65f2c3764971305621e222830"
setenv LD_LIBRARY_PATH "${ROOT_DIR}/lib:${LD_LIBRARY_PATH}"
setenv PATH "${ROOT_DIR}/bin:${PATH}"

# MD5
setenv MD5_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/md5/1.0.0-26057075013e190e56dad37d35219376"
setenv LD_LIBRARY_PATH "${MD5_ROOT}/lib:${LD_LIBRARY_PATH}"

# TinyXML2
setenv TINYXML2_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/tinyxml2/6.2.0-67924ead96ecb4e69aad321b767979a5"
setenv LD_LIBRARY_PATH "${TINYXML2_ROOT}/lib64:${LD_LIBRARY_PATH}"

# CLHEP
setenv CLHEP_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/clhep/2.4.7.2-9d5b7c3a55c3af00652fa823dcdd8319"
setenv LD_LIBRARY_PATH "${CLHEP_ROOT}/lib:${LD_LIBRARY_PATH}"

# Python3
setenv PYTHON3_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/python3/3.9.14-e16d2924e9eb9db8fddd14e187cf7209"
setenv LD_LIBRARY_PATH "${PYTHON3_ROOT}/lib:${LD_LIBRARY_PATH}"
setenv PATH "${PYTHON3_ROOT}/bin:${PATH}"

# pybind11
setenv PYBIND11_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/py3-pybind11/3.0.1-225a0aebad9d3cd25d37aabcec07d773"

# cpu_features
setenv CPU_FEATURES_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/cpu_features/0.9.0-9345f64300a0e12ee5bd1420a0e15254"
setenv LD_LIBRARY_PATH "${CPU_FEATURES_ROOT}/lib64:${LD_LIBRARY_PATH}"

# Python3
setenv PYTHON3_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/python3/3.9.14-e16d2924e9eb9db8fddd14e187cf7209"
setenv PATH "${PYTHON3_ROOT}/bin:${PATH}"
setenv LD_LIBRARY_PATH "${PYTHON3_ROOT}/lib:${LD_LIBRARY_PATH}"

echo "Environment configured for CMSSW build"
echo "GCC: `${GCC_ROOT}/bin/g++ --version | head -1`"
