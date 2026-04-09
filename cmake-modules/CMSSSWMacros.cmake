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

#[=======================================================================[.rst:
cmssw_generate_plugincache
--------------------------

Generate the .edmplugincache file for CMSSW EDM plugin libraries.

.. command:: cmssw_generate_plugincache

  ::

    cmssw_generate_plugincache(
        PLUGIN_TARGETS <target1> [<target2> ...]
        [OUTPUT_DIR <directory>]
        [CACHE_TARGET_NAME <name>]
    )

  Creates a custom command that runs edmPluginRefresh on all specified plugin
  targets to generate the .edmplugincache file, and installs the cache file.

  Arguments:
    ``PLUGIN_TARGETS``
      List of plugin target names to include in the cache.

    ``OUTPUT_DIR`` (optional)
      Directory where the .edmplugincache file will be generated.
      Defaults to ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}.

    ``CACHE_TARGET_NAME`` (optional)
      Name for the custom target that triggers cache generation.
      Defaults to "RefreshPluginCache".

  The function will:
    - Create a custom command that runs edmPluginRefresh on all plugins
    - Create a custom target (built by default) that depends on the cache
    - Install the .edmplugincache file to the library directory
    - Automatically handle plugin targets that may not exist

  Example:
    ::

      cmssw_generate_plugincache(
          PLUGIN_TARGETS
              FWCoreModulesPlugins
              FWCoreIntegrationPlugins
              FWCoreServicesPlugins
              MyCustomPlugins
      )

#]=======================================================================]
function(cmssw_generate_plugincache)
    # Parse arguments
    set(options "")
    set(oneValueArgs OUTPUT_DIR CACHE_TARGET_NAME)
    set(multiValueArgs PLUGIN_TARGETS)
    cmake_parse_arguments(CACHE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # Validate required arguments
    if(NOT CACHE_PLUGIN_TARGETS)
        message(FATAL_ERROR "cmssw_generate_plugincache: PLUGIN_TARGETS argument is required")
    endif()

    # Set defaults
    if(NOT CACHE_OUTPUT_DIR)
        set(CACHE_OUTPUT_DIR ${CMAKE_LIBRARY_OUTPUT_DIRECTORY})
    endif()

    if(NOT CACHE_CACHE_TARGET_NAME)
        set(CACHE_CACHE_TARGET_NAME "RefreshPluginCache")
    endif()

    # Build the command arguments and dependencies lists
    set(PLUGIN_COMMAND_ARGS "")
    set(PLUGIN_DEPENDS "edmPluginRefresh")

    foreach(plugin_target ${CACHE_PLUGIN_TARGETS})
        # Add target file to command arguments (only if target exists)
        list(APPEND PLUGIN_COMMAND_ARGS
            "$<$<TARGET_EXISTS:${plugin_target}>:$<TARGET_FILE:${plugin_target}>>")
        
        # Add target to dependencies (only if target exists)
        list(APPEND PLUGIN_DEPENDS
            "$<$<TARGET_EXISTS:${plugin_target}>:${plugin_target}>")
    endforeach()

    # Create custom command to generate the plugin cache
    add_custom_command(
        OUTPUT "${CACHE_OUTPUT_DIR}/.edmplugincache"
        COMMAND ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/edmPluginRefresh ${PLUGIN_COMMAND_ARGS}
        DEPENDS ${PLUGIN_DEPENDS}
        COMMENT "Refreshing plugin cache for edmplugin libraries"
        VERBATIM
    )

    # Add a custom target that depends on the plugin cache and is built by default
    add_custom_target(${CACHE_CACHE_TARGET_NAME} ALL
        DEPENDS "${CACHE_OUTPUT_DIR}/.edmplugincache"
    )

    # Install the plugin cache file
    install(FILES "${CACHE_OUTPUT_DIR}/.edmplugincache"
            TYPE LIB)  # Automatically uses CMAKE_INSTALL_LIBDIR

endfunction()
