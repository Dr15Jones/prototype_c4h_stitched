# FindPYBIND11.cmake
# ------------------
# Finds the pybind11 library.
#
# This module will search for pybind11 using the PYBIND11_ROOT variable as a hint.
#
# This will define the following variables:
#
#   PYBIND11_FOUND        - True if the system has pybind11
#   PYBIND11_INCLUDE_DIRS - Include directories needed to use pybind11
#   PYBIND11_VERSION      - The version of pybind11 found (if available)
#
# and the following imported targets:
#
#   pybind11::pybind11 - The pybind11 interface library

# Use PYBIND11_ROOT as a hint for finding pybind11
find_path(PYBIND11_INCLUDE_DIR
    NAMES pybind11/pybind11.h
    HINTS ${PYBIND11_ROOT}
    PATH_SUFFIXES include
    DOC "pybind11 include directory"
)

# Extract version from PYBIND11_ROOT path if possible
if(PYBIND11_ROOT AND PYBIND11_ROOT MATCHES "pybind11/([0-9]+\\.[0-9]+\\.?[0-9]*)")
    set(PYBIND11_VERSION ${CMAKE_MATCH_1})
endif()

# Handle standard arguments
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PYBIND11
    REQUIRED_VARS PYBIND11_INCLUDE_DIR
    VERSION_VAR PYBIND11_VERSION
)

# Set standard variables
if(PYBIND11_FOUND)
    set(PYBIND11_INCLUDE_DIRS ${PYBIND11_INCLUDE_DIR})
    
    # pybind11 requires Python3, so include Python3 headers if available
    if(Python3_INCLUDE_DIRS)
        list(APPEND PYBIND11_INCLUDE_DIRS ${Python3_INCLUDE_DIRS})
    elseif(Python3_INCLUDE_DIR)
        list(APPEND PYBIND11_INCLUDE_DIRS ${Python3_INCLUDE_DIR})
    endif()
    
    # Create imported target if it doesn't exist
    if(NOT TARGET pybind11::pybind11)
        add_library(pybind11::pybind11 INTERFACE IMPORTED)
        set_target_properties(pybind11::pybind11 PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${PYBIND11_INCLUDE_DIRS}"
        )
    endif()
endif()

# Mark cache variables as advanced
mark_as_advanced(PYBIND11_INCLUDE_DIR)
