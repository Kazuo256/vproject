
#include <vframework.h>
#include <libwraps/ncurses/ncurses.h>
#include <libwraps/SDL/SDL.h>

using namespace vframework::vbase;
using namespace vcurses::libwraps::ncurses;
using namespace vdl::libwraps::SDL;

int main (int argc, char **argv) {
    ncurses *vcurses = ncurses::ref();
    SDL *sdl = SDL::ref();
    if (sdl->Init(SDL_INIT_VIDEO | SDL_INIT_TIMER) == -1)
        puts("OH NOES SDL!");
    if (vcurses->init() == null(WINDOW))
        puts("OH NOES NCURSES!");
    vcurses->raw();
    vcurses->stdscr().keypad(TRUE);
    vcurses->noecho();
    vcurses->curs_set(INVISIBLE);
    window win = newwin(4, 11, 0, 0);
    win.mvprintw(1, 1, "OUTERMAZE");
    for (v_int i = 0; i < vcurses->stdscr().height() - 3; i++) {
        wborder((*win), ' ', ' ', ' ',' ',' ',' ',' ',' ');
        win.refresh();
        mvwin((*win), i, i);
        box(*win, 0 , 0);
        win.refresh();
        sdl->Delay(100);
    }
    win = null(WINDOW);
    vcurses->end();
    sdl->Quit();
    return 0;
}

