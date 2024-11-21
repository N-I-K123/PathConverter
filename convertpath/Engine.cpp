//
//  Engine.cpp
//  convertpath
//
//  Created by Krzysztof Żelazek on 17/04/2024.
//

#include "Engine.h"
#include <string>

void engine(std::string path) {
    
    int system = findSystem(path);
    if (system == 0){
        convertedPath = macToWin(path);
    } else if (system == 1) {
        convertedPath = remote(path);
    } else if (system==2){
       convertedPath = winToMac(path);
    }
}

std::string macToWin(std::string path){
    auto slashCount = 0;
        auto secondSlashPos = std::string::npos;
        for (auto i = 0; i <path.length(); ++i) {
            char c = path[i];
            if (c=='/'){
                path[i] = '\\';
                slashCount++;
            }
            if (prefixStatus) {
                if (slashCount<2){
                    secondSlashPos = i+1;
                }
            }
            
        }
        if (secondSlashPos != std::string::npos) {
            path.erase(0, secondSlashPos);
    }
    if (prefixStatus) {
        path.insert(0, prefixFinal);
    }else {
        path.insert(0, "C:");
    }
    
    
    return path;
}
std::string remote(std::string path){
    auto slashCount = 0;
    auto slashPos = std::string::npos;
    auto maxSlash = 0;
    for (auto i = 0; i <path.length(); ++i) {
            char c = path[i];
        if (!conversionDestination) {
            if (c=='/'){
                path[i] = '\\';
            }
        } else{
            maxSlash = 3;
            if (c=='\\') {
                path[i] = '/';
                slashCount++;
            }
            if (slashCount<maxSlash){
                slashPos = i+1;
            }
          
        }
            
        }
        if (slashPos != std::string::npos) {
            
        }
    if(conversionDestination){
        path.erase(0, 5);
        path.insert(0, "/Volumes");
    }else{
        path.erase(0, 5);
        if (prefixStatus) {
            pf = '\\';
            path.insert(0, pf);
        }else{
            path.insert(0, "C:");
        }
    }
    return path;
}
std::string winToMac(std::string path) {
    auto slashCount = 0;
    auto slashPos = std::string::npos;
    auto maxSlash = 0;
    if (path[0]=='\\'){maxSlash = 3;}
    else{maxSlash = 1;}

    for (auto i = 0; i <path.length(); ++i) {
        char c = path[i];
        if (c=='\\'){
            path[i] = '/';
            slashCount++;
        }
        if (slashCount<maxSlash){
            slashPos = i+1;
        }
    }
    if (slashPos != std::string::npos) {
        path.erase(0, slashPos);
    }
    if (prefixStatus) {
        path.insert(0, prefixFinal);
    }else {
        path.insert(0, "/Volumes");
    }
    return path;
}


int findSystem(std::string path) {
    if (path[0] == '/'){return 0;}
    else if (path.substr(0, 3) == "smb" || path.substr(0, 3) == "Smb"){return 1;}
    else return 2;
}


void setPrefix(std::string prefix){
    prefixFinal = prefix;
}

void setPrefixStatus(bool status){
    prefixStatus = status;
}

std::string getConvertedPath(){
    return convertedPath;
}
void setConversionDestination(bool dst){
    conversionDestination = dst;
}

