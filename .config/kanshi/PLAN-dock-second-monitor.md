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

### Findings 2026-11-17

- Applied Step 2, then rebooted with the dock attached: second Dell missing
  (DP-7 disconnected). No TB debug output, so the cause is unknown.
- Replugged the dock with debug enabled: both Dells came up. Both tunnels
  logged `DPRX read timeout`, then `DPRX capabilities read completed`. The
  second one came up ~2 s later; kanshi went single-monitor → `homeoffice`.
- Suspected: tunnels set up by the BIOS before boot don't survive the
  handover. Unconfirmed.
- Enabled persistent debug logging to catch the next bad boot:
  `options thunderbolt dprx_timeout=-1 dyndbg=+p`

After the next bad boot:

```sh
journalctl -b -k | grep -E 'thunderbolt.*(DP|DPRX|tunnel|tearing)'
```

Workaround: replug the dock.

### Findings 2026-11-17, bad boot with debug logging

- No tunnels inherited from the BIOS, so that suspicion is ruled out.
- Race at boot: both DP OUT adapters (2:13, 2:14) hotplug in the same
  second. The second tunnel is set up while the first is still waiting for
  DPRX, so the first one reserves its full 25920 Mb/s:
  ```
  0:7 <-> 2:13 (DP): activating
  available bandwidth for new DP tunnel 34650/8730 Mb/s
  0:6 <-> 2:14 (DP): bandwidth reduced to 2700 Mb/s x4 = 8640 Mb/s
  0:7 <-> 2:13 (DP): DPRX capabilities read completed
  ```
  2:13 then completes, but 2:14 stays at HBR and never gets past
  `DPRX read timeout` (it loops forever with `dprx_timeout=-1`).
- Good case (replug, boot -1): 2:13 completes first, 2:14 activates ~2 s
  later with 34650/17370 available, is reduced to only 5400 Mb/s x4 =
  17280 Mb/s, and works.
- So `dprx_timeout=-1` doesn't help: the tunnel is broken from the start
  because of the reduced bandwidth, not because it times out too early.

Next: Step 4.1 (`bw_alloc_mode=0`) and see if the reduction changes.

### Findings 2026-11-17, workarounds

- Tried a boot service that resets the TB controller (unbind/bind) when a
  Dell is missing. Dropped: the reset reproduces the race every time. Both
  tunnels activate at once, 2:14 is reduced to HBR, and both Dells only
  offer modes up to 1920x1080 afterwards.
- Power-cycling the Dells one after the other at the power button works:
  each tunnel is torn down and recreated with the other one already settled
  (33354 and 17370 Mb/s available), and both come back at 3840x2160@60.
- DDC can't replace the power button (`ddcutil` installed for this). Neither
  power off (`setvcp D6 04`) nor switching the input (`setvcp 60`) on one
  Dell makes the dock drop its tunnel; the connector stays `connected`.

### Findings 2026-11-17, `bw_alloc_mode=0`

- Set `options thunderbolt dprx_timeout=-1 bw_alloc_mode=0 dyndbg=+p` and
  rebooted with the dock attached.
- The race still happens: 2:14 activates with 34650/8730 Mb/s available and
  is reduced to 2700 Mb/s x4 = 8640 Mb/s.
- But this time 2:14 gets past its `DPRX read timeout`s, logs
  `DPRX capabilities read completed`, and both Dells run at 3840x2160@60.
- Only one boot so far. Keep testing as in Step 3 before calling it fixed.

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
