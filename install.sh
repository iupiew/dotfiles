# installation script
echo "This may override some files and folders in .config"

# Prompt for user confirmation
while true; do
    read -r -p "Do you want to continue? (y/N): " response
    response=${response:-N}  # Default to 'N' if no input is provided
    case $response in
        [Yy]* ) 
            echo "Proceeding with installation..."
            break
            ;;
        [Nn]* ) 
            echo "Installation aborted."
            exit 1
            ;;
        * ) 
            echo "Please answer Y or n."
            ;;
    esac
done

echo "Installing..."
sleep 2


