# Using CMSSW with find_package()

This document explains how to use the CMSSW package in your CMake projects.

## Installation

First, build and install CMSSW:

```bash
cd <build_directory>
cmake -DCMAKE_INSTALL_PREFIX=/path/to/install <source_directory>
cmake --build .
cmake --install .
```

## Using CMSSW in Your Project

### Basic Usage

In your CMakeLists.txt:

```cmake
cmake_minimum_required(VERSION 3.16)
project(MyProject)

# Find the CMSSW package
find_package(CMSSW REQUIRED)

# Link against CMSSW libraries
add_executable(myapp main.cpp)
target_link_libraries(myapp PRIVATE CMSSW::FWCoreFramework)
```

### Finding Specific Components

If you only need specific CMSSW components:

```cmake
find_package(CMSSW REQUIRED COMPONENTS
    FWCoreFramework
    FWCoreServices
    DataFormatsCommon
)

add_executable(myapp main.cpp)
target_link_libraries(myapp PRIVATE 
    CMSSW::FWCoreFramework
    CMSSW::FWCoreServices
    CMSSW::DataFormatsCommon
)
```

### Available Components

The following CMSSW components are available:

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
- FWCoreAbstractServices
- FWCoreConcurrency
- FWCoreSharedMemory
- FWCoreCommon
- FWCoreFramework
- FWCoreSources
- FWCorePythonFramework
- FWCoreTestProcessor
- FWCoreServices

#### DataFormats Libraries
- DataFormatsCommon
- DataFormatsProvenance
- DataFormatsTestObjects

#### SimDataFormats Libraries
- SimDataFormatsRandomEngine

### Setting CMAKE_PREFIX_PATH

If CMSSW is installed to a non-standard location, set CMAKE_PREFIX_PATH:

```bash
cmake -DCMAKE_PREFIX_PATH=/path/to/cmssw/install <source_directory>
```

Or in your CMakeLists.txt before find_package():

```cmake
list(APPEND CMAKE_PREFIX_PATH "/path/to/cmssw/install")
find_package(CMSSW REQUIRED)
```

## Include Directories

When you link against a CMSSW library, the include directories are automatically added to your target. Headers follow the package structure:

```cpp
#include "FWCore/Framework/interface/EDAnalyzer.h"
#include "DataFormats/Common/interface/Handle.h"
```

## Executables

The following executables are also installed:
- cmsRun
- edmPluginDump
- edmPluginHelp
- edmPluginRefresh
- edmWriteConfigs

## Example Full Project

```cmake
cmake_minimum_required(VERSION 3.16)
project(CMSSSWExample VERSION 1.0.0)

# Find CMSSW
find_package(CMSSW 1.0 REQUIRED COMPONENTS
    FWCoreFramework
    FWCoreServices
    DataFormatsCommon
)

# Create executable
add_executable(example_analyzer src/ExampleAnalyzer.cpp)

# Link with CMSSW
target_link_libraries(example_analyzer PRIVATE
    CMSSW::FWCoreFramework
    CMSSW::FWCoreServices
    CMSSW::DataFormatsCommon
)

# Set C++ standard
target_compile_features(example_analyzer PRIVATE cxx_std_20)
```
