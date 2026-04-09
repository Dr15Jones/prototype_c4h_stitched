# CMSSW CMake Functions Usage Guide

This document describes how to use the CMSSW CMake utility functions for creating and managing EDM plugin libraries.

## Available Functions

1. **`cmssw_generate_plugin()`** - Creates an EDM plugin library
2. **`cmssw_generate_plugincache()`** - Generates the .edmplugincache file for all plugins

---

## 1. cmssw_generate_plugin()

### Overview

The `cmssw_generate_plugin()` function simplifies the creation of CMSSW plugin libraries by:
- Creating a shared library with the "edmplugin" prefix
- Setting up proper build and install interface include directories
- Running `edmWriteConfigs` to generate Python configuration files
- Handling Python file installation

### Function Signature

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

---

## 2. cmssw_generate_plugincache()

### Overview

The `cmssw_generate_plugincache()` function generates the `.edmplugincache` file that indexes all EDM plugin libraries in a project. This cache file is required for CMSSW to discover and load plugins at runtime.

The function:
- Runs `edmPluginRefresh` on all specified plugin targets
- Generates the `.edmplugincache` file
- Creates a build target that is automatically built
- Installs the cache file to the library directory

### Function Signature

```cmake
cmssw_generate_plugincache(
    PLUGIN_TARGETS <target1> [<target2> ...]
    [OUTPUT_DIR <directory>]
    [CACHE_TARGET_NAME <name>]
)
```

### Parameters

- **PLUGIN_TARGETS** (required): List of plugin target names to include in the cache
- **OUTPUT_DIR** (optional): Directory for the `.edmplugincache` file (default: `${CMAKE_LIBRARY_OUTPUT_DIRECTORY}`)
- **CACHE_TARGET_NAME** (optional): Name for the custom target (default: `"RefreshPluginCache"`)

### Usage within CMSSW

#### Basic Example

```cmake
# After all plugins are defined with cmssw_generate_plugin()
cmssw_generate_plugincache(
    PLUGIN_TARGETS
        FWCoreModulesPlugins
        FWCoreIntegrationPlugins
        FWCoreServicesPlugins
        FWCoreTestModulesPlugins
        MyCustomPlugins
)
```

This is typically called once at the end of the main `CMakeLists.txt` after all subdirectories have been added.

#### Complete Example in Main CMakeLists.txt

```cmake
# Add all subdirectories containing plugins
add_subdirectory(FWCore)
add_subdirectory(MyPackage)

# Generate the plugin cache for all plugins
cmssw_generate_plugincache(
    PLUGIN_TARGETS
        FWCoreModulesPlugins
        FWCoreIntegrationPlugins
        FWCoreMessageServicePlugins
        FWCoreServicesPlugins
        MyPackagePlugins
)
```

### Usage in External Projects

External projects using `find_package(CMSSW)` can also use this function:

```cmake
cmake_minimum_required(VERSION 3.16)
project(MyExternalProject)

# Find CMSSW package (brings in the utility functions)
find_package(CMSSW REQUIRED)

# Create your plugins
file(GLOB PLUGIN1_SOURCES src/plugins1/*.cc)
cmssw_generate_plugin(
    TARGET MyPlugin1
    SOURCES ${PLUGIN1_SOURCES}
    LINK_LIBRARIES
        CMSSW::FWCoreFramework
        CMSSW::FWCoreParameterSet
)

file(GLOB PLUGIN2_SOURCES src/plugins2/*.cc)
cmssw_generate_plugin(
    TARGET MyPlugin2
    SOURCES ${PLUGIN2_SOURCES}
    LINK_LIBRARIES
        CMSSW::FWCoreFramework
)

# Generate plugin cache for all your plugins
cmssw_generate_plugincache(
    PLUGIN_TARGETS
        MyPlugin1
        MyPlugin2
)
```

### What the Function Does

1. **Creates custom command**: Generates a command that runs `edmPluginRefresh` on all plugin libraries
2. **Handles missing targets**: Uses generator expressions to gracefully handle plugins that may not exist
3. **Creates build target**: Adds a custom target (default name: `RefreshPluginCache`) that is built by default
4. **Installs cache file**: Automatically installs `.edmplugincache` to the library installation directory

### Advanced Options

You can customize the output directory and target name:

```cmake
cmssw_generate_plugincache(
    PLUGIN_TARGETS
        Plugin1
        Plugin2
        Plugin3
    OUTPUT_DIR ${CMAKE_BINARY_DIR}/custom/lib
    CACHE_TARGET_NAME MyCustomCacheTarget
)
```

### Important Notes

- This function should be called **after** all plugin targets have been defined
- The function requires `edmPluginRefresh` to be available in `${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/bin/`
- The generated cache file is named `.edmplugincache` (note the leading dot)
- The cache target is built by default (using the `ALL` keyword)
- Plugin targets that don't exist are automatically skipped (no error)
- The cache file is installed to `${CMAKE_INSTALL_LIBDIR}` by default

---

## Complete Workflow Example

Here's a complete example showing both functions working together:

### Project Structure
```
MyProject/
├── CMakeLists.txt              # Main build file
└── MyPackage/
    ├── CMakeLists.txt          # Package build file
    ├── interface/
    │   └── MyProducer.h
    ├── src/
    │   └── MyProducer.cc
    └── python/
        └── __init__.py
```

### Main CMakeLists.txt
```cmake
cmake_minimum_required(VERSION 3.16)
project(MyProject VERSION 1.0.0)

# Setup paths and dependencies
# ...

# Include CMSSW utility functions
include(CMSSSWMacros)

# Add subdirectories
add_subdirectory(MyPackage)

# Generate plugin cache for all plugins in the project
cmssw_generate_plugincache(
    PLUGIN_TARGETS
        MyPackagePlugins
)
```

### MyPackage/CMakeLists.txt
```cmake
# Collect plugin sources
file(GLOB PLUGIN_SOURCES src/*.cc)

# Generate the plugin library
cmssw_generate_plugin(
    TARGET MyPackagePlugins
    SOURCES ${PLUGIN_SOURCES}
    LINK_LIBRARIES
        FWCoreFramework
        FWCoreParameterSet
        DataFormatsCommon
)
```

This workflow:
1. Creates the plugin library with proper configuration
2. Generates Python configs automatically
3. Creates and installs the plugin cache
4. Makes everything available for installation and external use

