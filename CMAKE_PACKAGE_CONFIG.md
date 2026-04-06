# CMake Package Configuration for CMSSW

This document describes the CMake package infrastructure that enables CMSSW to be used with CMake's `find_package()` mechanism.

## Overview

The CMSSW build system now includes full support for CMake package configuration, allowing external projects to easily discover and link against CMSSW libraries using the standard `find_package()` command.

## What Was Added

### 1. Project Version

The root `CMakeLists.txt` now declares a project version:

```cmake
project(CMSSW VERSION 1.0.0 LANGUAGES CXX)
```

### 2. Installation Rules

All libraries, executables, and headers are now configured for installation with appropriate EXPORT declarations.

### 3. Package Configuration Files

Two key configuration files enable the `find_package()` mechanism:

- **CMSSSWConfig.cmake.in**: Template for the main configuration file that downstream projects will use
- **CMSSSWConfigVersion.cmake**: Automatically generated version file for compatibility checking

### 4. Exported Targets

All CMSSW libraries are exported with the `CMSSW::` namespace, making them available as imported targets in downstream projects.

## Installation

To install CMSSW with package configuration support:

```bash
# Configure with desired install prefix
cmake -DCMAKE_INSTALL_PREFIX=/opt/cmssw -S /path/to/source -B /path/to/build

# Build
cmake --build /path/to/build

# Install
cmake --install /path/to/build
```

The installation will create the following structure:

```
${CMAKE_INSTALL_PREFIX}/
├── include/              # Header files
│   ├── DataFormats/
│   ├── FWCore/
│   ├── SimDataFormats/
│   └── Utilities/
├── lib64/                # Library files
│   ├── libFWCore*.so
│   ├── libDataFormats*.so
│   ├── libSimDataFormats*.so
│   └── cmake/
│       └── CMSSW/        # CMake package files
│           ├── CMSSSWConfig.cmake
│           ├── CMSSSWConfigVersion.cmake
│           └── CMSSSWTargets.cmake
└── bin/                  # Executable files
    ├── cmsRun
    ├── edmPluginDump
    ├── edmPluginHelp
    ├── edmPluginRefresh
    └── edmWriteConfigs
```

## Using CMSSW in Your Project

### Basic Example

Create a `CMakeLists.txt`:

```cmake
cmake_minimum_required(VERSION 3.16)
project(MyProject)

# Find CMSSW
find_package(CMSSW 1.0 REQUIRED)

# Create your executable
add_executable(myapp main.cpp)

# Link against CMSSW libraries
target_link_libraries(myapp PRIVATE CMSSW::FWCoreFramework)
```

### Specifying Components

You can request specific CMSSW components:

```cmake
find_package(CMSSW 1.0 REQUIRED COMPONENTS
    FWCoreFramework
    FWCoreServices
    DataFormatsCommon
)

target_link_libraries(myapp PRIVATE
    CMSSW::FWCoreFramework
    CMSSW::FWCoreServices
    CMSSW::DataFormatsCommon
)
```

### Available Components

#### FWCore Libraries
- FWCoreUtilities
- FWCorePluginManager
- FWCoreReflection
- FWCoreVersion
- FWCoreParameterSet
- FWCoreParameterSetReader
- FWCorePythonParameterSet
- FWCoreServiceRegistry
- FWCoreMessageLogger
- FWCoreMessageService
- FWCoreAbstractServices
- FWCoreConcurrency
- FWCoreSharedMemory
- FWCoreCommon
- FWCoreFramework
- FWCoreSources
- FWCorePythonFramework
- FWCoreTestProcessor
- FWCoreServices
- FWCoreIntegration

#### DataFormats Libraries
- DataFormatsCommon
- DataFormatsProvenance
- DataFormatsTestObjects
- DataFormatsStdDictionaries_map
- DataFormatsStdDictionaries_others
- DataFormatsStdDictionaries_pair
- DataFormatsStdDictionaries_vector
- DataFormatsWrappedStdDictionaries

#### SimDataFormats Libraries
- SimDataFormatsRandomEngine

## Package Variables

After calling `find_package(CMSSW)`, the following variables are available:

- `CMSSW_FOUND`: TRUE if CMSSW was found
- `CMSSW_VERSION`: Version of CMSSW (e.g., "1.0.0")
- `CMSSW_INCLUDE_DIRS`: Include directories
- `CMSSW_LIBRARY_DIR`: Directory containing CMSSW libraries
- `CMSSW_LIBRARIES`: List of all available CMSSW library names

## Specifying CMSSW Location

If CMSSW is installed to a non-standard location, you can specify it in several ways:

### Method 1: CMAKE_PREFIX_PATH (Recommended)

```bash
cmake -DCMAKE_PREFIX_PATH=/opt/cmssw /path/to/your/project
```

### Method 2: CMSSW_DIR

```bash
cmake -DCMSSW_DIR=/opt/cmssw/lib64/cmake/CMSSW /path/to/your/project
```

### Method 3: In CMakeLists.txt

```cmake
list(APPEND CMAKE_PREFIX_PATH "/opt/cmssw")
find_package(CMSSW REQUIRED)
```

## Version Compatibility

The package configuration uses `SameMajorVersion` compatibility mode. This means:

- CMSSW 1.0.0 is compatible with requests for CMSSW 1.x
- CMSSW 1.x is NOT compatible with requests for CMSSW 2.x

To request a specific version:

```cmake
find_package(CMSSW 1.0 EXACT REQUIRED)  # Exact version
find_package(CMSSW 1.0 REQUIRED)        # 1.0 or higher (same major)
```

## Example Project

A complete example project is provided in the `example_project/` directory. See `example_project/README.md` for details on building and running it.

## Implementation Details

### Modified Files

1. **CMakeLists.txt** (root)
   - Added `VERSION` to `project()` declaration
   - Added installation rules for all targets
   - Added header file installation
   - Added package configuration generation
   - Added CMake helpers include

2. **CMSSSWConfig.cmake.in** (new)
   - Package configuration template
   - Defines available components
   - Sets up imported targets
   - Validates requested components

### CMake Modules Used

- `GNUInstallDirs`: Standard installation directory variables
- `CMakePackageConfigHelpers`: Utilities for creating package config files
  - `configure_package_config_file()`: Processes the .cmake.in template
  - `write_basic_package_version_file()`: Creates version compatibility file

## Troubleshooting

### Package Not Found

If CMake cannot find CMSSW:

1. Verify CMSSW was installed: Check for `${INSTALL_PREFIX}/lib64/cmake/CMSSW/CMSSSWConfig.cmake`
2. Check CMAKE_PREFIX_PATH includes the installation prefix
3. Try setting CMSSW_DIR explicitly to the cmake directory

### Missing Components

If find_package succeeds but components are missing:

1. Verify the component name matches exactly (case-sensitive)
2. Check that the library was built and installed
3. Look at the `CMSSW_LIBRARIES` variable to see available components

### Include Files Not Found

If compilation fails with missing headers:

1. Verify headers were installed to `${INSTALL_PREFIX}/include/`
2. Check that you're linking against the imported target (e.g., `CMSSW::FWCoreFramework`)
3. The include directories should be automatically added via the imported target

### Link Errors

If linking fails:

1. Verify the shared libraries exist in `${INSTALL_PREFIX}/lib64/`
2. Check that `LD_LIBRARY_PATH` includes the library directory (at runtime)
3. Consider using RPATH: `set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)`

## Testing the Installation

To verify the package configuration works:

```bash
# Build and install CMSSW
cd cmssw_build
cmake --install .

# Try the example project
cd ../example_project
mkdir build && cd build
cmake -DCMAKE_PREFIX_PATH=/path/to/cmssw/install ..
cmake --build .
./example_analyzer
```

## Additional Resources

- See `FIND_PACKAGE_USAGE.md` for quick reference on using the package
- See `example_project/README.md` for a working example
- CMake documentation: https://cmake.org/cmake/help/latest/command/find_package.html
