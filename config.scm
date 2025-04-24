(use-modules (gnu)
	     (gnu services containers)
	     (gnu services docker)
	     (gnu system accounts)
	     (gnu packages shells)
	     (gnu packages package-management)
	     (nongnu packages linux)
	     (nongnu system linux-initrd)
	     (rosenthal packages networking)
	     (rosenthal services networking))
(use-service-modules cups desktop networking ssh xorg nix)


(operating-system
  (locale "en_US.utf8")
  (timezone "America/Chicago")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "Guix")
 
  (kernel linux)
  (firmware (list linux-firmware))

  (users (cons* (user-account
                  (name "ndowens")
                  (comment "Ndowens")
                  (group "users")
                  (home-directory "/home/ndowens")
                  (supplementary-groups '("wheel" "netdev" "audio" "video" "docker")))
                %base-user-accounts))


  (services
   (append (list (service plasma-desktop-service-type)
	 	 (service docker-service-type)
	 	 (service nix-service-type)
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
									       runroot=\"/home/ndowens/.containers\"\n
									       graphroot=\"/home/ndowens/.containers\"")))))
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
  		%desktop-services))

  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot"))
                (keyboard-layout keyboard-layout)))

  (file-systems (cons* (file-system
                         (mount-point "/")
                         (device (file-system-label "guix-root"))
                         (type "ext4"))
			 (file-system
			   (mount-point "/boot")
			   (device "/dev/nvme0n1p1")
			   (type "vfat")) %base-file-systems)))
