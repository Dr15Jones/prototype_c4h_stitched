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
        DataFormatsProvenance
        FWCoreAbstractServices
        FWCorePluginManager
        FWCoreSources
        FWCoreParameterSet
        FWCoreUtilities
)
set_target_properties(FWCoreTestModulesPlugins PROPERTIES PREFIX "edmplugin")

file(RELATIVE_PATH PKG_PYTHON_PATH ${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
# Run edmWriteConfigs to generate Python configuration for this plugin library
add_custom_command(TARGET FWCoreTestModulesPlugins POST_BUILD
COMMAND ${CMAKE_BINARY_DIR}/bin/edmWriteConfigs -p $<TARGET_FILE:FWCoreTestModulesPlugins>
WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/python/${PKG_PYTHON_PATH}
COMMENT "Generating Python configs for FWCoreTestModulesPlugins"
)

# Also copy the modules.py template from FWCore/ParameterSet/templates
file(COPY ${CMAKE_SOURCE_DIR}/FWCore/ParameterSet/templates/modules.py
        DESTINATION ${CMAKE_BINARY_DIR}/python/${PKG_PYTHON_PATH})
# Install the modules.py template as well
install(FILES ${CMAKE_SOURCE_DIR}/FWCore/ParameterSet/templates/modules.py
        DESTINATION python/${PKG_PYTHON_PATH})
