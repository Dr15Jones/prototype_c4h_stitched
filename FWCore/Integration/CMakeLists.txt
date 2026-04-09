# FWCore/Integration library
file(GLOB SOURCES src/*.cc)

add_library(FWCoreIntegration SHARED ${SOURCES})

target_include_directories(FWCoreIntegration
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(FWCoreIntegration
    PUBLIC
        DataFormatsCommon
        DataFormatsProvenance
        FWCoreFramework
        FWCoreParameterSet
        FWCoreUtilities
        CLHEP::CLHEP
)

set_target_properties(FWCoreIntegration PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)

file(GLOB PLUGIN_SOURCES plugins/*.cc)
cmssw_generate_plugin(
    TARGET FWCoreIntegrationPlugins
    SOURCES ${PLUGIN_SOURCES}
    LINK_LIBRARIES
                FWCoreIntegration
                FWCoreSources
                FWCoreFramework
                DataFormatsTestObjects
                DataFormatsProvenance
                FWCoreSharedMemory
                ROOT::Hist
                ROOT::Core
)
