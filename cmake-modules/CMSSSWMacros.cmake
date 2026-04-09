# CMSSSWMacros.cmake
# Utility functions for CMSSW projects

#[=======================================================================[.rst:
cmssw_generate_plugin
---------------------

Generate a CMSSW EDM plugin library with automatic configuration generation.

.. command:: cmssw_generate_plugin

  ::

    cmssw_generate_plugin(
        TARGET <target_name>
        SOURCES <source1> [<source2> ...]
        LINK_LIBRARIES <lib1> [<lib2> ...]
        [INCLUDE_DIRECTORIES <dir1> [<dir2> ...]]
    )

  Creates a shared library target with the "edmplugin" prefix and generates
  Python configuration files using edmWriteConfigs.

  Arguments:
    ``TARGET``
      Name of the plugin target to create.

    ``SOURCES``
      List of source files for the plugin.

    ``LINK_LIBRARIES``
      List of libraries to link against.

    ``INCLUDE_DIRECTORIES``
      Optional list of additional include directories (beyond standard paths).

  The function will:
    - Create a shared library with the "edmplugin" prefix
    - Set up include directories for build and install interfaces
    - Link against specified libraries
    - Run edmWriteConfigs to generate Python configurations
    - Copy and install any Python files from the python/ subdirectory

  Example:
    ::

      file(GLOB PLUGIN_SOURCES src/*.cc)
      cmssw_generate_plugin(
          TARGET MyPlugins
          SOURCES ${PLUGIN_SOURCES}
          LINK_LIBRARIES
              FWCoreFramework
              FWCoreParameterSet
      )

#]=======================================================================]
function(cmssw_generate_plugin)
    # Parse arguments
    set(options "")
    set(oneValueArgs TARGET)
    set(multiValueArgs SOURCES LINK_LIBRARIES INCLUDE_DIRECTORIES)
    cmake_parse_arguments(PLUGIN "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # Validate required arguments
    if(NOT PLUGIN_TARGET)
        message(FATAL_ERROR "cmssw_generate_plugin: TARGET argument is required")
    endif()
    if(NOT PLUGIN_SOURCES)
        message(FATAL_ERROR "cmssw_generate_plugin: SOURCES argument is required")
    endif()

    # Create the plugin library
    add_library(${PLUGIN_TARGET} SHARED ${PLUGIN_SOURCES})

    # Set up include directories
    target_include_directories(${PLUGIN_TARGET}
        PUBLIC
            $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
            $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
            $<INSTALL_INTERFACE:include>
            ${PLUGIN_INCLUDE_DIRECTORIES}
    )

    # Link with specified libraries
    if(PLUGIN_LINK_LIBRARIES)
        target_link_libraries(${PLUGIN_TARGET}
            PUBLIC
                ${PLUGIN_LINK_LIBRARIES}
        )
    endif()

    # Set the plugin prefix
    set_target_properties(${PLUGIN_TARGET} PROPERTIES PREFIX "edmplugin")

    # Calculate relative Python path for this package
    file(RELATIVE_PATH PKG_PYTHON_PATH ${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR})

    # Run edmWriteConfigs to generate Python configuration for this plugin library
    # The POST_BUILD command ensures this runs after the plugin is built
    # CMake will ensure edmWriteConfigs is built before this command runs
    add_custom_command(TARGET ${PLUGIN_TARGET} POST_BUILD
        COMMAND ${CMAKE_BINARY_DIR}/bin/edmWriteConfigs -p $<TARGET_FILE:${PLUGIN_TARGET}>
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/python/${PKG_PYTHON_PATH}
        COMMENT "Generating Python configs for ${PLUGIN_TARGET}"
    )

    # Copy and install Python files if they exist
    if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/python)
        file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/python/
             DESTINATION ${CMAKE_BINARY_DIR}/python/${PKG_PYTHON_PATH}
             PATTERN "__pycache__" EXCLUDE
             PATTERN "*.pyc" EXCLUDE)
        
        # Install Python files
        install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/python/
                DESTINATION python/${PKG_PYTHON_PATH}
                PATTERN "__pycache__" EXCLUDE
                PATTERN "*.pyc" EXCLUDE)
        
    endif()
        # Also copy the modules.py template if available
    if(EXISTS ${CMAKE_SOURCE_DIR}/FWCore/ParameterSet/templates/modules.py)
        file(COPY ${CMAKE_SOURCE_DIR}/FWCore/ParameterSet/templates/modules.py
                DESTINATION ${CMAKE_BINARY_DIR}/python/${PKG_PYTHON_PATH})
    endif()
    # Install modules.py template if available
    if(EXISTS ${CMAKE_SOURCE_DIR}/FWCore/ParameterSet/templates/modules.py)
        install(FILES ${CMAKE_SOURCE_DIR}/FWCore/ParameterSet/templates/modules.py
                DESTINATION python/${PKG_PYTHON_PATH})
    endif()

endfunction()
