library IEEE;
use IEEE.std_logic_1164.all;
use work.SelectionSort_pkg.all;	
use IEEE.numeric_std.all;

-- Test Bench com estímulos sincronizados com clk
entity ControlPath_tb is
end ControlPath_tb;

architecture behavioral of ControlPath_tb is
	signal rst		: std_logic;
	signal clk		: std_logic := '0';
	signal data_av	: std_logic;
	signal done		: std_logic;  
	signal sel, ld	: std_logic;
	signal sts		: Status;
	signal cmd		: Command;
begin
	
	-- Gerar estímulos (test bench)
	--rst <= '0', '1' after 10ns, '0' after 15ns;
	clk <= not clk after 20ns;			  
	
	CONTROL_PATH: entity work.ControlPath
		port map (
		rst      => rst,
        	clk      => clk,
        	data_av  => data_av,
        	done     => done,
        	sel      => sel,
        	ld       => ld,
        	sts      => sts,
        	cmd      => cmd
		);

process
    begin
 	rst <= '1';
	data_av <= '0';
	sts.lt_size <= '0';
	sts.aux_t_min <= '0';
	sts.i_dt_min <= '0';
        wait until  clk = '1';
        rst <= '0';
        wait until  clk = '1';
        data_av <= '1';
	--s0
        wait until  clk = '1';
	--s1
        wait until  clk = '1';
	--s2
        wait until  clk = '1';
	data_av <= '0';
	sts.lt_size <= '1';
	--s3
	wait until clk = '1';
	--s4
	wait until clk = '1';
	--s5
	wait until clk = '1';
	--s6
	sts.lt_size <= '0';
	sts.aux_t_min <= '1';
	wait until clk = '1';
	--s7
	wait until clk = '1';
	--s8
	wait until clk = '1';
	--s5
	wait until clk = '1';
	sts.aux_t_min <= '0';
	sts.i_dt_min <= '1';
	--s9
	wait until clk = '1';
	--s11
	wait until clk = '1';
	--s12
	wait until clk = '1';
	--s13
	wait until clk = '1';
	--s10
	wait until clk = '1';
	--s3
	wait until clk = '1';
	--s14
	wait until clk = '1';
	--s0

end process;
		
end behavioral;