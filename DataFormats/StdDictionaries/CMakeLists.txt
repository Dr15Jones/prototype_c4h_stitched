# DataFormats/StdDictionaries library
# This package contains ROOT dictionary definitions
file(GLOB SOURCES src/*.cc)

if(ROOT_FOUND)
    # Generate dictionary
    set_property(DIRECTORY PROPERTY INCLUDE_DIRECTORIES $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}> )
    root_generate_dictionary(DataFormatsStdDictionaries_map_dict
        ${CMAKE_CURRENT_SOURCE_DIR}/src/classes_map.h
        LINKDEF ${CMAKE_CURRENT_SOURCE_DIR}/src/classes_def_map.xml
        NOINSTALL
        OPTIONS --reflex
    )
    root_generate_dictionary(DataFormatsStdDictionaries_others_dict
        ${CMAKE_CURRENT_SOURCE_DIR}/src/classes_others.h
        LINKDEF ${CMAKE_CURRENT_SOURCE_DIR}/src/classes_def_others.xml
        NOINSTALL
        OPTIONS --reflex
    )
    root_generate_dictionary(DataFormatsStdDictionaries_pair_dict
        ${CMAKE_CURRENT_SOURCE_DIR}/src/classes_pair.h
        LINKDEF ${CMAKE_CURRENT_SOURCE_DIR}/src/classes_def_pair.xml
        NOINSTALL
        OPTIONS --reflex
    )
    root_generate_dictionary(DataFormatsStdDictionaries_vector_dict
        ${CMAKE_CURRENT_SOURCE_DIR}/src/classes_vector.h
        LINKDEF ${CMAKE_CURRENT_SOURCE_DIR}/src/classes_def_vector.xml
        NOINSTALL
        OPTIONS --reflex
    )
    list(APPEND SOURCES DataFormatsStdDictionaries_map_dict.cxx)
    list(APPEND SOURCES DataFormatsStdDictionaries_others_dict.cxx)
    list(APPEND SOURCES DataFormatsStdDictionaries_pair_dict.cxx)
    list(APPEND SOURCES DataFormatsStdDictionaries_vector_dict.cxx)

    add_library(DataFormatsStdDictionaries SHARED ${SOURCES})

    target_include_directories(DataFormatsStdDictionaries
        PUBLIC
            $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
            $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
            $<INSTALL_INTERFACE:include>
    )


    target_link_libraries(DataFormatsStdDictionaries PUBLIC ROOT::Core)

    set_target_properties(DataFormatsStdDictionaries PROPERTIES
        VERSION 1.0.0
        SOVERSION 1
    )
else()
    message(STATUS "DataFormats/StdDictionaries: No sources or ROOT not found - skipping")
endif()
