library IEEE;                        
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.SelectionSort_pkg.all;

entity SelectionSort is
	generic(
		DATA_WIDTH		: integer := 8
	);
	port (
		clk       : in std_logic;
		rst		  : in std_logic;
		data_av	  : in std_logic;
		data	  : in std_logic_vector (DATA_WIDTH - 1 downto 0);
		data_in   : in std_logic_vector (DATA_WIDTH - 1 downto 0);
		done	  : out std_logic;
		addr   : out std_logic_vector(DATA_WIDTH - 1 downto 0);
		data_out : out std_logic_vector(DATA_WIDTH - 1 downto 0);
		sel		 : out std_logic;
		ld		 : out std_logic
	);

	end SelectionSort;
	
	architecture structural of SelectionSort is
		signal cmd: Command;
		signal sts: Status;
	begin
		
	    CONTROL_PATH: entity work.ControlPath
	        port map (
	            clk     => clk,
	            rst     => rst,
	            data_av => data_av,    
	            done    => done,    
	            sel     => sel,
	            ld      => ld,
	            cmd     => cmd,
	            sts     => sts
	    );
	        
	    DATA_PATH: entity work.DataPath(behavioral)
	        generic map (
	            DATA_WIDTH  => DATA_WIDTH
	        )
	        port map (
	            clk         => clk,
	            rst         => rst,
	            cmd         => cmd,
	            sts         => sts,
	            data        => data,
	            data_in     => data_in,
	            addr    	=> addr,
	            data_out    => data_out
	        );
	        
	end structural;
	
	
	
	
	architecture behavioral of SelectionSort is	
		signal regOrder, regStartAddr, regSize            : UNSIGNED(DATA_WIDTH - 1 downto 0);
		signal regI, regJ, regMin, regAux, regAux2        : UNSIGNED(DATA_WIDTH - 1 downto 0);
		type State is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14);
		signal currentState: State;
	begin		 
		process(clk, rst)
		begin	   
			if rst = '1' then
				currentState <= S0;
			elsif rising_edge(clk) then
				case currentState is
					when S0 => 
						regStartAddr <= unsigned(data);
						if data_av = '1' then
							currentState <= S1;
						else
							currentState <= S0;
						end if;	  
					
					when S1 => 
						regSize <= unsigned(regStartAddr) + unsigned(data);
						regI <= unsigned(regStartAddr);
						if data_av = '1' then
							currentState <= S2;
						else
							currentState <= S1;
						end if;	 
					
					when S2 => 
						regOrder <= unsigned(data);
					
						if data_av = '1' then
							currentState <= S3;
						else
							currentState <= S2;
						end if;
					
					when S3 =>
						regMin <= unsigned(regI);
						if regI + 1 < regSize then
							currentState <= S4;
						else
							currentState <= S14; --done
						end if;
						
					when S4	=>
						regJ <= regI + 1;
						currentState <= S5;
						
					when S5 =>
						regAux <= unsigned(data_in);
						if 	regJ < regSize then
							currentState <= S6;
						else
							currentState <= S9;
						end if;			 
						
					 when S6 =>
					 	if (regOrder(0) = '1' and regAux < unsigned(data_in)) or
    						(regOrder(0) = '0' and regAux > unsigned(data_in)) then
							currentState <= S7;
						else
							currentState <= S8;
						end if;	
						
					 when S7 =>
						regMin <= regJ;
						currentState <= S8;	
						
					 when S8 =>
						regJ <= regJ + 1;
						currentState <= S5;
						
					 when S9 =>
						regAux <= unsigned(data_in);
						if regI = regMin then
						   currentState <= S10;
						else
							currentState <= S11; 
						end if;	
						
					 when S10 =>
						regI <= regI + 1;
						currentState <= S3;
						
					 when S11 =>
						regAux2 <= unsigned(data_in);
						currentState <= S12; 
						
					 when S12 =>
					 	currentState <= S13;
					 
					 when S13 => 
					 	currentState <= S10;
					
					when others => --s14
						currentState <= S0;
			
				end case;
			end if;
		end process;
		
		sel <= '1' when currentState = S5 or 
						currentState = S6 or
						currentState = S9 or
						currentState = S11 or
						currentState = S12 or						
						currentState = S13 else '0';
							
		ld <= '1' when currentState = S12 or currentState = S13 else '0';
		
		done <= '1' when currentState = S14 else '0';
					
		process(currentState, regI, regMin, regJ)
	   	begin
	        case currentState is
	            when S5 =>
	                addr <= std_logic_vector(regJ);
	            when S6 | S11 | S13 =>
	                addr <= std_logic_vector(regMin);
	            when S9 | S12 =>
	                addr <= std_logic_vector(regI);
	            when others =>
	                addr <= (others => '0');
	        end case;
	  	end process;	
		  
	    process(currentState, regAux, regAux2)
	    begin
	        case currentState is
	            when S12 =>
	                data_out <= std_logic_vector(regAux2);
	            when S13 =>
	                data_out <= std_logic_vector(regAux);
	            when others =>
	                data_out <= (others => '0');
	        end case;
	    end process;

		
	end behavioral;				  	
		
	
	