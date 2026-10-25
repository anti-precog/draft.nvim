; basic
(narrative) @text
(speech) @string

; groups
((head) @keyword
 (#set! conceal ""))
((stop) @keyword
 (#set! conceal ""))

; comments
(comment) @comment

; headers
(header) @markup.strong

; summaries
((summary) @markup.underline
  (#set! conceal "")
  (#set! conceal_lines ""))

; other
(ERROR) @error
(MISSING) @missing

