# Changing/making/removing directory
setopt autocd
setopt autopushd
setopt pushdignoredups
setopt pushdminus

for index ({1..9}) alias "$index"="cd -${index}"; unset index


compdef _dirs d

