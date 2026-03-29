# FWCore/ParameterSet library
file(GLOB SOURCES src/*.cc)

add_library(FWCoreParameterSet SHARED ${SOURCES})

target_include_directories(FWCoreParameterSet
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(FWCoreParameterSet
    PUBLIC
        FWCorePluginManager
        FWCoreMessageLogger
        DataFormatsProvenance
        FWCoreUtilities
        Boost::boost
        TBB::tbb
        Python3::Python
)

set_target_properties(FWCoreParameterSet PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
