
#ifndef VWINDOW_H_
#define VWINDOW_H_

#include <curses.h>

#include <vframework.h>

namespace vcurses {
namespace libwraps {
namespace ncurses {

using namespace vframework::vbase;

class v_window_allocator {
  public:
    void destroy (WINDOW *win) {}
    void deallocate (WINDOW *win, v_size n) {
        delwin(win);
    }
};

typedef vref<WINDOW, void, v_window_allocator> WINDOW_ref;

class window : public WINDOW_ref {

  public:

    window (const window& ref) : WINDOW_ref(ref) {}
    window (WINDOW *win) : WINDOW_ref(win) {}
    ~window () {}

    native_args_return (v_bool, keypad, (v_bool bflag), (*(*this), bflag))
    native_return (v_int, refresh, (), wrefresh(*(*this)))

    v_int printw (const v_char *fmt, ...) {
        va_list vl;
        va_start(vl, fmt);
        v_int ret = vwprintw(*(*this), fmt, vl);
        va_end(vl);
        return ret;
    }

    v_int mvprintw (v_int y, v_int x, const v_char *fmt, ...) {
        va_list vl;
        va_start(vl, fmt);
        v_int ret = wmove(*(*this), y, x);
        if (ret == ERR) return ret;
        ret = vwprintw(*(*this), fmt, vl);
        va_end(vl);
    }

    v_word height () {
        return getmaxy(*(*this));
    }

    v_word width () {
        return getmaxx(*(*this));
    }

  private:

};

}
}
}

#endif /* VWINDOW_H_ */
