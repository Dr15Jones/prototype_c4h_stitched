# DataFormats/WrappedStdDictionaries library
# This package contains ROOT dictionary definitions

add_library(DataFormatsWrappedStdDictionaries SHARED)

# Generate dictionary
set_property(DIRECTORY PROPERTY INCLUDE_DIRECTORIES $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}> )
root_generate_dictionary(DataFormatsWrappedStdDictionaries_dict
    ${CMAKE_CURRENT_SOURCE_DIR}/src/classes.h
    LINKDEF ${CMAKE_CURRENT_SOURCE_DIR}/src/classes_def.xml
    MODULE DataFormatsWrappedStdDictionaries
    OPTIONS --reflex
)

target_include_directories(DataFormatsWrappedStdDictionaries
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(DataFormatsWrappedStdDictionaries
    PUBLIC
        DataFormatsCommon
        ROOT::Core
)

set_target_properties(DataFormatsWrappedStdDictionaries PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
