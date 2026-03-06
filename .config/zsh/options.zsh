setopt autocd
setopt autopushd
setopt pushdignoredups
setopt pushdminus

setopt extendedhistory
setopt histignoredups
setopt histignorespace
setopt histexpiredupsfirst
setopt histverify
setopt sharehistory
setopt histignorealldups

setopt interactivecomments
setopt promptsubst
setopt completeinword
setopt automenu

setopt alwaystoend
setopt longlistjobs
setopt noflowcontrol

# History Setup
HISTFILE="${HISTFILE:-$HOME/.zsh_history}"
HISTSIZE=$(( HISTSIZE < 50000 ? 50000 : HISTSIZE ))
SAVEHIST=$(( SAVEHIST < 10000 ? 10000 : SAVEHIST ))


