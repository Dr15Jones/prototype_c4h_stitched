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
        DataFormatsProvenance
        FWCoreUtilities
        Boost::boost
        tinyxml2::tinyxml2
        CLHEP::CLHEP
        cpu_features::cpu_features
        ROOT::Tree
        ROOT::Hist
        atomic
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
        set_target_properties(FWCoreServicesPlugins PROPERTIES PREFIX "edmplugin")
    endif()
endif()

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
