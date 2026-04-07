# DataFormats/Provenance library
file(GLOB SOURCES src/*.cc)

add_library(DataFormatsProvenance SHARED ${SOURCES})

# Generate ROOT dictionary if classes_def.xml exists
root_generate_dictionary(DataFormatsProvenance_dict
    ${CMAKE_CURRENT_SOURCE_DIR}/src/classes.h
    LINKDEF ${CMAKE_CURRENT_SOURCE_DIR}/src/classes_def.xml
    MODULE DataFormatsProvenance
    OPTIONS --reflex
)

target_include_directories(DataFormatsProvenance
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(DataFormatsProvenance
    PUBLIC
        FWCoreUtilities
        FWCoreReflection
        Boost::boost
        TBB::tbb
        ROOT::Core
        ROOT::RIO
)

set_target_properties(DataFormatsProvenance PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
