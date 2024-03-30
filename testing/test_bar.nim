import std/terminal
import std/[os, strutils]

var exercise = 21



proc print_bar(ammount: int) =
    stdout.styledWriteLine(
        fgRed, "[0 ",
        if ammount < 30: fgRed
        elif ammount < 70: fgYellow
        else: fgGreen, '='.repeat(ammount),
        " ", fgGreen, $ammount, "/", fgGreen, "96]")

