#!/usr/bin/env bash
IP=192.168.54.20
case "$1" in  
  "music")
          NCMPCPP=1 ssh -o SendEnv=NCMPCPP szabi@$IP -p 1922
          ;;
  "szabi")
          ssh szabi@$IP -p 1922
          ;;
  "mount")
          sudo mount -t cifs //$IP/shared /mnt/vacak -o credentials=~/.samba/vacak.credentials,iocharset=utf8
          ;;
  "umount")
          sudo umount /mnt/vacak
          ;;
esac
