;;; demangle-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "demangle-mode" "demangle-mode.el" (0 0 0 0))
;;; Generated autoloads from demangle-mode.el

(autoload 'demangle-mode "demangle-mode" "\
Toggle demangle mode.

If called interactively, enable Demangle mode if ARG is positive,
and disable it if ARG is zero or negative.  If called from Lisp,
also enable the mode if ARG is omitted or nil, and toggle it if
ARG is `toggle'; disable the mode otherwise.

Interactively with no argument, this command toggles the mode.  A
positive prefix argument enables the mode; any other prefix
argument disables it.  From Lisp, argument omitted or nil enables
the mode, while `toggle' toggles the state.

When Demangle mode is enabled, mangled C++, D, and Rust symbols
appearing within the buffer are demangled, making their decoded
forms visible.

Visit `https://github.com/liblit/demangle-mode/issues' or use
\\[demangle-mode-submit-bug-report] to report bugs in
`demangle-mode'.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "demangle-mode" '("demangle-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; demangle-mode-autoloads.el ends here
