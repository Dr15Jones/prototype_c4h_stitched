# FWCore/PythonParameterSet library
file(GLOB SOURCES src/*.cc)

if(NOT SOURCES)
    message(FATAL_ERROR "No source files found for FWCorePythonParameterSet")
endif()

add_library(FWCorePythonParameterSet SHARED ${SOURCES})

target_include_directories(FWCorePythonParameterSet
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(FWCorePythonParameterSet
    PUBLIC
        FWCoreParameterSet
        Python3::Python
        pybind11::pybind11
)

set_target_properties(FWCorePythonParameterSet PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
