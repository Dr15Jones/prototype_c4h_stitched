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

# Build plugins if they exist
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/plugins)
    file(GLOB PLUGIN_SOURCES plugins/*.cc)
    if(PLUGIN_SOURCES)
        add_library(FWCoreIntegrationPlugins MODULE ${PLUGIN_SOURCES})
        target_link_libraries(FWCoreIntegrationPlugins
            PRIVATE
                FWCoreIntegration
                FWCoreFramework
        )
        set_target_properties(FWCoreIntegrationPlugins PROPERTIES
            LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib/plugins
        )
    endif()
endif()
