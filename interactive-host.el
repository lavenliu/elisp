(defun newline-and-execute ()
  (interactive)
  (let ((line (current-line)))
	(run line)
	(reindent-then-newline-and-indent)))

(defun current-line ()
  "获得当前行的字符串"
  (interactive)
  (buffer-substring-no-properties
  (line-beginning-position)
  (line-end-position)))

(local-set-key (kbd "<RET>") 'newline-and-execute)
ls

df
df -h
ifconfig
ifconfig eth0
df -h
clear
(ssh->hosts)
ls
df
df -h
whoami
cat /etc/hosts
ping -c2 www.baidu.com
