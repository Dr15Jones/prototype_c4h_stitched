# DataFormats/StdDictionaries library
# This package contains ROOT dictionary definitions
file(GLOB SOURCES src/*.cc)

if(SOURCES AND ROOT_FOUND)
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
