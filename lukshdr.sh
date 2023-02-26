#!/bin/sh

make_temp()
{
  G_tmpf="$(mktemp -u)"
  trap "rm -f $G_tmpf" EXIT
}

print_usage()
{
  echo "Usage: $0 backup|restore DRIVE BACKUP"
}

do_backup()
{
  make_temp

  # Backup to a temporary file
  cryptsetup luksHeaderBackup "$1" --header-backup-file "$G_tmpf"
  # Encrypt the backup
  gpg -o "$2" --symmetric "$G_tmpf"
  # Prevent other users from writin the file (TODO: do this atomically)
  chmod 400 "$2"

  exit 0
}

do_restore()
{
  make_temp

  # Decrypt the backup
  gpg -o "$G_tmpf" --decrypt "$2"
  # Backup to a temporary file
  cryptsetup luksHeaderRestore "$1" --header-backup-file "$G_tmpf"

  exit 0
}

# Check number of arguments
if [ "$#" -ne 3 ]
then
  print_usage
  exit 1
fi

case "$1" in
  backup )
    do_backup "$2" "$3"
    ;;

  restore )
    do_restore "$2" "$3"
    ;;

  * )
    print_usage
    exit 1
    ;;
esac

exit 0
