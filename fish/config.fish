alias tty-clock="tty-clock -t -c -C 1"

# Ctrl+Backspace to delete word backward
bind \b backward-kill-word

# Ctrl+Left to jump word backward
bind \e\[1\;5D backward-word

# Ctrl+Right to jump word forward
bind \e\[1\;5C forward-word


if status is-interactive
# Commands to run in interactive sessions can go here
   starship init fish | source
end
