# FWCore/Services library
file(GLOB SOURCES src/*.cc)

add_library(FWCoreServices SHARED ${SOURCES})

target_include_directories(FWCoreServices
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(FWCoreServices
    PUBLIC
        SimDataFormatsRandomEngine
        FWCoreAbstractServices
        FWCoreMessageLogger
        FWCoreParameterSet
        FWCoreServiceRegistry
        DataFormatsProvenance
        FWCoreUtilities
        Boost::boost
        tinyxml2
        CLHEP::CLHEP
        CpuFeatures::cpu_features
        ROOT::Tree
        ROOT::Hist
        atomic
)

set_target_properties(FWCoreServices PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)

file(GLOB PLUGIN_SOURCES plugins/*.cc)
cmssw_generate_plugin(
    TARGET FWCoreServicesPlugins
    SOURCES ${PLUGIN_SOURCES}
    LINK_LIBRARIES
                FWCoreServices
                FWCoreFramework
)
