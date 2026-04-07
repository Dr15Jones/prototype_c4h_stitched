# DataFormats/Common library
file(GLOB SOURCES src/*.cc)

add_library(DataFormatsCommon SHARED ${SOURCES})

# Generate ROOT dictionary if classes_def.xml exists
# Generate dictionary
root_generate_dictionary(DataFormatsCommon_dict
    ${CMAKE_CURRENT_SOURCE_DIR}/src/classes.h
    LINKDEF ${CMAKE_CURRENT_SOURCE_DIR}/src/classes_def.xml
    MODULE DataFormatsCommon
    OPTIONS --reflex
)

target_include_directories(DataFormatsCommon
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(DataFormatsCommon
    PUBLIC
        DataFormatsProvenance
        FWCoreMessageLogger
        FWCoreUtilities
        Boost::boost
        TBB::tbb
        ROOT::Core
)

set_target_properties(DataFormatsCommon PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
