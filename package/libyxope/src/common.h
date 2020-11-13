/*
Copyright (C) 2020 Metrological
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

First attempt. Possibly wrong and / or incomplete, and may contain 'bad' code and / or coding practice.
*/

#pragma once

#ifdef NDEBUG
    #error This library requires assert to be available
#else
    #include <cassert>
#endif

#include <string>

#define COMMON_PRIVATE __attribute__ (( visibility ("hidden") ))
#define COMMON_PUBLIC __attribute__ (( visibility ("default") ))

#include <iostream>

#ifdef __cplusplus
extern "C" {
#endif

#ifdef __cplusplus
}
#endif

#if !defined(LOG_PREFIX)
    #define LOG(...) _LOG(__VA_ARGS__)
#else
    #define _UNKNOWN_ 1
    #define _RELEASE_ 2
    #define _DEBUG_ 3

    // At least define a LOG
    #define LOG(...)

    #if (LOG_PREFIX==_RELEASE_)
        #undef LOG
        #define LOG(...) _LOG(__VA_ARGS__)
    #endif

    #if (LOG_PREFIX==_DEBUG_)
        #undef LOG
        #define LOG(...) _LOG(__FILE__, __LINE__, __VA_ARGS__)
    #endif

    #undef _UNKNOWN_
    #undef _RELEASE_
    #undef _DEBUG_
#endif

// Force internal linkage
namespace {

// Termination condition
void _LOG () {
    // Avoid the static initialization order fiasco by ensuring the (default) standard stream objects are constructed before their first use
    static std::ios_base::Init _base;

    // Unbuffered!
    std::cout << std::endl;
}

template <typename Head, typename... Tail>
void _LOG (const Head& head, const Tail&... tail) {
    // Unbuffered!
    std::cout << head;

    _LOG (tail...);
}

} // Anonymous namespace

template <typename T>
class Singleton {

    public :

        Singleton (const Singleton&) = delete;
        Singleton (const Singleton&&) = delete;

        Singleton& operator= (const Singleton&) = delete;
        Singleton& operator= (Singleton&&) = delete;

        // Each shared object should have its own instance
        COMMON_PRIVATE static T& Instance ()
        {
            static T _instance;
            return _instance;
        }

    protected :

        COMMON_PRIVATE Singleton () = default;
        COMMON_PRIVATE virtual ~Singleton () = default;

    private :

        // Nothing
};

COMMON_PRIVATE bool lookup (const std::string symbol, uintptr_t& _address, bool default_scope = false);
COMMON_PRIVATE bool loaded(const std::string lib);
