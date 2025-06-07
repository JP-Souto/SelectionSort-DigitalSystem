library IEEE;
use IEEE.std_logic_1164.all;

package SelectionSort_pkg is
	
	type Command is record					
		-- incoming data 
		wrOrder, wrStartAddr, wrSize	: std_logic;
		
		-- address 
		wrI, wrJ, wrMin					: std_logic;  
		
		-- Aux
		wrAux, wrAux2					: std_logic;
		
		-- Mux selector
		selI, selInc, selComp, selMin, selAddr0, selAddr1, selData_out	: std_logic;
	end record;																		
	
	type Status is record	  
		lt_size, i_dt_min, aux_t_min	: std_logic;
	end record;	 
	
end SelectionSort_pkg;