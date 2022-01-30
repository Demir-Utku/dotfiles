#!/bin/bash
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

SESSION=${1:-cinnamon}

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

export DESKTOP_SESSION=cinnamon

get_session(){
	local dbus_args=(--sh-syntax --exit-with-session)
	case "$1" in
		cinnamon) dbus_args+=(cinnamon-session) ;;
		gnome) dbus_args+=(gnome-session) ;;
		kde) dbus_args+=(startplasma-x11) ;;
		mate) dbus_args+=(mate-session) ;;
		xfce) dbus_args+=(xfce4-session) ;;
		*) dbus_args+=("$1") ;;
	esac

	echo "dbus-launch ${dbus_args[*]}"
}

exec $(get_session "$1")
xset r rate 400 40
