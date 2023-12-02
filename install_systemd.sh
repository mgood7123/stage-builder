# stop on first error

set -e

echo creating
CONTAINER=$(sudo docker container create --user ubuntu --workdir /home/ubuntu --tmpfs /tmp --tmpfs /run --tty --ulimit nofile=262144:262144 --name git_local_ubuntu git_local_ubuntu:23.10 /bin/bash -i)
echo CONTAINER = $CONTAINER
echo starting
sudo docker container start $CONTAINER
sudo docker container exec -it --user root $CONTAINER apt install -y apt-utils
sudo docker container exec -it --user root $CONTAINER apt install -y libterm-readline-gnu-perl
sudo docker container exec -it --user root $CONTAINER apt install -y systemd systemd-sysv systemd-dev
echo commiting to image
sudo docker container commit $CONTAINER git_local_ubuntu-systemd:23.10
echo stopping
sudo docker container stop $CONTAINER
echo removing
sudo docker container rm $CONTAINER

echo creating
CONTAINER=$(sudo docker container create --user root --workdir /home/root --tmpfs /tmp --tty --cap-add SYS_ADMIN --cgroup-parent docker.slice --security-opt apparmor:unconfined --security-opt seccomp=unconfined --ulimit nofile=262144:262144 -v /sys/fs/cgroup:/sys/fs/cgroup:rw --cgroupns host --name git_local_ubuntu git_local_ubuntu-systemd:23.10 /sbin/init)
echo CONTAINER = $CONTAINER
echo starting
sudo docker container start $CONTAINER
sudo docker container exec $CONTAINER bash -c "sleep 5 ; systemctl --wait is-system-running || sysctl --failed"
sudo docker container exec $CONTAINER bash -c "echo 'ubuntu ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/ubuntu"
echo "creating user session"
sudo docker container exec --user ubuntu --workdir /home/ubuntu $CONTAINER bash -c "sudo mkdir -p /run/user/$(id -u ubuntu)"
sudo docker container exec --user ubuntu --workdir /home/ubuntu $CONTAINER bash -c "sudo chown ubuntu:ubuntu /run/user/$(id -u ubuntu)"
sudo docker container exec --user ubuntu --workdir /home/ubuntu $CONTAINER bash -c "sudo systemctl start user@$(id -u ubuntu)"
echo "created user session"
sudo docker container exec --user ubuntu --workdir /home/ubuntu -it $CONTAINER bash -c "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u ubuntu)/bus systemd-run --user --scope --collect /bin/bash -c \"systemctl status --system\""
sudo docker container exec --user ubuntu --workdir /home/ubuntu -it $CONTAINER bash -c "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u ubuntu)/bus systemd-run --user --scope --collect /bin/bash -c \"systemctl status --user\""
sudo docker container exec --user ubuntu --workdir /home/ubuntu -it $CONTAINER bash -c "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u ubuntu)/bus systemd-run --user --scope --collect /bin/bash -c \"sudo apt install -y polkitd pkexec polkitd-pkla\""
echo commiting to image
sudo docker container commit $CONTAINER git_local_ubuntu-systemd-polkitd:23.10
echo stopping
sudo docker container stop $CONTAINER
echo removing
sudo docker container rm $CONTAINER

echo creating
CONTAINER=$(sudo docker container create --user root --workdir /home/root --tmpfs /tmp --tty --cap-add SYS_ADMIN --cgroup-parent docker.slice --security-opt apparmor:unconfined --security-opt seccomp=unconfined --ulimit nofile=262144:262144 -v /sys/fs/cgroup:/sys/fs/cgroup:rw --cgroupns host --name git_local_ubuntu git_local_ubuntu-systemd-polkitd:23.10 /sbin/init)
echo CONTAINER = $CONTAINER
echo starting
sudo docker container start $CONTAINER
sudo docker container exec $CONTAINER bash -c "sleep 5 ; systemctl --wait is-system-running || sysctl --failed"
echo "creating user session"
sudo docker container exec --user ubuntu --workdir /home/ubuntu $CONTAINER bash -c "sudo mkdir -p /run/user/$(id -u ubuntu)"
sudo docker container exec --user ubuntu --workdir /home/ubuntu $CONTAINER bash -c "sudo chown ubuntu:ubuntu /run/user/$(id -u ubuntu)"
sudo docker container exec --user ubuntu --workdir /home/ubuntu $CONTAINER bash -c "sudo systemctl start user@$(id -u ubuntu)"
echo "created user session"
sudo docker container exec --user ubuntu --workdir /home/ubuntu -it $CONTAINER bash -c "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u ubuntu)/bus systemd-run --user --scope --collect /bin/bash -c \"systemctl status --system\""
sudo docker container exec --user ubuntu --workdir /home/ubuntu -it $CONTAINER bash -c "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u ubuntu)/bus systemd-run --user --scope --collect /bin/bash -c \"systemctl status --user\""
sudo docker container exec --user ubuntu --workdir /home/ubuntu -it $CONTAINER bash -c "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u ubuntu)/bus systemd-run --user --scope --collect /bin/bash -c \"sudo apt install -y flatpak flatpak-builder\""
echo commiting to image
sudo docker container commit $CONTAINER git_local_ubuntu-systemd-polkitd-flatpak:23.10
echo stopping
sudo docker container stop $CONTAINER
echo removing
sudo docker container rm $CONTAINER

echo creating
CONTAINER=$(sudo docker container create --user root --workdir /home/root --tmpfs /tmp --tty --cap-add SYS_ADMIN --cgroup-parent docker.slice --security-opt apparmor:unconfined --security-opt seccomp=unconfined --ulimit nofile=262144:262144 -v /sys/fs/cgroup:/sys/fs/cgroup:rw --cgroupns host --name git_local_ubuntu git_local_ubuntu-systemd-polkitd-flatpak:23.10 /sbin/init)
echo CONTAINER = $CONTAINER
echo starting
sudo docker container start $CONTAINER
sudo docker container exec $CONTAINER bash -c "sleep 5 ; systemctl --wait is-system-running || sysctl --failed"
echo "creating user session"
sudo docker container exec --user ubuntu --workdir /home/ubuntu $CONTAINER bash -c "sudo mkdir -p /run/user/$(id -u ubuntu)"
sudo docker container exec --user ubuntu --workdir /home/ubuntu $CONTAINER bash -c "sudo chown ubuntu:ubuntu /run/user/$(id -u ubuntu)"
sudo docker container exec --user ubuntu --workdir /home/ubuntu $CONTAINER bash -c "sudo systemctl start user@$(id -u ubuntu)"
echo "created user session"
sudo docker container exec --user ubuntu --workdir /home/ubuntu -it $CONTAINER bash -c "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u ubuntu)/bus systemd-run --user --scope --collect /bin/bash -c \"systemctl status --system\""
sudo docker container exec --user ubuntu --workdir /home/ubuntu -it $CONTAINER bash -c "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u ubuntu)/bus systemd-run --user --scope --collect /bin/bash -c \"systemctl status --user\""
sudo docker container exec --user ubuntu --workdir /home/ubuntu -it $CONTAINER bash -c "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u ubuntu)/bus systemd-run --user --scope --collect /bin/bash -c \"sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo\""
sudo docker container exec --user ubuntu --workdir /home/ubuntu -it $CONTAINER bash -c "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u ubuntu)/bus systemd-run --user --scope --collect /bin/bash -c \"sudo flatpak install -y flathub org.freedesktop.Platform//23.08 org.freedesktop.Sdk//23.08\""
echo commiting to image
sudo docker container commit $CONTAINER git_local_ubuntu-systemd-polkitd-flatpak:23.10
echo stopping
sudo docker container stop $CONTAINER
echo removing
sudo docker container rm $CONTAINER

echo creating
CONTAINER=$(sudo docker container create --user root --workdir /home/root --tmpfs /tmp --tty --cap-add SYS_ADMIN --cap-add NET_ADMIN --privileged --cgroup-parent docker.slice --security-opt apparmor:unconfined --security-opt seccomp=unconfined --ulimit nofile=262144:262144 -v /sys/fs/cgroup:/sys/fs/cgroup:rw --cgroupns host --name git_local_ubuntu git_local_ubuntu-systemd-polkitd-flatpak:23.10 /sbin/init)
echo CONTAINER = $CONTAINER
echo starting
sudo docker container start $CONTAINER
sudo docker container exec $CONTAINER bash -c "sleep 5 ; systemctl --wait is-system-running || sysctl --failed"
sudo docker container exec $CONTAINER bash -c "systemctl status --system"
sudo docker container exec $CONTAINER bash -c "echo 'ubuntu ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/ubuntu"
echo "creating user session"
sudo docker container exec --user ubuntu --workdir /home/ubuntu $CONTAINER bash -c "sudo mkdir -p /run/user/$(id -u ubuntu)"
sudo docker container exec --user ubuntu --workdir /home/ubuntu $CONTAINER bash -c "sudo chown ubuntu:ubuntu /run/user/$(id -u ubuntu)"
sudo docker container exec --user ubuntu --workdir /home/ubuntu $CONTAINER bash -c "sudo systemctl start user@$(id -u ubuntu)"
echo "created user session"
sudo docker container exec --user ubuntu --workdir /home/ubuntu -it $CONTAINER bash -c "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u ubuntu)/bus systemd-run --user --scope --collect /bin/bash -c \"systemctl status --system\""
sudo docker container exec --user ubuntu --workdir /home/ubuntu -it $CONTAINER bash -c "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u ubuntu)/bus systemd-run --user --scope --collect /bin/bash -c \"systemctl status --user\""
cat << EOF > install_systemd_tmp.sh
set -e
sudo docker cp flat.sh $CONTAINER:/home/ubuntu/flat.sh
sudo docker container exec --user ubuntu --workdir /home/ubuntu -it $CONTAINER bash -c "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u ubuntu)/bus systemd-run --user --scope --collect /bin/bash -c \"chmod +x flat.sh ; ./flat.sh\""
echo "launch interactive shell"
sudo docker container exec --user ubuntu --workdir /home/ubuntu -it $CONTAINER bash -c "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u ubuntu)/bus systemd-run --user --scope --collect /bin/bash -i"
EOF
chmod +x install_systemd_tmp.sh
./install_systemd_tmp.sh || true
echo stopping
sudo docker container stop $CONTAINER
echo removing
sudo docker container rm $CONTAINER