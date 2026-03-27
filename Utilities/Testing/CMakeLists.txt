# Utilities/Testing library
# This is typically a header-only library or may not have sources

if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/src)
    file(GLOB SOURCES src/*.cc)
    if(SOURCES)
        add_library(UtilitiesTesting SHARED ${SOURCES})

        target_include_directories(UtilitiesTesting
            PUBLIC
                $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
                $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
                $<INSTALL_INTERFACE:include>
        )

        set_target_properties(UtilitiesTesting PROPERTIES
            VERSION 1.0.0
            SOVERSION 1
        )
    else()
        message(STATUS "Utilities/Testing has no source files - likely header-only")
    endif()
else()
    message(STATUS "Utilities/Testing has no src directory")
endif()
