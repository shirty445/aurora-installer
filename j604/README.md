# J604 developer installer

This experimental branch carries the J604 6 GiB stub, firmware selection,
64 KiB raw boot-object padding and BCM4388C2 opt-in in the source backend.
The native runtime integration permits the standalone restore-image decoder.
The existing source locks, signing configuration and other board admission
rules are preserved. This is not a qualified public installer release.

The hardware-tested installation used installer-v0.9.2-aurora.14.tar.gz plus
the two patches in packaged-engine-patches/. Apply these with patch -p1
inside an extracted copy of that release engine, in numbered order. They
preserve its runtime factory wiring. The source backend differs from the
packaged runtime, so these release patches deliberately retain their original
paths. A new native app/package has not been built or physically installed.

The 64 KiB padding rule was supplied from GravityLinux installer commit
6420623: https://github.com/GravityLinux/installer/commit/6420623
Guam collection uses the existing public Aurora firmware packager; firmware
bytes, device captures, passwords and installed-machine configuration are
not included in this repository.
