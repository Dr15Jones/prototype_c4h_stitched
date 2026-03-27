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
        FWCoreUtilities
        Boost::boost
        tinyxml2::tinyxml2
        CLHEP::CLHEP
        cpu_features::cpu_features
)

set_target_properties(FWCoreServices PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)

# Build plugins if they exist
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/plugins)
    file(GLOB PLUGIN_SOURCES plugins/*.cc)
    if(PLUGIN_SOURCES)
        add_library(FWCoreServicesPlugins MODULE ${PLUGIN_SOURCES})
        target_link_libraries(FWCoreServicesPlugins
            PRIVATE
                FWCoreServices
                FWCoreFramework
        )
        set_target_properties(FWCoreServicesPlugins PROPERTIES
            LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib/plugins
        )
    endif()
endif()
