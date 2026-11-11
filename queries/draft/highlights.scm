; basic
(text) @none
(speech) @string
(quote) @string
(asterix) @label

(paragraph) @spell

; comments
(comment) @comment
(comment) @nospell

; context
(context) @comment
((sub_context) @comment
 (#set! conceal ">"))

(context) @nospell
(sub_context) @nospell

; header
(name) @label
(name) @nospell

((prefix) @number
 (#set! conceal ""))

; other
(ERROR) @error
(MISSING) @missing


