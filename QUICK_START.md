# Quick Start: Using CMSSW with find_package()

## For CMSSW Developers (Installing)

Build and install CMSSW with CMake package support:

```bash
# Configure
cmake -DCMAKE_INSTALL_PREFIX=/opt/cmssw -S . -B build

# Build
cmake --build build

# Install (creates the find_package infrastructure)
cmake --install build
```

After installation, the following files will be created:
- `/opt/cmssw/lib64/cmake/CMSSW/CMSSSWConfig.cmake`
- `/opt/cmssw/lib64/cmake/CMSSW/CMSSSWConfigVersion.cmake`
- `/opt/cmssw/lib64/cmake/CMSSW/CMSSSWTargets.cmake`

## For Users (Using CMSSW)

### Step 1: Create Your CMakeLists.txt

```cmake
cmake_minimum_required(VERSION 3.16)
project(MyAnalysis)

# Find CMSSW
find_package(CMSSW 1.0 REQUIRED COMPONENTS
    FWCoreFramework
    FWCoreServices
)

# Create your executable
add_executable(myanalyzer src/myanalyzer.cpp)

# Link with CMSSW
target_link_libraries(myanalyzer PRIVATE
    CMSSW::FWCoreFramework
    CMSSW::FWCoreServices
)
```

### Step 2: Create Your Source File

```cpp
// src/myanalyzer.cpp
#include "FWCore/Framework/interface/Event.h"
#include <iostream>

int main() {
    std::cout << "Using CMSSW libraries!" << std::endl;
    return 0;
}
```

### Step 3: Build Your Project

```bash
# Configure (tell CMake where CMSSW is installed)
cmake -DCMAKE_PREFIX_PATH=/opt/cmssw -B build

# Build
cmake --build build

# Run
./build/myanalyzer
```

## Available CMSSW Components

You can request any of these in `find_package()`:

**Most Common:**
- `FWCoreFramework` - Core framework functionality
- `FWCoreServices` - Framework services
- `DataFormatsCommon` - Common data formats
- `FWCoreParameterSet` - Configuration handling

**Full List:** See [FIND_PACKAGE_USAGE.md](FIND_PACKAGE_USAGE.md) for the complete list.

## Finding CMSSW

CMake searches for CMSSW in these locations (in order):

1. `CMAKE_PREFIX_PATH` (recommended):
   ```bash
   cmake -DCMAKE_PREFIX_PATH=/opt/cmssw ..
   ```

2. `CMSSW_DIR`:
   ```bash
   cmake -DCMSSW_DIR=/opt/cmssw/lib64/cmake/CMSSW ..
   ```

3. Standard system paths (`/usr/local`, `/usr`, etc.)

## Troubleshooting

**Problem:** `find_package(CMSSW)` fails with "Could not find CMSSW"

**Solution:** Make sure CMAKE_PREFIX_PATH points to the CMSSW installation directory

**Problem:** Headers not found during compilation

**Solution:** Use the imported target syntax `CMSSW::ComponentName` instead of manually specifying libraries

**Problem:** Runtime library errors

**Solution:** Add the CMSSW library directory to LD_LIBRARY_PATH:
```bash
export LD_LIBRARY_PATH=/opt/cmssw/lib64:$LD_LIBRARY_PATH
```

## Example Project

A complete working example is provided in `example_project/`:

```bash
cd example_project
mkdir build && cd build
cmake -DCMAKE_PREFIX_PATH=/opt/cmssw ..
cmake --build .
./example_analyzer
```

## More Information

- **Quick Reference:** [FIND_PACKAGE_USAGE.md](FIND_PACKAGE_USAGE.md)
- **Complete Guide:** [CMAKE_PACKAGE_CONFIG.md](CMAKE_PACKAGE_CONFIG.md)
- **What Changed:** [CMAKE_PACKAGE_SUMMARY.md](CMAKE_PACKAGE_SUMMARY.md)
