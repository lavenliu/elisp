(defun myfun (a b c d)
  "This is a nonce function desigend to show how to
use local variables safely"
  (let ((e (+ a b))
		(f (* c d)))
	(- e f)))

(message (number-to-string (myfun 7 5 3 1)))


