# Shared helpers for fetch-totem and flash-totem. Source it, don't run it.
# shellcheck shell=bash disable=SC2034  # constants are used by the scripts

TOTEM_REPO=draptik/zmk-config-totem
TOTEM_WORKFLOW=build.yml
TOTEM_ARTIFACT=firmware
TOTEM_DEVICES=(dongle left right settings_reset)
TOTEM_LABEL=XIAO-SENSE
TOTEM_BOARD_ID=Seeed_XIAO_nRF52840_Sense

# UF2 constants (https://github.com/microsoft/uf2), as unsigned decimals.
UF2_MAGIC_START0=171066965   # 0x0A324655
UF2_MAGIC_START1=2656915799  # 0x9E5D5157
UF2_MAGIC_END=179400496      # 0x0AB16F30
UF2_FAMILY_NRF52840=2913282112 # 0xADA52840

die() { printf 'error: %s\n' "$*" >&2; exit 1; }
warn() { printf 'warning: %s\n' "$*" >&2; }
info() { printf '%s\n' "$*"; }

# confirm "question" [default y|n] -> 0 for yes
confirm() {
  local answer hint='[y/N]'
  [ "${2:-n}" = y ] && hint='[Y/n]'
  read -rp "$1 $hint " answer || return 1
  answer="${answer:-${2:-n}}"
  [[ "$answer" =~ ^[Yy]([Ee][Ss])?$ ]]
}

# pick "prompt" ITEM... -> prints the chosen item; Enter picks the first one.
pick() {
  local prompt="$1" i reply
  shift
  i=1
  for item in "$@"; do printf '  %2d) %s\n' "$i" "$item" >&2; i=$((i + 1)); done
  while :; do
    read -rp "$prompt [1]: " reply </dev/tty || return 1
    reply="${reply:-1}"
    if [[ "$reply" =~ ^[0-9]+$ ]] && (( reply >= 1 && reply <= $# )); then
      printf '%s\n' "${!reply}"
      return 0
    fi
    warn "enter a number from 1 to $#"
  done
}

# Check that a file is a well-formed UF2 image for the nRF52840.
check_uf2() {
  local f="$1" size blocks
  [ -f "$f" ] && [ ! -L "$f" ] || { warn "$f: not a regular file"; return 1; }
  size="$(stat -c %s -- "$f")"
  if (( size == 0 || size % 512 != 0 )); then
    warn "$f: size $size is not a multiple of 512"
    return 1
  fi
  blocks=$(( size / 512 ))
  # One line per 512-byte block, 128 little-endian uint32 fields.
  od -An -v -tu4 -w512 -- "$f" | awk \
    -v n="$blocks" -v m0="$UF2_MAGIC_START0" -v m1="$UF2_MAGIC_START1" \
    -v me="$UF2_MAGIC_END" -v fam="$UF2_FAMILY_NRF52840" '
    $1 != m0 || $2 != m1 || $128 != me { print "bad magic in block " NR-1; bad=1; exit 1 }
    int($3 / 8192) % 2 != 1 || $8 != fam { print "not an nRF52840 image (block " NR-1 ")"; bad=1; exit 1 }
    $5 > 476 || $6 != NR-1 || $7 != n { print "inconsistent block numbering (block " NR-1 ")"; bad=1; exit 1 }
    END { if (!bad && NR != n) { print "truncated"; exit 1 } }
  ' >&2 || { warn "$f: invalid UF2"; return 1; }
}

# Verify a firmware folder: checksums (if recorded) and UF2 structure.
verify_folder() {
  local dir="$1" f
  if [ -f "$dir/SHA256SUMS" ]; then
    (cd "$dir" && sha256sum --quiet --strict -c SHA256SUMS) \
      || die "checksum mismatch in $(basename "$dir") - files changed since download"
  else
    warn "$(basename "$dir") has no SHA256SUMS (not fetched with fetch-totem), integrity can't be checked"
    confirm "Continue anyway?" || exit 1
  fi
  for f in "$dir"/*.uf2; do check_uf2 "$f" || die "refusing to use $(basename "$dir")"; done
}
