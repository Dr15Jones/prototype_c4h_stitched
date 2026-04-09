# cmssw_generate_plugin Function Usage Guide

This document describes how to use the `cmssw_generate_plugin()` CMake function to create CMSSW EDM plugin libraries.

## Overview

The `cmssw_generate_plugin()` function simplifies the creation of CMSSW plugin libraries by:
- Creating a shared library with the "edmplugin" prefix
- Setting up proper build and install interface include directories
- Running `edmWriteConfigs` to generate Python configuration files
- Handling Python file installation

## Function Signature

```cmake
cmssw_generate_plugin(
    TARGET <target_name>
    SOURCES <source1> [<source2> ...]
    LINK_LIBRARIES <lib1> [<lib2> ...]
    [INCLUDE_DIRECTORIES <dir1> [<dir2> ...]]
)
```

### Parameters

- **TARGET** (required): Name of the plugin target to create
- **SOURCES** (required): List of source files (.cc) for the plugin
- **LINK_LIBRARIES** (optional): List of libraries to link against
- **INCLUDE_DIRECTORIES** (optional): Additional include directories

## Usage within CMSSW

### Basic Example

Here's how to convert the FWCore/Modules plugin to use this function:

**Original FWCore/Modules/CMakeLists.txt:**
```cmake
file(GLOB SOURCES src/*.cc)

add_library(FWCoreModulesPlugins SHARED ${SOURCES})

target_include_directories(FWCoreModulesPlugins
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/interface>
        $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}>
        $<INSTALL_INTERFACE:include>
)

target_link_libraries(FWCoreModulesPlugins
    PUBLIC
        FWCoreSources
        FWCoreFramework
        FWCoreParameterSet
)

set_target_properties(FWCoreModulesPlugins PROPERTIES PREFIX "edmplugin")
# ... plus custom commands for Python generation ...
```

**Simplified with cmssw_generate_plugin:**
```cmake
file(GLOB SOURCES src/*.cc)

cmssw_generate_plugin(
    TARGET FWCoreModulesPlugins
    SOURCES ${SOURCES}
    LINK_LIBRARIES
        FWCoreSources
        FWCoreFramework
        FWCoreParameterSet
)
```

### Another Example

Creating a custom plugin in a different package:

```cmake
# MyPackage/MyPlugins/CMakeLists.txt
file(GLOB PLUGIN_SOURCES src/*.cc)

cmssw_generate_plugin(
    TARGET MyPackagePlugins
    SOURCES ${PLUGIN_SOURCES}
    LINK_LIBRARIES
        FWCoreFramework
        FWCoreParameterSet
        DataFormatsCommon
        MyPackageUtilities
)
```

## Usage in External Projects (via find_package)

Once CMSSW is installed, external projects can use `find_package(CMSSW)` to access the `cmssw_generate_plugin()` function.

### External Project Example

```cmake
cmake_minimum_required(VERSION 3.16)
project(MyExternalProject)

# Find CMSSW package
find_package(CMSSW REQUIRED)

# The cmssw_generate_plugin function is now available

file(GLOB MY_PLUGIN_SOURCES src/*.cc)

cmssw_generate_plugin(
    TARGET MyExternalPlugins
    SOURCES ${MY_PLUGIN_SOURCES}
    LINK_LIBRARIES
        CMSSW::FWCoreFramework
        CMSSW::FWCoreParameterSet
        # Note: Use CMSSW:: prefix for installed targets
)

# Install the plugin
install(TARGETS MyExternalPlugins
    LIBRARY DESTINATION lib
)
```

## What the Function Does Automatically

1. **Creates plugin library**: Adds a shared library with your sources
2. **Sets plugin prefix**: Sets library prefix to "edmplugin" (creates `libedmpluginMyPlugin.so`)
3. **Configures include paths**: Sets up build and install interface include directories
4. **Links libraries**: Links against specified libraries
5. **Generates Python configs**: Runs `edmWriteConfigs` to create Python configuration files
6. **Handles Python files**: Copies and installs Python files from `python/` subdirectory
7. **Installs modules.py**: Copies the `modules.py` template if available

## Directory Structure Requirements

For the function to work properly, your package should follow this structure:

```
MyPackage/MyPlugins/
├── CMakeLists.txt
├── interface/          # Header files (optional)
│   └── MyClass.h
├── src/                # Source files (required)
│   ├── Module1.cc
│   └── Module2.cc
└── python/             # Python configs (optional)
    └── __init__.py
```

## Notes

- The function expects `edmWriteConfigs` to be available in the build tree
- Python file handling only occurs if a `python/` subdirectory exists
- The `modules.py` template is copied from `FWCore/ParameterSet/templates/` if available
- Generated Python configs are placed in `${CMAKE_BINARY_DIR}/python/<PackagePath>/`
