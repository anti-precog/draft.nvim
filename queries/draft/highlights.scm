; basic
(narrative) @text
(speech) @string

; groups
((header) @comment.note
 (#set! conceal ""))
((footer) @comment.warning
 (#set! conceal ""))

; comments
(comment) @comment

; section
; headers
(title) @module

; summaries
((summary) @markup.underline
  (#set! conceal "")
  (#set! conceal_lines ""))

; other
(ERROR) @error
(MISSING) @missing

