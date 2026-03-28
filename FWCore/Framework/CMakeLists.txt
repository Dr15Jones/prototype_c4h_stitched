# FWCore/Framework library
file(GLOB SOURCES src/*.cc src/global/*.cc src/limited/*.cc src/one/*.cc src/stream/*.cc)

add_library(FWCoreFramework SHARED ${SOURCES})

target_include_directories(FWCoreFramework
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(FWCoreFramework
    PUBLIC
        DataFormatsCommon
        DataFormatsProvenance
        FWCoreAbstractServices
        FWCoreCommon
        FWCoreConcurrency
        FWCoreMessageLogger
        FWCoreParameterSet
        FWCorePluginManager
        FWCoreReflection
        FWCoreServiceRegistry
        FWCoreUtilities
        FWCoreVersion
        Boost::boost
        Boost::program_options
        TBB::tbb
        ROOT::Core
)

set_target_properties(FWCoreFramework PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
)

# Build cmsRun executable
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/bin/cmsRun.cpp)
    add_executable(cmsRun bin/cmsRun.cpp)
    
    target_include_directories(cmsRun
        PRIVATE
            ${CMAKE_CURRENT_SOURCE_DIR}/interface
            ${CMAKE_SOURCE_DIR}
    )
    
    target_link_libraries(cmsRun
        PRIVATE
            FWCoreFramework
            FWCoreParameterSetReader
            FWCoreParameterSet
            FWCoreMessageLogger
            FWCorePluginManager
            FWCoreServiceRegistry
            FWCoreUtilities
            FWCoreConcurrency
            TBB::tbb
            ROOT::Core
    )
    
    set_target_properties(cmsRun PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
    )
endif()
