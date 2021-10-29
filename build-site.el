;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)


;;This is needed only for displaying on localhost
;;(use-package simple-httpd
;;	:ensure t)

;; Load publishing system
(require 'ox-publish)

;; customization
(setq org-html-validation-link nil)
(setq org-html-head-include-scripts nil) ;;don't load default scripts
(setq org-html-head-include-default-styles nil) ;;to enable own styles later
(setq org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />")

;; define the publishing project
(setq org-publish-project-alist
			(list
			 (list "my-org-site"
						 :recursive t
						 :base-directory "./content"
						 :publishing-directory "./public"
						 :publishing-function 'org-html-publish-to-html
						 :with-author t
						 :with-creator t
						 :with-toc nil
						 :section-numbers nil
						 :time-stamp-file t)))

;; generate the output
(org-publish-all t)

(message "Build Completed!")
