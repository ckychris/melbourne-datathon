# melbourne-datathon

kaggle branch -- to test out predictive models.

On a new ubuntu VM, perform the following:

~~~
useradd kaggle
apt-get install zip
su - kaggle
tmux
git clone https://github.com/nfaggian/melbourne-datathon.git
cd melbourne-datathon
git checkout kaggle
bash build.sh
~~~

Once completed a tmux session will have a notebook server running (on default ports), with the password set to "bomfire".

Since you are using tmux you can now close the connection to the server.
