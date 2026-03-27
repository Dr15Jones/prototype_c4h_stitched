# DataFormats/TestObjects library
file(GLOB SOURCES src/*.cc)

add_library(DataFormatsTestObjects SHARED ${SOURCES})

target_include_directories(DataFormatsTestObjects
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(DataFormatsTestObjects
    PUBLIC
        DataFormatsCommon
        DataFormatsProvenance
        FWCoreUtilities
)

set_target_properties(DataFormatsTestObjects PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
