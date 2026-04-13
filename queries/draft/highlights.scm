; basic
(narrative) @text
(comment) @comment
(speech) @function

; groups
((head) @keyword
 (#set! conceal "")
 (#set! conceal_lines ""))
((end) @keyword
 (#set! conceal "")
 (#set! conceal_lines ""))

; tags
((tags) @keyword
 (#set! conceal "")
 (#set! conceal_lines ""))

(tags
  (tag) @error)

; other
(ERROR) @error
(MISSING) @missing
