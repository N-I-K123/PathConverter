
#ifndef Engine_h
#define Engine_h

#include <stdio.h>
#include <string>

#endif /* Engine_hpp */

#ifdef __cplusplus
extern "C++" {
#endif

    void engine(std::string path);
    std::string macToWin(std::string path);
    std::string remote(std::string path);
    std::string winToMac(std::string path);
    std::string getConvertedPath();
    void prefixMainMac();
    void setPrefix(std::string prefix);
    void setPrefixStatus(bool status);
    int findSystem(std::string path);
    void setConversionDestination(bool dst);

    std::string prefixFinal;
    bool prefixStatus;
    std::string convertedPath;
    bool conversionDestination;
    std::string pf;
    

#ifdef __cplusplus
} // extern "C"
#endif
