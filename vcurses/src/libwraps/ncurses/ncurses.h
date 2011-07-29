

#ifndef LIBWRAP_NCURSES_H_
#define LIBWRAP_NCURSES_H_

#include <curses.h>

#include <vframework.h>
#include <libwraps/ncurses/window.h>

namespace vcurses {
namespace libwraps {
namespace ncurses {

#define INVISIBLE       0
#define NORMAL          1
#define VERY_VISIBLE    2

using namespace vframework::vbase;

class ncurses {

  public:

    ~ncurses() {
        reference = null(ncurses);
    }

    static ncurses* ref () {
        if (reference)
            return reference;
        else
            return reference = new ncurses;
    }

    window init () {
        stdscr_ = initscr();
        stdscr_.iref()->set_ownership(false);
        return stdscr_;
    }

    v_int end () {
        stdscr_ = null(WINDOW);
        return endwin();
    }

    window stdscr () {
        return stdscr_;
    }

    native_wrap_return (v_int, refresh)
    native_wrap_return (v_bool, has_colors)
    native_wrap_return (v_int, start_color)
    native_wrap_return (v_int, raw)
    native_wrap_return (v_int, noraw)
    native_wrap_return (v_int, echo)
    native_wrap_return (v_int, noecho)
    native_args_return (v_int, curs_set, (v_int visibility), (visibility))

  private:

    static ncurses *reference;

    window stdscr_;

    ncurses() : stdscr_(null(WINDOW)) {}

};

}
}
}

#endif /* LIBWRAP_NCURSES_H_ */
