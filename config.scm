;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu)
	     (gnu services containers)
	     (gnu services docker)
	     (gnu system accounts)
	     (rosenthal packages networking)
	     (rosenthal services networking))
(use-service-modules cups desktop networking ssh xorg)


(operating-system
  (locale "en_US.utf8")
  (timezone "America/Chicago")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "Guix")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "ndowens")
                  (comment "Ndowens")
                  (group "users")
                  (home-directory "/home/ndowens")
                  (supplementary-groups '("wheel" "netdev" "audio" "video" "docker")))
                %base-user-accounts))


  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append (list (service xfce-desktop-service-type)
	 	 (service docker-service-type)
		 (service tailscale-service-type)
		 (service openssh-service-type)
		 (service containerd-service-type)
                 (set-xorg-configuration
                  (xorg-configuration (keyboard-layout keyboard-layout))))
	   (list (simple-service 'container
				etc-service-type
				`(("containers/storage.conf" ,(plain-file "storage.conf"
									       "[storage]\n
									       driver=\"overlay\"\n
									       runroot=\"/run/containers\"\n
									       graphroot=\"/run/containers\"")))))
	   (list (simple-service 'container-policy
				 etc-service-type
				 `(("containers/policy.json" ,(local-file "./policy.json")))))

	   (list (simple-service 'add-nonguix-substitutes
                               guix-service-type
                               (guix-extension
                                (substitute-urls
                                 (append (list "https://substitutes.nonguix.org")
                                         %default-substitute-urls))
                                (authorized-keys
                                 (append (list (plain-file "nonguix.pub"
                                                           "(public-key (ecc (curve Ed25519) (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))
                                         %default-authorized-guix-keys)))))
           ;; This is the default list of services we
           ;; are appending to.
  		%desktop-services))

  (bootloader (bootloader-configuration
                (bootloader grub-bootloader)
                (targets (list "/dev/vda"))
                (keyboard-layout keyboard-layout)))
  (swap-devices (list (swap-space
                        (target (uuid
                                 "1bfb6271-4c4b-4a42-abd0-bc4e179db0fb")))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/")
                         (device (uuid
                                  "546e2164-6215-4d01-9783-6b86fbcd0788"
                                  'ext4))
                         (type "ext4")) %base-file-systems)))
