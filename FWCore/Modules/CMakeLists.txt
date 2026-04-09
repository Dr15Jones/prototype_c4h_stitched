# FWCore/Modules library
file(GLOB SOURCES src/*.cc)

cmssw_generate_plugin(
    TARGET FWCoreModulesPlugins
    SOURCES ${SOURCES}
    LINK_LIBRARIES
        FWCoreSources
        FWCoreFramework
        FWCoreParameterSet
)
