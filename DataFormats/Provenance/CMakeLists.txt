# DataFormats/Provenance library
file(GLOB SOURCES src/*.cc)

# Generate ROOT dictionary if classes_def.xml exists
if(ROOT_FOUND AND EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/src/classes.h)
    set_property(DIRECTORY PROPERTY INCLUDE_DIRECTORIES $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>)
    root_generate_dictionary(DataFormatsProvenance_dict
        ${CMAKE_CURRENT_SOURCE_DIR}/src/classes.h
        LINKDEF ${CMAKE_CURRENT_SOURCE_DIR}/src/classes_def.xml
        NOINSTALL
        NO_CXXMODULE
        OPTIONS --reflex
    )
    list(APPEND SOURCES DataFormatsProvenance_dict.cxx)
endif()

add_library(DataFormatsProvenance SHARED ${SOURCES})

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
