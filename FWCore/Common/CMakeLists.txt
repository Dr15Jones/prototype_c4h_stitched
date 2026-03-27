# FWCore/Common library
file(GLOB SOURCES src/*.cc)

add_library(FWCoreCommon SHARED ${SOURCES})

target_include_directories(FWCoreCommon
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(FWCoreCommon
    PUBLIC
        DataFormatsCommon
        FWCoreUtilities
)

if(ROOT_FOUND)
    target_link_libraries(FWCoreCommon PUBLIC ROOT::Core)
endif()

set_target_properties(FWCoreCommon PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
