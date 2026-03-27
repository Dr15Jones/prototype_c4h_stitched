# FWCore/ParameterSetReader library
file(GLOB SOURCES src/*.cc)

add_library(FWCoreParameterSetReader SHARED ${SOURCES})

target_include_directories(FWCoreParameterSetReader
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(FWCoreParameterSetReader
    PUBLIC
        FWCoreParameterSet
        FWCoreUtilities
        FWCorePythonParameterSet
        Python3::Python
        pybind11::pybind11
)

set_target_properties(FWCoreParameterSetReader PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
