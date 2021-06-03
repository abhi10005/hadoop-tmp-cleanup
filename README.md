# hadoop-tmp-cleanup


What do these scripts do?
-------------------------

These scripts can be used to cleanup the data present in the temporary directories created during Hadoop job execution. Generally, these folders, along with application logs, get cleaned up as soon as jobs finish. However, in order to retain application logs for the longer duration, cleanup gets postponed. The side effect is- disk space starts getting filled with the data not so useful (The data in /tmp can grow exponentially if not addressed periodically).

Hence, this script was created with sole intention of keeping the logs, but removing the tmp folders on periodic intervals.

More details can be found on this article: <medium article>

  
Configuration
-------------
  
The default namenode IP is of the local machine where this script would run. The correct IP can be provided in the **namenode_ip** present in **hadoop-tmp-cleanup.sh**.

The script is configured to run at the interval of every 120 seconds. This can also be configured as per the requirement by tweaking the sleep paramenter in **hadoop-tmp-cleanup.sh**

Please configure the appropriate tmp directory as **application_dir** in the **hadoop-tmp-cleanup.sh**


  
  
How does it work?
-----------------
**Note**: You need to have root access to complete the process.
  
It is a Linux based script containing followings:
  1. Script file **hadoop-tmp-cleanup.sh** which gets executed to remove temporary files present in /tmp. (Please check where the tmp files get generated for your environment. By default, it is /tmp directory. However, this can be customized to a different location than usual)
  2. Service file **hadoop-tmp-cleanup.service** which needs to be present in **/etc/systemd/system/**. Please make sure to specify correct path for **hadoop-tmp-cleanup.sh** in **hadoop-tmp-cleanup.service**
  
  
 Commands:
 --------
  
**Start service**
  
sudo systemctl start hadoop-tmp-cleanup
  
  
**Check service status**
  
sudo systemctl status hadoop-tmp-cleanup

  
**Check logs**
  
  less /var/log/syslog
  
  OR
  
  sudo journalctl -u hadoop-tmp-cleanup  # to tail use -f
  
  
**Enable service on startup**
  
  sudo systemctl enable hadoop-tmp-cleanup
  
  
**Reload service file after manually edit**
  
  sudo systemctl daemon-reload
  
  
**Restart service**
  
  sudo systemctl restart hadoop-tmp-cleanup
  
  
**Edit service - No need to run daemon-reload**
  
  sudo systemctl edit hadoop-tmp-cleanup --full
