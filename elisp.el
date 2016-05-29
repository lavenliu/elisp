

;; went into the castle and lived happily ever after.
;; The end. WRITESTAMP((2015/4/15))

;; Chapter 1: 列表处理

; 在Lisp中，数据和程序都以同样的方式表示；也就是说，它们都是由空格分割、
; 由括号括起来的单词、数字或者其他列表的列表。

; 在一个列表中，列表的元素被称为“原子”，不可再被分割为更小的部分。列表
; 中的原子是由空格一一分割的。

; 双引号中的文本，不论是句子还是段落，都是一个单个原子，被称为串
; （string）

; 如何执行下呢？我们把光标放到(this list includes "text between
; quotation marks.")的最后一个括号处，然后按下“C-x C-e”，然后在echo
; area区域，可以看到执行后的结果。或者使用“C-u C-x C-e”组合键，结果可以
; 输出到当前光标所在位置处。
; 动手试试？:-)
'(this list includes "text between quotation marks.")
;(this list includes "text between quotation marks.")


; 列表中的空格数量是无关紧要的

; 单引号，被称为一个引用。当单引号位于一个列表之前时，它告诉lisp不要对
; 这个列表做任何操作，而仅仅是按其原样。
; 但是，如果一个列表前没有引号，这个列表中的第一个符号就很特别了：
; 它是一条计算机要执行的命令（在Lisp中，这些命令被称作函数）

(+ 2 2)
;4

'(this is a quoted list)
;(this is a quoted list)

(this is a quoted list)
;Symbol's function definition is void: this

;; Lisp解释器
; Lisp解释器对一个列表求值时它做些了什么：首先，它查看一下在列表前面是
; 否有单引号。如果有，解释器就为我们给出这个列表。如果没有引号，解释器
; 就查看列表的第一个元素，并判断它是否是一个函数定义。如果它确实是一个
; 函数，则解释器执行函数定义中的指令。否则，解释器打印一个错误消息。

(+ 2 (+ 3 3))
;8

; 一个函数参量是函数后面的原子或者列表


kill-ring-max
;60

;; ----------------------------------------
;; 第一章练习
;; ----------------------------------------
1. 通过对一个不在括号内的适当符号求值，产生一个错误消息
2. 通过对一个在括号内的适当符号求值，产生一个错误消息
3. 创建一个每次增加2而不是1的计数器
(setq counter 0)
(setq counter (+ 2 counter))
4. 写个一个表达式，当对它求值时，它在回显区中输出一条消息
(message "This file full path name is: %s" (buffer-file-name))
;;"This file full path name is: e:/home/elisp.el"

;; ======================================================================

;; ========================================
;; Chapter 2: 求值实践
;; ========================================

;; 每当在Emacs Lisp中发出一个编辑命令时，比如移动一个光标或滚动屏幕的
;; 命令，就是在对一个表达式求值，这个表达式的第一个元素就是一个函数。
;; 这就是Emacs的工作方式。


;; buffer-name是缓冲区的名称
;; buffer-file-name是缓冲区所指向的文件完整的路径名
(buffer-name)
;; "*scratch*"

(buffer-file-name)
;; "f:/Misc/elisp.org"

;; 文件和缓冲区是两个不同的实体。文件是永久记录在计算机中的信息。而缓
;; 冲区是Emacs内部的信息，它在Emacs编辑回话结束时（或当取消缓冲区时）
;; 就消失了。

;; 通常情况下，缓冲区包含了从文件中拷贝过来的信息，我们称这个缓冲区正
;; 在“访问”那个文件。这份拷贝正是我们要加工或修改的对象。对这个缓冲
;; 区的改动不会改变那个文件，除非我们保存了这个缓冲区。当我们保存这个
;; 缓冲区时，缓冲区中的内容被拷贝到文件中去，因此被永久的保存下来了。

(current-buffer)
;; #<buffer elisp.el>

(other-buffer)
;; #<buffer *scratch*>

(switch-to-buffer (other-buffer))

;; ----------------------------------------
;; 2.4 缓冲区大小和位点的定位
;; ----------------------------------------

;; buffer-size point point-min point-max

(buffer-size)
;; 17533

(point) ; 2308
(point-min) ;1 ;; 除非设置了变窄，这个值一般是1
(point-max) ;17585

;; ----------------------------------------
;; 2.5 练习
;; ----------------------------------------

;; 找一个文件，对它进行操作，将光标移动到缓冲区的中间部分。找出它的缓
;; 冲区名、文件名、长度、和你在文件（其实是缓冲区）的位置
(buffer-name) ;"elisp.el" ; only get the filename
(buffer-file-name) ; "f:/Misc/elisp.el" ; get the filename and its path
(current-buffer) ; #<buffer elisp.el>
(other-buffer) ; #<buffer *Buffer List*>
(switch-to-buffer (other-buffer))
(buffer-size) ; 1814
(point)
(point-max)
(point-min)

;; ======================================================================

;; ========================================
;; Chapter 3: 如何编写函数定义
;; ========================================

;; 一个函数定义在defun一词之后最多有下列五个部分：
;; 1. 符号名，这是函数定义将要依附的符号
;; 2. 将要传递给函数的参量列表。如果没有参量要传递，则是空列表()
;; 3. 描述这个函数的文档。（可选，但强烈推荐的。）
;; 4. 一个使函数成为交互函数的表达式，这是可选的。因此，可以通过键入
;; M-x和函数名来使用它，或者键入一个适当的键或者键序列来使用它。
;; 5. 指导计算机如何运行的代码，这是函数定义的主体。

;; 当注册一个函数后，在函数的最后一个括号后，使用"C-x C-e"来使之生效。
;; "C-h e"可以打开*Messages*窗口，查看输出结果。

; Version 1
;(defun multiply-by-seven (number)
;  "Multiply NUMBER by seven."
;  (* 7 number))
(multiply-by-seven 3) ; 21

; Version 2
(defun multiply-by-seven (number)
  "Multiply NUMBER by seven."
  (interactive "p")
  (message "The result is %d" (* 7 number)))

;; "p"告诉Emacs要传送一个前缀参量给这个函数，并将它的值用于函数的参量
;; 如何传递，比如传递“5”给函数，可以使用C-u 5 M-x multiply-by-seven

(multiply-by-seven 3) ; "The result is 21"

;; let创建的局部变量

(let ((zebra 'stripes)
      (tiger 'fierce))
  (message "One kind of animal has %s and another is %s."
	   zebra tiger))
"One kind of animal has stripes and another is fierce."

(let ((birch 3)
      pine
      fir
      (oak 'some))
  (message
   "Here are %d variables with %s, %s, and %s value."
   birch pine fir oak)) ;"Here are 3 variables with nil, nil, and some value."

(if (> 5 4)
    (message
     "5 is greater than 4!")) ;"5 is greater than 4!"

;; Version 1: type-of-animal
(defun type-of-animal (characteristic)
  "Print message in echo area depending on CHARACTERISTIC.
If the CHARACTERISTIC is the symbol 'fierce',
then warn of a tiger."
  (if (equal characteristic 'fierce)
      (message "It's a tiger!")))

(type-of-animal 'fierce) ; "It's a tiger!"
(type-of-animal 'zebra) ; nil

(if (> 4 5)                              ; if-part
    (message "5 is greater than 4!")     ; then-part
  (message "4 is not greater than 5!"))  ; else-part


;; Version 2: type-of-animal
(defun type-of-animal (characteristic)   ; Second version
  "Print message in echo area depending on CHARACTERISTIC.
If the CHARACTERISTIC is the symbol 'fierce',
then warn of a tiger;
else say it's not fierce."
  (if (equal characteristic 'fierce)
      (message "It's a tiger!")
    (message "It's not fierce!")))

(type-of-animal 'fierce) ;"It's a tiger!"
(type-of-animal 'zebra) ;"It's not fierce!"

(if 4
    'true
  'false) ;true

(if nil
    'true
  'false) ;false

(> 5 4) ;t
(> 4 5) ;nil

(let ((foo (buffer-name))
      (bar (buffer-size)))
  (message
   "This buffer is %s and has %d characters."
   foo bar)) ;"This buffer is elisp.el and has 3811 characters."

;; save-excursion函数

(message "We are %d characters into this buffer."
	 (- (point)
	    (save-excursion
	      (goto-char (point-min)) (point))))
;; "We are 5583 characters into this buffer."



(emacs-version) ;"GNU Emacs 24.4.1 (x86_64-w64-mingw32)
					; of 2014-10-21 on KAEL"
(substring (emacs-version) 10 12) ;"24"

;; Problem
(if (string= (int-to-string 24）
	     （substring (emacs-version) 10 12))
    (message "This is version 24 Emacs")
  (message "This is not version 24 Emacs"))


(defun is-larger-fill-column (number)
  "This function"
  (interactive "p")
  (if (> number fill-column)
      (message "%d is larger than fill-column!" number)
    (message "%d is not greater than fill-column!" number)))
;; is-larger-fill-column
(is-larger-fill-column 80)
;; "80 is larger than fill-column!"

;; ----------------------------------------
;; 练习
;; ----------------------------------------
;; 1. 编写一个非交互的函数，这个函数将其第一个参量（是一个数）的值翻倍。
;; 然后使这个函数成为交互函数
(defun two-times (number)
  "multi number by 2"
  (message "multi %d by 2 is: %d" number (* 2 number)))

(two-times 2) ;"multi 2 by 2 is: 4"
(two-times 25) ;"multi 25 by 2 is: 50"

(defun two-times (number)
  "multi number by 2"
  (interactive "p")
  (message "multi %d by 2 is: %d" number (* 2 number)))

;; 2. 编写一个函数，测试fill-column的当前值是否大于传递给函数的参量的值。
;; 如果是，则打印适当的消息
(is-larger-fill-column 23) ;"23 is not greater than fill-column!"
(is-larger-fill-column 73) ;"73 is larger than fill-column!"

;; ======================================================================

;; ========================================
;; Chapter 4: 与缓冲区有关的函数
;; ========================================

;;; C-h f 函数名 -- 可以查看Emacs Lisp函数的全部文档
;;; C-h v 变量名 -- 可以查看Emacs Lisp变量的全部文档

;;; 在一个原始的源代码文件中查看一个函数定义，可以使用find-tags函数跳到
;;; 相应的位置。使用M-.，然后输入要查看的函数名即可。


;; (push-mark)
;; 在最后一个)处，按C-x C-e，然后再按M-<，
;; 这时，光标跑到了文件的开头，然后，按C-x C-x后，光标将处于
;; )后面的位置


; beginning-of-buffer
(defun simplified-beginning-of-buffer ()
  "Move point to the beginning of the buffer;
leave mark at previous position."
  (interactive)
  (push-mark)
  (goto-char (point-min)))


;;; 4.3 mark-whole-buffer函数定义

; mark-whole-buffer
(defun mark-whole-buffer ()
  "Put point at beginning and mark at end of buffer."
  (interactive)
  (push-mark (point))
  (push-mark (point-max))
  (goto-char (point-min)))



(point)
;6269
(push-mark)

(car mark-ring)

;;; 4.4 append-to-buffer函数定义


;;; 4.6 练习

;;;; 编写自己的simplified-end-of-buffer函数定义，然后测试它是否能工作

; end-of-buffer
(defun simplified-end-of-buffer ()
  "Move point to the end of the buffer;
leave mark at previous position."
  (interactive)
  (push-mark)
  (goto-char (point-max)))

;;;; 用if和get-buffer编写一个函数，这个函数要打印一个说明某个缓冲区是否
;;;; 存在的消息

; is-buffer-exists

(buffer-name)
;"elisp.el"

(buffer-file-name)
;"c:/Users/admin/Desktop/elisp/elisp.el"

(get-buffer (current-buffer))
;#<buffer elisp.el>

(get-buffer "elisp.el")
;#<buffer elisp.el>

(get-buffer "scratch")
;nil

; is-buffer-exists

(defun is-buffer-exists (my-buffer)
  "Is exists my-buffer"
  (interactive "BInput your buffer-name: \nr")
  (if (get-buffer "my-buffer")
      (message "Exists %s buffer!" my-buffer)
    (message "Do not exist %s buffer!" my-buffer)))

;; ======================================================================

;; ========================================
;; Chapter 5: 更复杂的函数
;; ========================================

(buffer-size)
;; 12179

;; (erase-buffer)
;; 整个buffer就给擦除了。

;; ======================================================================

;; ========================================
;; Chapter 6：变窄和增宽
;; ========================================

;; ======================================================================

;; ========================================
;; Chapter 7: 基本函数：car、cdr、cons
;; ========================================

; cons -> construct
; car -> Contents of the Address part of the Register （寄存器地址的部分内容）
; car 返回列表的第一个元素，
; cdr -> Contents of the Decrement part of the Register （寄存器后部内容）
; cdr 返回第一个元素后的所有内容

(car '(rose violet daisy buttercup)) ; output: rose

(cdr '(rose violet daisy buttercup)) ; output: (violet daisy buttercup)


(car '((lion tiger cheetah)
       (gazelle antelope zebra)
       (whale dolphin seal))) ; output: (lion tiger cheetah)

(cdr '((lion tiger cheetah)
       (gazelle antelope zebra)
       (whale dolphin seal))) ; output: ((gazelle antelope zebra) (whale dolphin seal))

(cons 'pine '(fir oak maple)) ; output: (pine fir oak maple)

(cons 'buttercup ()) ; (buttercup)

(cons 'daisy '(buttercup)) ; (daisy buttercup)

(cons 'violet '(daisy buttercup)) ; (violet daisy buttercup)

(cons 'rose '(violet daisy buttercup)) ; (rose violet daisy buttercup)


(length '(buttercup)) ; 1
(length '(daisy buttercup)) ; 2
(length (cons 'violet '(daisy buttercup))) ; 3
(length ()) ; 0
(length ) ; (wrong-number-of-arguments length 0)


(cdr '(pine fir oak maple)) ; (fir oak maple)
(cdr '(fir oak maple)) ; (oak maple)
(cdr '(oak maple)) ; (maple)
(cdr '(maple)) ; nil
(cdr 'nil) ; nil
(cdr ()) ; nil

(cdr (cdr '(pine fir oak maple))) ; (oak maple)

(nthcdr 2 '(pine fir oak maple)) ; (oak maple)
(nthcdr 0 '(pine fir oak maple)) ; (pine fir oak maple)
(nthcdr 1 '(pine fir oak maple)) ; (fir oak maple)
(nthcdr 3 '(pine fir oak maple)) ; (maple)
(nthcdr 4 '(pine fir oak maple)) ; nil
(nthcdr 5 '(pine fir oak maple)) ; nil

(setq animals '(giraffe antelope tiger lion)) 
; (giraffe antelope tiger lion)

animals 
; (giraffe antelope tiger lion)

(setcar animals 'hippopotamus) 
; hippopotamus
animals 
; (hippopotamus antelope tiger lion)

(setq domesticated-animals '(horse cow sheep goat)) 
; (horse cow sheep goat)

domesticated-animals 
; (horse cow sheep goat)

(setcdr domesticated-animals '(cat dog)) 
; (cat dog)

domesticated-animals 
; (horse cat dog)

;; ======================================================================

;; ========================================
;; Chapter 8: 剪切和存储文本
;; ========================================

;; ======================================================================

;; ========================================
;; Chapter 9: 列表是如何实现的
;; ========================================

(setq bouquet '(rose violet buttercup))

; (rose violet buttercup)

(setq flowers (cdr bouquet))
; (violet buttercup)

;flowers
; (violet buttercup)

(setq bouquet (cons 'lilly bouquet))
bouquet


(eq (cdr (cdr bouquet)) flowers)
;t

(setq flowers '(violet buttercup))
;(violet buttercup)

(setq flowers (cons 'liu flowers))
;(liu violet buttercup)

(setq flowers (cons 'laven flowers))
;(laven liu violet buttercup)

(setq more-flowers flowers)

more-flowers
;(laven liu violet buttercup)

(setq myfish (car flowers))
;laven

more-flowers
;(laven liu violet buttercup)

;; ======================================================================

;; ========================================
;; Chapter 10: 找回文本
;; ========================================

kill-ring-max
;60

(car kill-ring)
;#("(car kill-ring)" 0 15 (fontified t))

(car (nthcdr 0 kill-ring))
(car (nthcdr 1 kill-ring))
(car (nthcdr 2 kill-ring))
(car (nthcdr 3 kill-ring))
(car (nthcdr 4 kill-ring))

;; ======================================================================

;; ========================================
;; Chapter 11: 循环和递归
;; ========================================

(setq animals '(giraffe gazelle lion tiger))
animals


(defun print-elements-of-list (list)
  "Print each elements of LIST on a line of its on."
  (while list
    (print (car list))
    (setq list (cdr list))
    )
  )

(print-elements-of-list animals)
;
;giraffe
;
;gazelle
;
;lion
;
;tiger
;nil

(defun triangle (number-of-rows)
  "Add up the number of pebbles in a triangle.
The first row has one pebble, the second row two pebbles,
the third row three pebbles, and so on.
The argument is NUMBER-OF-ROW."
  (let ((total 0)
	(row-number 1))
    (while (<= row-number number-of-rows)
      (setq total (+ total row-number))
      (setq row-number (1+ row-number)))
    total))

(triangle 4)
;; 10

(triangle 7)
;; 28


;;; 11.2.1 使用列表的递归函数
(setq animals '(giraffe gazelle lion tiger))

(defun print-elements-recursively (list)
  "Print each element of LIST on a line of its own.
Uses recursion."
  (print (car list))			;body
  (if list				;do-again-test
      (print-elements-recursively	;recursive call
       (cdr list))))			;next-step-expression

(print-elements-recursively animals)
;注册完毕函数后，使用C-u C-x C-e，得到以下输出
;
;giraffe
;
;gazelle
;
;lion
;
;tiger
;
;nil
;nil

;;; 11.2.2 用递归算法代替计数器

(defun triangle-recursively (number)
  "Return the sum of the numbers 1 through NUMBER inclusive.
Use recursion."
  (if (= number 1)
      1
    (+ number 
       (triangle-recursively (1- number)))))

(triangle-recursively 7)
;C-u C-x C-e
;28

;;; 11.2.3 使用cond的递归的例子

(cond
 ((first-true-or-false-test first-consequent)
  (second-true-or-false-test second-consequent)
  (third-true-or-false-test third-consequent)
  ...)

(defun triangle-using-cond (number)
  (cond ((< number 0) 0)
	((= number 1) 1)
	((> number 1)
	 (+ number (triangle-using-cond (1- number))))))
;C-x C-e

(triangle-using-cond 7)
;C-u C-x C-e
;28

;;; 11.3 有关循环表达式的练习

;;;; 11.3.1 编写一个与triangle函数相似的函数，在这函数中，每一行的值等
;;;; 于所在行数的平方，使用while循环来编写这个函数。

(defun my-triangle1 (number-of-rows)
  "Square every line"
  (let ((total 0)
	(row-number 1))
    (while (<= row-number number-of-rows)
      (setq total (+ total (* row-number row-number))) ;just modify this line
      (setq row-number (1+ row-number)))
    total))

(my-triangle1 7)
;C-u C-x C-e
;1+4+9+16+25+36+49
;140

;;;; 11.3.2 编写一个与triangle函数相似的函数，求这些数的积而不是和

(defun my-triangle2 (number-of-rows)
  "Multiple every line."
  (let ((total 1)
	(row-number 1))
    (while (<= row-number number-of-rows)
      (setq total (* total row-number))
      (setq row-number (1+ row-number)))
    total))

(my-triangle2 7)
;C-u C-x C-e
;1x2x3x4x5x6x7=5040
;5040

;;;; 11.3.3 用递归的方法重新编写上面这两个函数。然后使用cond表达式重新
;;;; 编写这两个函数。

(defun my-triangle3 (number)
  "Return the quod use recursion."
  (let ((total 1)
	(row-number 1))
    (while (<= row-number number)
      (setq total (* row-number row-number))
      (setq row-number (1+ row-number))
      (+ total (my-triangle3 (1- number))))
  total))

(my-triangle3 7)

(defun my-triangle4 (number)
  "some blabla."
  (cond ((= number 0) 0)
	((= number 1) 1)
	((> number 1)
	 (* number (my-triangle4 (1- number))))))

(my-triangle4 7)
;5040

(my-triangle4 0)
;; 

;; ======================================================================

;; ========================================
;; Chapter 12: 正则表达式查询
;; ========================================

(format-time-string "%l.%M %p" (current-time))
(current-time)

;;; ========================================
;;; Writing GNU Emacs Extensions
;;; ========================================



(defun other-window-backward (&optional n)
  "Select the Nth previous window."
  (interactive "p")
  (if n
      (other-window (- n))
    (other-window -1)))

;;(other-window-backward)

(if a a b) === (or a b)

(if a a					; if a is true, return a
  (if b b				; if b is true, return b
    ...
    (if y y z)))			;else if y is true, return y, else z

(or a b . . . yz)


;;; ========================================
;;; elisp manual
;;; ========================================


(funcall (lambda (a b c) (+ a b c))
	 1 (* 2 3) (- 5 4))
;8

(funcall (lambda (n) (1+ n))		; One required;
	 1)				; requires exactly one argument.
;2

(funcall (lambda (n &optional n1)	;One required and one optional;
	 (if n1 (+ n n1) (1+ n)))	;1 or 2 arguments.
	 1 2)
;3

;;; ========================================
;;;
;;; ========================================
(defun insert-current-time ()
  "Insert the current time"
  (interactive "*")
  (insert (current-time-string)))

(insert-current-time);Thu Apr 16 13:24:41 2015

(current-time);(21807 18400 921470 200000)

(format-time-string "%X" (current-time))
;; "22:35:50"

(format-time-string "%x" (current-time))
;; "2015/11/28"

(format-time-string "%l.%M %p" (current-time))
;;#(" 1.33 下午" 6 8 (charset chinese-gbk))

(format-time-string "%H:%M %x" (current-time))
;; "22:35 2015/11/28"


;C-c-v可以打开一个lisp文件的函数名列表

;%X is the locale's "preferred" time format.

;; insert-time
(defvar insert-time-format "%X"
  "*Format for \\[insert-time] (c.f. 'format-time-string').")

(defvar insert-date-format "%x"
  "*Format for \\[insert-date] (c.f. 'format-time-string').")

(defun insert-time ()
  "Insert the current time according to insert-time-format."
  (interactive "*")
  (insert (format-time-string insert-time-format
                              (current-time))))

(defun insert-date ()
  "Insert the current date according to insert-time-format."
  (interactive "*")
  (insert (format-time-string insert-date-format
                              (current-time))))

(insert-time)
                                        ;13:47:24nil
(insert-date)
                                        ;2015/4/16nil
(buffer-file-name);"c:/Users/admin/Desktop/elisp/elisp.el"

(defun read-only-if-symlink ()
  (if (file-symlink-p buffer-file-name)
      ((progn )
       (setq buffer-read-only t)
       (message "File is a symlink"))))
(add-hook 'find-file-hook 'read-only-if-symlink)


;; chapter 4
;;
;; went into the castle and lived happily ever after.
;; The end. WRITESTAMP((2015/4/15))


======================================================================
;; http://ergoemacs.org/emacs/emacs.html
======================================================================
;; Determine OS
===============
(cond
 ((string-equal system-type "windows-nt") ; Microsoft Windows
  (progn
    (message "Microsoft Windows")))
 ((string-equal system-type "darwin") ; Mac OS X
  (progn
    (message "Mac OS X")))
 ((string-equal system-type "gnu/linux") ; linux
  (progn
    (message "Linux"))))


;; Determine Emacs Version
==========================
;; full emacs version number. A string.
emacs-version
;; sample value: "24.5.1"

;; A integer, emacs major version number.
emacs-major-version
;; sample value: 24

;; A integer, emacs minor version number.
emacs-minor-version
;; sample value: 5

或者可以使用下面的三个函数来检查Emacs版本：
;; version=
;; version<
;; version<=
(if (version< emacs-version "24.4")
    (message "is before 24.4")
  (message "is 24.4 or after"))

;; Determine Host Name, User Name, Init File Path
=================================================
system-name ;;"ZL-LIUCHUAN"
user-login-name ;; "Administrator"
user-emacs-directory ;; "~/.emacs.d/"
user-init-file ;; "e:/home/.emacs"


;;; =================================================
;;; ErgoEmacs.org
;;; =================================================

;; ================
;; Global Variables
;; ================
;; setq is used to set variables. Variables need not
;; be declared, and is global.
;;
;; (setq x 1) ; assign 1 to x
;; (setq a 3 b 2 c 7) ; assign 3 to a, 2 to b, 7 to c

;; ===============
;; Local Variables
;; ===============

;; To define local variables, use let. The format is: (let (<var1>
;; <var2> ...) <body>) where <body> is (one or more) lisp
;; expressions. The body's last expression's value is returned.

(let (a b)
  (setq a 3)
  (setq b 4)
  (+ a b)
  ) ;7

;; Another form of let is this: (let (<var1> <val1>) (<var2> <val2>)
;; ...) <body>)

(let ((a 3) (b 4))
  (+ a b)
  ) ;7

;; 局部变量只在特定的上下文里有效。另外还有一种变量叫做全局变量
;; （global variable），是在任何地方都可视的。

;; 可以使用defparameter来定义一个全局变量，
(defparameter *glob* 99)

;; 全局变量在任何地方都可以存取，除了在定义了相同名字的区域变量的表达式
;; 里。为了避免这种情形发生，通常我们在给全局变量命名时，以星号作开始与
;; 结束。刚才我们创造的变量可以念作 “星-glob-星” (star-glob-star)。

;; 你也可以用 defconstant 来定义一个全局的常量：
(defconstant limit (+ *glob* 1))

(defun show-squares (start end)
  (do ((i start (+ i 1)))
      ((> i end) 'done)
    (format t "~A ~A~%" i (* i i))))

(show-squares 2 5)
;; 



(function +)
;; equals
#'+
;; +
;; ' -- quote 等价
;; #' -- function 等价
