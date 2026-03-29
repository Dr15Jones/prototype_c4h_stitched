# FWCore/Common library
file(GLOB SOURCES src/*.cc)

# Generate ROOT dictionary if classes_def.xml exists
if(ROOT_FOUND AND EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/src/classes.h)
    set_property(DIRECTORY PROPERTY INCLUDE_DIRECTORIES $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>)
    root_generate_dictionary(FWCoreCommon_dict
        ${CMAKE_CURRENT_SOURCE_DIR}/src/classes.h
        LINKDEF ${CMAKE_CURRENT_SOURCE_DIR}/src/classes_def.xml
        NOINSTALL
        OPTIONS --reflex
    )
    list(APPEND SOURCES FWCoreCommon_dict.cxx)
endif()

add_library(FWCoreCommon SHARED ${SOURCES})

target_include_directories(FWCoreCommon
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(FWCoreCommon
    PUBLIC
        DataFormatsCommon
        DataFormatsProvenance
        FWCoreParameterSet
        FWCoreUtilities
        ROOT::Core
)

set_target_properties(FWCoreCommon PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
