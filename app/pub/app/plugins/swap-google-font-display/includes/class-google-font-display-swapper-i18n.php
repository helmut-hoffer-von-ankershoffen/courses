<?php

/**
 * Define the internationalization functionality
 *
 * Loads and defines the internationalization files for this plugin
 * so that it is ready for translation.
 *
 * @link       https://wpspeedmatters.com
 * @since      1.0.0
 *
 * @package    Google_Font_Display_Swapper
 * @subpackage Google_Font_Display_Swapper/includes
 */

/**
 * Define the internationalization functionality.
 *
 * Loads and defines the internationalization files for this plugin
 * so that it is ready for translation.
 *
 * @since      1.0.0
 * @package    Google_Font_Display_Swapper
 * @subpackage Google_Font_Display_Swapper/includes
 * @author     Gijo Varghese <hi@gijovarghese.com>
 */
class Google_Font_Display_Swapper_i18n {


	/**
	 * Load the plugin text domain for translation.
	 *
	 * @since    1.0.0
	 */
	public function load_plugin_textdomain() {

		load_plugin_textdomain(
			'google-font-display-swapper',
			false,
			dirname( dirname( plugin_basename( __FILE__ ) ) ) . '/languages/'
		);

	}



}
