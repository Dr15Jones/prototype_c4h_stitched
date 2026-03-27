# FWCore/Framework library
file(GLOB SOURCES src/*.cc)

add_library(FWCoreFramework SHARED ${SOURCES})

target_include_directories(FWCoreFramework
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(FWCoreFramework
    PUBLIC
        DataFormatsCommon
        DataFormatsProvenance
        FWCoreAbstractServices
        FWCoreCommon
        FWCoreConcurrency
        FWCoreMessageLogger
        FWCoreParameterSet
        FWCorePluginManager
        FWCoreReflection
        FWCoreServiceRegistry
        FWCoreUtilities
        FWCoreVersion
        Boost::boost
        Boost::program_options
        TBB::tbb
)

if(ROOT_FOUND)
    target_link_libraries(FWCoreFramework PUBLIC ROOT::Core ROOT::RIO ROOT::Net ROOT::Tree)
endif()

set_target_properties(FWCoreFramework PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
