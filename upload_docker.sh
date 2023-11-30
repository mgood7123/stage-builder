if [[ $# < 1 ]]
	then
		echo "must suuply an image id"
		exit 1
fi

sudo docker image tag $1 git_local_ubuntu:23.10
sudo docker image save "git_local_ubuntu:23.10" > ubuntu.tar
xz -9 -e -v ubuntu.tar
rm ubuntu.tar
git add ubuntu.tar.xz
git commit -am "update docker image"
git push
