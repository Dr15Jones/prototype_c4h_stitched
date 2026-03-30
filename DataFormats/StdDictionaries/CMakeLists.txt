# DataFormats/StdDictionaries library
# This package contains ROOT dictionary definitions


add_library(DataFormatsStdDictionaries_map SHARED)
# Generate dictionary
root_generate_dictionary(DataFormatsStdDictionaries_map_dict
    src/classes_map.h
    LINKDEF src/classes_def_map.xml
    MODULE DataFormatsStdDictionaries_map
    NOINSTALL
    OPTIONS --reflex
)

target_include_directories(DataFormatsStdDictionaries_map
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(DataFormatsStdDictionaries_map PUBLIC ROOT::Core)

set_target_properties(DataFormatsStdDictionaries_map PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)

add_library(DataFormatsStdDictionaries_others SHARED)
# Generate dictionary
root_generate_dictionary(DataFormatsStdDictionaries_others_dict
    src/classes_others.h
    LINKDEF src/classes_def_others.xml
    MODULE DataFormatsStdDictionaries_others
    NOINSTALL
    OPTIONS --reflex
)

target_include_directories(DataFormatsStdDictionaries_others
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(DataFormatsStdDictionaries_others PUBLIC ROOT::Core)

set_target_properties(DataFormatsStdDictionaries_others PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
add_library(DataFormatsStdDictionaries_pair SHARED)
# Generate dictionary
root_generate_dictionary(DataFormatsStdDictionaries_pair_dict
    src/classes_pair.h
    LINKDEF src/classes_def_pair.xml
    MODULE DataFormatsStdDictionaries_pair
    NOINSTALL
    OPTIONS --reflex
)

target_include_directories(DataFormatsStdDictionaries_pair
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(DataFormatsStdDictionaries_pair PUBLIC ROOT::Core)

set_target_properties(DataFormatsStdDictionaries_pair PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
add_library(DataFormatsStdDictionaries_vector SHARED)
# Generate dictionary
root_generate_dictionary(DataFormatsStdDictionaries_vector_dict
    src/classes_vector.h
    LINKDEF src/classes_def_vector.xml
    MODULE DataFormatsStdDictionaries_vector
    NOINSTALL
    OPTIONS --reflex
)

target_include_directories(DataFormatsStdDictionaries_vector
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(DataFormatsStdDictionaries_vector PUBLIC ROOT::Core)

set_target_properties(DataFormatsStdDictionaries_vector PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
