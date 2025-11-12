;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(message "Starting build-site.el")
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
;;(require 'ob-tangle)
;;(require 'ox-latex)
;;(require 'ox-html)

;; TODO capability of auto evaluation on publish to be added some day
;; enable evaluation of code blocks when website is published
;;(setq org-confirm-babel-evaluate nil)
;;(setq org-export-babel-evaluate t)
;;(setq org-export-use-babel t)
;;(org-babel-do-load-languages
;; 'org-babel-load-languages
;; '((emacs-lisp . t)))


;; customization
(setq org-html-validation-link nil)
(setq org-html-head-include-scripts nil) ;;don't load default scripts
(setq org-html-head-include-default-styles nil) ;;to enable own styles later

;; simple.min directly from URL
;;(setq org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />")

;; simple.css downloaded from the URL's github page
;;(setq org-html-head "<link rel=\"stylesheet\" href=\"css/simple.css\" />")

;; simple.css modified for my own styles
(setq org-html-head
      "
<link rel='stylesheet' href='gs_simple.css' />
<script type='text/javascript' src='gs_simple.js'></script>
")
                                        ;<link rel='stylesheet' href='css/gs_simple.css' />
                                        ;<script type='text/javascript' src='js/gs_simple.js'></script>

;; preamble (style defined in CSS)
(setq org-html-preamble
      "
<center>
<nav>
<a href=\"/index.html\">Home</a>
<a href=\"/research.html\">Research</a>
<a href=\"/teaching.html\">Teaching</a>
<a href=\"/students.html\">Students</a>
</nav>
</center>
")

;; try again with div and try to fix with CSS (#navbar) and JS for sticky headers
;;  id=\"navbar\"

;; postamble
(setq org-html-postamble
      "
<footer>
Contact:
<a href='mailto:gauravs@iitgn.ac.in'>gauravs@iitgn.ac.in</a> (Work) |
<a href='mailto:it.gaurav@gmail.com'>it.gaurav@gmail.com</a> (Personal)
<br>
Created completely through <a href='https://www.gnu.org/software/emacs/'>Gnu Emacs</a> and <a href='https://orgmode.org'>Org Mode</a> (<a href='https://github.com/gaurav-iitgn/gaurav-iitgn.github.io'>source code</a>)
</footer>
")

;; define the publishing project
(setq org-publish-project-alist
      (list
       (list "my-org-site"
             :recursive t
             :base-directory "./content"
             :base-extension "org"
             :publishing-directory "./public"
             :publishing-function 'org-html-publish-to-html
             :with-author t
             :with-creator t
             :with-toc t
             :auto-sitemap t
             :section-numbers nil
             :time-stamp-file t)
       (list "my-org-site-static"
             :recursive t
             :base-directory "./content"
             :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg"
             :publishing-directory "./public"
             :publishing-function 'org-publish-attachment)))

;; generate the output
(org-publish-all t)

(message "Build Completed!")
