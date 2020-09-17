#!/bin/bash -e


function install_oh_my_zsh () {
    sudo apt-get update
    sudo apt install -y zsh
    sudo apt install -y powerline fonts-powerline figlet lolcat
    git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    sudo chsh -s /bin/zsh
    sudo chmod -R 744 ~/.oh-my-zsh/
}

function install_autojump () {
    git clone git://github.com/wting/autojump.git
    cd autojump
    ./install.py
}

# a windows sysetm reboot may be required after executing this
# if installing on Windows Subsystem For Linux 2
function install_dotnet_core_sdk_31_and_21_runtime () {
    wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    sudo add-apt-repository universe
    sudo apt-get update
    sudo apt-get install -y apt-transport-https
    sudo apt-get update
    sudo apt-get install -y dotnet-sdk-3.1
    sudo apt-get install -y aspnetcore-runtime-2.1
}

function install_dotnet_global_tools () {
    dotnet tool install -g dotnet-ef --version 3.1.0
    dotnet tool install -g dotnet-property
    dotnet tool install -g base64urls
    dotnet tool install -g depguard
    dotnet tool install -g dmd5
    dotnet tool install -g dotnet-aspnet-codegenerator
    dotnet tool install -g dotnet-depends
}

function install_visual_studio_useful_extensions_if_not_wsl2 () {
    uname -a | grep "Microsoft"
    retVal=$?
    if [ $retVal -ne 0 ]; then
        # don't run on WSL2, but do run on git-bash and true linux/mac
        code --install-extension ajhyndman.jslint
        code --install-extension alefragnani.Bookmarks
        code --install-extension bibhasdn.unique-lines
        code --install-extension DotJoshJohnson.xml
        code --install-extension eamodio.gitlens
        code --install-extension eriklynd.json-tools
        code --install-extension jebbs.plantuml
        code --install-extension Leopotam.csharpfixformat
        code --install-extension marp-team.marp-vscode
        code --install-extension mauve.terraform
        code --install-extension mblode.pretty-formatter
        code --install-extension mindginative.terraform-snippets
        code --install-extension ms-azuretools.vscode-docker
        code --install-extension ms-vscode-remote.remote-wsl
        code --install-extension ms-vscode.csharp
        code --install-extension ms-vscode.powershell
        code --install-extension slevesque.vscode-hexdump
        code --install-extension tht13.html-preview-vscode
        code --install-extension Tyriar.sort-lines
        code --install-extension yuichinukiyama.TabSpacer
    fi
}

function install_docker_on_linux_or_wsl2 () {
    sudo apt update
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
    sudo apt update
    apt-cache policy docker-ce
    # Note: on WSL2, this will only install the docker client, as there is no init system
    # you need export DOCKER_HOST=tcp://localhost:2375 in your .bashrc or .zshrc file when running on WSL2
    # docker desktop must be running, and the option to run unsecure on port 2375 (docker options) must be selected
    sudo apt install -y docker-ce   
}

function install_git_lfs () {
    sudo apt update
    sudo apt install -y git-lfs
    git lfs install
}

# from https://github.com/tomnomnom/dotfiles/blob/master/setup.sh
function linkdotfile {
  dest="${HOME}/${1}"
  dateStr=$(date +%Y-%m-%d-%H%M)

  if [ -h ~/${1} ]; then
    # Existing symlink 
    echo "Removing existing symlink: ${dest}"
    rm ${dest} 

  elif [ -f "${dest}" ]; then
    # Existing file
    echo "Backing up existing file: ${dest}"
    mv ${dest}{,.${dateStr}}

  elif [ -d "${dest}" ]; then
    # Existing dir
    echo "Backing up existing dir: ${dest}"
    mv ${dest}{,.${dateStr}}
  fi

  echo "Creating new symlink: ${dest}"
  ln -s ${dotfilesDir}/${1} ${dest}
}

function fix_git_configuration () {
    read -p "Enter First and Last Name for git: " fullname
    read -p "Enter Email for git: " email
    git config --global user.name "$fullname"
    git config --global user.email $email
}

function copy_dotfiles () {
    cp $dotfilesdir/.gitattributes ~/.gitattributes
    cp $dotfilesdir/.gitconfig ~/.gitconfig
    cp $dotfilesdir/.zshrc ~/.zshrc
}

function create_ssh_keypair () {
    mkdir -p /home/$USER/.ssh
    sudo chown $USER:$USER /home/$USER/.ssh
    chmod 744 /home/$USER/.ssh

    ssh-keygen -t rsa -b 4096 -P "" -f /home/$USER/.ssh/id_rsa
    chmod 600 /home/$USER/.ssh/*
}

function install_docker_compose () {
    sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
}

function install_powerline_fonts () {
    git clone https://github.com/Lokaltog/powerline-fonts ./git/powerline-fonts/
    bash ./git/powerline-fonts/install.sh
}


function main () {
    uname -a | grep "MINGW"
    retVal=$?
    if [ $retVal -eq 0 ]; then
        install_visual_studio_useful_extensions
        exit
    fi
    dotfilesdir=$PWD 
    cd ~
    install_oh_my_zsh
    #install_autojump
    install_dotnet_core_sdk_31_and_21_runtime
    install_dotnet_global_tools
    install_visual_studio_useful_extensions_if_not_wsl2
    install_docker_on_linux_or_wsl2
    install_docker_compose
    install_git_lfs
    fix_git_configuration
    copy_dotfiles
    create_ssh_keypair
    sudo cp $dotfilesdir/wsl.conf /etc/wsl.conf
    cd $OLDPWD
    figlet "Reboot Windows to Use!" | lolcat
}

# Run Powershell:  Get-ItemProperty -Path Registry::HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss -Name DefaultDistribution to get the GUID
# Patch ConEmu (v191012 or newer), new task 
# Task Parameters: /dir %CD% /icon "%USERPORFILE%\appdata\Local\lxss\bash.ico"
# Commands: set "PATH=%ConEmuBaseDirShort%\wsl;%PATH%" & %ConEmuBaseDirShort%\conemu-cyg-64.exe --wsl --distro-guid={YOUR-GUID-FROM-ABOVE} -cur_console:pnm:/c -t zsh -l

main
