{ config, pkgs, ... }:

{
  # imports = [
  # ];
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "emi";
  home.homeDirectory = "/home/emi";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    neovim
    wget
    curl
    git
    hurl
    fzf
    fd
    ripgrep
    sd
    pinentry
    jq
    docker
    wezterm
    pandoc
    zip
    unzip
    nix-output-monitor
    glow
    btop
    iotop
    iftop
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    tree
    bat
    delta
    (pkgs.writeShellScriptBin "my-hello" ''
       echo "Hello, ${config.home.username}!"
    '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/emi/etc/profile.d/hm-session-vars.sh
  #
  #nix = {
  #	package = pkgs.nix;
  #      settings.experimental-features = [ "nix-command" "flakes" ];
  #};
  
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs = {
  	fish = {
		enable = true;
	};
	firefox.enable = true;
	wezterm = {
		enable = true;
		extraConfig = ''
			return {
				color_scheme = 'tokyonight_night',
				font = wezterm.font("JetBrains Mono"),
				     font_size = 16.0,
				     color_scheme = "Tokyonight Dark",
				     hide_tab_bar_if_only_one_tab = true,
				     keys = {
					     {key="n", mods="SHIFT|CTRL", action="ToggleFullScreen"},
				     }
			}
		'';
	};
  }; 

  # home.file.".config/fish/config.fish".source = ./fishconfig/config.fish;  
  # home.file.".config/wezterm/wezterm.lua".source = ./wezconfig/wezterm.lua;
  # home.file.".config/nvim/init.lua".source = ./vimconfig/init.lua;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
