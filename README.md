# Backup scripts
## Backup of all MySQL databases in separate files.
1) Download `mysql_backup.sh`
```
mkdir /root/bin/
cd /root/bin
wget https://raw.githubusercontent.com/kamilkobak/backup/master/mysql_backup.sh
chmod +x mysql_backup.sh
```
2) Add to cron
```
crontab -e
```
and add:
```
59 23 * * * /root/bin/mysql_backup.sh >/dev/null 2>&1
```

