---
layout: post
title: Free Software Development
date: 2025-03-15 21:01:00
description: Logbook and notes for the free software development course at USP, 2025-1
tags: mac-courses
categories: [free software, usp]
thumbnail: https://sagaratechnology.com/blog/wp-content/uploads/2021/11/open-source-software.png
giscus_comments: true
toc:
  beginning: true
  sidebar: left
related_posts: false
citation: true
related_publications: false
_styles: ".container {
  max-width: 85%;
}"
---

## Introduction

This post is created for the Free Software Development course taught by [Professor Paulo R. M. Meirelles](https://www.ime.usp.br/paulormm/) at the [Institute of Mathematics and Statistics (IME)](https://www.ime.usp.br/) at the [University of São Paulo (USP)](https://www5.usp.br/). The course is designed and maintained by the research group [FLUSP](https://flusp.ime.usp.br/). You can find all tutorials and more detailed information on its official webpage. More information about the course (content, references, etc.) can be found on the official website Janus for the courses, [MAC5856 - Desenvolvimento de Software Livre](https://uspdigital.usp.br/janus/componente/disciplinasOferecidasInicial.jsf?action=3&sgldis=MAC5856).

The objective of the course is to introduce students to free and open source software. In Portuguese, both terms mean the same. The course covers basic concepts, appropriate languages, ethical and technical aspects, etc., with the goal of promoting and constructing open and collaborative software.

> **NOTE**
>
> The device used for the course is a Lenovo laptop with Ubuntu 24.04.2 LTS.

## Tutorial 1: Setting up a test environment for Linux Kernel

The first tutorial of the course provides an introduction to [QEMU](https://github.com/QEMU) and [libvirt](https://github.com/libvirt), powerful tools designed to deploy virtual machines (VMs) quickly and efficiently, eliminating the traditional complexities and time-consuming efforts typically associated with VM setup. Both QEMU and libvirt are libraries used for virtualization and resource emulation, enabling users to create and manage virtualized environments with ease.

A detailed guide can be found at: [Setting up a test environment for Linux Kernel Dev using QEMU and libvirt](https://flusp.ime.usp.br/kernel/qemu-libvirt-setup/).

### Summary

The tutorial is divided into the following sections:

1. Preparing testing environment directory and “all-in-one” script

   - Create necessary folders and files.
   - Give the required permissions for files and folders.

2. Set up and configure a VM running a guest OS

   - Create an `activate.sh` file to deploy VMs manager. To enable it, execute the comand `/path_to/activate.sh`, this will print some green text and a pink prompt preamble to .
   - Check image OS properties and partition size, then resize the disk image to 5Gb to give space for more linux modules.
   - Extract kernel and initrd images from OS image to create the VM

3. Configure SSH access from the host to the VM
4. Set up host <-> VM file sharing (optional)

To start a created machine use `sudo virsh start --console arm64`.

### Troubleshooting

#### SSH Configuration

At point 3, if the `/etc/ssh/` folder is missing, it indicates that SSH is not installed on the system. To resolve this issue, follow these steps:

1. Update and upgrade the system packages:

   ```bash
   sudo apt update && sudo apt upgrade
   ```

2. Install the OpenSSH server package to enable SSH functionality:

   ```bash
   sudo apt install openssh-server
   ```

This will download and configure the necessary SSH dependencies, allowing you to establish an SSH connection.

#### Shared Memory

Blog to solve the shared memory issue: https://discourse.nixos.org/t/virt-manager-cannot-find-virtiofsd/26752/9

`EDITOR=nano; virsh edit arm64`

### Parctical excersie: Ubuntu Jammy kernel

As a practical exercise, let's create a VM using an Ubuntu image. Since the previous image is lightweight, let's test with a more robust image.

1. Add environment constants and functions to the "all-in-one" script:

   ```bash
   ++activate.sh

   export BOOT_DIR_UBUNTU="${VM_DIR}/ubuntu-jammy-arm64" # path to boot artifacts

   # ---------- ubuntu image -----------
   function launch_ubuntu_vm_qemu() {
       qemu-system-aarch64 \
           -M virt,gic-version=3 \
           -m 7G -cpu cortex-a57 \
           -smp 2 \
           -netdev user,id=net0 -device virtio-net-device,netdev=net0 \
           -initrd "${BOOT_DIR_UBUNTU}/initrd.img-5.15.0-134-generic-lpae" \
           -kernel "${BOOT_DIR_UBUNTU}/vmlinuz-5.15.0-134-generic-lpae" \
           -append "loglevel=8 root=/dev/vda2 rootwait" \
           -device virtio-blk-pci,drive=hd \
           -drive if=none,file="${VM_DIR}/ubuntu-jammy-arm64.qcow2",format=qcow2,id=hd \
           -nographic
   }

   function create_ubuntu_vm_virsh() {
       sudo virt-install \
         --name "ubuntu-jammy" \
         --memory 2048 \
         --arch aarch64 --machine virt \
         --osinfo detect=on,require=off \
         --import \
         --features acpi=off \
         --disk path="${VM_DIR}/ubuntu-jammy-arm64.qcow2" \
         --boot kernel=${BOOT_DIR_UBUNTU}/vmlinuz-5.15.0-134-generic-lpae,initrd=${BOOT_DIR_UBUNTU}/initrd.img-5.15.0-134-generic-lpae,kernel_args="loglevel=8 root=/dev/vda2 rootwait" \
         --network bridge:virbr0 \
         --graphics none
   }

   export -f launch_ubuntu_vm_qemu
   export -f create_ubuntu_vm_virsh
   ```

2. Set up and configure a VM

   2.1. Download image

   ```bash
   wget --directory-prefix="${VM_DIR}" https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-armhf.img
   mv "${VM_DIR}/jammy-server-cloudimg-armhf.img" "${VM_DIR}/ubuntu-jammy-arm64.qcow2" # rename file for legibility
   ```

   The kernel downloaded is Debian-12-nocloud-arm64-daily-20250217-2026.qcow2, an image for QEMU without cloud settings and arm64 architecture, [link to download](http://cdimage.debian.org/cdimage/cloud/bookworm/daily/20250217-2026/debian-12-nocloud-arm64-daily-20250217-2026.qcow2). As practice excersie let's download an Ubuntu arm image, [Ubuntu 22.04 LTS (Jammy Jellyfish)](https://cloud-images.ubuntu.com/jammy/current/), select any QCow2 image, note that this image contains a cloud setup.

   2.2. Resize disk image

   ```bash
   du -h "ubuntu-jammy-arm64.qcow2"
   ```

   Output:

   ```bash
   1,2G	base-jammy-server-cloudimg-armhf.img
   ```

   ```bash
   qemu-img info "${VM_DIR}/ubuntu-jammy-arm64.qcow2"
   ```

   Output:

   ```bash
   image: base-jammy-server-cloudimg-armhf.img
   file format: qcow2
   virtual size: 3.5 GiB (3758096384 bytes)
   disk size: 1.15 GiB
   cluster_size: 65536
   Format specific information:
       compat: 0.10
       compression type: zlib
       refcount bits: 16
   Child node '/file':
       filename: base-jammy-server-cloudimg-armhf.img
       protocol type: file
       file length: 1.15 GiB (1233318400 bytes)
       disk size: 1.15 GiB
   ```

   ```bash
   virt-filesystems --long --human-readable --all --add "${VM_DIR}/ubuntu-jammy-arm64.qcow2"
   ```

   Output:

   ```bash
   Name        Type        VFS   Label            MBR  Size  Parent
   /dev/sda1   filesystem  ext4  cloudimg-rootfs  -    3,2G  -
   /dev/sda15  filesystem  vfat  UEFI             -    97M   -
   /dev/sda1   partition   -     -                -    3,4G  /dev/sda
   /dev/sda15  partition   -     -                -    99M   /dev/sda
   /dev/sda    device      -     -                -    3,5G  -
   ```

   ```bash
   qemu-img create -f qcow2 -o preallocation=metadata "${VM_DIR}/ubuntu-jammy-arm64.qcow2" 7G # creates new QCOW2 image with 5GB
   virt-resize --expand /dev/sda1 "${VM_DIR}/base-jammy-server-cloudimg-armhf.img" "${VM_DIR}/arm64_img.qcow2" # makes a copy of the image expanding the `rootfs`
   ```

   ```bash
   Name       Type        VFS   Label            MBR  Size  Parent
   /dev/sda1  filesystem  vfat  UEFI             -    97M   -
   /dev/sda2  filesystem  ext4  cloudimg-rootfs  -    6,6G  -
   /dev/sda1  partition   -     -                -    99M   /dev/sda
   /dev/sda2  partition   -     -                -    6,9G  /dev/sda
   /dev/sda   device      -     -                -    7,0G  -
   ```

```text
initrd.img-5.15.0-134-generic-lpae
vmlinuz-5.15.0-134-generic-lpae
```

> **Useful Commands**
>
> - `lsmod` - Show the status of modules in the Linux Kernel, more info [here](https://manpages.ubuntu.com/manpages/trusty/man8/lsmod.8.html).

<div class="row mt-3" style="width:70%; margin: 0 auto 0 auto;">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/flusp/9.jpg" class="img-fluid rounded z-depth-1" zoomable=true%}
    </div>
</div>
<div class="caption">
    A simple, elegant caption looks good between image rows, after each row, or doesn't have to be there at all.
</div>

## Tutorial 2: Building and booting a custom Linux kernel for ARM using kw

asd

A detailed guide can be found at: [Building and booting a custom Linux kernel for ARM using kw](https://flusp.ime.usp.br/kernel/build-linux-for-arm-kw/)

### Parts

find ~/ -type f -name "postgis-2.0.0"

### Troubleshooting

### Results

<!-- {% cite flusp %} -->

## Tutorial 3: Introduction to Linux kernel build configuration and modules

### Parts

find ~/ -type f -name "postgis-2.0.0"

### Troubleshooting

### Results

## Tutorial 4

### Parts

### Troubleshooting

### Results

## Tutorial 5

### Parts

### Troubleshooting

### Results

## Tutorial 6

### Parts

### Troubleshooting

### Results

## Tutorial 7

### Parts

### Troubleshooting

### Results

## Tutorial 8

### Parts

### Troubleshooting

### Results
