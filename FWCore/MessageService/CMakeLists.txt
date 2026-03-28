# FWCore/MessageService library
file(GLOB SOURCES src/*.cc)

add_library(FWCoreMessageService SHARED ${SOURCES})

target_include_directories(FWCoreMessageService
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(FWCoreMessageService
    PUBLIC
        FWCoreMessageLogger
        FWCoreParameterSet
        FWCoreServiceRegistry
        FWCoreUtilities
        Threads::Threads
)

set_target_properties(FWCoreMessageService PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)

# Build plugins if they exist
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/plugins)
    file(GLOB PLUGIN_SOURCES plugins/*.cc)
    if(PLUGIN_SOURCES)
        add_library(FWCoreMessageServicePlugins MODULE ${PLUGIN_SOURCES})
        target_link_libraries(FWCoreMessageServicePlugins
            PRIVATE
                FWCoreMessageService
                FWCoreFramework
        )
        set_target_properties(FWCoreMessageServicePlugins PROPERTIES PREFIX "edmplugin")
    endif()
endif()
