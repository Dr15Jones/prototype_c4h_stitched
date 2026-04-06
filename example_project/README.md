# Example Project Using CMSSW

This is a simple example demonstrating how to use CMSSW in your own CMake project via `find_package()`.

## Directory Structure

```
example_project/
├── CMakeLists.txt          # CMake configuration
├── src/
│   └── example_analyzer.cpp  # Example source code
└── README.md               # This file
```

## Prerequisites

1. CMSSW must be built and installed first
2. CMake 3.16 or higher

## Building

### If CMSSW is installed to a standard location (e.g., /usr/local):

```bash
mkdir build
cd build
cmake ..
cmake --build .
```

### If CMSSW is installed to a custom location:

```bash
mkdir build
cd build
cmake -DCMAKE_PREFIX_PATH=/path/to/cmssw/install ..
cmake --build .
```

## Running

After a successful build:

```bash
./example_analyzer
```

## What This Example Demonstrates

1. Using `find_package(CMSSW)` to locate the installed CMSSW package
2. Specifying required CMSSW components
3. Linking against CMSSW libraries using the `CMSSW::` namespace
4. Automatic include directory propagation from CMSSW targets

## Customization

To use different CMSSW components, modify the `find_package()` call in CMakeLists.txt:

```cmake
find_package(CMSSW 1.0 REQUIRED COMPONENTS
    FWCoreFramework
    FWCoreServices
    DataFormatsCommon
    # Add more components as needed
)
```

And add them to `target_link_libraries()`:

```cmake
target_link_libraries(example_analyzer PRIVATE
    CMSSW::FWCoreFramework
    CMSSW::FWCoreServices
    CMSSW::DataFormatsCommon
    # Add corresponding targets here
)
```
