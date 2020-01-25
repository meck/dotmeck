function cheat -d "Query cheat.sh for documentation"
    if [ -z "$argv" ];
      echo "Usage: $_ query"
      curl https://cheat.sh/
      return
    else
      curl https://cheat.sh/$argv
    end
end
