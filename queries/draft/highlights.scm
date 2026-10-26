; basic
(narrative) @text
(speech) @string

; groups
((header) @comment
 (#set! conceal ""))
((footer) @comment
 (#set! conceal ""))

; comments
(comment) @comment

; section
; headers
(title) @markup.underline

; summaries
((summary) @markup.underline
  (#set! conceal "")
  (#set! conceal_lines ""))

; other
(ERROR) @error
(MISSING) @missing

