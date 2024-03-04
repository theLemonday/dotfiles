if status is-interactive
    # Commands to run in interactive sessions can go here
	set -x LS_COLORS (vivid generate molokai)
	#source "$HOME/.cargo/env"
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# GoLang
set GOROOT '/home/lemonday/.go'
set GOPATH '/home/lemonday/go'
set PATH $GOPATH/bin $GOROOT/bin $PATH
