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
(main_context) @comment
((head_context) @comment
 (#set! conceal ""))
((foot_context) @comment
 (#set! conceal ""))

(main_context) @nospell
(head_context) @nospell
(foot_context) @nospell

; header
(name) @label
(name) @nospell

((tag) @number
 (#set! conceal ""))

; other
(ERROR) @error
(MISSING) @missing


