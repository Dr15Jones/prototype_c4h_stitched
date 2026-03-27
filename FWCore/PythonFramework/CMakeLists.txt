# FWCore/PythonFramework library
file(GLOB SOURCES src/*.cc)

if(NOT SOURCES)
    message(FATAL_ERROR "No source files found for FWCorePythonFramework")
endif()

add_library(FWCorePythonFramework SHARED ${SOURCES})

target_include_directories(FWCorePythonFramework
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(FWCorePythonFramework
    PUBLIC
        FWCoreFramework
        FWCorePythonParameterSet
        Python3::Python
)

set_target_properties(FWCorePythonFramework PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
