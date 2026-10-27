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
(title) @module

; TODO: to remove
; summaries
; ((summary) @markup.underline
;  (#set! conceal "")
;  (#set! conceal_lines ""))

; other
(ERROR) @error
(MISSING) @missing

