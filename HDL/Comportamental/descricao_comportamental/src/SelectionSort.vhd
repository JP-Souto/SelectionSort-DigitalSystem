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
	            data_av   => data_av,    
	            done    => done,    
	            sel      => sel,
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
	            data      => data,
	            data_in     => data_in,
	            addr     => addr,
	            data_out          => data_out
	        );
	        
end structural;