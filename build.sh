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
BUILD_DIR="${SCRIPT_DIR}/build"

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
cmake .. -DCMAKE_BUILD_TYPE=${BUILD_TYPE}

# Build
echo -e "${YELLOW}Building with ${JOBS} parallel jobs...${NC}"
cmake --build . -j${JOBS}

echo -e "${GREEN}Build completed successfully!${NC}"
echo ""
echo "Libraries are in: ${BUILD_DIR}/lib/"
echo "Executables are in: ${BUILD_DIR}/bin/"
