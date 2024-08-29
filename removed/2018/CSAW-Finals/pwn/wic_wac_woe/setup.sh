cat > /etc/supervisor/conf.d/supervisord.conf <<EOF
[supervisord]
nodaemon=true

[program:app]
command=stdbuf -o0 gunicorn -w 4 server:app -b 0.0.0.0:8080 --user app --access-logfile -
directory=/server
stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0
EOF
