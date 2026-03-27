# CMake Build System for CMSSW Framework

This directory contains CMake build configurations for the CMSSW framework components.

## Prerequisites

The following dependencies are required:
- CMake 3.16 or later
- C++20 compatible compiler (GCC 13+)
- Boost libraries (including program_options, filesystem, serialization)
- Intel TBB (Threading Building Blocks)
- ROOT (for full functionality)
- TinyXML2 (XML parsing library)
- MD5 library
- CLHEP (physics library for random number generation)
- Python3 3.9+ (interpreter and development libraries)
- pybind11 (Python/C++ interoperability)
- cpu_features (CPU feature detection library)
- UUID library

### CVMFS Externals (Pre-configured)

This build system is pre-configured to use externals from CVMFS at:
- **GCC**: `/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/gcc/13.4.0-6908cfdf803923e783448096ca4f0923`
- **TBB**: `/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/tbb/v2022.3.0-88eb7be4ee320d604a798a914aea6359`
- **ROOT**: `/cvmfs/cms.cern.ch/el8_amd64_gcc13/lcg/root/6.36.09-550a5cc65f2c3764971305621e222830`
- **Boost**: `/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/boost/1.80.0-4e041c5f850405476cd4bc42f965d947`
- **MD5**: `/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/md5/1.0.0-26057075013e190e56dad37d35219376`
- **TinyXML2**: `/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/tinyxml2/6.2.0-67924ead96ecb4e69aad321b767979a5`
- **CLHEP**: `/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/clhep/2.4.7.2-9d5b7c3a55c3af00652fa823dcdd8319`
- **Python3**: `/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/python3/3.9.14-e16d2924e9eb9db8fddd14e187cf7209`
- **pybind11**: `/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/py3-pybind11/3.0.1-225a0aebad9d3cd25d37aabcec07d773`
- **cpu_features**: `/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/cpu_features/0.9.0-9345f64300a0e12ee5bd1420a0e15254`

Make sure CVMFS is mounted and accessible before building.

## Building

### Environment Setup

**Important**: Before building, you must set up the environment to use the correct compiler and libraries from CVMFS:

For **tcsh/csh** (default on lxplus):
```tcsh
source setup_env.csh
```

For **bash**:
```bash
source setup_env.sh
```

This sets up:
- GCC 13.4.0 compiler
- TBB, Boost, and ROOT from CVMFS
- Required library paths (LD_LIBRARY_PATH)

### Quick Start

**After sourcing the environment setup:**

```bash
# Create a build directory
mkdir build
cd build

# Configure with CMake (environment already set)
cmake ..

# Build all libraries
cmake --build . -j$(nproc)

# Install (optional)
cmake --install . --prefix /path/to/install
```

Or use the provided build script:
```bash
# After sourcing setup_env.csh or setup_env.sh
./build.sh
```

### Advanced Configuration

To use different versions of the externals, edit the paths in CMakeLists.txt:

```cmake
set(TBB_ROOT "/path/to/tbb")
set(ROOT_DIR "/path/to/root")
set(BOOST_ROOT "/path/to/boost")
```

Or override them on the command line:

```bash
cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DBOOST_ROOT=/custom/path/to/boost \
  -DTBB_ROOT=/custom/path/to/tbb \
  -DROOT_DIR=/custom/path/to/root
```

### Build Options

- `CMAKE_BUILD_TYPE`: Build type (Debug, Release, RelWithDebInfo, MinSizeRel)
- `CMAKE_INSTALL_PREFIX`: Installation directory
- `CMAKE_CXX_COMPILER`: C++ compiler to use

## Library Naming Convention

Libraries are named based on their directory path:
- `FWCore/Framework/src` → `libFWCoreFramework.so`
- `DataFormats/Common/src` → `libDataFormatsCommon.so`
- `SimDataFormats/RandomEngine/src` → `libSimDataFormatsRandomEngine.so`

## Output Structure

After building, libraries and binaries will be in:
- Libraries: `build/lib/`
- Plugin modules: `build/lib/plugins/`
- Executables: `build/bin/`

## Individual Package Building

To build only specific packages:

```bash
# Build only FWCore/Framework and its dependencies
cmake --build . --target FWCoreFramework

# Build only DataFormats/Common
cmake --build . --target DataFormatsCommon
```

## Troubleshooting

### Missing Dependencies

If CMake cannot find a dependency, you can help it by:

1. Setting environment variables:
   ```bash
   export ROOT_DIR=/path/to/root
   export BOOST_ROOT=/path/to/boost
   ```

2. Providing hints to CMake:
   ```bash
   cmake .. -DROOT_DIR=/path/to/root
   ```

### Build Errors

If you encounter build errors:
1. Check that all dependencies are installed
2. Ensure your compiler supports C++17
3. Try a clean build: `rm -rf build && mkdir build && cd build && cmake ..`

## Package Dependencies

The build system handles dependencies automatically. Major dependency chains:

- `FWCoreUtilities` - Base utility library (depends on Boost, TBB)
- `DataFormatsProvenance` - Depends on FWCoreUtilities
- `DataFormatsCommon` - Depends on DataFormatsProvenance
- `FWCoreFramework` - Main framework (depends on most other FWCore and DataFormats packages)

## Note

This CMake build system was generated to replicate the functionality of the CMSSW BuildFile.xml system. Some external dependencies may need to be adjusted based on your specific environment.
