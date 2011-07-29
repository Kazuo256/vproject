/*
 * SDL.h
 *
 *  Created on: May 22, 2011
 *      Author: kazuo
 */

#ifndef LIBWRAP_SDL_H_
#define LIBWRAP_SDL_H_

#include <SDL/SDL.h>

#include <vframework.h>

namespace vdl {
namespace libwraps {
namespace SDL {

using namespace vframework::vbase;

class SDL {

  public:

    ~SDL () {}

    static SDL* ref () {
        if (reference)
            return reference;
        else
            return reference = new SDL;
    }

    native_return (v_int, Init, (v_size flags), SDL_Init(flags))
    native_void (Quit, (), SDL_Quit())
    native_return (v_size, GetTicks, (), SDL_GetTicks())
    native_void (Delay, (v_size ms), SDL_Delay(ms))

  private:

    static SDL *reference;

    SDL () {}

};

}
}
}

#endif /* LIBWRAP_SDL_H_ */
