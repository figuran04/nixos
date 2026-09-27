# NixOS + Niri + Noctalia

Flake NixOS untuk desktop **Niri** + **Noctalia v5** (desktop shell) + **Home Manager**.

> **Kunci fleksibilitas:** konfigurasi hardware **tidak pernah di-commit**.
> File `hardware-configuration.nix` selalu dibuat otomatis oleh
> `nixos-generate-config` di **tiap mesin target** (masuk `.gitignore`).
> `hardware-hp.nix` hanyalah skenario test VirtualBox — **tidak dipakai** untuk mesin asli.

Ada **dua config** di `flake.nix`:

| Config                        | Hardware                     | Dipakai untuk            |
|-------------------------------|------------------------------|--------------------------|
| `nixosConfigurations.default` | `hardware-configuration.nix` (hasil generate) | Mesin asli / device apa pun |
| `nixosConfigurations.hp`      | `hardware-hp.nix`            | Test VirtualBox          |

## Struktur singkat

```
flake.nix | flake.lock     # definisi flake (nixosConfigurations: default & hp)
configuration.nix           # setting sistem: network, pipewire, niri, greetd, dll
home.nix                    # entry Home Manager untuk user figuran04
home/*.nix                  # modul HM: niri, terminal, shell, gtk, fonts, noctalia, dll
niri/*.kdl                  # konfigurasi Niri (binds, startup, dll)
hardware-configuration.nix  # HASIL GENERATE — jangan diedit manual / di-commit
```

## Pasang NixOS di device apa pun (flexible)

Cara membawa repo ini ke mesin target bebas (clone GitHub, USB, scp/rsync, dll).
Yang penting: **config hardware dibuat otomatis di mesin itu sendiri**, bukan
menyalin `hardware-hp.nix`.

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

### 7. Pakai hardware hasil generate (bukan `hardware-hp.nix`)

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
> `configuration.nix`, bisa diganti. Config `#hp` (hardware-hp.nix)
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
nix flake lock --update-input noctalia   # sekalian input yang belum ada di lock
sudo nixos-rebuild switch --flake .#default
```

`hardware-configuration.nix` tidak akan ikut di-`git add`/`push`
(karena di-`.gitignore`), jadi tiap selesai rebuild/ubah konfigurasi
bisa langsung mengunggah/perbarui repo ke GitHub tanpa takut file
khusus mesin ikut ter-commit.