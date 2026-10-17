# NixOS + Niri + Quickshell

Flake NixOS untuk desktop **Niri** + **Quickshell** + **Home Manager** — arsitektur **multi-host multi-profile**.

> **Kunci fleksibilitas:** hardware config **tidak pernah di-commit**.
> File `hardware-configuration.nix` selalu dibuat otomatis oleh
> `nixos-generate-config` di **tiap mesin target** (masuk `.gitignore`).

## Host yang Tersedia

| Config | Profil NixOS | Profil Home Manager | Dipakai untuk |
|---|---|---|---|
| `#hp` | base + desktop | base + desktop | Laptop HP utama, full desktop |
| `#work` | base + desktop + **work** | base + desktop + **work** | Mode kerja, dev tools, Docker |
| `#anon` | base + desktop + **anonymous** | base + desktop + **anonymous** | Mode anonim, Tor, no logs |
| `#default` | base + desktop | base + desktop | Install baru di device apapun |

```bash
# Rebuild ke mode yang diinginkan:
sudo nixos-rebuild switch --flake .#hp      # laptop utama
sudo nixos-rebuild switch --flake .#work    # mode kerja
sudo nixos-rebuild switch --flake .#anon    # mode anonim
sudo nixos-rebuild switch --flake .#default # install generic
```

## Struktur

```
flake.nix | flake.lock       # flake: inputs (nixpkgs, HM, nix-colors), outputs, devShell
configuration.nix             # thin entry point → import ./modules/nixos
modules/nixos/
├── default.nix               # root modul → import semua sub-modul
├── nix.nix                   # daemon nix: flakes, GC, store-opt
├── boot.nix                  # systemd-boot + EFI
├── network.nix               # NM, firewall, SSH, timezone
├── audio.nix                 # PipeWire + RTKit
├── hardware.nix              # graphics, bluetooth, power, microcode
├── desktop.nix               # niri, greetd, xdg-portal, dconf
├── users.nix                 # users.users.figuran04
└── packages.nix              # environment.systemPackages minimal

home.nix                      # entry HM: colorScheme (nix-colors) + imports
home/
├── apps.nix                  # paket user (firefox, fuzzel, dll.)
├── fonts.nix                 # font + fontconfig
├── git.nix                   # git config
├── gtk.nix                   # GTK theming
├── niri.nix                  # xdg.configFile niri/*.kdl
├── quickshell.nix            # programs.quickshell
├── shell.nix                 # bash + direnv + nix-direnv + starship
└── terminal.nix              # alacritty (warna dari colorScheme)

niri/*.kdl                    # konfigurasi Niri (binds, startup, dll)
quickshell/shell.qml          # config bar Quickshell
.envrc                        # direnv: `use flake` → auto-load devShell
hardware-configuration.nix    # HASIL GENERATE — jangan diedit manual / di-commit
```

## Dev shell (edit konfigurasi ini)

Saat masuk folder ini, `direnv` otomatis load dev shell yang sudah berisi
`nixd` (LSP), `nixfmt-rfc-style`, dan `nil`:

```sh
# Pertama kali (setelah direnv aktif di shell):
direnv allow

# Manual (tanpa direnv):
nix develop
```

## Ganti tema warna

Edit satu baris di [`home.nix`](./home.nix):

```nix
colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;
# Alternatif: dracula | nord | gruvbox-dark-hard | rose-pine | everforest-dark-hard
```

Semua modul yang pakai `config.colorScheme.palette` (terminal, dll.)
otomatis ikut berubah setelah `home-manager switch`.

Daftar skema: <https://github.com/tinted-theming/schemes>

## Pasang NixOS di device apa pun (flexible)

Cara membawa repo ini ke mesin target bebas (clone GitHub, USB, scp/rsync, dll).
Yang penting: **config hardware dibuat otomatis di mesin itu sendiri**, bukan
menyalin `hardware-configuration.nix`.

### 1. Boot ISO NixOS → masuk ke terminal install

### 2. Kenali & partisi disk

```sh
lsblk                                   # cari device, mis. /dev/sda atau /dev/nvme0n1
cfdisk /dev/sdX                         # ganti sdX sesuai hasil lsblk; pilih "gpt"
# Buat partisi (contoh ukuran, bebas disesuaikan):
#   1G   -> tipe "EFI System"        (sdX1)
#   4G   -> tipe "Linux swap"        (sdX2)
#   sisa -> tipe "Linux filesystem"  (sdX3)
```

Boleh pakai `fdisk` / `parted` — terserah.

### 3. Format

```sh
mkfs.fat -F 32 -n boot /dev/sdX1
mkswap -L swap /dev/sdX2
mkfs.ext4 -L nixos /dev/sdX3
```

### 4. Mount

```sh
mount /dev/sdX3 /mnt
mount --mkdir /dev/sdX1 /mnt/boot
swapon /dev/sdX2
```

### 5. Generate config hardware (KUNCI — otomatis per device)

```sh
nixos-generate-config --root /mnt
# -> menghasilkan /mnt/etc/nixos/hardware-configuration.nix sesuai mesin ini
cp /mnt/etc/nixos/hardware-configuration.nix /root/   # backup sementara
```

### 6. Bawa repo flake ini ke target (pilih salah satu, bebas)

- **A. Git clone** (jika repo sudah ada di GitHub):
  ```sh
  git clone <URL-repo-kamu> /mnt/nixos
  ```
- **B. USB / media lain**: salin folder repo (tanpa `.git` pun boleh) ke `/mnt/nixos/`.
- **C. Dari mesin lain**: `rsync -a <folder-repo>/ user@target:/mnt/nixos/` atau `scp`.

> Repo ini **tidak berisi** `hardware-configuration.nix` (file itu di-`gitignore`),
> padahal `flake.nix` wajib import-nya — maka langkah 7 tetap wajib.
> Tidak ada yang perlu dihapus: direktori target (`/mnt/nixos`) sengaja
> terpisah dari hasil generate `/mnt/etc/nixos`.

### 7. Pakai hardware hasil generate (bukan `hardware-configuration.nix`)

```sh
cp /root/hardware-configuration.nix /mnt/nixos/hardware-configuration.nix
```

### 8. (Opsional) Set password user

```sh
nixos-enter --root /mnt -c 'passwd figuran04'
```

### 9. Install

```sh
nixos-install --root /mnt --flake /mnt/nixos#default
```

> `--flake <path>#<nama>`: path lokal tanpa git pun bisa dievaluasi.
> Di sini memakai config **`default`** karena hardware-configuration.nix
> dipakai hasil generate tiap mesin. User `figuran04` diatur di
> `configuration.nix`, bisa diganti. Config `#hp` (hardware-configuration.nix)
> khusus skenario test VirtualBox.

### 10. Reboot

```sh
reboot
```

## Setelah boot: setup repo & rebuild

```sh
git clone <URL-repo-kamu> ~/nixos
cp /root/hardware-configuration.nix ~/nixos/  # backup langkah 5 masih di /root
cd ~/nixos
nix flake lock   # update lock file jika input berubah
sudo nixos-rebuild switch --flake .#default
```

`hardware-configuration.nix` tidak akan ikut di-`git add`/`push`
(karena di-`.gitignore`), jadi tiap selesai rebuild/ubah konfigurasi
bisa langsung mengunggah/perbarui repo ke GitHub tanpa takut file
khusus mesin ikut ter-commit.