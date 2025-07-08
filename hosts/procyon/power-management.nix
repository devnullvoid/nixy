# Power management configuration for procyon laptop
# Prevents suspend when on AC power while maintaining power efficiency
{ pkgs, lib, ... }:

{
  # Enhanced power management
  powerManagement = {
    enable = true;
    # Don't suspend when on AC power
    cpuFreqGovernor = lib.mkDefault "powersave";
  };

  # power-profiles-daemon is already enabled in utils.nix
  # services.power-profiles-daemon.enable = true;
  
  # TLP is more comprehensive but conflicts with power-profiles-daemon
  # services.tlp.enable = false;

  # Logind configuration for power button and lid switch behavior
  # Extend the existing configuration from utils.nix
  services.logind.extraConfig = lib.mkAfter ''
    # Lid switch behavior
    HandleLidSwitch=suspend
    HandleLidSwitchExternalPower=ignore
    HandleLidSwitchDocked=ignore
    IdleAction=ignore
    IdleActionSec=0
  '';

  # Systemd sleep configuration
  systemd.sleep.extraConfig = ''
    # Prevent system from suspending when on AC power
    # This is handled by our smart-suspend script in hypridle
    AllowSuspend=yes
    AllowHibernation=no
    AllowSuspendThenHibernate=no
    AllowHybridSleep=no
  '';

  # CPU frequency scaling
  boot.kernelModules = [ "cpufreq_ondemand" "cpufreq_powersave" ];
  
  # Additional power management tools
  environment.systemPackages = with pkgs; [
    powertop      # Power consumption analysis
    acpi          # ACPI information
    lm_sensors    # Hardware monitoring
  ];

  # Optimize for laptop usage
  boot.kernelParams = [
    # Enable power saving features
    "pcie_aspm=force"
    "i915.enable_fbc=1"
    "i915.enable_psr=1"
    "i915.enable_rc6=1"
  ];

  # Hardware configuration for power management
  hardware = {
    # Enable firmware updates
    enableRedistributableFirmware = true;
    
    # CPU microcode updates
    cpu.intel.updateMicrocode = true;
  };

  # Thermald for thermal management
  services.thermald.enable = true;
} 