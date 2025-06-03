{ config, pkgs, ... }:

{
	imports = [ # Include the results of the hardware scan.
		./hardware-configuration.nix
	];

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	# broadcom-wl
	# nixos-generate-config doesn't detect this automatically.
	boot.extraModulePackages = with config.boot.kernelPackages; [ broadcom_sta ];
	boot.kernelModules = [ "wl" ];

	networking.hostName = "colossus"; # Define your hostname.

	# { nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
	# 	"1password"
	# ];}

	programs = {
		# NixOS has built-in modules to enable 1Password
		# along with some pre-packaged configuration to make
		# it work nicely. You can search what options exist
		# in NixOS at https://search.nixos.org/options
	
		# Enables the 1Password CLI
		_1password = { enable = true; };
	
		# Enables the 1Password desktop app
		_1password-gui = {
			enable = true;
			# this makes system auth etc. work properly
			polkitPolicyOwners = [ "emi" ];
		};
	};

	# services.your-service = {
	#      enable = true;
	#      extraEnv = lib.mkForce {
	#      HOME_WIFI_SSID = "op read op://Personale/home_wifi/SSID -n";
	#      HOME_WIFI_PASSWORD = "op read op://Personale/home_wifi/ssid_password -n";
	#     };
	#  };
	
	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
	
	# Enable networking
	# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
	networking.networkmanager.enable = true;
	networking.networkmanager.wifi.powersave = false;
	networking.networkmanager.ensureProfiles.profiles = {
		home-wifi = {
			connection = {
				id = "home-wifi";
				permissions = "";
				type = "wifi";
			};
			ipv4 = {
				dns-search = "";
				method = "auto";
			};
			ipv6 = {
				addr-gen-mode = "stable-privacy";
				dns-search = "";
				method = "auto";
			};
			wifi = {
				mac-address-blacklist = "";
				mode = "infrastructure";
				ssid = "$HOME_WIFI_SSID";
			};
			wifi-security = {
				auth-alg = "open";
				key-mgmt = "wpa-psk";
				psk = "$HOME_WIFI_PASSWORD";
			};
		};
	};

	# Set your time zone.
	time.timeZone = "Europe/Rome";

	# Select internationalisation properties.
	i18n.defaultLocale = "it_IT.UTF-8";

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "it_IT.UTF-8";
		LC_IDENTIFICATION = "it_IT.UTF-8";
		LC_MEASUREMENT = "it_IT.UTF-8";
		LC_MONETARY = "it_IT.UTF-8";
		LC_NAME = "it_IT.UTF-8";
		LC_NUMERIC = "it_IT.UTF-8";
		LC_PAPER = "it_IT.UTF-8";
		LC_TELEPHONE = "it_IT.UTF-8";
		LC_TIME = "it_IT.UTF-8";
	};

	services = {
		# Enable the X11 windowing system.
		# You can disable this if you're only using the Wayland session.
		xserver.enable = true;
		# Enable touchpad support (enabled default in most desktopManager).
		libinput.enable = true;
		# Configure keymap in X11
		xserver.xkb = {
			layout = "it";
			variant = "us";
		};

		# Enable the KDE Plasma Desktop Environment.
		displayManager = {
			sddm.enable = true;
			autoLogin.enable = true;
			autoLogin.user = "emi";
			# use the example session manager (no others are packaged yet so this is enabled by default,
			# no need to redefine it in your config for now)
			#media-session.enable = true;
		};

		desktopManager = {
			plasma6.enable = true;
		};

		# Enable CUPS to print documents.
		printing.enable = true;
		pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
			# If you want to use JACK applications, uncomment this
			#jack.enable = true;
		};

		pulseaudio.enable = false;

		# Enable the OpenSSH daemon.
		openssh = {
			enable = true;
			settings = {
				X11Forwarding = true;
				PermitRootLogin = "no";
				PasswordAuthentication = false;
			};
			openFirewall = true;
		};

	# Configure console keymap
	console.keyMap = "it2";

	hardware = {
		logitech.wireless.enable = true;
		logitech.wireless.enableGraphical = true;
		enableRedistributableFirmware = true;
	};

	security.rtkit.enable = true;

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.emi = {
		isNormalUser = true;
		description = "emiliano";
		extraGroups = [ "networkmanager" "wheel" ];
		hashedPassword = "$y$j9T$DToYNAF.Wf1uimfvlvg1b0$jVlLRQezl8rDeL.8I8dw5snfXIBoVVKWo5/hUdoKLr/";
		openssh.authorizedKeys.keys = [
			"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCejOsX2ccn0SZW7k4h3hU3z1I8e8gUEzenH9C2XXRIrhNgSykATcVWwRIONdj6Gwh5/EzoYlD/ZSSCIdnOmEebkmvRlpUau9K/IRJf3jnjNQxkdNb3QaRARuVMLPixT0BXR+/lj1UhVFCcIPKYraAb8mjgX+Q4cPvVtgqC+ybE0wg13PxScToMgPQeiB+hUE/8HHBadKsGJ4DMbF6/C3JBwUId9QrNgGB9BWw/hspQQ+SRM0uBBZzSlGGSOEIPQqTI5okGKSV7aS9L+WLHYxmSGv5SQ7921bMTWGYTszUrmErNqH+hyqCDW1aWv0bgvWM1rVWj5vCn8dfs3gPYfeMf"]
		shell = pkgs.fish;
		packages = with pkgs; [
			neovim
		];
	};

	programs = {
		# Some programs need SUID wrappers, can be configured further or are
		# started in user sessions.
		mtr.enable = true;
		gnupg.agent = {
			enable = true;
			enableSSHSupport = true;
		};
	};
	

	# List packages installed in system profile. To search, run:
	# $ nix search wget

	environment.systemPackages = with pkgs; [
		neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
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
		(discord.override {
			withOpenASAR = true;
			withVencord = true;
		})
	];
	environment.shells = with pkgs; [ zsh fish ];
	programs.fish.enable = true;
	programs.neovim.defaultEditor = true;

	# List services that you want to enable:
	
	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;
	
	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "24.11"; # Did you read the comment?

	nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
