;; 主机IP地址
(defvar *hosts* '("192.168.20.158" "192.168.20.159"))

;; 在表达式末尾按C-j可以求值

(defun ssh->hosts ()
  "SSH到列表中的主机"
  (dolist (host *hosts*)
	(shell host)
	(insert (format "ssh root@%s" host))
	(comint-send-input)))

(defun run (command)
  "执行Shell命令"
  (let ((current-buf (current-buffer)))
	(dolist (host *hosts*)
	  (shell host)
	  (insert command)
	  (comint-send-input))
	(switch-to-buffer current-buf)))
