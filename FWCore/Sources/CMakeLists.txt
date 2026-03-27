# FWCore/Sources library
file(GLOB SOURCES src/*.cc)

add_library(FWCoreSources SHARED ${SOURCES})

target_include_directories(FWCoreSources
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(FWCoreSources
    PUBLIC
        FWCoreFramework
        FWCoreUtilities
)

set_target_properties(FWCoreSources PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
