# Org-mode Exercises

A hands-on introduction for Neovim users learning org-mode.
Work through these in order — each builds on the previous.

---

## 1. Create your first org file

1. Open Emacs and create a new file: `C-x C-f ~/test.org RET`
2. Type a heading: `* My first heading`
3. Press `RET` then write a line of body text below it
4. Save: `C-x C-s`

---

## 2. Headings and structure

In `~/test.org`:

1. Create a top-level heading: `* Projects`
2. Below it, create a subheading: press `RET`, then `M-RET` — notice it creates `**`
3. Type `My first project`
4. Add another subheading under that: `*** A task inside the project`
5. Navigate between headings with `C-c C-n` (next) and `C-c C-p` (previous)
6. Collapse and expand headings with `TAB` on a heading
7. Collapse everything with `S-TAB`

---

## 3. Todo states

1. Place the cursor on a heading
2. Press `C-c C-t` — notice the state cycles: `TODO` → `NEXT` → `WAITING` → `DONE` → `CANCELLED` → (none)
3. Create three headings, set them to different states
4. Try the shortcut keys (defined in your config): `C-c C-t t` for TODO, `C-c C-t n` for NEXT, etc.

---

## 4. Capture a task

Without leaving what you're doing:

1. Press `C-c c` to open the capture menu
2. Press `t` to capture a Task
3. Type a task description
4. Press `C-c C-c` to save and close — it lands in `$ORG_DIR/inbox.org` under Tasks
5. Open `inbox.org` with `C-x C-f` and find your task

---

## 5. Capture a journal entry

1. Press `C-c c` then `j` for Journal
2. Write a short entry
3. Press `C-c C-c` to save
4. Open `$ORG_DIR/journal.org` — notice the date tree structure (year → month → day)

---

## 6. Scheduling and deadlines

1. Create a heading: `* TODO Buy groceries`
2. Schedule it: `C-c C-s` → pick a date in the calendar (arrow keys to navigate, `RET` to select)
3. Add a deadline: `C-c C-d`
4. Notice the `SCHEDULED:` and `DEADLINE:` timestamps added to the entry

---

## 7. The agenda

1. Press `C-c a` to open the agenda dispatcher
2. Press `a` for the weekly agenda — you should see your scheduled items
3. Press `t` for a global todo list
4. Press `q` to quit the agenda

---

## 8. Time tracking

1. Create a heading: `* TODO Write project report`
2. Clock in: `C-c C-x C-i` — notice the `CLOCK:` line appears
3. Do some pretend work (wait a moment)
4. Clock out: `C-c C-x C-o`
5. The elapsed time is recorded under the heading

---

## 9. Links

1. Visit any file, then store a link to it: `C-c l`
2. Open your `inbox.org`
3. Create a heading and insert the link: `C-c C-l RET RET` (it auto-completes the stored link)
4. Follow the link: `C-c C-o` with cursor on it

---

## 10. Refiling

Once your inbox has a few tasks, practice refiling them:

1. Open `inbox.org`
2. Place cursor on a task heading
3. Press `C-c C-w` to refile
4. Start typing a target heading — completion will narrow the list
5. Press `RET` to move the task there
