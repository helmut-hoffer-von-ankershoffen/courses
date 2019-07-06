jQuery(document).ready(function($){
	'use strict';

	//Block cart on fragment refresh
	$(document.body).on('wc_fragment_refresh',block_cart);

	//Unblock cart
	$(document.body).on('wc_fragments_refreshed wc_fragments_loaded',function(){
		content_height();
	});

	// refresh fragment on document load
	if(!xoo_wsc_localize.added_to_cart){
		$( document.body ).trigger( 'wc_fragment_refresh' );
	}


	function update_cartChk(){
		//Refresh checkout page
		if( window.wc_checkout_params && wc_checkout_params.is_checkout === "1" ){
			if( $( 'form.checkout' ).length === 0 ){
				location.reload();
				return;
			}
			$(document.body).trigger("update_checkout");
		}

		//Refresh Cart page
		if( window.wc_add_to_cart_params && window.wc_add_to_cart_params.is_cart && wc_add_to_cart_params.is_cart === "1" ){
			$(document.body).trigger("wc_update_cart");
		}
	}

	$(document.body).on('xoo_wsc_cart_updated',update_cartChk);


	//Toggle Side Cart
	function toggle_sidecart(toggle_type){
		var toggle_element = $('.xoo-wsc-modal , body, html'),
			toggle_class   = 'xoo-wsc-active';

		if(toggle_type == 'show'){
			toggle_element.addClass(toggle_class);
		}
		else if(toggle_type == 'hide'){
			toggle_element.removeClass(toggle_class);
		}
		else{
			toggle_element.toggleClass('xoo-wsc-active');
		}

		unblock_cart();
	}

	$('.xoo-wsc-basket').on('click',toggle_sidecart);

	if(xoo_wsc_localize.trigger_class){
		$('.'+xoo_wsc_localize.trigger_class).on('click',toggle_sidecart);
	}


	//Set Cart content height
	function content_height(){
		var header = $('.xoo-wsc-header').outerHeight(), 
			footer = $('.xoo-wsc-footer').outerHeight(),
			screen = $(window).height();


		if( xoo_wsc_localize.cont_height == "auto_adjust" ){
			var body_height = 'calc(100% - '+(header+footer)+'px)';
			if( $('.xoo-wsc-container').outerHeight() > screen ){
				$('.xoo-wsc-container').css({"top": "0", "bottom": "0"});
			}
		}
		else{
			var body_height = screen-(header+footer);
		}


		$('.xoo-wsc-body').css('height',body_height);

	};

	content_height();

	$(window).resize(function(){
    	content_height();
	});


	//Reset cart button/form
	function reset_cart(atc_btn){
		$('.xoo-wsc-icon-atc',atc_btn).remove();
		var qty_elem = atc_btn.parents('form.cart').find('.qty');
		if(qty_elem.length > 0) qty_elem.val(qty_elem.attr('min') || 1);
		$('.added_to_cart').remove();
	}

	//Auto open Side Cart when item added to cart without ajax
	(function(){
		if(xoo_wsc_localize.added_to_cart){
			var toggled = false;
			$(document).on('wc_fragments_refreshed',function(){
				if(!toggled){
					setTimeout(toggle_sidecart,1,'show');
					toggled = true;
				}
			})
		}
	}());
	

	//Auto open with ajax & reset cart form
	$(document).on('added_to_cart',function(event,fragments,cart_hash,atc_btn){
		if(xoo_wsc_localize.auto_open_cart == 1){
			setTimeout(toggle_sidecart,1,'show');
		}

		if(xoo_wsc_localize.atc_reset == 1){
			reset_cart(atc_btn);
		}

		update_cartChk();
	});
	


	//Block Cart
	function block_cart(){
		$('.xoo-wsc-updating').show();
	}

	//Unblock cart
	function unblock_cart(){
		$('.xoo-wsc-updating').hide();
	}


	//Close Side Cart
	function close_sidecart(e){
		$.each(e.target.classList,function(key,value){
			if(value != 'xoo-wsc-container' && (value == 'xoo-wsc-close' || value == 'xoo-wsc-opac' || value == 'xoo-wsc-basket' || value == 'xoo-wsc-cont')){
				$('.xoo-wsc-modal , body, html').removeClass('xoo-wsc-active');
			}
		})
	}

	$('body').on('click','.xoo-wsc-close , .xoo-wsc-opac',function(e){
		e.preventDefault();
		close_sidecart(e);
	});

	$('body').on('click','.xoo-wsc-cont',function(e){
		var link = $.trim($(this).attr('href'));
		if( link == "#" || !link){
			e.preventDefault();
			close_sidecart(e);
		}
	});

	

	//Add to cart function
	function add_to_cart(atc_btn,product_data){

		// Trigger event.
		$( document.body ).trigger( 'adding_to_cart', [ atc_btn, product_data ] );

		$.ajax({
				url: xoo_wsc_localize.wc_ajax_url.toString().replace( '%%endpoint%%', 'xoo_wsc_add_to_cart' ),
				type: 'POST',
				data: $.param(product_data),
			    success: function(response){
			    	
			    	add_to_cart_button_check_icon(atc_btn);

					if(response.fragments){
						// Trigger event so themes can refresh other areas.
						$( document.body ).trigger( 'added_to_cart', [ response.fragments, response.cart_hash, atc_btn ] );
					}
					else if(response.error){
						show_notice('error',response.error);
						toggle_sidecart('show');
					}
					else{
						console.log(response);
					}
			
			    }
			})
	}


	//Update cart
	function update_cart(cart_key,new_qty){
		
		$.ajax({
			url: xoo_wsc_localize.wc_ajax_url.toString().replace( '%%endpoint%%', 'xoo_wsc_update_cart' ),
			type: 'POST',
			data: {
				cart_key: cart_key,
				new_qty: new_qty
			},
			success: function(response){
				if(response.fragments){
					var fragments = response.fragments,
						cart_hash =  response.cart_hash;

					//Set fragments
			   		$.each( response.fragments, function( key, value ) {
						$( key ).replaceWith( value );
						$( key ).stop( true ).css( 'opacity', '1' ).unblock();
					});


					if(wc_cart_fragments_params){
				   		var cart_hash_key = wc_cart_fragments_params.ajax_url.toString() + '-wc_cart_hash';
						//Set cart hash
						sessionStorage.setItem( wc_cart_fragments_params.fragment_name, JSON.stringify( fragments ) );
						localStorage.setItem( cart_hash_key, cart_hash );
						sessionStorage.setItem( cart_hash_key, cart_hash );
					}

					$(document.body).trigger('wc_fragments_loaded');
					$(document.body).trigger('xoo_wsc_cart_updated');
				}
				else{
					//Print error
					show_notice('error',response.error);
				}
			}

		})
	}



	//Remove item from cart
	$(document).on('click','.xoo-wsc-remove',function(e){
		e.preventDefault();
		block_cart();
		var product_row = $(this).parents('.xoo-wsc-product');
		var cart_key = product_row.data('xoo_wsc');
		update_cart(cart_key,0);
	})

	//Add to cart on single page
	
	$(document).on('submit','form.cart',function(e){

		if( xoo_wsc_localize.ajax_atc != 1 ) return;

		e.preventDefault();
		block_cart();
		var form = $(this);
		var atc_btn  = form.find( 'button[type="submit"]');

		add_to_cart_button_loading_icon(atc_btn);

		var product_data = form.serializeArray();

		//Check for woocommerce custom quantity code 
		//https://docs.woocommerce.com/document/override-loop-template-and-show-quantities-next-to-add-to-cart-buttons/
		var has_product_id = false;
		$.each(product_data,function(key,form_item){
			if(form_item.name === 'product_id' || form_item.name === 'add-to-cart'){
				if(form_item.value){
					has_product_id = true;
					return false;
				}
			}
		})

		//If no product id found , look for the form action URL
		if(!has_product_id){
			var is_url = form.attr('action').match(/add-to-cart=([0-9]+)/);
			var product_id = is_url ? is_url[1] : false; 
		}

		// if button as name add-to-cart get it and add to form
        if( atc_btn.attr('name') && atc_btn.attr('name') == 'add-to-cart' && atc_btn.attr('value') ){
            var product_id = atc_btn.attr('value');
        }

        if(product_id){
        	product_data.push({name: 'add-to-cart', value: product_id});
        }


        product_data.push({name: 'action', value: 'xoo_wsc_add_to_cart'});

		add_to_cart(atc_btn,product_data);//Ajax add to cart
	})


	//Notice Function
	function show_notice(notice_type,notice){
	 	$('.xoo-wsc-notice').html(notice).attr('class','xoo-wsc-notice').addClass('xoo-wsc-nt-'+notice_type);
	 	$('.xoo-wsc-notice-box').fadeIn('fast');
	 	clearTimeout(fadenotice);
	 	var fadenotice = setTimeout(function(){
	 		$('.xoo-wsc-notice-box').fadeOut('slow');
	 	},2000);
	};

	//Add to cart preloader
	function add_to_cart_button_loading_icon(atc_btn){
		if(xoo_wsc_localize.atc_icons != 1) return;

		if(atc_btn.find('.xoo-wsc-icon-atc').length !== 0){
			atc_btn.find('.xoo-wsc-icon-atc').attr('class','xoo-wsc-icon-spinner2 xoo-wsc-icon-atc xoo-wsc-active');
		}
		else{
			atc_btn.append('<span class="xoo-wsc-icon-spinner2 xoo-wsc-icon-atc xoo-wsc-active"></span>');
		}
	}

	//Add to cart check icon
	function add_to_cart_button_check_icon(atc_btn){
		if(xoo_wsc_localize.atc_icons != 1) return;
		// Check icon
   		atc_btn.find('.xoo-wsc-icon-atc').attr('class','xoo-wsc-icon-checkmark xoo-wsc-icon-atc');
	}
})