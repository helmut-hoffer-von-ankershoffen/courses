<?php

function fastvelocity_version_check() {
	global $fastvelocity_plugin_version;
	
	# current FVM install date, create if it doesn't exist
	$ver = get_option("fastvelocity_plugin_version");
	if ($ver == false) { $ver = '0.0.0'; }
	
	# save current version on upgrade
	if ($ver != $fastvelocity_plugin_version) {
		update_option( "fastvelocity_plugin_version", $fastvelocity_plugin_version);
	}
	
	# compare versions (0.1.2)
	$dots = explode('.', $ver);
	if(!is_array($dots) || count($dots) != 3) { return false; }
	
	# changed options on 2.6.1 (elementor fixes)
	if($dots[0] <= 2 && $dots[1] <= 6 && $dots[2] < 1) {
		
		# ignore list
		$ignorelist = array_filter(array_map('trim', explode(PHP_EOL, get_option('fastvelocity_min_ignorelist', ''))));
		$exc = array('/Avada/assets/js/main.min.js', '/woocommerce-product-search/js/product-search.js', '/includes/builder/scripts/frontend-builder-scripts.js', '/assets/js/jquery.themepunch.tools.min.js', '/js/TweenMax.min.js', '/jupiter/assets/js/min/full-scripts', '/Divi/core/admin/js/react-dom.production.min.js', '/LayerSlider/static/layerslider/js/greensock.js', '/kalium/assets/js/main.min.js', '/elementor/assets/js/common.min.js', '/elementor/assets/js/frontend.min.js', '/elementor-pro/assets/js/frontend.min.js');
		$new = array_unique(array_merge($ignorelist, $exc));
		update_option('fastvelocity_min_ignorelist', implode(PHP_EOL, $new));
		
		# default minimal settings
		update_option('fastvelocity_preserve_settings_on_uninstall', 1);
		update_option('fastvelocity_min_fvm_fix_editor', 1);
	}
	
}
add_action( 'plugins_loaded', 'fastvelocity_version_check' );


# upgrade notifications
function fastvelocity_plugin_update_message($currentPluginMetadata, $newPluginMetadata) {
	if (isset($newPluginMetadata->upgrade_notice) && strlen(trim($newPluginMetadata->upgrade_notice)) > 0){
		echo '<span style="display:block; background: #F7FCFE; padding: 14px 0 6px 0; margin: 10px -12px -12px -16px;">';
		echo '<span class="notice notice-info" style="display:block; padding: 10px; margin: 0;">';
		echo '<span class="dashicons dashicons-megaphone" style="margin-left: 2px; margin-right: 6px;"></span>';
		echo strip_tags($newPluginMetadata->upgrade_notice);
		echo '</span>'; 
		echo '</span>'; 
	}
}
add_action( 'in_plugin_update_message-fast-velocity-minify/fvm.php', 'fastvelocity_plugin_update_message', 10, 2 );
