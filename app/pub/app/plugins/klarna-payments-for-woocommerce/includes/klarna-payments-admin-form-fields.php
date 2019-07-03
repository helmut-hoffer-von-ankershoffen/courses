<?php

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

/**
 * Class Klarna_Payments_Form_Fields
 */
class Klarna_Payments_Form_Fields {
	/**
	 * Returns the fields.
	 */
	public static function fields() {
		return apply_filters(
			'wc_gateway_klarna_payments_settings', array(
				'enabled'                  => array(
					'title'       => __( 'Enable/Disable', 'klarna-payments-for-woocommerce' ),
					'label'       => __( 'Enable Klarna Payments', 'klarna-payments-for-woocommerce' ),
					'type'        => 'checkbox',
					'description' => '',
					'default'     => 'no',
				),
				'title'                    => array(
					'title'       => __( 'Title', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Payment method title. Changes what the payment method is called on the order recieved page aswell as the email that is sent to the customer.', 'klarna-payments-for-woocommerce' ),
					'default'     => 'Klarna',
					'desc_tip'    => true,
				),
				'testmode'                 => array(
					'title'       => __( 'Test mode', 'klarna-payments-for-woocommerce' ),
					'label'       => __( 'Enable Test Mode', 'klarna-payments-for-woocommerce' ),
					'type'        => 'checkbox',
					'description' => __( 'Place the payment gateway in test mode using test API keys.', 'klarna-payments-for-woocommerce' ),
					'default'     => 'yes',
					'desc_tip'    => true,
				),
				'logging'                  => array(
					'title'       => __( 'Logging', 'klarna-payments-for-woocommerce' ),
					'label'       => __( 'Log debug messages', 'klarna-payments-for-woocommerce' ),
					'type'        => 'checkbox',
					'description' => __( 'Save debug messages to the WooCommerce System Status log.', 'klarna-payments-for-woocommerce' ),
					'default'     => 'no',
					'desc_tip'    => true,
				),
				'hide_what_is_klarna'      => array(
					'title'    => __( 'Hide What is Klarna? link', 'klarna-payments-for-woocommerce' ),
					'type'     => 'checkbox',
					'label'    => __( 'If checked, What is Klarna? will not be shown.', 'klarna-payments-for-woocommerce' ),
					'default'  => 'no',
					'desc_tip' => true,
				),
				'float_what_is_klarna'     => array(
					'title'    => __( 'Float What is Klarna? link', 'klarna-payments-for-woocommerce' ),
					'type'     => 'checkbox',
					'label'    => __( 'If checked, What is Klarna? will be floated right.', 'klarna-payments-for-woocommerce' ),
					'default'  => 'yes',
					'desc_tip' => true,
				),
				'send_product_urls'        => array(
					'title'    => __( 'Product URLs', 'klarna-payments-for-woocommerce' ),
					'type'     => 'checkbox',
					'label'    => __( 'Send product and product image URLs to Klarna', 'klarna-payments-for-woocommerce' ),
					'default'  => 'yes',
					'desc_tip' => true,
				),
				'customer_type'            => array(
					'title'       => __( 'Customer type', 'klarna-payments-for-woocommerce' ),
					'type'        => 'select',
					'label'       => __( 'Customer type', 'klarna-payments-for-woocommerce' ),
					'description' => __( 'Select the customer for the store.', 'klarna-payments-for-woocommerce' ),
					'options'     => array(
						'b2c' => __( 'B2C', 'klarna-payments-for-woocommerce' ),
						'b2b' => __( 'B2B', 'klarna-payments-for-woocommerce' ),
					),
					'default'     => 'b2c',
					'desc_tip'    => true,
				),

				// AT.
				'credentials_at'           => array(
					'title' => '<img src="' . plugins_url( 'assets/img/flags/at.svg', WC_KLARNA_PAYMENTS_MAIN_FILE ) . '" height="12" /> Austria',
					'type'  => 'title',
				),
				'merchant_id_at'           => array(
					'title'       => __( 'Production Username', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for AT.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'shared_secret_at'         => array(
					'title'       => __( 'Production Password', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for AT.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'test_merchant_id_at'      => array(
					'title'       => __( 'Test Username', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for AT.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'test_shared_secret_at'    => array(
					'title'       => __( 'Test Password', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for AT.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),

				// DK.
				'credentials_dk'           => array(
					'title' => '<img src="' . plugins_url( 'assets/img/flags/dk.svg', WC_KLARNA_PAYMENTS_MAIN_FILE ) . '" height="12" /> Denmark',
					'type'  => 'title',
				),
				'merchant_id_dk'           => array(
					'title'       => __( 'Production Username', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for DK.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'shared_secret_dk'         => array(
					'title'       => __( 'Production Password', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for DK.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'test_merchant_id_dk'      => array(
					'title'       => __( 'Test Username', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for DK.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'test_shared_secret_dk'    => array(
					'title'       => __( 'Test Password', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for DK.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),

				// FI.
				'credentials_fi'           => array(
					'title' => '<img src="' . plugins_url( 'assets/img/flags/fi.svg', WC_KLARNA_PAYMENTS_MAIN_FILE ) . '" height="12" /> Finland',
					'type'  => 'title',
				),
				'merchant_id_fi'           => array(
					'title'       => __( 'Production Username', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for FI.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'shared_secret_fi'         => array(
					'title'       => __( 'Production Password', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for FI.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'test_merchant_id_fi'      => array(
					'title'       => __( 'Test Username', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for FI.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'test_shared_secret_fi'    => array(
					'title'       => __( 'Test Password', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for FI.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),

				// DE.
				'credentials_de'           => array(
					'title' => '<img src="' . plugins_url( 'assets/img/flags/de.svg', WC_KLARNA_PAYMENTS_MAIN_FILE ) . '" height="12" /> Germany',
					'type'  => 'title',
				),
				'merchant_id_de'           => array(
					'title'       => __( 'Production Username', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for DE.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'shared_secret_de'         => array(
					'title'       => __( 'Production Password', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for DE.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'test_merchant_id_de'      => array(
					'title'       => __( 'Test Username', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for DE.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'test_shared_secret_de'    => array(
					'title'       => __( 'Test Password', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for DE.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),

				// NL.
				'credentials_nl'           => array(
					'title' => '<img src="' . plugins_url( 'assets/img/flags/nl.svg', WC_KLARNA_PAYMENTS_MAIN_FILE ) . '" height="12" /> Netherlands',
					'type'  => 'title',
				),
				'merchant_id_nl'           => array(
					'title'       => __( 'Production Username', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for NL.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'shared_secret_nl'         => array(
					'title'       => __( 'Production Password', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for NL.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'test_merchant_id_nl'      => array(
					'title'       => __( 'Test Username', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for NL.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'test_shared_secret_nl'    => array(
					'title'       => __( 'Test Password', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for NL.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),

				// NO.
				'credentials_no'           => array(
					'title' => '<img src="' . plugins_url( 'assets/img/flags/no.svg', WC_KLARNA_PAYMENTS_MAIN_FILE ) . '" height="12" /> Norway',
					'type'  => 'title',
				),
				'merchant_id_no'           => array(
					'title'       => __( 'Production Username', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for NO.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'shared_secret_no'         => array(
					'title'       => __( 'Production Password', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for NO.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'test_merchant_id_no'      => array(
					'title'       => __( 'Test Username', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for NO.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'test_shared_secret_no'    => array(
					'title'       => __( 'Test Password', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for NO.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),

				// SE.
				'credentials_se'           => array(
					'title' => '<img src="' . plugins_url( 'assets/img/flags/se.svg', WC_KLARNA_PAYMENTS_MAIN_FILE ) . '" height="12" /> Sweden',
					'type'  => 'title',
				),
				'merchant_id_se'           => array(
					'title'       => __( 'Production Username', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for SE.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'shared_secret_se'         => array(
					'title'       => __( 'Production Password', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for SE.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'test_merchant_id_se'      => array(
					'title'       => __( 'Test Username', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for EU.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'test_shared_secret_se'    => array(
					'title'       => __( 'Test Password', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for SE.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),

				// UK.
				'credentials_gb'           => array(
					'title' => '<img src="' . plugins_url( 'assets/img/flags/gb.svg', WC_KLARNA_PAYMENTS_MAIN_FILE ) . '" height="12" /> United Kingdom',
					'type'  => 'title',
				),
				'merchant_id_gb'           => array(
					'title'       => __( 'Production Username', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for UK.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'shared_secret_gb'         => array(
					'title'       => __( 'Production Password', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for UK.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'test_merchant_id_gb'      => array(
					'title'       => __( 'Test Username', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for UK.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'test_shared_secret_gb'    => array(
					'title'       => __( 'Test Password', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for UK.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),

				// US.
				'credentials_us'           => array(
					'title' => '<img src="' . plugins_url( 'assets/img/flags/us.svg', WC_KLARNA_PAYMENTS_MAIN_FILE ) . '" height="12" /> United States',
					'type'  => 'title',
				),
				'merchant_id_us'           => array(
					'title'       => __( 'Production Username', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for US.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'shared_secret_us'         => array(
					'title'       => __( 'Production Password', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for US.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'test_merchant_id_us'      => array(
					'title'       => __( 'Test Username', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for US.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'test_shared_secret_us'    => array(
					'title'       => __( 'Test Password', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for US.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				// CH.
				'credentials_ch'           => array(
					'title' => '<img src="' . plugins_url( 'assets/img/flags/ch.svg', WC_KLARNA_PAYMENTS_MAIN_FILE ) . '" height="12" /> Switzerland',
					'type'  => 'title',
				),
				'merchant_id_ch'           => array(
					'title'       => __( 'Production Username', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for Switzerland.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'shared_secret_ch'         => array(
					'title'       => __( 'Production Password', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for Switzerland.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'test_merchant_id_ch'      => array(
					'title'       => __( 'Test Username', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for Switzerland.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),
				'test_shared_secret_ch'    => array(
					'title'       => __( 'Test Password', 'klarna-payments-for-woocommerce' ),
					'type'        => 'text',
					'description' => __( 'Get your API keys from your Klarna Payments merchant account for Switzerland.', 'klarna-payments-for-woocommerce' ),
					'default'     => '',
					'desc_tip'    => true,
				),

				'iframe_options'           => array(
					'title' => 'Iframe settings',
					'type'  => 'title',
				),
				'background'               => array(
					'title'    => 'Background',
					'type'     => 'color',
					'default'  => '#ffffff',
					'desc_tip' => true,
				),
				'color_button'             => array(
					'title'    => 'Button color',
					'type'     => 'color',
					'default'  => '',
					'desc_tip' => true,
				),
				'color_button_text'        => array(
					'title'    => 'Button text color',
					'type'     => 'color',
					'default'  => '',
					'desc_tip' => true,
				),
				'color_checkbox'           => array(
					'title'    => 'Checkbox color',
					'type'     => 'color',
					'default'  => '',
					'desc_tip' => true,
				),
				'color_checkbox_checkmark' => array(
					'title'    => 'Checkbox checkmark color',
					'type'     => 'color',
					'default'  => '',
					'desc_tip' => true,
				),
				'color_header'             => array(
					'title'    => 'Header color',
					'type'     => 'color',
					'default'  => '',
					'desc_tip' => true,
				),
				'color_link'               => array(
					'title'    => 'Link color',
					'type'     => 'color',
					'default'  => '',
					'desc_tip' => true,
				),
				'color_border'             => array(
					'title'    => 'Border color',
					'type'     => 'color',
					'default'  => '',
					'desc_tip' => true,
				),
				'color_border_selected'    => array(
					'title'    => 'Selected border color',
					'type'     => 'color',
					'default'  => '',
					'desc_tip' => true,
				),
				'color_text'               => array(
					'title'    => 'Text color',
					'type'     => 'color',
					'default'  => '',
					'desc_tip' => true,
				),
				'color_details'            => array(
					'title'    => 'Details color',
					'type'     => 'color',
					'default'  => '',
					'desc_tip' => true,
				),
				'color_text_secondary'     => array(
					'title'    => 'Secondary text color',
					'type'     => 'color',
					'default'  => '',
					'desc_tip' => true,
				),
				'radius_border'            => array(
					'title'    => 'Border radius (px)',
					'type'     => 'number',
					'default'  => '',
					'desc_tip' => true,
				),
			)
		);
	}
}

