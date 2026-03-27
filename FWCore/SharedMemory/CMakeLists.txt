# FWCore/SharedMemory library
file(GLOB SOURCES src/*.cc)

add_library(FWCoreSharedMemory SHARED ${SOURCES})

target_include_directories(FWCoreSharedMemory
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(FWCoreSharedMemory
    PUBLIC
        FWCoreFramework
        FWCoreUtilities
        Boost::boost
)

set_target_properties(FWCoreSharedMemory PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
