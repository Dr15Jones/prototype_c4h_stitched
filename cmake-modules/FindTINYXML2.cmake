# FindTINYXML2.cmake
# -------------------
# Finds the TinyXML2 library.
#
# This module will search for TinyXML2 using the TINYXML2_ROOT variable as a hint.
#
# This will define the following variables:
#
#   TINYXML2_FOUND        - True if the system has the TinyXML2 library
#   TINYXML2_INCLUDE_DIRS - Include directories needed to use TinyXML2
#   TINYXML2_LIBRARIES    - Libraries needed to link to TinyXML2
#   TINYXML2_VERSION      - The version of TinyXML2 found (if available)
#
# and the following imported targets:
#
#   tinyxml2::tinyxml2 - The TinyXML2 library

# Use TINYXML2_ROOT as a hint for finding TinyXML2
find_path(TINYXML2_INCLUDE_DIR
    NAMES tinyxml2.h
    HINTS ${TINYXML2_ROOT}
    PATH_SUFFIXES include
    DOC "TinyXML2 include directory"
)

find_library(TINYXML2_LIBRARY
    NAMES tinyxml2 libtinyxml2
    HINTS ${TINYXML2_ROOT}
    PATH_SUFFIXES lib lib64
    DOC "TinyXML2 library"
)

# Extract version from TINYXML2_ROOT path if possible
if(TINYXML2_ROOT AND TINYXML2_ROOT MATCHES "tinyxml2/([0-9]+\\.[0-9]+\\.?[0-9]*)")
    set(TINYXML2_VERSION ${CMAKE_MATCH_1})
endif()

# Handle standard arguments
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(TINYXML2
    REQUIRED_VARS TINYXML2_LIBRARY TINYXML2_INCLUDE_DIR
    VERSION_VAR TINYXML2_VERSION
)

# Set standard variables
if(TINYXML2_FOUND)
    set(TINYXML2_LIBRARIES ${TINYXML2_LIBRARY})
    set(TINYXML2_INCLUDE_DIRS ${TINYXML2_INCLUDE_DIR})
    
    # Create imported target if it doesn't exist
    if(NOT TARGET tinyxml2::tinyxml2)
        add_library(tinyxml2::tinyxml2 UNKNOWN IMPORTED)
        set_target_properties(tinyxml2::tinyxml2 PROPERTIES
            IMPORTED_LOCATION "${TINYXML2_LIBRARY}"
            INTERFACE_INCLUDE_DIRECTORIES "${TINYXML2_INCLUDE_DIR}"
        )
    endif()
endif()

# Mark cache variables as advanced
mark_as_advanced(TINYXML2_INCLUDE_DIR TINYXML2_LIBRARY)
