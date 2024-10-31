FROM archlinux:latest

RUN pacman -Sy
RUN pacman -S neovim --noconfirm
RUN pacman -S git --noconfirm
RUN pacman -S zsh --noconfirm
RUN pacman -S zoxide --noconfirm
RUN pacman -S sudo --noconfirm
RUN pacman -S which --noconfirm 

RUN useradd --create-home --shell /usr/bin/zsh jsimpson -p "$(openssl passwd -1 alewiss)"

USER jsimpson
WORKDIR /home/jsimpson
RUN mkdir /home/jsimpson/Code
RUN mkdir /home/jsimpson/.config
RUN mkdir -p /home/jsimpson/.local/bin

WORKDIR /home/jsimpson/Code
RUN git clone https://github.com/simpsonjt66/dotfiles.git

USER root
RUN chsh -s /usr/bin/zsh jsimpson
ADD ./zsh/zshenv /etc/zsh/zshenv

USER jsimpson
WORKDIR /home/jsimpson

CMD ["zsh"]



