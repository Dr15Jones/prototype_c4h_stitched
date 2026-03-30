# FWCore/ParameterSet/bin - Build parameter set utilities

# edmPluginHelp executable
add_executable(edmPluginHelp edmPluginHelp.cpp)

target_include_directories(edmPluginHelp
    PRIVATE
        ${CMAKE_SOURCE_DIR}
)

target_link_libraries(edmPluginHelp
    PRIVATE
        FWCoreParameterSet
        FWCorePluginManager
        FWCoreUtilities
        Boost::program_options
)

# edmWriteConfigs executable
add_executable(edmWriteConfigs edmWriteConfigs.cpp)

target_include_directories(edmWriteConfigs
    PRIVATE
        ${CMAKE_SOURCE_DIR}
)

target_link_libraries(edmWriteConfigs
    PRIVATE
        FWCoreParameterSet
        FWCorePluginManager
        FWCoreUtilities
        Boost::program_options
)
