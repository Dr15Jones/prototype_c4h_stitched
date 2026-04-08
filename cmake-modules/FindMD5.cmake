# FindMD5.cmake
# --------------
# Finds the MD5 library.
#
# This module will search for MD5 using the MD5_ROOT variable as a hint.
#
# This will define the following variables:
#
#   MD5_FOUND        - True if the system has the MD5 library
#   MD5_INCLUDE_DIRS - Include directories needed to use MD5
#   MD5_LIBRARIES    - Libraries needed to link to MD5
#   MD5_VERSION      - The version of MD5 found (if available)
#
# and the following imported targets:
#
#   MD5::md5 - The MD5 library

# Use MD5_ROOT as a hint for finding MD5
find_path(MD5_INCLUDE_DIR
    NAMES md5.h
    HINTS ${MD5_ROOT}
    PATH_SUFFIXES include
    DOC "MD5 include directory"
)

find_library(MD5_LIBRARY
    NAMES cms-md5 libcms-md5
    HINTS ${MD5_ROOT}
    PATH_SUFFIXES lib lib64
    DOC "MD5 library"
)

# Extract version from MD5_ROOT path if possible
if(MD5_ROOT AND MD5_ROOT MATCHES "md5/([0-9]+\\.[0-9]+\\.?[0-9]*)")
    set(MD5_VERSION ${CMAKE_MATCH_1})
endif()

# Handle standard arguments
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MD5
    REQUIRED_VARS MD5_LIBRARY MD5_INCLUDE_DIR
    VERSION_VAR MD5_VERSION
)

# Set standard variables
if(MD5_FOUND)
    set(MD5_LIBRARIES ${MD5_LIBRARY})
    set(MD5_INCLUDE_DIRS ${MD5_INCLUDE_DIR})
    
    # Create imported target if it doesn't exist
    if(NOT TARGET MD5::md5)
        add_library(MD5::md5 UNKNOWN IMPORTED)
        set_target_properties(MD5::md5 PROPERTIES
            IMPORTED_LOCATION "${MD5_LIBRARY}"
            INTERFACE_INCLUDE_DIRECTORIES "${MD5_INCLUDE_DIR}"
        )
    endif()
endif()

# Mark cache variables as advanced
mark_as_advanced(MD5_INCLUDE_DIR MD5_LIBRARY)
