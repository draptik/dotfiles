# Projecteur - using Logitech Spotlight with Linux

- Homepage: [https://github.com/jahnf/Projecteur](https://github.com/jahnf/Projecteur)

## Installation

### Arch linux

- Homepage: [https://aur.archlinux.org/packages/projecteur-git/](https://aur.archlinux.org/packages/projecteur-git/)

- `yay -S projecteur-git`

## Configuration

- Example: see `projecteur.config`.

## Usage

- `projecteur --cfg ~/.dotfiles/projecteur-logitech-spotlight/projecteur.config`
- add to `~/.bash_aliases`...

## Troubleshooting

Check if device is detected: `/usr/bin/prjecteur -d` scans devices. Should look something like
this:

```sh
$ /usr/bin/projecteur -d
Projecteur 0.7-alpha.9; device scan

 * Found 1 supported devices. (1 readable, 1 writable)

 +++ name:     'Logitech USB Receiver Mouse'
     vendorId:  046d
     productId: c53e
     phys:      usb-0000:00:14.0-6/input1
     busType:   USB
     device:    /dev/input/event19
     readable:  true
     writable:  true
```

