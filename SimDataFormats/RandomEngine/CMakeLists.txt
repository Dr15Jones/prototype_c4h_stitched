# SimDataFormats/RandomEngine library
file(GLOB SOURCES src/*.cc)

# Generate ROOT dictionary if classes_def.xml exists
if(ROOT_FOUND AND EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/src/classes.h)
    set_property(DIRECTORY PROPERTY INCLUDE_DIRECTORIES $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}> ${MY_INCLUDES} ${TBB_INCLUDES})
    root_generate_dictionary(SimDataFormatsRandomEngine_dict
        ${CMAKE_CURRENT_SOURCE_DIR}/src/classes.h
        LINKDEF ${CMAKE_CURRENT_SOURCE_DIR}/src/classes_def.xml
        NOINSTALL
        OPTIONS --reflex
    )
    list(APPEND SOURCES SimDataFormatsRandomEngine_dict.cxx)
endif()

add_library(SimDataFormatsRandomEngine SHARED ${SOURCES})

target_include_directories(SimDataFormatsRandomEngine
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(SimDataFormatsRandomEngine
    PUBLIC
        DataFormatsCommon
        FWCoreUtilities
        Boost::boost
        ROOT::Core
)

set_target_properties(SimDataFormatsRandomEngine PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
