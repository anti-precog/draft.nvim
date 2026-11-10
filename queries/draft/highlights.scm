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
(main_context) @comment.todo
(head_context) @comment.error
(foot_context) @comment.warning

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


