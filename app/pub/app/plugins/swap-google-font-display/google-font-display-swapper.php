<?php

/**
 * The plugin bootstrap file
 *
 * This file is read by WordPress to generate the plugin information in the plugin
 * admin area. This file also includes all of the dependencies used by the plugin,
 * registers the activation and deactivation functions, and defines a function
 * that starts the plugin.
 *
 * @link              https://wpspeedmatters.com
 * @since             1.0.0
 * @package           Google_Font_Display_Swapper
 *
 * @wordpress-plugin
 * Plugin Name:       Swap Google Fonts Display
 * Plugin URI:        https://wpspeedmatters.com
 * Description:       Inject font-display: swap to Google Fonts to ensure text remains visible during webfont load
 * Version:           1.0.0
 * Author:            Gijo Varghese
 * Author URI:        https://twitter.com/gijovarghese141
 * License:           GPL-2.0+
 * License URI:       http://www.gnu.org/licenses/gpl-2.0.txt
 * Text Domain:       google-font-display-swapper
 * Domain Path:       /languages
 */

// If this file is called directly, abort.
if ( ! defined( 'WPINC' ) ) {
	die;
}

/**
 * Currently plugin version.
 * Start at version 1.0.0 and use SemVer - https://semver.org
 * Rename this for your plugin and update it as you release new versions.
 */
define( 'GOOGLE_FONT_DISPLAY_SWAPPER_VERSION', '1.0.0' );

/**
 * The code that runs during plugin activation.
 * This action is documented in includes/class-google-font-display-swapper-activator.php
 */
function activate_google_font_display_swapper() {
	require_once plugin_dir_path( __FILE__ ) . 'includes/class-google-font-display-swapper-activator.php';
	Google_Font_Display_Swapper_Activator::activate();
}

/**
 * The code that runs during plugin deactivation.
 * This action is documented in includes/class-google-font-display-swapper-deactivator.php
 */
function deactivate_google_font_display_swapper() {
	require_once plugin_dir_path( __FILE__ ) . 'includes/class-google-font-display-swapper-deactivator.php';
	Google_Font_Display_Swapper_Deactivator::deactivate();
}

register_activation_hook( __FILE__, 'activate_google_font_display_swapper' );
register_deactivation_hook( __FILE__, 'deactivate_google_font_display_swapper' );

/**
 * The core plugin class that is used to define internationalization,
 * admin-specific hooks, and public-facing site hooks.
 */
require plugin_dir_path( __FILE__ ) . 'includes/class-google-font-display-swapper.php';

/**
 * Begins execution of the plugin.
 *
 * Since everything within the plugin is registered via hooks,
 * then kicking off the plugin from this point in the file does
 * not affect the page life cycle.
 *
 * @since    1.0.0
 */
function run_google_font_display_swapper() {

	$plugin = new Google_Font_Display_Swapper();
	$plugin->run();

}

function start_wp_head_buffer() {
    ob_start();
}
add_action('wp_head','start_wp_head_buffer',0);

function inject_font_display() {
    $head = ob_get_clean();

	// Add font-display=swap as a querty parameter to Google fonts
    $head = str_replace("googleapis.com/css?family", "googleapis.com/css?display=swap&family", $head);

    echo $head;
}
add_action('wp_head','inject_font_display', PHP_INT_MAX); 

run_google_font_display_swapper();