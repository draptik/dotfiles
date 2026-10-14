# Org-mode in Neovim — a tutorial for this config

This tutorial follows the setup in `lua/plugins/orgmode.lua`
([nvim-orgmode](https://github.com/nvim-orgmode/orgmode)). The focus is on
**time tracking**, and it sticks to features that nvim-orgmode ships with.

Inside an org buffer, `g?` lists every mapping that is active there. Agenda
and capture windows have their own `g?`.

## 1. What the config sets up

| Setting                  | Value                          | Effect                                         |
| ------------------------ | ------------------------------ | ---------------------------------------------- |
| `org_agenda_files`       | `~/tmp/org-demo/**/*`          | Files scanned by agenda and clock report       |
| `org_default_notes_file` | `~/tmp/org-demo/mydefault.org` | Where captures land                            |
| `org_agenda_span`        | `week`                         | `<Leader>oa` → `a` shows the current week      |
| custom agenda `d`        | span `day`                     | `<Leader>oa` → `d`: today only                 |
| custom agenda `w`        | span `week`                    | `<Leader>oa` → `w`: this week                  |

> The demo directory has to exist first: `mkdir -p ~/tmp/org-demo`.
> Only files under it count for the agenda and the clock report.

The mapping prefix is `<Leader>o`. The following mappings are remapped because
the defaults clash with LazyVim:

| Action               | Default     | This config  |
| -------------------- | ----------- | ------------ |
| Next TODO state      | `cit`       | `<Leader>os` |
| Previous TODO state  | `ciT`       | `<Leader>oS` |
| Priority up          | `ciR`       | `<Leader>oP` |
| Priority down        | `cir`       | `<Leader>op` |
| Toggle checkbox      | `<C-Space>` | `<Leader>o[` |

## 2. Basics in five minutes

Create `~/tmp/org-demo/work.org`:

```org
#+TITLE: Work
#+CATEGORY: work

* Project Alpha
** TODO Write API spec
** TODO Review pull requests
- [ ] backend
- [ ] frontend
* Admin
** TODO Expense report
```

| Key                        | What it does                                   |
| -------------------------- | ---------------------------------------------- |
| `<Tab>` / `<S-Tab>`        | Fold the subtree / cycle folding for the file  |
| `<Leader><CR>`             | New heading or list item (depends on context)  |
| `<Leader>oit`              | New TODO heading after the current subtree     |
| `<Leader>os` / `<Leader>oS`| Cycle `TODO` → `DONE` → none                   |
| `<Leader>o,`               | Pick a priority                                |
| `<Leader>o[`               | Toggle the checkbox under the cursor           |
| `<<` `>>` / `<s` `>s`      | Promote/demote the heading / the whole subtree |
| `<Leader>oK` / `<Leader>oJ`| Move the subtree up/down                       |
| `<Leader>ot`               | Set tags                                       |
| `<Leader>ois` / `<Leader>oid` | Set SCHEDULED / DEADLINE                    |
| `<Leader>oi.` / `<Leader>oi!` | Insert an active / inactive timestamp       |
| `<Leader>or`               | Refile the subtree                             |
| `<Leader>oc`               | Capture (default template `t` = Task)          |
| `<Leader>oa`               | Open the agenda dispatcher                     |

When a TODO is set to `DONE`, a `CLOSED: [timestamp]` line is added below the
heading (`org_log_done = 'time'`, which is the default).

In a capture window, `<C-c>` saves the entry, `<Leader>ok` throws it away and
`<Leader>or` refiles it somewhere else.

## 3. Time tracking

### 3.1 Clocking in and out

Put the cursor anywhere inside a heading's subtree:

| Key           | Action                                                |
| ------------- | ----------------------------------------------------- |
| `<Leader>oxi` | **Clock in.** Any other running clock is stopped first |
| `<Leader>oxo` | **Clock out**                                         |
| `<Leader>oxq` | **Cancel** the running clock (removes the entry)      |
| `<Leader>oxj` | Jump to the heading that is clocked in                |
| `<Leader>oxe` | Set an **effort** estimate (e.g. `1:30`, `45min`, `2h`) |

Clocking in creates a `:LOGBOOK:` drawer:

```org
** TODO Write API spec
:PROPERTIES:
:Effort:   2:00
:END:
:LOGBOOK:
CLOCK: [2026-10-14 Wed 09:05]
:END:
```

After clocking out, the entry is closed and its duration is added:

```org
:LOGBOOK:
CLOCK: [2026-10-14 Wed 09:05]--[2026-10-14 Wed 10:20] =>  1:15
:END:
```

Each new session adds a line at the top of the drawer. Things to know:

- **Only one clock can run at a time.** Clocking in on another task stops
  the current one, so you can just jump between tasks.
- **Setting a task to DONE stops its clock.** `<Leader>os` on the clocked
  task ends the session and adds `CLOSED:`.
- The running clock is stored in the file, so it keeps going after you close
  Neovim. Once you open Neovim again, `<Leader>oxj` or `<Leader>oxo` picks it
  up.

### 3.2 Fixing clock entries

If you forgot to clock out, or started late:

1. Put the cursor on a date or time inside a `CLOCK:` line.
2. `<C-a>` / `<C-x>` change the part under the cursor (minutes, hours, day…).
   The `=> H:MM` total is **recalculated automatically**.
3. `<S-Up>` / `<S-Down>` move the timestamp by a day.
4. If you typed the time by hand, `gqgq` on the line (or `gq` on a visual
   selection) recalculates the total. `gggqG` reformats the whole file and
   fixes every total.

Minutes snap to multiples of 5 (`org_time_stamp_rounding_minutes = 5`).

### 3.3 Clocking from the agenda

Open `<Leader>oa` → `d` (today) or `w` (week). The clocked-in item is
highlighted.

| Key           | Action                                           |
| ------------- | ------------------------------------------------ |
| `I`           | Clock in the item under the cursor               |
| `O`           | Clock out the running clock (from any line)      |
| `X`           | Cancel the running clock (from any line)         |
| `<Leader>oxj` | Jump to the clocked-in heading                   |
| `<Leader>oxe` | Set effort for the item under the cursor         |
| `t`           | Change TODO state                                |
| `<CR>` / `<Tab>` | Open the item (same window / other window)    |
| `K`           | Preview the item                                 |
| `r`           | Refresh                                          |

### 3.4 Reports: the agenda clock report

`R` in the agenda adds a **clock report** for the agenda's current date range
below it:

```
| File     | Headline         | Time |
|----------+------------------+------|
|          | ALL Total time   | 3:40 |
|----------+------------------+------|
| work.org | File time        | 3:40 |
|          | Write API spec   | 2:25 |
|          | Expense report   | 1:15 |
|----------+------------------+------|
```

Headings in the table are links: `<CR>` or `<Tab>` jumps to them.

Change the range to get a different report:

| Key                       | Range                                  |
| ------------------------- | -------------------------------------- |
| `vd` `vw` `vm` `vy`       | Day / week / month / year              |
| `f` / `b`                 | Next / previous period                 |
| `.`                       | Back to today                          |
| `J`                       | Jump to a date                         |

For example, *"what did I do last week?"* is `<Leader>oa` → `w` → `b` → `R`.
*"How much this month?"* is `vm` → `R`.

Limits of the clock report:

- It only includes **agenda files** (`~/tmp/org-demo/**/*`).
- Time is counted on the heading that holds the `CLOCK:` lines. Totals are
  **not rolled up** to parent headings; the per-file total is the only sum.
  Clock in on the leaf tasks you want to see in the report.
- It is shown in the agenda only and is never written into the file.

### 3.5 Showing the running clock in the statusline (optional)

nvim-orgmode has a statusline function. It shows
`(Org) [0:42/2:00] (Write API spec)`, i.e. time spent / effort plus the
heading. Using it in LazyVim's lualine takes a small extra plugin spec, which
this config does **not** have yet:

```lua
-- lua/plugins/extend-lualine.lua
return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    table.insert(opts.sections.lualine_x, 1, {
      function()
        return _G.orgmode and _G.orgmode.statusline() or ""
      end,
    })
  end,
}
```

## 4. Clocktables and the Emacs hook

Emacs Org has `#+BEGIN: clocktable` dynamic blocks: tables that are written
into the file and updated on demand. **nvim-orgmode does not support them**
(as of the locked commit `78c9928`, Oct 2026). The open upstream issue is
[#1089](https://github.com/nvim-orgmode/orgmode/issues/1089).

| Need                                                | Native answer                  |
| --------------------------------------------------- | ------------------------------ |
| See where the time went for a day/week/month        | Agenda `R` (section 3.4)       |
| Time on the task you're working on                  | `=> H:MM` lines, statusline    |
| A table stored in the file (to share, export, archive) | Not available — needs Emacs |

`lua/config/autocmds.lua` maps `<Leader>oC` in org buffers. It runs
`emacs --batch` with `update-clocktables.el`, which updates every dynamic block
in the file. You only need it for persisted clocktables, like this one:

```org
#+BEGIN: clocktable :scope file :maxlevel 2
#+END:
```

> **Note:** the hook points to `~/.dotfiles/emacs/update-clocktables.el`, but
> the script is at `~/.dotfiles/.config/emacs/update-clocktables.el`.
> `<Leader>oC` does nothing until that path is fixed.

## 5. A daily routine

1. **Morning:** `<Leader>oa` → `d`. Look at today's scheduled items and
   deadlines.
2. **Start a task:** `I` on it in the agenda, or `<Leader>oxi` in the file.
   Add an effort with `<Leader>oxe` if you want an estimate.
3. **Interruption:** `<Leader>oc` captures it. Clock in on it, or just
   clock in on something else, which stops the current clock.
4. **Done:** `<Leader>os` → `DONE`. This also stops the clock.
5. **Forgot to clock out?** `<Leader>oxj`, then fix the end time with
   `<C-x>` (section 3.2).
6. **End of week:** `<Leader>oa` → `w` → `R` shows the weekly report. Press
   `b` to see the week before.
