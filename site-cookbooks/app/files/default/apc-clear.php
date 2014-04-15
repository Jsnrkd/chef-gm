<?php
/*
	Clears the APC cache! 
*/
  apc_clear_cache();
  apc_clear_cache('user');
  apc_clear_cache('opcode');
  echo json_encode(array('apc_cache_cleared' => true));