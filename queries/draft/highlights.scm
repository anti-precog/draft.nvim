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
(context) @operator
(context
 (info) @label)

(context) @nospell

(sub_context) @operator
(sub_context
 (info) @label
 (#set! conceal ""))

(sub_context) @nospell

; header
(name) @label
(name) @nospell

((prefix) @number
 (#set! conceal ""))

; other
(ERROR) @error
(MISSING) @missing


