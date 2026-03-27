# FWCore/Modules library
file(GLOB SOURCES src/*.cc)

add_library(FWCoreModules SHARED ${SOURCES})

target_include_directories(FWCoreModules
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(FWCoreModules
    PUBLIC
        FWCoreFramework
        FWCoreParameterSet
)

set_target_properties(FWCoreModules PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
