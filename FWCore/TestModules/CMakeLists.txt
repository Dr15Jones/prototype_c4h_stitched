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
# Also copy the modules.py template from FWCore/ParameterSet/templates
file(COPY ${CMAKE_SOURCE_DIR}/FWCore/ParameterSet/templates/modules.py
        DESTINATION ${CMAKE_BINARY_DIR}/python/${PKG_PYTHON_PATH})
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/python/
        DESTINATION python/${PKG_PYTHON_PATH}
        PATTERN "__pycache__" EXCLUDE
        PATTERN "*.pyc" EXCLUDE)
# Install the modules.py template as well
install(FILES ${CMAKE_SOURCE_DIR}/FWCore/ParameterSet/templates/modules.py
        DESTINATION python/${PKG_PYTHON_PATH})
