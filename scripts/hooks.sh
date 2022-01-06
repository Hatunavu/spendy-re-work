if [ -d ".git/hooks" ]
then
sudo mv .git/hooks .git/hooks.old && ln -s ../scripts/hooks .git/hooks
else
sudo ln -s ../scripts/hooks .git/hooks
fi