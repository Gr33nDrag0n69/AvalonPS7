# `ascset` options — descriptions + PowerShell examples

**Important safety notes**

* `ascset` touches hardware. Use `help` first. Prefer read-only queries before writes.
* For destructive operations (`reboot`, `hash-sn-write`, `password`, `fac*`) ensure you have SSH/console access and a fallback plan.
* Use small increments for `fan`, `frequency`, `voltage` and monitor temps via `devs`/`devdetails`.

All examples assume you have `$MinerIP` set to the miner IP and ASC id `0`. Adjust as needed.

---

### `help`

**What it does:** Request driver help — returns supported `ascset` options and sometimes usage details.

```powershell
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,help'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `voltage`

**What it does:** Get/set ASIC voltage (core/board). Ranges & syntax are driver-specific — call `help` first.

```powershell
# Query current voltage (if supported)
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,voltage'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg

# Example set (driver-dependent — check help for safe ranges)
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,voltage,1150'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `fan-spd`

**What it does:** Set or query fan speed (usually percent 0–100). Common and lower risk.

```powershell
# Query current fan / rpm (if supported)
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,fan-spd'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg

# Set fan speed to 75%
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,fan-spd,75'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `ledmode`

**What it does:** Change LED behavior (off/on/blink/status). Values depend on driver.

```powershell
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,ledmode,status'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `ledset`

**What it does:** Configure LED settings (colors/patterns). Driver-specific.

```powershell
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,ledset,pattern1'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `lcd`

**What it does:** Control LCD (write text, clear, etc.). Format is driver dependent.

```powershell
# Write short text to LCD (check help for exact format)
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,lcd,OK'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `nightlamp`

**What it does:** Toggle night-mode lamp or low-light LED (on/off or schedule).

```powershell
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,nightlamp,on'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `wallpaper`

**What it does:** Set/clear wallpaper image shown on LCD/web UI — large payloads handled specially. Use `none` to clear.

```powershell
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,wallpaper,none'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `hash-sn-read`

**What it does:** Read device hash serial number. Read-only.

```powershell
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,hash-sn-read'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `hash-sn-write`

**What it does:** Write the device hash serial number — provisioning-only, risky.

```powershell
# ONLY use with vendor instruction
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,hash-sn-write,NEW_SERIAL_123'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `volt-adjust-switch`

**What it does:** Enable/disable automatic voltage adjustment.

```powershell
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,volt-adjust-switch,on'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `workmode`

**What it does:** Switch operation mode (e.g., normal/eco/boost). Values vary by driver.

```powershell
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,workmode,eco'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `worklevel`

**What it does:** Set numeric performance/power level (coarse mapping to freq/power).

```powershell
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,worklevel,2'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `work_mode_lvl`

**What it does:** Combined mode+level parameter; driver-specific mapping.

```powershell
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,work_mode_lvl,mode1:3'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `reboot`

**What it does:** Reboot the device or ASC module. Miner will restart — use with care.

```powershell
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,reboot'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `filter-clean`

**What it does:** Run a filter/clean routine — implementation-dependent (clears FIFOs, resets counters).

```powershell
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,filter-clean'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `facopts`

**What it does:** Factory options (production/provisioning). Vendor-only.

```powershell
# Query or vendor-specified set
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,facopts'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `faclock`

**What it does:** Factory lock/unlock — prevents factory changes. Use vendor instructions only.

```powershell
# Lock factory options
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,faclock,1'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `frequency`

**What it does:** Query or set ASIC operating frequency. **High risk** — raising freq can overheat or destabilize. Use small increments.

```powershell
# Query
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,frequency'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg

# Set (example — check help for safe values)
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,frequency,600'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `loop`

**What it does:** Start/stop an internal loop/test routine (self-test). Driver dependent.

```powershell
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,loop,start'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `password`

**What it does:** Set/change ASC-level password. Sensitive: prompt, don’t hardcode.

```powershell
# Secure prompt example (build param at runtime)
$secure = Read-Host "New ASC password" -AsSecureString
$plain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure))
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params "0,password,$plain"
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `qr_auth`

**What it does:** QR/2FA provisioning or enable QR-based auth. Vendor-specific.

```powershell
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,qr_auth,enable'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `target-temp`

**What it does:** Set target temperature; miner may throttle or adjust fans to reach it. Useful for thermal control.

```powershell
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,target-temp,65'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `smart-speed`

**What it does:** Enable adaptive speed control that adjusts frequency/worklevel to meet temp/efficiency targets.

```powershell
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,smart-speed,on'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `ssdn-pro`

**What it does:** Advanced/vendor feature (SSDN Pro) — query or toggle professional feature set.

```powershell
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,ssdn-pro'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `spdlog`

**What it does:** Configure speed/performance logging or diagnostics (verbose). Useful for debugging.

```powershell
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,spdlog,on'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `pll-sel`

**What it does:** Select PLL/clock source for frequency generator. Hardware-level, vendor-specific.

```powershell
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,pll-sel,1'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

### `aging-parameter`

**What it does:** Configure aging/burn-in parameters (used for reliability testing). Usually factory-only.

```powershell
$ApiObject = Invoke-AvalonAPI -IP $MinerIP -Command 'ascset' -Params '0,aging-parameter,72h'
$ApiObject | ConvertTo-Json -Depth 100
$ApiObject.STATUS.Msg
```

---

