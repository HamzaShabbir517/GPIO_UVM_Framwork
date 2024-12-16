// Declaring a UVM CONFIG DB Get macro which can be use all the time rather than using the full code

`define get_config(cfg_type, cfg_handle, cfg_name) \
if (``cfg_handle`` == null) \
	if(!uvm_config_db #(``cfg_type``)::get(this,"*",``cfg_name``,``cfg_handle``)) \
		 `uvm_fatal("CONFIG_LOAD", $sformatf("Cannot get() configuration %s from uvm_config_db. Have you set() it?", ``cfg_name``) ) 
		
