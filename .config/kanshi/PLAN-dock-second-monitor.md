# Plan: second monitor missing on dock connect

## Problem

Sometimes only one of the two Dell U2720Q shows up when connecting the
ThinkPad T14 (AMD Krackan, kernel 7.3.x) to the Ugreen TB4 dock.

kanshi is not at fault: it only ever sees one Dell and correctly applies
`laptop-thinkpad-t14-homeoffice-single-monitor-{left,right}`.

Root cause is in the kernel's Thunderbolt DP tunneling. The second DP tunnel
is torn down because the monitor doesn't answer within the DPRX timeout
(default 12 s):

```
thunderbolt 0000:c5:00.6: 0:7 <-> 2:14 (DP): not active, tearing down
```

Observed 2026-11-17, 20:58–21:00 (boot -1). A reboot fixed it.

## Step 1: confirm while it happens

```sh
journalctl -k -f | grep -iE 'tearing down|DPRX|tunnel'
```

Connect the dock. If a `not active, tearing down` line appears together with
a single-monitor kanshi profile, it's this issue.

## Step 2: disable the DPRX timeout

```sh
echo 'options thunderbolt dprx_timeout=-1' | sudo tee /etc/modprobe.d/thunderbolt.conf
```

`thunderbolt` is not in the initramfs (`MODULES=(amdgpu)`), so a reboot is
enough. To be safe anyway: `sudo mkinitcpio -P`.

Verify after reboot:

```sh
cat /sys/module/thunderbolt/parameters/dprx_timeout   # expect -1
```

### Drawbacks

- A tunnel that never comes up keeps its reserved TB bandwidth and DP IN
  adapter until the dock or monitor is unplugged (negligible here).
- Doesn't help if the link really fails. Then the kernel waits forever
  instead of giving up, and the monitor is still missing.
- The second monitor may come up late. kanshi then applies a single-monitor
  profile first and switches to `homeoffice` afterwards.

## Step 3: evaluate

Connect and disconnect the dock several times over a few days, including
after the monitors have been in standby for a while (the likely trigger).

- Both monitors show up every time: keep it, and consider tracking
  `/etc/modprobe.d/thunderbolt.conf` in the dotfiles.
- Monitor still missing: run Step 1 again and check whether the tunnel now
  hangs instead of being torn down. Then go to Step 4.

## Step 4: fallbacks

1. Disable bandwidth allocation mode as well:
   `options thunderbolt dprx_timeout=-1 bw_alloc_mode=0`
2. Update the dock firmware: `fwupdmgr refresh && fwupdmgr get-updates`
3. Try the other USB-C port and a different/shorter TB cable.

## Workaround when it happens

Power-cycle the missing Dell, or replug the dock and wait about 15 s.

## Rollback

```sh
sudo rm /etc/modprobe.d/thunderbolt.conf
# if mkinitcpio was run in step 2:
sudo mkinitcpio -P
```

Then reboot.
