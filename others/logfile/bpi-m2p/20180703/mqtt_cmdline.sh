#!/bin/bash
LCD1602="lcd1602"
LCD1602="mosquitto_pub -t bananapi/rfid -m "

LCD="Hello, BananaPi"
RFID=""

get_rfid() {
  set -- $LCD
  RFID=$2
}

T=0
P=0
while [ 1 ] ; do
  LCD=`mosquitto_sub -C 1 -t bananapi/rfid`
  get_rfid
  echo $RFID
  case ${LCD} in
  *D0020C3047172380)
    echo "MIKEY"
    $LCD1602 "Hello!! MIKEY"
    ;;
  Felica*)
    T=`expr $T + 1`
    echo "Felica($T)"
    if [ $T -ge 10 ] ; then
      $LCD1602 "Goodbye!! BananaPi"
    fi
    if [ $T -gt 20 ] ; then
      poweroff
    fi
    ;;
  ISO1443A*)
    P=`expr $P + 1`
    echo "ISO1443A($P)"
    if [ $P -ge 10 ] ; then
      mpv /home/pi/A023_480P_AVC_AAC_839K_30F.flv
      P=0
    fi
    ;;
  *)
    if [ $T -gt 10 ] ; then
      $LCD1602 "Hello!! BananaPi"
    fi
    T=0
    P=0
    ;;
  esac
  sleep .1
done
