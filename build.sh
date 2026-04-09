#!/bin/bash

# Simple build script for CMSSW CMake build system

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}CMSSW CMake Build Script${NC}"
echo "================================"

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_DIR="${SCRIPT_DIR}/../build"
INSTALL_DIR="${SCRIPT_DIR}/../install"

# Source environment setup
echo -e "${YELLOW}Setting up environment...${NC}"
source "${SCRIPT_DIR}/setup_env.sh"

# Parse command line arguments
BUILD_TYPE="Release"
CLEAN=0
JOBS=$(nproc)

while [[ $# -gt 0 ]]; do
    case $1 in
        -c|--clean)
            CLEAN=1
            shift
            ;;
        -d|--debug)
            BUILD_TYPE="Debug"
            shift
            ;;
        -j|--jobs)
            JOBS="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -c, --clean       Clean build directory before building"
            echo "  -d, --debug       Build in Debug mode (default: Release)"
            echo "  -j, --jobs N      Number of parallel jobs (default: $(nproc))"
            echo "  -h, --help        Show this help message"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Clean if requested
if [ $CLEAN -eq 1 ]; then
    echo -e "${YELLOW}Cleaning build directory...${NC}"
    rm -rf "${BUILD_DIR}"
fi

# Create build directory
if [ ! -d "${BUILD_DIR}" ]; then
    echo -e "${YELLOW}Creating build directory...${NC}"
    mkdir -p "${BUILD_DIR}"
fi

# Configure
cd "${BUILD_DIR}"
echo -e "${YELLOW}Configuring CMake (Build Type: ${BUILD_TYPE})...${NC}"
cmake .. -DCMAKE_CXX_COMPILER=/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/gcc/13.4.0-6908cfdf803923e783448096ca4f0923/bin/g++ -DCMAKE_PREFIX_PATH=/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/tbb/v2022.3.0-88eb7be4ee320d604a798a914aea6359:/cvmfs/cms.cern.ch/el8_amd64_gcc13/lcg/root/6.36.09-550a5cc65f2c3764971305621e222830:/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/boost/1.80.0-4e041c5f850405476cd4bc42f965d947:/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/clhep/2.4.7.2-9d5b7c3a55c3af00652fa823dcdd8319:/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/python3/3.9.14-e16d2924e9eb9db8fddd14e187cf7209:/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/cpu_features/0.9.0-9345f64300a0e12ee5bd1420a0e15254 -DMD5_ROOT=/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/md5/1.0.0-26057075013e190e56dad37d35219376 -Dtinyxml2_DIR=/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/tinyxml2/6.2.0-67924ead96ecb4e69aad321b767979a5/lib64/cmake/tinyxml2 -Dpybind11_DIR=/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/py3-pybind11/3.0.1-225a0aebad9d3cd25d37aabcec07d773/share/cmake/pybind11 -DCpuFeatures_DIR=/cvmfs/cms.cern.ch/el8_amd64_gcc13/external/cpu_features/0.9.0-9345f64300a0e12ee5bd1420a0e15254/lib64/cmake/CpuFeatures -DCMAKE_BUILD_TYPE=${BUILD_TYPE}  -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}

# Build
echo -e "${YELLOW}Building with ${JOBS} parallel jobs...${NC}"
cmake --build . -j${JOBS}
cmake --install .
echo -e "${GREEN}Build completed successfully!${NC}"
echo ""
echo "Libraries are in: ${BUILD_DIR}/lib/"
echo "Executables are in: ${BUILD_DIR}/bin/"
echo "Installed files are in: ${INSTALL_DIR}/"
