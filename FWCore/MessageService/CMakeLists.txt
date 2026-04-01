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

# Copy and install Python files
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/python)
    file(RELATIVE_PATH PKG_PYTHON_PATH ${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
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
        add_library(FWCoreMessageServicePlugins MODULE ${PLUGIN_SOURCES})
        target_link_libraries(FWCoreMessageServicePlugins
            PRIVATE
                FWCoreMessageService
                FWCoreFramework
        )
        set_target_properties(FWCoreMessageServicePlugins PROPERTIES PREFIX "edmplugin")
    endif()
endif()
