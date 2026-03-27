# FWCore/Concurrency library
file(GLOB SOURCES src/*.cc)

add_library(FWCoreConcurrency SHARED ${SOURCES})

target_include_directories(FWCoreConcurrency
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(FWCoreConcurrency
    PUBLIC
        FWCoreUtilities
        TBB::tbb
        Threads::Threads
)

set_target_properties(FWCoreConcurrency PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
