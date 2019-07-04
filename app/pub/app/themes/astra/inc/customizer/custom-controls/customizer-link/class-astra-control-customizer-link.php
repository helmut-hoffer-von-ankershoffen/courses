<?php
/**
 * Customizer Control: Customizer Link
 *
 * @package     Astra
 * @author      Astra
 * @copyright   Copyright (c) 2019, Astra
 * @link        https://wpastra.com/
 * @since       1.0.0
 */

// Exit if accessed directly.
if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

/**
 * A text control with validation for CSS units.
 */
class Astra_Control_Customizer_Link extends WP_Customize_Control {

	/**
	 * The control type.
	 *
	 * @access public
	 * @var string
	 */
	public $type = 'ast-customizer-link';

	/**
	 * Link text to be added inside the anchor tag.
	 *
	 * @var string
	 */
	public $link_text = '';

	/**
	 * Linked customizer section.
	 *
	 * @var string
	 */
	public $linked = '';

	/**
	 * Enqueue control related scripts/styles.
	 *
	 * @access public
	 */
	public function enqueue() {
		$css_uri = ASTRA_THEME_URI . 'inc/customizer/custom-controls/customizer-link/';
		$js_uri  = ASTRA_THEME_URI . 'inc/customizer/custom-controls/customizer-link/';

		wp_enqueue_style( 'astra-customizer-link-css', $css_uri . 'customizer-link.css', null, ASTRA_THEME_VERSION );
		wp_enqueue_script( 'astra-customizer-link-css', $js_uri . 'customizer-link.js', array( 'jquery', 'customize-base' ), ASTRA_THEME_VERSION, true );
	}

	/**
	 * Refresh the parameters passed to the JavaScript via JSON.
	 *
	 * @see WP_Customize_Control::to_json()
	 */
	public function to_json() {
		parent::to_json();
		$this->json['link_text'] = $this->link_text;
		$this->json['linked']    = $this->linked;
	}

	/**
	 * An Underscore (JS) template for this control's content (but not its container).
	 *
	 * Class variables for this control class are available in the `data` JS object;
	 * export custom variables by overriding {@see WP_Customize_Control::to_json()}.
	 *
	 * @see WP_Customize_Control::print_template()
	 *
	 * @access protected
	 */
	protected function content_template() {
		?>

		<# if ( data.linked && data.link_text ) { #>
			<a href="#" class="customizer-link" data-customizer-linked="{{{ data.linked }}}">
				{{{ data.link_text }}}
			</a>
		<# } #>

		<?php
	}
}
