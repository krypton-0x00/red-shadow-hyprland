alias tty-clock="tty-clock -t -c -C 1"

# Ctrl+Backspace to delete word backward
bind \b backward-kill-word

# Ctrl+Left to jump word backward
bind \e\[1\;5D backward-word

# Ctrl+Right to jump word forward
bind \e\[1\;5C forward-word

# install wrapper
function install
  
    if not test -e ~/red-shadow-hyprland/packages.lst
        touch ~/red-shadow-hyprland/packages.lst
    end


    yay -S $argv
    for pkg in $argv
        if not grep -qx "$pkg" ~/red-shadow-hyprland/packages.lst
            echo "$pkg" >> ~/red-shadow-hyprland/packages.lst
        end
    end
end

#ALIAS FOR INSTALL FUNCTION
alias i="install"

# Custom Alias
alias ls="eza --icons --group-directories-first"
alias ll="eza -l --icons --group-directories-first"
alias la="eza -la --icons --group-directories-first"
alias lt="eza --tree --level=2 --icons"
alias cat="bat --paging=never"
zoxide init fish | source
alias cd="z"




if status is-interactive
   starship init fish | source
   fastfetch
   
end
