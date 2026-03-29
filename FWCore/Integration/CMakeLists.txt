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

# Copy and install Python files
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/python)
    file(RELATIVE_PATH PKG_PYTHON_PATH ${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
    file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/python/
         DESTINATION ${CMAKE_BINARY_DIR}/python/${PKG_PYTHON_PATH}
         PATTERN "__pycache__" EXCLUDE
         PATTERN "*.pyc" EXCLUDE)
    install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/python/
            DESTINATION python/${PKG_PYTHON_PATH}
            PATTERN "__pycache__" EXCLUDE
            PATTERN "*.pyc" EXCLUDE)
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
endif()
