cmake_minimum_required(VERSION 3.16)
project(CMSSSWExample VERSION 1.0.0 LANGUAGES CXX)

# Set C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find the CMSSW package
# If CMSSW is installed in a non-standard location, set:
# cmake -DCMAKE_PREFIX_PATH=/path/to/cmssw/install ..
find_package(CMSSW 1.0 REQUIRED COMPONENTS
    FWCoreFramework
    FWCoreServices
    DataFormatsCommon
)

# Print what was found
message(STATUS "CMSSW include directories: ${CMSSW_INCLUDE_DIRS}")
message(STATUS "CMSSW library directory: ${CMSSW_LIBRARY_DIR}")

# Create an example executable
add_executable(example_analyzer
    src/example_analyzer.cpp
)

# Link with CMSSW components
# Note: CMSSW:: namespace is used for imported targets
target_link_libraries(example_analyzer PRIVATE
    CMSSW::FWCoreFramework
    CMSSW::FWCoreServices
    CMSSW::DataFormatsCommon
)

# The include directories are automatically added through the imported targets
message(STATUS "Example analyzer will be built with CMSSW support")
