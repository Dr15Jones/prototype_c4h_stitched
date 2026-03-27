# DataFormats/Provenance library
file(GLOB SOURCES src/*.cc)

add_library(DataFormatsProvenance SHARED ${SOURCES})

target_include_directories(DataFormatsProvenance
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(DataFormatsProvenance
    PUBLIC
        FWCoreUtilities
        FWCoreReflection
        Boost::boost
        TBB::tbb
)

if(ROOT_FOUND)
    target_link_libraries(DataFormatsProvenance PUBLIC ROOT::Core ROOT::RIO)
endif()

set_target_properties(DataFormatsProvenance PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
