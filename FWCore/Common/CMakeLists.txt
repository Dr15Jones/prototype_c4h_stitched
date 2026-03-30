# FWCore/Common library
file(GLOB SOURCES src/*.cc)

add_library(FWCoreCommon SHARED ${SOURCES})

# Generate ROOT dictionary if classes_def.xml exists
root_generate_dictionary(FWCoreCommon_dict
    ${CMAKE_CURRENT_SOURCE_DIR}/src/classes.h
    LINKDEF ${CMAKE_CURRENT_SOURCE_DIR}/src/classes_def.xml
    MODULE FWCoreCommon
    NOINSTALL
    OPTIONS --reflex
)

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
