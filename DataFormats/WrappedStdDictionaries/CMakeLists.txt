# DataFormats/WrappedStdDictionaries library
# This package contains ROOT dictionary definitions
file(GLOB SOURCES src/*.cc)

if(ROOT_FOUND)
    # Generate dictionary
    set_property(DIRECTORY PROPERTY INCLUDE_DIRECTORIES $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}> )
    root_generate_dictionary(DataFormatsWrappedStdDictionaries_dict
        ${CMAKE_CURRENT_SOURCE_DIR}/src/classes.h
        LINKDEF ${CMAKE_CURRENT_SOURCE_DIR}/src/classes_def.xml
        NOINSTALL
        OPTIONS --reflex
    )
    list(APPEND SOURCES DataFormatsWrappedStdDictionaries_dict.cxx)
    add_library(DataFormatsWrappedStdDictionaries SHARED ${SOURCES})

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
else()
    message(STATUS "DataFormats/WrappedStdDictionaries: No sources - skipping")
endif()
