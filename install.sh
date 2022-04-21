#!/usr/bin/env bash
set -euo pipefail

PREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site"

### COLOR ###
ESC="\e["
RESET="${ESC}0m"
BOLD="${ESC}1m"
DIM="${ESC}2m"
UNDERSCORE="${ESC}4m"

## FORGROUND COLOR
BLACK="${ESC}30m"
RED="${ESC}31m"
GREEN="${ESC}32m"
YELLOW="${ESC}33m"
BLUE="${ESC}34m"
MAGENTA="${ESC}35m"
CYAN="${ESC}36m"
WHITE="${ESC}37m"

## BACKGROUND COLOR
ON_BLACK="${ESC}40m"
ON_RED="${ESC}41m"
ON_GREEN="${ESC}42m"
ON_YELLOW="${ESC}43m"
ON_BLUE="${ESC}44m"
ON_MAGENTA="${ESC}45m"
ON_CYAN="${ESC}46m"
ON_WHITE="${ESC}47m"

info(){
  printf "> ${RESET}$@${RESET}\n"
}

warn(){
  printf "${YELLOW}! ${RESET}$@${RESET}\n"
}

success(){
  printf "${GREEN}✓ ${RESET}$@${RESET}\n"
}

error(){
  printf "${RED}✕  $@${RESET}\n" >&2
}

confirm() {
printf "${MAGENTA}? ${RESET}$@${RESET}"
read yn < /dev/tty
case $yn in
  [Yy]|[Yy]es) return 0;;
  [Nn]|[Nn]o);;
  *) error "Invalid answer";;
esac
return 1
}

print_help(){
  printf "${CYAN}${BOLD} USAGE ${RESET}
  ${GREEN}install.sh${MAGENTA} <plugin_manager>
  ${GREEN}install.sh${MAGENTA} --prefix <runtime_path> <plugin_manager>
  ${GREEN}install.sh${MAGENTA} -f -y --prefix ~/.config/nvim minpac

${CYAN}${BOLD} OPTIONS ${RESET}
  ${MAGENTA}-h | --help   ${RESET}Show help
  ${MAGENTA}-p | --prefix ${RESET}Set prefix. See ${ON_BLACK}:h runtimepath${RESET}
  ${MAGENTA}-f | --force  ${RESET}Overwrite existing plugin manager
  ${MAGENTA}-y | --yes    ${RESET}Don't show instalation prompt

${CYAN}${BOLD} PLUGIN MANAGERS ${RESET}
  ${GREEN}dep${RESET}
    ${BOLD}About${RESET}: Correct neovim package manager
    ${BOLD}URL${RESET}  : ${BLUE}${UNDERSCORE}https://github.com/chiyadev/dep${RESET}

  ${GREEN}minpac${RESET}
    ${BOLD}About${RESET}: A minimal package manager for Vim 8 (and Neovim)
    ${BOLD}URL${RESET}  : ${BLUE}${UNDERSCORE}https://github.com/k-takata/minpac${RESET}

  ${GREEN}packer${RESET}
    ${BOLD}About${RESET}: A use-package inspired plugin manager for Neovim. Uses native packages, supports Luarocks dependencies, written in Lua, allows for expressive config 
    ${BOLD}URL${RESET}  : ${BLUE}${UNDERSCORE}https://github.com/wbthomason/packer.nvim${RESET}

  ${GREEN}paq${RESET}
    ${BOLD}About${RESET}: 🌚 Neovim package manager
    ${BOLD}URL${RESET}  : ${BLUE}${UNDERSCORE}https://github.com/savq/paq-nvim${RESET}
"
}

clone_repo() {
  git clone --quiet --depth=1 --recursive "$1" "$2"
}



if [[ "$#" -eq 0 || "$1" == "-h" || "$1" == "--help" ]]; then
  print_help
  exit 1
fi

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -p|--prefix) PREFIX="$2"; shift 2;;
    -f|--force) FORCE=1; shift;;
    -y|--yes) CONFIRM=1; shift;;
    -h|--help)  print_help;;

    -*) error "Unknown option: ${RESET}$1"; exit 1;;
    *) PM_NAME="$1"; shift;;
  esac
done



case $PM_NAME in
  dep)
    SRC="https://github.com/chiyadev/dep.git"
    DIST="deps/opt/dep"
    ;;
  minpac)
    SRC="https://github.com/k-takata/minpac.git"
    DIST="minpac/opt/minpac"
    ;;
  packer)
    SRC="https://github.com/wbthomason/packer.nvim"
    DIST="packer/opt/packer.nvim"
    ;;
  paq)
    SRC="https://github.com/savq/paq-nvim"
    DIST="paqs/opt/paq-nvim"
    ;;
  *)
    error "Unknown plugin manager: ${RESET}${PM_NAME}"; exit 1;;
esac

PACKAGE_DIR="${PREFIX}/pack"
PM_DIR="${PACKAGE_DIR}/${DIST}"

if [[ -z ${CONFIRM-} ]]; then
  info "${BOLD}From : ${RESET}${UNDERSCORE}${BLUE}${SRC}"
  info "${BOLD}To   : ${RESET}${GREEN}${PACKAGE_DIR}/${BOLD}${DIST}\n"
  confirm "Confirm installation? [${BOLD}${GREEN}y/n${RESET}]"
fi

if [[ -d $PM_DIR ]]; then
  if [[ -z ${FORCE-} ]]; then
    warn "Directory existed. Aborting this opperation"
    exit 1
  fi
fi
  # donwload
  info "Installing ${GREEN}${PM_NAME}${RESET}..."
  rm -rf $PM_DIR
  clone_repo $SRC $PM_DIR
  success "Successfully installed ${GREEN}${PM_NAME}${RESET} to ${GREEN}${PACKAGE_DIR}/${BOLD}${DIST}"
