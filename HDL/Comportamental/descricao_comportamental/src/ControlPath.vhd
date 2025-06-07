library IEEE;
use IEEE.std_logic_1164.all;
use work.SelectionSort_pkg.all;

entity ControlPath is
	port ( 		 
		-- Input
		clk		    :in std_logic;
		rst			:in std_logic; 
		data_av		:in std_logic;
		done 		:out std_logic;
		
		-- Datapath interface
		sts			:in Status;
		cmd			:out Command;
		
		-- Memory interface
		sel, ld		: out std_logic
	);
end ControlPath; 



architecture behavioral of ControlPath is
	type State is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14);
	signal currentState, nextState: State;
	
begin  
	
		-- State memory	
		process(clk,rst)  
		begin 
			if rst <= '1' then
			currentState <= S0;
		
			elsif rising_edge(clk) then
				currentState <= nextState;
			end if;	
		end process;
			
		-- Next state logic
		process(currentState, data_av, sts.lt_size, 
		
		sts.i_dt_min, sts.aux_t_min)
		begin 
			case currentState is
				when S0 =>
					if data_av = '1' then
					   	nextState <= S1;
					else
						nextState <= S0;
					end if;
				
				when S1 =>
					if data_av = '1' then
					   	nextState <= S2;
					else
						nextState <= S1;
					end if;	  
					
				when S2 =>
					if data_av = '1' then
					   	nextState <= S3;
					else
						nextState <= S2;
					end if;			   
					
				when S3 => 
					if sts.lt_size = '1' then
					   	nextState <= S4;
					else
						nextState <= S14; -- done
					end if;
					
				when S4	=>
					nextState <= S5;
				
				when S5 =>
					if sts.lt_size = '1' then
						nextState <= S6;
					else 
						nextState <= S9; 
					end if;
					
				when S6 => 
					if sts.aux_t_min = '1' then
						nextState <= S7;
					else 
						nextState <= S8;
					end if;
					
				when S7 =>
					nextState <= S8;
				
				when S8 =>
					nextState <= S5;
				
				when S9 =>
					if sts.i_dt_min = '1' then
					   	nextState <= S11;
					else
						nextState <= S10;
					end if;
					
				when S10 =>
					nextState <= S3;
				  
				when S11 =>
					nextState <= S12;	
				
				when S12 =>
					nextState <= S13;
					
				when S13 =>
					nextState <= S14;	
					
				when others	=>	-- S14
					nextState <= S0;
					
			end case;
		end process;
					
		
end behavioral;