function update-all -d "Update everything in the user Env"
 echo "Updating Yadm..."
 yadm pull --ff-only

 echo "Updating Yadm submodules..."
 yadm submodule update --init --recursive

 if functions -q brewme
   echo "Updating Homebrew..."
   brewme
 end

 echo "Updating Fisher..."
 fisher

 echo "Updating Neovim Plugins..."
 nvim +PlugUpdate +qa
end
