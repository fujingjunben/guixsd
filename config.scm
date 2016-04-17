;; This is an operating system configuration template
;; for a "desktop" setup with GNOME and Xfce.

(use-modules (gnu) (gnu system nss))
(use-service-modules desktop)
(use-service-modules ssh)
(use-package-modules vim)
(use-package-modules emacs)
(use-package-modules ssh)
(use-package-modules certs)

(operating-system
  (host-name "antelope")
  (timezone "Asia/Shanghai")
  (locale "en_US.UTF-8")

  ;; Assuming /dev/sdX is the target hard disk, and "my-root"
  ;; is the label of the target root file system.
  (bootloader (grub-configuration (device "/dev/sdb")))
  (file-systems (cons (file-system
                        (device "guixsd")
                        (title 'label)
                        (mount-point "/")
                        (type "ext4"))
                      %base-file-systems))

  (users (cons (user-account
                (name "lhk")
                (comment "liu haikuan")
                (group "users")
                (supplementary-groups '("wheel" "netdev"
                                        "audio" "video"))
                (home-directory "/home/lhk"))
               %base-user-accounts))

  ;; This is where we specify system-wide packages.
  (packages (cons* nss-certs         ;for HTTPS access
                 openssh
                 vim
                 emacs  
                 %base-packages))

  ;; Add GNOME and/or Xfce---we can choose at the log-in
  ;; screen with F1.  Use the "desktop" services, which
  ;; include the X11 log-in service, networking with Wicd,
  ;; and more.
  (services (cons* (gnome-desktop-service)
                   (xfce-desktop-service)
                   (lsh-service #:port-number 2222)
                   %desktop-services))

  ;; Allow resolution of '.local' host names with mDNS.
  (name-service-switch %mdns-host-lookup-nss))
