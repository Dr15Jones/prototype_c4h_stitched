# DataFormats/TestObjects library
file(GLOB SOURCES src/*.cc)

add_library(DataFormatsTestObjects SHARED ${SOURCES})

# Generate ROOT dictionary if classes_def.xml exists
root_generate_dictionary(DataFormatsTestObjects_dict
    ${CMAKE_CURRENT_SOURCE_DIR}/src/classes.h
    LINKDEF ${CMAKE_CURRENT_SOURCE_DIR}/src/classes_def.xml
    MODULE DataFormatsTestObjects
    OPTIONS --reflex
)

target_include_directories(DataFormatsTestObjects
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(DataFormatsTestObjects
    PUBLIC
        DataFormatsCommon
        DataFormatsProvenance
        FWCoreUtilities
        ROOT::Core
)

set_target_properties(DataFormatsTestObjects PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
