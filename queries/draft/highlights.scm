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
(main_context) @comment.error
(head_context) @comment.note
(foot_context) @comment.todo

(head_context) @nospell
(foot_context) @nospell
(main_context) @nospell

; header
(name) @label
(name) @nospell

((tag) @number
 (#set! conceal ""))

; other
(ERROR) @error
(MISSING) @missing


