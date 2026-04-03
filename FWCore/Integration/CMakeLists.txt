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


file(RELATIVE_PATH PKG_PYTHON_PATH ${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
# Copy and install Python files
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/python)
    file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/python/
         DESTINATION ${CMAKE_BINARY_DIR}/python/${PKG_PYTHON_PATH}
         PATTERN "__pycache__" EXCLUDE
         PATTERN "*.pyc" EXCLUDE)
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
endif()

# Build plugins if they exist
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/plugins)
    file(GLOB PLUGIN_SOURCES plugins/*.cc)
    if(PLUGIN_SOURCES)
        add_library(FWCoreIntegrationPlugins MODULE ${PLUGIN_SOURCES})
        target_link_libraries(FWCoreIntegrationPlugins
            PRIVATE
                FWCoreIntegration
                FWCoreSources
                FWCoreFramework
                DataFormatsTestObjects
                DataFormatsProvenance
                FWCoreSharedMemory
                ROOT::Hist
                ROOT::Core
        )
        set_target_properties(FWCoreIntegrationPlugins PROPERTIES PREFIX "edmplugin")
    endif()
    # Run edmWriteConfigs to generate Python configuration for this plugin library
    add_custom_command(TARGET FWCoreIntegrationPlugins POST_BUILD
      COMMAND ${CMAKE_BINARY_DIR}/bin/edmWriteConfigs -p $<TARGET_FILE:FWCoreIntegrationPlugins>
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/python/${PKG_PYTHON_PATH}
      COMMENT "Generating Python configs for FWCoreIntegrationPlugins"
    )
endif()
