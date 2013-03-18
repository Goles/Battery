# Battery

![image](http://i.imgur.com/mEEPD.png)

Battery is a little bash script that uses [Spark](https://github.com/holman/spark) to display the battery status on your __tmux__ sessions or the __terminal__.

### Features

* Changes color to reflect battery status (Green, Yellow, Red)
* Displays battery percentage
* Graph bar changes its values between 0 and 100% (thanks to spark)
* If you don't like the default colors, you can specify the good, medium and warning battery status colors using flags (read usage).

### Requirements

Right now, battery requires [Spark](https://github.com/holman/spark) to graph your battery status, and only runs on __Mac OS X__.

### Install

#### Homebrew

Just do (case sensitive)

    brew tap Goles/battery

#### One Liner
(Cut & Paste on terminal to install on `/usr/bin`, btw, try to run from `~/` or other writable dir)

	brew install spark; curl -O https://raw.github.com/Goles/Battery/master/battery ; \
	sudo mv battery /usr/bin; sudo chmod 755 /usr/bin/battery

#### Step by Step

* Install spark ([Homebrew](https://github.com/mxcl/homebrew) on Mac OS X)

	``` brew install spark``` 
	
* Copy battery somewhere in your path & fix permissions

	``` sudo cp battery /usr/bin ```
	
	``` sudo chmod 755 /usr/bin/battery ```
	
### Usage (Terminal)

* Run Battery (From the terminal)

	``` battery ```	
###### You should see something like this:
![image](http://i.imgur.com/SLSBg.png)

### Usage (tmux)

* Add the following line to your `~/.tmux.conf` file

	``` set -g status-right "#(/usr/bin/battery -o tmux)"```

* reload the tmux config by running `tmux source-file ~/.tmux.conf`.

###### You should now see something like this at the bottom right corner:
![image](http://i.imgur.com/Eaajb.png)

### Usage (flags)

You can specifiy the colors for __good__ battery level, __middle__ battery level, and __warning__ battery level with the flags ``` -g -m -w ```. 

__Note:__ You should use color names for when in tmux mode and [ascii colors](http://www.termsys.demon.co.uk/vtansi.htm#colors) in terminal mode.

