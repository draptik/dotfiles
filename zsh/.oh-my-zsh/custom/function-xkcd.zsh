# XKCD
# Add this to your .bashrc or if you are using oh-my-zsh add a functions.zsh file under your oh-my-zsh/custom folder.

# Requirements:
# - Kitty terminal
# - jq
# - ImageMagick

function xkcd () {
    comicNum=$1
    newestJson=$(curl -s https://xkcd.com/info.0.json)
    newestNum=$(jq -r .num <<< $newestJson)

    if [[ "$1" != "newest" ]] ; then
        re='^[0-9]+$'
        # Check if argument is not "new", not a number or otherwise not valid and select random comic
        if ! [[ $1 =~ $re ]] || [[ comicNum -lt 1 ]] || [[ "$comicNum" -gt "$newestNum" ]] ; then
            # Generate a random comic number if none is specified
            comicNum=$((1 + $RANDOM % $newestNum))
        fi

        # Get xkcd by number
        json=$(curl -s https://xkcd.com/$comicNum/info.0.json)
    else
        # Use newest
        comicNum=$newestNum
        json=$newestJson
    fi
    

    # Parse response using jq
    url=$(jq -r .img <<< $json)
    title=$(jq -r .title <<< $json)
    alt=$(jq -r .alt <<< $json)
    transcript=$(jq -r .transcript <<< $json)
    date="$(jq -r .day <<< $json).$(jq -r .month <<< $json).$(jq -r .year <<< $json)"
    
    echo $url
    echo "\n\"$title\"\n"
    echo "#$comicNum -- $date\n"
    
    # Display the image using icat or alternatively print the alt-text and transcript of the comic
    kitty +kitten icat --align left $url || echo $transcript
    echo "\n\"$alt\"\n"
}
