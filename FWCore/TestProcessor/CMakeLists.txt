# FWCore/TestProcessor library
file(GLOB SOURCES src/*.cc)

add_library(FWCoreTestProcessor SHARED ${SOURCES})

target_include_directories(FWCoreTestProcessor
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(FWCoreTestProcessor
    PUBLIC
        FWCoreFramework
        FWCoreServiceRegistry
        FWCorePythonParameterSet
)

set_target_properties(FWCoreTestProcessor PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
