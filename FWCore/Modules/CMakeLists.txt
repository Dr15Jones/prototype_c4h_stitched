# FWCore/Modules library
file(GLOB SOURCES src/*.cc)

add_library(FWCoreModulesPlugins SHARED ${SOURCES})

target_include_directories(FWCoreModulesPlugins
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(FWCoreModulesPlugins
    PUBLIC
        FWCoreFramework
        FWCoreParameterSet
)
set_target_properties(FWCoreModulesPlugins PROPERTIES PREFIX "edmplugin")
