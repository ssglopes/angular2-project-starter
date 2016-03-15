# angular2-project-starter

<h3>Goal</h3>
<p>Having a startup project based on <a href="https://angular.io/" target="_blank">Angular 2</a> supporting <a href="https://jquery.com/" target="_blank">jQuery</a> (for stuff Angular 2 is missing), 
<a href="http://getbootstrap.com/" target="_blank">Bootstrap 3</a> or <a href="http://v4-alpha.getbootstrap.com/" target="_blank">Bootstrap 4</a>, 
<a href="http://valor-software.com/ng2-bootstrap/" target="_blank">ng2-bootstrap</a> and 
<a href="https://fortawesome.github.io/Font-Awesome/" target="_blank">Font Awesome</strong> in case using bootstrap 4. Bootstrap 3 uses 
<a href="http://getbootstrap.com/components/" target="_blank">Glyphicons</a>.</p>

<h3>Installation</h3>
<p>Make sure before executing the command below that /var/www is writable.<br />
The command will download a .sh script and execute it.</p>

<h3>What does the script?</h3>
<p>The script creates an app directory inside /var/www if it's not created.
It will also install a virtual host into the /etc/apache2 directory if the app.conf is not found.
It will add the projectname to the /etc/hosts file.
It will start download all required files needed for the angular 2 project inside /var/www/app/[project-name(string)]/</p>

<h3>Toggle between bootstrap 3 and 4</h3>
<p>To switch between bootstrap versions for the created project, executed the script again. 
Only some files will be modified and unneeded packages will be removed followed by downloading newly required packages from npm.</p>
<ul>
<li>Replace [project-name(string)] below with the project name.</li>
<li>Replace [bootstrap-version(int)] below with the bootstrap version to use for the project, either 3 or 4.</li>
</ul>
<p>
Open a terminal and execute:<br />
<code>wget https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/install.angular2.project.sh -P /var/www/ && chmod +x /var/www/install.angular2.project.sh && ./install.angular2.project.sh [project-name(string)] [bootstrap-version(int)]</code>
</p>
<p>
After execution has finished open a browser and go to either:<br />
For development against webpack server: http://localhost:8080/<br />
For transpiled site: http://www.[project-name(string)].app
</p>

<h3>Credits</h3>
<ul>
<li>angular 2: https://github.com/angular/angular</li>
<li>angular2-webpack: https://github.com/preboot/angular2-webpack</li>
<li>ng2-bootstrap: https://github.com/valor-software/ng2-bootstrap</li>
<li>bootstrap 3: https://github.com/twbs/bootstrap</li>
<li>bootstrap 4: https://github.com/twbs/bootstrap/tree/v4-dev</li>
<li>Fontawesome: https://github.com/FortAwesome/Font-Awesome</li>
<li>jQuery: https://github.com/jquery/jquery</li>
<li>And all others not mentioned here.</li>
</ul>

<h3>License</h3>
<p><a href="https://raw.githubusercontent.com/ssglopes/angular2-project-starter/master/LICENSE">MIT</a></p>

