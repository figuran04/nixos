# hosts/anon/default.nix
# Host mode anonymous — minimal tweak sistem.
{ ... }:
{
  # Tidak ada hostname yang identifiable (sudah di-set di anonymous.nix)
  # Matikan swap: jangan tulis RAM ke disk
  swapDevices = [];

  # Hapus semua file temp saat boot
  boot.cleanTmpDir = true;
}
