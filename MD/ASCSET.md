# `ascset` options — descriptions + PowerShell examples

**Important safety notes**

* `ascset` touches hardware. Use `help` first. Prefer read-only queries before writes.
* For destructive operations (`reboot`, `hash-sn-write`, `password`, `fac*`) ensure you have SSH/console access and a fallback plan.
* Use small increments for `fan`, `frequency`, `voltage` and monitor temps via `devs`/`devdetails`.

All examples assume you have `$MinerIP` set to the miner IP and ASC id `0`. Adjust as needed.

Clean list of all the `ascset` (device) subcommands that this driver implements (taken from the `device_cmds` table in `driver-avalon.c`):

* `help` — show available device commands
* `voltage` — set/query PSU voltage
* `fan-spd` — set fan speed (or `-1` for auto)
* `ledmode` — set LED mode (day/dark)
* `ledset` — set day-mode LED parameters (effect/brightness/temperature/R,G,B)
* `lcd` — control LCD (id:value)
* `nightlamp` — set night-lamp mode/duration
* `wallpaper` — upload/set LCD wallpaper (png/gif/none)
* `hash-sn-read` — read a miner/hashboard serial number
* `volt-adjust-switch` — enable/disable auto voltage tuning
* `workmode` — get/set work mode
* `worklevel` — get/set work level
* `work_mode_lvl` — set both work mode and level together
* `reboot` — schedule reboot (delay)
* `filter-clean` — trigger filter cleaning
* `facopts` — factory options (query/update prod/model)
* `faclock` — factory lock/unlock
* `frequency` — set ASIC frequency (format: freq[-addr[-miner]] etc.)
* `loop` — report ASIC loop/count info
* `password` — change web UI password
* `qr_auth` — QR-login authentication


---

### `ledmode`

**What it does:** SET-only: change LED mode (handler `set_avalon_ledmode`). Expects a single numeric value parsed as `%hhu`. The code accepts only two mode constants (`LED_MODE_DAY` or `LED_MODE_DARK`) — those constants are defined elsewhere in the build; this handler does not implement a textual `get` path.

```powershell
# GET EXAMPLE

# Not available via this handler — readback of current led mode is available only from device status APIs, not via this ascset handler.

# SET EXAMPLE

#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,ledmode,1'
#$ApiObject | ConvertTo-Json -Depth 100
#$ApiObject.STATUS.Msg

# NOTE: valid numeric values correspond to LED_MODE_DAY / LED_MODE_DARK (constants defined elsewhere).
```

---

### `ledset`  (day-mode LED settings)

**What it does:** SET-only (`set_avalon_device_ledday`). Applies LED parameters for *day* mode. Requires device to already be in day mode (`info->ledmode == LED_MODE_DAY`). Parameters: `effect-bright-temper-R-G-B` (six integers; code parses `%d-%d-%d-%d-%d-%d`).

```powershell
# GET EXAMPLE

# Not available via this handler; this is a set-only operation (applies only in day mode).

# SET EXAMPLE

#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,ledset,2-80-50-255-128-64'
#$ApiObject | ConvertTo-Json -Depth 100
#$ApiObject.STATUS.Msg

# NOTE: first value (effect) must be <= LED_COLORCYCLE (constant defined elsewhere).
```

---

### `lcd`

**What it does:** SET-only (`set_avalon_device_lcd`). Sends LCD control data. Expects two short integers separated by `:` (`%hd:%hd`). No GET via this handler.

```powershell
# GET EXAMPLE

# Not available — this handler only sends LCD commands.

# SET EXAMPLE

#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,lcd,1:2'
#$ApiObject | ConvertTo-Json -Depth 100
#$ApiObject.STATUS.Msg

# replybuf will contain "success lcd:id[val] val[val]" on success.
```

---

### `nightlamp`

**What it does:** SET-only (`set_avalon_nightlamp`). Night lamp mode/duration for *dark* (night) LED mode. Expects `%hhu-%hu` (mode[0|1]-duration). Requires `info->ledmode == LED_MODE_DARK`.

```powershell
# GET EXAMPLE

# Not available — set-only handler.

# SET EXAMPLE

#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,nightlamp,1-30'
#$ApiObject | ConvertTo-Json -Depth 100
#$ApiObject.STATUS.Msg
```

---

### `wallpaper`

**What it does:** SET-only via `set_avalon_device_wallpaper` — upload or clear an LCD wallpaper. Format passed to the handler: `mode,hex_payload` where `mode` is `png` / `gif` / `none` and `hex_payload` is the encoded package (header+payload) expected by `wallpaper_update`. The handler requires a `,` after the mode (even for `none`). If `mode == none` the handler clears wallpaper.

```powershell
# GET EXAMPLE

# Not available — wallpaper is updated/cleared only via this SET-style API.

# SET EXAMPLE (clear wallpaper)
#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,wallpaper,none,0'
#$ApiObject | ConvertTo-Json -Depth 100
#$ApiObject.STATUS.Msg

# SET EXAMPLE (upload — payload must be the hex-encoded header+data per wallpaper_update)
# NOTE: payload can be large (max about 100K per your driver logic); this is a simplified placeholder
#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,wallpaper,png,<hex_header_plus_payload>'
#$ApiObject | ConvertTo-Json -Depth 100
#$ApiObject.STATUS.Msg
```

---

### `hash-sn-read`

**What it does:** GET-only (`hash_sn_read`). Reads the serial number for a miner/hashboard index. Requires a single numeric argument (hash index). Returns a string `Hash-<n> SN:<serial>`.

```powershell
# GET EXAMPLE

$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,hash-sn-read,0'
#$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg

# SET EXAMPLE

# Not available — this handler only reads SN (no set).
```

---

### `volt-adjust-switch`

**What it does:** SET-only (`set_avalon_volt_adjust_switch`). Enables/disables automatic voltage tuning. Expects two values separated by `-`: `val-addr`. `val` must equal `AVA_VOLT_ADJ_SWITCH_OFF` or `AVA_VOLT_ADJ_SWITCH_ON` (constants defined elsewhere). `addr` is modular index (0..AVALON_DEFAULT_MODULARS-1).

```powershell
# GET EXAMPLE

# Not available — handler only accepts set requests.

# SET EXAMPLE

#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,volt-adjust-switch,1-0'
#$ApiObject | ConvertTo-Json -Depth 100
#$ApiObject.STATUS.Msg

# NOTE: numeric values for ON/OFF are constants (AVA_VOLT_ADJ_SWITCH_ON/OFF) defined in headers.
```

---

### `workmode`

**What it does:** GET/SET (`set_avalon_device_workmode`). Use textual `get`/`set` sub-commands in the handler parameters.

* GET: `get` (returns `workmode <value>`).
* SET: `set,<mode>` where `mode` must be `<= info->maxmode[0]` and device must not be in calibration.

```powershell
# GET EXAMPLE

$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,workmode,get'
#$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg

# SET EXAMPLE

#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,workmode,set,2'
#$ApiObject | ConvertTo-Json -Depth 100
#$ApiObject.STATUS.Msg

# NOTE: the handler rejects changes if calibration (aging) is not finished or mode > maxmode.
```

---

### `worklevel`

**What it does:** GET/SET (`set_avalon_device_worklevel`). Format: `get` or `set,<level>`. `level` must be within bounds encoded in `info->worklvl[0]`.

```powershell
# GET EXAMPLE

$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,worklevel,get'
#$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg

# SET EXAMPLE

#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,worklevel,set,3'
#$ApiObject | ConvertTo-Json -Depth 100
#$ApiObject.STATUS.Msg

# NOTE: changes are refused while calibration (aging) is running.
```

---

### `work_mode_lvl`

**What it does:** GET/SET combined (`set_avalon_work_mode_lvl`). Format:

* `get` → returns both current mode and level.
* `set,<mode>,<level>` → set both simultaneously (with validation and calibration checks).

```powershell
# GET EXAMPLE

$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,work_mode_lvl,get'
#$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg

# SET EXAMPLE

#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,work_mode_lvl,set,1,2'
#$ApiObject | ConvertTo-Json -Depth 100
#$ApiObject.STATUS.Msg
```

### `facopts`

**What it does:** GET/SET (`set_avalon_facopts`):

* Query: `mode == 255 (FACTCFG_QUERY)` → returns factory options summary (`FACOPTS_LK[...] WORKMODE[...]`). Use a single integer `255`.
* Update: allowed when factory config is unlocked and `mode == 101 (FACTCFG_OTHERS_SET_PROD)` or `105 (FACTCFG_OTHERS_SET_MODEL)` with a trailing string payload to set product or model.

```powershell
# GET EXAMPLE (query)
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,facopts,255'
#$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg

# SET EXAMPLE (set product)
#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,facopts,101,NewProductID'
#$ApiObject | ConvertTo-Json -Depth 100
#$ApiObject.STATUS.Msg

# SET EXAMPLE (set model)
#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,facopts,105,NewModelID'
#$ApiObject | ConvertTo-Json -Depth 100
#$ApiObject.STATUS.Msg

# NOTE: updates require factory unlock (faccfg_is_locked() == false).
```

---

### `faclock`

**What it does:** SET-style lock/unlock (`set_avalon_faclock`). If argument is the literal `"lock"` it locks; to unlock you must supply the unlock key computed from device DNA (driver computes CRC32 of `info->dna[0]` and accepts that hex string). The handler writes the current lock state into reply (so you get state feedback). There is no separate `get` command; use the command to change state or to read the status printed in the reply.

```powershell
# GET EXAMPLE

# There is no dedicated GET; the handler returns "Lock: True/False" after any call.
# A harmless way to read status is to call with the CRC that does not match,
# but the handler always returns the "Lock: ..." reply. However, there's no 'get' token.

# SET EXAMPLE (lock)
#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,faclock,lock'
#$ApiObject | ConvertTo-Json -Depth 100
#$ApiObject.STATUS.Msg

# SET EXAMPLE (unlock) — device-specific key:
# The unlock token expected is the CRC32-based hex of info->dna[0].
# Example placeholder (replace with actual CRC from your device DNA):
#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,faclock,0123abcd'
#$ApiObject | ConvertTo-Json -Depth 100
#$ApiObject.STATUS.Msg
```

---

### `frequency`

**What it does:** SET-only (`set_avalon_device_freq`). Changes ASIC PLL frequencies. Handler expects four PLL values separated by `:` followed by optional `-addr-miner-asic` triplet:
`val0:val1:val2:val3-addr-miner_id-asic_id`

* `addr==0` means *all modulars* (the code treats zero as "all").
* `miner_id==0` means *all miners* for the module.
* `asic_id==0` is treated as broadcast (all asics).
  This handler does not implement a `get`.

```powershell
# GET EXAMPLE

# Not available — frequency is set-only through this handler.

# SET EXAMPLE (set all modules/miners/asics to 450 MHz)
#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,frequency,450:450:450:450-0-0-0'
#$ApiObject | ConvertTo-Json -Depth 100
#$ApiObject.STATUS.Msg

# SET EXAMPLE (set miner 1 on module 0 asic broadcast)
#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,frequency,500:500:500:500-0-1-0'
#$ApiObject | ConvertTo-Json -Depth 100
#$ApiObject.STATUS.Msg
```

---

### `loop`

**What it does:** GET-only status helper (`set_avalon_device_loop`). It composes a reply listing `asic_count` values for the first module (no setting). Handler ignores input.

```powershell
# GET EXAMPLE

$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,loop'
#$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg

# SET EXAMPLE

# Not available — this is a read-only/status helper.
```

---

### `password`

**What it does:** SET-only (`set_avalon_device_password`). Changes the web UI password. Expects two comma-separated arguments: `oldpasswd,newpasswd`. The handler validates the old password by SHA256 hex compare then stores new password SHA256 hex into `info->webpass[0]` and sends it to hardware.

```powershell
# GET EXAMPLE

# Not available via this handler — password readback is not exposed by this ascset handler.

# SET EXAMPLE (change password)
#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,password,oldpass,newpass'
#$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg

# NOTE: handler expects two arguments; it uses SHA256(hex) internally for comparison/storage.
```

---

### `qr_auth`

**What it does:** SET-only (`set_avalon_qr_auth`). Accepts `random,verify` strings extracted from a QR process. The handler validates against `g_ava_qr_auth` and the stored web password-derived signature; on success sets `g_ava_qr_login = 1`. There is a separate web path to query `qr_login`, but this handler only performs the auth step.

```powershell
# GET EXAMPLE

# Not available — this handler is used to submit QR auth data (set only).

# SET EXAMPLE

#$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,qr_auth,myRandomString,myVerifyString'
#$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg

# NOTE: the handler expects both random and verify strings and compares against g_ava_qr_auth values.
```

---
