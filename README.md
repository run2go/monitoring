# monitoring
Basic monitoring shell scripts, reporting to a webhook of your choice.<br>
Prepared for discord & slack

## Configuration
The discord/slack Webhook can be defined at the top of the shell script. The former allows to define a user ID, feel free to use "@here" instead.

## Cronjob Usage
- Make it executable using `chmod +x monitoring.sh`
- Open crontab using `crontab -e`
- Then add a new entry with your preferred time schedule `*/10 * * * * /path/to/monitoring.sh`
<br>
Tip: Use <a href="https://crontab.guru/once-a-day" target="_blank" rel="noreferrer">crontab.guru</a> to generate your cron schedule expression.
