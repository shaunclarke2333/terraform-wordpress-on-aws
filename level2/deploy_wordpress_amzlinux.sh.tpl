#!/bin/bash

# using a function so that commands will work when executed in sub shell
function deploy_wordpress() {

# installing apache
sudo yum install -y httpd;

# starting apache
sudo service httpd start;

# downloading worpdress setup files
sudo wget https://wordpress.org/latest.tar.gz;

# unzipping wordpress setup files
sudo tar -xzf latest.tar.gz;

# changing to wordpress dir
cd /wordpress/; 

# Using here doc to create wp-config.php file with terraform variable inputs
cat  << "configfile" > wp-config.php
<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', '${database_name}' );

/** Database username */
define( 'DB_USER', '${username}' );

/** Database password */
define( 'DB_PASSWORD', '${password}' );

/** Database hostname */
define( 'DB_HOST', '${db_host}' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

define('WP_HOME','${domain}');
define('WP_SITEURL','${domain}');

//Moved https redirection from the Apache virtual server config to wp-config.php using this snippet.
if (strpos($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false)
       $_SERVER['HTTPS']='on';

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'jX<3Fw-6lXBY-)E`f6)#D(3d<-if3lbS-$f@D4lY|~iroRxvU*@2DSTl2^Oj+s+c');
define('SECURE_AUTH_KEY',  '&*rQ..%DDn]mmE.>ybGe$I39m(r+Sn`#qmBG|f@.9B|=zS,4XlcP2qUz-gT(?KCl');
define('LOGGED_IN_KEY',    'PYm<yz;t^Fx$4Mn(gs6+ +jl^JDCPZ:*_Q9VYm5x|Vg`tsRe]$GU5s[.q,.$0jFh');
define('NONCE_KEY',        '`N;KT=y@j*QcYJ k@r)@?ts}Ym@pjB}tR$%vPfS]0:-yT<LPVc:1B1^p&aRl+rd$');
define('AUTH_SALT',        'cXsy+ba4 M+ ~2(hzAQe+(k=HC-YjX-@lUrJ%EE~c_=vZGG[qJ2OD.Edr8}k<x27');
define('SECURE_AUTH_SALT', 'jd|<IJ%@B}D#8G- (a@p)S)vgA~e_{m@Qa=,8D;s(V[Wa>)aKTP1e$CmlU[ZK7/W');
define('LOGGED_IN_SALT',   'O~?}Le_bFAS~&--A1U@e{){n}J,An3gJ{YD*q;a!cUQ&E-)QeRN@r)Q];s7h<|hC');
define('NONCE_SALT',       '+?50ol$O_fgP)`!BVFyGXr,^az%v-LMG%-|ar_%2XRUt&]EsgUWrrN?led7::~>]');

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
        define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
configfile

# installing wordpress dependcies 
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2;

# copying wordpress setup files to html dir
sudo cp -r * /var/www/html/;

# restarting apache web server
sudo service httpd restart;
}

deploy_wordpress