<?php

/**
 * Provide a dashboard view for the plugin
 *
 * This file is used to markup the public-facing aspects of the plugin.
 *
 * @since      1.0.0
 *
 * @package    xoo-wsc
 * @subpackage xoo-wsc/admin/partials
 */
?>
<?php
?>
<div class="wrap">
	<?php
		$tab = isset( $_GET['tab'] ) ? $_GET['tab'] : 'general';
		$this->render_tabs(); 
	?>

	<div class="xoo-container">

		<div class="xoo-main">
			<?php 
			switch ($tab) {
				case 'style': ?>
					<form method="post" action="options.php">
						<?php
							settings_fields( 'xoo-wsc-sy-options' ); // Display Settings

							do_settings_sections( 'xoo-wsc-sy' ); // Display Sections

							submit_button( 'Save Settings' );	// Display Save Button
						?>			
					</form>
				<?php 
				break;
				case 'advanced':
				?>
					<form method="post" action="options.php">
						
						<?php
							settings_fields( 'xoo-wsc-av-options' );

							do_settings_sections( 'xoo-wsc-av' );

							submit_button( 'Save Settings' );
						?>		
					</form>

				<?php 
				break;
				case 'premium':
				?>
					<?php include(plugin_dir_path(__FILE__).'xoo-wsc-premium-info.php'); ?>

				<?php 
				break;
				default:
				?>
					<form method="post" action="options.php">				
							<?php 
								settings_fields( 'xoo-wsc-gl-options' );

								do_settings_sections( 'xoo-wsc-gl' );

								submit_button( 'Save Settings' );
							?>
							<div class="clear"></div>
					</form>
			<?php	
			} 
			?>
		</div>

		<div class="xoo-sidebar">
			<?php include XOO_WSC_PATH.'/admin/partials/xoo-wsc-sidebar.php'; ?>
		</div>
	</div>
</div>



