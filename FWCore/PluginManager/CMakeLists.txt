# FWCore/PluginManager library
file(GLOB SOURCES src/*.cc)

add_library(FWCorePluginManager SHARED ${SOURCES})

target_include_directories(FWCorePluginManager
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(FWCorePluginManager
    PUBLIC
        FWCoreUtilities
        Boost::filesystem
        ${CMAKE_DL_LIBS}
)

if(ROOT_FOUND)
    target_link_libraries(FWCorePluginManager PUBLIC ROOT::Core)
endif()

set_target_properties(FWCorePluginManager PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
