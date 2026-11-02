; basic
(text) @none
(speech) @string
(quote) @string
(asterix) @label

(narration) @spell
(dialog) @spell
(quotation) @spell

; groups
((header) @comment
 (#set! conceal ""))
((footer) @comment
 (#set! conceal ""))

; comments
(comment) @comment
(comment) @nospell

; section
(title) @label
(title) @nospell

((tag) @operator
 (#set! conceal ""))


; other
(ERROR) @error
(MISSING) @missing

