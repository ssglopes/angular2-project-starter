# angular2-project-starter

<strong>Installation</strong><br />
<p>Make sure before executing the command below that /var/www is writable.<br />
The command will download a .sh script and execute it.</p>

<strong>What does the script?</strong><br />
<p>
The script creates an app directory inside /var/www if it's not created.
It will also install a virtual host into the /etc/apache2 directory if the app.conf is not found.
It will add the projectname to the /etc/hosts file.
It will start download all required files needed for the angular 2 project inside /var/www/app/[project-name(string)]/
</p>
<p>
The script can be executed again to just use a different version of bootstrap eg. 3 or 4. 
In this case it will modify some files and remove package not longer needed followed by downloading required packages from npm.
</p>
<ul>
<li>Replace [project-name(string)] below with the project name.</li>
<li>Replace [bootstrap-version(int)] below with the bootstrap version to use for the project, either 3 or 4.</li>
</ul>
Open a terminal and execute:<br />
<code>wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/install.angular2.project.sh -P /var/www/ && chmod +x /var/www/install.angular2.project.sh && ./install.angular2.project.sh [project-name(string)] [bootstrap-version(int)]</code>

<p>
After execution has finished open a browser and go to either:<br />
For development against webpack server: http://localhost:8080/<br />
For transpiled site: http://www.[project-name(string)].app
</p>

<strong>Credits</strong><br />
<ul>
<li>angular2-webpack: https://github.com/preboot/angular2-webpack</li>
<li>ng2-bootstrap: https://github.com/valor-software/ng2-bootstrap</li>
<li>bootstrap 3: https://github.com/twbs/bootstrap</li>
<li>bootstrap 4: https://github.com/twbs/bootstrap/tree/v4-dev</li>
<li>Fontawesome: https://github.com/FortAwesome/Font-Awesome</li>
<li>And all others not mentioned here.</li>
</ul>

<strong>License</strong><br />
<p><a href="https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/LICENSE">MIT</a></p>

