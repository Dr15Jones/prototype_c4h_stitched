# FWCore/Modules library
file(GLOB SOURCES plugins/*.cc)

add_library(FWCoreTestModulesPlugins SHARED ${SOURCES})

target_include_directories(FWCoreTestModulesPlugins
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(FWCoreTestModulesPlugins
    PUBLIC
        FWCoreFramework
        FWCoreParameterSet
)
set_target_properties(FWCoreTestModulesPlugins PROPERTIES PREFIX "edmplugin")
