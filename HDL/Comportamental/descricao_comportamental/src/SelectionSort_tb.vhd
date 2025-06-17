library IEEE;                        
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SelectionSort_tb is
end SelectionSort_tb;

architecture behavioral of SelectionSort_tb is  
   
    constant DATA_WIDTH     : integer := 8;
    constant ADDR_WIDTH     : integer := 8;
    
    signal rst, data_av       : std_logic; 
    signal size, startAddr, order  : std_logic_vector(ADDR_WIDTH-1 downto 0);
    signal clk              : std_logic := '0';
    signal wr1, wr2         : std_logic;   --ld
    signal ce1, ce2         : std_logic;   --sel
    signal up               : std_logic;
    signal done1, done2     : std_logic;
    signal address1, address2    : std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal data				:  std_logic_vector(DATA_WIDTH-1 downto 0); 
    signal bs1_data_in, bs1_data_out : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal bs2_data_in, bs2_data_out : std_logic_vector(DATA_WIDTH-1 downto 0);    


begin

    SelectionSort_STR: entity work.SelectionSort(structural) 
    generic map (
        DATA_WIDTH    => DATA_WIDTH
    )
    port map (
        clk         => clk,
        rst         => rst,
        data_av     => data_av,
        done        => done2,
        data_in     => bs2_data_in,
        data        => data,
        -- Memory interface
        sel         => ce2,
        ld          => wr2,
        data_out     => bs2_data_out,
        addr     => address2
    );
        
    RAM_STR: entity work.Memory
        generic map (
            DATA_WIDTH    => DATA_WIDTH,
            ADDR_WIDTH    => ADDR_WIDTH,
            imageFileName   => "image.txt"
        )
        port map (
            clk       => clk,
            ce          => ce2,
            wr          => wr2,
            data_in     => bs2_data_out,
            data_out    => bs2_data_in,
            address     => address2
        );
		clk <= not clk after 20 ns;    -- 25 MHz
	process
	
    begin
	  report "Testbench - 2, 3, 5, 1 4, order = 1, size = 5";
        rst <= '1';
        wait until  clk = '1';
        wait until  clk = '1';
        rst <= '0';
		data <= (others => '0');
        wait until  clk = '1';
        report "Informando posicao zero na mem�ria para o startAddr";
		data_av <= '1';
		wait until  clk = '1';
		report "informa size = 5";
		data <= "00000101";
		wait until clk = '1';
		report "informa order = 0";
		data <= "00000001";
		wait until clk = '1';
		data_av <= '0';
		
		wait until done1 = '1' or done2 = '1';
		
		
        

    end process;
end behavioral;
