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
			if rst = '1' then
			currentState <= S0;
		
			elsif rising_edge(clk) then
				currentState <= nextState;
				
			end if;	
		end process;
			
		-- Next state logic
		process(currentState, data_av, sts.lt_size, sts.i_dt_min, sts.aux_t_min)
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
					nextState <= S10;	
					
				when others	=>	-- S14
					nextState <= S0;
					
			end case;
		end process;
		
		-- Output logic	
		done <= '1' when currentState = S14 else '0';		
			
		-- Write	
		cmd.wrStartAddr <= '1' when currentState = S0 else '0';	
		cmd.wrSize <= '1' when currentState = S1 else '0'; 
		cmd.wrOrder <= '1' when currentState = S2 else '0';	
		cmd.wrI <= '1' when currentState = S1 or currentState = S10 else '0';	 
		cmd.wrMIn <= '1' when currentState = S3 or currentState = S7 else '0';	 
		cmd.wrJ <= '1' when currentState = S4 or currentState = S8 else '0';
		cmd.wrAux <= '1' when currentState = S5 or currentState = S9 else '0'; 
		cmd.wrAux2 <= '1' when currentState = S11 else '0';
			
		-- Mux
		cmd.seli1 <= '1' when currentState = S1 else '0';
		cmd.selComp <= '1' when currentState = S5 else '0';
		cmd.selAddr0 <= '1' when currentState =	S5 or
								 currentState = S9 or
								 currentState = S12 else '0';
		cmd.selAddr1 <= '1' when currentState =	S5 or
								 currentState = S9 or
								 currentState = S12 else '0';  
		cmd.selMin <= '1' when currentState = S7 else '0';
		cmd.selInc <= '1' when currentState = S8 else '0';
		cmd.selData_out <= '1' when currentState = S13 else '0';	
		-- Memory interface
		sel <= '1' when currentState = S5 or 
						currentState = S6 or
						currentState = S9 or
						currentState = S11 or
						currentState = S12 or						
						currentState = S13 else '0';	  
		ld <= '1' when currentState = S12 or currentState = S13 else '0';
											
end behavioral;			

