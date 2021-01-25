/*
Copyright (C) 2020-2021 Metrological
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
*/

// https://gcc.gnu.org/projects/cxx-status.html
// https://en.cppreference.com/w/cpp/feature_test
#if __cplusplus >= 200806L || defined (__cpp_threadsafe_static_init)
#warning "Thread safe static initialization is supported"
#else
#error "Thread safe static initialization is NOT supported but is required."
#endif

#include "common.h"

#include <string>

// A little less code bloat
#ifndef _2CSTR
#define _2CSTR(str) std::string (str).c_str ()
#endif

#define PROXYGBM_PRIVATE COMMON_PRIVATE
#define PROXYGBM_PUBLIC COMMON_PUBLIC

#define PROXYGBM_UNUSED __attribute__ ((unused))

#include <unordered_map>
#include <unordered_set>
#include <functional>

#ifdef __cplusplus
extern "C" {
#endif
#include <gbm.h>
#ifdef __cplusplus
}
#endif

#ifdef __cplusplus
extern "C" {
#endif

PROXYGBM_PUBLIC struct gbm_bo* gbm_surface_lock_front_buffer (struct gbm_surface* surface);
PROXYGBM_PUBLIC void gbm_surface_release_buffer (struct gbm_surface* surface, struct gbm_bo* bo);
PROXYGBM_PUBLIC int gbm_surface_has_free_buffers (struct gbm_surface* surface);

PROXYGBM_PUBLIC struct gbm_surface* gbm_surface_create (struct gbm_device* gbm, uint32_t width, uint32_t height, uint32_t format, uint32_t flags);
PROXYGBM_PUBLIC struct gbm_surface* gbm_surface_create_with_modifiers (struct gbm_device* gbm, uint32_t width, uint32_t height, uint32_t format, const uint64_t* modifiers, const unsigned int count);

PROXYGBM_PUBLIC void gbm_surface_destroy (struct gbm_surface* surface);
PROXYGBM_PUBLIC void gbm_device_destroy (struct gbm_device* device);

PROXYGBM_PUBLIC struct gbm_device* gbm_create_device (int fd);

#ifdef __cplusplus
}
#endif

namespace std {

// Hash specialization that works with constant pointers
template <typename T>
struct hash <T* const> {
    size_t operator () (const T* const & obj) const {
        size_t _ret = 0;

        std::hash <const T*> hashfnc;

        _ret = hashfnc (obj);

        return _ret;
    }
};

}

namespace {
// Suppress compiler preprocessor 'visibiity ignored' in anonymous namespace
#define _PROXYGBM_PRIVATE /*PROXYGBM_PRIVATE*/
#define _PROXYGBM_PUBLIC PROXYGBM_PUBLIC
#define _PROXYGBM_UNUSED PROXYGBM_UNUSED

class Platform : public Singleton <Platform> {
    using sync_t = MutexRecursive;

    using gbm_bo_t      = struct gbm_bo*;
    using gbm_surface_t = struct gbm_surface*;
    using gbm_device_t  = struct gbm_device*;

    // This (These) friend(s) has (have) access to all members!
    friend Singleton <Platform>;

    public :

        // The hash can be specificied explicitly but it is not required as it is part of 'std' namespace
        using map_buf_t = std::unordered_map <gbm_bo_t const, uint32_t>;

        _PROXYGBM_PRIVATE bool Add (gbm_surface_t const & surface, gbm_bo_t const & bo);
        // The second parameter does not have to exist or explicitly provided
        _PROXYGBM_PRIVATE bool Remove (gbm_surface_t const & surface, gbm_bo_t const bo = nullptr);

        _PROXYGBM_PRIVATE bool Add (gbm_device_t const & device, gbm_surface_t const & surface);
        // The second parameter does not have to exist or explicitly provided
        _PROXYGBM_PRIVATE bool Remove (gbm_device_t const & device, gbm_surface_t const surface = nullptr);

        // 'Educated' guess of the (next0 buffer
        gbm_bo_t PredictedBuffer (gbm_surface_t const & surface) const;

        _PROXYGBM_PRIVATE bool Exist (gbm_device_t const & device) const;
        _PROXYGBM_PRIVATE bool Exist (gbm_surface_t const & surface) const;

        _PROXYGBM_PRIVATE static constexpr sync_t& SyncObject () {
            return _syncobject;
        }

    protected :

    //  Nothing

    private :

        _PROXYGBM_PRIVATE static sync_t _syncobject;

        // The hash can be specificied explicitly but it is not required as it is part of 'std' namespace
        using map_surf_t = std::unordered_map <gbm_surface_t const, map_buf_t>;
        // The const is not allowed for the second element in unordered_map
        using set_surf_t = std::unordered_set <gbm_surface_t /*const*/>;
        using map_dev_t  = std::unordered_map <gbm_device_t const, set_surf_t>;

        map_surf_t _map_surf;
        map_dev_t _map_dev;

        Platform () {
            /*void*/ _map_surf.clear ();
            /*void*/ _map_dev.clear ();
        }

        virtual ~Platform () {
            for (auto _it_surf = _map_surf.begin (), _end = _map_surf.end (); _it_surf != _end; _it_surf++) {
                LOG (_2CSTR ("Warning: remaining (gbm) surface entry: "), _it_surf->first);

                auto _buffers = _it_surf->second;

                if (_buffers.size () > 0) {
                    for (auto _it_buf = _buffers.begin (), _end = _buffers.end (); _it_buf != _end; _it_buf++) {
                        LOG (_2CSTR ("   |--> with buffer: "), _it_buf->first);
                    }
                }
                else {
                    LOG (_2CSTR ("   |--> with NO buffers"));
                }
            }

            for (auto _it_dev = _map_dev.begin (), _end = _map_dev.end (); _it_dev != _end; _it_dev++) {
                LOG (_2CSTR ("Warning: remaining (gbm) device entry: "), _it_dev->first);

                auto _surfaces = _it_dev->second;

                if (_surfaces.size () > 0) {
                    for (auto _it_surf = _surfaces.begin (), _end = _surfaces.end (); _it_surf != _end; _it_surf++) {
                        LOG (_2CSTR ("   |--> with surface: "), *_it_surf);
                    }
                }
                else {
                    LOG (_2CSTR ("   |--> with NO surfaces"));
                }
            }
        }

        _PROXYGBM_PRIVATE uint16_t Sequence (uint32_t value) const {
            return static_cast <uint16_t> (value >> 16);
        }

        _PROXYGBM_PRIVATE uint16_t Count (uint32_t value) const {
            return static_cast <uint16_t> (value & static_cast <uint32_t> (CountBitmask ()));
        }


        _PROXYGBM_PRIVATE static constexpr uint16_t SequenceInitialValue (void) {
            return 0;
        }

        _PROXYGBM_PRIVATE static constexpr uint16_t SequenceMaxValue (void) {
            return 4;
        }

        _PROXYGBM_PRIVATE static constexpr uint16_t CountInitialValue (void) {
            return 1;
        }

        _PROXYGBM_PRIVATE static constexpr uint16_t CountMaxValue () {
            return 4;
        }

        // Extract part of the gbm_bo_t paired value, here reference count
        _PROXYGBM_PRIVATE static constexpr uint16_t CountBitmask () {
            return 0x00FF;
        }

        // Extract part of the gbm_bo_t paired value, here sequence number
        _PROXYGBM_PRIVATE static constexpr uint16_t SequenceBitmask () {
            return 0xFF00;
        }

        _PROXYGBM_PRIVATE uint32_t Convert (uint16_t count, uint16_t sequence) const {
            return count + (sequence << 16);
        }

        _PROXYGBM_PRIVATE bool Age (map_buf_t& buffers) const;
        _PROXYGBM_PRIVATE bool Rejuvenate (map_buf_t& buffers) const;

// TODO: probably misused at places
        _PROXYGBM_PRIVATE static constexpr uint32_t NonEmptySizeInitialValue (void) {
            return 1;
        }

        _PROXYGBM_PRIVATE gbm_bo_t PredictedBuffer (map_buf_t const & buffers) const;
        _PROXYGBM_PRIVATE map_buf_t const & Buffers (gbm_surface_t const & surface) const;
};

/*_PROXYGBM_PRIVATE*/ Platform::sync_t Platform::_syncobject;

Platform::map_buf_t const & Platform::Buffers (gbm_surface_t const & surface) const {
    std::lock_guard < decltype (Platform::_syncobject) > _lock (_syncobject);

    // Empty well-defined placeholder
    static map_buf_t _map;

    map_buf_t& result = _map;

    if (surface != nullptr) {
        auto _it = _map_surf.find (surface);

        if (_it != _map_surf.end ()) {
            result = _it->second;
        }
    }

    return result;
}

Platform::gbm_bo_t Platform::PredictedBuffer (gbm_surface_t const & surface) const {
    struct gbm_bo* bo = nullptr;

    std::lock_guard < decltype (Platform::_syncobject) > _lock (_syncobject);

    auto _buffers = Platform::Instance ().Buffers (surface);

    if (_buffers.empty () != true) {
        // Decision time, without any (prior) knowledge select one of the recorded bo's
        bo = PredictedBuffer (_buffers);
    }
    else {
        // No recorded bo's, and failure, hand over the result
    }

    return bo;
}

Platform::gbm_bo_t Platform::PredictedBuffer (map_buf_t const & buffers) const {
    gbm_bo_t ret = nullptr;

    decltype (CountInitialValue ()) _count = CountInitialValue ();
    decltype (SequenceInitialValue ()) _sequence = SequenceInitialValue ();

    for (auto _it = buffers.begin (), _end = buffers.end (); _it != _end; _it++) {
        // The list should contain sane entries
        assert (_it->first != nullptr && Count (_it->second) >= CountInitialValue ());

        // Oldest, with lowest count is most probably the one required by a successive call to gbm_surface_lock_front_buffer
        if (Sequence (_it->second) >= _sequence) {
            if (Count (_it->second) <= _count) {
                _count = Count (_it->second);
                ret = _it->first;
                _sequence = Sequence (_it->second);
            }
        }
    }

    return ret;
}

bool Platform::Age (map_buf_t& buffers) const {
    bool ret = buffers.size () >= NonEmptySizeInitialValue ();

    for (auto _it_buf = buffers.begin (), _end = buffers.end (); _it_buf != _end; _it_buf++) {
        decltype (_it_buf->second) _count = Count (_it_buf->second);
        decltype (_it_buf->second) _sequence = Sequence (_it_buf->second);

        assert (_sequence < SequenceMaxValue ());

        ++_sequence;

        _it_buf->second = Convert (_count, _sequence);
    }

    return ret;
}

bool Platform::Rejuvenate (map_buf_t& buffers) const {
    bool ret = buffers.size () >= NonEmptySizeInitialValue ();

    for (auto _it_buf = buffers.begin (), _end = buffers.end (); _it_buf != _end; _it_buf++) {
        decltype (_it_buf->second) _count = Count (_it_buf->second);
        decltype (_it_buf->second) _sequence = Sequence (_it_buf->second);

        assert (_sequence > SequenceInitialValue ());

        _sequence--;

        _it_buf->second = Convert (_count, _sequence);
    }

    return ret;
}

bool Platform::Add (gbm_surface_t const & surface, gbm_bo_t const & bo) {
    std::lock_guard < decltype (Platform::_syncobject) > _lock (_syncobject);

    auto _it_surf = _map_surf.find (surface);

    map_buf_t _buffers;

    if (_it_surf != _map_surf.end ()) {
        // Surface buffers entry exists

        _buffers = _it_surf->second;
    }
    else {
        // No known surface
        if (surface != nullptr) {
            auto __it_surf = _map_surf.insert (std::pair < gbm_surface_t const, map_buf_t > (surface, _buffers));

            // The iterator may have become singular

            if (__it_surf.second != false) {
                assert (__it_surf.first != _map_surf.end ());

                _it_surf = __it_surf.first;
            }
        }
        else {
            assert (false);
        }
    }

    auto _it_buf = _buffers.find (bo);

    if (_it_buf != _buffers.end ()) {
        // bo exist
        assert (Count (_it_buf->second) >= CountInitialValue ());

        decltype (_it_buf->second) _count = Count(_it_buf->second);
        decltype (_it_buf->second) _sequence = Sequence(_it_buf->second);

        assert (_count < CountMaxValue ());

        _count++;

        _it_buf->second = Convert (_count, _sequence);
    }
    else {
        //  bo does not exist or bo equals nullptr

        if (bo != nullptr) {
            auto __it_buf = _buffers.insert (std::pair < gbm_bo_t const, uint32_t> (bo, Convert (CountInitialValue (), SequenceInitialValue ())));

            // The iterator may have become singular

            if ( __it_buf.second != false) {
                assert (__it_buf.first != _buffers.end ());

                _it_buf = __it_buf.first;

                if (Age (_buffers) != true) {
                    assert (false);
                }
            }
        }
        else {
            // Empty set
        }
    }

    bool ret = false;

    if (_it_surf != _map_surf.end ()) {

        // Successfully added or empty set
        if ((bo != nullptr && _it_buf != _buffers.end ()) || (bo == nullptr && _buffers.empty () != false)) {
            _it_surf->second = _buffers;

            ret  = true;
        }

    }
    else {
        // Surface is a nullptr or could not be added, in debug mode, only, could not be added
        assert (false);
    }

    return ret;
}

bool Platform::Remove (gbm_surface_t const & surface, gbm_bo_t bo) {
    std::lock_guard < decltype (Platform::_syncobject) > _lock (_syncobject);

    bool ret = false;

    auto _it_surf = _map_surf.find (surface);

    map_buf_t _buffers;

    if (_it_surf != _map_surf.end ()) {
        // Surface buffers entry exists

        _buffers = _it_surf->second;
    }
    else {
        // No known surface
        if (surface != nullptr) {
            assert (false);
        }
        else {
            // Remove all surfaces and consequently all devices
            /*void*/ _map_dev.clear ();
            /*void*/ _map_surf.clear ();

            // iterator has become singular
            _it_surf = _map_surf.end ();

            assert (_map_dev.size () < NonEmptySizeInitialValue ());
            assert (_map_surf.size () < NonEmptySizeInitialValue ());
        }
    }

    auto _it_buf = _buffers.find (bo);

    if (_it_buf != _buffers.end ()) {
        assert (bo != nullptr);

        // bo exist
        assert (Count (_it_buf->second) >= CountInitialValue ());

        switch (Count (_it_buf->second)) {
            case 0  :   // Error, it should not happen, try to make the _map sane
                        assert (false);
            case 1  :  // Count reduces to 0

                        switch (_buffers.erase (bo)) {
                            case 1  :   // Expected, iterator has become singular
                                        ret = Rejuvenate (_buffers);
                                        break;
                            case 0  :;
                            default :   // Unexpected, iterator has become singular
                                        _it_buf = _buffers.end ();
                                        assert (false);
                        }

                        break;
            default :   // > 1
                        decltype (_it_buf->second) _count = Count (_it_buf->second);
                        decltype (_it_buf->second) _sequence = SequenceInitialValue(); //Sequence (_it_buf->second);

                        assert (_count > CountInitialValue ());

                        --_count;

                        _it_buf->second = Convert (_count, _sequence);

                        ret = true;
        }
    }
    else {
        // Unknown bo or bo equals nullptr, nullptr is not an element in the map

        if (bo == nullptr) {
            // All associated bos have to be removed

            /* void */ _buffers.clear ();

            // iterator has become singular

            ret = _buffers.size() < NonEmptySizeInitialValue ();

            assert (ret != false);
        }
        else {
            // Error, untracked bo
#ifdef _NO_RESTART_APPLICATION
            assert (false);
#endif
        }
    }

    if (_it_surf != _map_surf.end ()) {
        if (ret != false /*|| bo == nullptr*/) {
            // An empty set is still valid
            _it_surf->second = _buffers;
        }
    }
    else {
        // Unknown surface or cleared map, in debug mode, only, a cleared map
        ret = surface == nullptr && _map_surf.size () < NonEmptySizeInitialValue ();

        assert (ret != false);
    }

    return ret;
}

bool Platform::Add (gbm_device_t const & device, gbm_surface_t const & surface) {
    std::lock_guard < decltype (Platform::_syncobject) > _lock (_syncobject);

    auto _it_dev = _map_dev.find (device);

    set_surf_t _surfaces;

    if (_it_dev != _map_dev.end ()) {
        // Device surfaces entry exist

        _surfaces = _it_dev->second;
    }
    else {
        // No known device
        if (device != nullptr) {
            auto __it_dev = _map_dev.insert (std::pair < gbm_device_t const, set_surf_t> (device, _surfaces));

            // The iterator may have become singular

            if (__it_dev.second != false) {
                assert (__it_dev.first != _map_dev.end ());

                _it_dev = __it_dev.first;
            }
        }
        else {
            assert (false);
        }
    }

    auto _it_surf = _surfaces.find (surface);

    if (_it_surf != _surfaces.end ()) {
        // Surface exist

        // Not an error if _map_surf has no associated bo's

        auto _buffers = Buffers (surface);

        if (_buffers.size () >= NonEmptySizeInitialValue ()) {
            _it_surf = _surfaces.end ();
            assert (false);
        }
    }
    else {
        //  Surface does not exist or surface equals nullptr

        if (surface != nullptr) {
            auto __it_surf = _surfaces.insert (surface);

            // The iterator may have become singular

            if ( __it_surf.second != false) {
                assert (__it_surf.first != _surfaces.end ());

                _it_surf = __it_surf.first;
            }
        }
        else {
            // Empty set
        }
    }

    bool ret = false;

    if (_it_dev != _map_dev.end ()) {

        // Successfully added or empty set
        if ((surface != nullptr && _it_surf != _surfaces.end ()) || (surface == nullptr && _surfaces.empty () != false)) {

            ret = true;

            if (surface != nullptr) {
                ret = Add (surface, nullptr);
            }

            if (ret != false) {
                _it_dev->second = _surfaces;
            }

            assert (ret != false);
        }
    }
    else {
        // Device is a nullptr or could not be added, in debug mode, only, could not be added
        assert (false);
    }

    return ret;
}

bool Platform::Remove (gbm_device_t const & device, gbm_surface_t surface) {
    std::lock_guard < decltype (Platform::_syncobject) > _lock (_syncobject);

    bool ret = false;

    auto _it_dev = _map_dev.find (device);

    set_surf_t _surfaces;

    if (_it_dev != _map_dev.end ()) {
        // Device surfaces entry exist

        _surfaces = _it_dev->second;
    }
    else {
        // Failure or no known device, surfaces are not tracked for unknown devices
        if (device != nullptr) {
            assert (false);
        }
        else {
            // Remove all devices and consequently all surfaces
            /*void*/ _map_dev.clear ();
            /*void*/ _map_surf.clear ();

            // iterator has become singular
            _it_dev = _map_dev.end ();

            assert (_map_dev.size () < NonEmptySizeInitialValue ());
            assert (_map_surf.size () < NonEmptySizeInitialValue ());
        }
    }

    auto _it_surf = _surfaces.find (surface);

    if (_it_surf != _surfaces.end ()) {
        assert (surface != nullptr);

        switch (_surfaces.erase (surface)) {
            case 1  :   // Expected
                        // Iterator has become singular
                        ret = Remove (surface);

                        assert (ret);

                        break;
            case 0  :; 
            default :   // Unexpected
                        // Iterator has become singular
                        _it_surf = _surfaces.end ();
                        assert (false);
        }
    }
    else {
        // Unknown or surface equals nullptr

        if (surface == nullptr) {
            // All associated surfaces have to be removed

            /* void */ _surfaces.clear ();

            // iterator has become singular

            ret = _surfaces.size () < NonEmptySizeInitialValue ();

            assert (ret != false);
        }
        else {
            // Error, untracked surface
            assert (false);
        }
    }

    if (_it_dev != _map_dev.end ()) {
        if (ret != false /*|| surface == nullptr*/) {
            // Successfully removed and/or empty set
            _it_dev->second = _surfaces;

            ret = true;
        }
    }
    else {
        // Unknown device or cleared map, in debug mode, only, a cleared map
        ret = device == nullptr && _map_dev.size () < NonEmptySizeInitialValue ();

        assert (ret);
    }

    return ret;
}

bool Platform::Exist (gbm_surface_t const & surface) const {
    std::lock_guard < decltype (Platform::_syncobject) > _lock (_syncobject);

    bool ret = false;

    if (surface != nullptr) {
        const auto _it_surf = _map_surf.find (surface);

        // Empty sets should be considered as non-existent
        ret = _it_surf != _map_surf.end () && _it_surf->second.size () >= NonEmptySizeInitialValue ();
    }
    else {
        // Unintended use
        assert (false);
    }

    return ret;
}

bool Platform::Exist (gbm_device_t const & device) const {
    std::lock_guard < decltype (Platform::_syncobject) > _lock (_syncobject);

    bool ret = false;

    if (device != nullptr) {
        auto _it_dev = _map_dev.find (device);

        // Empty sets should be considered as non-existent
        ret = _it_dev != _map_dev.end () && _it_dev->second.size () >= NonEmptySizeInitialValue ();
    }
    else {
        // Unintended use
        assert (false);
    }

    return ret;
}

#undef _PROXYGBM_PRIVATE
#undef _PROXYGBM_PUBLIC
#undef _PROXYGBM_UNUSED
} // Anonymous namespace

struct gbm_bo* gbm_surface_lock_front_buffer (struct gbm_surface* surface) {
    static struct gbm_bo* (*_gbm_surface_lock_front_buffer) (struct gbm_surface*) = nullptr;

    static bool resolved = lookup ("gbm_surface_lock_front_buffer", reinterpret_cast <uintptr_t&> (_gbm_surface_lock_front_buffer));

    struct gbm_bo* bo = nullptr;

    if (resolved != false) {
        std::lock_guard < decltype (Platform::Instance ().SyncObject ()) > _lock (Platform::Instance ().SyncObject ());

        bool _flag = false;

        if (surface != nullptr) {
            _flag = gbm_surface_has_free_buffers (surface) > 0;

            LOG (_2CSTR ("Calling Real gbm_surface_lock_front_buffer"));

            // This might trigger an internal error
            bo = _gbm_surface_lock_front_buffer (surface);
        }
        else {
            // Error
            assert (false);
        }

        if (bo == nullptr) {
            // gbm_surface_lock_front_buffer (also) fails if eglSwapBuffers has not been called (yet)

            if (_flag != false) {
                bo = Platform::Instance ().PredictedBuffer (surface);

                // Existing bo's can be updated by increasing the count
                if (Platform::Instance (). Add (surface, bo) != true) {
                    LOG (_2CSTR ("Unable to update existing bo"));
                }
            }
            else {
                // Error indicative for no free buffers, just hand over the result
            }
        }
        else {
            // A successful gbm_surface_lock_front_buffer

            if (Platform::Instance (). Add (surface, bo) != true) {
                // Unable to track or other error

                /* void */ gbm_surface_release_buffer (surface, bo);

                bo = nullptr;

                assert (false);
            }
            else {
                // Just hand over the created bo
            }
        }
    }
    else {
        LOG (_2CSTR ("Real gbm_surface_lock_front_buffer not found"));
        assert (false);
    }

    return bo;
}

void gbm_surface_release_buffer (struct gbm_surface* surface, struct gbm_bo* bo) {
    static void (*_gbm_surface_release_buffer) (struct gbm_surface*, struct gbm_bo*) = nullptr;

    static bool resolved = lookup ("gbm_surface_release_buffer", reinterpret_cast <uintptr_t&> (_gbm_surface_release_buffer));

    if (resolved != false) {
        std::lock_guard < decltype (Platform::Instance ().SyncObject ()) > _lock (Platform::Instance ().SyncObject ());

        if (Platform::Instance (). Remove (surface, bo) != true) {
#ifdef _NO_RESTART_APPLICATION
            // Error, probably, unknown surface, no known previous locked buffers or other error
            assert (false);
#endif
        }
        else {
            // Expected
        }

        // Avoid any segfault
        if (bo != nullptr) {
            LOG (_2CSTR ("Calling Real gbm_surface_release_buffer"));

            // Always release even an untracked surface
            /* void */ _gbm_surface_release_buffer (surface, bo);
        }
        else {
            // Error
            assert (false);
        }
    }
    else {
        LOG (_2CSTR ("Real gbm_surface_release_buffer not found"));
        assert (false);
    }
}

int gbm_surface_has_free_buffers(struct gbm_surface* surface) {
    static int (*_gbm_surface_has_free_buffers) (struct gbm_surface*) = nullptr;

    static bool resolved = lookup ("gbm_surface_has_free_buffers", reinterpret_cast <uintptr_t&> (_gbm_surface_has_free_buffers));

    // GBM uses only values 0 and 1; the latter indicates free buffers are available
    int ret = 0;

    if (resolved != false) {
        std::lock_guard < decltype (Platform::Instance ().SyncObject ()) > _lock (Platform::Instance ().SyncObject ());

        LOG (_2CSTR ("Calling Real gbm_surface_has_buffers"));

        ret = _gbm_surface_has_free_buffers (surface);
    }
    else {
        LOG (_2CSTR ("Real gbm_surface_has_free_buffers not found"));
        assert (false);
    }

    return ret;
}

struct gbm_surface* gbm_surface_create (struct gbm_device* gbm, uint32_t width, uint32_t height, uint32_t format, uint32_t flags) {
    static struct gbm_surface* (*_gbm_surface_create) (struct gbm_device*, uint32_t, uint32_t, uint32_t, uint32_t) = nullptr;

    static bool resolved = lookup ("gbm_surface_create", reinterpret_cast <uintptr_t&> (_gbm_surface_create));

    struct gbm_surface* ret = nullptr;

    if (resolved != false) {
        std::lock_guard < decltype (Platform::Instance ().SyncObject ()) > _lock (Platform::Instance ().SyncObject ());

        LOG (_2CSTR ("Calling Real gbm_surface_create"));

        ret = _gbm_surface_create (gbm, width, height, format, flags);

        // The surface should not yet exist
        if (Platform::Instance ().Exist (ret) != false && Platform::Instance ().Remove (ret) != false) {
            assert (false);
        }

        if (Platform::Instance ().Add (gbm, ret) != true) {
            /* void */ gbm_surface_destroy (ret);

            ret = nullptr;

            assert (false);
        }
        else {
            // Just hand over the created surface (pointer)
        }
    }
    else {
        LOG (_2CSTR ("Real gbm_surface_create not found"));
        assert (false);
    }

    return ret;
}

struct gbm_surface* gbm_surface_create_with_modifiers (struct gbm_device* gbm, uint32_t width, uint32_t height, uint32_t format, const uint64_t* modifiers, const unsigned int count) {
    static struct gbm_surface* (*_gbm_surface_create_with_modifiers) (struct gbm_device*, uint32_t, uint32_t, uint32_t, const uint64_t*, const unsigned int) = nullptr;

    static bool resolved = lookup ("gbm_surface_create_with_modifiers", reinterpret_cast <uintptr_t&> (_gbm_surface_create_with_modifiers));

    // GBM uses only values 0 and 1; the latter indicates free buffers are available
    struct gbm_surface* ret = nullptr;

    if (resolved != false) {
        std::lock_guard < decltype (Platform::Instance ().SyncObject ()) > _lock (Platform::Instance ().SyncObject ());

        LOG (_2CSTR ("Calling Real gbm_surface_create_with_modifiers"));

        ret = _gbm_surface_create_with_modifiers (gbm, width, height, format, modifiers, count);

        // The surface should not yet exist
        if (Platform::Instance ().Exist (ret) != false && Platform::Instance ().Remove (ret)) {
            assert (false);
        }

        if (Platform::Instance ().Add (gbm, ret) != true) {
            /* void */ gbm_surface_destroy (ret);

            ret = nullptr;

            assert (false);
        }
        else {
            // Just hand over the created gbm_surface
        }
    }
    else {
        LOG (_2CSTR ("Real gbm_surface_create_with_modifiers"));
        assert (false);
    }

    return ret;
}

void gbm_surface_destroy (struct gbm_surface* surface) {
    static void (*_gbm_surface_destroy) (struct gbm_surface*) = nullptr;

    static bool resolved = lookup ("gbm_surface_destroy", reinterpret_cast <uintptr_t&> (_gbm_surface_destroy));

    if (resolved != false) {
        std::lock_guard < decltype (Platform::Instance ().SyncObject ()) > _lock (Platform::Instance ().SyncObject ());

        // Remove all references
        if (Platform::Instance ().Remove (surface, nullptr) != false) {
            LOG (_2CSTR ("Calling Real gbm_surface_destroy"));
            /*void*/ _gbm_surface_destroy (surface);
        }
        else {
            // Error
            assert (false);
        }
    }
    else {
        LOG (_2CSTR ("Real gbm_surface_destroy not found"));
        assert (false);
    }
}

void gbm_device_destroy (struct gbm_device* device) {
    static void (*_gbm_device_destroy) (struct gbm_device*) = nullptr;

    static bool resolved = lookup ("gbm_device_destroy", reinterpret_cast <uintptr_t&> (_gbm_device_destroy));

    if (resolved != false) {
        std::lock_guard < decltype (Platform::Instance ().SyncObject ()) > _lock (Platform::Instance ().SyncObject ());

        // Remove all references
        if (Platform::Instance ().Remove (device, nullptr) != false) {
            LOG (_2CSTR ("Calling Real gbm_device_destroy"));
            /* void */ _gbm_device_destroy (device);
        }
        else {
            // Error
            assert (false);
        }
    }
    else {
        LOG (_2CSTR ("Real gbm_device_destroy not found"));
        assert (false);
    }
}

struct gbm_device* gbm_create_device (int fd) {
    static struct gbm_device* (*_gbm_create_device) (int) = nullptr;

    static bool resolved = lookup ("gbm_create_device", reinterpret_cast <uintptr_t&> (_gbm_create_device));

    struct gbm_device* ret = nullptr;

    if (resolved != false) {
        std::lock_guard < decltype (Platform::Instance ().SyncObject ()) > _lock (Platform::Instance ().SyncObject ());

        LOG (_2CSTR ("Calling Real gbm_create_device"));

        ret = _gbm_create_device (fd);

        // The device should not yet exist
        if (Platform::Instance ().Exist (ret) != false && Platform::Instance ().Remove (ret)) {
            assert (false);
        }

        if (Platform::Instance ().Add (ret, nullptr) != true) {
            /* void */ gbm_device_destroy (ret);

            ret = nullptr;

            assert (false);
        }
        else {
            // Just hand over the created device (pointer)
        }
    }
    else {
        LOG (_2CSTR ("Real gbm_create_device not found"));
        assert (false);
    }

    return ret;
}
