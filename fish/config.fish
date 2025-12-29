set -g fish_greeting

if status is-interactive
    starship init fish | source
end

# List Directory
alias l='eza -lh  --icons=auto' # long list
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree

# Show timetable in console
alias timetable='chafa ~/Documents/TimeTable.jpeg'

alias turnOnHotspot='nmcli device wifi hotspot ifname wlan1 ssid soni password honey@2014'
# Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
abbr mkdir 'mkdir -p'

set PATH $HOME/.local/share/gem/ruby/3.3.0/bin $PATH
set PATH $HOME/go/bin $PATH

set -x ANDROID_HOME /opt/android-sdk
set -x PATH $PATH $ANDROID_HOME/emulator
set -x PATH $PATH $ANDROID_HOME/tools
set -x PATH $PATH $ANDROID_HOME/tools/bin
set -x PATH $PATH $ANDROID_HOME/cmdline-tools/latest/bin
set -x PATH $PATH $ANDROID_HOME/platform-tools

set -x JAVA_HOME /usr/lib/jvm/default
# set -x JAVA_HOME /usr/lib/jvm/java-11-openjdk
# set -x PATH $JAVA_HOME/bin $PATH


