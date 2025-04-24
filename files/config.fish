# if we haven't sourced the login config, do it
status --is-login; and not set -q __fish_login_config_sourced
and begin

  set --prepend fish_function_path /gnu/store/7fv7hxfqzyan1va5ypa3wwjdcnpcik6b-fish-foreign-env-0.20230823/share/fish/functions
  fenv source $HOME/.profile
  set -e fish_function_path[1]

  set -g __fish_login_config_sourced 1

end
set GUIX_PROFILE "/home/ndowens/.guix-profile"
source "$GUIX_PROFILE/etc/profile"

export PATH="$PATH:/home/ndowens/.guix-profile/bin:/home/ndowens/.guix-profile/sbin:$PATH"

