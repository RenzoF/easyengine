# Install MySQL package

ee_mod_install_mysql()
{
	# Random characters
	local ee_random=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n1)

	# Check MySQL is installed or not
	ee_lib_package_check mysql-server

	# If MySQL is not installed
	# Then set random MySQL password for root user
	if [ -n "$EE_PACKAGE_NAME" ]; then

		# Setting up MySQL password
		debconf-set-selections <<< "mysql-server mysql-server/root_password password $ee_random"
		debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $ee_random"

		# Generate ~/.my.cnf
		echo -e "[client]\nuser=root\npassword=$ee_random" > ~/.my.cnf

	fi

	ee_lib_echo "Installing MySQL, please Wait..."
	$EE_APT_GET install mysql-server mysqltuner percona-toolkit \
	|| ee_lib_error "Unable to install MySQL, exit status = " $?

	# Download tuning-primer.sh
	wget --no-check-certificate -cqO /usr/local/bin/tuning-primer.sh https://launchpadlibrarian.net/78745738/tuning-primer.sh
	chmod a+x /usr/local/bin/tuning-primer.sh
}
