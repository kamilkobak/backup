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


## Backup of all PostgreSQL databases in single file.
1) Download 'postgresql_backup.sh'
```
mkdir /root/bin/
cd /root/bin
wget https://raw.githubusercontent.com/kamilkobak/backup/master/postgresql_backup.sh
chmod +x postgresql_backup.sh
```

2) Add to cron
```
crontab -e
```
and add:
```
59 22 * * * /root/bin/postgresql_backup.sh >/dev/null 2>&1
```


