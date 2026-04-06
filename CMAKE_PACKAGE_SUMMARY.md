# Summary of CMake find_package() Infrastructure

This document summarizes the changes made to enable CMSSW to be used with CMake's `find_package()` mechanism.

## Files Modified

### 1. CMakeLists.txt (Root)

**Location:** `/uscms_data/d2/cdj/build/temp/muonCollider/justFramework/try3/cmssw/CMakeLists.txt`

**Changes:**
- Added version to project declaration: `project(CMSSW VERSION 1.0.0 LANGUAGES CXX)`
- Included CMake package helper modules:
  - `GNUInstallDirs` - Standard installation directories
  - `CMakePackageConfigHelpers` - Tools for creating package config files
- Added installation rules for all libraries with EXPORT directive
- Added installation rules for executables
- Added installation rules for header files maintaining package structure
- Generated and installed package configuration files:
  - `CMSSSWTargets.cmake` - Exported target definitions
  - `CMSSSWConfig.cmake` - Main package configuration
  - `CMSSSWConfigVersion.cmake` - Version compatibility checking

## Files Created

### 1. CMSSSWConfig.cmake.in

**Location:** `/uscms_data/d2/cdj/build/temp/muonCollider/justFramework/try3/cmssw/CMSSSWConfig.cmake.in`

**Purpose:** Template file that gets processed by CMake to create the package configuration file

**Contents:**
- Locates and includes the exported targets file
- Defines `CMSSW_INCLUDE_DIRS` and `CMSSW_LIBRARY_DIR` variables
- Lists all available CMSSW components/libraries
- Validates requested components when `find_package()` is called
- Uses standard CMake package configuration patterns

### 2. Documentation Files

#### CMAKE_PACKAGE_CONFIG.md
**Location:** `/uscms_data/d2/cdj/build/temp/muonCollider/justFramework/try3/cmssw/CMAKE_PACKAGE_CONFIG.md`

Comprehensive guide covering:
- Overview of the package configuration system
- Installation instructions
- Usage examples
- Available components list
- Troubleshooting guide
- Implementation details

#### FIND_PACKAGE_USAGE.md
**Location:** `/uscms_data/d2/cdj/build/temp/muonCollider/justFramework/try3/cmssw/FIND_PACKAGE_USAGE.md`

Quick reference guide for:
- Basic usage examples
- Component specification
- Available components
- CMAKE_PREFIX_PATH configuration
- Example full project

### 3. Example Project

**Location:** `/uscms_data/d2/cdj/build/temp/muonCollider/justFramework/try3/cmssw/example_project/`

A complete working example demonstrating how to use CMSSW in an external project:

```
example_project/
├── CMakeLists.txt          # Shows find_package(CMSSW) usage
├── README.md               # Build and usage instructions
└── src/
    └── example_analyzer.cpp # Simple program using CMSSW headers
```

## How It Works

### Installation Phase

1. During `cmake --install`, CMake:
   - Copies all shared libraries to `${CMAKE_INSTALL_PREFIX}/lib64/`
   - Copies all executables to `${CMAKE_INSTALL_PREFIX}/bin/`
   - Copies all header files to `${CMAKE_INSTALL_PREFIX}/include/`
   - Generates `CMSSSWTargets.cmake` with imported target definitions
   - Processes `CMSSSWConfig.cmake.in` to create `CMSSSWConfig.cmake`
   - Generates `CMSSSWConfigVersion.cmake` for version checking
   - Installs all config files to `${CMAKE_INSTALL_PREFIX}/lib64/cmake/CMSSW/`

### Usage Phase

1. When a downstream project calls `find_package(CMSSW)`:
   - CMake searches for `CMSSSWConfig.cmake` in standard locations
   - The config file loads `CMSSSWTargets.cmake`
   - Imported targets like `CMSSW::FWCoreFramework` become available
   - Variables like `CMSSW_INCLUDE_DIRS` are set
   - Component validation occurs if specific components were requested

2. When linking against a CMSSW target:
   - Include directories are automatically propagated
   - Library dependencies are automatically handled
   - The target's public interface is properly configured

## Exported Targets

All libraries are exported with the `CMSSW::` namespace prefix:

### FWCore
- CMSSW::FWCoreUtilities
- CMSSW::FWCorePluginManager
- CMSSW::FWCoreReflection
- CMSSW::FWCoreVersion
- CMSSW::FWCoreParameterSet
- CMSSW::FWCoreParameterSetReader
- CMSSW::FWCorePythonParameterSet
- CMSSW::FWCoreServiceRegistry
- CMSSW::FWCoreMessageLogger
- CMSSW::FWCoreMessageService
- CMSSW::FWCoreAbstractServices
- CMSSW::FWCoreConcurrency
- CMSSW::FWCoreSharedMemory
- CMSSW::FWCoreCommon
- CMSSW::FWCoreFramework
- CMSSW::FWCoreSources
- CMSSW::FWCorePythonFramework
- CMSSW::FWCoreTestProcessor
- CMSSW::FWCoreServices
- CMSSW::FWCoreIntegration

### DataFormats
- CMSSW::DataFormatsCommon
- CMSSW::DataFormatsProvenance
- CMSSW::DataFormatsTestObjects
- CMSSW::DataFormatsStdDictionaries_map
- CMSSW::DataFormatsStdDictionaries_others
- CMSSW::DataFormatsStdDictionaries_pair
- CMSSW::DataFormatsStdDictionaries_vector
- CMSSW::DataFormatsWrappedStdDictionaries

### SimDataFormats
- CMSSW::SimDataFormatsRandomEngine

## Installation Directory Structure

After installation:

```
${CMAKE_INSTALL_PREFIX}/
├── include/
│   ├── DataFormats/
│   │   ├── Common/interface/*.h
│   │   ├── Provenance/interface/*.h
│   │   └── ...
│   ├── FWCore/
│   │   ├── Framework/interface/*.h
│   │   ├── Services/interface/*.h
│   │   └── ...
│   └── SimDataFormats/
│       └── RandomEngine/interface/*.h
├── lib64/
│   ├── libFWCoreFramework.so.1
│   ├── libFWCoreServices.so.1
│   ├── ...
│   └── cmake/
│       └── CMSSW/
│           ├── CMSSSWConfig.cmake
│           ├── CMSSSWConfigVersion.cmake
│           └── CMSSSWTargets.cmake
└── bin/
    ├── cmsRun
    ├── edmPluginDump
    ├── edmPluginHelp
    ├── edmPluginRefresh
    └── edmWriteConfigs
```

## Usage Example

Minimal CMakeLists.txt for a project using CMSSW:

```cmake
cmake_minimum_required(VERSION 3.16)
project(MyProject)

# Find CMSSW - will search in CMAKE_PREFIX_PATH
find_package(CMSSW 1.0 REQUIRED COMPONENTS FWCoreFramework)

# Create executable
add_executable(myapp main.cpp)

# Link with CMSSW - includes are automatically added
target_link_libraries(myapp PRIVATE CMSSW::FWCoreFramework)
```

Build command:
```bash
cmake -DCMAKE_PREFIX_PATH=/path/to/cmssw/install ..
cmake --build .
```

## Benefits

1. **Standard CMake Interface**: Uses the standard `find_package()` mechanism familiar to CMake users
2. **Automatic Dependency Management**: Transitive dependencies are handled automatically
3. **Version Checking**: Built-in version compatibility checking
4. **Component Selection**: Can request specific CMSSW components
5. **Imported Targets**: Modern CMake imported targets with proper interface properties
6. **Namespace Safety**: `CMSSW::` namespace prevents naming conflicts

## Compatibility

- Minimum CMake version: 3.16
- Package version compatibility: SameMajorVersion (1.x compatible with 1.y)
- Works with both in-source and out-of-source builds of downstream projects
