# FWCore/Utilities library
file(GLOB SOURCES src/*.cc)

add_library(FWCoreUtilities SHARED ${SOURCES})

target_include_directories(FWCoreUtilities
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(FWCoreUtilities
    PUBLIC
        Boost::boost
        TBB::tbb
        Threads::Threads
        MD5::md5
)

# Try to link UUID if available
find_library(UUID_LIBRARY uuid)
if(UUID_LIBRARY)
    target_link_libraries(FWCoreUtilities PUBLIC ${UUID_LIBRARY})
endif()

set_target_properties(FWCoreUtilities PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
