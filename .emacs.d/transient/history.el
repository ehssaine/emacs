((magit-branch nil)
 (magit-cherry-pick
  ("--ff")
  ("--ff" "--edit")
  nil)
 (magit-commit
  ("--no-verify"))
 (magit-dispatch nil)
 (magit-fetch nil)
 (magit-log
  ("-n256" "--graph" "--decorate"))
 (magit-merge nil)
 (magit-pull
  ("--rebase"))
 (magit-push
  ("--force"))
 (magit-rebase nil
               ("--autostash" "--interactive")
               ("--autostash" "--interactive" "--no-verify"))
 (magit-stash nil))
