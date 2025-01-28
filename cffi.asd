;;;; -*- Mode: lisp; indent-tabs-mode: nil -*-
;;;
;;; cffi.asd --- ASDF system definition for CFFI.
;;;
;;; Copyright (C) 2005-2006, James Bielman  <jamesjb@jamesjb.com>
;;; Copyright (C) 2005-2010, Luis Oliveira  <loliveira@common-lisp.net>
;;;
;;; Permission is hereby granted, free of charge, to any person
;;; obtaining a copy of this software and associated documentation
;;; files (the "Software"), to deal in the Software without
;;; restriction, including without limitation the rights to use, copy,
;;; modify, merge, publish, distribute, sublicense, and/or sell copies
;;; of the Software, and to permit persons to whom the Software is
;;; furnished to do so, subject to the following conditions:
;;;
;;; The above copyright notice and this permission notice shall be
;;; included in all copies or substantial portions of the Software.
;;;
;;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;;; NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
;;; HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
;;; WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
;;; DEALINGS IN THE SOFTWARE.
;;;

(in-package :asdf)

#-(or openmcl mcl sbcl cmucl scl clisp lispworks ecl allegro cormanlisp abcl mkcl clasp)
(error "Sorry, this Lisp is not yet supported.  Patches welcome!")

(defsystem "cffi"
  :description "The Common Foreign Function Interface"
  :author "James Bielman  <jamesjb@jamesjb.com>"
  :maintainer "Luis Oliveira  <loliveira@common-lisp.net>"
  :licence "MIT"
  :defsystem-depends-on (:trivial-features)
  :depends-on ((:feature :darwin :uiop)
               :alexandria
               :babel)
  :in-order-to ((test-op (load-op :cffi-tests)))
  :perform (test-op (o c) (operate 'asdf:test-op :cffi-tests))
  :components
  ((:module "src"
    :serial t
    :components
    ((:file "package")
     (:file "sys-utils")
     (:file "cffi-openmcl" :if-feature :openmcl)
     (:file "cffi-mcl" :if-feature :mcl)
     (:file "cffi-sbcl" :if-feature :sbcl)
     (:file "cffi-cmucl" :if-feature :cmucl)
     (:file "cffi-scl" :if-feature :scl)
     (:file "cffi-clisp" :if-feature :clisp)
     (:file "cffi-lispworks" :if-feature :lispworks)
     (:file "cffi-ecl" :if-feature :ecl)
     (:file "cffi-allegro" :if-feature :allegro)
     (:file "cffi-corman" :if-feature :cormanlisp)
     (:file "cffi-abcl" :if-feature :abcl)
     (:file "cffi-mkcl" :if-feature :mkcl)
     (:file "cffi-clasp" :if-feature :clasp)
     (:file "utils")
     (:file "darwin-frameworks" :if-feature :darwin)
     (:file "libraries")
     (:file "early-types")
     (:file "types")
     (:file "enum")
     (:file "strings")
     (:file "structures")
     (:file "functions")
     (:file "foreign-vars")
     (:file "features")))))

;; when you get CFFI from git, its defsystem doesn't have a version,
;; so we assume it satisfies any version requirements whatsoever.
(defmethod version-satisfies ((c (eql (find-system :cffi))) version)
  (declare (ignorable version))
  (or (null (component-version c))
      (call-next-method)))

(defsystem "cffi/c2ffi"
  :description "CFFI definition generator from the FFI spec generated by c2ffi. This system can be used through ASDF's :DEFSYSTEM-DEPENDS-ON."
  :author "Attila Lendvai <attila@lendvai.name>"
  :depends-on (:alexandria
               :cffi
               :uiop)
  :licence "MIT"
  :components
  ((:module "src/c2ffi"
    :components
    ((:file "package")
     (:file "c2ffi" :depends-on ("package"))
     (:file "asdf" :depends-on ("package" "c2ffi"))))))

(defsystem "cffi/c2ffi-generator"
  :description "This system gets loaded lazily when the CFFI bindings need to be regenerated. This only happens if the developer chose not to include the generated binding files, or the spec file generated by c2ffi has been modified."
  :author "Attila Lendvai <attila@lendvai.name>"
  :depends-on (:cffi/c2ffi
               :cl-ppcre
               :cl-json)
  :licence "MIT"
  :components
  ((:module "src/c2ffi"
    :components
    ((:file "generator")))))
