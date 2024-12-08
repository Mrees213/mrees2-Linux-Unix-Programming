ip addr | grep 'inet 10' | awk '{print $2}' | cut -d'/' -f1
