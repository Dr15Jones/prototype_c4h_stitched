cmake_minimum_required(VERSION 3.16)

# Set compiler from CVMFS (must be before project())
set(CMAKE_CXX_COMPILER "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/gcc/13.4.0-6908cfdf803923e783448096ca4f0923/bin/g++")
set(CMAKE_C_COMPILER "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/gcc/13.4.0-6908cfdf803923e783448096ca4f0923/bin/gcc")

project(CMSSW CXX)

# Set C++ standard (C++20 required for concepts)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Set output directories
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# CVMFS paths for external dependencies
set(TBB_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/tbb/v2022.3.0-88eb7be4ee320d604a798a914aea6359")
set(ROOT_DIR "/cvmfs/cms.cern.ch/el8_amd64_gcc13/lcg/root/6.36.09-550a5cc65f2c3764971305621e222830")
set(BOOST_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/boost/1.80.0-4e041c5f850405476cd4bc42f965d947")
set(MD5_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/md5/1.0.0-26057075013e190e56dad37d35219376")
set(TINYXML2_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/tinyxml2/6.2.0-67924ead96ecb4e69aad321b767979a5")
set(CLHEP_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/clhep/2.4.7.2-9d5b7c3a55c3af00652fa823dcdd8319")
set(PYTHON3_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/python3/3.9.14-e16d2924e9eb9db8fddd14e187cf7209")
set(PYBIND11_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/py3-pybind11/3.0.1-225a0aebad9d3cd25d37aabcec07d773")
set(CPU_FEATURES_ROOT "/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/cpu_features/0.9.0-9345f64300a0e12ee5bd1420a0e15254")

# Set CMAKE_PREFIX_PATH to help find packages
list(APPEND CMAKE_PREFIX_PATH ${TBB_ROOT} ${ROOT_DIR} ${BOOST_ROOT})

# Find Boost
find_package(Boost REQUIRED COMPONENTS program_options filesystem serialization
    PATHS ${BOOST_ROOT}
    NO_DEFAULT_PATH)
message(STATUS "Found Boost: ${Boost_VERSION} at ${Boost_DIR}")

# Find Threads
find_package(Threads REQUIRED)

# Find TBB
find_path(TBB_INCLUDE_DIR tbb/tbb.h
    PATHS ${TBB_ROOT}/include
    NO_DEFAULT_PATH
    REQUIRED)

find_library(TBB_LIBRARY
    NAMES tbb libtbb
    PATHS ${TBB_ROOT}/lib ${TBB_ROOT}/lib64
    NO_DEFAULT_PATH
    REQUIRED)

if(TBB_INCLUDE_DIR AND TBB_LIBRARY)
    add_library(TBB::tbb UNKNOWN IMPORTED)
    set_target_properties(TBB::tbb PROPERTIES
        IMPORTED_LOCATION "${TBB_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${TBB_INCLUDE_DIR}"
    )
    message(STATUS "Found TBB: ${TBB_LIBRARY}")
else()
    message(FATAL_ERROR "TBB not found at ${TBB_ROOT}")
endif()

# Find ROOT
find_package(ROOT REQUIRED COMPONENTS Core RIO Net Hist Tree
    PATHS ${ROOT_DIR}
    NO_DEFAULT_PATH)
message(STATUS "Found ROOT: ${ROOT_VERSION} at ${ROOT_DIR}")

# Find Python3
set(Python3_EXECUTABLE ${PYTHON3_ROOT}/bin/python3)
set(Python3_INCLUDE_DIR ${PYTHON3_ROOT}/include/python3.9)
set(Python3_LIBRARY ${PYTHON3_ROOT}/lib/libpython3.9.so)

# Verify Python3 files exist
if(NOT EXISTS ${Python3_EXECUTABLE})
    message(FATAL_ERROR "Python3 executable not found at ${Python3_EXECUTABLE}")
endif()
if(NOT EXISTS ${Python3_INCLUDE_DIR}/Python.h)
    message(FATAL_ERROR "Python3 headers not found at ${Python3_INCLUDE_DIR}")
endif()
if(NOT EXISTS ${Python3_LIBRARY})
    message(FATAL_ERROR "Python3 library not found at ${Python3_LIBRARY}")
endif()

# Create Python3::Python imported target
add_library(Python3::Python UNKNOWN IMPORTED)
set_target_properties(Python3::Python PROPERTIES
    IMPORTED_LOCATION "${Python3_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${Python3_INCLUDE_DIR}"
)

# Set standard Python3 variables for compatibility
set(Python3_FOUND TRUE)
set(Python3_VERSION "3.9.14")
set(Python3_INCLUDE_DIRS ${Python3_INCLUDE_DIR})
set(Python3_LIBRARIES ${Python3_LIBRARY})

message(STATUS "Found Python3: ${Python3_VERSION} at ${Python3_EXECUTABLE}")
message(STATUS "Python3 include dirs: ${Python3_INCLUDE_DIRS}")
message(STATUS "Python3 libraries: ${Python3_LIBRARIES}")

# Find TinyXML2
find_path(TINYXML2_INCLUDE_DIR tinyxml2.h
    PATHS ${TINYXML2_ROOT}/include
    NO_DEFAULT_PATH
    REQUIRED)

find_library(TINYXML2_LIBRARY
    NAMES tinyxml2 libtinyxml2
    PATHS ${TINYXML2_ROOT}/lib ${TINYXML2_ROOT}/lib64
    NO_DEFAULT_PATH
    REQUIRED)

if(TINYXML2_INCLUDE_DIR AND TINYXML2_LIBRARY)
    add_library(tinyxml2::tinyxml2 UNKNOWN IMPORTED)
    set_target_properties(tinyxml2::tinyxml2 PROPERTIES
        IMPORTED_LOCATION "${TINYXML2_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${TINYXML2_INCLUDE_DIR}"
    )
    message(STATUS "Found TinyXML2: ${TINYXML2_LIBRARY}")
else()
    message(FATAL_ERROR "TinyXML2 not found at ${TINYXML2_ROOT}")
endif()

# Find MD5
find_path(MD5_INCLUDE_DIR md5.h
    PATHS ${MD5_ROOT}/include
    NO_DEFAULT_PATH
    REQUIRED)

find_library(MD5_LIBRARY
    NAMES cms-md5 libcms-md5
    PATHS ${MD5_ROOT}/lib ${MD5_ROOT}/lib64
    NO_DEFAULT_PATH
    REQUIRED)

if(MD5_INCLUDE_DIR AND MD5_LIBRARY)
    add_library(MD5::md5 UNKNOWN IMPORTED)
    set_target_properties(MD5::md5 PROPERTIES
        IMPORTED_LOCATION "${MD5_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${MD5_INCLUDE_DIR}"
    )
    message(STATUS "Found MD5: ${MD5_LIBRARY}")
else()
    message(FATAL_ERROR "MD5 not found at ${MD5_ROOT}")
endif()

# Find CLHEP
find_path(CLHEP_INCLUDE_DIR CLHEP/Random/Random.h
    PATHS ${CLHEP_ROOT}/include
    NO_DEFAULT_PATH
    REQUIRED)

find_library(CLHEP_LIBRARY
    NAMES CLHEP libCLHEP
    PATHS ${CLHEP_ROOT}/lib ${CLHEP_ROOT}/lib64
    NO_DEFAULT_PATH
    REQUIRED)

if(CLHEP_INCLUDE_DIR AND CLHEP_LIBRARY)
    add_library(CLHEP::CLHEP UNKNOWN IMPORTED)
    set_target_properties(CLHEP::CLHEP PROPERTIES
        IMPORTED_LOCATION "${CLHEP_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${CLHEP_INCLUDE_DIR}"
    )
    message(STATUS "Found CLHEP: ${CLHEP_LIBRARY}")
else()
    message(FATAL_ERROR "CLHEP not found at ${CLHEP_ROOT}")
endif()

# Find pybind11
find_path(PYBIND11_INCLUDE_DIR pybind11/pybind11.h
    PATHS ${PYBIND11_ROOT}/include
    NO_DEFAULT_PATH
    REQUIRED)

if(PYBIND11_INCLUDE_DIR)
    add_library(pybind11::pybind11 INTERFACE IMPORTED)
    set_target_properties(pybind11::pybind11 PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${PYBIND11_INCLUDE_DIR};${Python3_INCLUDE_DIR}"
    )
    message(STATUS "Found pybind11: ${PYBIND11_INCLUDE_DIR}")
else()
    message(FATAL_ERROR "pybind11 not found at ${PYBIND11_ROOT}")
endif()

# Find cpu_features
find_path(CPU_FEATURES_INCLUDE_DIR cpu_features/cpu_features_macros.h
    PATHS ${CPU_FEATURES_ROOT}/include
    NO_DEFAULT_PATH
    REQUIRED)

find_library(CPU_FEATURES_LIBRARY
    NAMES cpu_features libcpu_features
    PATHS ${CPU_FEATURES_ROOT}/lib ${CPU_FEATURES_ROOT}/lib64
    NO_DEFAULT_PATH
    REQUIRED)

if(CPU_FEATURES_INCLUDE_DIR AND CPU_FEATURES_LIBRARY)
    add_library(cpu_features::cpu_features UNKNOWN IMPORTED)
    set_target_properties(cpu_features::cpu_features PROPERTIES
        IMPORTED_LOCATION "${CPU_FEATURES_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${CPU_FEATURES_INCLUDE_DIR}"
    )
    message(STATUS "Found cpu_features: ${CPU_FEATURES_LIBRARY}")
else()
    message(FATAL_ERROR "cpu_features not found at ${CPU_FEATURES_ROOT}")
endif()

# Add compile options
add_compile_options(-Wall -Werror=return-type -Wno-attributes -DPROJECT_VERSION="1_0_0" -DCMS_MICRO_ARCH="UNKNOWN")
add_link_options(LINKER:-z,defs)

# Add subdirectories
add_subdirectory(DataFormats)
add_subdirectory(FWCore)
add_subdirectory(SimDataFormats)
add_subdirectory(Utilities)
