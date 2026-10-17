# modules/nixos/audio.nix
# Audio: PipeWire + RTKit untuk low-latency audio.
{ ... }:
{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;   # PulseAudio compat layer (untuk app lama)
    alsa = {
      enable = true;
      support32Bit = true; # ALSA 32-bit untuk Wine / Steam
    };
  };
}
