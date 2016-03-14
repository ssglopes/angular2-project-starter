# angular2-project-starter

Make sure before executing the command below that /var/www is writable.
The command will download a .sh script and execute it.

What does the script?
The script creates an app directory inside /var/www if it's not created.
It will also install a virtual host into the /etc/apache2 directory if the app.conf is not found.
It will add the projectname to the /etc/hosts file
It will start download all required files needed for the angular 2 project inside /var/www/app/<project-name>

After execution has finished open a browser and go to either:
http://localhost:8080/ => for developement webpack server url
http://www.<project-name>.app => transpiled files

To install open a terminal and execute the following command:
wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/install.angular2.project.sh -P /var/www/ && chmod +x /var/www/install.angular2.project.sh && ./install.angular2.project.sh <project-name[string]> <bootstrap-version[int]>

Replace <project-name[string]> with the project name.
Replace <bootstrap-version[int]> with the bootstrap version to use for the project, either 3 or 4.

