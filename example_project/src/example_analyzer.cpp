// Example program using CMSSW via find_package()
// This demonstrates that the CMSSW headers are available

#include "FWCore/Framework/interface/Event.h"
#include "DataFormats/Common/interface/Handle.h"
#include <iostream>

int main() {
    std::cout << "This is an example program using CMSSW libraries." << std::endl;
    std::cout << "The CMSSW package was found and linked successfully!" << std::endl;
    
    // If you were to actually use CMSSW functionality, you would
    // create analyzers, access event data, etc. here.
    
    return 0;
}
