# DataFormats/TestObjects library
file(GLOB SOURCES src/*.cc)

# Generate ROOT dictionary if classes_def.xml exists
if(ROOT_FOUND AND EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/src/classes.h)
    get_target_property(MY_INCLUDES DataFormatsCommon INCLUDE_DIRECTORIES)
    get_target_property(TBB_INCLUDES TBB::tbb INTERFACE_INCLUDE_DIRECTORIES)
    set_property(DIRECTORY PROPERTY INCLUDE_DIRECTORIES $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}> ${MY_INCLUDES} ${TBB_INCLUDES})
    root_generate_dictionary(DataFormatsTestObjects_dict
        ${CMAKE_CURRENT_SOURCE_DIR}/src/classes.h
        LINKDEF ${CMAKE_CURRENT_SOURCE_DIR}/src/classes_def.xml
        NOINSTALL
        OPTIONS --reflex
    )
    list(APPEND SOURCES DataFormatsTestObjects_dict.cxx)
endif()

add_library(DataFormatsTestObjects SHARED ${SOURCES})

target_include_directories(DataFormatsTestObjects
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(DataFormatsTestObjects
    PUBLIC
        DataFormatsCommon
        DataFormatsProvenance
        FWCoreUtilities
        ROOT::Core
)

set_target_properties(DataFormatsTestObjects PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)
