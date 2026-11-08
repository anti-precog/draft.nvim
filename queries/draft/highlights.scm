; other
(ERROR) @error
(MISSING) @missing

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

; alternatives
(alter) @markup.strikethrough 
(alter) @nospell

; section
(name) @label
(name) @nospell

((tag) @operator
 (#set! conceal ""))


