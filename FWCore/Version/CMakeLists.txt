# FWCore/Version library
file(GLOB SOURCES src/*.cc)

add_library(FWCoreVersion SHARED ${SOURCES})

target_include_directories(FWCoreVersion
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

set_target_properties(FWCoreVersion PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
