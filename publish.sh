
rsync -av --delete "/home/francesco/Documents/Obsidian Vault/static" "/home/francesco/Desktop/EmotionalData/"


echo "copy images"

  

rsync -av --delete "/home/francesco/Documents/Obsidian Vault/posts" "/home/francesco/Desktop/EmotionalData/content"

  

echo "copy posts"

# with rsync i copy all my images and blog's posts into my hugo folders


echo "Connecting to GH via ssh"

hugo

ssh -T git@github.com

  

echo "push changes into EmotionalData.git repo"


git add .

git commit -m "Create new post !! :D "

git push

  

echo "everything fine and up to date"