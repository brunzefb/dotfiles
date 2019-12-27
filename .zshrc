# Path to your oh-my-zsh installation.
export ZSH=/home/$USER/.oh-my-zsh
ZSH_THEME=muse  #pygmalion
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"
DISABLE_CORRECTION="true"
# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"
# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"
# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=30
export DOTNET_CLI_TELEMETRY_OPTOUT=true
# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"
# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"
# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"
# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"
# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git colorize github jira vagrant virtualenv pip python brew autojump)
# User configuration
export PATH=$PATH:$HOME/.local/bin:/home/$USER/.dotnet/tools
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:/usr/local/man:$MANPATH"
source $ZSH/oh-my-zsh.sh
export DOCKER_HOST=tcp://localhost:2375
# You may need to manually set your language environment
# export LANG=en_US.UTF-8
# Compilation flags
# export ARCHFLAGS="-arch x86_64"
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias k=kubectl
alias d=dotnet
alias del=rmtrash
alias ls='ls -la'
alias tree="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"
alias md=mkdir
SSH_ENV=$HOME/.ssh
export BOTO_CONFIG=/Users/dev/.aws/credentials
alias prettyjson='python -m json.tool'
alias listext='find . -not -iwholename "*.git*" -type f | egrep -i -E -o "\.{1}\w*$" | sort | uniq -c | sort -rn'
alias listlarge='find . -xdev -not -iwholename "*git*" -type f -size +100k -exec ls -lh {} \;'
alias listupperext='find . -xdev -not -iwholename "*.git*" -type f | egrep -o -E "\.{1}\b[A-Z]\w*\b$" | sort | uniq -c'
alias dockerrm='docker rmi $(docker images -f "dangling=true" -q) -f'
function findext() {
    str='*.'
    str2=$str$1
    find . -type f -not -iwholename "*.git*" -name "$str2" -exec ls -lh {} \;
}
function fex1 () {
    str='*.'
    str2=$str$1
    vim "`find . -type f -not -iwholename "*.git*" -name "$str2" -print | sed '1!d;q'`"
}

function display_ignore(){
	if [ -d "testignore" ]; then
	  rm -rf testignore
	fi
	mkdir testignore
	find . -not -iwholename "*.git*" -type f | egrep -i -E -o "\.{1}\w*$" | sort | uniq > extlist.txt
	while IFS='' read -r line || [[ -n "$line" ]]; do
		touch ./testignore/f$line
	done < extlist.txt
	cd testignore
	/bin/ls | git check-ignore --stdin -n --verbose
	cd ..
  rm -rf ./testignore
}

function git-checkout-pr()
{
  if ! git config -l | grep -q "remote.origin.fetch=+refs/pull-requests/\*:refs/remotes/origin/pr/\*"; then
    git config --add remote.origin.fetch +refs/pull-requests/*:refs/remotes/origin/pr/*
  fi
  git fetch --prune
  git checkout pr/$1/merge
}
export GIT_EDITOR=/usr/bin/vim
#export LS_COLORS="di=31;1:ln=36;1:ex=31;1:*~=31;1:*.html=31;1:*.shtml=37;1"
# start the ssh-agent

function start_agent {
    echo "Initializing new SSH agent..."
    # spawn ssh-agent
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add
}

if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi



autoload colors; colors;
export LS_COLORS="di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32";
LSCOLORS="ExGxFxDxCxDxDxhbhdacEc";
export NUGET_API_KEY=d5ea393b-da95-3ff4-b2cf-c44436e237e6
# Do we need Linux or BSD Style?
if ls --color -d . &>/dev/null 2>&1; then
  # Linux Style
  export LS_COLORS=$LS_COLORS
  alias ls='ls -la'
else
  # BSD Style
  export LSCOLORS=$LSCOLORS
  alias ls='ls -laG'
fi
    [[ -s /home/$USER/.autojump/etc/profile.d/autojump.sh ]] && source /home/$USER/.autojump/etc/profile.d/autojump.sh
autoload -U compinit && compinit -u
# Use same colors for autocompletion
zmodload -a colors
zmodload -a autocomplete
zmodload -a complist
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
#unsetopt BG_NICE
cd /home/$USER/git
