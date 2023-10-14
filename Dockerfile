# Use the latest Debian image as the base
FROM debian:latest

# Update package list and install necessary packages
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        curl \
        git \
        fish \
        tmux \
        && rm -rf /var/lib/apt/lists/*

# Install Rust using rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Add cargo to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Install rust-analyzer
RUN rustup component add rls rust-analysis rust-src

# Set fish as the default shell in tmux
RUN echo "set-option -g default-shell /usr/bin/fish" >> ~/.tmux.conf

# Download and install Neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz && \
    tar xzf nvim-linux64.tar.gz -C /usr/local --strip-components=1 && \
    rm nvim-linux64.tar.gz

# Clone LunarVim repository and install
RUN git clone https://github.com/ChristianChiarulli/LunarVim.git ~/.config/lvim && \
    cd ~/.config/lvim && \
    curl -s https://raw.githubusercontent.com/ChristianChiarulli/LunarVim/master/utils/installer/install.sh > lunarvim_install.sh && \
    bash lunarvim_install.sh && \
    rm lunarvim_install.sh

# Set up a working directory
WORKDIR /workspace

# Start tmux with fish shell on entry
CMD ["tmux", "-u"]

