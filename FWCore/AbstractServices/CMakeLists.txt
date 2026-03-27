# FWCore/AbstractServices library
file(GLOB SOURCES src/*.cc)

add_library(FWCoreAbstractServices SHARED ${SOURCES})

target_include_directories(FWCoreAbstractServices
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

set_target_properties(FWCoreAbstractServices PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
