# SimDataFormats/RandomEngine library
file(GLOB SOURCES src/*.cc)

add_library(SimDataFormatsRandomEngine SHARED ${SOURCES})

target_include_directories(SimDataFormatsRandomEngine
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(SimDataFormatsRandomEngine
    PUBLIC
        DataFormatsCommon
        FWCoreUtilities
        Boost::boost
)

set_target_properties(SimDataFormatsRandomEngine PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
