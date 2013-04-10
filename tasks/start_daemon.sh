rm -rf /home/goggin/projects/hyper/daemon_1_dir
mkdir /home/goggin/projects/hyper/daemon_1_dir
rm -rf /home/goggin/projects/hyper/daemon_1_data
mkdir /home/goggin/projects/hyper/daemon_1_data

cd /home/goggin/projects/hyper/daemon_1_dir
/home/goggin/projects/install/bin/hyperdex daemon -f --listen=127.0.0.1 --listen-port=2012 \
                       --coordinator=127.0.0.1 --coordinator-port=1982 --data=/home/goggin/projects/hyper/daemon_1_data

